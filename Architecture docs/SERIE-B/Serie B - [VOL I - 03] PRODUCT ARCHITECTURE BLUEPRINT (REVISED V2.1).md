VOLUME I: PRODUCT FOUNDATION
[VOL I - 03] PRODUCT ARCHITECTURE BLUEPRINT (REVISED V2.1)
Trạng thái: Baseline Approved | Phiên bản: V2.1 (Integrated Cross-cutting Doctrines)
Hệ thống: Web App Quản lý Dòng họ (Clan Management Platform)
Cấu trúc thực thi: Unified 8-Section Blueprint Contract (Logical Architecture-Oriented)
1. PURPOSE (MỤC ĐÍCH)
Tài liệu này đặc tả thiết kế kiến trúc hệ thống cấp cao và mô hình chuyển dịch dữ liệu mang tính luận lý (Logical Product Architecture) của Web App Quản lý Dòng họ. Không đi sâu vào công nghệ vật lý cụ thể, tài liệu đóng vai trò làm trục trung gian chuyển hóa các nguyên tắc định tính thượng tầng từ [VOL I - 02] Business Doctrine V2.1 thành các khuôn mẫu, phân tầng kỹ thuật và cơ chế vận hành định lượng, thiết lập "DNA kiến trúc" bất biến để định hướng nhất quán cho toàn bộ các Domain nghiệp vụ ở Tập II và các giao thức API/Persistence ở Tập III, IV.
2. PRIMARY DESIGN QUESTION (CÂU HỎI THIẾT KẾ CỐT LÕI)
"Làm thế nào để cấu trúc một mô hình kiến trúc logic phân tán, tách biệt Command/Query (CQRS), hướng sự kiện phi trạng thái nhằm thực thi triệt để học thuyết Sổ cái bất biến, quy trình Truyền thông toàn diện và hạ tầng Trải nghiệm thích ứng nhân văn (ACXD) mà vẫn duy trì tính độc lập (Loose Coupling) giữa các phân hệ nghiệp vụ?"
3. SCOPE (TRONG PHẠM VI)
Product Architecture chịu trách nhiệm quy hoạch và định cấu trúc các thành phần luận lý sau:
Architectural Principles: Bộ nguyên lý kỹ thuật cốt lõi bắt buộc mọi phân hệ nghiệp vụ và tầng hạ tầng phải kế thừa.
Overall System & Layering View: Khung phân tầng chức năng tổng thể tích hợp CQRS, Outbox Pattern và mô hình Adaptive Clients.
Clan Instance Lifecycle Machine: Máy trạng thái vòng đời của một không gian số dòng họ (Clan Instance).
Identity & Conceptual Sovereign Model: Mô hình định danh luận lý kết hợp chữ ký toàn vẹn luật tục.
Doctrine Evaluation & Ledger Pipeline: Chuỗi tiến trình thẩm định điều kiện luật tục và ép buộc sinh Sổ cái nghiệp vụ cho các Commands.
Adaptive Workflow & Async Consensus: Cơ chế xử lý luồng đồng thuận bất đồng bộ, các APIs lưu tạm tiến trình (Wizard) và phân trang tối ưu cho thiết bị di động.
4. OUT OF SCOPE (NGOÀI PHẠM VI)
Để bảo vệ tính thuần khiết của tầng kiến trúc luận lý, tài liệu này loại trừ:
Không chỉ định các công nghệ vật lý cụ thể hoặc thư viện lập trình (như Kubernetes, Docker, PostgreSQL, Neo4j, Kafka, GraphQL Engine, React Native).
Không đặc tả chi tiết cấu trúc mã hóa tệp tin vật lý như JSON Schema hay các bảng Schema cụ thể (trách nhiệm thuộc về [VOL III - 11] Data & Storage Specification).
Không mô tả pipeline kỹ thuật của giao thức truyền tải mạng hay HTTP Middleware cụ thể.
5. RELATED DOCUMENTS (TÀI LIỆU LIÊN QUAN)
Consumer of (Tiêu thụ đầu vào): Trực tiếp chuyển hóa các Triết lý, Mô hình chủ quyền, Học thuyết Sổ cái, Truyền thông và ACXD từ [VOL I - 02] Business Doctrine Blueprint V2.1.
Referenced By (Được sử dụng bởi): Làm căn cứ tối cao cho toàn bộ các miền nghiệp vụ chuyên trách tại Tập II ([VOL II - 04] sang [VOL II - 09]), làm mẫu bắt buộc cho việc thiết kế hợp đồng giao tiếp ở Tập III (VOL III) và hướng dẫn triển khai, giám sát ở Tập IV (VOL IV).
6. BLUEPRINT (BẢN VẼ KIẾN TRÚC HỆ THỐNG LUẬN LÝ)
6.1 Nguyên lý Kiến trúc Cốt lõi (The 9 Architectural Principles)
Mọi phân hệ nghiệp vụ và giải pháp kỹ thuật bắt buộc phải tuân thủ nghiêm ngặt 9 nguyên lý DNA sau:
Domain First: Thiết kế xoay quanh lõi nghiệp vụ và ranh giới miền, công nghệ lưu trữ hay giao diện chỉ là chi tiết thực thi phục vụ miền.
Events over Shared State: Các phân hệ giao tiếp với nhau bằng cách phát tín hiệu sự kiện (Events) chuẩn hóa snake_case, không chia sẻ trực tiếp vùng nhớ dữ liệu hoặc ghi chung bảng cơ sở dữ liệu.
Immutable Business Ledger: Kiến trúc áp đặt mọi hành vi làm thay đổi trạng thái hệ thống phải tạo ra một mẩu tin sổ cái nghiệp vụ chỉ ghi tiếp (Append-only), băm liên chuỗi, cấm tuyệt đối lệnh UPDATE/DELETE vật lý trên dòng lịch sử sử liệu.
Loose Coupling: Các phân hệ phải giữ mức độ phụ thuộc tối giản, đảm bảo sự thay đổi nội bộ của một miền không làm gãy đổ các miền khác thông qua ứng dụng cấu trúc Outbox/Inbox Pattern.
Asynchronous by Default: Ưu tiên xử lý bất đồng bộ đối với các tác vụ có độ trễ lớn, điều phối truyền thông hoặc cần sự phê duyệt đa bên để tối ưu hóa hiệu năng hệ thống.
Read Models are Disposable & Tailored: Các mô hình dữ liệu phục vụ hiển thị (Read Models) có thể bị hủy bỏ và tái lập hoàn toàn từ chuỗi sự kiện gốc hoặc Sổ cái gốc bất cứ lúc nào. Read Models phải được tinh gọn (Tailored Projections) để tối ưu payload cho Mobile Client.
Canonical Domain Ownership: Mỗi thực thể dữ liệu chỉ được sở hữu và thay đổi trạng thái bởi duy nhất một miền nghiệp vụ chuyên trách.
Adaptive Gateway Separation (CQRS vật lý biên): Tách biệt hoàn toàn luồng viết (Commands qua RESTful Gateway) và luồng đọc (Queries qua GraphQL Gateway với Cursor Pagination bắt buộc để chống DoS thiết bị di động).
Fault-Tolerant Human Interaction (Elder-First Design): Lớp kiến trúc logic phải cung cấp khả năng chịu lỗi hành vi cao: cho phép lưu tạm trạng thái (Draft Workflow), khôi phục tiến trình (Resume Workflow) và hỗ trợ ủy quyền thực thi (Trusted Delegate) để chống thao tác nhầm ở người cao tuổi.
6.2 Khung Nhìn Hệ thống Tổng thể và CQRS (Overall System Layering View)
[ADAPTIVE CLIENT EXPERIENCE] --> Mobile-First Client / Elder-First Voice & Large UX Touch                                      │ (Queries)                      │ (Commands)                                      ▼                                ▼[CANONICAL API GATEWAY]      --> GraphQL Gateway              --> RESTful Gateway                                 (Cursor Pagination, Max 100KB)    (Wizard / Resume Workflow)                                      │                                │                                      ▼                                ▼[APPLICATION LAYER]          --> Read Projections Cache       --> Doctrine & LAAC Evaluation                                      ▲                                │                                      │ (Sync / Async)                 ▼[DOMAIN LAYER]               --> Tailored Query Projections   --> Domain Aggregates Execution                                                                       │                                                                       ▼[INTEGRATION & LEDGER]       --> Event Broker (CloudEvents)   --> Outbox Table --> Business Ledger                                                                                   (Immutable Store)
6.3 Máy trạng thái Vòng đời Không gian Dòng họ (Clan Instance Lifecycle Machine)
Mỗi không gian số độc lập của một dòng họ (Clan Instance) vận hành qua chuỗi trạng thái luận lý, tích hợp chặt chẽ việc khóa học thuyết và lưu trữ lịch sử:
[INITIALIZED] --(Khóa cứng Tộc ước số & Sinh vân tay luật tục)--> [DOCTRINE_LOCKED]
                                                │
                                       (Hoàn thành nạp phả hệ gốc & Kích hoạt Sổ cái)
                                                │
                                                ▼
