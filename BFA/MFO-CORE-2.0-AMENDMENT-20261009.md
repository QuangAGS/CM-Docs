# **BẢN CẬP NHẬT KIẾN TRÚC & QUY CHUẨN TRẠNG THÁI (AMENDMENT TO MFO CORE LIFECYCLE 2.0)**

**Mã văn bản: MFO-CORE-2.0-AMENDMENT-20261009**

**Ngày cập nhật: 09/10/2026**

**Phạm vi áp dụng: Thay thế & chuẩn hóa các phần ma trận trạng thái, quyền xóa và hành vi CSDL tại Phần 1 (Mục II.2) và Phần 2 (Mục 3 & 4\) của tài liệu MFO Core Lifecycle 2.0.**

### **1\. NÂNG CẤP BẢNG MA TRẬN TRẠNG THÁI GATE 1 (MFO\_PLAN)**

***Sửa đổi & Chuẩn hóa:*** **Thống nhất trạng thái đích khi SUBMIT là PENDING (Chờ duyệt Khung 5L) thay cho SUBMITTED để đồng bộ 100% giữa Database, SRPF State Engine và Giao diện Thẩm định Admin.**

| Trạng thái Hiện tại (Current State) | Hành động Trigger (Action) | Trạng thái Đích (Target State) | Mode Giao diện (viewMode) | Quyền thao tác & Tác động CSDL |
| :---- | :---- | :---- | :---- | :---- |
| ***(Khởi tạo)*** | **SAVE\_DRAFT** | **DRAFT** | **EDITABLE** | **Tạo bản ghi proposals nháp (plan\_ok \= false).** |
| **DRAFT** | **SAVE\_DRAFT** | **DRAFT** | **EDITABLE** | **Cập nhật payload.graph\_snapshot & canvas\_delta.** |
| **DRAFT** | **SUBMIT** | **PENDING** | **READONLY** | **Chuyển hồ sơ vào Hàng đợi Thẩm định Gate 1 của Admin.** |
| **DRAFT** | **DELETE\_DRAFT** | ***(Soft Delete)*** | **N/A** | **Soft-Delete (deleted\_at \= NOW()). Xóa an toàn.** |
| **PENDING** | **APPROVE** | **APPROVED** | **WORKBENCH** | **Gán payload.plan\_ok \= true. Chốt granted\_generation. Mở xưởng Workbench.** |
| **PENDING** | **RETURN\_FOR\_REVISION** | **NEEDS\_REVISION** | **EDITABLE** | **Lưu admin\_note. Mở khóa Canvas 5L cho EU sửa rồi Trình lại.** |
| **NEEDS\_REVISION** | **SAVE\_DRAFT** | **NEEDS\_REVISION** | **EDITABLE** | **Lưu vết chỉnh sửa Canvas của EU.** |
| **NEEDS\_REVISION** | **SUBMIT** | **PENDING** | **READONLY** | **Trình lại Khung 5L đã sửa cho Admin.** |
| **NEEDS\_REVISION** | **DELETE\_DRAFT** | ***(Soft Delete)*** | **N/A** | **Soft-Delete (deleted\_at \= NOW()). EU hủy tờ trình.** |

### **2\. NÂNG CẤP BẢNG MA TRẬN TRẠNG THÁI GATE 2 (MFO\_RESULT)**

***Sửa đổi & Chuẩn hóa:*** **Gate 2 vận hành đủ 3 mức quyết định (APPROVE, RETURN\_FOR\_REVISION, REJECT). Đột biến CSDL thật (members, marriages) chỉ diễn ra khi Gate 2 chốt APPROVED.**

