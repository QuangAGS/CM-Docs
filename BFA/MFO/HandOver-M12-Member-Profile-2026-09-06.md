# HandOver M12 — Member Profile (sống + đã mất)

```
PATH       : BFA/HandOver-M12-Member-Profile-2026-09-06.md
DATETIME   : 2026-09-06T16:48:00+07:00
VERSION    : 1.0.0-M12-CLOSE-UAT
SSOT       : thay thế ngữ cảnh làm việc A01/M12 trên thread cũ. 
             Tương tác = A01-Profile-Task-Shell-2026-09-06.md
REPOS      : QuangAGS/cmcodes (BE + FE) + CM-Docs
RP/OP      : CLOSED. Không mở lại SM.
```

## 1. Mục đích tài liệu

Giữ mạch khi **chuyển thread mới**. Thread cũ đã tạm đóng khối `/me/profile` + `/members/:id/profile` để chủ dự án UAT toàn bộ RP, OP, Profile.

Người nhận thread: đọc mục 2–5 trước khi sinh code. Lát nhỏ. Q1: không phá UI/logic đang chạy. Không inject tenant vào `update`/`findUnique`.

## 2. Đóng (đừng làm lại)

- S0 isolation; Hub v2 `/admin/tenants`.
- A01 hồ sơ sống: địa chỉ 34 tỉnh + notes; tiểu sử dropdown + RA + file; thành tích CRUD; BL B3 (CL=NONE); avatar singleton + crop; proof ảnh/PDF tách trang; khung Tài liệu khác 30MB.
- UTF-8 tên file download (presign `filename*` / stream BE nếu còn méo).
- Multimedia: mở bằng tool trình duyệt khi được; download khi không.
- Refresh từng khối sau xóa; không bắt buộc reload cả trang khi xóa.
- Không convert Office → PDF lúc upload.
- Privacy theo **field_group** (CONTACT / BIRTH_DATE / ADDRESS / BIO / ACHIEVEMENT / HEALTH / DOCS), visibility SELF | TENANT.
- Biography: nhóm máu enum + note; bệnh tật + `health_none`; dị tật bẩm sinh + `congenital_none`.
- Member đã mất: cùng 10 mục hồ sơ như người sống; thêm nơi ở cuối, nơi an nghỉ (`graves` + cemetery), **Ngày mất / ngày giỗ**.
- API dùng chung: `GET|PATCH /api/members/:id/profile`; `/me/*` nhận `member_id` (query/body) khi steward.
- Xem ≠ sửa: `canViewProfile` (cùng tenant) cho GET; `canEditProfile` cho PATCH/upload.
- Nút sửa: (1) `can_edit` hoặc CLAN_ADMIN/SYSTEM_ADMIN; (2) `dirty` theo **đúng mục đang mở**.
- Audit không được nằm trong interactive TX hồ sơ (`writeAudit` → `logAction(..., null)`). TX PATCH `{ maxWait: 10000, timeout: 20000 }`.
- `/me/profile` phải `can_edit: true` (SELF). Thread từng khóa nhầm avatar + Elder vì payload `can_edit: false`.
- Dropdown Profile: giữ bio, bio_read, ach, ach_read (A01 Task Shell 2026-09-07). Không gộp.

## 3. Khóa (không đụng)

- ALS. Không inject `tenant_id` vào Prisma `update` / `findUnique`.
- A01 / PATCH profile **không** sửa `users.phone`, `users.email`, `members.gender`, `members.is_alive`.
- Vital (sống/chết) = endpoint `/admin/members/:id/vital` (hoặc tương đương), không qua A01.
- `place ≠ usage`. AVATAR/LOGO singleton. CERTIFICATE/DOCUMENT không singleton.
- Không sửa schema `audit_logs` trong lát profile.
- `members.phone_number` / `members.email` **không unique** (đại diện liên lạc cho người khác được).
- `created_by_member_id = null` với SYSTEM_ADMIN là chấp nhận được. Không tạo member giả.

## 4. Model quyền sửa hồ sơ

`canEditProfile` (`profileAccess.service.js`):

| via | Điều kiện |
|---|---|
| SYS | SYSTEM_ADMIN |
| CLAN_ADMIN | cùng `tenant_id` |
| SELF | `is_alive !== false` và actor.member_id = target |
| CREATOR_USER / CREATOR_MEMBER | `created_by` / `created_by_member_id` |
| GRANT | `profile_edit_grants` HIEU_LUC, scope PROFILE hoặc BRANCH_PROFILE |
| OFFICE_* | `member_offices` TRUONG_HO / TRUONG_TOC / TRUONG_BRANCH|CHI|NGANH đúng branch |

`canViewProfile`: cùng tenant, `deleted_at` null. GET áp privacy: nhóm SELF bị che nếu không `can_edit`.

JWT có thể thiếu `role`/`tenantId` — `canEditProfile` phải hydrate từ bảng `users`.

## 5. Ngày mất / ngày giỗ

Cột sẵn trên `members`: `death_day`, `death_month`, `death_year`, `is_death_lunar`, `death_note`.

