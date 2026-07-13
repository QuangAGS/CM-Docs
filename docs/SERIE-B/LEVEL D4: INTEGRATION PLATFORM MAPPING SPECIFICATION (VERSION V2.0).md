LEVEL D: PLATFORM MAPPING SPECIFICATIONS
[LEVEL D4] INTEGRATION PLATFORM MAPPING SPECIFICATION (OFFICIAL FROZEN FINAL VERSION V2.0)
Trạng thái: Frozen Baseline Approved | Phiên bản: V2.0 (Canonical Enterprise Integration Engineering Handbook)
Hệ thống: Nền tảng Quản lý Dòng họ Số (Clan Management Platform)
Cấu trúc thực thi: Absolute Production-Grade Event-Driven & Integration Platform Contract (Zero Ambiguity)
1. PURPOSE & SCOPE (MỤC ĐÍCH & PHẠM VI)
Tài liệu này là Hiến pháp Kỹ thuật Tích hợp và Truyền thông điệp (Integration Engineering Constitution) tối cao dành cho Kỹ sư Hệ thống, Kỹ sư Tích hợp, và các Trí tuệ Nhân tạo lập trình (AI Coding Agents) của dự án Clan Management Platform. Đoạn tuyệt hoàn toàn với các phần mô tả kiến trúc định hướng chung chung của phiên bản trước, bản V2.0 là một Sổ tay Kỹ thuật Sản xuất (Production Integration Engineering Handbook) khép kín toàn vẹn. Tài liệu triệt tiêu 100% mọi quyết định tự phát của AI hay con người bằng cách khóa cứng các ma trận định tuyến API, danh mục sự kiện, máy trạng thái vòng đời tin nhắn, chiến lược xử lý lỗi phát sinh (Retry/DLQ), giao ước Replay phục hồi Projections và quy tắc tiến hóa Schema không phá vỡ tính tương thích.
2. TECHNOLOGY DECISIONS & STANDARD PROTOCOLS
Hệ thống kết nối và tích hợp đóng băng cứng các phân tầng giải pháp công nghệ Cloud-Native cấp doanh nghiệp lớn:
Enterprise Event Broker Core: Apache Kafka (v3.6+ sử dụng cơ chế KRaft Cluster vật lý). Cam kết phi tập trung dữ liệu luồng bất biến.
Change Data Capture (CDC) Engine: Debezium (v2.4+) vận hành trong mô hình Kafka Connect Cluster chuyên trách. Chức năng duy nhất: Đọc Append-Only WAL Log của bảng outbox_event_log vật lý từ PostgreSQL, bốc tách sự kiện và chuyển đổi trực tiếp thành tin nhắn phát lên Kafka.
Edge API Gateway API Gateway: KONG API Gateway Enterprise (v3.4+) làm chốt chặn biên, quản lý độc quyền định tuyến HTTPS, bóc tách Identity Context, giới hạn tần suất (Rate Limiting) và bảo vệ an ninh.
Internal RPC & Serialization Store: gRPC kết hợp Protocol Buffers (Protobuf v3) thực thi các luồng gọi dịch vụ đồng thì nội bộ dưới cơ chế an ninh mã hóa liên phân hệ mTLS (Mutual TLS).
Centralized Schema Governance: Confluent Schema Registry (v7.5+). Chuẩn hóa định dạng tuần tự hóa duy nhất là Protobuf Schema, áp đặt luật tiến hóa BACKWARD_COMPATIBLE.
3. INTEGRATION TOPOLOGY PIPELINE (SƠ ĐỒ TOÀN CẢNH LUỒNG DỮ LIỆU)
AI và Kỹ sư hệ thống bắt buộc triển khai đúng mô hình cấu trúc phân phối dữ liệu khép kín sau:
[Client Apps] → (HTTPS/REST) → [KONG Gateway Edge] → (Internal Private Endpoint) → [Command API / Service Layer] → (Prisma SQL UOW) → [PostgreSQL Core WAL Log] → (Debezium CDC Stream Engine) → [Apache Kafka Broker Cluster] → (Exactly-Once Event Forwarding) → [Event Consumer Workers] → (Projection Builder Logic) → [OpenSearch / Redis / S3 Storage Projections]
4. INTEGRATION STACK OVERVIEW (TỔNG QUAN TẦNG VẬT LÝ)
KONG Gateway (Edge API) + Apache Kafka Cluster (Event Broker) + Debezium Connect Cluster (CDC WAL Engine) + Confluent Schema Registry (Protobuf Only) + gRPC Core (mTLS Inter-Service)
5. INTEGRATION DOCTRINES (LINH HỒN KIẾN TRÚC TÍCH HỢP)
Exactly-Once Processing Semantics: Hệ thống kết hợp chặt chẽ bộ ba giải pháp: Idempotent Producer của Kafka (`enable.idempotence=true`) + Transactional Append-Only Outbox tại PostgreSQL + Cơ chế bộ lọc kiểm trùng Inbox Log Table tại Tầng Ứng dụng nhận nhằm bảo đảm tin nhắn nghiệp vụ chỉ được xử lý đúng một lần duy nhất.
Strict Protobuf Serialization Rule: Khóa cứng Protocol Buffers làm định dạng tuần tự hóa dữ liệu độc tôn trên trục tích hợp Kafka. Nghiêm cấm sử dụng hỗn hợp Avro, JSON Schema, hoặc chuỗi JSON thô vô danh để tránh suy diễn kiểu dữ liệu.
Loose Coupling & Fault Tolerance: Hệ thống tích hợp vận hành theo mô hình Nhất quán sau cùng (Eventual Consistency). Sự cố sập dịch vụ tiêu thụ (Consumers) tuyệt đối không được gây treo, tắc hoặc rollback giao dịch chính gốc tại PostgreSQL Core. Tin nhắn được lưu vết an toàn trên phân vùng đĩa cứng vật lý của Kafka Broker chờ xử lý bù đắp bất đồng bộ.
Immutable WAL CDC Model: Sửa đổi kỹ thuật: Nhân Debezium chỉ đóng vai trò là Read-Only Engine đọc WAL Log đối với bảng `outbox_event_log` có tính chất Append-Only vật lý. Debezium KHÔNG thực hiện bất kỳ lệnh `UPDATE` hoặc ghi ngược cờ `is_dispatched = TRUE` nào về PostgreSQL để tránh lặp khóa IOPS. Việc dọn dẹp các mẩu tin Outbox cũ (nếu có) sẽ được đảm nhiệm bởi một Batch Script định kỳ chạy ngầm ở mức Database.
6. SERVICE COMMUNICATION & API CLASSIFICATION MATRIX
6.1 API Classification Doctrine (Quy chuẩn phân định hình thái API)
RESTful API (JSON): Áp dụng độc quyền cho các kết nối biên ngoài (External Client-to-Gateway), giao tiếp thiết bị người dùng cuối.
gRPC (Protobuf over HTTP/2): Áp dụng độc quyền cho các luồng giao tiếp đồng thì nội bộ giữa các Microservices nằm trong biên giới mạng bảo mật (Internal Inter-Service RPC).
Kafka Event-Driven Stream: Áp dụng độc quyền cho các luồng giao tiếp bất đồng bộ, phân tán tác vụ phụ thuộc, và cập nhật Read Projections giữa các Bounded Context độc lập.
WebSocket Protocol: Áp dụng độc quyền cho các luồng đẩy thông báo trạng thái thời gian thực (Realtime Notifications) từ hệ thống biên về ứng dụng Client của thành viên dòng họ.
6.2 Ma trận kết nối và giao vận dịch vụ (Service Communication Matrix)
Source Subsystem
Destination Subsystem
Protocol Standard
Traffic Type
Security Enforcement Layer
 
