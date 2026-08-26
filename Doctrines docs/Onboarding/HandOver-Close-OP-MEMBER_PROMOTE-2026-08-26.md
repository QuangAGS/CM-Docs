# HandOver — Đóng Onboarding Process (OP / MEMBER_PROMOTE)

**PATH**       : CM-Docs / Doctrines docs/Onboarding / HandOver-Close-OP-MEMBER_PROMOTE-2026-08-26.md  
**DATETIME**   : 2026-08-26T10:25:00+07:00  
**VERSION**    : 1.0.0  
**STATUS**     : CLOSED — E2E OP PASS (BE + FE smoke OK)  
**REPOS**      : QuangAGS/cmcodes · QuangAGS/CM-Docs  
**SSOT + Q1/Q2**

**Liên quan**

- HandOver-RP-process-kind-BPL-2026-08-16  
- HandOver-Close-C6-2026-08-15  
- FE-OP-MEMBER_PROMOTE-2026-08-16  
- Register-to-OP-Handoff-Contract-2026-08-13  
- Onboarding Process.drawio.xml  

**Thread tiếp theo (không thuộc đóng OP):** Admin Hub v2 — Quản trị dòng họ.

---

## 0. Tóm tắt một trang

OP (Onboarding Process) đã triển khai **đủ vòng đời member `DU_BI` → hồ sơ cơ sở → gửi duyệt → xét duyệt (duyệt / trả sửa / từ chối / reopen theo quyền) → `CHINH_THUC`**, tách khỏi RP bằng `process_kind = MEMBER_PROMOTE`.

| Trục | Kết quả |
|------|---------|
| BE | GET my-op, PUT profile, SUBMIT, list reviewable (`basePrisma` SYS), APPROVE / REVISION / REJECT / REOPEN, timeline BPL, side-effect role + tenant |
| FE member | `/op` hub động + `/op/base-profile` (Zod + RHF), elder, footer |
| FE admin | `/admin/approval?process=OP` list + `/admin/approval/op/:caseId` detail |
| Shell | `TenantHeader` (logo_url / logo_icon / slogan italic-bold) + `AppFooterNav` + `resolveFooterNav` |
| Media | R2 private + `media` schema + replace LOGO (soft DB + xóa R2 ngay) |
| Smoke | Vòng đời OP PASS; footer 1–3 PASS (2026-08-26) |

**Không đóng trong report này:** module “Quản trị dòng họ” (gom cài đặt + trạng thái tenant + query SYS). Đó là epic thread mới.

---

## 1. Bối cảnh & mục tiêu đã khóa

Sau C6 CLOSED (OP-A `DU_BI→CHINH_THUC` E2E JOIN+CLAN_SETUP PASS trên BE) và RP `process_kind` + BPL semantic PASS:

- Option đã chọn: **B** — FE OP member mở / submit / approve `MEMBER_PROMOTE`.  
- Sau đó xen **D** (timeline BPL đọc `payload.action`) và **B3** (trả sửa / reject / reopen).  
- Media / tenant header phục vụ nhận diện tenant trên mọi page OP/admin.

### 1.1 Quy tắc nghiệp vụ (SSOT)

| Mục | Quy ước |
|-----|---------|
| `process_kind` | RP = `REGISTER` · OP = `MEMBER_PROMOTE` |
| `case_type` | `MEMBER_JOIN` \| `CLAN_SETUP` |
| BPL identity | `USER_APPROVAL` + `payload.action` — không đoán từ note |
| Entry OP | member `DU_BI`; user thường đã `DA_DUYET` sau RP |
| APPROVE MEMBER_JOIN | member `CHINH_THUC` · user.role = `USER` · tenant **không** đổi |
| APPROVE CLAN_SETUP | member `CHINH_THUC` · user.role = `CLAN_ADMIN` · tenant `HOAT_DONG` |
| RP CLAN_SETUP | user **giữ VIEWER** cho đến khi OP approve (không gán CLAN_ADMIN ngay RP) |
| Approver JOIN | `CLAN_ADMIN` tenant `HOAT_DONG` (đúng tenant) |
| Approver SETUP | `SYSTEM_ADMIN` |
| SYSTEM_ADMIN | mọi quyền; Prisma **phải** `basePrisma` khi list/review cross-tenant |

