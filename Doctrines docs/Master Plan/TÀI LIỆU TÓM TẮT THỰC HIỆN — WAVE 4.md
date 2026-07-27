# TÀI LIỆU TÓM TẮT THỰC HIỆN — WAVE 4 (v1.1 — phản biện tích hợp)

**Harden \+ Notification worker lock**

Master Plan v1.2.0 · Q1/Q2 · SSOT: SEC v1.1 · CED v1.1 · OPD v1.2

**Backend:** github.com/QuangAGS/gia-pha-backend · **Docs:** CM-Docs

---

### **Bối cảnh**

| Wave trước | W3 DONE |
| :---- | :---- |
| **Mục tiêu W4** | Harden entry (rate/guard/Turnstile) \+ worker PENDING multi-instance an toàn (**SKIP LOCKED** \+ **reclaim** \+ **max retry** \+ **correlation\_id**) |
| **Không làm** | Outbox table riêng, Redis bắt buộc, W5 delegation/jobs domain |

---

### **Bảng bước thực hiện (đã chỉnh)**

| \# | Bước thực hiện | Đầu ra | Loại | Ghi chú |
| ----- | ----- | ----- | ----- | ----- |
| **W4.0** | Baseline as-is | rateLimit, securityGuard, Turnstile, schema notifications | Kiểm tra | Có status, correlation\_id, locked\_at, attempts (hoặc cần migration nhẹ) |
| **W4.1** | Rate limit entry nhạy | rateLimit.middleware \+ auth/onboarding routes | Nâng cấp | login/register/OTP/reset/onboarding POST; theo securityConfig |
| **W4.2** | securityGuard nhạy | securityGuard \+ routes admin | Nâng cấp | Threshold/reasonCode ổn định |
| **W4.3** | Turnstile theo config | auth controller \+ securityConfig | Nâng cấp | **Cấm** TEMP bypass trên main |
| **W4.4** | PENDING worker \+ **correlation\_id** \+ **attempts** | Worker service/job | Tạo mới / nâng cấp | Insert PENDING từ API **bắt buộc** correlation\_id \= req.correlationId. Schema/logic: attempts (default 0), locked\_at, failed\_reason. Worker log **luôn** kèm correlation\_id (CED W1.0) |
| **W4.5** | Claim **FOR UPDATE SKIP LOCKED** | Raw SQL / Prisma $queryRaw trong TX | Tạo mới / nâng cấp | Claim PENDING → set SENDING \+ locked\_at → commit → send → SUCCESS/FAILED/PENDING |
| **W4.5b** | **Reclaim stuck SENDING** | Cùng query claim / job reclaim | **Bổ sung phản biện** | Row SENDING \+ locked\_at \< NOW() \- INTERVAL '10 minutes' được coi zombie → claim lại (cùng SKIP LOCKED). Chống worker crash/OOM kẹt vĩnh viễn |
| **W4.6** | Fail path \+ **Max Retry** | Worker error handler | Nâng cấp | Fail gửi: attempts \+= 1\. Nếu attempts \>= max\_retries (vd. **3**) → **FAILED** \+ failed\_reason; ngược lại → **PENDING** (retry). SMTP/channel fail **không** xóa row |
| **W4.7** | Optional Redis L2/L3 | flag | Optional | Không block exit |
| **W4.8** | CHO\_KICH\_HOAT map/ticket | Doc | Doc | Ghi Handoff |
| **W4.9** | Smoke \+ Exit | curl \+ 2 worker giả | Test | Bảng Exit |
| **W4.10** | Handoff-W4 | docs/handoffs/Handoff-W4.md | Tạo mới | Q2 |

---

### **Claim SQL (W4.5 \+ W4.5b — normative)**

SQL

