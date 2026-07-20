LEVEL D: PLATFORM MAPPING SPECIFICATIONS
[LEVEL D3] PERSISTENCE PLATFORM MAPPING SPECIFICATION (OFFICIAL FROZEN BASELINE V2.0)
Trạng thái: Frozen Baseline Approved | Phiên bản: V2.0 (Canonical Enterprise Persistence Engineering Handbook)
Hệ thống: Nền tảng Quản lý Dòng họ Số (Clan Management Platform)
Cấu trúc thực thi: Absolute Production-Grade Polyglot Persistence Contract (Zero Ambiguity)
1. PURPOSE & SCOPE (MỤC ĐÍCH & PHẠM VI)
Tài liệu này là Hiến pháp Kỹ thuật Dữ liệu (Persistence Engineering Constitution) tối cao dành cho Kỹ sư Dữ liệu (Data Engineers), Kỹ sư Backend, và các Trí tuệ Nhân tạo lập trình (AI Coding Agents) của dự án Clan Management Platform. Đoạn tuyệt hoàn toàn với tính chất mô tả kiến trúc chung chung của phiên bản trước, bản V2.0 đóng vai trò là một Sổ tay Kỹ thuật Sản xuất (Production Engineering Handbook) toàn vẹn, loại bỏ 100% mọi quyết định tự phát của AI hay con người bằng cách khóa cứng các ma trận ánh xạ đối tượng, biên giao dịch, phân định chủ quyền dữ liệu, hạ tầng đồng bộ, và quy tắc tiến hóa cơ sở dữ liệu không gián đoạn (Zero-Downtime Migration).
2. TECHNOLOGY DECISIONS & MATRIX
Hệ thống Persistence đa lõi (Polyglot Persistence) đóng băng cứng các phân tầng công nghệ đích vật lý vật lý cấp doanh nghiệp:
Core Relational Ledger & Outbox Store: PostgreSQL (v16+) chịu trách nhiệm thực thi ACID nghiêm ngặt cho hệ thống đa sổ cái độc lập.
Lineage Graph Engine: Neo4j Enterprise Cluster (v5+) đóng vai trò duy trì đồ thị cấu trúc phả hệ đa chi phái không chu trình.
Distributed Cache & Idempotency Store: Redis Cluster (v7+) đảm nhận lưu trữ Session context, token chống trùng lặp và cache Projections.
Immutable Object Storage: AWS S3 / MinIO WORM Storage lưu trữ tư liệu cổ, sắc phong, hình ảnh dòng họ với chính sách bảo toàn vĩnh cửu.
Hybrid Search & Vector Engine: OpenSearch Cluster (v2.11+) thực thi lập chỉ mục phẳng và tìm kiếm ngữ nghĩa di sản k-NN Vector Search.
3. PERSISTENCE STACK OVERVIEW (TỔNG QUAN TẦNG LƯU TRỮ VẬT LÝ)
PostgreSQL (Prisma Core - Only SQL) + Neo4j (Cypher Engine) + Redis (Transient Data) + OpenSearch (Disposable Index) + AWS S3 (WORM Storage)
4. PERSISTENCE DOCTRINES (LINH HỒN KIẾN TRÚC DỮ LIỆU)
Single Source of Truth (SSOT) Constraint: Chỉ có PostgreSQL và Neo4j nắm giữ bản quyền dữ liệu gốc (Write Models). Toàn bộ dữ liệu tại OpenSearch và Redis đều là phái sinh (Read Projections), có thể bị hủy bỏ và tái lập bất kỳ lúc nào từ Outbox Stream.
Append-Only Enforcement: Nghiêm cấm cấp phát quyền thực thi lệnh SQL DELETE hoặc UPDATE cho tài khoản ứng dụng trên các bảng Sổ cái và Nhật ký an ninh. Sai sót nghiệp vụ bắt buộc phải xử lý qua bút toán điều chỉnh ở tầng Application.
Multi-Tenant Strict Partitioning: Việc cô lập dữ liệu giữa các dòng họ (Clan Instances) phải được bảo đảm ở mức đĩa cứng thông qua cơ chế phân vùng vật lý sử dụng trường tenant_id.
5. PERSISTENCE MAPPING MATRIX (MA TRẬN ÁNH XẠ ĐỐI TƯỢNG PIM → PSM)
Định hướng tuyệt đối cho AI sinh mã lưu trữ, triệt tiêu nguy cơ tự quyết:
Domain Aggregate
PostgreSQL (Relational)
Neo4j (Graph Node/Edge)
Redis (Transient/Cache)
OpenSearch (Read Model)
Object Storage (S3)
 
