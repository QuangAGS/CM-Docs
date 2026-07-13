VOLUME II: BUSINESS DOMAINS
[VOL II - 07] COMMUNICATION & HONOR DOMAIN SPECIFICATION (REVISED V2.1)
Trạng thái: Baseline Approved | Phiên bản: V2.1 (Integrated Cross-cutting Doctrines)
Hệ thống: Web App Quản lý Dòng họ (Clan Management Platform)
Cấu trúc thực thi: Unified Domain Specification Contract (Domain-Driven Design Enforced)
1. PURPOSE (MỤC ĐÍCH)
Tài liệu này đặc tả chi tiết miền nghiệp vụ Communication & Honor Domain (Miền Truyền Thông & Tri Ân). Miền này đóng vai trò là hạ tầng phát ngôn, truyền tải thông cáo chính thống, thực thi vòng đời thông điệp toàn diện và quản trị văn hóa tri ân của dòng họ. Phạm vi chịu trách nhiệm bao gồm việc phối hợp quản lý bản tin tộc sự, điều phối định tuyến tin nhắn đa kênh (SMS, App Push, Email, Voice Call) qua Sổ cái truyền thông (Communication Ledger), và vận hành Bảng Vàng vinh danh bất biến trên nguyên lý liên kết lỏng (Loose Coupling) và nhất quán sau cùng (Eventual Consistency).
2. PRIMARY DESIGN QUESTION (CÂU HỎI THIẾT KẾ CỐT LÕI)
"Làm thế nào để kiến trúc một hệ thống quản trị vòng đời thông điệp 6 trạng thái nghiêm ngặt, đảm bảo cam kết phân phối phi trùng lặp (Idempotent), kết xuất các mô hình hiển thị Bảng Vàng và Bản tin tinh giản dưới 100 KB cho di động (Mobile-First) và cung cấp giao thức biên nhận một chạm siêu tối giản cho người cao tuổi (Elder-First UX)?"
3. SCOPE & RESPONSIBILITIES (RANH GIỚI & TRÁCH NHIỆM MIỀN)
3.1 Trong phạm vi (Scope)
Multi-Channel Dispatching Engine: Chuyển hóa cấu trúc tin nhắn thông qua Template Engine và phân phối bất đồng bộ qua hệ thống trừu tượng hóa kênh (Channel Adapters).
Communication Lifecycle Core: Quản lý vòng đời thông điệp chính thống đi qua đầy đủ các bước từ dự thảo, phê duyệt, lên lịch, phân phối, đến khi lưu trữ lịch sử kiểm toán liên lạc (Communication Ledger).
Clan Bulletin Board: Quản lý luồng tin tức, thông cáo đại sự dòng họ và bình luận tương tác dưới mô hình các Aggregate Root phân rã cô lập.
Honor Registry & Aura Object: Ghi nhận công đức, thành tích khoa cử của con cháu thông qua đối tượng giá trị bất biến (Aura Value Object).
3.2 Ngoài phạm vi (Out of Scope)
Không tham gia tính toán khoảng cách hoặc thời gian biểu nhắc nhở giỗ chạp (trách nhiệm thuộc về [VOL II - 05] Event & Ritual Domain).
Không thực hiện xác minh chứng từ hoặc sửa đổi dòng tiền đóng góp thực tế (trách nhiệm thuộc về [VOL II - 06] Ledger Domain).
3.3 Bản đồ Trách nhiệm Miền (Domain Responsibilities)
Sở hữu thực thể (Owns)
Tham chiếu ngoài (References)
Phát sự kiện (Publishes)
Tiêu thụ sự kiện (Consumes)
 