### 1.2 Vòng đời case OP (đã khóa B3)

```
DRAFT
  └─ SUBMIT → SUBMITTED | UNDER_REVIEW
       ├─ Admin Duyệt → APPROVED (+ side-effects trên)
       ├─ Admin Trả sửa → NEEDS_REVISION + revision_request
       │     └─ Member sửa BP + Gửi lại → SUBMITTED
       ├─ Admin Từ chối (reopenable) → REJECTED
       │     └─ Chỉ ADMIN reopen → DRAFT  (member không tự REOPEN)
       └─ Admin FINAL_REJECT → REJECTED (không reopen)
             └─ member giữ DU_BI · users.status = BI_CAM · role = GUEST
```

**Luôn có note** khi Trả sửa / Duyệt / Từ chối.

Tenant (chỉ **CLAN_SETUP**):

| Quyết định | tenants.status |
|------------|----------------|
| Soft reject (reopenable) | `TU_CHOI` |
| REOPEN | `TAM_NGUNG` |
| FINAL_REJECT | `NGUNG_HAN` |
| APPROVE | `HOAT_DONG` |

MEMBER_JOIN: tenant **không** bị ảnh hưởng.

---

## 2. Phạm vi đã hoàn thành

### 2.1 BE OP

| Hạng mục | Endpoint / hành vi | Status |
|----------|-------------------|--------|
| Instance của user | `GET /api/onboarding/my-op` | PASS |
| Cập nhật Base Profile | `PUT /api/members/:id` (quyền member tự sửa DU_BI) | PASS |
| Gửi duyệt | `POST /api/onboarding/cases/:id/submit` | PASS (sau vá DRAFT→SUBMITTED) |
| List xét duyệt | `GET /api/onboarding/cases/reviewable?process_kind=MEMBER_PROMOTE` | PASS (`basePrisma` cho SYS) |
| Duyệt | `POST .../approve` + note | PASS |
| Trả sửa | `POST .../revision` | PASS |
| Từ chối | `POST .../reject` (`finalReject`) | PASS |
| Reopen | `POST .../reopen` — **chỉ admin** | PASS (sau thêm `ONBOARDING_CASE_REOPEN`) |
| Timeline | `GET .../cases/:id/timeline` (RP+OP, actionLabel) | PASS |
| Tenant isolation | SYS dùng `basePrisma`; CLAN_ADMIN lọc `tenant_id` + `MEMBER_JOIN` | PASS |

**Side-effect APPROVE (B2, đã khóa):**

- `MEMBER_JOIN` → `user_role = USER`  
- `CLAN_SETUP` → `user_role = CLAN_ADMIN` + tenant `HOAT_DONG`

### 2.2 FE member

| Route | Vai trò | Status |
|-------|---------|--------|
| `/op` | Hub loại công việc (card mở/thu; thiếu field + yêu cầu admin **trong card**) | PASS |
| `/op/base-profile` | BaseProfileForm — Zod + RHF; Lưu nháp / Gửi duyệt | PASS |
| Guard | chưa login → `/auth`; không OP → không dùng `/op` như tree; admin không vào `/op` như hub member | PASS |

**Elder (điều kiện chấp nhận):** AudioHelpButton (toàn trang) ≠ ZoneVoice (hướng dẫn card) ≠ nút đọc yêu cầu admin ≠ FormErrorSpeaker.

**Hub động:** member có thể chọn hiện việc cần làm / hiện đủ danh mục.

### 2.3 FE admin OP

| Route | Vai trò | Status |
|-------|---------|--------|
| `/admin/approval?process=OP` | List reviewable OP | PASS |
| `/admin/approval/op/:caseId` | Chi tiết + Duyệt / Trả sửa / Từ chối | PASS |
| Work items | “Phê duyệt người dùng” (RP) · “Phê duyệt thành viên” (OP) | PASS (rename 2026-08-26) |

