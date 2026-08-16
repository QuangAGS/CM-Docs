# HandOver — RP Completion: process_kind + BPL Semantic

**PATH**       : CM-Docs / RP / HandOver-RP-process-kind-BPL-2026-08-16.md  
**DATETIME**   : 2026-08-16T16:25:00+07:00  
**VERSION**    : 1.0.0  
**STATUS**     : APPROVED (implementation PASS on live test)  
**REPOS**      : QuangAGS/cmcodes · CM-Docs  
**SSOT + Q1/Q2**

---

## 1. Bối cảnh

Sau **HandOver-Close-C6** (OP-A MEMBER_PROMOTE E2E PASS):

- RP (Register Process) và OP (MEMBER_PROMOTE) **cùng bảng** `onboarding_cases`.
- Cùng `case_type` (`MEMBER_JOIN` | `CLAN_SETUP`) → dễ lẫn khi query “case đang mở”.
- BPL `USER_APPROVAL` bị **BusinessLogSchemas** whitelist hẹp → mọi action Admin nhìn như “Phê duyệt tài khoản thành công”.
- Revision submit ghi nhầm `USER_REGISTER` (payload rỗng).

**Mục tiêu phase:** hoàn thiện **quan sát & tách RP** trước khi mở rộng OP/FE; **không** đổi state machine OP đã PASS.

---

## 2. Phạm vi đã làm

| PR | Tên | Nội dung | Status |
|----|-----|----------|--------|
| **PR-1** | `process_kind` | Cột + enum + backfill + write/read filter | **PASS** |
| **PR-2** | BPL semantic | Mở schema `USER_APPROVAL` + revision ≠ REGISTER | **PASS** |
| **PR-2.1** | `case_id` on Approve/Reject | Payload BPL gắn case RP vừa đóng | **PASS** |

**Ngoài phạm vi phase này**

- Enum BPL `RP_*` mới trên DB
- Tách bảng `process_instances`
- FE Admin timeline
- Đổi OP SRPF / C6 behavior

---

## 3. PR-1 — `process_kind` (tách RP / OP trên case)

### 3.1 Schema

```prisma
enum onboarding_process_kind {
  REGISTER        /// RP: đăng ký / identity / reopen
  MEMBER_PROMOTE  /// OP: DU_BI → CHINH_THUC (SRPF)
}

model onboarding_cases {
  // ... existing fields ...
  process_kind onboarding_process_kind @default(REGISTER)
  // ...
  @@index([user_id, process_kind, status], map: "idx_onboarding_user_kind_status")
}
```

### 3.2 Quy ước

| Process | `process_kind` | Ghi chú |
|---------|----------------|---------|
| RP (register, reopen case) | `REGISTER` | `case_type` vẫn JOIN/SETUP |
| OP (MEMBER_PROMOTE) | `MEMBER_PROMOTE` | Metadata OP giữ `process_type` / `source: OP` |

**Không** nhân đôi bắt buộc `process_kind` vào `metadata` (cột là SSOT).  
**Không** ảnh hưởng bắt buộc tới `audit_logs` (audit tin `old_data`/`new_data` caller truyền; có thể bổ sung snapshot sau).

### 3.3 Write path

| Hàm | Gán |
|-----|-----|
| `onboardingService.createCaseFromRegister` | `REGISTER` |
| `openMemberPromoteInstance` (create) | `MEMBER_PROMOTE` |

`updateCaseStatus` **không** đổi `process_kind` (kind cố định theo đời case).

### 3.4 Read path (RP)

Mọi `findFirst` open/rejected **RP** trong `auth.service` + `findOpenCaseByUser`:

```text
process_kind = REGISTER
+ status open:
  DRAFT | PROFILE_COMPLETED | FAMILY_TREE_DRAFT |
  SUBMITTED | UNDER_REVIEW | NEEDS_REVISION
```

**Lưu ý status list**

- `PROFILE_COMPLETED` / `FAMILY_TREE_DRAFT` = status **RP/legacy open**, **không** mô tả OP.
- OP thực tế dùng chủ yếu `DRAFT | SUBMITTED | UNDER_REVIEW | NEEDS_REVISION | APPROVED | REJECTED | …`.
- Tách OP nhờ **`process_kind`**, không nhờ việc OP không dùng hai status legacy.

**Chỗ đã filter (auth / onboarding service)**

