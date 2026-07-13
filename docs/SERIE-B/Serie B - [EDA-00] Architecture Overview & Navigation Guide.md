[EDA-00] ARCHITECTURE OVERVIEW & NAVIGATION GUIDE
Trạng thái: Frozen (Bất biến) | Phiên bản: V1.0
Hệ thống: Web App Quản lý Dòng họ (Clan Management Platform)
Mục tiêu tài liệu: Định hướng tư duy, phân định ranh giới miền dữ liệu và hướng dẫn khai thác bộ 12 tài liệu kiến trúc chuẩn tắc.
1. GIỚI THIỆU TỔNG QUAN VÀ TRIẾT LÝ KIẾN TRÚC BẤT BIẾN
1.1 Sứ mệnh Trường tồn của Dữ liệu Gia tộc
Không giống như các ứng dụng thương mại điện tử hay mạng xã hội thông thường có vòng đời ngắn và dữ liệu thay đổi liên tục theo xu hướng thị trường, Web App Quản lý Dòng họ mang một sứ mệnh đặc thù: Trường tồn xuyên thế hệ. Dữ liệu phả hệ, tộc ước, và tư liệu lịch sử của một dòng họ là tài sản tinh thần vô giá, cần được lưu trữ, bảo vệ và kế thừa qua hàng chục, hàng trăm năm.
Công nghệ cốt lõi, ngôn ngữ lập trình, hạ tầng đám mây hay giao diện người dùng (UI/UX) có thể thay đổi, nâng cấp hoặc bị thay thế theo dòng chảy của công nghệ. Tuy nhiên, cấu trúc luận lý của mô hình phả hệ, các triết lý vận hành gia tộc và mối quan hệ huyết thống thì bất biến. Do đó, kiến trúc hệ thống cần tách biệt hoàn toàn giữa tầng logic nghiệp vụ cốt lõi (Domain Core) và tầng thực thi kỹ thuật vật lý bên ngoài.
1.2 Tại sao Bộ 12 Tài liệu Kiến trúc lại được "Khóa cứng" (Frozen)?
Hệ thống áp dụng nguyên tắc Canonical Contract Enforcement (Thực thi hợp đồng miền chuẩn tắc) và đưa toàn bộ bộ 12 tài liệu vào trạng thái "Frozen" nhằm đạt được các mục tiêu chiến lược sau:
Chống suy thoái kiến trúc (Architecture Drift): Dự án có sự tham gia của nhiều thế hệ lập trình viên, cộng tác viên từ các vùng miền khác nhau. Việc khóa cứng đường biên giúp ngăn chặn tình trạng chắp vá mã nguồn bừa bãi, làm biến dạng cấu trúc dữ liệu phả hệ ban đầu.
Sẵn sàng cho Tự động hóa bằng AI (AI/Generators Ready): Toàn bộ tài liệu được chuẩn hóa dưới dạng các Hợp đồng Miền cấu trúc cao. Đây là nguồn ngữ cảnh (Context) tối cao để nạp vào các AI Agent/Generators, cho phép hệ thống tự động sinh mã nguồn (Code), sinh cấu trúc DB, và sinh kịch bản kiểm thử (Test Cases) một cách chính xác mà không bị sai lệch nghiệp vụ.
Đảm bảo tính nhất quán dữ liệu (Single Source of Truth): Tránh hiện tượng chồng lấn dữ liệu giữa các phân hệ (ví dụ: thông tin thành viên bị phân tán ở cả module tài chính lẫn module truyền thông).
2. BẢN ĐỒ TIẾP CẬN VÀ QUY HOẠCH MIỀN (DOMAIN BOUNDARIES)
2.1 Mô hình Kim tự tháp Kiến trúc Ba tầng
Bộ 12 tài liệu được tổ chức theo cấu trúc phân tầng logic chặt chẽ, hỗ trợ các đối tượng nhân sự khác nhau trong dự án có thể dễ dàng định vị thông tin:
Tầng Định Hướng (Tài liệu 1, 2): Định hình triết lý, tầm nhìn chiến lược và luật lệ tối cao. Dành cho Product Owner (PO), Hội đồng Gia tộc và các nhà tài trợ dự án.
Tầng Thiết Kế Miền Nghiệp Vụ (Tài liệu 3, 4, 5, 6, 7, 8): Đặc tả chi tiết luồng xử lý, cấu trúc dữ liệu luận lý và logic AI hỗ trợ người dùng. Dành cho Solution Architect, Tech Lead và Business Analyst.
Tầng Thực Thi Vật Lý (Tài liệu 9, 10, 11, 12): Quy định về bảo mật, kết nối API, cấu hình Cơ sở dữ liệu vật lý và hạ tầng Cloud triển khai thực tế. Dành cho Backend/Frontend Developer, DevOps Engineer và SecOps.
2.2 Phân định Biên giới Dữ liệu bằng Đồ thị Hướng không Chu trình (DAG)
Hệ thống áp dụng mô hình DAG để quản lý sự phụ thuộc giữa các miền dữ liệu. Mối quan hệ phụ thuộc tuân thủ nghiêm ngặt chiều từ trên xuống dưới, tuyệt đối không xảy ra hiện tượng phụ thuộc vòng (Circular Dependency):
Nút gốc (Root): Lineage & Member Domain (Tài liệu 4) giữ vai trò định danh tối cao. Mọi thực thể trong hệ thống (từ một khoản đóng góp tài chính đến một lời nhắc ngày giỗ) đều phải tham chiếu về ID thành viên hoặc ID chi tộc được định nghĩa tại đây.
Các miền nghiệp vụ phụ thuộc như Ledger Domain (Tài liệu 6) hay Event Domain (Tài liệu 5) chỉ được phép đọc dữ liệu từ Nút gốc, không có quyền can thiệp làm thay đổi cấu trúc cây phả hệ của Nút gốc.
3. KHUNG THAM CHIẾU BỘ 12 TÀI LIỆU CHUẨN TẮC
Bảng dưới đây thiết lập bản đồ điều hướng nhanh, chỉ rõ mục tiêu giải quyết bài toán và đối tượng độc giả chính của từng tài liệu:
STT
Tên Tài Liệu (Domain)
Câu Hỏi Cốt Lõi Cần Giải Quyết
Đối Tượng Đọc Chính
 
