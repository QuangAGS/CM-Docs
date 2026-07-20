
Trạng thái:
Baseline Approved | Frozen
(Bất biến)
Phiên bản:	V5.1 (Integrated Cross-cutting
Security & Doctrines)
Hệ thống:
Web App Quản lý Dòng họ
(Clan Management Platform)
Cấu trúc thực thi: Production-Grade API Contract &
Decentralized Governance
Specification
1. PURPOSE (MỤC ĐÍCH)

Tài liệu này đặc tả chi tiết thiết kế giao thức biên vật lý và hợp đồng API chuẩn tắc (Canonical API Platform Specification) của toàn bộ hệ thống. Tài liệu hiện thực hóa kỹ thuật phân tách CQRS lớp biên vật lý, chuẩn hóa định dạng thông điệp bất đồng bộ theo tiêu chuẩn CloudEvents v1.0, cấu trúc mô hình xử lý lỗi Canonical Error Model và thiết lập cơ chế kiểm soát giao vận tin nhắn đáng tin cậy (Idempotent Outbox +
Inbox Patterns). Phiên bản V5.1 tích hợp sâu sắc 3 Học thuyết xuyên suốt cốt lõi bao gồm Business Ledger Doctrine, Communication Doctrine, và học thuyết trợ năng ACXD nhằm áp đặt các ràng buộc định lượng bắt buộc lên tầng cổng trung gian (API Gateways).
2. PRIMARY DESIGN QUESTION (CÂU HỎI THIẾT KẾ CỐT LÕI)

Câu hỏi kiến trúc tối cao:
"Làm thế nào để thiết kế một hệ thống giao thức API phân tán lớp biên pha trộn tối ưu giữa mô hình nạp đồ thị tinh giản GraphQL Queries (100% Read, khống chế cứng Payload < 100 KB cho chiến lược Mobile-First), kiến trúc RESTful Commands (100% Write, tích hợp Stateful Wizard phục vụ Elder-First và ép buộc chỉ số sinh Sổ cái), song song với cơ chế định tuyến sự kiện bất đồng bộ Idempotent nhằm bảo toàn tính nhất quán sau cùng trường tồn độc lập với các biến động công nghệ?"
3. SCOPE & DEPENDENCIES (RANH GIỚI & SỰ PHỤ THUỘC)

Nằm trong phạm vi sở hữu: Các hợp đồng biên vật lý JWT Zero-Stale, lược đồ schema GraphQL và cấu trúc phân trang Connection Cursor Relay, đầu cuối RESTful API cho luồng trạng thái Wizard/Resume, cấu trúc CloudEvents v1.0 snake_case, Canonical Error Contract, chính sách Idempotency động, cơ chế Inbox Pattern kiểm trùng và hệ thống thẻ truy vết phân tán OpenTelemetry.
Sự phụ thuộc và liên kết: Tiêu thụ trực tiếp các mô hình và bộ quy tắc phân quyền động LAAC từ Tập I và Tập II ( [VOL I - 03] V2.1 , [VOL II - 04] V2.1 , [VOL II - 06] V2.1 , [VOL II - 09]
V4.1 ). Định hướng trực tiếp cho việc hiện thực hóa mô hình lưu trữ vật lý tại tài liệu dữ liệu hạ tầng [VOL
III - 11] Data & Persistence Architecture Specification .
4. BLUEPRINT (BẢN VẼ KỸ THUẬT VẬT LÝ BIÊN)

4.1 Giao thức Xác thực & Đóng gói Danh tính (Zero Stale Context Identity Model)
JWT mã hóa ở lớp biên loại bỏ hoàn toàn các trường trạng thái nghiệp vụ động (Business State) dễ thay đổi (như chi phái sở tại, vai trò tộc sự hay hạn mức). API Gateway bắt buộc sử dụng thuộc tính sub (identity_id) và phối hợp cùng dấu vết phiên bản security_version để thực hiện truy vấn trực tiếp vào bộ nhớ đệm
LAAC Topology Projection Cache trên Redis Cluster theo thời gian thực nhằm kết xuất ma trận quyền bính huyết thống động:
4.2 Lớp GraphQL Gateway (100% Read Only - Tối ưu hóa Mobile-First Payload)
GraphQL Gateway đảm nhận độc quyền 100% tác vụ Read. Toàn bộ các Domain Node được tinh giản thành cấu trúc rút gọn (Tailored Summary Projections) độc lập với ViewModel phức tạp để triệt tiêu độ trễ mạng. Ép buộc áp dụng chuẩn Relay Connection Specification để phân trang dựa trên Cursor. Hạ tầng API Gateway sẽ lập tức từ chối và ngắt kết nối đối với mọi phản hồi GraphQL có dung lượng gói tin thô vượt quá ngưỡng cứng 100 KB.

4.3 Lớp RESTful Platform Gateway (100% Command - Tích hợp Sổ cái & Trợ năng Lão thành)
Toàn bộ các Domain Command thay đổi trạng thái được tiếp nhận qua cổng REST API biên. Phản hồi thành công (HTTP 200/201) của mọi tác vụ Mutation làm biến động sử liệu bắt buộc phải đính kèm thuộc tính khẳng định hạch toán sổ cái vĩnh viễn: "business_ledger_entry_generated": true .
1. Khai báo Giao dịch Thu/Chi Quỹ (Financial Ledger Mutation)
• Phương thức cổng biên: POST /api/v1/ledger/transactions

