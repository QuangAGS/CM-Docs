# Handoff — PR-OP-4 Residual · SEC + Register polish

**DATETIME:** 2026-08-09  
**SSOT:** SEC / CED / OPD + Master Plan · Q1/Q2  
**Repos:**

- Backend / Frontend: https://github.com/QuangAGS/cmcodes  
- Docs: https://github.com/QuangAGS/CM-Docs  

**Scope handoff này:** residual sau PR-OP-4 R1/R2 + C1/C2 (không mở lại OP-2 trừ mục 3.1 ghi nhận).

---

## 1. Đã xong (UAT OK — không mở lại trừ regression)

| # | Hạng mục | Kết quả |
|---|----------|---------|
| **1.1** | Login lock theo **account** (phone ↔ email cùng user) | PASS |
| **2.1** | Online uniqueness phone **và** email; fail-closed khi API lỗi | PASS |
| **2.2** | CLAN_SETUP revision cập nhật `tenants.description` (+ optional `clanName`) | PASS |
| **2.3** | Email field padding (`pl-11`) — icon không đè chữ | PASS (fixed) |

### 1.1 — Account-level login lock

**Vấn đề:** `user_attempt_number` / lock chỉ theo chuỗi `identifier` → fail email ×N vẫn login được bằng phone (cùng user).

**Fix:**

- `authLog.service.js`: `resolveLinkedIdentifiers(identifier)` → mọi phone/email của cùng user.
- `logAttempt` (LOGIN): bump / reset **mọi** alias (cùng IP + action).
- `getLockoutMetadata`: `max(attempt_count)` trên linked identifiers.
- Controller login: giữ pre-check metadata; optional log `[login lock]`.

**Smoke:** Fail email × MAX → login phone đúng pass → **423**, không Homepage; hết window / success → cả hai OK.

### 2.1 — Online check phone/email

**Hiện trạng repo:** BE `checkIdentity` + FE Join/Create đã có check; lỗ chính là **fail-open** khi network/429.

**Fix:**

- BE `checkIdentity`: `findFirst` + `deleted_at: null` (khớp login/register).
- Join: `checkPhoneAvailability` / `checkEmailAvailability` — `catch` → `valid: false` + remote error.
- Create: `checkIdentityOnline` — cùng fail-closed.
- Revision: **không** check uniqueness (giữ).

**Smoke:** Trùng phone/email blur + nextStep chặn Waiting; API lỗi không lọt Waiting; revision skip.

### 2.2 — Revision CLAN_SETUP → tenant description

**Vấn đề:** `submitRegistrationRevision` chỉ update `users.temp_*`.

**Fix BE:** Trong TX revision, nếu `role === CLAN_ADMIN` + tenant onboarding (`CHO_DUYET` | `TU_CHOI` | `TAM_NGUNG`) → update `tenants.description` (và `name` nếu `clanName` non-empty) + audit.

**Fix FE:** `AuthPage.handleConfirmSubmit` — revision + `isNewClan` ép `description` / `clanName` từ form hoặc snapshot.

**Smoke:** Sửa mô tả → DB + prefill/Admin đúng; Join revision không đụng tenant.

### 2.3 — UI email field

`pl-11` trên input email (Join/Create) cho icon absolute left — đã fixed.

---

## 2. Path / symbol quan trọng

| Layer | Path |
|-------|------|
| Lock | `Backend/src/modules/auth/authLog.service.js` |
| Login pre-check | `Backend/src/modules/auth/auth.controller.js` (login) |
| Identity API | `Backend/src/modules/auth/auth.service.js` → `checkIdentity` |
| Revision + tenant | `auth.service.js` → `submitRegistrationRevision` |
| FE confirm | `frontend/src/pages/AuthPage.jsx` → `handleConfirmSubmit` |
| FE online check | `JoinClanForm.jsx`, `CreateClanForm.jsx` |

---

## 3. Chưa làm / đã hoãn

| # | Hạng mục | Ghi chú |
|---|----------|---------|
| **3.1** | CLAN_ADMIN / SYSTEM kích hoạt tenant `TAM_NGUNG` → `HOAT_DONG` | Thuộc **OP-2 Clan activate**; cần API + authz + UI riêng — **không** nhét vào residual register |
| Redesign Approval FE case-centric | Hoãn (handoff OP trước) |
| Residual notif / edge APPROVED rồi reject | Theo doctrine communication — phase sau nếu cần |
| Lock global theo `user_id` (mọi IP) | Optional harden; hiện lock **theo account + IP** |

---

## 4. Quyết định kiến trúc giữ nguyên

- M1 register: case ngoài TX user; fail-open ledger/notif nơi đã chốt.
- Revision: giữ `users.status = CHO_DUYET`; case `NEEDS_REVISION` → `SUBMITTED`; khóa phone/email.
- Final rejection: `users.status = TU_CHOI` + `metadata.is_final_rejection`; không enum status mới.
- Login CHO_DUYET: 423 + `canEdit` / `reviewNote` / `tempSnapshot` khi có bút phê / NEEDS_REVISION.

---

## 5. Việc tiếp (thứ tự đề xuất)

1. **(Optional)** Smoke regression nhanh full PR-OP-4 checklist (approve / reject / reopen / final / revision Join + Create).
2. **OP-2** — Tenant activate (`TAM_NGUNG` → `HOAT_DONG`): spec authz (CLAN_ADMIN own tenant DA_DUYET; SYSTEM full) + API + BPL/audit + FE entry.
3. Không nhảy feature lớn khác cho đến khi 3.1 chốt scope.

---

## 6. Handoff note (Q2)

- Residual **1.1 / 2.1 / 2.2 / 2.3** đã UAT OK (2026-08-09).
- Code trên monorepo `QuangAGS/cmcodes` (main).
- Thread tiếp: ưu tiên **OP-2 tenant activate** nếu product cần CLAN_ADMIN tự bật dịch vụ sau duyệt.

---

*End of handoff.*
