VOLUME I: PRODUCT FOUNDATION
[VOL I - 02] BUSINESS DOCTRINE BLUEPRINT (REVISED V2)
Trạng thái: Baseline Approved | Phiên bản: V2.0 (Refactored via Peer Reviews)
Hệ thống: Web App Quản lý Dòng họ (Clan Management Platform)
Cấu trúc thực thi: Unified 8-Section Blueprint Contract (Business-Oriented)
1. PURPOSE (MỤC ĐÍCH)
Tài liệu này định nghĩa Học thuyết Nghiệp vụ Chuẩn tắc (Canonical Clan Doctrine) – tầng cốt lõi thiết lập các nguyên tắc vận hành, quyền quản trị tối cao và triết lý lập pháp của hệ thống Web App Dòng họ. Không đóng vai trò như một cấu phần kỹ thuật, Business Doctrine đóng vai trò như bộ quy tắc ứng xử văn hóa được số hóa, quy định "điều gì là đúng" (What) đối với các hành vi tộc sự, tạo nền tảng tư duy bất biến để định hình thế giới quan cho toàn bộ các mô hình dữ liệu, thuật toán và giải pháp kỹ thuật ở các phân tầng phía dưới.
2. PRIMARY DESIGN QUESTION (CÂU HỎI THIẾT KẾ CỐT LÕI)
"Làm thế nào để trừu tượng hóa và hệ thống hóa các luật tục truyền thống, mang tính định tính của văn hóa gia tộc Việt Nam thành một bộ khung triết lý và nguyên tắc nghiệp vụ nhất quán, giúp định hướng hành vi phần mềm mà không bị phụ thuộc vào các giải pháp công nghệ hay cấu trúc mã nguồn cụ thể?"
3. SCOPE (TRONG PHẠM VI)
Business Doctrine chịu trách nhiệm định nghĩa và quản lý các nhóm nguyên tắc nghiệp vụ thượng tầng sau:
Business Principles (Triết lý cốt lõi): Định hình các tư tưởng tối cao không thể lay chuyển về mặt lịch sử, dữ liệu và văn hóa tộc sự.
Governance Principles (Nguyên tắc quản trị): Quy định về vai trò chính danh, vị thế văn hóa của các thành viên (Trưởng tộc, Trưởng chi, Nội tộc, Ngoại tộc, Dâu, Rể) trong hệ thống số.
Ownership Principles (Nguyên tắc chủ quyền dữ liệu): Xác lập ranh giới sở hữu thông tin giữa các nhánh họ và dòng họ tổng thể.
Approval Principles (Nguyên tắc phê duyệt): Định tính hóa các điều kiện cần và đủ để thiết lập tính đồng thuận đối với các quyết định đại sự.
Conflict Resolution Principles (Nguyên tắc giải quyết xung đột): Quy chuẩn văn hóa để xử lý và đóng băng các luồng thông tin gây tranh chấp.
4. OUT OF SCOPE (NGOÀI PHẠM VI)
Để đảm bảo tính thuần khiết của tầng nghiệp vụ và tránh chồng lấn kiến trúc, tài liệu này loại trừ:
Không đặc tả các giải pháp kỹ thuật hay công nghệ thực thi cụ thể (như Rule Engine, Multi-sig, OTP, Redis, cơ sở dữ liệu).
Không chứa mã cấu hình, kiểu dữ liệu lập trình (Boolean, Enum), tên biến phần mềm hoặc đặc tả giao thức kết nối API.
Không tự mình thực thi các ca kiểm thử hành vi dữ liệu cụ thể (nhường chỗ cho tầng Domain Specification).
5. RELATED DOCUMENTS (TÀI LIỆU LIÊN QUAN)
Thừa hưởng giá trị sứ mệnh trường tồn và ma trận đối tượng người dùng từ [VOL I - 01] Product Vision Blueprint.
Chuyển giao các nguyên tắc cấu hình (Flags, Boolean) và giải pháp kỹ thuật đa chữ ký xuống [VOL I - 03] Product Architecture Blueprint.
Định hướng trực tiếp cho logic nghiệp vụ tại các phân hệ [VOL II - 04] Lineage & Member Domain và [VOL II - 06] Ledger Domain.
6. BLUEPRINT (BẢN VẼ HỌC THUYẾT NGHIỆP VỤ)
6.1 Triết lý Nghiệp vụ Cốt lõi (The 6 Business Principles)
Mọi hành vi phần mềm được xây dựng trong hệ thống bắt buộc phải tuân thủ nghiêm ngặt 6 triết lý linh hồn sau:
Nguyên tắc 1: Lịch sử bất biến. Dữ liệu quá khứ của dòng họ không bao giờ bị xóa bỏ, chỉ được phép hiệu chỉnh bằng cách bổ sung phiên bản mới, bảo toàn vết tích của dòng chảy thời gian.
Nguyên tắc 2: Thông tin hữu căn. Mọi chỉnh sửa, thêm mới đối với các thông tin nhạy cảm của phả hệ hay tài chính đều phải đính kèm minh chứng nguồn gốc (bằng chứng hình ảnh, gia phả đối chiếu hoặc văn bản xác thực).
Nguyên tắc 3: Phân rã quyền lực dữ liệu. Không tồn tại bất kỳ một cá nhân đơn lẻ nào có quyền sở hữu, định đoạt hoặc thay đổi toàn bộ dữ liệu của cả một dòng họ lớn mà không qua kiểm soát.
Nguyên tắc 4: Đóng băng tranh chấp. Bất kỳ thông tin phả hệ nào xảy ra mâu thuẫn giữa các nguồn nhập liệu đều phải được cô lập ngay lập tức, không cho phép ghi đè tự do làm sai lệch hiện trạng trước khi đạt được đồng thuận.
Nguyên tắc 5: Truy nguyên tuyệt đối. Toàn bộ các thao tác, tác động thay đổi trạng thái thông tin trong hệ thống đều phải lưu vết định danh vĩnh viễn, có khả năng tra cứu ngược dòng thời gian (Auditable).
Nguyên tắc 6: Tôn trọng sự khác biệt. Hệ thống phải chấp nhận tính đa dạng và khác biệt về luật tục vùng miền của từng dòng họ, không áp đặt một khuôn mẫu văn hóa duy nhất cho mọi khách hàng.
6.2 Mô hình Chủ quyền Dữ liệu (Data Sovereignty Model)
Hệ thống xác lập ranh giới quản trị dựa trên mô hình chủ quyền phân cấp:
Quyền Tự trị của Chi phái: Mỗi Chi/Nhánh họ có quyền chủ quyền tuyệt đối đối với nhánh phả hệ nội bộ và các quỹ hoạt động riêng của Chi mình. Họ có quyền tự quyết thông tin sinh tử, hỷ sự của thành viên trong Chi mà không cần sự phê duyệt từ dòng họ tổng.
Quyền Tối cao của Trưởng tộc / Hội đồng: Dòng họ tổng thể (thông qua Hội đồng Gia tộc) nắm giữ chủ quyền đối với các node lịch sử chung (Cụ Tổ khởi tổ, các đời tổ tiên chung) và các quỹ đại sự của toàn bộ tổ đường.
6.3 Mô hình Đồng thuận và Giải quyết Xung đột (Consensus & Conflict Resolution Model)
Cơ chế đồng thuận văn hóa: Các quyết định mang tính thay đổi cấu trúc phả hệ lịch sử hoặc duyệt chi ngân sách lớn từ quỹ chung bắt buộc phải thông qua một hội đồng đại diện cho tất cả các chi phái. Tỷ lệ đồng thuận định tính (Quorum văn hóa) phải được xác lập rõ ràng từ trước.
Luồng hòa giải xung đột: Khi một thông tin phả hệ rơi vào trạng thái tranh chấp, hệ thống kích hoạt không gian hòa giải. Quyền định đoạt cuối cùng thuộc về quyết định đồng thuận của Hội đồng Gia tộc dựa trên các bằng chứng lịch sử được cung cấp.
7. IMPLEMENTATION NOTES (HƯỚNG DẪN ĐỊNH HƯỚNG SẢN PHẨM)
Chuyển dịch sang Cấu hình Kỹ thuật: Kỹ sư kiến trúc khi đọc tài liệu này cần chuyển hóa mô hình định tính tại mục số 6 thành một Schema cấu hình (Configuration Schema) động. Ví dụ, triết lý "cho phép hoặc không cho phép hậu duệ ngoại tộc mở rộng cây" phải được trừu tượng hóa thành các biến luận lý nằm trong nhân cấu hình hệ thống, sẵn sàng cho lớp Rule Engine vật lý đọc hiểu.
Về trải nghiệm đồng thuận số: Do tính chất phức tạp của các quy trình bỏ phiếu dòng họ ngoài đời thực, lớp ứng dụng cần thiết lập các luồng phê duyệt (Approval Workflow) đa tầng nhưng có trải nghiệm đơn giản, biến các yêu cầu đồng thuận phức tạp thành các hành động xác nhận trực quan, phù hợp với thói quen sinh hoạt của các thế hệ trưởng lão tham gia Hội đồng.
8. CROSS REFERENCES (THAM CHIẾU CHÉO)
Xem định vị chiến lược và ma trận Persona tại [VOL I - 01] Product Vision Blueprint.
Xem hiện thực hóa Rule Engine và mô hình mã băm bảo toàn dữ liệu tại [VOL I - 03] Product Architecture Blueprint.
[KẾT THÚC TÀI LIỆU VOL I - 02 V2. BASELINE APPROVED]