- Login `CHO_DUYET` — open case
- `findOpenCaseByUser`
- `processUserApproval` — open case + `rpCase` APPROVED (handoff OP)
- `returnForRevision` — open case
- Revision submit — open case
- `reopenRejectedUser` — last REJECTED case
- `markFinalRejection` / list `isFinalRejection` — REJECTED case

### 3.5 Backfill (đã chạy)

```sql
UPDATE onboarding_cases
SET process_kind = 'MEMBER_PROMOTE'
WHERE deleted_at IS NULL
  AND (
    metadata->>'process_type' = 'MEMBER_PROMOTE'
    OR metadata->>'source' = 'OP'
  );
```

**Verify**

```sql
SELECT process_kind, count(*)
FROM onboarding_cases
WHERE deleted_at IS NULL
GROUP BY 1;
```

Kết quả mẫu sau migrate: REGISTER và MEMBER_PROMOTE đều > 0; mọi case OP = `MEMBER_PROMOTE`.

---

## 4. PR-2 — BPL semantic (`USER_APPROVAL`)

### 4.1 Root cause

`ledger.service` → `BusinessLogSchemas[process_type](payload)` **strip** field ngoài whitelist.

- `USER_APPROVAL` cũ chỉ giữ: `approved_role`, `approver_note`, `attempt_no`
- Default note: `"Phê duyệt tài khoản thành công"` khi thiếu `approver_note`
- Caller đã truyền `action`, `admin_note`, `status_before` / `status_after`, `is_final`… → **bị mất**
- Revision submit dùng `process_type: USER_REGISTER` trong khi payload chỉ có `action` / `case_id` → schema REGISTER chỉ giữ email/phone/… → **REGISTER rỗng**

### 4.2 Contract mới `USER_APPROVAL`

**File:** `Backend/src/services/businessLogSchemas.js`  
**VERSION gợi ý:** `1.1.0-PR2-bpl-semantic`

**`action` hợp lệ (convention, không enum DB):**

- `APPROVE`
- `REJECT`
- `FINAL_REJECT`
- `RETURN_FOR_REVISION`
- `REOPEN_REJECTED`
- `REVISION_SUBMIT`

**Fields giữ trong payload sau sanitize:**

| Field | Ý nghĩa |
|-------|---------|
| `action` | Hành động RP identity |
| `approver_note` / `admin_note` | Note gốc; map `admin_note` → `approver_note` |
| `status_before` / `status_after` | `users.status` |
| `is_final` | Reject lần cuối |
| `case_id` | Case RP liên quan (nếu có) |
| `case_status_after` | Status case sau action (nếu có) |
| `new_case_id` | Case mới khi reopen |
| `approved_role` | Tương thích cũ (mặc định `USER`) |
| `attempt_no` | Số lần USER_APPROVAL theo target |

**Quy tắc note**

- Default `"Phê duyệt tài khoản thành công"` **chỉ** khi `action === 'APPROVE'` và caller không gửi note.
- REJECT / RETURN / REOPEN / REVISION **không** bị ghi đè câu phê duyệt mặc định.

**`USER_REGISTER`:** không đổi — **chỉ** đăng ký thật (email/phone/`registered_via`/`temp_full_name`).

### 4.3 Caller paths

| Hàm | process_type | action |
|-----|--------------|--------|
| Register post-TX | `USER_REGISTER` + `ONBOARDING_CASE_CREATE` | — |
| `returnForRevision` | `USER_APPROVAL` | `RETURN_FOR_REVISION` |
| Revision submit | `USER_APPROVAL` | `REVISION_SUBMIT` |
| `processUserApproval` TU_CHOI | `USER_APPROVAL` | `REJECT` / `FINAL_REJECT` |
| `reopenRejectedUser` | `USER_APPROVAL` | `REOPEN_REJECTED` |
| `processUserApproval` DA_DUYET | `USER_APPROVAL` | `APPROVE` |

### 4.4 Revision submit (thay đổi quan trọng)

**File:** `src/modules/auth/auth.service.js` (hàm revision submit)

- Đổi `process_type` từ `USER_REGISTER` → **`USER_APPROVAL`**
- Payload: `action: REVISION_SUBMIT`, `case_id`, `status_before/after: CHO_DUYET`, `case_status_after: SUBMITTED` (khi case từ NEEDS_REVISION → SUBMITTED)

### 4.5 Evidence (live test)