```
BEGIN;

SELECT id, correlation_id, attempts
FROM notifications
WHERE status = 'PENDING'
   OR (status = 'SENDING' AND locked_at < NOW() - INTERVAL '10 minutes')
ORDER BY created_at
LIMIT $N
FOR UPDATE SKIP LOCKED;

UPDATE notifications
SET status = 'SENDING',
    locked_at = NOW()
WHERE id = ANY($ids);

COMMIT;
-- Gửi channel ngoài TX ngắn; cập nhật SUCCESS / FAILED / PENDING + attempts
```

| Rule | Chi tiết |
| ----- | ----- |
| Multi-instance | Chỉ **SKIP LOCKED** — cấm claim bằng UPDATE WHERE PENDING không lock |
| Zombie | SENDING quá 10 phút → reclaim |
| Max retry | attempts \>= 3 → FAILED \+ reason; else PENDING |
| Observability | Mọi log worker gắn correlation\_id của row |

---

### **PR chain W4**

| PR | Nội dung |
| ----- | ----- |
| **PR-W4-1** | rateLimit \+ securityGuard entry nhạy |
| **PR-W4-2** | Turnstile theo securityConfig; strip TEMP |
| **PR-W4-3** | Worker claim SKIP LOCKED \+ **reclaim SENDING** \+ correlation\_id / attempts schema |
| **PR-W4-4** | Fail path **max retry** → FAILED; SMTP fail không mất row |
| **PR-W4-5** | Handoff-W4 \+ CHO\_KICH\_HOAT note |

---

### **Exit Criteria W4**

| Case | Kỳ vọng |
| ----- | ----- |
| Rate limit login/register | Hợp lý; không 429 nhầm single elderly |
| Turnstile main | Không TEMP bypass |
| 2 worker \+ 1 PENDING | **1** lần send only |
| Worker crash sau SENDING | Sau 10p row được **reclaim** → gửi lại hoặc FAILED theo attempts |
| SMTP fail, attempts \< 3 | PENDING \+ attempts++ |
| SMTP fail, attempts ≥ 3 | **FAILED** \+ failed\_reason |
| Insert PENDING từ Approve/… | Có **correlation\_id** |
| Worker log | Có correlation\_id |
| Regression W2/W3 | Assert Order \+ tenant gate OK |

---

### **Rủi ro & giảm thiểu (cập nhật)**

| Rủi ro | Giảm thiểu |
| ----- | ----- |
| Zombie SENDING | **W4.5b** reclaim locked\_at \+ 10m |
| Retry vô hạn email chết | **W4.6** max\_retries → FAILED |
| Mất trace HTTP → worker | **W4.4** bắt buộc correlation\_id |
| Double send multi-instance | SKIP LOCKED |
| Rate siết UX | securityConfig \+ review tay |

---

### **Thay đổi so với bản tóm tắt trước (phản biện)**

1. **W4.5b** Reclaim stuck SENDING (locked\_at timeout) — bước chính thức.  
2. **W4.6** Max retry (attempts \>= 3 → FAILED).  
3. **W4.4** Bắt buộc correlation\_id \+ attempts trên notification PENDING / worker log.

---

**Q1:** Confirm v1.1 trước gen bulk (đặc biệt migration cột locked\_at / attempts nếu schema chưa có).  
**Q2:** Header \+ Handoff-W4.

# \*\*TÀI LIỆU TÓM TẮT THỰC HIỆN — WAVE 4 (V1.0)\*\*  

\*\*Harden \+ Notification worker lock\*\*    
Master Plan v1.2.0 · Q1/Q2 · SSOT: SEC v1.1 · CED v1.1 · OPD v1.2  

