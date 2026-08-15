
# HANDOFF REPORT — C6

**OP Realization Move → `modules/onboarding/srpf` + Correlation Control Map (C)**

| Field | Value |
|-------|--------|
| Document ID | HandOff-C6-OP-SRPF-Move-Correlation-2026-08-15 |
| Version | 1.0.0-FINAL |
| Status | Ready to Close |
| Date | 2026-08-15 |
| Repos | cmcodes + CM-Docs |
| Principles | SSOT + Q1/Q2 |
| Related | Register-to-OP-Handoff-Contract-2026-08-13 v1.0 |

Báo cáo bàn giao kết thúc **C6**: tách realization `MEMBER_PROMOTE` (OP) khỏi shared SRPF engine, xác nhận E2E `MEMBER_JOIN` + `CLAN_SETUP`, và chuẩn hóa mô hình kiểm soát **correlation_id (C)**.

**Đường dẫn đề xuất CM-Docs:**  
`Doctrines docs/Onboarding/HandOff-C6-OP-SRPF-Move-Correlation-2026-08-15.md`

---

## 1. Mục tiêu & phạm vi C6

### 1.1 Mục tiêu

- Engine SRPF generic giữ tại `shared/frameworks/srpf` (không biết `MEMBER_PROMOTE`).
- Definition + `openMemberPromoteInstance` + register bootstrap chuyển sang `modules/onboarding/srpf`.
- Auth C3 (`processUserApproval`) require path mới; không phá Q1 luồng Approve.
- Test suite C6 tự `register` trước `executeAction`.

### 1.2 Phạm vi

| Trong phạm vi | Ngoài phạm vi |
|---------------|---------------|
| Move definition + open service + register | FE / OpenAPI routes OP |
| Barrel `index` `modules/onboarding/srpf` | Model `process_instances` |
| Wire `registerMemberPromote` (routes/tests) | Refactor RP sang `member.service` |
| E2E verify JOIN + CLAN_SETUP sau move | Auto tenant `HOAT_DONG` / auto `CLAN_ADMIN` |
| Correlation control map (SSOT vận hành) | Đổi schema `notification_event` |

---

## 2. Cấu trúc sau C6

### 2.1 Shared — engine only

```text
Backend/src/shared/frameworks/srpf/
  engine/          ActionExecutor, StateMachineRunner, CorrelationFactory
  guards/          ContextGuard
  ledger/          BusinessLedgerWriter
  communication/   CommunicationHook
  storage/         ProcessInstanceLoader (temp: onboarding_cases)
  registry/        ProcessDefinitionRegistry
  constants/       states, actions
  errors/          srpf.codes, srpfCreateError
  index.js         v0.8.1-C6 — KHÔNG auto-register MEMBER_PROMOTE
```

### 2.2 Onboarding — OP realization

```text
Backend/src/modules/onboarding/srpf/
  index.js                         Barrel v1.0.0-C6
  registerMemberPromote.js         Idempotent bootstrap register
  definitions/MemberPromote.definition.js
  services/openMemberPromoteInstance.js
```

### 2.3 Bootstrap

- `onboarding.routes.js` (hoặc app load routes): `require('./srpf').registerMemberPromote()`
- Test scripts: tự gọi `registerMemberPromote()` trước `executeAction`
- `auth.service`: `require('../onboarding/srpf')` hoặc `.../services/openMemberPromoteInstance`

---

## 3. Deliverable đã hoàn thành (C1–C6)

| # | Việc | Status |
|---|------|--------|
| **C1** | Register-to-OP-Handoff-Contract SSOT v1.0 | DONE |
| **C2** | `openMemberPromoteInstance` (idempotent, DRAFT, C mới) | DONE |
| **C3** | `processUserApproval` DA_DUYET → open OP (cùng TX) | DONE |
| **C4** | OP DRAFT → SUBMIT (+ BPL + notif) | DONE |
| **C5** | START_REVIEW → APPROVE → member `CHINH_THUC` | DONE |
| **C6** | Move realization → `modules/onboarding/srpf` + barrel + index header | DONE |