User mới, flow đủ bước: REGISTER → RETURN_FOR_REVISION → REVISION_SUBMIT → REJECT → REOPEN_REJECTED → REVISION_SUBMIT → APPROVE.

- Mỗi bước Admin/NU = **C-action** riêng
- Note Admin đúng trên BPL
- **0** dòng `USER_REGISTER` phụ giữa flow

---

## 5. PR-2.1 — `case_id` trên Approve / Reject

### 5.1 Bản chất

Làm giàu ledger: sự kiện Approve/Reject đã ghi đúng **user status** + **action**; bổ sung **case RP nào vừa bị đóng**.

- **Không** đổi correlation model
- **Không** đổi state machine user/case
- **Không** đổi OP handoff

### 5.2 Kỹ thuật

Trong `processUserApproval` (cùng TX):

1. Khai báo `affectedCaseId`, `caseStatusAfter` **ngoài** block update case (tránh mất scope).
2. Khi tìm thấy open case `process_kind = REGISTER` và update:
   - `affectedCaseId = openCase.id`
   - `caseStatusAfter = 'APPROVED' | 'REJECTED'`
3. Payload BPL:

```text
case_id            = affectedCaseId
case_status_after  = caseStatusAfter
```

Schema PR-2 đã whitelist hai field này — **không** cần sửa schema thêm cho PR-2.1.

### 5.3 Quy ước đọc payload theo action

| action | case_id | new_case_id | case_status_after |
|--------|---------|-------------|-------------------|
| `RETURN_FOR_REVISION` | case đang mở | null | `NEEDS_REVISION` |
| `REVISION_SUBMIT` | case đang mở | null | `SUBMITTED` |
| `REJECT` / `FINAL_REJECT` | case vừa đóng | null | `REJECTED` |
| `REOPEN_REJECTED` | null (cố ý) | case **mới** | null (optional sau) |
| `APPROVE` | case vừa đóng | null | `APPROVED` |

**REOPEN:** tham chiếu case mới qua `new_case_id`, không qua `case_id` của case cũ đã REJECTED.

### 5.4 Evidence (live test)

| action | case_id | case_status_after |
|--------|---------|-------------------|
| REJECT | UUID case₁ | REJECTED |
| APPROVE | UUID case₂ (sau reopen) | APPROVED |
| REVISION_SUBMIT | UUID case đang mở | SUBMITTED |
| REOPEN_REJECTED | null | null (đúng thiết kế; có `new_case_id`) |

---

## 6. Nguyên tắc Correlation (C) — RP

| Loại | Lưu tại | Ý nghĩa |
|------|---------|---------|
| **C-root** | `onboarding_cases.correlation_id` | Một đời **một case** |
| **C-action** | `business_process_logs`, audit, notif | Một **hành động** nghiệp vụ |

### Quy tắc cứng

1. Case giữ C-root; action không ghi đè C-root case.
2. Reopen → **case mới** + C-root mới; case cũ giữ `REJECTED`.
3. Approve RP → C-action `USER_APPROVAL`; OP mở bằng **C_op** riêng + `process_kind = MEMBER_PROMOTE`.
4. RP reject **không** dùng `process_type = ONBOARDING_REJECT` (path onboarding/OP/SRPF).
5. Không query case bằng C-action; không expect mọi BPL trùng C-root case.

### Sơ đồ 7 bước MEMBER_JOIN / CLAN_SETUP (RP)

```text
Step1 Register          C₁ = C-root Case₁
                        BPL: USER_REGISTER + ONBOARDING_CASE_CREATE @ C₁

Step2 Return revision   C₂ = C-action
                        Case₁ → NEEDS_REVISION (vẫn C₁)
                        BPL: USER_APPROVAL / RETURN_FOR_REVISION @ C₂

Step3 NU bổ sung        C₃ = C-action
                        Case₁ → SUBMITTED
                        BPL: USER_APPROVAL / REVISION_SUBMIT @ C₃

Step4 Reject            C₄ = C-action
                        User → TU_CHOI; Case₁ → REJECTED
                        BPL: USER_APPROVAL / REJECT @ C₄ (+ case_id)

Step5 Reopen            C₅ = C-action (+ thường = C-root Case₂)
                        Case₁ giữ REJECTED; Case₂ mới NEEDS_REVISION
                        BPL: USER_APPROVAL / REOPEN_REJECTED @ C₅ (+ new_case_id)

Step6 NU sửa lại        C₆ = C-action
                        Case₂ → SUBMITTED
                        BPL: USER_APPROVAL / REVISION_SUBMIT @ C₆

Step7 Approve           C₇ = C-action
                        User → DA_DUYET; Case₂ → APPROVED; Member DU_BI
                        BPL: USER_APPROVAL / APPROVE @ C₇ (+ case_id)
                        + C_op = root Case OP (MEMBER_PROMOTE DRAFT)
```

