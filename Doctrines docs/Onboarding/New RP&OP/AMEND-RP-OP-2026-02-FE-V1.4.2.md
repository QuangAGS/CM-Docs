# TÀI LIỆU PHỤ LỤC THIẾT KẾ KỸ THUẬT FRONTEND
## ĐIỀU CHỈNH KIẾN TRÚC GIAO DIỆN VÀ ĐIỀU PHỐI LUỒNG RP & OP
### AMEND-RP-OP-2026-02-FE
### (Phụ lục kỹ thuật bổ trợ cho RP-OP-DETAILED-IMPLEMENTATION-V2.1)

---

## 1. Thông tin văn kiện

| Mục | Giá trị |
|-----|---------|
| Tên | Thiết kế kiến trúc Frontend và điều phối luồng Đăng ký & Nhận diện nhân thân |
| Mã | `AMEND-RP-OP-2026-02-FE` |
| Phiên bản | **V1.4.2 - FINAL** |
| Ngày | 12/11/2026 |
| Trạng thái | FROZEN & READY FOR IMPLEMENTATION |
| Kế thừa | V1.3 Phương án A, có tách C1 / C2 và cổng Admin |

Phương án đã chốt: **A cho Guest (C2)**, **Multi-Home claim cho user đã có tài khoản (C1)**. Không xóa `/membership/*`.

---

## 2. Mục đích

1. Chấm dứt RP cũ: không tạo `members` `DU_BI`, không dùng `users.member_id` làm ngữ cảnh.
2. Guest đăng ký trọn gói tại `/auth`: định danh + Claim EM hoặc 21 trường. Dữ liệu vào `onboarding_cases.metadata`.
3. User đã có tài khoản gia nhập họ thứ hai qua `/membership/claim`, không đi `/auth/register`.
4. Admin duyệt một lần tại `/admin/approval`. Chỉ lúc duyệt mới tạo member hoặc nối EM, và chỉ ghi `user_member_links`.
5. Revision của Guest đi qua 423. Revision của user đã có tài khoản đi qua `/membership/status`.

---

## 3. Hai đường ống

| Tiêu chí | C2 — Guest mới | C1 — User đã có tài khoản |
|----------|----------------|---------------------------|
| Khởi phát | `/auth` → RegisterForm | Đã login → HeaderClanSwitcher → “+ Gia nhập dòng họ khác” → `/membership/claim?mode=add-clan` |
| UI | Phone/email, mật khẩu, Turnstile + Wizard EM hoặc form 21 trường | Chỉ Wizard EM hoặc form 21 trường. Phone/email lấy từ phiên |
| API nộp | `POST /api/auth/register` | `POST /api/membership/cases` |
| Sau nộp | `users.status = CHO_DUYET`. Chưa JWT. Case `SUBMITTED` | `users.status` giữ `DA_DUYET`. Link mới của Tenant B = `CHO_DUYET`. Case `SUBMITTED` |
| Theo dõi / sửa | Login → 423 `ACCOUNT_CHO_DUYET`. `canEdit` thì `revision-notice` | Chọn Tenant B → `/membership/status`. Sửa → `/membership/claim?mode=revision` |
| Khi Admin duyệt | `users.status = DA_DUYET`. Tạo `user_member_links` `DA_DUYET`, `is_default = true` | Không đụng `users`. Link Tenant B → `DA_DUYET`, `is_default = false` |
| Sau duyệt, login | JWT có `activeMemberId` + `DA_DUYET` → `/op` | Login vẫn vào họ mặc định. Switcher để sang họ mới |

Cấm đẩy user C1 về `users.status = CHO_DUYET`. Làm vậy sẽ khóa họ gốc.

---

## 3.1 Clan-setup — lập dòng họ mới

Khác C1 gia nhập họ có sẵn. Tenant B chưa tồn tại. Người duyệt là `SYSTEM_ADMIN`, không phải admin của họ A. Role trên link mới là `CLAN_ADMIN`.

| Tiêu chí | C2-S — Guest lập họ | C1-S — User đã có, lập họ B |
|----------|---------------------|-----------------------------|
| Khởi phát | `/auth` → “Tạo mới một dòng họ” | Đã login → Switcher → “+ Lập dòng họ mới” → `/membership/setup` |
| Vì sao không đăng ký lại | Chưa có tài khoản | Phone/email đã có. `/auth/register` trả 409 |
| UI | Định danh + tên họ, mô tả, hồ sơ người sáng lập | Chỉ hồ sơ lập họ. Định danh lấy từ phiên |
| API | `POST /api/auth/register` với `isNewClan: true` | `POST /api/membership/clan-setup` |
| Sau nộp | `users.status = CHO_DUYET`. Case `CLAN_SETUP` / `SUBMITTED`. Chưa tenant hoạt động | `users.status` giữ `DA_DUYET`. Case `CLAN_SETUP`. Họ A không đổi |
| Duyệt | Chỉ `SYSTEM_ADMIN` | Chỉ `SYSTEM_ADMIN` |
| Khi duyệt | Tạo tenant B `HOAT_DONG`. Tạo founder member. Link `DA_DUYET`, `role_in_tenant = CLAN_ADMIN`, `is_default = true`. `users.status = DA_DUYET`. Tenant ở chế độ sandbox (`tenant` chưa khóa phả đồ) cho đến khi founder nộp kế hoạch 5 đời | Tạo tenant B. Founder member. Link B `DA_DUYET`, `CLAN_ADMIN`, `is_default = false`. Không đụng link A. Sandbox chỉ khi active B |
| Sau duyệt | Login → `/op` của B. Banner sandbox nếu phả đồ 5 đời chưa nộp. Không dùng `activeLinkStatus = DRAFT` cho việc này | Vẫn ở họ A. Switcher sang B. Role B là `CLAN_ADMIN` → `/admin` của B |
| Theo dõi khi chờ | 423 tại `/auth` | Case hiện trong Switcher / `/membership/status?scope=setup`. Chưa có link B nên không đổi context A |