Mobile / Web App Client
KONG API Gateway
REST / HTTPS
External Inbound
TLS 1.3 + KONG JWT + Rate Limiting Plugin
KONG API Gateway
Identity Service
gRPC
Internal RPC
Private VPC Endpoint + mTLS Encryption
Identity Service
Member Service
gRPC
Internal RPC
mTLS Certificates Constraint
Member Service (Outbox)
Apache Kafka Core
Kafka Native Wire
Async Event Ingest
SASL/SCRAM + Kafka ACL Policies
Apache Kafka Core
Search / Projection Workers
Kafka Native Wire
Async Event Consumer
SASL/SCRAM + Kafka ACL Policies
7. INTEGRATION OWNERSHIP MATRIX (MA TRẬN CHỦ QUYỀN TÍCH HỢP)
Xác định rõ ràng Service nào nắm bản quyền khởi tạo, phát hành và tiêu thụ dữ liệu tin nhắn, loại bỏ lỗi cấu hình chéo:
Service Context Name
Owns Core Domain Aggregate
Publishes Core Events
Consumes External Events
 
Identity Context
User, SecurityToken, AccessControl
vn.clanplatform.identity.user.created
None
Member Context
Member, Branch, GenealogyTree
vn.clanplatform.member.profile.updated
vn.clanplatform.identity.user.created
Ledger Context
FinancialLedger, AuditLogEntry
vn.clanplatform.ledger.transaction.verified
None
Ritual Context
RitualCalendar, AncestorCeremony
vn.clanplatform.ritual.ceremony.completed
vn.clanplatform.member.profile.updated
8. TOPIC CATALOG & PHYSICAL PARTITIONING STRATEGY
8.1 Topic Catalog Baseline
Physical Topic Name
Primary Producer Service
Primary Consumer Subsystems
Physical Schema Mapping Contract
 
