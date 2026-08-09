# HandOver — Register Process Package (OPD-aligned)

**DATETIME:** 2026-08-09  
**SSOT:** SEC / CED / OPD + Master Plan v1.2 · Q1/Q2  
**STATUS:** Register onboarding loop **chốt gói** (UAT OK) — sẵn sàng thread mới  
**REPOS (đã cập nhật main):**

- Code: https://github.com/QuangAGS/cmcodes/tree/main/
- Docs: https://github.com/QuangAGS/CM-Docs/tree/main/

**Related handoffs (đọc thêm, không lặp chi tiết):**

- `Doctrines docs/Onboarding/Handoff-PR-OP-4-R1-R2.md`
- `Doctrines docs/Onboarding/Handoff-PR-OP-4-Residual-SEC-1.1-2.x.md`
- Master Plan HandOff W2–W5 (CED/SEC pipeline nền)

---

## 1. Mục tiêu gói này (đã đạt)

Xử lý **Register Process** theo tinh thần OPD:

- Case onboarding gắn vòng đời hồ sơ (SUBMITTED / NEEDS_REVISION / APPROVED / REJECTED…).
- `users.status` là cổng auth/login thực tế (CHO_DUYET / DA_DUYET / TU_CHOI…).
- Admin quyết định: duyệt / từ chối / trả về sửa / mở lại / từ chối lần cuối.
- Applicant: login thấy bút phê → sửa hồ sơ (revision) → gửi lại, **không** JWT full khi còn chờ duyệt.
- CLAN_SETUP đồng bộ tenant status + mô tả khi revision; MEMBER_JOIN tách biệt.
- SEC: lock login theo **account** (phone↔email), online uniqueness fail-closed.

**Không** nhằm redesign toàn bộ Register từ zero — **patch + chuẩn hóa** trên app hiện có (Q1 bảo toàn).

---

## 2. Bản đồ trạng thái đã chốt

### 2.1 users.status (auth gate)

| Status | Ý nghĩa vận hành |
|--------|------------------|
| `CHO_DUYET` | Hồ sơ mở: chờ duyệt hoặc đang bổ sung (tương đương case open / NEEDS_REVISION về UX) |
| `DA_DUYET` | Quyết định cuối — **không** flip ngược tại form approve thường |
| `TU_CHOI` | Từ chối; có thể reopen **trừ khi** final |
| `BI_KHOA` / `BI_CAM` | An ninh / kỷ luật — **không** dùng cho vòng Register thường |

### 2.2 onboarding_cases (OP tracking)

| Status (tiêu biểu) | Khi nào |
|--------------------|---------|
| `SUBMITTED` | Sau register / sau revision submit |
| `NEEDS_REVISION` | Admin trả về sửa **hoặc** reopen từ TU_CHOI |
| `APPROVED` / `REJECTED` | Đóng case khi duyệt / từ chối (kèm metadata final nếu có) |

**Nguyên tắc:** Case chỉ “đóng” khi APPROVED/REJECTED; query open case theo status open list. Final reject = `TU_CHOI` + `metadata.is_final_rejection` (không invent enum user status mới).

### 2.3 tenants.status (CLAN_SETUP)

| Sự kiện | Tenant |
|---------|--------|
| CreateClan register | `CHO_DUYET` |
| SYSTEM approve CLAN_ADMIN | `TAM_NGUNG` (chờ kích hoạt dịch vụ) |
| Reject / final reject | `TU_CHOI` (đồng bộ) |
| Reopen | `TU_CHOI` → `CHO_DUYET` |
| Revision (onboarding tenant) | Cập nhật `description` (+ optional `name`) |
| **Activate `HOAT_DONG`** | **Chưa làm → OP-2** |

### 2.4 Bảng chuyển (admin) — đã UAT

| From → To | Cơ chế |
|-----------|--------|
| CHO_DUYET → DA_DUYET | `processUserApproval` |
| CHO_DUYET → TU_CHOI (± final) | `processUserApproval` + `isFinalRejection` |
| CHO_DUYET → “trả về sửa” | `returnForRevision` — **giữ** CHO_DUYET; case → NEEDS_REVISION |
| TU_CHOI → CHO_DUYET | Bridge → `reopenRejectedUser` (case mới, correlation mới) |
| TU_CHOI → TU_CHOI + final | Bridge → `markFinalRejection` |
| DA_DUYET → * | **Cấm** flip tại service thường |

