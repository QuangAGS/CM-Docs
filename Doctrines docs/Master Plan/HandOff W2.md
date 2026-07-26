# Handoff-W2 — Assert Order & Status Honesty (FINAL)

**PATH**        : docs/handoffs/Handoff-W2.md  
**DATETIME**    : 2026-07-26T11:45:00+07:00  
**VERSION**     : 1.1.0-W2-FINAL  
**WAVE**        : Wave 2 — Assert Order & Status Honesty  
**STATUS**      : DONE (all PRs closed)

---

## 1. Done

### PR-W2-1 — feat(assert-order-login) + TENANT_NOT_ACTIVATED
- `loginUser`: Assert Order (credential → lock/status → tenant → token)
- `CHO_DUYET` → 423 `ACCOUNT_CHO_DUYET`
- User `TU_CHOI`/`TAM_NGUNG` → 403 `ACCOUNT_DISABLED`
- Tenant `TAM_NGUNG` → cho phép login (CLAN_ADMIN hoàn thiện profile)
- Tenant `BI_KHOA` → 403 `TENANT_DISABLED`
- JWT + user response: field `tenantStatus`
- `requireActiveTenant` middleware → 403 `TENANT_NOT_ACTIVATED`
- `checkRole` nhận cả array và rest params
- Controller login: bỏ check status thừa, map 423 đúng

### PR-W2-2 — fix(auth-mw-ced-shape)
- `auth.middleware.js` + `role.middleware.js`: `res.status().json` → `next(err)`
- Dual-contract qua Global Handler (`createGlobalErrorHandler({ legacy: true })`)
- Codes: `UNAUTHORIZED`, `INVALID_TOKEN`, `FORBIDDEN`, `ADMIN_ACCOUNT_NOT_ACTIVATED`, `TENANT_NOT_ACTIVATED`

### PR-W2-3 — fix(early-404-shape)
- `app.js` tenant middleware: early 404 → `next(err)` với `TENANT_NOT_FOUND`
- Dual-contract + `X-Correlation-Id`

### PR-W2-4 — fix(controller-validation-shape)
- `onboarding.controller.js`: validation sớm → `throw validationError(...)` → `sendError`
- Codes: `VALIDATION_ERROR` dual-contract
- `MERGE_FAILED` cũng đi qua `sendError`

---

## 2. Smoke results

| Case | Kết quả |
|------|---------|
| Sai password | 401 `INVALID_AUTH` ✅ |
| `users.status = CHO_DUYET` | 423 `ACCOUNT_CHO_DUYET` ✅ |
| `users.status = TU_CHOI` | 403 `ACCOUNT_DISABLED` ✅ |
| `CLAN_ADMIN` + tenant `TAM_NGUNG` → login | 200 + token ✅ |
| `CLAN_ADMIN` + tenant `TAM_NGUNG` → query | 403 `TENANT_NOT_ACTIVATED` ✅ |
| `CLAN_ADMIN` + tenant `HOAT_DONG` → query | 200 ✅ |
| `SYSTEM_ADMIN` | bypass OK ✅ |
| Tenant slug không tồn tại | 404 `TENANT_NOT_FOUND` dual-contract ✅ |
| Onboarding profile `{}` | 400 `VALIDATION_ERROR` dual-contract ✅ |
| `/api/auth/me` no token | 401 `UNAUTHORIZED` dual-contract ✅ |
| `/api/auth/me` bad token | 403 `INVALID_TOKEN` dual-contract ✅ |

---

## 3. Residual / Backlog

- **FE routing:** `CLAN_ADMIN` + `tenantStatus = TAM_NGUNG` sau login vẫn bị lái vào trang Approve → map `TENANT_NOT_ACTIVATED` / `tenantStatus` để redirect trang hoàn thiện tenant.
- JWT cũ (trước deploy `tenantStatus`) → bắt buộc logout/login lại.
- `src/modules/auth/core/` — dead code, xóa chore sau.
- Turnstile bypass local (nếu còn) → **phải revert** trước commit/deploy.

---

## 4. Files touched (Wave 2)

| File | PR |
|------|-----|
| `src/modules/auth/auth.service.js` | W2-1 |
| `src/modules/auth/auth.controller.js` | W2-1 |
| `src/modules/auth/auth.routes.js` | W2-1 |
| `src/middlewares/role.middleware.js` | W2-1, W2-2 |
| `src/middlewares/auth.middleware.js` | W2-1, W2-2 |
| `src/app.js` | W2-3 |
| `src/modules/onboarding/onboarding.controller.js` | W2-4 |

---

## 5. Next

- Frontend: redirect theo `tenantStatus` / `TENANT_NOT_ACTIVATED`.
- Chore: xóa `src/modules/auth/core/` (dead code).
- Wave tiếp theo theo Master Implementation Plan v1.2.0 (khi sẵn sàng): lock engine / outbox / delegation — **không mở SEC Impl riêng ngoài plan**.

---

## 6. Doctrine Pins

| Tài liệu | Version | Trạng thái |
|----------|---------|------------|
| EGAL-SEC Security Doctrine | v1.1.0 | APPROVED & FROZEN |
| EGAL-CED Centralized Error Doctrine | v1.1.0 | APPROVED & FROZEN |
| OPD | v1.2.0 | — |
| Master Implementation Plan | v1.2.0 | AUTHORITATIVE |

---

## 7. Notes

- Dual-contract `legacy: true` vẫn bật (Q1 FE).
- CorrelationId bắt buộc qua Global Handler (CED E5).
- Không tách lock/token/policy service trong Wave 2 (đúng scope).
- Business rule: sau Approve, tenant `CHO_DUYET` → `TAM_NGUNG`; không tồn tại `DA_DUYET` + tenant `CHO_DUYET` trong flow chuẩn.

---

**Handoff-W2 FINAL — Wave 2 DONE.**