# FE – Onboarding Process (OP / MEMBER_PROMOTE)

**Document ID:** FE-OP-MEMBER_PROMOTE  
**Date:** 2026-08-16  
**Status:** Approved direction (B1 checklist locked; implementation not started)  
**Repos:** QuangAGS/cmcodes · CM-Docs  
**Related:**  
- HandOver-RP-process-kind-BPL-2026-08-16  
- HandOver-Close-C6-2026-08-15  
- MemberPromote.definition.js (BE SRPF)  
- SSOT + Q1/Q2  

---

## 1. Purpose

Tài liệu này là **SSOT phía FE** cho mọi công việc liên quan Onboarding Process (OP), phân biệt với Register Process (RP).

OP = quy trình member `DU_BI` → hoàn thiện hồ sơ → xét duyệt → `CHINH_THUC`,  
phân biệt bằng `process_kind = MEMBER_PROMOTE`.

Mọi PR / page / form OP phải tuân thủ tài liệu này trừ khi có handoff mới ghi đè.

---

## 2. Business summary (FE-relevant)

| Item | Rule |
|------|------|
| process_kind | `MEMBER_PROMOTE` (OP) vs `REGISTER` (RP) |
| case_type | `MEMBER_JOIN` \| `CLAN_SETUP` |
| Entry | member.status = `DU_BI` (user thường đã `DA_DUYET` sau RP) |
| Goal | Base Profile đủ → Submit → Review → Approve → member `CHINH_THUC` |
| APPROVE side-effect (BE) | Chỉ đổi member → `CHINH_THUC`; **không** auto CLAN_ADMIN |
| Approver | CLAN_ADMIN: MEMBER_JOIN (tenant HOAT_DONG). SYSTEM_ADMIN: CLAN_SETUP (và có thể MEMBER_JOIN tùy policy) |
| Base Profile hard (APPROVE) | full_name, gender, is_alive, birth_year, birth_month, birth_day |
| generation | Hard nếu CLAN_SETUP; khuyến nghị nếu MEMBER_JOIN |

States (SRPF): DRAFT → SUBMITTED → UNDER_REVIEW → NEEDS_REVISION \| APPROVED \| REJECTED \| CANCELLED.

---

## 3. Design principles (bắt buộc)

### 3.1 Q1 – Bảo toàn

- Không phá RP auth, WaitingPage, ResultPage, Admin RP approval hiện tại.
- Không phình `auth.service` bằng logic OP.
- Không trộn API cây phả hệ (`/members` tree) vào hub OP như nguồn sự thật của quy trình.

### 3.2 Q2 – Doc format

- Mọi file mới/sửa: header `PATH` / `DATETIME` / `VERSION` / `DESCRIPTION`.
- Không sinh code khi chưa có plan + xác nhận.

### 3.3 Mobile-first

- `max-w-[480px]`, card/nút lớn, touch-friendly.

### 3.4 Elder Support (điều kiện chấp nhận trang)

| Component | Role |
|-----------|------|
| **AudioHelpButton** | Thay online help. Tóm tắt **toàn page/form**: dùng để làm gì + bước chính. User bấm mới đọc. |
| **AttentionZone** | Chia **từng khối** mục đích cụ thể; mỗi khối có thông điệp ngắn. |
| **ZoneVoiceButton** | User bấm để máy đọc thông điệp của **khối** đó. |
| **FormErrorSpeaker** | Đọc lỗi đã được **biến đổi thân thiện + an toàn** (không đọc nguyên văn BE). |

Mọi trang OP (hub, form, sau này report) phải có đủ 4 thành phần đúng vai trò trên.

### 3.5 Message tập trung

- Chuỗi hướng dẫn / lỗi thân thiện quản lý tập trung (cùng tinh thần auth/RP).
- UI không hiện mã trạng thái thô (DRAFT/SUBMITTED) cho end-user; dùng ngôn ngữ đời thường.

---

## 4. Architecture decisions (locked)

### 4.1 Module boundary

| Concern | Module |
|---------|--------|
| Login, /me, token, user lifecycle | auth |
| OP case, my-op, profile OP, submit/approve MEMBER_PROMOTE | **onboarding** |
| Tree / generic member CRUD | members |

### 4.2 `GET /onboarding/my-op` (phương án B)

**Lý do:** OP là module riêng; không phụ thuộc API cây; không nhồi vào auth.

**Contract (tái sử dụng được cho process khác):**

```text
GET /onboarding/my-op
Auth: Bearer token

data:
  hasOpen: boolean
  process_kind: "MEMBER_PROMOTE" | null
  case: { id, status, case_type, process_kind } | null
  primary: { id, status, full_name, gender, is_alive,
             birth_year, birth_month, birth_day, generation, ... } | null
  completeness: { complete: boolean, missingFields: string[] } | null
```

