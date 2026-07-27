# Handoff-W4 — Harden + Notification worker lock

**PATH**        : docs/handoffs/Handoff-W4.md  
**DATETIME**    : 2026-07-27T17:20:00+07:00  
**VERSION**     : 1.0.0-W4  
**WAVE**        : Wave 4 — Harden entry + PENDING worker (SKIP LOCKED)  
**STATUS**      : DONE  
**SSOT**        : Master Implementation Plan v1.2.0 · SEC Doctrine v1.1 · CED Doctrine v1.1 · OPD v1.2  

**Backend**     : github.com/QuangAGS/cmcodes (gia-pha-backend local)  
**Docs**        : github.com/QuangAGS/CM-Docs  

---

## 1. Done

### DB (pre-W4)
- Enum `notification_status` + **`SENDING`**
- `notifications.locked_at` (nullable)
- `notifications.attempts` (default 0)
- Index claim `(status, created_at)` / `(status, locked_at)`
- `correlation_id` đã có sẵn (NOT NULL)

### PR-W4-1 — feat(rate-guard-entry)
- `onboardingWriteRateLimiter` (20/1p), `onboardingAdminRateLimiter` (30/1p)
- `checkIdentityRateLimiter` (20/1p)
- Admin onboarding: `restrictSuspiciousActivity` (`ONBOARDING_ADMIN_ABUSE`)
- 429 gắn `correlationId` khi có
- `validate: false` + normalize localhost key (`::1` → `127.0.0.1`)
- Smoke: login 10× → **429**; check-identity 20× → **429**

### PR-W4-2 — feat(turnstile-config)
- Gate **`securityConfig.TURNSTILE_REQUIRED`** trên login / register / forgot / verify-reset
- Xóa TEMP bypass (`{ success: true }`)
- `validateTurnstile` giữ path siteverify thật
- Smoke: `TURNSTILE_REQUIRED=true` + body `{}` → 403 CAPTCHA

### PR-W4-3 — feat(notif-worker-claim)
- `src/jobs/notificationClaim.worker.js` — claim `FOR UPDATE SKIP LOCKED`
- Reclaim: `SENDING` + `locked_at < NOW() - 10 minutes`
- Set `SENDING` + `locked_at` + `attempts++` trong TX
- Log **correlation_id**; stub mark **SENT**
- CLI: `src/jobs/runNotificationWorker.js`
- Smoke: 2 terminal → **không trùng id**

### PR-W4-4 — fix(notif-fail-retry)
- Fail channel: `attempts < max` → **PENDING** (retry); `>= max` (3) → **FAILED**
- `NOTIF_WORKER_FORCE_FAIL=true` smoke: attempts 1→2 PENDING, 3→**FAILED**
- Row không bị xóa

---

## 2. Smoke matrix

| Case | Kết quả |
|------|---------|
| Login burst 12 | 403×10 + **429**×2 |
| check-identity burst 22 | 200×20 + **429** |
| Login `{}` + Turnstile required | 403 CAPTCHA |
| 2× worker song song | Batches **disjoint** |
| FORCE_FAIL ×3 | PENDING → PENDING → **FAILED** |
| correlationId trên worker log | ✅ |

---

## 3. Files touched

| File | PR |
|------|-----|
| `src/middlewares/rateLimit.middleware.js` | W4-1 |
| `src/modules/onboarding/onboarding.routes.js` | W4-1 |
| `src/modules/auth/auth.routes.js` | W4-1 |
| `src/modules/auth/auth.controller.js` | W4-2 |
| `prisma/schema` + migration SENDING/locked_at/attempts | pre-W4 / W4-3 |
| `src/jobs/notificationClaim.worker.js` | W4-3, W4-4 |
| `src/jobs/runNotificationWorker.js` | W4-3 |

---

## 4. Runtime notes

| Item | Rule |
|------|------|
| Worker CLI | `node src/jobs/runNotificationWorker.js` |
| Force fail (dev only) | `NOTIF_WORKER_FORCE_FAIL=true` — **cấm** production |
| Turnstile off (dev only) | `TURNSTILE_REQUIRED=false` — **cấm** production |
| Reclaim window | 10 minutes |
| Max attempts | 3 (claim filter `attempts < max`) |
| Channel send thật | Stub SENT; SMTP/Zalo = residual / follow-up |

---

## 5. Residual / backlog

| Hạng mục | Ghi chú |
|----------|---------|
| Channel delivery thật (SMTP, Zalo, …) + `notification_deliveries` | Post-W4 |
| Cron/interval host worker (systemd / Railway / …) | Ops |
| Outbox table riêng | Master: sau worker PENDING ổn |
| Redis L2/L3 | Optional, không block W4 |
| `CHO_KICH_HOAT` enum/ticket | Doc map tạm — tenant enum hiện không có |
| approve `reviewerId`/`adminId` alias (W3) | Pre-existing |
| Xóa block login comment cũ trong controller | Cleanup |
| Members status whitelist 400 | W3 residual |

---

## 6. Pipeline (auth + notif)
