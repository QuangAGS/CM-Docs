# Handoff-W5 — Delegation + Jobs

**PATH**        : docs/handoffs/Handoff-W5.md  
**DATETIME**    : 2026-07-27T19:20:00+07:00  
**VERSION**     : 1.0.0-W5  
**WAVE**        : Wave 5 — on_behalf_of + expire onboarding + temp unlock  
**STATUS**      : DONE  
**SSOT**        : Master Implementation Plan v1.2.0 · SEC Doctrine v1.1 · CED Doctrine v1.1 · OPD v1.2  

**Backend**     : github.com/QuangAGS/cmcodes  
**Docs**        : github.com/QuangAGS/CM-Docs  

---

## 1. Done

### PR-W5-1 — feat(bpl-actor-context)
- `src/shared/constants/bplActions.js`  
  - `DELEGATED_ACTION` · `ONBOARDING_EXPIRED` · `USER_TEMP_UNLOCKED`  
  - Map → `ONBOARDING_CASE_EXPIRE` / `USER_UNLOCK`
- `src/shared/utils/actorContext.js`  
  - `buildActorContext` (SEC D: actor ≠ subject)  
  - `buildJobActorContext` · `toBplMetadata`
- `src/services/bpl.service.js` — `writeBpl` (TX-aware)
- Smoke: node require constants + metadata shape OK

### PR-W5-2 — feat(job-onboarding-expire)
- `src/jobs/onboardingExpire.worker.js` + `runOnboardingExpire.js`
- **Policy (Q1):**  
  - Whitelist: `DRAFT`, `PROFILE_COMPLETED`, `FAMILY_TREE_DRAFT`, `NEEDS_REVISION`  
  - Mốc: `updated_at` + **30 days**  
  - Notif event: `ONBOARDING_CANCELLED` (tạm)
- Batch `LIMIT 100` + `FOR UPDATE SKIP LOCKED`
- **Atomic TX:** `EXPIRED` + `expired_at` + notif `PENDING` + BPL `ONBOARDING_EXPIRED`
- Smoke: seed case 31d → EXPIRED + PENDING notif + BPL JOB_RUNNER

### PR-W5-3 — feat(job-temp-unlock)
- `src/jobs/tempUnlock.worker.js` + `runTempUnlock.js`
- Claim: `locked_until < NOW()`, skip `BI_CAM`
- Restore: `pre_lock_status` || fallback; clear `locked_until` / `pre_lock_status`
- Batch + SKIP LOCKED; BPL `USER_TEMP_UNLOCKED` / `USER_UNLOCK`
- Smoke: `BI_KHOA` + past `locked_until` → `DA_DUYET` + BPL OK

---

## 2. Smoke matrix

| Case | Kết quả |
|------|---------|
| Expire empty queue | claimed=0 |
| Expire 1 DRAFT quá 30d | EXPIRED + notif PENDING + BPL ONBOARDING_CASE_EXPIRE |
| Same correlation_id case↔notif↔BPL metadata | ✅ |
| Temp unlock empty | claimed=0 |
| Temp unlock BI_KHOA hết hạn | → DA_DUYET, lock fields null, BPL USER_UNLOCK |
| BI_CAM | Skip (policy) |

---

## 3. Files touched

| File | PR |
|------|-----|
| `src/shared/constants/bplActions.js` | W5-1 |
| `src/shared/utils/actorContext.js` | W5-1 |
| `src/services/bpl.service.js` | W5-1 |
| `src/jobs/onboardingExpire.worker.js` | W5-2 |
| `src/jobs/runOnboardingExpire.js` | W5-2 |
| `src/jobs/tempUnlock.worker.js` | W5-3 |
| `src/jobs/runTempUnlock.js` | W5-3 |

---

## 4. Runtime / ops

| Job | Lệnh |
|-----|------|
| Notif claim (W4) | `node src/jobs/runNotificationWorker.js` |
| Onboarding expire | `node src/jobs/runOnboardingExpire.js` |
| Temp unlock | `node src/jobs/runTempUnlock.js` |

Schedule (systemd/cron/Railway): interval đề xuất 5–15 phút; **không** chạy job nặng trong request HTTP.

Env dev only: `NOTIF_WORKER_FORCE_FAIL`, `TURNSTILE_REQUIRED=false` — **cấm** production.

---

## 5. Residual / backlog

| Hạng mục | Ghi chú |
|----------|---------|
| Wire `DELEGATED_ACTION` vào `processApproval` / admin paths | Optional follow-up |
| Domain finance adopt CED/SEC | Master optional — không block W5 |
| Notif event riêng `ONBOARDING_EXPIRED` (thay CANCELLED tạm) | Enum + migration nhẹ |
| Channel delivery thật (SMTP/Zalo) trên notif worker | W4 residual |
| Host cron production | Ops |
| Outbox table / Redis | Post-backbone |
| approve reviewerId/adminId (W3) | Pre-existing |

---

## 6. Pipeline jobs
