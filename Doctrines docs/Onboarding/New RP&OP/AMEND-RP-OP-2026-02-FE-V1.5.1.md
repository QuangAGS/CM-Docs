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
| Phiên bản | **V1.5.1 - Thay đổi nhỏ từ: V1.5.0 - FINAL FROZEN** |
| Ngày | 12/11/2026 |
| Trạng thái | FROZEN & READY FOR IMPLEMENTATION |
| Kế thừa | V1.4.2: Vá mâu thuẫn Sandbox vs `DA_DUYET`, bổ sung kênh theo dõi C1-S trên Switcher, tách rạch ròi quyền duyệt Admin, làm rõ OpProtectedRoute và cờ Sandbox |
| Lưu ý: V1.5.1 thay đổi phần Ghi chú của mục Tìm người để claim.

Phương án đã chốt: **A cho Guest (C2)**, **Multi-Home claim cho user đã có tài khoản (C1)**. Không xóa `/membership/*`.

---

## 2. Mục đích

1. Chấm dứt RP cũ: không tạo `members` `DU_BI`, không dùng `users.member_id` làm ngữ cảnh điều hướng hay phân quyền.
2. Guest đăng ký trọn gói tại `/auth`: định danh + Claim EM hoặc 21 trường. Dữ liệu vào `onboarding_cases.metadata`.
3. User đã có tài khoản gia nhập họ thứ hai qua `/membership/claim`, không đi `/auth/register`.
4. Admin duyệt một lần tại `/admin/approval`. Chỉ lúc duyệt mới tạo member hoặc nối EM, và chỉ ghi `user_member_links` (tuyệt đối không đụng `users.member_id`).
5. Revision của Guest đi qua 423 `ACCOUNT_CHO_DUYET`. Revision của user đã có tài khoản đi qua `/membership/status`.

---

## 3. Hai đường ống (Nhóm gia nhập họ có sẵn)

| Tiêu chí | C2 — Guest mới | C1 — User đã có tài khoản |
|----------|----------------|---------------------------|
| Khởi phát | `/auth` → RegisterForm | Đã login → HeaderClanSwitcher → “+ Gia nhập dòng họ khác” → `/membership/claim?mode=add-clan` |
| UI | Phone/email, mật khẩu, Turnstile + Wizard EM hoặc form 21 trường | Chỉ Wizard EM hoặc form 21 trường. Phone/email lấy từ phiên đăng nhập |
| API nộp | `POST /api/auth/register` | `POST /api/membership/cases` |
| Sau nộp | `users.status = CHO_DUYET`. Chưa cấp JWT. Case `SUBMITTED` | `users.status` giữ `DA_DUYET`. Link mới của Tenant B = `CHO_DUYET`. Case `SUBMITTED` |
| Theo dõi / sửa | Login → 423 `ACCOUNT_CHO_DUYET`. `canEdit = true` thì vào `revision-notice` | Chọn Tenant B → `/membership/status`. Sửa → `/membership/claim?mode=revision` |
| Khi Admin duyệt | `users.status = DA_DUYET`. Tạo `user_member_links` `DA_DUYET`, `is_default = true` | Không đụng `users`. Link Tenant B → `DA_DUYET`, `is_default = false` |
| Sau duyệt, login | JWT có `activeMemberId` + `DA_DUYET` → `/op` | Login vẫn vào họ mặc định. Dùng Switcher để sang họ mới |

*Lưu ý:* Cấm đẩy user C1 về `users.status = CHO_DUYET`. Làm vậy sẽ khóa tài khoản tại họ gốc.

---

## 3.1 Clan-setup — Lập dòng họ mới

Khác C1 gia nhập họ có sẵn: Tenant B chưa tồn tại. Người duyệt là `SYSTEM_ADMIN`, không phải admin của họ A. Role trên link mới là `CLAN_ADMIN`.