Quyền nút: SYS thấy CLAN_SETUP (+ JOIN); CLAN_ADMIN chỉ JOIN tenant mình.

### 2.4 Shell dùng chung (phục vụ OP + admin)

| Thành phần | Path | Ghi chú |
|------------|------|---------|
| `TenantHeader` | `src/components/shell/TenantHeader.jsx` | logo_url > logo_icon > initials; slogan **italic + bold** |
| `AppFooterNav` | `src/components/shell/AppFooterNav.jsx` | Quay lại / Home / Đăng xuất — không CTA nghiệp vụ |
| `resolveFooterNav` | `src/lib/resolveFooterNav.js` | `pageKey` quyết định tầng Home |
| `resolveTenant` | `src/lib/resolveTenant.js` | `user.tenant { id, name, logo_url, slogan, logo_icon }` từ `/auth/me` + login |

**Footer đã khóa (smoke 26/08):**

| pageKey | Quay lại | Home |
|---------|----------|------|
| `admin` | ẩn | Trang chủ → `/` |
| `admin-approval` | `/admin` | Trang chủ → `/` |
| `admin-op-detail` / `admin-settings` | cấp cha | Trung tâm QT → `/admin` |
| `op-hub` | `/` | Việc của tôi / Trang chủ theo role |
| `op-base-profile` | `/op` | theo role |

### 2.5 Media / nhận diện tenant (hỗ trợ header OP)

| Hạng mục | Status |
|----------|--------|
| R2 private, key `{tenantId}/{uuid}{ext}` | PASS |
| `POST /api/media/upload` | PASS |
| Presigned GET | PASS |
| LOGO/AVATAR replace: soft-delete DB + **xóa R2 ngay** | PASS |
| PATCH tenant settings (name, slogan, logo_icon, social_configs) | PASS |
| FE `/admin/tenant/settings` + crop logo | PASS (UX crop còn nợ tinh chỉnh) |

---

## 3. Enum / BPL đã bổ sung (OP)

`business_process_type` (trích OP):

- `ONBOARDING_CASE_CREATE`  
- `ONBOARDING_PROFILE_SAVE` / `COMPLETE`  
- `ONBOARDING_SUBMIT`  
- `ONBOARDING_REVIEW_START`  
- `ONBOARDING_REVISION_REQUEST`  
- `ONBOARDING_APPROVE`  
- `ONBOARDING_REJECT`  
- `ONBOARDING_CASE_REOPEN`  
- `ONBOARDING_CANCEL`  
- `ONBOARDING_CASE_EXPIRE` (job — chưa vận hành FE)

Timeline FE đọc `process_type` + `payload.action` → `actionLabel` tiếng Việt.

**Không** tách bảng `business_types` trong phase này (enum Prisma giữ tương thích CED).

---

## 4. File / module then chốt

### BE (`gia-pha-backend`)

- `src/modules/onboarding/onboarding.service.js` — approve / revision / reject / reopen / listReviewable / timeline  
- `src/modules/onboarding/onboarding.controller.js` + `onboarding.routes.js` + `index.js`  
- `src/modules/onboarding/services/getMyOpInstance.js`  
- `src/lib/prisma.js` — `prisma` vs `basePrisma`  
- `src/modules/interactions/media.service.js` — upload + retire LOGO  
- `src/shared/storage/r2.storage.service.js`  
- `schema.prisma` — `onboarding_process_kind`, `media`, `business_process_type`

### FE (`gia-pha-frontend`)

- `src/pages/OpHubPage.jsx`  
- `src/pages/OpBaseProfilePage.jsx` + BaseProfileForm  
- `src/pages/OpCaseDetailPage.jsx`  
- `src/features/admin/components/OpApprovalPanel.jsx`  
- `src/pages/AdminUserApprovalPage.jsx` — `process=OP` → panel  
- `src/features/onboarding/constants/opMessages.js` · `opFieldLabels.js`  
- `src/features/admin/constants/adminWorkItems.js` · `adminMessages.js`  
- Shell: TenantHeader, AppFooterNav, resolveFooterNav, resolveTenant  

---