\*\*Backend:\*\* \`github.com/QuangAGS/gia-pha-backend\` · \*\*Docs:\*\* \`CM-Docs/Doctrines docs\`

\---

\#\#\# Bối cảnh

| | |  
|--|--|  
| \*\*Wave trước\*\* | W3 DONE (tenantStatus Light/Heavy, whitelist activate, CED-4 onboarding, members filter CHINH\_THUC) |  
| \*\*Mục tiêu W4\*\* | Cứng hóa entry (rate / guard / Turnstile) \+ worker gửi notif \*\*PENDING\*\* an toàn multi-instance (\*\*FOR UPDATE SKIP LOCKED\*\*) |  
| \*\*Không làm trong W4\*\* | Outbox table riêng (sau worker PENDING), Redis bắt buộc, delegation (W5), domain finance adopt |

\---

\#\#\# Bảng bước thực hiện

| \# | Bước thực hiện | Đầu ra (path / files / codes) | Loại đầu ra | Ghi chú / giải thích |  
|---|----------------|-------------------------------|-------------|----------------------|  
| \*\*W4.0\*\* | Baseline as-is | rateLimit / securityGuard / Turnstile / notifications | Kiểm tra | Xác định route đã gắn limiter; worker notif hiện có hay chưa; schema \`notifications.status\` |  
| \*\*W4.1\*\* | Rate limit entry nhạy | \`rateLimit.middleware.js\`, \`auth.routes\`, \`onboarding.routes\` | \*\*Nâng cấp\*\* | Bổ sung / thống nhất limiter cho login, register, OTP/reset, onboarding POST nhạy. Config theo \`securityConfig\` — \*\*không\*\* siết elderly UX quá mức |  
| \*\*W4.2\*\* | securityGuard nhạy | \`securityGuard.middleware.js\` \+ routes | \*\*Nâng cấp\*\* | \`restrictSuspiciousActivity\` trên query-reviewable / process-approval / onboarding admin (đã có một phần) — rà soát threshold, reasonCode |  
| \*\*W4.3\*\* | Turnstile theo securityConfig | \`auth.controller\`, optional onboarding entry, \`securityConfig\` | \*\*Nâng cấp\*\* | Bật/tắt theo env; \*\*cấm\*\* TEMP bypass trên main; siteverify action khớp (login/register) |  
| \*\*W4.4\*\* | PENDING notification worker | \`notifications\` worker / job script / service | \*\*Tạo mới hoặc nâng cấp\*\* | Claim rows \`status=PENDING\` → gửi channel → \`SUCCESS\`/\`FAILED\`. Ghi \`correlation\_id\` / idempotent key |  
| \*\*W4.5\*\* | \*\*SKIP LOCKED\*\* (v1.2 \*\*normative\*\*) | Worker claim SQL (Prisma \`$queryRaw\` hoặc tương đương) | \*\*Tạo mới / nâng cấp\*\* | Trong \*\*transaction\*\*: \`SELECT … FOR UPDATE SKIP LOCKED\` → cập nhật \`SENDING\`/\`LOCKED\` → commit → send → \`SUCCESS\`/\`FAILED\`. \*\*Cấm\*\* claim bằng \`UPDATE … WHERE PENDING\` không lock khi multi-instance |  
| \*\*W4.6\*\* | SMTP/channel fail không mất row | Worker error path | \*\*Nâng cấp\*\* | Fail gửi → row \*\*không\*\* mất; về \`PENDING\` (retry) hoặc \`FAILED\` có reason; critical notif không “bay” im lặng |  
| \*\*W4.7\*\* | Optional Redis L2/L3 | feature flag | \*\*Optional\*\* | Chỉ khi flag on; không block exit W4 |  
| \*\*W4.8\*\* | \`CHO\_KICH\_HOAT\` map/ticket | Doc / migration ticket | \*\*Doc\*\* | Map tạm hoặc ticket migration; ghi Handoff |  
| \*\*W4.9\*\* | Smoke \+ Exit W4 | curl \+ 2 worker giả lập | \*\*Test\*\* | Xem Exit Criteria |  
| \*\*W4.10\*\* | Handoff-W4 | \`docs/handoffs/Handoff-W4.md\` | \*\*Tạo mới\*\* | Q2: done / residual / next / SHAs / doctrine pins |

\---

\#\#\# PR chain gợi ý (W4)

| PR | Nội dung |  
|----|----------|  
| \*\*PR-W4-1\*\* | \`feat(rate-guard-entry)\`: rateLimit \+ securityGuard trên entry nhạy (auth OTP, onboarding POST) |  
| \*\*PR-W4-2\*\* | \`feat(turnstile-config)\`: Turnstile theo securityConfig; strip TEMP bypass |  
| \*\*PR-W4-3\*\* | \`feat(notif-worker-claim)\`: worker PENDING \+ \*\*FOR UPDATE SKIP LOCKED\*\* \+ status transition |  
| \*\*PR-W4-4\*\* | \`fix(notif-fail-path)\`: SMTP fail → FAILED/PENDING retry; không mất row |  
| \*\*PR-W4-5\*\* | \`docs(Handoff-W4)\` \+ optional CHO\_KICH\_HOAT note |

\---

\#\#\# W4.1 — Claim lock (Master v1.2 \*\*LOCKED\*\*)

\`\`\`text  
BEGIN;  
  SELECT id FROM notifications  
  WHERE status \= 'PENDING'  
  ORDER BY created\_at  
  LIMIT N  
  FOR UPDATE SKIP LOCKED;

  UPDATE notifications SET status \= 'SENDING', locked\_at \= now()  
  WHERE id IN (...);  
COMMIT;

\-- ngoài TX hoặc TX ngắn: gửi channel  
\-- thành công → SUCCESS; lỗi → FAILED hoặc PENDING \+ attempt++  
\`\`\`

| Sai | Đúng |  
|-----|------|  
| \`UPDATE … WHERE status='PENDING' LIMIT 1\` (không lock) | \`FOR UPDATE SKIP LOCKED\` |  
| 2 instance cùng claim 1 id | Chỉ 1 instance nhận row |

\---

\#\#\# Exit Criteria W4

| Case | Kỳ vọng |  
|------|---------|  
| Login/register vẫn có rate limit hợp lý | Không 429 nhầm elderly single-user |  
| Turnstile production path | Không TEMP \`{ success: true }\` trên main |  
| 1 PENDING \+ 2 worker song song | \*\*Chỉ 1\*\* lần send (SKIP LOCKED) |  
| SMTP/provider fail | Row \*\*còn\*\*; status FAILED hoặc PENDING retry |  
| Critical notif (approve/reject/merge/activate) | Vẫn tạo PENDING trong TX nghiệp vụ (W3/OPD) \+ worker xử lý |  
| Login regression W2/W3 | Assert Order \+ tenant gate \*\*không regress\*\* |

\---

\#\#\# Rủi ro & giảm thiểu

| Rủi ro | Giảm thiểu |  
|--------|------------|  
| Rate limit chặn UX người cao tuổi | Threshold theo \`securityConfig\`; review tay |  
| Double email multi-instance | SKIP LOCKED \*\*bắt buộc\*\* (W4.5) |  
| Worker crash giữa SENDING và send | Timeout reclaim SENDING → PENDING; documented |  
| Turnstile localhost | Env flag dev only; không commit bypass |  
| Scope outbox table sớm | \*\*Không\*\* dựng outbox table trong W4 — chỉ PENDING worker |

\---

\#\#\# Residual sau W4 (→ W5 / backlog)

\- Outbox table / event bus riêng    
\- Redis L2/L3 production    
\- Delegation \`on\_behalf\_of\` (W5)    
\- Jobs expire onboarding / temp unlock (W5)    
\- Approve \`reviewerId\`/\`adminId\` alias (W3 residual)

\---

\#\#\# Dependency (Master)

\`\`\`text  
W0 → W1 → W2 → W3 → W4 (harden \+ worker lock) → W5 (delegation/jobs/domain)  
\`\`\`

Cấm đảo: worker multi-instance \*\*không\*\* SKIP LOCKED.

\---

\*\*Q1:\*\* Confirm diff trước gen bulk (đặc biệt raw SQL claim).    
\*\*Q2:\*\* Header \+ Handoff-W4 mỗi PR.