| Tiêu chí | C2-S — Guest lập họ | C1-S — User đã có, lập họ B |
|----------|---------------------|-----------------------------|
| Khởi phát | `/auth` → “Tạo mới một dòng họ” | Đã login → Switcher → “+ Lập dòng họ mới” → `/membership/setup` |
| Đăng ký lại? | Chưa có tài khoản | Phone/email đã có. Nếu gọi `/auth/register` sẽ trả 409 Conflict |
| UI | Định danh + Tên họ, mô tả, hồ sơ người sáng lập | Chỉ hồ sơ lập họ. Định danh lấy từ phiên |
| API | `POST /api/auth/register` với `isNewClan: true` | `POST /api/membership/clan-setup` |
| Sau nộp | `users.status = CHO_DUYET`. Case `CLAN_SETUP` / `SUBMITTED`. Chưa có tenant | `users.status` giữ `DA_DUYET`. Case `CLAN_SETUP`. Họ A không đổi |
| Duyệt | Chỉ `SYSTEM_ADMIN` | Chỉ `SYSTEM_ADMIN` |
| Khi duyệt | Tạo tenant B. Tạo founder member. Link `DA_DUYET`, `role_in_tenant = CLAN_ADMIN`, `is_default = true`. `users.status = DA_DUYET`. Tenant ở chế độ sandbox cho đến khi nộp kế hoạch 5 đời. | Tạo tenant B. Tạo founder member. Link B `DA_DUYET`, `CLAN_ADMIN`, `is_default = false`. Không đụng link A. Sandbox chỉ khi active B. |
| Sau duyệt | Login → `/op` của B. Banner sandbox nếu phả đồ 5 đời chưa nộp | Vẫn ở họ A. Switcher sang B. Role B là `CLAN_ADMIN` → `/admin` của B |
| Theo dõi khi chờ | Login trả mã 423 tại `/auth` | Case hiện trong Switcher / `/membership/status?scope=setup` |

**Quy tắc Sandbox:**
- Không dùng `activeLinkStatus = DRAFT` để định nghĩa Sandbox. Sandbox là trạng thái cờ của tenant.
- **Tắt Sandbox:** Phải có cơ chế tắt cờ Sandbox (chuyển sang chính thức) sau khi người sáng lập nộp và chốt phả đồ 5 đời (Xử lý tại `Backend/src/modules/mfo/mfo.service.js` trong hàm duyệt plan).

---

## 4. Điều hướng sau login (`resolvePostLoginRedirect`)

Hàm điều hướng trong `AuthContext` không được luôn trả về `/op`. Thứ tự ưu tiên cố định:

1. `tenant` đang ở chế độ sandbox và user là founder → Chuyển vào `/op/mfo/plan` (kèm `SandboxModeBanner`).
2. `activeLinkStatus === 'CHO_DUYET'` → Chuyển vào `/membership/status`.
3. `activeLinkStatus === 'TU_CHOI'` → Chuyển vào `/membership/status` (để xem lý do và có thể nộp lại).
4. Không có `activeMemberId` → Chuyển vào `/membership/claim`.
5. `DA_DUYET` và có `activeMemberId` hợp lệ → Chuyển vào `/op`.

**OpProtectedRoute Guard:**
- `/op` và `/tree` chỉ được phép truy cập khi `activeLinkStatus === 'DA_DUYET'` và có `activeMemberId`.
- **Ngoại lệ cho sửa đơn C1-S:** Route `/membership/setup` phải được phép truy cập khi sửa đơn lập họ (kể cả khi trạng thái đang là `CHO_DUYET` hay `NEEDS_REVISION`).
- Tuyệt đối không đọc `users.member_id` để quyết định đường đi. Nguồn sự thật (SSOT) là `activeMemberId` trên JWT (lấy từ bảng `user_member_links`).

---

## 5. API công khai cho Guest Claim (Chưa có JWT)

Guest chưa có JWT vẫn phải tìm được dòng họ và người trên cây để chạy Wizard EM.