[ARCHIVED] <--(Đóng băng trường tồn - S3 WORM Lock)-- [PRODUCTION_ACTIVE]
6.4 Mô hình Định danh Luận lý và Toàn vẹn (Identity Model)
Thực thể dòng họ được cấu trúc định danh ở cấp độ khái niệm bao gồm:
Định danh thực thể (Identity Point): Khóa định danh duy nhất toàn cầu (UUIDv7 hướng thời gian) và con trỏ tham chiếu đến Node cội nguồn của cây phả hệ (Root Ancestor Node).
Chữ ký toàn vẹn luật tục (Doctrine Integrity Fingerprint): Mã băm mật mã học (SHA256) đại diện cho toàn bộ trạng thái cấu hình quy tắc tộc ước đã đồng thuận, đảm bảo phát hiện ngay lập tức mọi hành vi sửa đổi bất hợp pháp ngoài luồng Sổ cái.
6.5 Chuỗi Tiến trình Thẩm định Học thuyết & Ép buộc Sổ cái (Doctrine & Ledger Pipeline)
Mọi yêu cầu thay đổi trạng thái dữ liệu (Mutation Command) bắt buộc phải đi qua chuỗi thẩm định tuần tự tại tầng logic trước khi ghi nhận vào kho lưu trữ:
Mutation Request → Doctrine & LAAC Evaluation → Domain Validation → Persist Aggregate + Outbox Entry (Atomic Transaction) → Log to Business Ledger → Event Publication (CloudEvents v1.0)
Doctrine & LAAC Evaluation: Đối chiếu yêu cầu với bộ tham số quy tắc tộc ước (In-memory Cache) và tọa độ huyết thống hệ thống (Lineage-Aware Access Control). Nếu vi phạm quyền hạn chi phái hoặc tộc ước, từ chối ngay lập tức qua Canonical Error Model.
Atomic Transaction & Outbox Entry: Đảm bảo tính nhất quán tuyệt đối giữa việc cập nhật trạng thái thực thể cục bộ và ghi mẩu tin sự kiện vào bảng Outbox trong cùng một Transaction cơ sở dữ liệu.
Log to Business Ledger: Hệ thống tự động trích xuất payload nghiệp vụ thô để đóng gói thành một bản ghi business_ledger bất biến, thực hiện tính toán mã băm liên chuỗi phục vụ kiểm toán sử liệu trường tồn.
6.6 Kiến trúc Luồng Đồng thuận Bất đồng bộ & ACXD Workflow
Async Consensus Workflow: Đối với các tác vụ đụng chạm đến vùng dữ liệu tổ tiên chung hoặc vượt hạn mức tài chính, kiến trúc chuyển đổi luồng xử lý sang trạng thái chờ đồng thuận bất đồng bộ. Yêu cầu được đóng gói thành một Approval Proposal luận lý chứa ma trận chữ ký đại diện cần đạt và ngưỡng Quorum văn hóa ($2/3$, $50\%+1$, $100\%$). Hệ thống duy trì trạng thái cô lập (Isolated State) cho đến khi sự kiện Consensus Achieved kích hoạt luồng commit.
Communication Lifecycle Machine: Mọi thông điệp truyền thông chính thống phát đi từ hệ thống được kiểm soát nghiêm ngặt qua 6 trạng thái logic độc lập: Draft → Approved → Scheduled → Delivered → Read → Archived. Vòng đời này được giám sát bởi communication_ledger nhằm lưu vết bằng chứng truyền thông tộc sự.
Wizard & Resume Machine (Elder Support): Lớp API Command hỗ trợ cơ chế lưu vết trạng thái nhập liệu tạm thời (Stateful Session). Trưởng lão có thể thực hiện nhập liệu gia phả qua nhiều bước (Wizard API), nếu tiến trình bị ngắt quãng giữa chừng (do mất mạng, tắt ứng dụng), hệ thống cho phép nạp lại nguyên vẹn phiên làm việc thông qua Resume Workflow API.
7. ARCHITECTURE DECISIONS (CÁC QUYẾT ĐỊNH KIẾN TRÚC - ADR)
Mã Quyết định
Nội dung giải pháp & Ràng buộc kiến trúc (ADR Core)
 
