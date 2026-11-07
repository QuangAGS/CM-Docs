# ĐẶC TẢ THIẾT KẾ CHÍNH THỨC: RP & OP

**Mã tài liệu:** RP-OP-DESIGN-SPEC-V2.2  
**Dự án:** myclan.com.vn  
**Phiên bản:** 2.2-OFFICIAL  
**Ngày:** 2026-11-06  
**Trạng thái:** Chính thức

---

## 0. Chuẩn hóa khái niệm

(Giữ nguyên như V2.1)

---

## 1–7. Backend

(Giữ nguyên như V2.1: State Machines, BPL, CL, Security, Elder Support, Optimization, Deprecation)

---

## 8. Frontend [FE]

### 8.1 Màn hình & Luồng [FE-SCR]

| Mã | Màn hình | Hiện tại | Thiết kế | GAP | Đánh giá |
|----|----------|----------|----------|-----|----------|
| FE-SCR-01 | Đăng ký / OTP | Có (`AuthPage`) | Giữ | Không | **Sử dụng lại** |
| FE-SCR-02 | Chọn dòng họ | Có một phần | Multi-Home Selector | Có | **Biến đổi** |
| FE-SCR-03 | Claim — Tìm member | Không có | Tìm trên cây, chọn | P0 | **Thêm vào** |
| FE-SCR-04 | Claim — Xác thực 3 lớp | Không có | Form trắc nghiệm + bảo lãnh | P0 | **Thêm vào** |
| FE-SCR-05 | Claim — Theo dõi trạng thái | Không có | Trang chờ duyệt | P1 | **Thêm vào** |
| FE-SCR-06 | MFO Workbench | Có | Giữ | Không | **Sử dụng lại** |
| FE-SCR-07 | Clan Switcher | Không có | Dropdown trên Header | P0 | **Thêm vào** |
| FE-SCR-08 | Sandbox Banner | Không có | Banner "Đang khởi tạo" | P1 | **Thêm vào** |

### 8.2 Redirect & Navigation [FE-NAV]

| Mã | Logic | Hiện tại | Thiết kế | Đánh giá |
|----|-------|----------|----------|----------|
| FE-NAV-01 | Sau login, chưa có member | Vào `/op` | Vào `/op/base-profile` hoặc Claim | **Biến đổi** `AuthContext.jsx` |
| FE-NAV-02 | Sau login, có member | Vào `/op` | Vào `/op` hoặc `/tree` | **Sử dụng lại** |
| FE-NAV-03 | Sandbox (DRAFT) | Không có | Chặn điều hướng ngoài MFO/profile | **Thêm vào** route guard |
| FE-NAV-04 | Claim đang chờ | Không có | Chỉ cho xem trạng thái | **Thêm vào** |

### 8.3 Clan Switcher [FE-SW]

| Mã | Thành phần | Hiện tại | Thiết kế | Đánh giá |
|----|------------|----------|----------|----------|
| FE-SW-01 | Dropdown dòng họ | Không có | Header, gọi `switch-context` | **Thêm vào** |
| FE-SW-02 | Hiển thị link_type | Không có | Label: Họ nội / Họ ngoại / ... | **Thêm vào** |
| FE-SW-03 | Dòng họ mặc định | Không có | Đánh dấu `is_default` | **Thêm vào** |

### 8.4 Thông báo [FE-NOTI]

| Mã | Loại | Hiện tại | Thiết kế | Đánh giá |
|----|------|----------|----------|----------|
| FE-NOTI-01 | In-app notification | Có | Hiển thị theo CL | **Biến đổi** |
| FE-NOTI-02 | Banner Sandbox | Không có | "Bạn đang trong chế độ khởi tạo" | **Thêm vào** |
| FE-NOTI-03 | Thông báo Dispute | Không có | Cảnh báo trên chuông Admin | **Thêm vào** |

### 8.5 Elder Support FE [FE-ELD]

| Mã | Thành phần | Hiện tại | Thiết kế | Đánh giá |
|----|------------|----------|----------|----------|
| FE-ELD-01 | Nút "Nghe" trên Claim | Không có | Có trên mọi màn hình Claim | **Thêm vào** |
| FE-ELD-02 | Ngôn ngữ đơn giản | Có | Áp dụng cho Claim | **Biến đổi** |
| FE-ELD-03 | Xác nhận trước khi nộp | Có một phần | Áp dụng cho Claim | **Biến đổi** |

---

## 9. Deprecation Matrix [DEP]

(Giữ nguyên như V2.1: DEP-01, DEP-02)

---

## 10. Tài liệu liên quan

| Tài liệu | Phiên bản |
|----------|-----------|
| BPMN RP & OP | 2.5.0-FROZEN |
| Implementation Plan | v1.3-READY |
| FTDI Spec | v1.0.4+ |

---

**Kết luận:** Bản 2.2 bổ sung mục FE theo cùng format với BE. Mỗi thành phần có mã quy chiếu.