### 5.1 Tìm dòng họ
`GET /api/public/tenants/search?q=`
- Rate limit theo IP để chống Scraping.
- `q` tối thiểu 2 ký tự.
- Trả về: `id`, `name`, `slug`. Không trả bất kỳ dữ liệu thành viên nào.

### 5.2 Tìm người để claim
`GET /api/public/tenants/:tenantId/members/claim-search?q=`
- Rate limit: tối đa 15 request/phút/IP.
- `q` tối thiểu 2 ký tự.
- Chỉ trả bản ghi có `status = CHINH_THUC`, `deleted_at = null` (Tuyệt đối không trả `DU_BI`).
- **Ghi chú: không lọc is_clan = true để đảm bảo con dâu / con rể cũng có thể đăng ký vào dòng họ của vợ/chồng.
- Payload tối thiểu (Không lộ PII): `id`, `full_name`, `alias`, `generation`, `branch_name`, `father_name`, `mother_name`, `birth_year`. (Cấm trả điện thoại, email, địa chỉ cụ thể, ngày/tháng sinh).

*Xử lý Claim trùng:* Không chặn lúc đăng ký nếu nhiều người claim cùng một EM. Chặn lúc Admin duyệt: một EM chỉ có tối đa một link `DA_DUYET`. Các đơn còn lại bị đánh dấu `DISPUTED` hoặc từ chối.

---

## 6. Cổng 423 và Hard-lock

Login khi `users.status = CHO_DUYET` trả mã lỗi HTTP **423** `ACCOUNT_CHO_DUYET`.

| Payload trả về | Mục đích & Ý nghĩa |
|----------------|--------------------|
| `canEdit` | Bằng `true` khi case có trạng thái `NEEDS_REVISION` |
| `reviewNote` | Bút phê / Lời nhắn từ Admin |
| `caseId` | ID của onboarding case đang chờ duyệt |
| `caseStatus` | `SUBMITTED` hoặc `NEEDS_REVISION` |
| `caseMetadata` | Nguyên khối `onboarding_cases.metadata` (chứa đủ 21 trường hoặc `claimed_member_id` + 3 lớp gia mật) |

*Ghi chú:* Các trường `temp_*` cũ trong bảng `users` không đủ dữ liệu cho revision. `AuthPage` phải đọc `caseMetadata` để nạp lại đầy đủ vào `RegisterForm`.

**Hard-lock (Khóa vĩnh viễn):** Là một mã lỗi riêng biệt **403** `ACCOUNT_PERMANENTLY_REJECTED` (kèm `canEdit: false`). Không dùng chung mã 423. FE sẽ khóa toàn bộ form, không hiển thị nút sửa chữa hay nộp lại.

---

## 7. Cổng Admin (`/admin/approval`)

**Quyền duyệt phân lập:**
- C2 / C1 (Gia nhập họ có sẵn): Được duyệt bởi `CLAN_ADMIN` của tenant đích.
- C2-S / C1-S (Lập dòng họ mới): Chỉ được duyệt bởi `SYSTEM_ADMIN`.

**Nhãn phân loại trực quan (trên danh sách):**
- `[NHẬN NGƯỜI TRÊN CÂY - EM]`
- `[KHAI BÁO MỚI - 21 TRƯỜNG]`
- `[LẬP DÒNG HỌ MỚI - CLAN SETUP]` (Tách biệt C2-S và C1-S)
- `[GIA NHẬP HỌ THỨ HAI - C1]`

**Màn hình đối soát (OpCaseDetailPage):**
- **Case EM:** Cột trái là thông tin member gốc trên cây, cột phải là 3 lớp gia mật và minh chứng của người nộp. Hiện cảnh báo đỏ nếu EM đã có link `DA_DUYET` hoặc đang `DISPUTED`.
- **Case 21 trường:** Chia 4 nhóm (Nhân thân, Tiền nhân 3 đời, Liên lạc/Cư trú, Minh chứng). Cho phép Admin chọn gán cha/mẹ/chi nhánh trên cây trước khi duyệt.
- **Case C1:** Hiển thị thông tin user đã có ở họ gốc và tenant đích. Không cho phép sửa `users.status`.