ADR-01: Immutable History via Event Accumulation
Hệ thống quyết định ghi nhận lịch sử thay đổi của các miền lõi (Phả hệ, Sổ cái) dưới dạng chuỗi sự kiện tích lũy chỉ ghi tiếp (Append-only). Trạng thái hiện tại được thiết lập thông qua cơ chế Replay sự kiện hoặc qua Read Projections tối ưu. Điều này đảm bảo tính toàn vẹn lịch sử, chống tẩy xóa sử liệu tộc hệ.
ADR-02: Cached Doctrine Rules & LAAC Topology
Bộ tham số quy tắc của học thuyết dòng họ và bản đồ cấu trúc đồ thị huyết thống rút gọn phục vụ phân quyền quyền hạn (LAAC) bắt buộc phải được lưu trữ trên lớp bộ nhớ trong (In-memory Cache) để thẩm định thời gian thực (P95 < 300ms), triệt tiêu độ trễ truy vấn đệ quy DB thô.
ADR-03: Asynchronous Consensus for Grand Decisions
Chấp nhận việc trì hoãn trạng thái dữ liệu cuối cùng đối với các hành vi đại sự. Hệ thống sử dụng mô hình trạng thái tạm thời (Pending/Isolated State) để cô lập dữ liệu gây tranh chấp hoặc chờ biểu quyết đa bên cho đến khi tiến trình xử lý bất đồng bộ thu thập đủ minh chứng hợp lệ.
ADR-04: Mandatory Cursor Pagination & Payload Hard-Limit
Để thực thi chiến lược Mobile-First trong học thuyết ACXD, tất cả các API Query trên GraphQL Gateway bắt buộc phải áp dụng Connection/Edge Cursor Pagination. Nghiêm cấm sử dụng Offset Pagination. Thiết lập bộ lọc Gateway từ chối mọi phản hồi có kích thước vượt quá 100 KB để bảo vệ băng thông và bộ nhớ thiết bị di động.
ADR-05: Tailored Read Projections for Mobile Clients
Tách biệt hoàn toàn thực thể Domain thô đồ sộ khỏi mô hình dữ liệu trả về giao diện. Tầng Application chịu trách nhiệm xây dựng các góc nhìn tối giản (ví dụ: MemberSummaryProjection chỉ chứa tối đa 5 trường cốt lõi bao gồm danh tính, ảnh đại diện, chi phái, đời thứ) nhằm triệt tiêu tải trọng xử lý trên Mobile Client.
ADR-06: Outbox-Based Reliable Communication Delivery
Quy trình gửi truyền thông đa kênh không được thực thi trực tiếp trong luồng xử lý Command nghiệp vụ. Mọi thông điệp sau khi được phê duyệt sẽ sinh một bản ghi sự kiện vào Outbox Table và được quét bởi bộ điều phối bất đồng bộ nhằm thực thi cơ chế phân phối tin cậy, theo dõi trạng thái vòng đời tin nhắn chặt chẽ.

8. CROSS REFERENCES (THAM CHIẾU CHÉO)
Đối chiếu tiêu chí thành công và định hướng ACXD tại [VOL I - 01] Product Vision Blueprint V3.1.
Tham chiếu nền tảng học thuyết định tính và định nghĩa Sổ cái Nghiệp vụ tại [VOL I - 02] Business Doctrine Blueprint V2.1.
Tham chiếu đặc tả vật lý GraphQL/REST Gateway và cấu trúc mã CloudEvents tại [VOL III - 10] Canonical Enterprise API Platform Spec.
Tham chiếu cấu trúc bảng vật lý business_ledger và Outbox/Inbox Store tại [VOL III - 11] Enterprise Data & Persistence Architecture.
[KẾT THÚC TÀI LIỆU VOL I - 03 V2.1 - BASELINE APPROVED]