# TÀI LIỆU TÓM TẮT THỰC HIỆN — WAVE 5 (v1.1 — phản biện tích hợp)

**Delegation \+ Jobs \+ domain seeds**  
Master Implementation Plan v1.2.0 · Q1/Q2 · SSOT: SEC v1.1 · CED v1.1 · OPD v1.2  
Backend: github.com/QuangAGS/cmcodes · Docs: CM-Docs  
Wave trước: W4 DONE  
---

### Bối cảnh

| Mục tiêu W5 | `on_behalf_of`, job expire onboarding / temp unlock (batch \+ atomic), BPL constants; optional finance CED |
| :---- | :---- |
| Không làm | Outbox table mới, Redis bắt buộc, rewrite auth core |

### Bảng bước thực hiện (đã chỉnh)

| \# | Bước thực hiện | Đầu ra | Loại | Ghi chú |
| ----- | ----- | ----- | ----- | ----- |
| **W5.0** | Baseline as-is | BPL, onboarding `EXPIRED`/`expired_at`, `users.locked_until` | Kiểm tra | `actor_type`: USER / SYSTEM / JOB\_RUNNER / CRON |
| **W5.1** | **`on_behalf_of` (SEC D)** | Helper \+ middleware context | Tạo mới / nâng cấp | `actor_id` \= người auth; `on_behalf_of` \= subject; **không** ghi đè `req.user.userId` |
| **W5.2** | BPL **actor\_context** \+ **Action Constants** | Constants module \+ metadata chuẩn | **Nâng cấp** | Constants (bắt buộc): `DELEGATED_ACTION`, `ONBOARDING_EXPIRED`, `USER_TEMP_UNLOCKED`. Metadata: `{ actor_type, actor_id, on_behalf_of?, correlation_id }` |
| **W5.3** | Job **expire onboarding** | `src/jobs/onboardingExpire.worker.js` | Tạo mới | **Batch LIMIT 100–500**. Mỗi case: **1 DB TX** \= `status=EXPIRED` \+ `expired_at` \+ **INSERT notification PENDING** (+ `correlation_id`). Claim: `FOR UPDATE SKIP LOCKED` nếu batch |
| **W5.4** | Job **temp unlock** | `src/jobs/tempUnlock.worker.js` | Tạo mới | **Batch LIMIT 100–500**. Unlock hết `locked_until`; **không** unlock `BI_CAM` vĩnh viễn. BPL action **`USER_TEMP_UNLOCKED`**, `actor_type=JOB_RUNNER` |
| **W5.5** | Wire CLI / ops note | `run*.js` \+ Handoff schedule | Nâng cấp | Tách khỏi web process |
| **W5.6** | Optional finance CED seed | 1–2 endpoint | Optional | Không block exit |
| **W5.7** | Smoke \+ Exit | SQL \+ 2 worker | Test | Bảng Exit |
| **W5.8** | Handoff-W5 | `docs/handoffs/Handoff-W5.md` | Tạo mới | Q2 |

### W5.2 — BPL Action Constants (chuẩn hóa)

JavaScript

```
// src/shared/constants/bplActions.js (gợi ý)
const BPL_ACTIONS = Object.freeze({
  DELEGATED_ACTION: 'DELEGATED_ACTION',       // admin on_behalf_of
  ONBOARDING_EXPIRED: 'ONBOARDING_EXPIRED', // job expire case
  USER_TEMP_UNLOCKED: 'USER_TEMP_UNLOCKED', // job temp unlock
});
// Dùng kèm process_type enum hiện có (ONBOARDING_CASE_EXPIRE, USER_UNLOCK, …)
```

Tránh synonym lệch: không ghi lẫn EXPIRE\_CASE / ONBOARDING\_EXPIRED giữa các module.

### W5.3 — Atomic expire \+ notif \+ batch

LOOP batch (LIMIT 100..500, SKIP LOCKED):  
  BEGIN;  
    UPDATE onboarding\_cases  
      SET status \= 'EXPIRED', expired\_at \= now(), ...  
      WHERE id \= :id AND status IN (...whitelist...);  
      INSERT notifications (… status='PENDING', correlation\_id, event\_type=…);  
      INSERT business\_process\_logs (process\_type / action ONBOARDING\_EXPIRED, actor\_type=JOB\_RUNNER, …);  
  COMMIT;

| Rule | Chi tiết |
| ----- | ----- |
| Atomic | Case \+ PENDING notif (+ BPL) **cùng TX** — chống crash giữa chừng |
| Batch | **Cấm** `UPDATE` không LIMIT trên toàn bộ DRAFT quá hạn |
| Status whitelist | Chỉ case được phép expire (DRAFT / NEEDS\_REVISION / … theo policy) — không đụng MERGED/APPROVED |

### W5.4 — Temp unlock \+ batch

text

```
LOOP batch (LIMIT 100..500):
  SELECT id … WHERE locked_until < NOW() AND status phù hợp
    [FOR UPDATE SKIP LOCKED]
  UPDATE clear lock / restore pre_lock_status
  BPL: USER_TEMP_UNLOCKED, actor_type=JOB_RUNNER
```

| Rule | Chi tiết |
| ----- | ----- |
| Batch | LIMIT 100–500 — tránh lock bảng `users` lâu |
| Permanent ban | `BI_CAM` / flag vĩnh viễn → **skip** |

### PR chain

| PR | Nội dung |
| ----- | ----- |
| **PR-W5-1** | `on_behalf_of` context \+ BPL constants (`DELEGATED_ACTION`, …) |
| **PR-W5-2** | onboarding expire worker — **batch \+ TX atomic** case+notif |
| **PR-W5-3** | temp unlock worker — **batch** \+ `USER_TEMP_UNLOCKED` |
| **PR-W5-4** | Handoff-W5 (+ optional finance) |

### 

### Exit Criteria W5

| Case | Kỳ vọng |
| ----- | ----- |
| Delegated action | BPL/metadata: actor \+ `on_behalf_of` \+ correlation\_id; action `DELEGATED_ACTION` |
| Expire 1 case | TX: case `EXPIRED` **và** notif `PENDING` cùng lúc; action `ONBOARDING_EXPIRED` |
| Expire crash giữa TX | Không case EXPIRED mà thiếu notif (atomic) |
| Batch 100k draft | Mỗi sweep ≤ LIMIT; web request không treo |
| Temp unlock | Hết hạn → unlock \+ `USER_TEMP_UNLOCKED`; còn hạn / BI\_CAM → không đụng |
| 2 worker song song | SKIP LOCKED — không double-process cùng id |
| Regression W2–W4 | Login / tenant gate / notif claim OK |

### Rủi ro & giảm thiểu (cập nhật)

| Rủi ro | Giảm thiểu |
| :---- | :---- |
| Expire \+ notif đứt TX | W5.3 atomic |
| Table lock / lag web | Batch LIMIT 100–500 |
| BPL tên loạn | Constants W5.2 |
| Subject \= actor trong JWT | Chỉ context/metadata |
| Unlock ban vĩnh viễn | Skip BI\_CAM / permanent |

### 

### Thay đổi so với bản tóm tắt trước (phản biện)

1. **W5.3** — Atomic TX (EXPIRED \+ PENDING notif) \+ **batch LIMIT**.  
2. **W5.4** — **Batch LIMIT** \+ BPL USER\_TEMP\_UNLOCKED.  
3. **W5.2** — Constants: DELEGATED\_ACTION, ONBOARDING\_EXPIRED, USER\_TEMP\_UNLOCKED.

### 