## 5. Quyết định thiết kế đã khóa (không mở lại trừ handoff mới)

1. OP **module riêng** — không gắn cây phả hệ (`/tree`) làm SSOT quy trình.  
2. Không phình `auth.service` bằng logic OP.  
3. BPL identity = type + **action**, không parse note.  
4. Member **không** tự REOPEN sau REJECTED; chỉ ADMIN.  
5. FINAL_REJECT → `BI_CAM` + `GUEST`.  
6. Một tenant **một LOGO primary**; upload mới = retire cũ (DB + R2).  
7. Header tenant thống nhất mọi page đã login.  
8. Footer khuôn chung; CTA Lưu/Duyệt **không** nằm footer điều hướng.

---

## 6. Nợ kỹ thuật / ngoài phạm vi đóng OP

### 6.1 Vá nhỏ đã xong cùng ngày đóng (26/08)

- Footer Home đúng tầng (Trang chủ `/` trên hub + list approval).  
- Bỏ dòng “Hệ thống trung tâm” trên `/admin/approval`.  
- Elder `/admin` (AudioHelp + ZoneVoice).  
- Rename work item RP/OP.

### 6.2 Cố ý **không** làm trong OP (chuyển thread Admin Hub v2)

- Gom “Dòng họ chờ kích hoạt” + “Cài đặt dòng họ” + activate → **Quản trị dòng họ**.  
- SYS: query/filter mọi tenant + đổi status.  
- CLAN_ADMIN: chỉ 1 tenant mình.  
- Card thu gọn danh sách tenant trên `/admin`.  
- Quản trị thành viên (ngoài phê duyệt).

### 6.3 Nợ khác (không chặn đóng OP)

- Job timeout `ONBOARDING_CASE_EXPIRE` + xử lý status khi quá hạn.  
- Crop logo UX (pan/zoom) còn có thể thay `react-easy-crop` nếu cần.  
- Media public URL không dùng (private R2) — đúng doctrine.  
- Logic RP gán CLAN_ADMIN sớm: **đã thống nhất giữ VIEWER sau RP**; nếu DB cũ lệch thì sửa tay khi test.  
- Timeline UI admin đọc BPL: API có; polish UI chưa epic riêng.

---

## 7. Cách smoke lại (rút gọn)

1. RP CLAN_SETUP → user VIEWER + member DU_BI + tenant TAM_NGUNG.  
2. Login member → `/op` → base-profile → Gửi duyệt.  
3. SYS: `/admin/approval?process=OP` thấy CLAN_SETUP → detail → Duyệt → member CHINH_THUC, user CLAN_ADMIN, tenant HOAT_DONG.  
4. MEMBER_JOIN: CLAN_ADMIN duyệt → user USER, tenant không đổi.  
5. Trả sửa → member thấy yêu cầu trong card hồ sơ → sửa → gửi lại.  
6. Reject reopenable → chỉ admin reopen → DRAFT.  
7. Header logo/slogan hiện mọi page sau login; footer đúng tầng.

---

## 8. Hướng dẫn thread mới

**Tiêu đề đề xuất:**  
`Admin Hub v2 — Quản trị dòng họ (sau HandOver-Close-OP-2026-08-26)`

**Đầu vào bắt buộc**

- Report này (SSOT đóng OP).  
- Không phá RP / OP đã PASS (Q1).  
- Work taxonomy đề xuất:  
  1. Phê duyệt người dùng (đã có)  
  2. Phê duyệt thành viên (đã có)  
  3. **Quản trị dòng họ** (settings + status + query)  
  4. Quản trị thành viên (sau)

**Không** mở lại state machine OP trừ khi có bug production.

---

## 9. Trạng thái đóng

| Câu hỏi | Trả lời |
|---------|---------|
| OP member E2E? | **PASS** |
| OP admin approve/revision/reject/reopen? | **PASS** |
| RP còn nguyên? | **Có** (Q1) |
| Có được phép bắt đầu Admin Hub v2? | **Có** — thread mới |
| Có được phép sửa OP state machine trong thread admin? | **Không** trừ handoff riêng |

**CLOSED.**
)
