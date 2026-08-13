
# REGISTER → OP HANDOFF CONTRACT

**SSOT — Gia Phả Số 2026 / MEMBER_PROMOTE (Direction A)**

| Field | Value |
|-------|--------|
| Document ID | Register-to-OP-Handoff-Contract-2026-08-13 |
| Version | 1.0.0-FINAL |
| Status | Approved & Frozen for implementation |
| Date | 2026-08-13 |
| Repos | CM-Docs + cmcodes |
| Principles | SSOT + Q1/Q2 |

Tài liệu này là Single Source of Truth cho biên giới và handoff giữa **Register Process (RP)** đã CLOSED và **Onboarding Promote Process (OP / MEMBER_PROMOTE)**. Mọi implementation phải tuân thủ. Không mở lại RP/OP-2 trừ regression có log + repro.

**Đường dẫn đề xuất:** `docs/Onboarding/Register-to-OP-Handoff-Contract-2026-08-13.md`

---

## 1. Phạm vi & nguyên tắc

### 1.1 Phạm vi

- **Trong phạm vi:** điều kiện mở OP, ownership process, correlation, quyền A/B/C, storage tạm, idempotent.
- **Ngoài phạm vi:** FE Elder Support chi tiết, OpenAPI đầy đủ, model `process_instances` (chỉ ghi chú dài hạn), refactor toàn bộ RP sang `member.service`.

### 1.2 Nguyên tắc bất biến

| Nguyên tắc | Nội dung |
|------------|----------|
| RP đóng tại APPROVED | Case Register `status = APPROVED` là terminal của RP. Không UPDATE case RP sang `NEEDS_REVISION` / `SUBMIT` cho OP. |
| OP là process mới | Mỗi lần bắt đầu Promote = process instance mới + `correlation_id` mới. |
| Nhận diện ownership | `process_type` (logic: `MEMBER_PROMOTE`) + `correlation_id` — không chỉ `case.status`. |
| Đầu vào OP | Outcome domain: `members.status = DU_BI` (+ user `DA_DUYET` nếu có user). Không = tiếp tục row case RP. |
| NEEDS_REVISION tách chủ | `NEEDS_REVISION` của RP ≠ `NEEDS_REVISION` của OP (cùng enum status, khác correlation / process). |

---

## 2. Trigger mở OP (đã chốt)

**Tiêu chuẩn nghiệp vụ (một câu):**

> Mỗi khi một `members` row được tạo với `status = DU_BI` → mở một OP instance mới (`correlation_id` mới, row/case OP mới, status khởi tạo = `DRAFT`).

Không phụ thuộc “có đi hết RP hay không”. RP Approve chỉ là **một** nguồn tạo `DU_BI`; Admin thêm người thân, member `CHINH_THUC` tạo gia đình, v.v. dùng **cùng** rule.

### 2.1 Ba lớp quyền (A / B / C)

| Lớp | Việc | Ai |
|-----|------|-----|
| **A. Tạo member DU_BI** | Sinh row `members` | `SYSTEM_ADMIN`, `CLAN_ADMIN`; sau này member `CHINH_THUC` (tạo người thân / nhánh). |
| **B. Mở OP instance** | Row OP mới + C mới | **Hệ thống auto** mỗi khi (A) thành công; User `DA_DUYET` / Admin được **khởi tạo hoặc tiếp tục** nếu chưa có instance mở (idempotent). |
| **C. Vận hành OP** | SAVE_DRAFT / SUBMIT / review / approve | **User gắn member:** tự hoàn thiện BP → SUBMIT. **CLAN_ADMIN / SYSTEM_ADMIN:** hỗ trợ + START_REVIEW / APPROVE / REJECT. |

### 2.2 ContextGuard (action)

| Action | USER (chủ member / user_id case) | CLAN_ADMIN / SYSTEM_ADMIN |
|--------|----------------------------------|---------------------------|
| SAVE_DRAFT, SUBMIT, WITHDRAW | Có (đúng instance của mình) | Có |
| START_REVIEW, RETURN_FOR_REVISION, APPROVE, REJECT | Không | Có |

User `DA_DUYET` khởi tạo/vận hành OP = quyền **B + C (draft/submit)**, không phải quyền APPROVE.