BulletinPost
BulletinComment
OutboundMessage
MessageTemplate
HonorRecord
CommunicationLedgerEntry
Member ID (VOL II-04)
Branch ID (VOL II-04)
ClanEvent ID (VOL II-05)
LedgerTransaction ID
PostPublished
CommentCreated
MessageDispatched
MessageDelivered
MessageDeliveryFailed
CommunicationRead
CommunicationExpired
HonorRecordCreated
AuraLevelUpgraded
ReminderPlanned
TransactionVerified
MemberCreated
BranchChanged
DoctrineChanged
4. CANONICAL VOCABULARY & ENTITIES (TỪ ĐIỂN THUẬT NGỮ & THỰC THỂ CHUẨN TẮC)
4.1 Từ điển Thuật ngữ (Vocabulary)
Communication Ledger: Phân hệ sổ cái lưu vết vĩnh viễn trạng thái phân phối, biên nhận thông điệp, làm bằng chứng tộc sự không thể tẩy xóa.
Aura Value Object: Đối tượng giá trị đóng gói điểm số, danh hiệu vinh danh. Có đặc tính bất biến tuyệt đối (Immutable).
Deduplication Key: Khóa phi trùng lặp bắt buộc tạo lập từ hệ thống để ngăn chặn việc gửi lặp thông báo trên mạng lưới phân tán.
Simple Notification (Thông báo tối giản): Cấu trúc tin nhắn đã triệt tiêu toàn bộ định dạng đồ họa phức tạp, chỉ chứa văn bản thuần hoặc tệp âm thanh đọc số hóa, phục vụ riêng cho người cao tuổi.
4.2 Mô hình Thực thể Mở rộng (Canonical Entities)
OutboundMessage: [message_id (UUIDv7), deduplication_key (String), recipient_member_id (UUIDv7), channel (Enum: SMS/PUSH/EMAIL/VOICE), status (Enum: DRAFT/APPROVED/SCHEDULED/SENDING/DELIVERED/FAILED), retry_count (Integer), rendered_payload (Text), scheduled_at (Timestamp)]
HonorRecord: [honor_id (UUIDv7), member_id (UUIDv7), source_type (Enum: LEDGER_DONATION/EDUCATION_ACHIEVEMENT), source_reference_id (UUIDv7), title (String), aura (AuraValueObject), recognized_at (Timestamp)]
5. RELATED DOCUMENTS (TÀI LIỆU LIÊN QUAN)
Consumer of (Tiêu thụ đầu vào): Triển khai học thuyết Quản trị truyền thông và ACXD từ [VOL I - 02] V2.1, quy tắc Cursor Pagination và Payload < 100 KB từ [VOL I - 03] V2.1, tiêu thụ thông tin liên lạc thành viên từ [VOL II - 04] V2.1, lắng nghe bản thiết kế lịch nhắc reminder_planned từ [VOL II - 05] V2.1, và lắng nghe sự kiện ghi nhận hạch toán công đức transaction_verified từ [VOL II - 06] V2.1 để kích hoạt vinh danh.
Referenced By (Được sử dụng bởi): Đóng vai trò là cổng ra giao tiếp viễn thông vật lý cho toàn bộ các phân hệ API tại Tập III (VOL III).
6. DOMAIN COMMANDS, MODEL & WORKFLOWS (LỆNH MIỀN, MÔ HÌNH & TIẾN TRÌNH)
6.1 Cấu trúc Phân rã Cụm Tổng hợp (Aggregate Root Strategy)
Nhằm triệt tiêu rủi ro phình to dữ liệu (Mega-Aggregate), miền phân rã thành 4 Cụm tổng hợp cô lập kết nối qua Khóa ngoại:
[BulletinPost]  |  [BulletinComment]  |  [OutboundMessage]  |  [HonorRecord]
6.2 Máy Trạng thái Vòng đời Thông điệp Toàn diện (Message Lifecycle Machine)
Mọi OutboundMessage bắt buộc phải vận hành xuyên suốt ma trận trạng thái của Học thuyết Truyền thông, tự động đồng bộ hóa sang Sổ cái:
[DRAFT] ──> [APPROVED] ──> [SCHEDULED] ──> [SENDING] ──┬──> [DELIVERED] ──> (Lưu Communication Ledger)                                                        │                                                        └──> [FAILED] ──> [RETRY_PENDING] ──> (Vượt hạn → DLQ)
6.3 Mô hình Hiển thị Hội tụ Tinh giản (ACXD Projections)
BranchNewsFeedView (Mobile-First): Bản tin phân mảnh theo chi phái. Áp dụng giới hạn cứng Payload < 100 KB và ép buộc phân trang Cursor, triệt tiêu tải trọng xử lý trên Mobile Client.
HonorRankingBoardView: Bảng vàng điện tử hiển thị thứ tự tôn vinh phụng hiến đóng góp được xử lý bất đồng bộ, cập nhật theo mô hình nhất quán sau cùng (Eventual Consistency).
Elder-First Acknowledge API: Đầu cuối API tiếp nhận biên nhận một chạm (Read Receipt) từ giao diện tối giản của người cao tuổi, tự động phát sự kiện communication_read mà không yêu cầu hiểu biết công nghệ.
6.4 Luồng Xử lý Định tuyến và Kênh Dự phòng Thông minh
Khi tiến trình Background Worker bóc tách sự kiện đầu vào hoặc quét Outbox Table:
reminder_planned Event → Template Rendering → Check NotificationPreference → Try App Push (Free Tier) → Fail? → Fallback to VoiceCall / SMS Adapter (Paid Tier) → Commit to Communication Ledger
7. DOMAIN INVARIANTS (CÁC RÀNG BUỘC TOÀN VẸN BẤT BIẾN)
INV-01 (Khóa Ranh giới Quyền lực - Display Only): Thực thể HonorRecord và đối tượng Aura được thiết lập với đặc tính chỉ phục vụ hiển thị tri ân văn hóa. Nghiêm cấm tuyệt đối việc sử dụng điểm số Aura để tính toán phân bổ quyền truy cập hệ thống, xét duyệt biểu quyết tộc sự, cấp đặc quyền quản trị hoặc can thiệp vào bộ quy tắc Doctrine Matrix và Security.
INV-02 (Bảo toàn ranh giới thông tin bài viết): Một bài viết BulletinPost cấu hình giới hạn hiển thị nội bộ Chi phái X tuyệt đối không được phép xuất hiện trong luồng kết xuất BranchNewsFeedView của thành viên thuộc Chi phái Y.
INV-03 (Bảo toàn tính bất biến của lõi tri ân): Điểm số chứa trong Aura Value Object của một HonorRecord một khi đã ghi sổ thành công bắt buộc phải khớp logic vĩnh viễn với mã tham chiếu gốc source_reference_id của miền Sổ cái, cấm mọi hành vi sửa đổi tăng giảm số dư điểm thô bằng tay.
INV-04 (Ràng buộc Payload bản tin - ACXD): Mọi Query kết xuất dòng tin tức lên thiết bị di động bắt buộc phải kiểm soát dung lượng phản hồi thô dưới ngưỡng nghiêm ngặt 100 KB.
8. DOMAIN EVENTS (DANH SÁCH SỰ KIỆN MIỀN)
Các sự kiện nghiệp vụ phát ra dưới cấu trúc chuẩn snake_case và định dạng CloudEvents v1.0:
post_published: Bài viết chính thống được phê duyệt phát hành lên bản tin dòng họ.
comment_created: Con cháu khởi tạo bình luận tương tác dưới bài đăng đại sự.
message_dispatched: Tin nhắn được đưa vào luồng gửi vật lý qua Channel Adapter.
message_delivered: Kênh đối tác xác nhận thông điệp đã tới thiết bị đầu cuối của thành viên.
message_delivery_failed: Quá trình phân phối thông điệp thất bại sau khi đã cạn kiệt số lần cấu hình thử lại.
communication_read: Thành viên xác nhận đã đọc thông điệp (Kích hoạt luồng biên nhận một chạm).
communication_expired: Thông điệp triệu tập hoặc nhắc nhở hết hiệu lực thời gian.
honor_record_created: Hồ sơ vinh danh công đức được khai sinh, cập nhật vào Bảng Vàng.
9. ARCHITECTURE DECISIONS (QUYẾT ĐỊNH KIẾN TRÚC MIỀN - ADR)
Mã Quyết định
Nội dung giải pháp & Ràng buộc kiến trúc (ADR Core)
 