---

## 4. Sơ đồ kiểm soát Correlation_id (C)

Hai lớp C bắt buộc tách khi đọc DB và khi design process:

| Lớp | Ý nghĩa | Lưu ở đâu |
|-----|---------|-----------|
| **C-root (case)** | Định danh một process instance / vòng đời hồ sơ | `onboarding_cases.correlation_id` (unique, **không đổi** theo action) |
| **C-action** | Định danh một hành động nghiệp vụ (submit, approve…) | `business_process_logs`, `notifications`, `audit_logs` |

**Quy tắc:**

- `SAVE_DRAFT` **không** sinh C.
- Các action SRPF còn lại (`SUBMIT`, `START_REVIEW`, `APPROVE`, …) sinh **C-action mới**.
- C-action **KHÔNG** ghi đè `onboarding_cases.correlation_id`.

### 4.1 Happy path CLAN_SETUP (đã chứng minh trên DB)

```text
Register CreateClan
  C1  ──► onboarding_cases RP (CLAN_SETUP)
      ├── business_process_logs: USER_REGISTER, ONBOARDING_CASE_CREATE
      ├── notifications: USER_REGISTERED
      └── audit: REGISTER_CREATE_CLAN (user CHO_DUYET, tenant CHO_DUYET)

processUserApproval → DA_DUYET
  C_a ──► BPL USER_APPROVAL SUCCESS
      ├── audit: user CHO_DUYET→DA_DUYET + member_id
      ├── audit: tenant CHO_DUYET→TAM_NGUNG (CLAN_SETUP)
      └── (cùng TX) openMemberPromoteInstance

openMemberPromoteInstance
  C_op ──► onboarding_cases OP MỚI (DRAFT, process_type MEMBER_PROMOTE)
           metadata.source_register_case_id / source_register_correlation_id = RP/C1
           (không bắt buộc BPL lúc open — implement hiện tại)

MEMBER_PROMOTE SUBMIT
  C_s ──► BPL ONBOARDING_SUBMIT + notif ONBOARDING_SUBMITTED + audit case DRAFT→SUBMITTED
           case OP: status SUBMITTED, correlation_id vẫn = C_op

START_REVIEW
  C_r ──► BPL ONBOARDING_REVIEW_START + audit → UNDER_REVIEW

APPROVE
  C_p ──► BPL ONBOARDING_APPROVE + notif ONBOARDING_APPROVED + audit → APPROVED
           sideEffect: members.status = CHINH_THUC
```

### 4.2 Bảng ánh xạ C ↔ bảng (kiểm soát vận hành)

| Nhãn | Sinh khi | onboarding_cases | BPL | notifications | audit_logs |
|------|----------|------------------|-----|---------------|------------|
| **C1** | Register CreateClan/Join | YES (root RP) | YES (USER_REGISTER, CASE_CREATE…) | YES (USER_REGISTERED…) | YES (REGISTER_*) |
| **C2, C3…** | Revision RP (nếu có) | NO (giữ C1) | YES (C-action) | YES (nếu emit) | YES (nếu có) |
| **C_a** | processUserApproval | NO (RP status APPROVED, C1 giữ) | YES USER_APPROVAL | YES (post-TX) | YES user/tenant |
| **C_op** | openMemberPromoteInstance | YES (root OP) | NO (hiện tại) | NO (hiện tại) | NO (hiện tại) |
| **C_s** | OP SUBMIT | NO (giữ C_op) | YES ONBOARDING_SUBMIT | YES ONBOARDING_SUBMITTED | YES case status |
| **C_r** | OP START_REVIEW | NO (giữ C_op) | YES REVIEW_START | YES UNDER_REVIEW | YES |
| **C_p** | OP APPROVE | NO (giữ C_op) | YES ONBOARDING_APPROVE | YES ONBOARDING_APPROVED | YES |
| **C_x** | REJECT / RETURN / CANCEL | NO (giữ C_op) | YES tương ứng | YES tương ứng | YES |

