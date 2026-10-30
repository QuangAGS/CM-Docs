# Family Tree (FT) Doctrine
## Hệ thống Triết lý & Quy tắc Nghiệp vụ Quản lý Cây Gia Phả — myclan.com.vn

---

## TỔNG QUAN (OVERVIEW)

Tài liệu **Family Tree (FT) Doctrine** định nghĩa toàn bộ quy chuẩn dữ liệu, thuật toán dựng cây, quy tắc nghiệp vụ (Business Rules), bảo toàn logic và cơ chế tương tác Canvas cho hệ thống quản lý gia phả số **myclan.com.vn**. 

Tài liệu này đóng vai trò là "Hiến pháp kỹ thuật" (Technical & Product Blueprint) dành cho đội ngũ Phát triển Sản phẩm (Product), Thiết kế (UI/UX) và Kỹ thuật (Backend/Frontend/Data Engineers).

---

## 1. CORE DATA MODEL & NODE LOGIC (MÔ HÌNH DỮ LIỆU & NÚT CỐT LÕI)

### 1.1. Thực thể Thành viên (Member Node)
Mỗi thành viên trên FT Canvas đại diện cho một nút (Node) đồ thị với các trạng thái:

*   **Active Node (Nút chính thức):** Nút lưu trữ đầy đủ thông tin cá nhân và đã liên kết/có khả năng liên kết với tài khoản người dùng thực tế.
*   **Placeholder Node (Nút tạm/Giữ chỗ):** Nút được hệ thống tạo tự động hoặc do Trưởng ban gia phả tạo để duy trì tính liên tục của phả đồ khi thiếu thông tin (ví dụ: Vợ chưa rõ tên, người con biệt tích, cội nguồn chưa rõ danh tính).
*   **Virtual Node (Nút ảo/Hôn nhân):** Nút trung gian đại diện cho mối liên kết hôn nhân giữa 2 hoặc nhiều thành viên để nối nhánh xuống các con.

#### Các thuộc tính cốt lõi của Node:
*   `id`: UUID định danh duy nhất.
*   `clan_id`: ID Dòng họ.
*   `full_name`, `given_name`, `courtesy_name` (Tên tự), `posthumous_name` (Tên hiệu/Thụy).
*   `gender`: Nam / Nữ / Khác.
*   `life_status`: Còn sống / Đã mất / Mất tích.
*   `birth_date_solar`, `birth_date_lunar`: Ngày sinh Âm/Dương.
*   `death_date_solar`, `death_date_lunar`: Ngày mất Âm/Dương.
*   `burial_location`: Tọa độ & địa chỉ mộ phần.
*   `generation_level`: Đời thứ N (tính từ Thủy tổ = 1).

---

### 1.2. Thực thể Quan hệ (Edge / Link Types)
Mối quan hệ giữa các Node là đồ thị có hướng (Directed Graph) chia làm 2 nhóm chính:

#### A. Parent-Child Edge (Huyết thống / Nhánh dọc)
*   `bloodline`: Con đẻ.
*   `adopted`: Con nuôi (có cờ `is_adopted = true`).
*   `stepchild`: Con riêng của vợ/chồng (có cờ `is_stepchild = true`).

#### B. Spouse Edge (Hôn nhân / Nhánh ngang)
*   `marriage_order`: Thứ tự đời vợ/chồng (1, 2, 3...).
*   `spouse_role`: 
    *   *Nam:* Chính thất (Vợ cả), Thứ thất (Vợ lẽ), Kế thất (Vợ kế).
    *   *Nữ:* Chồng chính, Chồng sau.
*   `marriage_status`: Đang gắn kết, Ly hôn, Một bên qua đời.

---

### 1.3. Quy chuẩn Đánh số Gia phả (Genealogical Numbering System)
Hệ thống áp dụng **Quy chuẩn d'Aboville sửa đổi (Dành cho Gia phả Việt Nam)** để tự động cấp mã định danh vị trí (Position Code):

*   **Thủy tổ (Thế hệ 1):** Mã `1`
*   **Con trưởng của Thủy tổ (Thế hệ 2):** Mã `1.1`
*   **Con thứ hai của Thủy tổ (Thế hệ 2):** Mã `1.2`
*   **Con trưởng của Con thứ hai (Thế hệ 3):** Mã `1.2.1`