Member
members table thô
(:Member) node
member_cache:id
member_summary_idx
/avatars/* thô
Clan
clans table thô
(:Clan) node
clan_cache:id
clan_profile_idx
None
Branch
branches table thô
-[:BELONGS_TO]-> edge
None
None
None
Ritual
rituals table thô
None
None
ritual_calendar_idx
None
Heritage
heritages table thô
None
None
heritage_vector_idx (k-NN)
/scans/original.pdf
User
users table thô
None
user_session:token (TTL)
None
None
6. DATA OWNERSHIP MATRIX (MA TRẬN CHỦ QUYỀN DỮ LIỆU)
Xác định rõ ràng nguồn gốc ghi dữ liệu canonical và các bản sao read-only của từng trường dữ liệu:
Data Field
Canonical Owner (Write Mode)
Read-Only Replica
Projection Layer
Cache Layer
 
Member.name
PostgreSQL (SSOT)
None
OpenSearch
Redis
Member.lineage_edges
Neo4j (SSOT)
None
OpenSearch (Flattened Path)
None
Ledger.balance
PostgreSQL (Append-Only)
None
None
Redis
User.session_status
Redis (Only Source)
None
None
None
7. REPOSITORY CONTRACTS
AI sinh mã lớp Data Access Layer bắt buộc phải tuân thủ việc phân tách Abstraction thành 4 tệp tin độc lập cho cùng một thực thể miền:
MemberRepository (PostgreSQL / Prisma Core): Phụ trách độc quyền các thao tác CRUD dữ liệu thô, quan hệ bảng phẳng, và thực thi ACID Giao dịch. Không được gọi Graph, không gọi OpenSearch.
MemberGraphRepository (Neo4j Cypher): Phụ trách độc quyền thiết lập quan hệ phả hệ trực hệ, tìm kiếm tổ tiên bàng hệ, tính toán khoảng cách thế hệ bằng Cypher.
MemberProjectionRepository (OpenSearch): Phụ trách độc quyền việc truy vấn tìm kiếm văn bản đầy đủ (Full-text search), lọc kết quả phân trang phức tạp, và tìm kiếm vector k-NN.
MemberCacheRepository (Redis): Phụ trách độc quyền việc nạp, hủy bộ nhớ đệm (Cache eviction) với cơ chế TTL tự động cho các màn hình UI tốc độ cao.
8. SYNCHRONIZATION CONTRACTS (MÁY TRẠNG THÁI ĐỒNG BỘ DỮ LIỆU)
Mọi biến động dữ liệu từ PostgreSQL bắt buộc phải được đồng bộ hóa sang các vùng lưu trữ phái sinh thông qua Hàng đợi Outbox, điều khiển bởi máy trạng thái tuần tự sau:
[CREATED] → (Prisma Unit of Work) → [PERSISTED] → [OUTBOX_READY] → (CDC Relayer Daemon) → [DISPATCHED] → (Saga Worker) → [PROJECTED_NEO4J] → [INDEXED_OPENSEARCH] → [CACHED_REDIS] → [COMPLETED]
9. QUERY ROUTING DOCTRINE (HỌC THUYẾT ĐỊNH TUYẾN TRUY VẤN)
Quy chuẩn bắt buộc ngăn chặn hành vi AI gọi sai Cơ sở dữ liệu vật lý khi thực thi các Use Case:
Search Member by Identity ID: Tuyến đường → PostgreSQL (Đảm bảo tính chính xác tuyệt đối ngay lập tức).
Search Member by Complex Name / Nickname: Tuyến đường → OpenSearch (Full-Text Search Engine).
Generate 10-Generation Genealogy Tree Diagram: Tuyến đường → Neo4j Enterprise Cluster (Graph Traverse).
Validate Active User Token / Idempotency Rule: Tuyến đường → Redis Cluster (Sub-millisecond Latency Check).
Query Smart Heritage Recommendations (AI Proposals): Tuyến đường → OpenSearch k-NN Vector Space.
10. TRANSACTION BOUNDARY DOCTRINE (RANH GIỚI GIAO DỊCH VẬT LÝ)
Business Transaction Constraints: Mọi ranh giới giao dịch ACID bắt buộc chỉ được phép mở rộng duy nhất trên phạm vi PostgreSQL Core Data Storage. Không được mở rộng distributed transaction (XA/2PC) lên Neo4j hay OpenSearch.
Eventual Consistency Budget: Toàn bộ dữ liệu phả hệ trên Neo4j và chỉ mục trên OpenSearch chấp nhận độ trễ nhất quán muộn (Eventual Consistency) với SLA tối đa là < 500ms tính từ thời điểm PostgreSQL commit thành công.
Redis Non-Transactional Law: Lớp Redis Cluster tuyệt đối độc lập, nằm ngoài mọi biên cô lập giao dịch, vận hành theo cơ chế At-The-Moment.
11. INDEX DOCTRINE (GIAO ƯỚC THIẾT LẬP CHỈ MỤC SẢN XUẤT)
AI và kỹ sư dữ liệu bắt buộc áp dụng chính xác loại hình index theo tính chất truy vấn trường dữ liệu:
Primary / Unique Keys (id, UUID): Sử dụng B-Tree Index tiêu chuẩn.
Asynchronous Status Flags (is_dispatched, status): Bắt buộc áp dụng Partial Index (e.g., WHERE is_dispatched = FALSE).
Audit Log Timestamp Range Queries (created_at): Áp dụng BRIN Index (Block Range Index) để giảm thiểu 95% kích thước bộ nhớ chỉ mục trên các bảng dữ liệu cực lớn.
Dynamic JSONB Payloads Search: Sử dụng GIN Index (Generalized Inverted Index) với toán tử jsonb_path_ops.
12. SCHEMA & MIGRATION DOCTRINE (TIẾN HÓA SƠ ĐỒ KHÔNG TREO APPS)
12.1 Schema Evolution Rules
Database Alteration Command
Production Rule Status
Enforcement Implementation Strategy
 
ADD COLUMN
ALLOWED
Bắt buộc phải gán giá trị DEFAULT hoặc chấp nhận thuộc tính NULL. Không được thêm cột NOT NULL không có default.
DROP COLUMN / DROP TABLE
FORBIDDEN
Nghiêm cấm tuyệt đối trên môi trường Production. Cột cũ phải được đánh dấu không dùng ở lớp ứng dụng (Deprecation Stage).
RENAME COLUMN / TABLE
EXPAND & MIGRATE
Tạo cột mới → Chạy code song song ghi vào cả 2 cột → Chạy script backfill dữ liệu cũ → Xóa code đọc cột cũ.
12.2 Zero-Downtime Migration Pattern (Expand → Backfill → Switch → Cleanup)
Mọi tập lệnh thay đổi cấu trúc dữ liệu làm thay đổi kiểu dữ liệu (Type Change) bắt buộc phải tuân thủ quy trình 4 giai đoạn độc lập qua CI/CD: 1. Giai đoạn Expand (Thêm trường dữ liệu mới với kiểu dữ liệu mới); 2. Giai đoạn Backfill (Chạy background worker đồng bộ dữ liệu cũ sang định dạng mới); 3. Giai đoạn Switch (Chuyển đổi toàn bộ mã nguồn đọc ghi ứng dụng sang trường mới); 4. Giai đoạn Cleanup (Xóa bỏ logic cũ sau 2 phiên bản ổn định).
13. STORAGE FOLDER LAYOUT STANDARD (SƠ ĐỒ THƯ MỤC CẤU TRÚC HẠ TẦNG)
Khóa cứng sơ đồ phân vùng lưu trữ cho toàn dự án:
database/├── postgresql/│   ├── schema/                           # Khai báo file thực thể thô (Prisma Schema Baseline)│   ├── migrations/                       # Chứa file SQL Migration chạy sống theo thứ tự thời gian│   ├── functions/                        # Store Procedures tính toán mã băm SHA256 liên xích│   ├── views/                            # Khai báo các view phân tích dữ liệu phẳng phục vụ quản trị│   ├── extensions/                       # Script nạp các thành phần mở rộng (pg_partman, pgcrypto)│   └── seed/                             # Master Data phục vụ khởi tạo hệ thống ban đầu│       ├── master_data/                  # Danh mục hành chính, quốc gia, tôn giáo ổn định│       ├── system_roles/                 # Khởi tạo ma trận phân quyền tối cao│       └── clan_templates/               # Bộ mẫu hiến chương tộc sự mặc định cho clan mới├── neo4j/│   ├── constraints/                      # Script Cypher khóa độc nhất (Unique constraints)│   ├── indexes/                          # Cấu hình Full-text index cho các Node thực thể phả hệ│   └── procedures/                       # Mã nguồn Java APOC custom hoặc Cypher trigger chặn chu trình└── opensearch/    ├── templates/                        # Index Templates cấu hình phân mảnh và bản sao vật lý    └── pipelines/                        # Ingest Pipelines tiền xử lý chuẩn hóa dữ liệu trước khi index
14. IMPLEMENTATION CONTRACTS (GIAO ƯỚC MÃ NGUỒN VẬT LÝ)
Mọi lệnh ghi xuống Sổ cái PostgreSQL bắt buộc phải chạy qua cơ chế tính băm chuỗi khối liên kết nội bộ mã hóa an toàn, không phụ thuộc Prisma Lifecycle Hooks:
CREATE OR REPLACE FUNCTION generate_ledger_entry_hash()RETURNS TRIGGER AS $$DECLARE    v_prev_hash VARCHAR(64);BEGIN    -- 1. Lấy mã băm của bản ghi sổ cái liền trước thuộc cùng một Tenant dòng họ    SELECT current_entry_hash INTO v_prev_hash    FROM business_ledger    WHERE tenant_id = NEW.tenant_id AND ledger_type = NEW.ledger_type    ORDER BY recorded_at DESC, ledger_id DESC    LIMIT 1;    IF v_prev_hash IS NULL THEN        NEW.previous_entry_hash := '0000000000000000000000000000000000000000000000000000000000000000';    ELSE        NEW.previous_entry_hash := v_prev_hash;    END IF;    -- 2. Thực thi thuật toán băm SHA256 kết nối toàn vẹn dữ liệu (Canonical Serialization Cryptography)    NEW.current_entry_hash := encode(digest(        coalesce(NEW.ledger_id::text, '') ||         coalesce(NEW.ledger_type, '') ||         coalesce(NEW.tenant_id::text, '') ||         coalesce(NEW.payload::text, '') ||         coalesce(NEW.previous_entry_hash, ''),     'sha256'), 'hex');    RETURN NEW;END;$$ LANGUAGE plpgsql;CREATE TRIGGER trg_business_ledger_hash_chainBEFORE INSERT ON business_ledgerFOR EACH ROW EXECUTE FUNCTION generate_ledger_entry_hash();
15. PERFORMANCE, BACKUP & LIFECYCLE BUDGETS
15.1 Ma trận Hạn ngạch Hiệu năng & Dung lượng đĩa cứng
Storage Type
IOPS & Latency Budget
Backup Priority
Data Lifecycle Contract
 
PostgreSQL
Latency < 5ms (Writes) | IOPS: 3000
HIGHEST (First Restore)
Never Delete Law cho Sổ cái và Nhật ký An ninh.
Neo4j Graph
Hop Traverse Latency < 15ms sâu 10 đời
HIGH (Second Restore)
Never Delete Law cho cấu trúc cây gia phả chính sử.
Redis Cache
Sub-millisecond Latency (< 1ms)
NONE (Never Backup)
Strict TTL Enforcement (Session context tự hủy).
OpenSearch
Query Latency < 50ms | k-NN < 100ms
REBUILDABLE (Disposable)
Rebuild Anytime. Có quyền thiết lập xoá tái lập chỉ mục phẳng.
AWS S3 Object
Time-to-first-byte < 200ms
INDEPENDENT WORM BACKUP
Retention Policy = 100 Years đóng băng vĩnh cửu.
16. OBSERVABILITY METRICS MAPPING (ÁNH XẠ ĐO LƯỜNG TẬP TRUNG)
Toàn bộ hạ tầng lưu trữ bắt buộc phải cấu hình OpenTelemetry Metrics Agent xuất bản mã nguồn số liệu về bộ thu thập tập trung đúng với định danh tham số:
postgres.query.duration: Giám sát phân phối thời gian thực thi câu lệnh SQL thô (Ngưỡng cảnh báo đỏ: > 200ms).
postgres.lock.wait: Đo lường tổng thời gian các phiên giao dịch chờ khóa tài nguyên đĩa cứng trên bảng Sổ cái tổng hợp.
redis.hit.rate: Giám sát tỷ lệ tìm thấy dữ liệu trong bộ nhớ đệm nhằm tối ưu hóa chiến lược Cache Eviction Strategy.
neo4j.cypher.duration: Đo lường thời gian xử lý các thuật toán duyệt đồ thị tìm kiếm huyết mạch tộc hệ đệ quy sâu.
opensearch.query.duration: Đo lường tốc độ tính toán khoảng cách cosine không gian vector của plugin k-NN search.
17. QA AUTOMATION & MUTATION TESTING GATES
Database Testcontainers Gate: Toàn bộ các câu lệnh SQL Migration và cấu hình Prisma Repositories bắt buộc phải được chạy kiểm thử tự động thực tế dựa trên Docker Testcontainers khởi chạy một instance PostgreSQL/Neo4j độc lập ngay trong RAM tại CI/CD Pipeline.
Data Mutation Injection Breach Test: Công cụ kiểm thử tự động thực hiện thao túng một dòng bản ghi trực tiếp trong DB PostgreSQL mà không thông qua cơ chế băm chuỗi liên xích, hệ thống thanh tra tự động kiểm toán bắt buộc phải phát hiện mã băm gãy đổ trong vòng 30 giây và tự động kích hoạt lệnh ngắt mạch hạ tầng (Circuit Breaker).
18. AI CODING & SCHEMA GENERATION CONSTRAINTS (15 MỆNH LỆNH TỐI CAO CHO AI)
Mọi Trí tuệ Nhân tạo lập trình (AI Coding Agent) khi tiếp cận, sửa đổi, sinh tập lệnh cấu trúc cho hệ thống Persistence BẮT BUỘC tuân thủ 15 mệnh lệnh tuyệt đối sau:

1. AI SHALL NOT generate any SQL migration file containing structural destructive commands like DROP TABLE or ALTER TABLE DROP COLUMN for production databases.
2. AI SHALL NOT bypass the tenant_id list partitioning configuration when creating core domain business transactional data storage structures.
3. AI SHALL enforce the strict SHA-256 hash-chaining verification parameters inside every write operation mapping script designed for the business_ledger partition.
4. AI SHALL automatically attach a targeted Partial Index on any asynchronous processing state flag where the boolean value matches the undispatched status configuration.
5. AI SHALL NOT use native relational database cascading mechanisms (ON DELETE CASCADE) for any entity registered under the core permanent lineage genealogy context.
6. AI SHALL NOT duplicate canonical domain data across separate databases; Write Models belong exclusively to their designated Canonical Owner.
7. AI SHALL NEVER query OpenSearch, Redis, or AWS S3 to perform mutation data verification logic within Write Transactions.
8. AI SHALL restrict Prisma Client usage exclusively to the PostgreSQL database context; Prisma SHALL NOT connect to Neo4j, Redis, or OpenSearch.
9. AI SHALL enforce strict feature isolation at the database migration level; no script shall mix Master Data seeds with operational transactional migrations.
10. AI SHALL automatically calculate validation checksums for every newly generated migration file and match it with the deployment lock mechanism.
11. AI SHALL always document an explicit, automated Rollback script alongside every forward migration script generated for PostgreSQL and Neo4j.
12. AI SHALL implement the zero-downtime Expand-and-Contract migration pattern whenever changing a database column's primitive data type.
13. AI SHALL automatically assign a strict Time-To-Live (TTL) parameter to every Redis cache insertion key command without exception.
14. AI SHALL inject OpenTelemetry Span Context trace IDs into every asynchronous log write payload dispatched to the outbox event storage.
15. AI SHALL fail the build pipeline immediately if any raw SQL query string contains dynamic string interpolation bypasses that expose the system to SQL Injection.

19. CROSS REFERENCES (THAM CHIẾO CHÉO KIẾN TRÚC)
Tham chiếu quy định về cấu trúc phong bì lỗi và API biên tại [LEVEL D2] Frontend Platform Mapping Spec V2.0 mục 9.1.
Tham chiếu quy định về bộ xử lý lệnh tổng quát tại [LEVEL D1] Backend Platform Mapping Spec V2.0 phân mục 6.
[KẾT THÚC TÀI LIỆU LEVEL D3: PERSISTENCE PLATFORM MAPPING SPECIFICATION - FROZEN BASELINE VERSION V2.0 - CANONICAL DESIGN APPROVED]