# **Tài liệu Thiết kế Luồng Nghiệp vụ Onboarding \- Web App Quản lý Dòng họ**

VERSION: 1.0.0  
DATETIME: 23062026 21:00

Tài liệu này đặc tả quy trình nghiệp vụ Onboarding (Profile Completion & Setup) dành cho hệ thống quản lý dòng họ, dựa trên việc tách biệt giữa tài khoản người dùng (Users) và thực thể phả hệ (Members), đồng thời hỗ trợ mô hình đa khách thuê (Multi-tenant) cho các dòng họ độc lập.

## **1\. Tổng quan Kiến trúc Thực thể & Trạng thái**

Hệ thống quản lý dòng họ phân tách rõ ràng hai thực thể cốt lõi để đảm bảo tính mềm dẻo về mặt nghiệp vụ và an ninh hệ thống:

* **Users (Tài khoản định danh):** Quản lý an ninh truy cập, xác thực danh tính.  
* **Members (Thành viên phả hệ):** Bản ghi nằm trong cây gia phả, lưu giữ thông tin huyết thống, vế vế, lịch sử cá nhân (bibliographies, addresses, contacts...).

Dưới đây là danh sách các Trạng thái và Vai trò chính thức của hệ thống:

| Thực thể | Danh sách Trạng thái (Status) | Danh sách Vai trò (Role)   |
| :---- | :---- | :---- |
| **users** | CHO\_DUYET, DA\_DUYET, BI\_KHOA, BI\_CAM, TAM\_NGUNG, TU\_CHOI | SYSTEM\_ADMIN, CLAN\_ADMIN, USER, KHAC, VIEWER, GUEST, EDITOR |
| **members** | DU\_BI, CHINH\_THUC | TRUONG\_TOC, TRUONG\_NGANH, TRUONG\_CHI, THANH\_VIEN, TRUONG\_HO, KHAC |
| **tenant (Clan)** | CHO\_DUYET, HOAT\_DONG, BI\_KHOA, TAM\_NGUNG, NGUNG\_HAN, TU\_CHOI | Không áp dụng |

## **2\. Tiến trình Đăng ký Nhập tộc (Member Onboarding)**

Sau khi tài khoản đăng ký ban đầu được duyệt, user có trạng thái users.status \= 'DA\_DUYET' và quyền truy cập ban đầu là users.role \= 'VIEWER'. Lúc này họ chỉ có quyền xem tổng quan. Để trở thành một thành viên thực sự trong cây phả hệ, họ phải trải qua các bước sau:

### **Bước 1: Khai báo thông tin thiết yếu & Khởi tạo thực thể Member (Bắt buộc)**

Hệ thống bắt buộc user điền form thông tin cá nhân cốt lõi trước khi thao tác các tính năng khác nhằm tránh sinh dữ liệu mồ côi.

* **Nghiệp vụ:** Khai báo thông tin liên lạc (contacts), địa chỉ hiện tại (addresses), ngày tháng năm sinh (hỗ trợ cả âm lịch/dương lịch), giới tính. Các thông tin sâu như tiểu sử (bibliographies) có thể hoàn thiện sau.  
* **Hành động Hệ thống (Atomic Transaction):**  
  1. Khởi tạo một bản ghi mới trong bảng members với status \= 'DU\_BI' và members\_roles \= 'THANH\_VIEN'.  
  2. Cập nhật liên kết users.member\_id \= \[ID\_MEMBER\_VUA\_TAO\]. Dấu hiệu này chứng minh user đã bắt đầu tiến trình gia nhập tộc.

### **Bước 2: Khai báo sơ đồ gia đình nhỏ (Tối đa 4 đời)**

Áp dụng cho trường hợp con cháu xa quê, biết rõ thông tin gia đình nhỏ của mình nhưng chưa xác định được thuộc chi, nhánh hoặc đời thứ mấy trên cây phả hệ tổng.

* **Nghiệp vụ:** Sử dụng giao diện vẽ cây thu nhỏ (gốc là chính Member của user vừa tạo ở Bước 1\) để nhập hộ thông tin trực hệ gồm: Vợ/Chồng, Con cái, Bố/Mẹ, Ông/Bà (tối đa 4 đời).  
* **Hành động Hệ thống:** Tạo các bản ghi members phụ thuộc ở trạng thái DU\_BI, tạo nhánh gia đình độc lập (Unlinked Node) gắn liền với tài khoản quản lý của user đó.

### **Bước 3: Gửi yêu cầu khớp nối & Chờ duyệt**

Sau khi hoàn thành cây thu nhỏ, user gửi hồ sơ gia nhập. Hệ thống chuyển giao diện của user sang trạng thái chờ và gửi thông báo kiểm duyệt tới các cấp quản lý dòng họ.

### **Bước 4: Phê duyệt chuyên sâu & Ghép cây phả hệ chính thức**

