# Handoff-W3 — Tenant gate + OPD policy

**PATH**        : docs/handoffs/Handoff-W3.md  
**DATETIME**    : 2026-07-27T09:45:00+07:00  
**VERSION**     : 1.0.0-W3  
**WAVE**        : Wave 3 — Tenant gate + OPD policy  
**STATUS**      : DONE  
**SSOT**        : Master Implementation Plan v1.2.0 · SEC Doctrine v1.1 · CED Doctrine v1.1 · OPD v1.2  

---

## 1. Done

### PR-W3-1 — feat(tenant-status-mw)
- Tạo `src/middlewares/tenantStatus.middleware.js`
- Modes: **Light** / **Heavy**
- SYSTEM_ADMIN: bypass **status check**, vẫn gán `req.tenantGate` context
- `next(err)` CED + `correlationId` từ `req.correlationId`
- Codes: `TENANT_NOT_ACTIVATED` (403), `TENANT_DISABLED` (403), `TENANT_PENDING_ACTIVATION` (423)

### PR-W3-2 — feat(wire-tenant-status)
- `requireActiveTenant` = alias `tenantStatusHeavy` (Q1) trong `role.middleware.js`
- Re-export `tenantStatus*` qua `auth.middleware.js`
- Auth admin routes (`pending-users`, `query-reviewable-users`, `process-approval`): Heavy qua alias
- Onboarding: Heavy trên review/approve/reject/merge
- **Whitelist:** `POST /api/onboarding/clan/activate` — **không** Heavy (CLAN_ADMIN + tenant `TAM_NGUNG` được kích hoạt)

### PR-W3-3 — refactor(onboarding-ced4)
- `BusinessError` local → adapter `createBusinessError` từ `shared/errors`
- Giữ chữ ký `BusinessError(code, message, { statusCode, ... })` (Q1)
- `_assert*` giữ nguyên body (policy extract full = residual)

### PR-W3-4 — fix(members-filter)
- `getAllMembers(tenantId, filters)` — default **`CHINH_THUC`**
- Override: `?status=DU_BI` | `?status=CHINH_THUC` | `?status=ALL` | `?includePending=true`
- Controller truyền `req.query` → filters
- Enum invalid (vd. `HOAT_DONG` trên members) → Prisma reject (optional VALIDATION_ERROR whitelist = residual)

---

## 2. Smoke results

| Case | Kết quả |
|------|---------|
| CLAN_ADMIN + tenant `TAM_NGUNG` → query-reviewable | **403** `TENANT_NOT_ACTIVATED` + correlationId ✅ |
| CLAN_ADMIN + tenant `HOAT_DONG` → query-reviewable | **200** ✅ |
| CLAN_ADMIN + `TAM_NGUNG` → `/onboarding/clan/activate` | **không** Heavy (400 validation OK) ✅ |
| `GET /members` default | chỉ **CHINH_THUC** ✅ |
| `GET /members?status=DU_BI` | chỉ **DU_BI** ✅ |
| `GET /members?status=ALL` | cả CHINH_THUC + DU_BI ✅ |
| Onboarding profile `{}` | **400** `VALIDATION_ERROR` dual-contract ✅ |

---

## 3. Files touched

| File | PR |
|------|-----|
| `src/middlewares/tenantStatus.middleware.js` | W3-1 (new) |
| `src/middlewares/role.middleware.js` | W3-2 |
| `src/middlewares/auth.middleware.js` | W3-2 |
| `src/modules/onboarding/onboarding.routes.js` | W3-2 |
| `src/modules/onboarding/onboarding.service.js` | W3-3 |
| `src/modules/members/member.service.js` | W3-4 |
| `src/modules/members/member.controller.js` | W3-4 |

---

## 4. Residual / backlog

| Hạng mục | Ghi chú |
|----------|---------|
| `approve` path 500 (`reviewerId` vs `adminId` / Prisma) | Pre-existing; không chặn W3 |
| Policy service full extract (`assertAccountUsable` …) | W2/W3 partial; optional follow-up |
| Members status whitelist → 400 operational | Tránh Prisma enum crash |
| Tree/focal filter CHINH_THUC | Cố ý **không** làm W3 (tránh gãy provisional) |
| FE audio recovery | Ngoài backend |
| Turnstile TEMP | Phải **revert** trước mọi commit production |

---

## 5. Pipeline (documented)