ADR-01: Asynchronous Fan-Out Message Generation
Miền Truyền thông vận hành tách biệt, không bao giờ khởi tạo tin nhắn đồng thì với luồng xử lý của miền Sự kiện gốc. Mọi tiến trình nhân bản tin nhắn vật lý bắt buộc phải được xử lý bởi lớp Background Worker bất đồng bộ nhằm giải phóng hoàn toàn hiệu năng xử lý tác vụ cốt lõi.
ADR-02: Fallback Channel Routing Strategy (ACXD)
Hệ thống tối ưu hóa chi phí bằng cách ưu tiên các kênh thông báo không tốn phí vật lý (Push Notification). Khi bộ chuyển đổi báo lỗi thiết bị không khả dụng hoặc đối tượng là người cao tuổi không cài App, hệ thống tự động hạ cấp định tuyến sang kênh viễn thông giọng nói tự động (Voice Call Adapter) hoặc SMS để bảo đảm thông tin luôn tới đích.
ADR-03: Event-Driven Honor Ingestion (Loose Coupling)
Nghiêm cấm hành vi nhúng trực tiếp mã nguồn tính toán điểm vinh danh vào bên trong các tiến trình xử lý giao dịch tài chính của miền Sổ cái. Miền Truyền thông đứng ngoài ranh giới context, hấphtu thông tin gián tiếp thông qua việc lắng nghe các sự kiện công khai phát ra từ trục kết nối trung tâm.
ADR-04: Idempotent Dispatching Strategy via Deduplication Key
Thực thể `OutboundMessage` bắt buộc phải sở hữu thuộc tính `deduplication_key` được thiết lập tự động theo quy tắc cấu trúc: (event_id + member_id + channel). Mọi tin nhắn trùng khóa đối chiếu này tại tầng lưu trữ sẽ bị loại bỏ ngay tại vòng thẩm định Command Validation để tránh làm phiền gia tộc.
ADR-05: Communication Domain is Eventually Consistent
Hoạt động kỹ thuật của miền này (gửi tin nhắn, hiển thị bảng tin, nâng cấp bậc danh hiệu Aura) không bao giờ được phép can thiệp hoặc kéo dài thời gian hoàn tất tác vụ (Transaction block) của các miền chính. Mọi gián đoạn kết nối mạng viễn thông bên thứ ba sẽ được đồng bộ bù đắp bất đồng bộ ở chu kỳ sau.
ADR-06: Outbox Pattern for Enterprise Reliability
Toàn bộ các Command tác động thay đổi trạng thái bài đăng, tin nhắn, hồ sơ vinh danh bắt buộc phải được lưu trữ đồng thời vào bảng Outbox cục bộ trong cùng một Transaction nguyên tử của cơ sở dữ liệu. Tiến trình ngầm quét độc lập sẽ chịu trách nhiệm bốc dữ liệu đẩy ra Event Broker toàn cục an toàn.
ADR-07: Notification Channel Independence via Adapter Pattern
Lớp gửi tin nhắn vật lý bắt buộc phải đứng sau các giao diện trừu tượng hóa (Channel Adapters) bao gồm: SMSAdapter, EmailAdapter, PushAdapter, và VoiceAdapter. Việc hoán đổi, nâng cấp đối tác viễn thông bên thứ ba hoàn toàn không được gây ảnh hưởng hay biến đổi cấu trúc logic của miền nghiệp vụ cốt lõi.
ADR-08: Mandatory Communication Ledger Logging
Mọi sự kiện thay đổi trạng thái cuối của tin nhắn (Delivered, Read, Expired) bắt buộc phải tạo mẩu tin đóng dấu lịch sử vĩnh viễn vào `communication_ledger` để phục vụ công tác thanh tra kiểm toán tộc sự dài hạn qua các thế hệ.
ADR-09: Voice Call Optimization for Elder Experience
Thiết lập riêng bộ chuyển đổi `VoiceAdapter` tích hợp cùng AI Synthesis. Khi kế hoạch nhắc nhở phát tín hiệu đến tài khoản người cao tuổi, hệ thống ưu tiên chuyển đổi kịch bản chữ thô thành cuộc gọi thoại tự động nhắc lịch giỗ chạp, triệt tiêu toàn bộ rào cản thao tác màn hình thông minh.