**Hành động (4 nút):**
| Nút | Hệ quả trên Backend |
|-----|--------------------|
| **Duyệt** | Transaction: Case EM thì nối link tới EM. Case 21 trường thì tạo `members` `CHINH_THUC` rồi nối link. Link được gán `DA_DUYET`. Tuyệt đối không ghi `users.member_id`. |
| **Trả sửa** | Yêu cầu bắt buộc điền ghi chú. Cập nhật Case sang `NEEDS_REVISION`. |
| **Từ chối mềm** | Bắt buộc điền lý do. Cập nhật sang `TU_CHOI` (người dùng được nộp lại đơn). |
| **Từ chối vĩnh viễn**| Yêu cầu xác nhận 2 bước + lý do. Cập nhật cờ `is_final_rejection = true` (Hard-lock). |

---

## 8. Danh mục File chịu ảnh hưởng

| Mã | File | Chức năng & Yêu cầu thay đổi |
|----|------|-----------------------------|
| MF-01 | `RegisterForm.jsx` | C2: Tích hợp chọn Claim EM hoặc Form 21 trường. Đóng gói payload vào `metadata`. |
| MF-02 | `AuthPage.jsx` | Lắng nghe mã 423 → Gọi `revision-notice`. Nạp `caseMetadata` vào form. Lắng nghe mã 403 hard-lock. |
| MF-03 | `AuthContext.jsx` | Cập nhật hàm `resolvePostLoginRedirect` theo Mục 4. Thêm hàm `register`. |
| MF-03b| `OpProtectedRoute.jsx` | Cho phép `/membership/setup` khi sửa đơn C1-S. Chặn truy cập `/op` nếu chưa `DA_DUYET`. |
| MF-04 | `ClaimMemberPage.jsx` | Dành cho C1 với `mode=add-clan` và `mode=revision`. |
| MF-04b| `ClanSetupPage.jsx` | Dành cho C1-S qua route `/membership/setup`. Tự động dùng phone/email của user. |
| MF-05 | `ClaimMemberWizard.jsx` | UI Tra cứu → Xác thực 3 lớp → Xác nhận đơn. |
| MF-06 | `RegistrationProfileForm.jsx`| UI nhập liệu chuẩn 21 trường phả hệ. |
| MF-07 | `MembershipStatusPage.jsx` | C1: Quản lý vòng đời `CHO_DUYET`, `NEEDS_REVISION`, `TU_CHOI`, hard-lock. |
| MF-08 | `HeaderClanSwitcher.jsx` | Bổ sung 2 nút: "Gia nhập họ khác" và "Lập dòng họ mới". Hiển thị case đang chờ duyệt. |
| MF-09 | `AdminUserApprovalPage.jsx` | Gắn nhãn loại hồ sơ theo Mục 7. |
| MF-10 | `OpCaseDetailPage.jsx` | Thiết kế giao diện đối soát cho Case EM, Case 21 trường và C1. |
| MF-11 | `auth.service.js` | Hàm `register` phải lưu cấu trúc `metadata`. Hàm `processUserApproval` không sinh member `DU_BI` và không gán `users.member_id`. |
| MF-11b| `mfo.service.js` | Có cơ chế tắt cờ Sandbox cho tenant sau khi kế hoạch 5 đời được duyệt (e.g. `approvePlan`). |
| MF-12 | `App.jsx` | Điều chỉnh Router: Giữ `/membership/claim`, `/membership/status`, `/membership/setup`. `/op` và `/tree` require approved. |

---

## 9. Lộ trình triển khai (Lát cắt)