Sau khi member thành `CHINH_THUC`, họ có thể tạo thêm member `DU_BI` (gia đình) → mỗi `DU_BI` mới auto mở OP riêng.

---

## 3. Handoff RP → OP

### 3.1 Khi RP Approve thành công

Hệ thống phải đảm bảo outcome:

| Artifact | Bắt buộc | Ghi chú |
|----------|----------|---------|
| `users.status` | `DA_DUYET` | User đã duyệt |
| `members.status` | `DU_BI` | Member sơ bộ đã tạo |
| Link user ↔ member | Có | Theo quan hệ RP đã UAT |
| Case RP `onboarding_cases` | `APPROVED` (đóng) | Không bắt buộc `primary_member_id` trên case RP; OP **không** đọc field đó từ case RP |
| RP `correlation_id` | Giữ lịch sử | Chỉ để **trace**; OP **không** tái sử dụng |

### 3.2 Hành động bắt buộc sau Approve (implementation ngắn hạn)

```
RP Approve (giữ nguyên luồng đã UAT — Q1)
  → user DA_DUYET + member DU_BI chắc chắn
  → openMemberPromoteInstance({ userId, memberId, tenantId, sourceRegisterCaseId? })
  → row OP mới, status = DRAFT, correlation_id mới, primary_member_id gắn member DU_BI
```

- **Không** bắt buộc refactor toàn bộ RP sang `member.service` trong cùng PR.
- `openMemberPromoteInstance` **chỉ** tạo instance OP — **không** tạo member.

### 3.3 Storage tạm (`onboarding_cases`)

Tạo **row mới** với tối thiểu:

| Field | Giá trị |
|-------|---------|
| `id` | `gen_random_uuid()` |
| `correlation_id` | `gen_random_uuid()` — **MỚI, bắt buộc** |
| `status` | `DRAFT` |
| `case_type` | `MEMBER_JOIN` \| `CLAN_SETUP` (ngữ cảnh tenant/flow) |
| `user_id` | User `DA_DUYET` (nếu có) |
| `primary_member_id` | Member `DU_BI` — **BẮT BUỘC trên case OP** |
| `tenant_id` | Tenant liên quan |
| `metadata` | Xem dưới |

```json
{
  "process_type": "MEMBER_PROMOTE",
  "source": "OP",
  "source_register_case_id": "<id case RP APPROVED | null>",
  "source_register_correlation_id": "<C của RP | null>"
}
```

**Cấm:** `UPDATE` case RP `APPROVED` → `NEEDS_REVISION` để “giả” OP.  
Fixture SQL dev **không** phải production path.

### 3.4 State khởi tạo OP

**v1:** luôn **`DRAFT`** khi auto-open sau create `DU_BI`.  
`SUBMIT` do USER / Admin trên instance đó.

---

## 4. Entry condition & profile (MEMBER_PROMOTE)

- `primary_member_id` có và `members.status = DU_BI`
- Nếu có `user_id` → `users.status = DA_DUYET` (promote gắn tài khoản)
- Member không user (chỉ trong cây): entry nới theo rule Admin-only (definition)
- **Base Profile hard required trước APPROVE:** `full_name`, `gender`, `is_alive`, `birth_year`, `birth_month`, `birth_day`
- **generation:** bắt buộc ≥ 1 với `CLAN_SETUP`; strongly recommended (warn) với `MEMBER_JOIN`
- `father_id` / `mother_id`: optional
- **Side-effect APPROVED:** `members.status = CHINH_THUC`; **không** auto `CLAN_ADMIN`; **không** auto tenant `HOAT_DONG`

---

## 5. Correlation, BPL, Communication

| Hạng mục | Rule |
|----------|------|
| Root OP instance | `onboarding_cases.correlation_id` = C mở process |
| Mỗi action quan trọng (trừ SAVE_DRAFT) | Một correlation mới (SRPF); ghi BPL |
| Trace về RP | `metadata.source_register_*` + BPL metadata — không reuse C RP |
| Notification `event_type` | Map `MEMBER_PROMOTE_*` → enum `ONBOARDING_*` (`ONBOARDING_SUBMITTED`, …) |
| Communication | After-commit; `silentEmit`; failure không phá business TX |
| `audit_logs.action` | `THEM_MOI` \| `CAP_NHAT` \| `XOA` (không dùng tên SRPF action) |
| audit `changed_by` | Chỉ UUID `users.id` hợp lệ (tránh FK abort TX) |