10. CROSS REFERENCES (THAM CHIẾU CHÉO)
Đối chiếu chỉ số phân phối tin nhắn và trải nghiệm tiếp cận của người già tại [VOL I - 01] Product Vision Blueprint V3.1.
Tham chiếu hiến pháp về quản trị vòng đời truyền thông và triết lý Sổ cái nghiệp vụ tại [VOL I - 02] Business Doctrine Blueprint V2.1.
Tham chiếu mô hình Outbox Pattern và ADR-06 về phân phối tin cậy một lần duy nhất tại [VOL I - 03] Product Architecture Blueprint V2.1.
Tham chiếu nguồn dữ liệu NotificationPreference và cấu hình liên lạc phả hệ tại [VOL II - 04] Lineage & Member Domain Specification V2.1.
Tham chiếu nguồn thiết kế nhắc nhở giỗ chạp phát ra từ reminder_planned tại [VOL II - 05] Event & Ritual Domain Specification V2.1.
Tham chiếu nguồn phát sự kiện hạch toán công đức tài chính transaction_verified tại [VOL II - 06] Financial & Governance Ledger Domain Specification V2.1.
Tham chiếu thiết kế cấu trúc các bảng vật lý theo dõi hiệu năng truyền thông tại [VOL III - 11] Enterprise Data & Persistence Architecture.
[KẾT THÚC TÀI LIỆU VOL II - 07 V2.1 - BASELINE APPROVED]