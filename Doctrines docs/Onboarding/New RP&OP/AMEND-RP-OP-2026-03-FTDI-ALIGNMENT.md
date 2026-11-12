# TÀI LIỆU PHỤ LỤC THIẾT KẾ KỸ THUẬT FRONTEND
## ĐIỀU CHỈNH KIẾN TRÚC GIAO DIỆN VÀ ĐIỀU PHỐI LUỒNG RP & OP
### AMEND-RP-OP-2026-03-FTDI-ALIGNMENT
### (Phụ lục kỹ thuật bổ trợ cho RP-OP-DETAILED-IMPLEMENTATION-V2.1 và FTDI-PRACTICAL-SPEC-1.0.4)

---

## 1. Thông tin văn kiện

| Mục | Giá trị |
|-----|---------|
| Tên | Thiết kế kiến trúc Frontend Đăng ký & Nhận diện nhân thân (Bổ sung tích hợp FTDI & Multi-Home) |
| Mã | `AMEND-RP-OP-2026-03-FTDI-ALIGNMENT` |
| Phiên bản | **V2.0.0 - DRAFT / IMPLEMENTING** |
| Ngày | 12/11/2026 |
| Nền tảng | Multi-Home V1.5.0, FTDI-PRACTICAL-SPEC-1.0.4 (Giai đoạn G2) |
| Kế thừa | AMEND-RP-OP-2026-02-FE V1.5.0 |

**Phương án chốt quá độ (Progressive Cutover G2):** Vẫn giữ nguyên các trường legacy `father_id`, `mother_id`, và `child_type` (được khai báo qua `temp_relationship` trên Form) trên bảng `members` để phục vụ UAT Multi-Home. Backend sẽ thực hiện cơ chế Dual-Write (ghi đồng thời) sang bảng `parentages` theo FTDI. Khi nào pha G4 hoàn tất, Frontend mới loại bỏ hoàn toàn các trường legacy.

---

## 2. Mục đích

1. Củng cố thiết kế Frontend Lát 1 đến Lát 5 của New RP/OP (từ V1.5.0) sao cho tương thích với mô hình đồ thị chuẩn FTDI.
2. Quy định rõ hợp đồng DTO trả về từ API tìm kiếm công khai (`claim-search`) để hiển thị đúng bối cảnh con dâu/con rể (`is_clan = false`) mà không gây gãy quy trình hiện tại.
3. Giải phóng ràng buộc `is_clan = true` để không bỏ sót các trường hợp nhận diện người phối ngẫu (hôn nhân) trên cây gia phả.
4. Đảm bảo UI/UX tiếp tục sử dụng các tham số kế thừa (`father_name`, `mother_name`, `temp_relationship`) để giữ ổn định hệ thống trong giai đoạn G2 của lộ trình FTDI.

---

## 3. Tác động của FTDI-PRACTICAL-SPEC-1.0.4 tới New RP & OP

### 3.1. Hợp đồng API `claim-search` (Lát 1)

Việc gỡ bỏ bộ lọc `is_clan` là bắt buộc để hỗ trợ tìm kiếm toàn bộ thành viên đang hiển diện trên cây (bao gồm cả con dâu / con rể). 

*   **API Endpoint:** `GET /api/public/tenants/:tenantId/members/claim-search`
*   **Điều kiện truy vấn (G2):**
    *   `tenant_id = :tenantId`
    *   `status = 'CHINH_THUC'`
    *   `deleted_at IS NULL`
    *   *(Bỏ điều kiện `is_clan = true`)*
*   **Payload DTO trả về (G2):**
    Vẫn kế thừa cấu trúc V1.5.0 (ẩn SĐT, Email, Địa chỉ, Ngày tháng sinh chi tiết).
    Backend tự động map `father_name` và `mother_name` thông qua `father_id` / `mother_id` (vẫn đang duy trì).
    Đối với con dâu/con rể (xác định qua `child_type` = `CON_DAU` hoặc `CON_RE` trên Backend), hệ thống trả về thêm trường phụ trợ (ví dụ: `spouse_name` thông qua bảng `marriages`) nếu có.