Authz: không tự duyệt; CLAN_ADMIN cùng tenant + actor `DA_DUYET`; CreateClan / CLAN_ADMIN target → SYSTEM_ADMIN; final block reopen.

---

## 3. Các PR / wave đã đóng trong gói Register

| Wave | Nội dung chính | Status |
|------|----------------|--------|
| **PR-OP-1a** | Register → Waiting; không JWT full; login CHO_DUYET → 423 | Done |
| **PR-OP-1a.1 M1** | post-TX: case SUBMITTED, BPL, audit, notif; Join=MEMBER_JOIN / Create=CLAN_SETUP | Done |
| **PR-OP-1b** | `processUserApproval`: correlation factory, createLog C, return trong TX, authz | Done |
| **PR-OP-4 R1** | Return-for-revision; FE note + RegisterForm prefill; revision submit | Done |
| **PR-OP-4 R2** | Reopen; final rejection; badge/label list; form disable final | Done |
| **PR-OP-4 C1/C2** | CreateClan revision parity (form, identity, description prefill) | Done |
| **Residual 1.1** | Login lock theo user (linked phone+email) | Done |
| **Residual 2.1** | Online check phone/email fail-closed | Done |
| **Residual 2.2** | Revision cập nhật `tenants.description` | Done |
| **Residual 2.3** | Email field `pl-11` | Done |

---

## 4. Luồng end-to-end (applicant + admin)

```
[Applicant]
  Register (Join | CreateClan)
    → users CHO_DUYET (+ tenant CHO_DUYET nếu Create)
    → case SUBMITTED (M1 post-TX)
    → Waiting / Result
  Login CHO_DUYET
    → 423 ACCOUNT_CHO_DUYET
    → nếu có reviewNote / NEEDS_REVISION: canEdit + tempSnapshot
    → FE revision-notice → RegisterForm prefill (phone/email khóa)
    → submit isRevision → case NEEDS_REVISION→SUBMITTED; tenant desc nếu CLAN_SETUP

[Admin]
  query-reviewable-users (isFinalRejection enriched)
  → Duyệt / Từ chối (± final) / Trả về sửa / Mở lại (nếu chưa final)
  → BPL USER_APPROVAL + audit + notif (orchestrator / ledger tùy chỗ đã vá)
```

**Correlation:** một `C` gốc cho TX approve/reopen/revision; factory `prisma.correlation.create()` — không `crypto.randomUUID()` rời.

---

## 5. Path / symbol “SSOT code” (thread mới mở đây trước)

### Backend (`cmcodes` → Backend/)

| Symbol | Path |
|--------|------|
| `registerUser` / M1 post-TX | `src/modules/auth/auth.service.js` |
| `loginUser` (CHO_DUYET 423 + snapshot) | cùng file |
| `processUserApproval` + bridges reopen/final | cùng file |
| `returnForRevision` | cùng file |
| `reopenRejectedUser` / `markFinalRejection` | cùng file |
| `submitRegistrationRevision` (+ tenant 2.2) | cùng file |
| `checkIdentity` | cùng file |
| `queryReviewableUsers` (+ isFinalRejection) | cùng file |
| Controller routes | `src/modules/auth/auth.controller.js` |
| Routes | `src/modules/auth/auth.routes.js` |
| Account lock | `src/modules/auth/authLog.service.js` |
| Case helpers | `src/services/onboarding.service.js` |
| BPL / audit | `ledger.service` / `audit.service` |
| Correlation | `src/lib/prisma.js` → `prisma.correlation` |

### Frontend (`cmcodes` → frontend/)

| Area | Path |
|------|------|
| Auth shell / revision / confirm | `src/pages/AuthPage.jsx` |
| Login 423 handling | `src/context/AuthContext.jsx` |
| Join / Create forms | `src/features/register-wizard/components/JoinClanForm.jsx`, `CreateClanForm.jsx` |
| Identity helpers | `src/features/register-wizard/utils/identityHelpers.js` |
| Admin list + form | `src/pages/AdminUserApprovalPage.jsx`, `src/features/admin/components/UserApprovalForm.jsx` |

### Docs