vn.clanplatform.identity.user.created
Identity Context (via CDC)
Member Context, Ritual Context
identity_event_v1.proto
vn.clanplatform.member.profile.updated
Member Context (via CDC)
Search Projection, Ritual Context
member_event_v1.proto
vn.clanplatform.ledger.transaction.verified
Ledger Context (via CDC)
Financial Projection Worker
ledger_event_v1.proto
vn.clanplatform.ritual.ceremony.completed
Ritual Context (via CDC)
Notification Push Service
ritual_event_v1.proto
8.2 Hot Partition Mitigation Strategy (Chiến lược xử lý phân vùng quá tải)
Mặc định, trường tenant_id được băm làm Partition Key để bảo toàn tính độc lập và tuần tự cho từng dòng họ. Tuy nhiên, để xử lý tình huống dòng họ có quy mô cực lớn sinh lượng tin đột biến gây quá tải một phân vùng vật lý đơn lẻ (Hot Partition Risk), AI và hệ thống Connect bắt buộc áp dụng quy tắc: Nếu dung lượng tin nhắn của một dòng họ vượt ngưỡng 10,000 sự kiện/giờ, Partition Key sẽ tự động được gộp thành chuỗi tổ hợp: tenant_id + "_" + (recorded_at::timestamp % 4) để phân rã tải đều sang 4 phân vùng vật lý khác nhau một cách mượt mà.
9. EVENT CATALOG & LIFECYCLE FSM
9.1 Event Catalog Specifications
Event Name: `vn.clanplatform.member.profile.updated` | Version: v1.0 [cite: 1f0C-dDHFtRWaOXnMm6k1vsManJYXiUkweH2H05dlLZE]• Producer: Member Service | Consumers: OpenSearch Summary Index Worker, Neo4j Lineage Sync [cite: 1f0C-dDHFtRWaOXnMm6k1vsManJYXiUkweH2H05dlLZE]• Retention Budget: 365 Days | Max Size Limit: 256 KB.
Event Name: `vn.clanplatform.ledger.transaction.verified` | Version: v1.0 [cite: 1f0C-dDHFtRWaOXnMm6k1vsManJYXiUkweH2H05dlLZE]• Producer: Ledger Service | Consumers: Financial Analytics Engine, S3 Audit Archive [cite: 1f0C-dDHFtRWaOXnMm6k1vsManJYXiUkweH2H05dlLZE]• Retention Budget: Forever (Infinite Log) | Max Size Limit: 128 KB.
9.2 Event Lifecycle Finite State Machine (Máy trạng thái vòng đời sự kiện)
Mọi sự kiện tích hợp bắt buộc phải trải qua và được xác thực trạng thái theo đúng biểu đồ FSM đóng băng sau:
[CREATED] → (Prisma Outbox Write) → [OUTBOX_PERSISTED] → (Debezium CDC Read) → [CDC_CAPTURED] → (Kafka Wire Ingest) → [KAFKA_COMMITTED] → (Consumer Worker Pull) → [CONSUMED] → (Projection Persistence) → [PROJECTED] → (Idempotency Inbox Log Commit) → [ACKNOWLEDGED] → (Retention Expiry Policy) → [ARCHIVED_IN_S3]
10. ERROR HANDLING DOCTRINE (MẠCH XỬ LÝ LỖI PHÂN TÁN)
10.1 Retry & Dead Letter Queue (DLQ) Strategy
AI và Kỹ sư vận hành bắt buộc cài đặt cấu trúc mạch ngắt lỗi 3 cấp phân tầng tự động cho toàn bộ Consumers:
Immediate Retry Layer: Khi xảy ra lỗi kết nối mạng tạm thời, hệ thống thực thi thử lại ngay lập tức tại chỗ 3 lần liên tục.
Exponential Backoff Topic Layer: Nếu Immediate Retry gãy đổ, tin nhắn tự động chuyển tiếp sang Topic chờ trung gian có cấu hình tăng tiến thời gian: vn.clanplatform.[service_name].retry.backoff. Thực hiện thử lại tối đa 5 lần với khoảng giãn cách: 2s, 4s, 8s, 16s, 32s.
Dead Letter Queue (DLQ) Isolation Layer: Nếu vượt quá hạn ngạch thử lại, tin nhắn bắt buộc phải tách biệt hoàn toàn khỏi luồng chính và đẩy vào Topic cô lập lỗi DLQ để đảm bảo không gây tắc nghẽn luồng xử lý toàn cục của hệ thống.
10.2 DLQ Implementation Contract Laws
DLQ Parameter Configuration
Strict Production Enforcement Value
Operational Law & Rationale
 