- Mục hồ sơ: **Ngày mất / ngày giỗ** (`section === 'death'`), sau Ngày sinh. Luôn có trên dropdown.
- Header: badge **Đã chết** chỉ khi chết; kèm `formatGio` (vd. `Giỗ 15/09/2010 (âm lịch)`).
- PATCH nhận `death_*` **chỉ khi** `members.is_alive === false`. Không nhận `is_alive`.
- `dirty.death` = `death_year|month|day|is_death_lunar|death_note`. Thiếu map này thì nút kẹt «Chưa có thay đổi».

## 6. File then chốt (cmcodes)

```
Backend/src/modules/profile/profile.service.js
Backend/src/modules/profile/profile.routes.js
Backend/src/modules/members/profileAccess.service.js
Backend/src/modules/members/member.service.js
Backend/src/modules/members/member.controller.js
frontend/src/pages/MemberProfilePage.jsx
frontend/src/pages/AddressFormPage.jsx
frontend/src/pages/BioFileUploadPage.jsx
frontend/src/pages/DocumentUploadPage.jsx
frontend/src/pages/ProofUploadPage.jsx
frontend/src/features/member/components/AddressForm.jsx
frontend/src/features/member/constants/addressCatalog.js
frontend/src/features/member/components/AchievementSection.jsx
frontend/src/lib/toastSpeak.js
```

Địa chỉ: `latitude`, `longitude`, `location_url` đã có trên `addresses`. Form + `upsertAddress` + `mapHref` (mở Google Maps).

## 7. Nợ — không chặn UAT RP/OP/Profile

1. Nén ảnh WebP/JPEG + resize; **cấm JPEG→PNG**. HEIC upload từ iPhone đã smoke OK.
2. G-media presign PUT dùng chung + Ports & Adapters (`STORAGE_PROVIDER`). Hiện façade R2; chưa Drive.
3. `GET /me/achievements|documents|biography/files?member_id=` vẫn theo `canEdit` — USER xem hồ sơ người khác có thể trống file/thành tích dù GET profile 200.
4. PATCH gầy theo mục (đừng gửi cả 7 privacy mỗi lần lưu tiểu sử) + index `(tenant_id, member_id, field_group)` trên `member_privacy_rules`.
5. `audit_logs.create` vẫn có thể fail (log `audit skip`). Không chặn lưu. Không sửa bảng audit trong lát profile.
6. Cây thư mục FE theo Architecture docs — chưa enforce.
7. UI grant / trưởng chi / `data_suggestions` → phê duyệt uỷ quyền sửa hồ sơ người mất — bảng có, màn hình chưa gắn profile.
8. `contact_via_member_id` (số con đại diện cha) — cố ý chưa làm.
9. TanStack Query — không chữa TX; chỉ khi UAT kêu waterfall 4 GET.

## 8. Lát tiếp (nếu UAT ra phiếu)

- M-media-compress  
- M-presign-facade (vẫn R2)  
- M-view-files (`canView` trên list achievements/docs/bio files)  
- M-grant-ui (nếu UAT cần uỷ quyền con/cháu)  

Không mở SM. Không copy-paste UI `/me` thành trang chết riêng — một `MemberProfilePage` tham số hóa.

## 9. Smoke tối thiểu trước khi tuyên bố regression

1. `/me/profile` (chính mình): `can_edit: true`, đổi avatar, Lưu họ tên, toast đọc, nút Nghe.
2. USER thường `/members/<id-chết>/profile`: 200, badge Đã chết + giỗ, không Thêm/Sửa/Lưu, HEALTH/DOCS trống nếu SELF.
3. CLAN_ADMIN cùng URL: sửa ngày giỗ → dirty «Lưu mục này» → reload còn ngày.
4. PATCH USER → 403 + `toastSpeak`.
5. Địa chỉ nơi an nghỉ: lat/lng + «Mở bản đồ».
6. `/me/profile` không nhảy nhầm sang member khác sau Lưu.

## 10. Phiên bản thread (mốc, không phải semver sản phẩm)

M12a creator stamp → M12c/d GET/PATCH member profile → M12f shared `/me?member_id=` → M12h/i target UI → M12k audit/TX timeout → M12L geo address → M12M header/tts → M12n canView → M12n3 readonly buttons → M12n5 `/me` can_edit SELF → M12n7 mục Ngày mất → M12n8 admin canEdit hydrate → M12n9 dirty death.

Repo tại thời điểm handover: kiểm tra `git log` cmcodes; chủ dự án có thể đã push M12n9.

HA (header đã APPROVED, checklist còn trống)

## 11. Câu chốt cho prompt thread mới

```
Tiếp myClan.com.vn.
SSOT: BFA/HandOver-M12-Member-Profile-2026-09-06.md
SSOT: tương tác = A01-Profile-Task-Shell-2026-09-06.md  Thread sau không mất file
Repos QuangAGS/cmcodes + CM-Docs.
RP/OP CLOSED. Không mở lại SM.
Profile sống+chết tạm đóng để UAT. Chỉ mở lát nếu UAT ra phiếu.
Khóa: ALS; không inject tenant vào update/findUnique; không sửa users.phone/gender; is_alive không qua PATCH profile; place ≠ usage.
Nợ: nén ảnh; presign façade; list file theo canView; audit skip; grant UI.
Q1/Q2. Lát nhỏ. Không sinh code lớn trước khi hỏi.
```
