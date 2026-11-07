# HandOver — BFA 2.2.2 B3 / A01 Business Ledger

**PATH** : CM-Docs/HandOver-BFA-222-B3-A01-BL-2026-09-01  
**DATETIME** : 2026-09-01T17:25:00+07:00  
**VERSION** : 1.0.0  
**REPO** : QuangAGS/cmcodes (`profile.service.js` sạch trên main)  
**SSOT** : BFA-Post-OP-myClan-v2.2.2-Amendment (DRAFT-2)  
**Q1** : Không mở RP / OP / SM CLOSED.

---

## 1. Phạm vi đóng

A01 `/me` ghi **Business Ledger** khi đổi trạng thái hồ sơ / địa chỉ gắn member / thành tích.  
**CL = NONE** — không orchestrator, không silentIntent, không Zalo/mail.

## 2. Đã xong

| Hạng | Ghi chú |
|---|---|
| Enum `business_process_type` | `MEMBER_PROFILE_PATCH`, `ACHIEVEMENT_UPSERT`, `ACHIEVEMENT_DELETE`, `MEMBER_ADDRESS_LINK` + migration ADD VALUE |
| `businessLogSchemas.js` | Contract 4 mã; A01 nằm **trong** object |
| `bpl.service.js` 1.1.0 | Cửa BL: bắt `tx`, schema, `correlation_id`, `actor_id`; không nuốt lỗi |
| `ledger.service.js` 1.2.0 | Wrapper → `writeBpl` |
| `profile.service.js` 1.3.0-BFA-222-B3 | Một vòng upsert; một `correlation.create()`; `attempt_no` 1..n; `address_id` từ upsert |
| `achievements.service.js` | TX + `writeBpl` UPSERT/DELETE (kiểm `correlation.create()`, không `crypto`) |

GET `/me/profile`, search address: **không** BL.

## 3. Quy ước vận hành A01

- Vết: `correlation.create()` (`prisma.js`).  
- Nhiều dòng BPL cùng request: **cùng** `correlation_id`, **khác** `attempt_no`.  
- Fail `writeBpl` → fail command (cùng `$transaction`).  
- Không `findUnique` inject tenant; không sửa `users.phone` / `gender` / `is_alive`.

## 4. UAT tối thiểu (còn lại nếu chưa chạy)

- [ ] PATCH hồ sơ không địa chỉ → 1 hàng `MEMBER_PROFILE_PATCH`  
- [ ] PATCH kèm quê + cư trú → thêm `MEMBER_ADDRESS_LINK` attempt kế tiếp, `payload.address_id` ≠ null  
- [ ] POST/PATCH/DELETE thành tích → `ACHIEVEMENT_*`  
- [ ] Không insert `notifications`  
- [ ] `grep writeBpl` / `createLog(` trên auth/onboarding: caller CLOSED **phải có `tx`** (B1 toàn cục — nợ nếu chưa rà)

## 5. Nợ — không thuộc HandOver này

- B4/B5 CL / silentIntent  
- Hash chain VOL I-03  
- `writeBpl` bắt `tx` vs caller RP cũ  
- Avatar, member đã mất, proof/duyệt thành tích  
- FE `AchievementSection.jsx` nhầm cây `Backend/src/modules/members/` (dọn khi lát FE)

## 6. Next

Đóng B3 sau khi tick mục 4.  
Lát tiếp: **không** CL. Chọn HandOver đóng hẳn hoặc P1 avatar / mục hồ sơ khác.

**RP/OP CLOSED. Không mở lại SM.**