> **Quy tắc:** Số chữ số phân tách bằng dấu chấm biểu thị cho số Đời (Thế hệ). Thứ tự số cuối cùng thể hiện thứ bậc sinh trong gia đình.

---

## 2. DYNAMIC FT GENERATION ALGORITHM (THUẬT TOÁN DỰNG CÂY)

### 2.1. Anchor Node Selection (Lựa chọn Điểm tựa dựng cây)
Cây gia phả không cố định một góc nhìn duy nhất mà dựng động dựa trên **Anchor Node** (Nút làm mốc) được người dùng chọn:

1.  **Ancestry View (Chế độ Tổ tiên):** Lấy Anchor Node làm gốc ở dưới cùng, dựng ngược lên Cha/Mẹ, Ông/Bà, Cụ, Mị (Cây đi từ dưới lên).
2.  **Descendant View (Chế độ Hậu duệ - Chuẩn Gia phả Việt Nam):** Lấy Thủy tổ, Tổ phụ hoặc Trưởng chi làm gốc ở trên cùng, dựng tỏa xuống các thế hệ con cháu (Cây đi từ trên xuống).
3.  **Hourglass View (Chế độ Đồng hồ cát):** Anchor Node ở giữa; phía trên hiển thị Tổ tiên direct, phía dưới hiển thị Hậu duệ direct.
4.  **Full Clan View (Toàn cảnh Dòng họ):** Dựng từ Thủy tổ cao nhất (`generation_level = 1`), tự động trải rộng tất cả các Chi/Nhánh/Phái.

---

### 2.2. Thuật toán Dàn trang & Chống đè đụng (Layout & Edge Crossing)
*   **Generational Alignment (Căn chỉnh Thế hệ):** Tất cả các Node có cùng `generation_level` bắt buộc phải nằm trên cùng một đường gióng ngang (Y-axis Alignment).
*   **Sub-tree Clustering (Gom cụm Nhánh):** Mỗi gia đình nhỏ (Cha + Mẹ + Con) tạo thành một Sub-tree Block. 
*   **Dynamic Spacing (Khoảng cách Động):** Khoảng cách giữa 2 Node anh em $S_1, S_2$ được tính toán theo độ rộng toàn bộ nhánh con cháu của $S_1$ và $S_2$, đảm bảo không có đường nối (Edge) nào cắt ngang qua Node khác.

$$X(S_2) \ge X(S_1) + \text{Width}(\text{Subtree}(S_1)) + \text{Padding}$$

---

## 3. ADVANCED CANVAS OPERATIONS (TÁC VỤ VẬN HÀNH CANVAS)

### 3.1. Thao tác Điều hướng & Trực quan hóa
*   **Zoom & Pan:** Cho phép phóng to, thu nhỏ ($10\% - 500\%$), kéo rê Canvas mượt mà (Smooth Panning).
*   **Minimap:** Bản đồ thu nhỏ ở góc Canvas hiển thị khung nhìn hiện tại so với toàn bộ cây.
*   **Focus & Center:** Click đúp vào một Node bất kỳ để Canvas tự động căn giữa (Auto-center) và highlight màu nổi bật.
*   **Collapse / Expand Branch:**
    *   Mỗi Node cha/mẹ có nút `[-]` hoặc `[+]`.
    *   Bấm `[-]`: Thu gọn toàn bộ nhánh hậu duệ bên dưới, giúp giảm tải Canvas.
    *   Bấm `[+]`: Mở rộng lại nhánh hậu duệ.
*   **Smart Search & Highlight:** Tìm kiếm theo Tên, Tên hiệu, Năm sinh, Đời thứ N. Hệ thống cuộn màn hình (Smooth scroll) đến vị trí Node và kích hoạt hiệu ứng nhấp nháy (Pulse effect).

---

### 3.2. Chuyển Nhánh Trực quan (Branch Re-parenting via Drag & Drop)
Khi phát hiện sai sót lịch sử hoặc đính chính gia phả, Trưởng ban gia phả có thể di chuyển toàn bộ một nhánh:

1.  **Thao tác Kéo-Thả:** Kéo Node đầu nhánh $N_{sub}$ và Thả vào Node Cha/Mẹ mới $N_{parent\_new}$.
2.  **Kiểm tra Điều kiện (Pre-validation):** Hệ thống tự động chạy thuật toán kiểm tra Logic (Chống vòng lặp & Tuổi tác).
3.  **Hộp thoại Xác nhận Biến động (Diff Preview):** Hiển thị sơ đồ so sánh trạng thái Cây **Trước** và **Sau** khi di chuyển.
4.  **Cập nhật lại Chỉ số (Re-indexing):** Tự động tính toán lại `generation_level` và Mã số d'Aboville cho toàn bộ các Node con cháu thuộc nhánh bị di chuyển.

---

## 4. DATA INTEGRITY & TEMPORAL LOGIC (BẢO TOÀN LOGIC & THỜI GIAN)

Để đảm bảo tính chính xác tuyệt đối của gia phả, FT Engine áp dụng các quy tắc chặn lỗi tự động (Strict Validation Rules):

### 4.1. Chống Vòng lặp Quan hệ (Cycle Detection - DAG Validation)
Sử dụng thuật toán phát hiện chu trình trên Đồ thị Hướng không Chu trình (Directed Acyclic Graph):
*   **Quy tắc:** Node $A$ không thể được thiết lập làm Cha/Mẹ của Node $B$ nếu $B$ đã là Tổ tiên (Ancestors) của $A$.
*   **Hành động:** Hệ thống chặn ngay lập tức ở giao diện và báo lỗi: *"Thao tác vi phạm logic: Một người không thể là tổ tiên của chính mình."*

---

### 4.2. Ràng buộc Logic Thời gian (Temporal Logic Rules)

| Quy tắc | Công thức / Điều kiện | Loại Cảnh báo |
| :--- | :--- | :--- |
| **Tuổi sinh con hợp lý** | $12 \le (\text{Year}_{\text{child}} - \text{Year}_{\text{parent}}) \le 75$ | Warning (Cần xác nhận) |
| **Ngày sinh của Con** | $\text{Date}_{\text{child}} > \text{Date}_{\text{parent}}$ | Block (Chặn tuyệt đối) |
| **Thời điểm mất của Cha** | $\text{Date}_{\text{child\_birth}} \le \text{Date}_{\text{father\_death}} + 300\text{ ngày}$ | Warning (Cần xác nhận) |
| **Tuổi thọ hợp lý** | $0 \le (\text{Year}_{\text{death}} - \text{Year}_{\text{birth}}) \le 120$ | Warning (Cần xác nhận) |
| **Ngày kết hôn** | $\text{Date}_{\text{marriage}} \ge \min(\text{Date}_{\text{husband\_birth}}, \text{Date}_{\text{wife\_birth}}) + 12\text{ năm}$ | Block (Chặn tuyệt đối) |

---

### 4.3. Đối soát Trùng lặp (Deduplication Engine)
Khi thêm thành viên mới, hệ thống tự động tính toán chỉ số tương đồng:

$$\text{Similarity Score} = f(\text{Full Name}, \text{Birth Year}, \text{Parents' Names})$$

*   Nếu $\text{Similarity Score} \ge 80\%$: Hệ thống bật cảnh báo trùng lặp và gợi ý nối với Node hiện có thay vì tạo Node mới.

---

## 5. VIỆT NAM CULTURE-SPECIFIC EXTENSIONS (TÍNH NĂNG ĐẶC THÙ VĂN HÓA VIỆT)

### 5.1. Phân cấp Chi / Nhánh / Phái
*   **Chi Trưởng (Dòng Trưởng):** Hệ thống tự động nhận diện và gắn nhãn "Chi Trưởng" (Dòng truyền thừa con trai trưởng qua các thế hệ). Được hiển thị với viền vàng kim/biểu tượng Hoành phi.
*   **Chi Thứ / Phái / Nhánh:** Cấu trúc phân cấp theo dạng cây đa cấp. Mỗi Chi/Nhánh có thể đặt tên riêng (VD: *Chi 2 - Nhánh Mạc Mẫu*).

---

### 5.2. Đồng bộ Lịch Âm - Dương & Lịch Giỗ
*   Mọi sự kiện (Sinh, Mất) lưu trữ đồng thời Unix Timestamp (Dương lịch) và Cấu trúc Âm lịch (Ngày, Tháng, Năm, Tháng Nhuận, Giờ Hoàng đạo).
*   **Auto Remind (Tự động Nhắc Giỗ):** Hệ thống quét Cây gia phả mỗi ngày, tự động tính toán chuyển đổi Âm-Dương và gửi thông báo nhắc lễ Giỗ trước 3 ngày đến toàn bộ thành viên thuộc Chi/Nhánh đó.

---

### 5.3. Định vị Mộ phần & Sơ đồ Nghĩa trang Dòng họ (Grave Mapping)
*   Mỗi Node đã mất tích hợp dữ liệu GIS: Latitude, Longitude, Altitude.
*   Tích hợp bản đồ vệ tinh chỉ đường đến vị trí mộ phần.
*   Hỗ trợ sơ đồ vị trí tọa lạc bát hương/mộ phần bên trong Khu nghĩa trang dòng họ.

---

## 6. SECURITY, PERMISSIONS, VERSIONING & EXPORT (BẢO MẬT, PHÂN QUYỀN, PHIÊN BẢN & XUẤT BẢN)

### 6.1. Ma trận Phân quyền theo Nhánh (Branch-Level RBAC)

| Vai trò (Role) | Phạm vi Phân quyền (Scope) | Quyền hạn trên Canvas |
| :--- | :--- | :--- |
| **Super Admin (Trưởng Họ)** | Toàn bộ Cây Dòng họ | Full Control (Thêm, sửa, xóa, duyệt, di chuyển nhánh, phân quyền). |
| **Branch Admin (Trưởng Chi)** | Nhánh Chi/Phái phụ trách | Thêm, sửa, di chuyển nhánh trong phạm vi Chi của mình. |
| **Member (Thành viên)** | Toàn Cây | Xem phả đồ. Được phép đề xuất cập nhật thông tin cá nhân/con cái. |
| **Guest (Khách)** | Toàn Cây | Xem thông tin công khai. Ẩn toàn bộ thông tin riêng tư. |

#### Chính sách Ẩn Quyền riêng tư (Privacy Masking Rule):
*   Thành viên **Đã mất**: Hiển thị đầy đủ thông tin trên Cây công khai.
*   Thành viên **Còn sống**: Tự động ẩn SĐT, Email, Địa chỉ nhà, Ngày sinh chi tiết đối với người xem không cùng phân nhánh gần (phạm vi 3 đời), trừ khi được chủ thể cho phép.

---

### 6.2. Lịch sử Thay đổi & Khôi phục (Audit Trail & Versioning)
*   **Audit Log:** Mọi thao tác chỉnh sửa Node, nối quan hệ, di chuyển nhánh đều tạo ra 1 bản ghi Log:
    `[Timestamp] - [User_ID] - [Action_Type] - [Node_ID] - [Before_State] - [After_State]`
*   **Rollback System:** Trưởng ban gia phả có quyền duyệt danh sách lịch sử và thực hiện **Undo** (Khôi phục) Cây gia phả về bất kỳ mốc thời gian nào trong quá khứ nếu xảy ra lỗi nhập liệu hàng loạt.

---

### 6.3. Trích xuất Dữ liệu & In ấn Khổ lớn (Export & Publishing)
1.  **Print-Ready Vector Export:** Xuất Canvas ra định dạng Vector (`.SVG`, `.PDF` khổ A0, A1, Băng rôn dài) với độ phân giải siêu cao (300 DPI) phục vụ in ấn phả đồ treo Nhà thờ họ.
2.  **Chuẩn Quốc tế GEDCOM:** Hỗ trợ Import/Export file `.ged` (Standard GEDCOM 5.5.1 / 7.0) để chuyển đổi dữ liệu dễ dàng với các phần mềm gia phả quốc tế.
3.  **Tập Phả ký (Word/PDF Report):** Tự động trích xuất toàn bộ dữ liệu Cây thành cuốn sách Gia Phả Số hoàn chỉnh (gồm Lịch sử dòng họ, Sơ đồ chi phái, Tiểu sử từng thành viên và Danh sách ngày giỗ).

---
*Tài liệu Family Tree Doctrine này là quy chuẩn bắt buộc áp dụng cho dự án myclan.com.vn.*