| Trạng thái Hiện tại (Current State) | Hành động Trigger (Action) | Trạng thái Đích (Target State) | Mode Giao diện (viewMode) | Tác động CSDL & Nghiệp vụ Gate 2 |
| :---- | :---- | :---- | :---- | :---- |
| **APPROVED *(Gate 1\)*** | **SAVE\_DRAFT** | **APPROVED** | **WORKBENCH** | **Lưu nháp dữ liệu Workbench (result\_submitted \= false).** |
| **APPROVED *(Gate 1\)*** | **SUBMIT** | **UNDER\_REVIEW** | **READONLY** | **Gán result\_submitted \= true. Chuyển vào Hàng đợi Nghiệm thu.** |
| **APPROVED *(Gate 1\)*** | **DELETE\_DRAFT** | ***(Soft Delete)*** | **N/A** | **Soft-Delete (deleted\_at \= NOW()). EU hủy tờ trình.** |
| **UNDER\_REVIEW** | **APPROVE** | **APPROVED** | **TERMINAL** | **Gán result\_ok \= true. KÍCH HOẠT TRANSACTION GHI CSDL THẬT (members, marriages). Đóng băng vĩnh viễn.** |
| **UNDER\_REVIEW** | **RETURN\_FOR\_REVISION** | **NEEDS\_REVISION** | **EDITABLE** | **Gán result\_submitted \= false, lưu admin\_note. Mở khóa Form Workbench.** |
| **UNDER\_REVIEW** | **REJECT** | **REJECTED** | **TERMINAL** | **Gán result\_ok \= false, lưu admin\_note. deleted\_at \= NULL. Đóng băng vĩnh viễn (Terminated State).** |
| **NEEDS\_REVISION** | **SAVE\_DRAFT** | **NEEDS\_REVISION** | **EDITABLE** | **Lưu tạm thông tin Workbench đã sửa.** |
| **NEEDS\_REVISION** | **SUBMIT** | **UNDER\_REVIEW** | **READONLY** | **Gán result\_submitted \= true. Trình lại Tờ khai.** |
| **NEEDS\_REVISION** | **DELETE\_DRAFT** | ***(Soft Delete)*** | **N/A** | **Soft-Delete (deleted\_at \= NOW()). EU hủy tờ trình.** |

### **3\. ĐIỀU CHỈNH CHÍNH THỨC: BẢNG NGUYÊN TẮC QUYỀN XÓA (EU DELETE MATRIX)**

**Đính chính mục II.2 & Phụ lục Mục 3 của tài liệu cũ: Loại bỏ cờ EDITABLE đối với trạng thái REJECTED. Trạng thái REJECTED là Terminal State (Đóng băng lưu vết Bút phê Admin), KHÔNG CHO PHÉP XÓA VÀ KHÔNG CHO PHÉP SỬA DO'S/DON'TS.**

| \================================================================================ MA TRẬN QUYỀN XÓA TỜ TRÌNH CỦA END USER (proposals.deleted\_at \= NOW()) \================================================================================  🟢 CHO PHÉP XÓA (ALLOWED\_DELETE\_STATES \= \['DRAFT', 'NEEDS\_REVISION'\]):     1\. DRAFT: Bản nháp đang soạn thảo ở Gate 1 hoặc Gate 2\.     2\. NEEDS\_REVISION: Tờ trình bị Admin trả về yêu cầu sửa ở Gate 1 hoặc Gate 2\.     3\. APPROVED (Gate 1 \- plan\_ok \= true nhưng result\_submitted \= false): EU đổi ý không kê khai tiếp.  🔴 CẤM XÓA (PROHIBITED\_DELETE\_STATES):     1\. PENDING / UNDER\_REVIEW: Đang trong phòng thẩm định/nghiệm thu của Admin.     2\. APPROVED (Gate 2 \- result\_ok \= true): Đã chốt Sổ thật CSDL gia tộc.     3\. REJECTED: Đã bị Bác bỏ vĩnh viễn. Bắt buộc giữ deleted\_at \= NULL để bảo lưu Bút phê Admin.  |
| :---- |

### **4\. BỔ SUNG QUY TRÌNH HIỂN THỊ HỒ SƠ REJECTED TRÊN FRONTEND**

1. **Điều kiện Query Backend: WHERE deleted\_at IS NULL. Dòng REJECTED vẫn trả về trong danh sách của EU.**  
2. **Hiển thị Dropdown List (MyMfoPlans.jsx):**

   * **Nhãn: \<DateTime\> \- Tờ khai bị Bác bỏ / Từ chối (REJECTED)**  
3. **Chế độ xem (viewMode \= 'TERMINAL'):**  
   * **Hiển thị Banner Cảnh báo Đỏ: 🛑 TỜ KHAI ĐÃ BỊ BAN QUẢN TRỊ BÁC BỎ VĨNH VIỄN. Lý do: \[admin\_note\]**  
   * **Vô hiệu hóa toàn bộ Popup, Form, Active Form, Canvas (Read-Only 100%).**  
   * **Ẩn/Vô hiệu hóa hoàn toàn nút Xóa và nút Nộp lại.**  
   * **Hiển thị nút điều hướng: "+ Khởi tạo Tờ trình MFO mới".**

### **📌 KẾT LUẬN TÍCH HỢP**

**Các nội dung cập nhật trên sẽ được hợp nhất trực tiếp vào văn bản MFO Core Lifecycle 2.0. Bộ quy chuẩn này đảm bảo tính toàn vẹn dữ liệu, đồng bộ giữa Backend SRPF Framework, Database và Frontend React Flow.**