### 3.2. Form Khai báo 21 trường (Lát 1 - `RegistrationProfileForm.jsx`)

Vì hệ thống đang ở **Giai đoạn G2 (Dual-Write)**, Form khai báo vẫn thu thập các trường theo cấu trúc cũ để tương thích với `members` legacy:

*   **Trường `temp_relationship`:** Vẫn sử dụng danh sách tùy chọn (Con đẻ, Con dâu, Con rể, Con nuôi, Con đỡ đầu, Khác).
*   **Trường `father_name` / `mother_name`:** Người dùng (bất kể là con đẻ hay dâu/rể) đều khai báo tên cha mẹ của mình.
*   **Mục đích:** Dữ liệu này được đóng gói vào `onboarding_cases.metadata.registration_profile`. Khi Admin phê duyệt, Backend sẽ dựa vào `temp_relationship` để vừa ghi vào `members.child_type`, vừa ghi đồng thời vào `parentages.relationship_type` (Dual-write) theo bảng mapping của FTDI.

### 3.3. Cổng phê duyệt Admin (Lát 4 - `OpCaseDetailPage.jsx`)

Màn hình đối soát của Admin phải phản ánh đúng cơ chế Dual-Write:

*   **Case 1 (Claim EM):** 
    Khi duyệt nhận diện thành viên có sẵn trên cây, Admin chỉ đối soát 3 lớp gia mật. Backend tự động gán `user_member_links` sang `DA_DUYET`. Việc kiểm tra vòng lặp đồ thị (Cycle Detection) hay Parentages không thay đổi vì thành viên này đã nằm sẵn trên cây.
*   **Case 2 (Khai báo mới 21 trường - Không có EM):**
    Khi Admin bấm "Nối cây & Phê duyệt", giao diện vẫn cung cấp chức năng chọn Nút cha/mẹ (hoặc Nút vợ/chồng nếu `temp_relationship` là Con dâu/Con rể).
    Backend (Lát 0) sẽ nhận ID của nút được chọn, ghi `members` với `father_id`/`mother_id` và `child_type` cũ, đồng thời gọi `syncMemberParentages` để sinh bản ghi `parentages` (quan hệ dọc) hoặc `marriages` (quan hệ ngang) tương ứng.
*   **Advisory Lock & Fail-Closed:** Khi thực thi thay đổi cấu trúc cây, Admin UI phải sẵn sàng hiển thị thông báo `TOPOLOGY_BUSY_RETRY` (lỗi 409 hoặc 423) nếu Backend chặn ghi do Advisory Lock (khi có 2 Admin cùng sửa một cây).

---

## 4. Đặc tả luồng C1 & C2 (Cập nhật G2)

### 4.1 C2 — Guest mới (Đăng ký tại `/auth`)

*   **Khởi phát:** `/auth` → `RegisterForm` (Intent Selector)
*   **Nạp dữ liệu:** Nếu chọn Gia nhập, người dùng tương tác với `JoinClanForm`.
*   **Xử lý Claim EM (Wizard 3 bước):** 
    Gọi `/api/public/tenants/search` để tìm họ.
    Gọi `/api/public/tenants/:tenantId/members/claim-search` (KHÔNG LỌC `is_clan`) để tra cứu.
    Hệ thống lưu trữ ID và 3 câu hỏi gia mật.
*   **Xử lý 21 trường:** Nếu không có EM, khai báo đủ `temp_relationship` và `father_name` để Backend xử lý Dual-write.
*   **Payload:** Một khối duy nhất chứa `registration_profile` (và `claimed_member_id` nếu có). Không rải `temp_*` ra ngoài payload.

