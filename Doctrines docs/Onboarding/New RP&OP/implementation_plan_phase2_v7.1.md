# IMPLEMENTATION PLAN CHI TIẾT v7.1 (FINAL POLISHED)

* **Dự án:** New RP&OP — Phase 2 (RPAP & Ledgers)
* **Tài liệu tham chiếu:** `AMEND-RP-OP-2026-03-BASELINE (v7.0 FROZEN)`
* **Phiên bản kế hoạch:** `v7.1 (Final Polished / Ready for Sprint 1)`
* **Ngày phê chuẩn:** `18/11/2026`
* **Trạng thái:** `FROZEN / READY FOR SPRINT 1 KICKOFF`

## TỔNG QUAN & NGUYÊN TẮC THỰC THI

Kế hoạch này cụ thể hóa tài liệu Baseline v7.0 thành các gói công việc kỹ thuật, duy trì ma trận truy vết xuyên suốt bằng các mã định danh `[REQ-ID]`. Mã giả (pseudo-code) được cung cấp tại các điểm nhạy cảm để ngăn chặn rủi ro tự diễn giải sai hợp đồng kỹ thuật và transaction.

---

## SPRINT 1: DATABASE & FOUNDATION (BACKEND)

### Task 1.1 – Prisma Migration & Cấu trúc Metadata `[ARCH-05]`, `[ARCH-06]`

**Mục tiêu:** Bổ sung cột, composite FK, 6 indexes và định nghĩa JSON Interface chuẩn.
**File:** `prisma/schema.prisma`, `src/types/metadata.type.ts`

**1. Định nghĩa Interface dùng chung (FE/BE):**
```typescript
// src/types/metadata.type.ts
export interface OnboardingCaseMetadata {
  staging_cleanup?: {
    cleanup_status: 'PENDING' | 'CLEANED' | 'FAILED';
    prefix: string;
  };
  offline_verifications?: Array<{
    id: string;
    endorser_name: string;
    call_status: 'VERIFIED' | 'UNREACHABLE';
    notes?: string;
  }>;
  referral_history?: Array<{
    referrer_id: string;
    status: 'DECLINED';
    decided_at: string;
  }>;
}
```

**2. Prisma Schema:**
```prisma
model onboarding_cases {
  // ... (Các cột cơ bản)
  metadata Json @default("{}") // [ARCH-06] Lưu trữ theo OnboardingCaseMetadata interface

  // [NFR-03] Index phục vụ Claim-Hopping 90 ngày (Cần query ĐÚNG thứ tự cột này)
  @@index([user_id, tenant_id, claim_mode, status, reopenable, updated_at], map: "idx_onboarding_claim_hopping")
}

model profile_edit_grants {
  // [ARCH-05] Chuẩn bị DROP NOT NULL qua raw SQL
  grantee_member_id String? @db.VarChar(36) 
  grantee_user_id   String? @db.VarChar(36)
}
```

### Task 1.2 – SQL Migration (Constraints & `DROP NOT NULL`) `[ARCH-05]`

```sql
-- 1. DROP NOT NULL & XOR 
ALTER TABLE profile_edit_grants
  ALTER COLUMN grantee_member_id DROP NOT NULL,
  ADD CONSTRAINT chk_peg_grantee_xor CHECK (
    (grantee_member_id IS NOT NULL AND grantee_user_id IS NULL) OR
    (grantee_member_id IS NULL AND grantee_user_id IS NOT NULL)
  );

-- 2. Constraints & Length
ALTER TABLE onboarding_cases
  ADD CONSTRAINT chk_agreed_rules_snapshot_length CHECK (agreed_rules_snapshot IS NULL OR char_length(agreed_rules_snapshot) <= 30000);
```

### Task 1.3 & 1.4 – Cô Lập Legacy & Lọc `is_clan` `[ARCH-02]`, `[ARCH-03]`

* Quét Regex chặn mọi thao tác gọi trực tiếp `users.member_id` / `users.tenant_id`. Bật ESLint `no-restricted-syntax`.
* Xóa điều kiện lọc `is_clan = true` khỏi các repository tìm kiếm Claim và Referrer.

---

## SPRINT 2: CORE BUSINESS LOGIC & CONCURRENCY (BACKEND)

### Task 2.1 – `OnboardingStateMachineService` & Token Invalidation `[FUNC-04]`, `[FUNC-10]`

* **Đồng bộ vô hiệu hóa Token (`[FUNC-10]`):** Khi State Machine chuyển case sang `APPROVED`, `REJECTED`, `CANCELLED`, `EXPIRED`, bắt buộc vô hiệu hóa toàn bộ Token đồng bộ trong transaction:
```typescript
await tx.onboarding_cases.update({
  where: { id: caseId },
  data: {
    status: newState,
    beneficiary_token_hash: null, // Hủy token proxy
    referral_token_hash: null,    // Hủy token bảo lãnh
    // ... clear OTP tokens
  }
});
```

### Task 2.2 – `OnboardingLockService` (Strict Lock) `[ARCH-04]`, `[FUNC-05]`, `[FUNC-08]`

**File:** `src/modules/onboarding/services/onboarding-lock.service.ts`