- `hasOpen: false` khi không có OP hợp lệ / không còn trong quy trình.
- Implement trong **onboarding only**; tái sử dụng `findOpenOpCase` / load member hiện có.
- **Không** sửa `auth.service.js` cho endpoint này.

### 4.3 Shared vs OP-specific

| Shared (giữ / tái sử dụng) | OP-specific |
|----------------------------|-------------|
| AudioHelpButton, AttentionZone, ZoneVoiceButton, FormErrorSpeaker, useTts | Copy text / cấu trúc khối từng page |
| SRPF find-open helper, ProcessInstanceLoader patterns | Filter `MEMBER_PROMOTE`, case_type |
| Contract shape “my-open process” | Path `/onboarding/my-op` |
| — | Base Profile form fields & copy |

Không tạo UniversalProcessHub trong B1. Extract layout shared chỉ khi lặp ≥ 2–3 trang thật sự.

### 4.4 FE surface

| Route | Page | Actor |
|-------|------|--------|
| `/op` | OpHubPage (trang trung gian member) | Member DU_BI |
| `/op/base-profile` | OpBaseProfilePage + BaseProfileForm | Member DU_BI |
| `/admin` + approval (mở rộng sau) | AdminWorkSelector + AdminUserApprovalPage | SYSTEM_ADMIN / CLAN_ADMIN |

- Hub member **tách** khỏi AdminWorkSelector (mental model khác).
- Approver: **mở rộng** AdminUserApprovalPage (tab/filter OP), work item label thống nhất: **“Phê duyệt MEMBER_JOIN (OP)”** (tránh nhầm CLAN_SETUP trong RP).

### 4.5 Redirect sau login

- Admin → `/admin` (giữ).
- User thường: có thể vào `/op`; **OpProtectedRoute + my-op** quyết định ở lại hay đẩy `/tree`.
- Không nhồi business OP vào BE auth.service.

---

## 5. Page specs (Elder Support)

### 5.1 OpHubPage (`/op`)

- **AudioHelpButton:** tóm tắt trang (danh sách việc cần làm để được xét duyệt thành viên chính thức).
- **AttentionZone** theo từng việc (bắt buộc đầu tiên: Hoàn thiện Hồ sơ cơ sở) + thông điệp ngắn + **ZoneVoiceButton**.
- Trạng thái bằng lời: Chưa đủ / Đã đủ / Đang chờ duyệt / Cần bổ sung…
- Footer: Trang chủ | Đăng xuất (và quay hub từ trang con).
- Config-driven work items (`opWorkItems.js`).

### 5.2 Base Profile (`/op/base-profile`)

- File form **mới**; tái sử dụng pattern code hữu ích từ Register/Join/Waiting (không copy-paste mù).
- **AudioHelpButton:** mục đích trang + Lưu nháp / Gửi duyệt.
- **AttentionZone** theo khối: Thông tin cơ bản | Ngày sinh | Thế hệ… + **ZoneVoiceButton**.
- **FormErrorSpeaker** cho lỗi đã làm sạch.
- Actions: SAVE_DRAFT, SUBMIT (qua API onboarding hiện có).
- Sau thành công: quay `/op` / trang chủ / logout.

### 5.3 Admin (phase sau B1)

- Work item: “Phê duyệt MEMBER_JOIN (OP)” cho SYSTEM_ADMIN và CLAN_ADMIN (đúng policy tenant).
- SYSTEM_ADMIN hub: nên chia **AttentionZone** rõ (Phê duyệt thành viên RP | Dòng họ chờ kích hoạt | Phê duyệt MEMBER_JOIN OP); danh sách dài **thu gọn được** trên mobile.
- Relogin khi duyệt: ghi nhận là UX defect — điều tra token/session/redirect (phase riêng).

---

## 6. Phased delivery

| Phase | Scope | Status |
|-------|--------|--------|
| **B0** | Survey components, auth/me, member API, onboarding routes | Done 2026-08-16 |
| **B1** | `GET /onboarding/my-op` + routes `/op` + OpProtectedRoute + skeleton | Checklist approved |
| **B1 UI** | OpHubPage + BaseProfileForm đầy đủ Elder Support + API wire | Next after B1 skeleton |
| **B2** | Admin filter/tab OP + approve/reject/revision trên Approval hiện có | Planned |
| **B3** | Timeline BPL (`payload.action`), card phụ (tiểu sử, thành tích…) | Later |

### B1 implementation order

1. BE `GET /onboarding/my-op` (contract trên)
2. FE routes + OpProtectedRoute + page skeleton
3. Redirect login tối thiểu (nếu cần)
4. Hub + Base Profile UI (Elder Support) — bước riêng sau skeleton