1
Product Vision
Sản phẩm giải quyết nỗi đau nào của dòng tộc thời đại số? Giá trị cốt lõi mang lại cho các thế hệ (Gen Z, Alpha, người ly hương) là gì?
PO, Hội đồng Gia tộc
2
Business Doctrine
"Tộc ước số" quy định luật lệ gì về quyền can thiệp dữ liệu phả hệ? Cơ chế đồng thuận khi có tranh chấp thông tin ra sao?
PO, Hội đồng Gia tộc
3
Product Architecture
Hệ thống giao tiếp thông qua các mô hình kiến trúc nào (Event-Driven)? Làm sao đảm bảo tính bất đồng bộ khi tải cây phả hệ hàng vạn nút?
Solution Architect, Tech Lead
4
Lineage & Member Domain
Làm thế nào biểu diễn chính xác đồ thị quan hệ huyết thống, hôn nhân, tái hôn, con nuôi? Chống lỗi đệ quy vòng lặp cây như thế nào?
Tech Lead, Developer
5
Event & Ritual Domain
Cơ chế tự động chuyển đổi lịch Âm - Dương để nhắc lịch Giỗ chạp, sự kiện? Quy trình điều phối trạng thái chuẩn bị việc làng, việc họ?
Business Analyst, Developer
6
Ledger Domain
Làm sao ứng dụng mô hình Sổ cái chỉ ghi (Append-only) để đảm bảo tính minh bạch tuyệt đối cho các quỹ dòng họ, chống gian lận, sửa xóa?
Tech Lead, Backend Dev
7
Communication Domain
Làm thế nào để truyền thông báo (tin hỷ, tin buồn, vinh danh) đúng đối tượng theo từng chi phái mà không gây nhiễu thông tin?
Frontend/Backend Dev
8
AI & Elder Support
Làm sao để các C cụ trưởng lão mắt kém tương tác bằng giọng nói (Voice UX)? AI dịch thuật chữ Hán Nôm và hỗ trợ tra cứu lịch sử thế nào?
AI Engineer, UI/UX Designer
9
Security & Trust
Cơ chế xác thực danh tính (KYC nội bộ) để tránh người ngoài xâm nhập? Phân quyền bảo mật dữ liệu nhạy cảm (SĐT, địa chỉ) ra sao?
SecOps, Tech Lead
10
API & Integration Spec
Các cổng kết nối dữ liệu (RESTful/GraphQL) chuẩn hóa như thế nào để phục vụ Web App, Mobile App và màn hình Kiosk tại Nhà thờ Tổ?
Backend Dev, Mobile Dev
11
Data & Storage Spec
Quy hoạch cơ sở dữ liệu vật lý (Graph DB cho phả hệ, Relational DB cho kế toán, Object Storage cho hình ảnh gia phả cổ) như thế nào?
Database Administrator, Dev
12
Deployment & Operations
Làm sao ứng dụng kiến trúc Serverless để tối ưu chi phí (bằng 0 khi ở trạng thái tĩnh, tự động scale khi có lượng truy cập đột biến dịp Tết)?
DevOps Engineer
4. HƯỚNG DẪN THỰC THI VÀ TUÂN THỦ
Khi bắt tay vào lập trình hoặc cấu hình hệ thống, tất cả các thành viên phải tuân thủ nghiêm ngặt quy trình đối chiếu:
Bước 1: Kiểm tra Triết lý nghiệp vụ tại Tài liệu 2 (Business Doctrine) để đảm bảo tính năng dự định viết không vi phạm tộc ước và văn hóa dòng họ.
Bước 2: Xem xét cấu trúc thực thể và quan hệ tại Tài liệu 4 (Lineage Domain) để tái sử dụng các định danh (IDs) sẵn có, tuyệt đối không tự sinh cấu trúc thành viên mới.
Bước 3: Thực thi mã nguồn dựa trên các thông số kỹ thuật, cấu trúc bảo mật và API được quy định từ Tài liệu 9 đến 11.
Mọi đề xuất thay đổi đối với bất kỳ tài liệu nào trong bộ 12 tài liệu đã "Frozen" đều phải thông qua quy trình đánh giá tác động (Impact Analysis) do Chief AI Architect chủ trì và phải được sự phê duyệt đồng thuận từ Hội đồng Gia tộc số.