### 4.3 Ví dụ số liệu thật (CLAN_SETUP — Đỗ Văn A, 2026-08-15)

| Nhãn | correlation_id | Ghi nhận chính |
|------|----------------|----------------|
| **C1** | `b6cf9e31-60ec-47ca-8e90-55809d462b02` | Case RP APPROVED; BPL REGISTER; notif USER_REGISTERED |
| **C_a** | `9b0ee839-d4ba-44f7-8f3a-bedc74e629a8` | USER_APPROVAL; user DA_DUYET; tenant TAM_NGUNG |
| **C_op** | `45ecbe1e-5f00-4e92-9044-a913f45c807b` | Case OP `7ae88300-…` root |
| **C_s** | `82d248af-f1d4-4b34-987c-22c257ab183f` | ONBOARDING_SUBMIT SUCCESS + notif |
| **C_r** | `8700ccf9-be07-4781-bb92-d6d6fea4a5f2` | START_REVIEW audit SUBMITTED→UNDER_REVIEW |
| **C_p** | `fae70533-4bba-45f2-8cb1-90e10d56c743` | APPROVE; member CHINH_THUC (Đỗ Văn A) |

### 4.4 Anti-pattern (cấm)

- `UPDATE` case RP `APPROVED` → `NEEDS_REVISION` để “giả” OP.
- Reuse **C1** hoặc **C_a** làm `onboarding_cases.correlation_id` của OP.
- Query case bằng **C-action** (`C_s` / `C_p`) — sẽ **0 row**; phải query theo **case id** hoặc **C_op**.
- Coi mọi `correlation_id` trên BPL là root case.

### 4.5 SQL đối soát chuẩn

```sql
-- Case RP + OP cùng user
SELECT id, case_type, status, correlation_id, primary_member_id, metadata
FROM onboarding_cases
WHERE user_id = '<userId>'
ORDER BY created_at;

-- BPL theo các C đã biết
SELECT correlation_id, process_type, process_status, created_at
FROM business_process_logs
WHERE correlation_id IN ('<C1>','<C_a>','<C_op>','<C_s>','<C_r>','<C_p>')
ORDER BY created_at;

-- Notif
SELECT correlation_id, event_type, title
FROM notifications
WHERE correlation_id IN ('<C1>','<C_a>','<C_s>','<C_p>', ...);

-- C_a nếu chưa có trong list C case
SELECT correlation_id, process_type, process_status, created_at
FROM business_process_logs
WHERE process_type = 'USER_APPROVAL'
  AND created_at >= '<register_time>'
ORDER BY created_at;
```

---

## 5. Kết quả kiểm thử sau C6

### 5.1 MEMBER_JOIN

- open → DRAFT → SUBMIT → START_REVIEW → APPROVE → `CHINH_THUC`
- BPL + `ONBOARDING_SUBMITTED` / `ONBOARDING_APPROVED`
- `generation` JOIN: **warn only** (strongly recommended)

### 5.2 CLAN_SETUP

- Register → **C1**; Approve identity → **C_a** + tenant **`TAM_NGUNG`**; open OP → **C_op** DRAFT
- SUBMIT → **C_s**; START_REVIEW → **C_r**
- APPROVE blocked đúng: thiếu `birth_month`/`birth_day`; thiếu `generation` (≥ 1 bắt buộc SETUP)
- Sau bổ sung BP: APPROVE → `CHINH_THUC` (Đỗ Văn A); case `APPROVED`
- Không auto `HOAT_DONG`; không auto `CLAN_ADMIN` user role

### 5.3 Test scripts C6