```typescript
export class OnboardingLockService {
  async executeWithStrictLock<T>(
    prisma: PrismaClient,
    params: { caseId: string; targetMemberId: string | null; lockUserId: string | null },
    work: (tx: Prisma.TransactionClient, lockCtx: { shouldBeDefault: boolean }) => Promise<T>,
  ): Promise<T> {
    try {
      return await prisma.$transaction(async (tx) => {
        await tx.$executeRaw`SET LOCAL lock_timeout = '5s'`;

        // 1. Lock Node
        if (params.targetMemberId) {
          await tx.$queryRaw`SELECT id FROM members WHERE id = ${params.targetMemberId} FOR UPDATE`;
          // Kiểm tra Active link tại đây...
        }

        // 2 & 3. Lock User & Toàn bộ Links (Tính is_default)
        let shouldBeDefault = false;
        if (params.lockUserId) {
          await tx.$queryRaw`SELECT id FROM users WHERE id = ${params.lockUserId} FOR UPDATE`;
          await tx.$queryRaw`SELECT id FROM user_member_links WHERE user_id = ${params.lockUserId} ORDER BY id ASC FOR UPDATE`;
          
          const defaultCount = await tx.user_member_links.count({
            where: { user_id: params.lockUserId, status: 'DA_DUYET', is_default: true, deleted_at: null },
          });
          shouldBeDefault = defaultCount === 0;
        }

        // 4. Lock Case(s)
        if (params.targetMemberId) {
          await tx.$queryRaw`SELECT id FROM onboarding_cases WHERE primary_member_id = ${params.targetMemberId} ORDER BY id ASC FOR UPDATE`;
        } else {
          await tx.$queryRaw`SELECT id FROM onboarding_cases WHERE id = ${params.caseId} FOR UPDATE`;
        }

        // [FUNC-08]: Log Business Process CHỈ ĐƯỢC GHI sau khi lock thành công ở bước 4 này
        
        return await work(tx, { shouldBeDefault });
      });
    } catch (err: any) {
      if (err?.meta?.code === '55P03' || err?.code === '55P03') throw new ConflictException('CONCURRENT_TRANSACTION_LOCKED');
      throw err;
    }
  }
}
```

### Task 2.3 – `MembershipLinkService` (Raw UPSERT & Cascade) `[FUNC-06]`, `[FUNC-07]`

**File:** `src/modules/membership/services/membership-link.service.ts`

**1. Bắt buộc dùng Raw SQL để bypass Soft-delete Middleware (`[FUNC-06]`):**
```typescript
async upsertLink(tx: Prisma.TransactionClient, params: UpsertLinkParams) {
  const rows = await tx.$queryRaw<{ id: string }[]>`
    SELECT id FROM user_member_links WHERE user_id = ${params.userId} AND tenant_id = ${params.tenantId} LIMIT 1
  `;
  if (rows.length > 0) {
    await tx.$executeRaw`
      UPDATE user_member_links 
      SET member_id = ${params.memberId},
          link_type = ${params.linkType}::member_link_type,
          role_in_tenant = ${params.roleInTenant},
          status = 'DA_DUYET', 
          is_default = ${params.isDefault},
          deleted_at = NULL,
          updated_at = NOW()
      WHERE id = ${rows[0].id}
    `;
    return { id: rows[0].id };
  }
  return tx.user_member_links.create({ /* ... */ });
}
```

**2. Thu hồi GUARDIAN khi EU Claim (`[FUNC-07]`):**
```typescript
async revokeGuardianOnEuClaim(tx: Prisma.TransactionClient, tenantId: string, targetMemberId: string) {
  // Thu hồi quyền sửa profile
  await tx.profile_edit_grants.updateMany({
    where: { target_member_id: targetMemberId, status: 'HIEU_LUC' },
    data: { status: 'THU_HOI', revoked_at: new Date() },
  });
  // Xóa mềm link GUARDIAN
  await tx.user_member_links.updateMany({
    where: { tenant_id: tenantId, member_id: targetMemberId, link_type: 'GUARDIAN', deleted_at: null },
    data: { status: 'HUY_LIEN_KET', deleted_at: new Date() },
  });
}
```

### Task 2.4 – Xử lý Ngoại lệ Referrer Qua Đời `[FUNC-02]`

**Logic chèn vào quá trình `ONBOARDING_APPROVE` (Chú ý không ném Exception bên trong Transaction):**
```typescript
const referrer = await tx.members.findUnique({ where: { id: caseData.referrer_member_id } });
if (!referrer || !referrer.is_alive) {
  // 1. Cập nhật case về Needs Revision và hủy token
  await tx.onboarding_cases.update({
    where: { id: caseId },
    data: { status: 'NEEDS_REVISION', revision_reason: 'REFERRER', referral_token_hash: null } 
  });
  // 2. Ghi log & Notification
  await tx.business_process_logs.create({ data: { type: 'ONBOARDING_REVISION_REQUEST', /*...*/ }});
  await tx.notifications.create({ data: { type: 'ONBOARDING_REVISION_REQUESTED', /*...*/ }});
  
  // 3. RETURN object thất bại để Transaction được COMMIT (lưu lại trạng thái Needs Revision).
  // KHÔNG dùng "throw new Error()" ở đây vì Prisma sẽ rollback toàn bộ việc ghi log và update.
  return { success: false, reason: 'REFERRER_DECEASED' };
}
```
*Tầng Controller sau khi nhận `{ success: false, reason: 'REFERRER_DECEASED' }` sẽ tiến hành ném `HTTP 400 BadRequestException` ra Client.*