**Không sinh code** khi chưa có xác nhận từng nhóm file (thói quen dự án).

---

## 7. File map (dự kiến)

### New (FE)

- `frontend/src/pages/OpHubPage.jsx`
- `frontend/src/pages/OpBaseProfilePage.jsx`
- `frontend/src/features/onboarding/components/BaseProfileForm.jsx`
- `frontend/src/features/onboarding/constants/opWorkItems.js`
- (optional) `OpProtectedRoute` trong `App.jsx` hoặc `components/routes/`

### Touch (FE, tối thiểu)

- `frontend/src/App.jsx` — routes
- `frontend/src/context/AuthContext.jsx` — redirect tối thiểu only

### New/Touch (BE, onboarding only)

- `onboarding.routes.js` — `GET /my-op`
- `onboarding.controller.js` — `getMyOp`
- service nhỏ (onboarding.service hoặc `srpf/services/getMyOpInstance.js`)

### Do not touch for OP core

- `auth.service.js` (không thêm my-op)
- WaitingPage / ResultPage / RP forms (trừ khi handoff riêng)
- Member tree APIs as process SSOT

### Elder components (reuse paths)

- AudioHelpButton — `features/a11y/tts/AudioHelpButton.jsx` (verify path in repo)
- AttentionZone — `components/AttentionZone.jsx`
- ZoneVoiceButton — `features/elder-doctrine/components/ZoneVoiceButton.jsx`
- FormErrorSpeaker — `features/elder-doctrine/components/FormErrorSpeaker.jsx`

---

## 8. API map (existing + new)

| API | Role in OP FE |
|-----|----------------|
| `GET /onboarding/my-op` | **New** – hub + guard |
| `POST /onboarding/cases` | Tạo/mở case nếu cần |
| `POST /onboarding/profile` | completeProfile / Base Profile |
| `POST /onboarding/cases/:caseId/submit` | SUBMIT |
| `POST /onboarding/cases/:caseId/cancel` | Cancel |
| `POST .../review/start`, `/revision`, `/approve`, `/reject` | Approver (B2) |
| `GET /auth/me` | member_id, user status (không thay my-op) |
| `GET /members/:id` | Không dùng làm SSOT quy trình OP |

---

## 9. Acceptance criteria (B1 skeleton)

- [ ] `GET /onboarding/my-op` trả đúng contract; không đụng auth.service
- [ ] `/op` protected; chưa login → `/auth`
- [ ] Admin login vẫn `/admin`
- [ ] User có OP mở (DU_BI) vào được `/op`
- [ ] User không có OP không kẹt tại `/op`
- [ ] Q1: RP + admin RP không regress

Acceptance UI đầy đủ (Elder 4 components, form, submit) thuộc phase B1 UI — checklist riêng khi triển khai.

---

## 10. Open items / risks

| Item | Note |
|------|------|
| Relogin khi admin duyệt | UX defect; điều tra sau B1 |
| Admin SYSTEM_ADMIN list không collapsible | Cải thiện mobile + AttentionZone 3 khối |
| `/auth/me` thiếu member.status | Cố ý; dùng my-op |
| Generation UX copy | Phân biệt CLAN_SETUP vs MEMBER_JOIN trên form |
| Label admin work item | Thống nhất “Phê duyệt MEMBER_JOIN (OP)” |

---

## 11. Checklist Bước 1 + skeleton BE (locked 2026-08-16)

### A. BE – `GET /onboarding/my-op`

- [ ] Path + auth + response shape đúng mục 4.2
- [ ] `onboarding.routes.js` / `controller` / service nhỏ (không đụng auth.service)
- [ ] Tái sử dụng findOpenOpCase / load member
- [ ] Header Q2
- [ ] Done: DU_BI + case mở → hasOpen true; không OP → hasOpen false

### B. FE – Routing & Guard

- [ ] Routes `/op`, `/op/base-profile` trong App.jsx
- [ ] OpProtectedRoute (không sửa ProtectedRoute / AdminProtectedRoute)
- [ ] Redirect login tối thiểu; admin giữ `/admin`
- [ ] Done criteria mục 9

### C. Thứ tự triển khai

1. BE my-op  
2. FE route + guard + skeleton  
3. Redirect login (nếu cần)  
4. Hub + Base Profile UI (phase B1 UI)

---

## 12. Change log

| Date | Change |
|------|--------|
| 2026-08-16 | Initial FE-OP doctrine: Elder 4-parts, my-op contract, hub `/op`, phased B1–B3, no auth.service growth, module boundaries |
| 2026-08-16 | Export full .md for project docs (CM-Docs / cmcodes) |

---

*End of document.*