Naming Convention
[original_topic_name].dlq
Ánh xạ tương thích 1:1 giúp AI định vị nguồn phát lỗi tức thời.
Retention Policy Budget
30 Days (720 Hours) Fixed
Quá hạn ngạch 30 ngày tự động hủy bỏ. Bảo vệ đĩa cứng Broker không tràn.
Replay Execution Permission
Role: ClusterAdmin ONLY
Nghiêm cấm Client Service tự ý Replay mẩu tin lỗi lên trục chính tự phát.
Message Ordering Status
Ordering = IGNORED
Chấp nhận mất thứ tự tuyến tính để cô lập mẩu tin lỗi, cứu luồng chính chạy tiếp.
Alert & Observability Trigger
Instant Prometheus Counter Push
Nếu số lượng mẩu tin trong DLQ tăng > 5 tin nhắn/phút, kích hoạt chuông báo động SRE.
11. DATA REPLAY & PROJECTION REBUILD DOCTRINE
Khi kho lưu trữ phái sinh (như OpenSearch hoặc Redis) bị đổ vỡ toàn diện hoặc cấu trúc Read Model thay đổi phiên bản lớn, hệ thống thực hiện tái lập thông qua cơ chế Replay chính thống:
-- Kịch bản quy trình Replay chuẩn hóa cho AI hiện thực hóa:GIAI_ĐOẠN_1: Ngắt toàn bộ mã nguồn xử lý sự kiện online của Consumer Worker đích để tránh tranh chấp dữ liệu.GIAI_ĐOẠN_2: Khởi tạo một mẫu Index phái sinh trống mới (e.g., member_summary_index_v2).GIAI_ĐOẠN_3: Cấu hình lại Kafka Consumer Group Offset về mốc sơ khai: `seekToBeginning()`.GIAI_ĐOẠN_4: Kích hoạt luồng Consumer Replay luân chuyển tin nhắn tốc độ cao, tái lập toàn bộ trạng thái vào Index mới.GIAI_ĐOẠN_5: Thực thi đối soát kiểm toán mã băm bám đuôi (`Compare Checksum`) giữa PostgreSQL Core và Index phái sinh mới.GIAI_ĐOẠN_6: Tráo đổi định danh định tuyến (OpenSearch Alias Swap) sang Index mới và tái kích hoạt luồng xử lý online.
12. API VERSIONING & SCHEMA EVOLUTION RULES
12.1 Edge API Gateway Versioning Rules
Toàn bộ API biên ngoài phải tích hợp rõ ràng phiên bản trong đường dẫn URL thô (Ví dụ: /api/v1/member, /api/v2/member).
Breaking Changes Policy: Tuyệt đối nghiêm cấm việc sửa đổi kiểu dữ liệu trực tiếp hoặc xóa bỏ các trường đang live trên cùng một phiên bản API. Nếu phát sinh thay đổi phá vỡ tương thích, bắt buộc phải phát hành phiên bản URL mới (v2) và duy trì phiên bản cũ (v1) song song trong tối thiểu 12 tháng trước khi tắt hẳn (Deprecation Stage).
12.2 Schema Evolution Compatibility Rules (Luật Confluent Schema Registry)
Toàn bộ tệp hợp đồng Protobuf đẩy lên Schema Registry bắt buộc cấu hình luật BACKWARD_COMPATIBLE. AI khi tiến hóa Schema phải tuân thủ:
Protobuf Modification Act
Execution Status Rule
Strict Compilation Enforcement Constraint
 