---

## SPRINT 3: FRONTEND INTEGRATION & PROACTIVE DEFENSE

### Task 3.1 – Logic-Tier Rate-Limiter `[NFR-02]`
* Public Search: Ngắt Redis $\rightarrow$ Chặn bằng Turnstile.
* In-App Search: Ngắt Redis $\rightarrow$ Fallback `LRUCache`.

### Task 3.2 – Limiters: Claim-Hopping & Cooldown `[FUNC-03]`, `[FUNC-09]`, `[NFR-03]`

* **Khóa QA (`[FUNC-03]`):** Logic cập nhật `qa_locked = true` nếu nhập sai 3 lần.
* **Cooldown 7 ngày (`[FUNC-09]`):** Chặn nộp form bảo lãnh nếu referrer ID tồn tại trong `metadata.referral_history` với `status = DECLINED` cách đây $< 7$ ngày.
* **Ngắt mạch Claim Hopping (`[NFR-03]`):** Service layer bắt buộc validate trước khi tạo case `CLAIM_EXISTING`:
```typescript
// BẮT BUỘC query ĐÚNG THỨ TỰ CỘT INDEX
const rejectedCount = await prisma.onboarding_cases.count({
  where: {
    user_id: userId, tenant_id: tenantId, claim_mode: 'CLAIM_EXISTING', status: 'REJECTED', reopenable: false,
    updated_at: { gte: ninetyDaysAgo } // Lấy mốc 90 ngày
  }
});
if (rejectedCount >= 2) throw new ForbiddenException('CLAIM_HOPPING_DETECTED');
```

---

## SPRINT 4: ASYNC, CLEANUP & QA

### Task 4.1 – Staging Cleanup Worker `[FUNC-05]`
* Cronjob/Worker quét `metadata.staging_cleanup.cleanup_status = PENDING`. Xóa S3 Idempotent (Bắt `NoSuchKey`).

### Task 4.3 – Test Cases Nghiệm Thu (Khớp với Baseline v7.0)

 1. **AC1 (`[ARCH-04]`, `[FUNC-05]`):** Đánh đồng thời 3 request $\rightarrow$ 409, `is_default` chuẩn.
 2. **AC2 (`[FUNC-07]`):** Thu hồi quyền Guardian phải xóa sạch grants đồng bộ.
 3. **AC3 (`[NFR-01]`, `[FUNC-08]`):** Idempotency của Magic Link.
 4. **AC4 (`[ARCH-06]`):** Chặn duyệt `CLAN_SETUP` nếu thiếu metadata offline.
 5. **AC5 (`[NFR-02]`):** Ngắt Redis test Fallback In-App vs Public.
 6. **AC6 (`[ARCH-01]`, `[ARCH-03]`):** Lát 0 - không lọt data sang phả đồ khi chưa duyệt.
 7. **AC7 (`[ARCH-05]`, `[FUNC-06]`):** Check XOR constraint DB và UPSERT đè lên dòng soft-deleted.
 8. **AC8 (`[FUNC-09]`):** Gửi lại bảo lãnh sau 2 ngày bị reject $\rightarrow$ 400.
 9. **AC9 (`[FUNC-10]`):** Bấm link OTP/Proxy của case đã bị Hủy $\rightarrow$ 410 Gone.
10. **AC10 (`[FUNC-03]`):** Trả lời sai QA 3 lần $\rightarrow$ bị khóa `qa_locked = true`.
11. **AC11 (`[NFR-03]`):** Nhồi 2 case bị khóa vĩnh viễn, tạo case 3 $\rightarrow$ 403 (Claim Hopping).

---

## KNOWN RISKS & IMPLEMENTATION GUARDRAILS

| Hạng mục Guardrail | Yêu cầu Kỹ thuật (Mã) | 
| ----- | ----- | 
| **Bảo vệ Query Planner** | `[NFR-03]` Bắt buộc gọi 6 cột đúng thứ tự của `idx_onboarding_claim_hopping` trong Prisma `where`. | 
| **Namespace JSON** | `[ARCH-06]` Sử dụng chặt chẽ Interface `OnboardingCaseMetadata`. Tuyệt đối không thêm key rác ở root. | 
| **Bypass Middleware** | `[FUNC-06]` `upsertLink` phải dùng raw SQL. Prisma `findUnique` sẽ bỏ qua dòng có `deleted_at != null`. | 
| **Exception trong Transaction** | `[FUNC-02]` **CẤM** ném Exception (`throw new Error`) bên trong `$transaction` nếu nghiệp vụ yêu cầu lưu lại trạng thái trung gian (như `NEEDS_REVISION`). Phải return object báo lỗi và để Controller ném ra HTTP Error. | 