### 4.2 C1 — User đã có tài khoản (Multi-Home tại `/membership/claim`)

*   **Khởi phát:** Đã đăng nhập, chọn "Gia nhập dòng họ khác" → `/membership/claim?mode=add-clan`
*   **Giao diện:** Tái sử dụng `ClaimMemberWizard` và `RegistrationProfileForm`. Token JWT (có chứa TTL từ token cũ) được gửi kèm, nhưng khi gọi `/public/*` phải gỡ header `Authorization` để tránh 401 Session reset.
*   **Sau nộp đơn:** `users.status` của tài khoản gốc KHÔNG đổi. Chỉ có liên kết mới ở trạng thái `CHO_DUYET`.

---

## 5. Danh sách các File cốt lõi cần hiệu chỉnh (Lát 1 - Đã vá)

| Mã | File | Tác động FTDI & Multi-Home (G2) |
|----|------|---------------------------------------------------------|
| MF-01 | `publicSearch.routes.js` | Mở rộng điều kiện lọc (Bỏ `is_clan`), chỉ chặn `BI_KHOA`, `TU_CHOI`. Trả về `father_name`, `mother_name` theo cấu trúc legacy để UI duy trì ổn định. |
| MF-02 | `ClaimMemberWizard.jsx` | Thêm thẻ hiển thị Cha/Mẹ từ payload. Dừng nổi bọt sự kiện `onClick`. Đảm bảo clear `Authorization` header khi gọi API Public. |
| MF-03 | `JoinClanForm.jsx` | Clear `Authorization` header khi tra cứu Tenant Public. Đóng gói sạch `registration_profile` không lộ `temp_*`. |
| MF-04 | `CreateClanForm.jsx` | Đóng gói sạch `registration_profile` (chế độ `CLAN_SETUP`, `generation: 1`). |
| MF-05 | `WaitingPage.jsx` | Bóc tách rõ 3 nhãn: Claim EM, Khai báo 21 trường, Lập họ. Render dựa trên `data.registration_profile`. Lọc bỏ mọi trường `temp_*` trước khi gửi lên API `POST /auth/register`. |
| MF-06 | `auth.service.js` | Hàm `registerUser` tạo `users` (chỉ định danh), ghi toàn bộ metadata vào `onboarding_cases` trong một Transaction nguyên tử (Atomic). Hàm `processUserApproval` chỉ đọc metadata, tạo `user_member_links` và `members` (nếu cần), tuyệt đối không sinh `DU_BI`. |

---

## 6. Chốt chặn thiết kế G2

1. **Không Drop `child_type` & `father_id`:** Mọi Form Frontend (`RegistrationProfileForm`) vẫn thu thập bình thường. Sự phức tạp của việc chuyển đổi sang Đồ thị (Graph) hoàn toàn do Backend xử lý ẩn (`mfo.service.js` / `onboarding.service.js` Dual-Write).
2. **Không tự quyết định vị trí nhánh trên Form C2:** Dù người dùng khai báo là con dâu / con đẻ, form đăng ký chỉ làm nhiệm vụ **Khai báo (Declaration)**. Việc gắn vào nút Vợ/Chồng hay Cha/Mẹ thực tế trên cây sẽ do Admin (Cổng G01) quyết định ở Lát 4.
3. **SSOT Multi-Home:** Sau khi Admin duyệt, Backend trả về `users.status = DA_DUYET`. Khi người dùng đăng nhập, thông tin dòng họ active (`activeTenantId`, `activeMemberId`, `roleInTenant`) sẽ được nội suy trực tiếp từ `user_member_links`, hoàn tất chu trình Multi-Home.

---
**Bản tài liệu này là phần bổ trợ chiến lược cho AMEND-RP-OP-2026-02-FE V1.5.0 nhằm đảm bảo hệ thống không bị đứt gãy trong quá trình quá độ lên FTDI Core Engine (Giai đoạn G2).**