---

## 7. SQL checklist vận hành

### 7.1 Cases theo user

```sql
SELECT id, process_kind, case_type, status, correlation_id, metadata,
       created_at, rejected_at, approved_at
FROM onboarding_cases
WHERE user_id = '<USER_ID>'
ORDER BY created_at;
```

### 7.2 BPL RP identity (register + approval)

```sql
SELECT correlation_id, process_type, actor_id, created_at,
       metadata->'payload' AS payload
FROM business_process_logs
WHERE metadata::text ILIKE '%<USER_ID>%'
  AND process_type IN ('USER_REGISTER', 'ONBOARDING_CASE_CREATE', 'USER_APPROVAL')
ORDER BY created_at;
```

### 7.3 Approve / Reject — case_id

```sql
SELECT created_at,
       metadata->'payload'->>'action' AS action,
       metadata->'payload'->>'case_id' AS case_id,
       metadata->'payload'->>'case_status_after' AS case_status_after,
       metadata->'payload'->>'new_case_id' AS new_case_id,
       metadata->'payload'->>'admin_note' AS note
FROM business_process_logs
WHERE process_type = 'USER_APPROVAL'
  AND metadata::text ILIKE '%<USER_ID>%'
ORDER BY created_at DESC;
```

### 7.4 Phân bố process_kind

```sql
SELECT process_kind, count(*)
FROM onboarding_cases
WHERE deleted_at IS NULL
GROUP BY 1;
```

---

## 8. File đã chạm (cmcodes)

| File | PR |
|------|-----|
| `Backend/schema.prisma` | PR-1 (`onboarding_process_kind`, cột, index) |
| Migration + backfill DB | PR-1 |
| `src/services/onboarding.service.js` | PR-1 create + `findOpenCaseByUser` |
| `src/modules/onboarding/srpf/services/openMemberPromoteInstance.js` | PR-1 create (+ optional findOpenOp) |
| `src/modules/auth/auth.service.js` | PR-1 filters; PR-2 revision; PR-2.1 case_id |
| `src/services/businessLogSchemas.js` | PR-2 `USER_APPROVAL` whitelist |

---

## 9. DoD tổng phase

- [x] Case RP / OP tách bằng `process_kind`
- [x] Query RP không trả OP DRAFT
- [x] BPL đọc được `action` từng bước 7-flow
- [x] Không còn `USER_REGISTER` giả khi revision
- [x] Approve/Reject BPL có `case_id` + `case_status_after`
- [x] OP C6 path không bị phá (Q1)
- [x] Evidence SQL live test PASS

---

## 10. Việc tiếp (gợi ý — chưa thuộc phase này)

1. Optional: REOPEN payload thêm `case_status_after: 'NEEDS_REVISION'` (đối xứng đọc; `new_case_id` đã đủ).
2. Công bố doc này trên CM-Docs / GitHub Pages; link HandOver-Close-C6.
3. Admin UI / queue: filter `process_kind = REGISTER` vs OP.
4. Dài hạn: `process_instances` tách storage OP khỏi hồ sơ đăng ký.
5. Optional: enum BPL `RP_*` nếu muốn filter thuần `process_type` không đọc payload.

---

## 11. Liên kết

- HandOver-Close-C6-2026-08-15 (OP-A E2E PASS)
- Register-to-OP Contract / `openMemberPromoteInstance`
- SRPF engine: `shared/frameworks/srpf`
- OP realization: `modules/onboarding/srpf`

---

## 12. Kết luận

Phase RP từ nhu cầu P0 (quan sát C / hết nhầm case) đến **PR-1 + PR-2 + PR-2.1** đã:

1. Tách discriminator **case** (`process_kind`) khi RP và OP chung bảng.
2. Khôi phục **semantic BPL** identity (action + note + status + case ref).
3. Giữ nguyên mô hình **C-root / C-action** và Q1 đối với OP đã đóng C6.

Tài liệu này là **SSOT vận hành + đối soát** cho ledger RP sau 2026-08-16.
```