Add New Field
ALLOWED
Bắt buộc trường mới phải gán vị trí số hiệu thuộc tính (Tag Number) mới tăng tiến. Không được chiếm dụng lại số hiệu cũ.
Delete Existing Field
FORBIDDEN
Nghiêm cấm xóa trường cũ khỏi file .proto. Chỉ được phép đánh dấu bằng từ khóa tiền tố reserved cho tag hiệu đó.
Change Primitive Type
CRITICAL FORBIDDEN
Tuyệt đối không được đổi kiểu dữ liệu của một số hiệu trường cũ (e.g., int32 sang string). Bắt buộc phải tạo trường mới hoàn toàn.
13. INTEGRATION STORAGE LAYOUT CONTRACTS (SƠ ĐỒ THƯ MỤC TÍCH HỢP TOÀN DIỆN)
Khóa cứng sơ đồ cấu trúc mã nguồn tích hợp cho toàn bộ các kho mã (Repositories):
integration/├── gateway/│   ├── KONG.yml                          # Tệp cấu hình định tuyến tĩnh Declarative của KONG Gateway biên ngoài│   └── middleware/                       # Lua custom scripts xử lý bóc tách token và bảo mật biên├── grpc/│   └── definitions/                      # Thư mục gốc chứa các file gRPC Service Contract mTLS nội bộ│       └── membership_rpc_v1.proto├── protobuf/│   ├── events/                           # Định nghĩa các cấu trúc Payload sự kiện lõi dạng CloudEvents│   │   ├── identity_events_v1.proto│   │   └── ledger_events_v1.proto│   └── schemas/                          # File khóa Schema Registry phiên bản định danh│       └── registry_lock.json├── topics/│   └── topics_config.json                # Định dạng khai báo cấu hình số lượng Partitions, Replica Factor vật lý├── dlq/│   └── consumers_dlq_handler.go          # Logic gom tin lỗi tự động cách ly đẩy sang phân vùng .dlq├── retry/│   └── backoff_scheduler.go              # Bộ lập lịch giãn cách thời gian lũy thừa (Exponential Backoff Policy)├── replay/│   └── rebuild_projection_orchestrator.go # Kịch kịch bản tự động tua ngược offset, tái thiết lập Read Models└── consumers/    └── workers/                          # Lớp hiện thực hóa việc nhận tin nhắn tích hợp kèm Inbox Guard Filter        ├── member_projection_worker.go        └── ledger_analytics_worker.go
14. IMPLEMENTATION CONTRACTS: PROTOBUF SCHEMA CONTRACT
Mẫu thiết kế hợp đồng thông điệp Protocol Buffers chuẩn hóa CloudEvents v1.0, tích hợp trường bọc định danh an toàn để AI sinh mã nguồn thô tự động:
syntax = "proto3";package vn.clanplatform.member.events;option go_package = "vn/clanplatform/member/events;member_events";option java_multiple_files = true;option java_package = "vn.clanplatform.member.events";// Hợp đồng dữ liệu sự kiện thay đổi hồ sơ phả hệ thành viên dòng họmessage MemberProfileUpdatedEvent {  // CloudEvents v1.0 Standard Context Core fields  string id = 1;                         // Event Unique ID (UUIDv7)  string source = 2;                     // Định danh hệ thống phát (e.g., "/services/member_context")  string specversion = 3;                // Phiên bản tiêu chuẩn (Mặc định: "1.0")  string type = 4;                       // Tên cấu trúc sự kiện định danh  string subject = 5;                    // Thực thể chịu tác động trực tiếp  string time = 6;                       // Thời gian ISO 8601 UTC Z  string datacontenttype = 7;            // Content-Type (Mặc định: "application/x-protobuf")    // Nghiệp vụ lõi Domain Payload  message MemberData {    string member_id = 1;    string tenant_id = 2;    string updated_field_mask = 3;        // Chứa danh sách các trường thay đổi để hỗ trợ cập nhật phẳng partial update    string full_name = 4;    string generation_number = 5;    string biological_father_id = 6;     // Khóa quan hệ định tuyến đồ thị cho Neo4j Lineage Graph    string correlation_id = 7;           // Khóa liên kết distributed tracing xuyên mạng  }    MemberData data = 8;}
15. EDGE SECURITY MAPPING MATRIX
Quy chuẩn bảo an toàn diện trên các phân tầng giao tiếp mạng lưới tích hợp:
Integration Layer
Primary Security Protocol
Authentication Mechanism
Authorization & Control Enforcement Policy
 