---

## 6. member.service (hướng dài hạn, không chặn handoff)

**Ngắn hạn:** RP Approve += `openMemberPromoteInstance`.

**Dài hạn — một cổng `createDuBiMember`:**

1. Force `members.status = DU_BI` (không tạo `CHINH_THUC` trực tiếp)
2. Tenant `HOAT_DONG` cho luồng thường (JOIN / family)
3. Exception: tenant `TAM_NGUNG` + context `CLAN_SETUP` founder
4. Sau insert member → `openMemberPromoteInstance` (idempotent)

RP / Admin / `CHINH_THUC` dần gọi service này; **không** big-bang refactor RP trong phase handoff.

---

## 7. Idempotent

Một member `DU_BI` **tối đa một** OP instance đang mở (status không terminal).  
Retry Approve / tạo trùng **không** nhân đôi case.

**Key gợi ý:**

```text
(tenant_id, primary_member_id, metadata.process_type = MEMBER_PROMOTE,
 status ∉ { APPROVED, REJECTED, CANCELLED, EXPIRED })
```

---

## 8. Boundary — không làm

- Không reopen case RP `APPROVED` / `REJECTED` / `CANCELLED` cho OP
- Không dùng SQL fixture `UPDATE status` case RP như production path
- Không auto gán `CLAN_ADMIN` khi promote
- Không auto `tenant.status = HOAT_DONG` (CLAN_SETUP: Admin tự quyết)
- Không bắt buộc model `process_instances` trong phase này (note dài hạn trong Architecture SRPF)
- Không dời engine SRPF sang `modules/onboarding` ngay; definition + open instance chuyển **sau** lát cắt OP ổn

---

## 9. Vòng đời tóm tắt

```text
RP Approve
  → user DA_DUYET + member DU_BI
  → auto open OP instance (DRAFT, C mới, primary_member_id)
  → USER hoàn thiện BP → SUBMIT
  → Admin START_REVIEW → APPROVE | REJECT | RETURN_FOR_REVISION
  → APPROVE: member CHINH_THUC
  → (sau) CHINH_THUC tạo thêm DU_BI → mỗi người một OP mới
```

---

## 10. Deliverable implementation (thứ tự)

| # | Việc | Ghi chú |
|---|------|---------|
| **C1** | Document này (SSOT) | Approved & Frozen v1.0 |
| **C2** | `openMemberPromoteInstance(...)` | Tạo row + C mới; idempotent |
| **C3** | Gọi từ RP Approve (+ điểm create DU_BI khi sẵn sàng) | Q1: không phá RP UAT |
| **C4** | Test: open OP rồi SUBMIT (không reset case RP) | Thay fixture giả NEEDS_REVISION trên case RP |
| **C5** | E2E APPROVE → CHINH_THUC | Khi BP đủ |
| **C6** | Move definition + open service → `modules/onboarding` | Sau lát cắt ổn — không làm ngay |

---

## 11. Tham chiếu

- Standard-Revision-Process-Framework-SRPF-v1.0-Final (CM-Docs)
- SRPF-Architecture-Overview-Pseudo-code-v1.1
- OP-Boundary-Definition-SSOT-2026-08-09
- HandOver-Register-Process-Closure-2026-08-10 (RP + OP-2 CLOSED)
- Code: `src/shared/frameworks/srpf` (engine); `MemberPromote.definition.js`

---

## 12. Phê duyệt

| Hạng mục | Giá trị |
|----------|---------|
| Status | **Approved & Frozen v1.0.0** — đủ để implementation C2+ |
| Ngày | 2026-08-13 |
| Nguyên tắc | SSOT + Q1 (bảo toàn RP) + Q2 (doc-first) |
| Thay đổi sau freeze | Chỉ qua amendment có version + lý do; không sửa âm thầm |

---

*End of Register-to-OP-Handoff-Contract v1.0.0-FINAL*