| Doc | Path (CM-Docs) |
|-----|----------------|
| R1/R2 | `Doctrines docs/Onboarding/Handoff-PR-OP-4-R1-R2.md` |
| Residual SEC | `Doctrines docs/Onboarding/Handoff-PR-OP-4-Residual-SEC-1.1-2.x.md` |
| **Gói này** | Commit file này cùng thư mục Onboarding (khuyến nghị) |

---

## 6. Invariants Q1/Q2 (bắt buộc trên thread mới)

1. **Q1:** Mọi thay đổi auth/register/approve — đọc code hiện tại + schema trước; không phá flow đã UAT.
2. **Q2:** Header PATH / DATETIME / VERSION / DESCRIPTION; handoff ngắn khi wave PASS.
3. **Không gen bulk code** khi chưa confirm plan/diff (protocol user).
4. **Correlation** chỉ qua factory tập trung.
5. **DA_DUYET** không flip thường; final reject không reopen qua service thường.
6. Revision: khóa phone/email; không uniqueness check self.

---

## 7. Việc **không** làm trong gói (còn mở)

| ID | Hạng mục | Gợi ý phase |
|----|----------|-------------|
| **OP-2** | Tenant activate: `TAM_NGUNG` → `HOAT_DONG` (CLAN_ADMIN own + SYSTEM) | **Next recommended** |
| **OP-3** | State machine FE case-centric | Sau OP-2 |
| — | Redesign Approval FE theo case | Hoãn |
| — | Job auto SUBMITTED → UNDER_REVIEW | Hoãn |
| — | `createFullMember` trong approve (nếu còn gap member) | Kiểm tra regression khi cần |
| — | Communication doctrine đầy đủ (WEB_PUSH / EMAIL…) | Phase communication |
| — | Lock login global theo `user_id` (mọi IP) | Optional SEC harden |
| — | SYSTEM reverse DA_DUYET trong cửa sổ ngắn | Policy + service riêng nếu product yêu cầu |

---

## 8. Lộ trình đề xuất (thread mới)

### Ngay (OP-2 — Clan activate)

1. Spec authz:
   - CLAN_ADMIN + `DA_DUYET` + cùng `tenant_id` + tenant `TAM_NGUNG` → được activate một lần / có kiểm soát.
   - SYSTEM_ADMIN: full support.
2. API: ví dụ `POST /api/tenants/:id/activate` (hoặc domain service tương đương).
3. TX: tenant status + BPL + audit + correlation; optional notif.
4. FE: entry sau login khi `tenantStatus === TAM_NGUNG` (gate hiện có trong JWT/`tenantStatus`).
5. Smoke: CreateClan → SYSTEM approve → CLAN_ADMIN login → activate → `HOAT_DONG` → member flows.

### Sau đó

- OP-3 / FE case-centric nếu admin UX còn đau.
- SEC residual (lock cross-IP) nếu threat model yêu cầu.
- Notif một cửa / edge APPROVED.

### Không làm

- Mở lại Register M1 / PR-OP-1b / PR-OP-4 core trừ **regression** có log + repro.

---

## 9. Smoke regression tối thiểu (trước feature mới)

Chạy nhanh nếu đụng auth/tenant:

1. Join register → admin duyệt → login 200  
2. CreateClan → SYSTEM duyệt → tenant TAM_NGUNG  
3. Return-for-revision → applicant sửa → resubmit  
4. Reject → reopen → reject final → reopen **403**  
5. Fail login email ×N → phone cùng user **423**  
6. Online trùng phone/email chặn Waiting  

---

## 10. Ghi chú cho agent thread mới

- User protocol: **hỏi / plan / confirm trước khi gen code**; xuất full function khi được yêu cầu patch; hướng dẫn vị trí chèn cụ thể.
- Ngôn ngữ kỹ thuật: tiếng Việt + symbol code; checklist smoke dạng bảng.
- Repo truth: **main** đã push (2026-08-09); ưu tiên đọc GitHub hơn memory cũ nếu lệch.
- Health/personal memory: **không** liên quan Register — không đưa vào handoff kỹ thuật.

---

## 11. Kết luận một dòng

**Register Process (Join + CreateClan) đã khép vòng OPD-practical: case + user status + admin decisions + revision + final + SEC lock/uniqueness — UAT OK. Thread mới bắt đầu từ OP-2 Tenant Activate; không redesign Register trừ regression.**

---

*End of HandOver — Register Process Package · 2026-08-09*