- **Lát 0 — Backend Cốt lõi:** Cấm tạo `DU_BI` và cấm ghi `users.member_id` khi duyệt tài khoản. Hàm `register` lưu `metadata`. API Login trả 423 kèm `caseMetadata`. Tách biệt 403 Hard-lock. Tắt Sandbox khi duyệt MFO plan.
- **Lát 1 — Frontend C2 (Guest):** Nâng cấp `RegisterForm` đính kèm `ClaimMemberWizard` và `RegistrationProfileForm`. Xây dựng API public search có giới hạn rate-limit.
- **Lát 2 — Frontend Revision (423):** Xử lý luồng nạp lại `caseMetadata` vào form tại `AuthPage.jsx` khi bị trả sửa; đóng băng giao diện khi gặp Hard-lock 403.
- **Lát 3 — Frontend Multi-Home (C1 & C1-S):** Hoàn thiện `/membership/claim` và `/membership/setup` cho user đã có JWT. Bổ sung nút bấm trên Switcher. Không can thiệp `users.status`.
- **Lát 4 — Backend & Frontend Admin OP:** Hoàn thiện danh sách phân loại hồ sơ, màn hình đối soát 2 bên, và bộ 4 nút hành động. Chỉ thao tác trên `user_member_links`.
- **Lát 5 — Redirect & Route Guards:** Cập nhật `AuthContext` và `OpProtectedRoute` theo chính xác luật ưu tiên ở Mục 4. Cho phép sửa đơn C1-S tại `/membership/setup`.

---

## 10. Tiêu chí nghiệm thu

1. **C2 Claim EM:** Đăng ký không tự tạo member. Chỉ khi Admin duyệt mới sinh link `DA_DUYET`. Đăng nhập thành công sẽ vào `/op`.
2. **C2 No EM:** Dữ liệu 21 trường lưu trong `metadata`. Admin duyệt mới tạo `members` `CHINH_THUC`. Tuyệt đối không xuất hiện member `DU_BI` trong CSDL.
3. **C2 Trả sửa:** Login trả 423 `canEdit: true`, form nạp lại đầy đủ 21 trường hoặc dữ liệu Claim EM để nộp lại.
4. **Hard-lock:** Admin từ chối vĩnh viễn $\rightarrow$ Login trả 403, giao diện thông báo khóa và không có nút chỉnh sửa.
5. **C1 (Gia nhập thêm họ):** User dùng số điện thoại/email cũ không bị lỗi 409. Trạng thái họ gốc vẫn `DA_DUYET`. Họ đích hiển thị `CHO_DUYET` cho đến khi duyệt.
6. **C1-S (Lập họ mới):** User của họ A lập họ B không bị lỗi 409. Họ A không đổi trạng thái. Khi duyệt xong, link tại Tenant B là `CLAN_ADMIN`, `is_default = false`.
7. **C2-S (Guest lập họ):** Chỉ hiển thị cho `SYSTEM_ADMIN` duyệt. Sau khi duyệt, sinh đủ bảng tenant và bản ghi founder member. Sandbox bật đến khi nộp MFO 5 đời.
8. **Tranh chấp Claim:** Hai người cùng Claim một EM sẽ không bị chặn lúc gửi đăng ký. Khi Admin duyệt người đầu tiên, đơn thứ hai sẽ bị khóa hoặc đánh dấu `DISPUTED`.
9. **Ngữ cảnh (Context):** `users.member_id` không còn tác dụng; hệ thống chỉ sử dụng `activeMemberId` lấy từ `user_member_links` trong JWT.

---

## 11. Kết luận

Phiên bản `V1.5.0` chốt hạ 4 đường ống nghiệp vụ cốt lõi: C2, C1, C2-S, C1-S. Chế độ Sandbox là thuộc tính riêng của Tenant và sẽ tự động tắt khi hoàn thành phả đồ 5 đời, không trùng lặp với `activeLinkStatus`. Các route `/membership/*` được bảo tồn hoàn chỉnh để vận hành kiến trúc Multi-Home. Backend là chốt chặn duy nhất có quyền sinh member hoặc nối link. Hệ thống chấm dứt hoàn toàn tình trạng rác dữ liệu `DU_BI` và khóa chéo tài khoản.