* **Nghiệp vụ:** CLAN\_ADMIN hoặc các trưởng chi (TRUONG\_CHI, TRUONG\_NGANH) thẩm định thông tin và sơ đồ 4 đời, đối chiếu tộc phả để xác định vị trí nối cây thích hợp.  
* **Hành động Hệ thống:**  
  1. Thực hiện khớp nối (Merge) nút gốc của nhánh 4 đời vào vị trí cha/ông tương ứng trên cây tổng thức.  
  2. Chuyển toàn bộ trạng thái của các thành viên trong nhánh từ members.status \= 'DU\_BI' sang 'CHINH\_THUC'.  
  3. Nâng cấp quyền tài khoản: Chuyển users.role từ 'VIEWER' sang 'USER' (hoặc 'EDITOR' nếu cho phép tự quản lý nhánh gia đình đó).

## **3\. Tiến trình Thiết lập & Kích hoạt Dòng họ mới (New Clan Onboarding)**

Dành riêng cho trường hợp người đăng ký là người khởi tạo dòng họ mới trên hệ thống (Sáng lập Tenant), quy trình gồm 4 bước bắt buộc sau:

### **Bước 1: Hoàn thiện hồ sơ cá nhân của Người đại diện**

Tương tự như luồng khai báo thông tin thiết yếu của thành viên thường, nhưng vì là người sáng lập hệ thống phả hệ của dòng họ, hệ thống sẽ tự động cấu hình:

* users.role \= 'CLAN\_ADMIN'  
* members.status \= 'CHINH\_THUC'  
* members\_roles \= 'TRUONG\_HO' (hoặc vai trò quản trị tối cao tương đương ban đầu).

### **Bước 2: Thiết lập thông tin Dòng họ (Tenant Configuration)**

Admin tiến hành cấu hình không gian số (Tenant Space) cho dòng họ của mình:

* **Thông tin hành chính:** Tên dòng họ (Ví dụ: Nguyễn Tộc chi 2), Địa chỉ nhà thờ tổ, Thông tin Hội đồng gia tộc lâm thời, Tóm tắt lịch sử dòng họ.  
* **Quy tắc vận hành (Business Rules):**  
  * Cơ chế duyệt thành viên mới: *Tự động duyệt* hay *Bắt buộc phê duyệt thủ công*.  
  * Bật/tắt các phân hệ tính năng mở rộng: Quỹ đóng góp dòng họ, Tin tức/Thông báo, Quản lý Sự kiện/Giỗ chạp.

### **Bước 3: Khởi tạo Cây gia phả cốt lõi (Core Tree Initialization)**

Hệ thống cung cấp một biểu mẫu hoặc cấu trúc cây gợi ý để Admin thiết lập nền móng phả hệ ban đầu.

* **Nghiệp vụ:** Nhập thông tin của 2 đến 3 đời cao nhất (Thủy tổ, Viễn tổ) và thiết lập sẵn bộ khung các nhánh lớn (Chi 1, Chi 2...). Việc này làm tiền đề giúp con cháu tham gia sau này dễ dàng nhận diện và chọn đúng gốc tích của mình.

### **Bước 4: Kích hoạt & Phát hành không gian dòng họ (Activation & Publish)**

Admin xác nhận hoàn tất thiết lập bằng cách nhấn nút "Kích hoạt Dòng họ". Hệ thống chạy các tiến trình nền tự động:

* Cập nhật trạng thái không gian: tenant.status \= 'HOAT\_DONG'.  
* Đồng bộ trạng thái tài khoản: Khóa quyền truy cập cấu hình onboarding, mở toàn quyền trang Dashboard chính thức.  
* Hệ thống tự động tạo mã mời thành viên (Clan Invite Code) và liên kết đăng ký rút gọn (Invite Link) kèm trang chào mừng (Landing Page) riêng của dòng họ phục vụ việc chia sẻ mạng xã hội.

## **4\. Nguyên tắc Triển khai Kỹ thuật & UX**

* **Chặn điều hướng (State Guard / Auth Middleware):** Khi một tài khoản có trạng thái an ninh là DA\_DUYET nhưng chưa thỏa mãn điều kiện nghiệp vụ (ví dụ: users.member\_id \== null ở thành viên thường hoặc tenant.status \== 'CHO\_DUYET' ở New Clan Admin), hệ thống phải sử dụng Middleware để chặn quyền truy cập vào các tính năng chính thức, ép buộc user ở lại giao diện Wizard Onboarding cho đến khi hoàn thành.  
* **Xử lý phân lớp An ninh và Nghiệp vụ:** Việc phân chia trạng thái users.status thành hai nhóm là hoàn toàn chính xác. Nhóm an ninh (BI\_KHOA, BI\_CAM...) cần được xử lý ngay tại tầng Xác thực (Authentication) để từ chối truy cập ngay lập tức, độc lập với logic nghiệp vụ gia phả của bảng members.  
* **Tính năng Lưu nháp (Save Draft):** Giao diện Onboarding cho cả Member và Clan Admin cần hỗ trợ lưu nháp qua từng bước nhằm đảm bảo trải nghiệm người dùng không bị gián đoạn do dữ liệu phả hệ đặc thù đòi hỏi thời gian thu thập thông tin lớn.