2. Giao thức Quản trị Vòng đời Truyền thông & Biên nhận Một chạm (Communication Contracts)
POST /api/v1/communication/messages/send (Khởi chạy phát thông cáo tộc hệ → Trạng thái APPROVED)
POST /api/v1/communication/messages/{id}/read-receipt  (Đầu cuối API nhận phản hồi biên nhận một chạm dành riêng cho Elder-First UI)

3. Luồng Lưu tạm và Phục hồi Tiến trình Nhập liệu (Stateful Wizard Workflows)
Nhằm hỗ trợ thuộc tính Elder-First, ngăn ngừa tối đa tình trạng mất mát dữ liệu do kết nối không ổn định hoặc thao tác nhầm lẫn ở các cụ già bách niên lão thành:
POST /api/v1/workflows/wizard/save (Lưu ảnh chụp trạng thái biểu mẫu nháp vào phân vùng cache tạm thời)
POST /api/v1/workflows/wizard/resume (Nạp lại nguyên vẹn phiên làm việc để tiếp tục tiến trình nhập liệu)

4.4 Trục Tích hợp Tín hiệu Sự kiện Bất đồng bộ (CloudEvents v1.0 Spec snake_case)
Hợp đồng cấu trúc mẩu tin sự kiện lưu chuyển trên Message Broker bắt buộc tuân thủ chuẩn mã hóa thông tin, áp đặt định dạng thuần snake_case cho toàn bộ thuộc tính dữ liệu nghiệp vụ:

5. CANONICAL API GOVERNANCE (QUẢN TRỊ TRỤC BIÊN)

5.1 Canonical Error Contract
Mọi lỗi nghiệp vụ hoặc sự cố hạ tầng trả về từ bất kỳ phân hệ nào đều bắt buộc phải đóng gói qua mô hình cấu trúc lỗi chuẩn hóa sau để các Client đầu cuối tự động phân luồng hiển thị trực quan:

5.2 Quy định Idempotency Policy động theo Phân tầng Rủi ro Nghiệp vụ
Thời gian lưu giữ khóa chống trùng lặp tại cổng biên vật lý được quy hoạch linh hoạt dựa trên mức độ rủi ro nghiệp vụ thực tế nhằm tối ưu hóa hiệu năng lưu trữ RAM Cache:
Phân lớp tác vụ tương tác
Thời gian lưu giữ khóa
Mục tiêu kiểm soát thiết kế
Tác vụ Tài chính / Sổ cái
(Transaction Mutations)
7 ngày
Phục vụ trọn vẹn chu kỳ đối soát tài chính tuần và cơ chế Replay mẩu tin an toàn.
Biểu quyết / Hội đồng tộc sự (Multisig Votes)
72 giờ
Trùng khớp với thời gian sống tối đa của một phiên thu thập chữ ký số Hội đồng tộc sự.
Truyền thông phát tin tộc hệ
(Publish Message/Post)
24 giờ
Chống bão tin nhắn lặp (Message Storming) do thiết bị di động gửi retry sai cách.
Tải tệp tin / Tài liệu di sản AI
(Upload S3 URL)
1 giờ
Giới hạn thời gian sống của các chữ ký Presigned ngắn hạn chống rò rỉ vùng chứa.
Xác thực trợ năng hệ thống (Wizard
Draft Sync)
30 giây
Khống chế bão request đồng bộ gói tin nháp khi người cao tuổi gõ phím liên tục.
5.3 Phiên bản hóa, Lỗi thời và Hủy bỏ (Deprecation & Sunset Policy)
URI Versioning bắt buộc: Áp dụng cho tầng REST Command thay đổi trạng thái ( /api/v1/... ). Sử dụng Header versioning đối với sự tiến hóa phi phá vỡ của mạng lưới GraphQL Federation.
Sunset Automation: Khi hợp đồng API bị gắn cờ lỗi thời, Gateway tự động chèn Header Deprecated: true và Sunset: 2026-12-31T23:59:59Z vào gói tin phản hồi để hệ thống giám sát tự động kích hoạt cảnh báo tái cấu trúc lên SecOps.
5.4 Cơ chế Inbox Pattern cho Dịch vụ Tiêu thụ (Message Consumer Guard)
Để bảo vệ tính phi trùng lặp đầu nhận khi Event Broker giao vận tin nhắn theo cơ chế At-least-once, mọi Service tiêu thụ bắt buộc phải thực thi Inbox Pattern nghiêm ngặt. Sự kiện sau khi đi qua Gateway bảo mật sẽ kiểm tra ID vào bảng inbox_event_log nội bộ của Domain thô. Nếu ID sự kiện đã tồn tại, hệ thống lập tức bỏ qua xử lý logic và chỉ phản hồi mã xác nhận ACK về cho Broker để chống lỗi xử lý lặp dữ liệu sử liệu (Double-processing Semantics).
6. CROSS REFERENCES (THAM CHIẾU CHÉO)

Đối chiếu ranh giới Payload tối giản và Cursor Connection tại [VOL I - 03] Product Architecture Blueprint V2.1.
Tham chiếu các sự kiện nghiệp vụ phát ra từ [VOL II - 04] Lineage & Member, [VOL II - 05] Event & Ritual, [VOL II - 06] Ledger, [VOL II - 07] Communication, và [VOL II - 08] AI Domain Specification V3.1.
Tham chiếu thiết kế bảng vật lý Outbox/Inbox và Idempotency Store trong cơ sở dữ liệu PostgreSQL tại [VOL III - 11] Enterprise Data & Persistence Architecture Spec.
[KẾT THÚC TÀI LIỆU VOL III - 10 V5.1 - BASELINE APPROVED] 