| Script | Mục đích |
|--------|----------|
| `test-srpf-c6-smoke.js` | register + registry + loader + correlation policy |
| `test-srpf-c6-open.js` | `openMemberPromoteInstance` idempotent |
| `test-srpf-c6-submit-once.js` | DRAFT\|NEEDS_REVISION → SUBMITTED |
| `test-srpf-c6-approve.js` | START_REVIEW → APPROVE → CHINH_THUC |

---

## 6. Quyết định nghiệp vụ giữ nguyên (không đổi trong C6)

- **Trigger OP:** mỗi create member `DU_BI` → open OP DRAFT (C mới); RP Approve là một nguồn.
- **Quyền A/B/C:** tạo `DU_BI` / mở instance / vận hành (USER draft–submit; Admin review–approve).
- **BP hard trên APPROVE:** `full_name`, `gender`, `is_alive`, `birth_year`, `birth_month`, `birth_day`.
- **generation:** hard ≥ 1 `CLAN_SETUP`; strongly recommended `MEMBER_JOIN`.
- **Notification map:** `MEMBER_PROMOTE_*` → `ONBOARDING_*` enum.
- **audit action:** `THEM_MOI` \| `CAP_NHAT` \| `XOA`; `changed_by` chỉ UUID user hợp lệ.

---

## 7. Rủi ro & nợ kỹ thuật

| Mục | Mức | Ghi chú |
|-----|-----|---------|
| `registerMemberPromote` chưa gọi nếu routes/app quên wire | Trung | Tests tự register; production cần routes/app chắc chắn |
| Fallback require registry trong definition (path cũ) | Thấp | OK khi truyền registry; nên sửa path fallback shared |
| PATH comment Q2 còn ghi shared/ trên file đã move | Thấp | Sửa khi đụng file |
| open OP không ghi BPL | Thấp | Có thể bổ sung sau nếu cần audit “OPEN_OP” |
| `process_instances` model | Thấp / Dài hạn | Vẫn temporary `onboarding_cases` |
| Definition còn chỗ `throw Error` lẻ | Thấp | Ưu tiên `srpfError` đồng bộ CED |

---

## 8. Hướng dẫn vận hành sau bàn giao

- Mọi `executeAction MEMBER_PROMOTE`: đảm bảo đã `registerMemberPromote()`.
- Trace RP→OP: `metadata.source_register_case_id` + `source_register_correlation_id`.
- Trace action: dùng **C trên BPL/notifications**; không dùng C-action để tìm case.
- Fixture: **không** `UPDATE` case RP `APPROVED` thành `NEEDS_REVISION`.

---

## 9. Tài liệu & code tham chiếu

- CM-Docs: `Register-to-OP-Handoff-Contract-2026-08-13`
- CM-Docs: `Standard-Revision-Process-Framework-SRPF-v1.0-Final`
- CM-Docs: `HandOver-Register-Process-Closure-2026-08-10` (RP CLOSED)
- cmcodes: `Backend/src/shared/frameworks/srpf/`
- cmcodes: `Backend/src/modules/onboarding/srpf/`
- cmcodes: `Backend/src/modules/auth/auth.service.js` (C3 handoff)

---

## 10. Kết luận & phê duyệt đóng C6

C6 đạt DoD: engine/shared tách khỏi OP realization; bootstrap register rõ; E2E `MEMBER_JOIN` và `CLAN_SETUP` đã PASS trên môi trường dev; mô hình **C-root vs C-action** đã kiểm chứng bằng SQL thật.

| Hạng mục | Giá trị |
|----------|---------|
| **Status C6** | **COMPLETE — Ready to Close** |
| Ngày | 2026-08-15 |
| Khuyến nghị | Đóng C6; next: FE/API OP hoặc polish (wire routes chắc, Q2 PATH headers) |
| Thay đổi sau đóng | Amendment versioned; không sửa âm thầm contract C |

---

*End of HandOff-C6-OP-SRPF-Move-Correlation v1.0.0-FINAL*