Không cho CLAN_ADMIN của họ A duyệt đơn lập họ B. Không copy role của họ A sang họ B. Không tự đổi họ mặc định của user C1-S.

---

## 4. Điều hướng sau login

`resolvePostLoginRedirect` không được luôn trả `/op`. Thứ tự cố định:

1. `tenant` đang sandbox và user là founder → `/op/mfo/plan`, kèm `SandboxModeBanner`. Không dựa vào `activeLinkStatus = DRAFT`.
2. `activeLinkStatus === 'CHO_DUYET'` → `/membership/status`.
3. `activeLinkStatus === 'TU_CHOI'` → `/membership/status`.
4. Không có `activeMemberId` → `/membership/claim`.
5. `DA_DUYET` và có `activeMemberId` → `/op`.

`OpProtectedRoute`: `/op` và `/tree` chỉ khi `DA_DUYET` và có `activeMemberId`. `CHO_DUYET` chỉ được `/membership/status`.

Không đọc `users.member_id` để quyết định đường đi. SSOT là `activeMemberId` trên JWT, lấy từ `user_member_links`.

---

## 5. API công khai cho Guest Claim

Guest chưa có JWT vẫn phải tìm được dòng họ và người trên cây.

### 5.1 Tìm dòng họ

`GET /api/public/tenants/search?q=`

- Rate limit theo IP.
- `q` tối thiểu 2 ký tự.
- Trả `id`, `name`, `slug`. Không trả dữ liệu thành viên.

### 5.2 Tìm người để claim

`GET /api/public/tenants/:tenantId/members/claim-search?q=`

- Rate limit: tối đa 15 request/phút/IP.
- `q` tối thiểu 2 ký tự.
- Chỉ `status = CHINH_THUC`, `deleted_at = null`. Không trả `DU_BI`.
- Payload tối thiểu: `id`, `full_name`, `alias`, `generation`, `branch_name`, `father_name`, `mother_name`, `birth_year`.
- Cấm trả điện thoại, email, địa chỉ, ngày/tháng sinh.

Không chặn lúc đăng ký nếu nhiều người claim cùng một EM. Chặn lúc Admin duyệt: một EM chỉ một link `DA_DUYET`. Đơn còn lại thành `DISPUTED` hoặc bị từ chối với lý do đã có chủ.

---

## 6. Cổng 423 và hard-lock

Login khi `users.status = CHO_DUYET` trả **423** `ACCOUNT_CHO_DUYET`.

| Trường | Bắt buộc |
|--------|----------|
| `canEdit` | `true` khi case `NEEDS_REVISION` |
| `reviewNote` | Lời Admin |
| `caseId` | Id case |
| `caseStatus` | `SUBMITTED` hoặc `NEEDS_REVISION` |
| `caseMetadata` | Nguyên `onboarding_cases.metadata`: 21 trường, hoặc `claimed_member_id` + 3 lớp gia mật |

`temp_*` cũ không đủ cho revision. `AuthPage` nạp `caseMetadata` vào RegisterForm.

Hard-lock là mã riêng: **403** `ACCOUNT_PERMANENTLY_REJECTED`, `canEdit: false`. Không dùng 423. FE khóa form, không nút sửa.

---

## 7. Cổng Admin

Người duyệt:

- C2 / C1 gia nhập họ có sẵn: `CLAN_ADMIN` của tenant đích.
- C2-S / C1-S lập họ mới: chỉ `SYSTEM_ADMIN`.

`AdminUserApprovalPage.jsx` — danh sách chờ, nhãn:

- `[NHẬN NGƯỜI TRÊN CÂY - EM]`
- `[KHAI BÁO MỚI - 21 TRƯỜNG]`
- `[LẬP DÒNG HỌ MỚI - CLAN SETUP]` — chỉ `SYSTEM_ADMIN`. Tách C2-S và C1-S
- `[GIA NHẬP HỌ THỨ HAI - C1]`

`OpCaseDetailPage.jsx`:

- Case EM: cột trái là member trên cây, cột phải là 3 lớp gia mật và minh chứng. Cảnh báo đỏ nếu EM đã có link hoặc đang `DISPUTED`.
- Case 21 trường: 4 nhóm (nhân thân, tiền nhân 3 đời, liên lạc/cư trú, minh chứng). Admin chọn cha/mẹ/chi trước khi duyệt.
- Case C1: hiện user đã có (họ gốc) và tenant đích. Không cho sửa `users.status`.

Bốn nút:

| Nút | Hệ quả |
|-----|--------|
| Duyệt | Transaction: Case EM thì link tới EM; Case 21 trường thì tạo `members` `CHINH_THUC` rồi link. Link `DA_DUYET`. Không ghi `users.member_id` |
| Trả sửa | Bắt buộc ghi chú. Case → `NEEDS_REVISION` |
| Từ chối mềm | Bắt buộc lý do. `TU_CHOI`. Được nộp lại |
| Từ chối vĩnh viễn | Xác nhận 2 bước + lý do. `is_final_rejection = true` |

---

## 8. File

| Mã | File | Việc |
|----|------|------|
| MF-01 | `RegisterForm.jsx` | C2: sau định danh, chọn Claim EM hoặc 21 trường. Gói `metadata` |
| MF-02 | `AuthPage.jsx` | 423 → `revision-notice`. Nạp `caseMetadata`. 403 hard-lock không sửa |
| MF-03 | `AuthContext.jsx` | Redirect theo mục 4. Có `register`. Không fallback luôn `/op` |
| MF-04 | `ClaimMemberPage.jsx` | C1 `mode=add-clan` và `mode=revision`. Không dùng cho lập họ |
| MF-04b | `ClanSetupPage.jsx` | C1-S: `/membership/setup`. Không hỏi lại phone/email |
| MF-05 | `ClaimMemberWizard.jsx` | Tra cứu → 3 lớp → xác nhận |
| MF-06 | `RegistrationProfileForm.jsx` | 21 trường |
| MF-07 | `MembershipStatusPage.jsx` | C1: CHO_DUYET, NEEDS_REVISION, TU_CHOI, hard-lock |
| MF-08 | `HeaderClanSwitcher.jsx` | Hai nút: gia nhập họ khác, lập dòng họ mới. Hiện case lập họ đang chờ |
| MF-09 | `AdminUserApprovalPage.jsx` | Nhãn loại hồ sơ |
| MF-10 | `OpCaseDetailPage.jsx` | Đối soát EM / 21 trường / C1 |
| MF-11 | `auth.service.js` | `register` lưu metadata. `processUserApproval` không tạo `DU_BI`, không set `users.member_id` |
| MF-12 | `App.jsx` | Giữ `/membership/claim` và `/membership/status`. `/op`, `/tree` require approved |

---

## 9. Lát cắt

**Lát 0 — BE.** Cấm `DU_BI` và cấm ghi `users.member_id` trong duyệt. `register` lưu `metadata`. Login 423 trả `caseMetadata`. 403 hard-lock riêng.

**Lát 1 — C2 form.** RegisterForm gắn Wizard EM và form 21 trường. Search public. Submit một payload.

**Lát 2 — 423.** AuthPage revision nạp `caseMetadata`. Hard-lock không mở form.

**Lát 3 — C1 và C1-S.** Claim/status cho gia nhập họ có sẵn. `/membership/setup` cho lập họ. Switcher có hai lối. Không đổi `users.status`.

**Lát 4 — Admin.** Danh sách phân loại, màn đối soát, bốn nút. Duyệt mới tạo link.

**Lát 5 — Redirect.** AuthContext và OpProtectedRoute theo mục 4.

---

## 10. Nghiệm thu

1. C2 Claim EM: đăng ký không tạo member. Admin duyệt mới có link `DA_DUYET`. Login vào `/op`.
2. C2 No EM: metadata 21 trường. Duyệt tạo `members` `CHINH_THUC`. Không có `DU_BI`.
3. C2 trả sửa: 423 `canEdit`, form đầy dữ liệu, nộp lại.
4. Hard-lock: 403, không nút sửa.
5. C1: phone/email cũ không 409. Họ gốc vẫn `DA_DUYET`. Họ mới `CHO_DUYET` cho đến khi duyệt.
6. C1-S: user họ A lập họ B. Không 409. Họ A không đổi. Sau duyệt, link B là `CLAN_ADMIN`, `is_default = false`.
7. C2-S: Guest lập họ. Chỉ `SYSTEM_ADMIN` duyệt. Sau duyệt có tenant và founder.
8. Hai người claim cùng EM: chặn lúc duyệt.
9. `users.member_id` không được dùng để vào `/op`.

---

## 11. Kết luận

V1.4.2 chốt bốn đường: C2, C1, C2-S, C1-S. Sandbox là cờ của tenant, không phải `DRAFT` của link. `/membership/*` giữ cho C1. Không khóa họ gốc. Không còn member `DU_BI`.