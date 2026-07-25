# Handoff-W2 — Assert Order & Status Honesty

**PATH**        : docs/handoffs/Handoff-W2.md  
**DATETIME**    : 2026-07-25T17:45:00+07:00  
**VERSION**     : 1.0.0-W2  
**WAVE**        : Wave 2 — Assert Order & Status Honesty  
**STATUS**      : DONE  

---

## 1. Done

### PR-W2-1 — feat(assert-order-login) + TENANT_NOT_ACTIVATED

**auth.service.js — `loginUser`**
- Assert Order bắt buộc:
  1. Credential (password)
  2. User status / Lock (`checkLockStatus`)
  3. Tenant status (defensive)
  4. Cấp token
- `CHO_DUYET` → 423 `ACCOUNT_CHO_DUYET`
- `TU_CHOI` / `TAM_NGUNG` (user) → 403 `ACCOUNT_DISABLED`
- Tenant `TAM_NGUNG` → **cho phép login** (CLAN_ADMIN cần hoàn thiện profile)
- Tenant `BI_KHOA` → 403 `TENANT_DISABLED`
- JWT + response user: thêm field `tenantStatus`

**auth.controller.js — `login`**
- Bỏ check status thừa sau `loginUser`
- Map đúng HTTP 423 cho lifecycle / locked codes

**role.middleware.js**
- `checkRole` hỗ trợ cả `checkRole('A','B')` và `checkRole(['A','B'])`
- Thêm `requireActiveTenant`:
  - SYSTEM_ADMIN bypass
  - `tenantStatus ∈ {CHO_DUYET, TAM_NGUNG, BI_KHOA}` → 403 `TENANT_NOT_ACTIVATED`

**auth.middleware.js**
- Map `tenantStatus` từ JWT → `req.user`
- Re-export `requireActiveTenant`

**auth.routes.js**
- Gắn `requireActiveTenant` vào:
  - `GET /pending-users`
  - `POST /query-reviewable-users`
  - `POST /process-approval`

---

## 2. Smoke results

| Case | Kết quả |
|------|---------|
| Sai password | 401 `INVALID_AUTH` ✅ |
| `users.status = CHO_DUYET` | 423 `ACCOUNT_CHO_DUYET` ✅ |
| `users.status = TU_CHOI` | 403 `ACCOUNT_DISABLED` ✅ |
| `CLAN_ADMIN` + tenant `TAM_NGUNG` → login | 200 + token ✅ |
| `CLAN_ADMIN` + tenant `TAM_NGUNG` → query/approve | 403 `TENANT_NOT_ACTIVATED` ✅ |
| `CLAN_ADMIN` + tenant `HOAT_DONG` → query | 200 ✅ |
| `SYSTEM_ADMIN` | bypass OK ✅ |

---

## 3. Residual

- FE routing: sau login, `CLAN_ADMIN` + tenant `TAM_NGUNG` vẫn bị lái vào trang Approve → cần map `tenantStatus` / `TENANT_NOT_ACTIVATED` để redirect trang hoàn thiện tenant.
- JWT cũ (trước deploy) không có `tenantStatus` → bắt buộc logout/login lại sau deploy.
- Early tenant-slug 404 shape cũ (residual Wave 1) — chưa chuẩn hóa dual-contract.
- Validation sớm trong onboarding controller — chưa dual-contract đầy đủ.
- `src/modules/auth/core/` — dead code, xóa sau (không đụng Wave 2).

---

## 4. Next

- **Frontend:** xử lý redirect theo `tenantStatus` / `code === 'TENANT_NOT_ACTIVATED'`.
- Residual shape (optional) nếu còn trong Wave 2.
- Hoặc chuyển Wave tiếp theo theo Master Implementation Plan v1.2.0 (lock engine / outbox / delegation — khi sẵn sàng).

---

## 5. Doctrine Pins

| Tài liệu | Version | Trạng thái |
|----------|---------|------------|
| EGAL-SEC Security Doctrine | v1.1.0 | APPROVED & FROZEN |
| EGAL-CED Centralized Error Doctrine | v1.1.0 | APPROVED & FROZEN |
| OPD | v1.2.0 | — |
| Master Implementation Plan | v1.2.0 | AUTHORITATIVE |

---

## 6. Notes

- Dual-contract `legacy: true` vẫn bật (Q1 FE).
- CorrelationId vẫn bắt buộc qua Global Handler (CED E5).
- Không tách lock/token/policy service trong Wave 2 (đúng scope).
- Business rule xác nhận: `DA_DUYET` + tenant `CHO_DUYET` không xảy ra sau Approve (tenant → `TAM_NGUNG`).

---

**Handoff-W2 hoàn tất.**  
Wave 2 (Assert Order & Status Honesty) DONE.