REST Web Endpoints
HTTPS TLS 1.3
KONG API Gateway JWT Verification
Bóc tách Identity Context nạp ngầm vào Header của Upstream
Internal RPC
gRPC over HTTP/2 mTLS
X.509 Digital Certificates Exchange
Chỉ chấp nhận các Certificate thuộc danh sách whitelist nội bộ VPC
Event Broker Cluster
Kafka Native TCP Protocol
SASL / SCRAM-SHA-512 Protocol
Kafka ACLs (Phân quyền chi tiết: Dịch vụ nào được phép Read/Write Topic nào)
Schema Registry
HTTPS Private Call
Bearer Mutual Token Authentication
ACLs khóa chặt quyền thay đổi cấu trúc file .proto của các ứng dụng
16. INTEGRATION CAPACITY PLANNING & PERFORMANCE BUDGETS
Hạ tầng Broker
Tham số cấu hình vật lý
Strict Production Enforcement Limit
SLA Performance & Target Threshold
 
Apache Kafka Cluster
Minimum Partitions Per Topic
12 Partitions Minimum
Bảo đảm khả năng co giãn tải cho tối thiểu 12 Consumer Workers song song.
Apache Kafka Cluster
Replication Factor Budget
3 Nodes (In-Sync Replicas = 2)
Chịu lỗi sập tối đa 1 Kafka Broker vật lý mà không mất mát dữ liệu.
Apache Kafka Cluster
Max Message Size Limit
1 MB Maximum Allowed Size
Nghiêm cấm đóng gói tệp tin ảnh băm nhị phân thô đẩy trực tiếp lên Kafka.
Apache Kafka Cluster
Compression Type Rule
compression.type = zstd
Tối ưu hóa băng thông mạng lưới và giảm tải dung lượng đĩa cứng lưu trữ.
Observability Metric
Maximum Consumer Lag Alert
< 5000 Messages Threshold
Nếu Consumer Lag vượt ngưỡng quá 5000 mẩu tin, kích hoạt lệnh tự động co giãn tải.
Observability Metric
CDC WAL Processing Delay
< 25 Milliseconds Budget
Đo lường thời gian từ lúc PostgreSQL ghi xong đĩa đến khi Debezium phát lên Kafka.
17. OBSERVABILITY INTEGRATION METRICS CATALOG
Hệ thống giám sát vận hành tích hợp bắt buộc thu thập và cảnh báo tự động thông qua OpenTelemetry Prometheus Agents các chỉ số định danh chính xác sau:
kafka.consumer.lag: Chỉ số đo lường số lượng mẩu tin tồn đọng chưa xử lý của từng Consumer Group (Cảnh báo đỏ: > 5000) [cite: 1f0C-dDHFtRWaOXnMm6k1vsManJYXiUkweH2H05dlLZE].
kafka.publish.duration: Giám sát phân phối thời gian Producer phát mẩu tin sự kiện nghiệp vụ lên Kafka Broker thành công.
grpc.client.duration: Đo lường tốc độ xử lý các cuộc gọi dịch vụ đồng thì nội bộ mã hóa mTLS giữa các microservices.
gateway.request.duration: Đo lường tổng thời gian định tuyến phản hồi của lớp cổng biên KONG API Gateway.
debezium.capture.delay: Đo lường tốc độ đọc nhật ký WAL của nhân CDC Debezium, phát hiện nghẽn tầng lưu trữ vật lý đĩa cứng.
dlq.message.count: Đếm số lượng tin nhắn gãy đổ bị đào thải đẩy vào Topic cô lập lỗi cách ly [cite: 1f0C-dDHFtRWaOXnMm6k1vsManJYXiUkweH2H05dlLZE]. (Cảnh báo SRE tức thời nếu giá trị biến động > 0).
18. QA AUTOMATION & CONTRACT TESTING GATES
Consumer-Driven Contract Testing Gate (Pact Verification Framework): Toàn bộ các file định nghĩa dịch vụ gRPC, tệp cấu hình API Gateway và sơ đồ Schema Protobuf bắt buộc chạy qua cổng kiểm thử hợp đồng dữ liệu tự động tại CI/CD Pipeline. Hệ thống sẽ ngay lập tức từ chối biên dịch và khóa lệnh tự động triển khai (Deploy Block) nếu phát hiện ra bất kỳ sửa đổi payload nào làm tổn hại đến khả năng đọc hiểu của hệ thống Client cũ.
19. AI CODING & PLATFORM INTEGRATION CONSTRAINTS (25 MỆNH LỆNH TỐI CAO CHO AI)
Mọi Trí tuệ Nhân tạo lập trình và sinh mã nguồn tích hợp (AI Coding Agent) khi tiếp cận hệ thống BẮT BUỘC tuân thủ tuyệt đối 25 mệnh lệnh ràng buộc cứng:

1. AI SHALL NOT generate any Kafka Producer configuration where the acks parameter value is set to 0 or 1; it MUST always be explicitly configured as all [cite: 1f0C-dDHFtRWaOXnMm6k1vsManJYXiUkweH2H05dlLZE].
2. AI SHALL NOT use native relational database cascading mechanisms to propagate multi-domain system mutations; all cross-boundary side effects MUST be driven via asynchronous Kafka events [cite: 1f0C-dDHFtRWaOXnMm6k1vsManJYXiUkweH2H05dlLZE].
3. AI SHALL enforce strict snake_case naming conventions for all Kafka topics, following the explicit structural blueprint: vn.clanplatform.[domain].[aggregate].[event] [cite: 1f0C-dDHFtRWaOXnMm6k1vsManJYXiUkweH2H05dlLZE].
4. AI SHALL automatically attach a deterministic Partition Key matching the tenant_id field configuration to every event record dispatched to the Kafka cluster store [cite: 1f0C-dDHFtRWaOXnMm6k1vsManJYXiUkweH2H05dlLZE].
5. AI SHALL NOT declare dynamic wildcard path matchers (/*) inside the KONG API Gateway declarative routes without binding a corresponding strict Rate-Limiting policy plugin [cite: 1f0C-dDHFtRWaOXnMm6k1vsManJYXiUkweH2H05dlLZE].
6. AI SHALL enforce mutual TLS (mTLS) configuration within every internal gRPC service definition file generated for inter-service RPC communication frameworks [cite: 1f0C-dDHFtRWaOXnMm6k1vsManJYXiUkweH2H05dlLZE].
7. AI SHALL serialize all financial numeric transaction data attributes as immutable string fields inside Protobuf definitions to prevent CPU floating-point decimal distortions [cite: 1f0C-dDHFtRWaOXnMm6k1vsManJYXiUkweH2H05dlLZE].
8. AI SHALL automatically configure an explicit Dead Letter Queue (DLQ) topic named with the standard suffix .dlq for every asynchronous message consumer engine structure created [cite: 1f0C-dDHFtRWaOXnMm6k1vsManJYXiUkweH2H05dlLZE].
9. AI SHALL NOT bypass the Debezium CDC Engine to construct dynamic custom application pollers that read the relational database state logs for event generation purposes [cite: 1f0C-dDHFtRWaOXnMm6k1vsManJYXiUkweH2H05dlLZE].
10. AI SHALL automatically inject OpenTelemetry W3C Trace Context parameters (traceparent) inside both gRPC metadata payloads and Kafka record metadata envelopes [cite: 1f0C-dDHFtRWaOXnMm6k1vsManJYXiUkweH2H05dlLZE].
11. AI SHALL establish an explicit BACKWARD_COMPATIBLE schema evolution policy rule inside the central Schema Registry configuration for all operational messaging contracts [cite: 1f0C-dDHFtRWaOXnMm6k1vsManJYXiUkweH2H05dlLZE].
12. AI SHALL limit the maximum execution time window parameter for any internal synchronous gRPC network call block to a strict maximum budget threshold of 3000 milliseconds [cite: 1f0C-dDHFtRWaOXnMm6k1vsManJYXiUkweH2H05dlLZE].
13. AI SHALL fail the build pipeline integration validation stage instantly if any modified Protobuf schema definition breaks reverse compatibility rules designed for historical clients [cite: 1f0C-dDHFtRWaOXnMm6k1vsManJYXiUkweH2H05dlLZE].
14. AI SHALL construct an independent idempotency inbox validation guard log table verification check immediately at the entry point logic of every message consumer worker structure [cite: 1f0C-dDHFtRWaOXnMm6k1vsManJYXiUkweH2H05dlLZE].
15. AI SHALL NOT store raw private credentials or unencrypted cryptographic key references inside the KONG API Gateway declarative manifest code repositories [cite: 1f0C-dDHFtRWaOXnMm6k1vsManJYXiUkweH2H05dlLZE].
16. AI SHALL NOT publish mutable payloads to Apache Kafka topics; all integration messages MUST represent point-in-time immutable state occurrences.
17. AI SHALL NOT embed entity structural snapshots larger than the hard configuration limit threshold of 1 MB inside any messaging event contract envelope.
18. AI SHALL NOT execute synchronous blocking RPC network requests that cut directly across separate bounded context boundaries; cross-context communication MUST favor async streaming.
19. AI SHALL NOT orchestrate pseudo request-response synchronous communication wrappers or block loops built on top of the Apache Kafka streaming architecture.
20. AI SHALL NOT expose internal microservice system Protobuf message schema models directly to public external clients at the KONG Edge Gateway layer.
21. AI SHALL NOT deploy any active message producer or consumer component that completely bypasses centralized Schema Registry automated verification steps.
22. AI SHALL NOT disable idempotency filters or tracking mechanisms inside write transactional loops designed for any asynchronous projection building subscriber process.
23. AI SHALL automatically route event payloads to the dynamic secondary partitioning topology format whenever a single tenant instance breaks the extreme traffic threshold budget.
24. AI SHALL configure all Kafka Consumer Group deployments to leverage the explicit Read_Committed isolation level standard to block raw uncommitted transaction leakage.
25. AI SHALL always attach an explicit, execution-ready shell command migration routine script for topic allocation schemas whenever deploying structural system configuration changes.

20. CROSS REFERENCES (THAM CHIẾO CHÉO KIẾN TRÚC)
Tham chiếu quy định về cấu trúc phân vùng vật lý Sổ cái tại [LEVEL D3] Persistence Platform Mapping Spec V2.0 phân mục 7.
Tham chiếu hợp đồng xử lý Command Handler thô tại [LEVEL D1] Backend Platform Mapping Spec V2.0 phân mục 6.
[KẾT THÚC TÀI LIỆU LEVEL D4: INTEGRATION PLATFORM MAPPING SPECIFICATION - OFFICIAL FROZEN FINAL VERSION V2.0 - CANONICAL INTEGRATION CONTRACT APPROVED]