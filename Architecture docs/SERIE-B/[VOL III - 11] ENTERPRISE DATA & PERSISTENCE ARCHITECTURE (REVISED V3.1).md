VOLUME III: TECHNICAL ARCHITECTURE
[VOL III - 11] ENTERPRISE DATA & PERSISTENCE ARCHITECTURE (REVISED V3.1)
Trạng thái: Baseline Approved | Phiên bản: V3.1 (Integrated Cross-cutting Storage Doctrines)
Hệ thống: Nền tảng Quản lý Dòng họ Số (Clan Management Platform)
Cấu trúc thực thi: EGAL Absolute Canonical Physical Schema & Code Specification
1. PERSISTENCE ARCHITECTURE DOCTRINE
Trọng tâm của khung kiến trúc EGAL (Enterprise Generation Architecture Layer) là việc thiết lập một tầng chân lý bất biến về mặt lý thuyết lưu trữ, hoàn toàn độc lập với các biến động công nghệ vật lý ở hạ tầng cấp thấp.
Single Source of Truth (SSOT): Mỗi hạt nhân thông tin chỉ tồn tại duy nhất một thực thể gốc có quyền tối cao (Authority Domain Table). Mọi bản sao phục vụ tối ưu hóa truy vấn đều là thứ cấp (Projection Models) và phải chịu sự chi phối của cơ chế đồng bộ bất đồng bộ.
Immutable Storage Strategy: Toàn bộ biên sử liệu phả hệ, nhật ký an ninh, và biến động tài chính (Sổ cái) được đóng băng dưới dạng chỉ ghi tiếp (Append-only). Các thao tác can thiệp phá hủy dữ liệu vật lý (SQL DELETE, UPDATE) bị loại trừ hoàn toàn.
Multi-Tenant Strict Isolation: Không gian số của từng dòng họ (Clan Instance) được ngăn cách bằng tường biên logic/vật lý tuyệt đối từ tầng kết nối, tránh rò rỉ chéo dữ liệu cấu trúc phả hệ.
Consistency & Replication Doctrine: Strict Consistency áp đặt cho phân hệ Ledger và Security Identity. Eventual Consistency áp dụng cho Lineage và Communication Projections qua hàng đợi Outbox với Propagation SLA < 1500ms trên mô hình Primary-Replica phân tán vùng địa lý.
2. CANONICAL MULTI-STORAGE MAPPING
Quy chuẩn lựa chọn hạ tầng lưu trữ dựa trên bản chất cấu trúc dữ liệu miền nghiệp vụ (Domain Core Structure), triệt tiêu hoàn toàn sự cảm tính trong việc lựa chọn công nghệ:
Miền Nghiệp Vụ (Domain Context)
Aggregate Root Gốc (Vol II)
Mô Hình Lưu Trữ Vật Lý
Công Nghệ Chỉ Định (Enterprise Stack)
 
Lineage & Member
ClanInstance, Member, Branch
Graph Persistence Model
Neo4j Enterprise Cluster
Hệ thống Sổ cái Tổng hợp
ClanLedger, FinancialLedger
Relational Hash-Chained Ledger
PostgreSQL Cluster Partitioned
Vòng đời Truyền thông
OutboundMessage, MessageTemplate
Relational Log + Key-Value Store
PostgreSQL + Redis Cluster Layer
Trợ năng & Trải nghiệm (ACXD)
UserPreference, DelegateMapping
Key-Value & Relational Mapping
Redis Cache + PostgreSQL Tables
AI & Di sản Số
HeritageDigital, AIProposal
Object Storage & Hybrid Vector Search
MinIO / AWS S3 + OpenSearch k-NN Plugin

3. GRAPH PERSISTENCE ARCHITECTURE (MÔ HÌNH ĐỒ THỊ TRƯỜNG TỒN - NEO4J)
3.1 Node Labels & Schema Constraints
Label: Member (memberId: ULID [Unique], fullName: String, gender: Enum, generationOrder: Integer, profileStatus: Enum, isMinorProtected: Boolean).
Label: Branch (branchId: ULID [Unique], branchName: String, hierarchyPath: String).
3.2 Database Engine Graph Cycle Block Trigger
Để thực thi tuyệt đối ràng buộc toán học Đồ thị hướng không chu trình (DAG) của miền phả hệ, ngăn chặn việc sinh chu trình đệ quy ngược (con làm cha tổ tiên), hệ thống cấu hình một Transaction Event Handler (DB Trigger) chạy trực tiếp trong nhân Neo4j Cluster:
// Mã Cypher Schema thiết lập ràng buộc Neo4j Enterprise Chặn Chu Trình Vật LýCREATE CONSTRAINT member_id_unique IF NOT EXISTSFOR (m:Member) REQUIRE m.memberId IS UNIQUE;CREATE CONSTRAINT branch_id_unique IF NOT EXISTSFOR (b:Branch) REQUIRE b.branchId IS UNIQUE;// Trigger logic kiểm tra đệ quy (Hiện thực qua APOC Validation ngầm trong Transaction)MATCH (child:Member {memberId: $childId}), (parent:Member {memberId: $parentId})WHERE EXISTS((child)-[:PARENT_OF*]->(parent))CALL apoc.util.validate(true, 'CRITICAL_LINEAGE_ERROR: Circular pedigree path detected! A child cannot be an ancestor.', [])RETURN child;
4. RELATIONAL PERSISTENCE SCHEMA & DDL SPECIFICATION (POSTGRESQL)
Dưới đây là mã DDL hoàn chỉnh cấp Production, tích hợp cơ chế phân vùng vật lý (Partitioning) và toàn vẹn chuỗi khối mập mờ.
-- 1. KHỞI TẠO CÁC ENUM NGHIỆP VỤ TẬP TRUNGCREATE TYPE ledger_category AS ENUM ('FINANCIAL', 'GOVERNANCE', 'RITUAL', 'AUDIT');CREATE TYPE message_state AS ENUM ('DRAFT', 'APPROVED', 'SCHEDULED', 'SENDING', 'DELIVERED', 'READ', 'FAILED');CREATE TYPE channel_type AS ENUM ('SMS', 'PUSH', 'EMAIL', 'VOICE');CREATE TYPE font_size_option AS ENUM ('STANDARD', 'LARGE', 'EXTRA_LARGE');CREATE TYPE contrast_option AS ENUM ('NORMAL', 'HIGH_CONTRAST');-- 2. PHÂN HỆ SỔ CÁI NGHIỆP VỤ BẤT BIẾN (BUSINESS LEDGER - PARTITIONED)CREATE TABLE business_ledger (    ledger_id UUID DEFAULT gen_random_uuid(),    ledger_type ledger_category NOT NULL,    tenant_id UUID NOT NULL,    aggregate_type VARCHAR(100) NOT NULL,    aggregate_id VARCHAR(100) NOT NULL,    actor_id UUID NOT NULL,    correlation_id UUID NOT NULL,    payload JSONB NOT NULL,    previous_entry_hash VARCHAR(64) NOT NULL,    current_entry_hash VARCHAR(64) NOT NULL,    recorded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,    PRIMARY KEY (ledger_id, ledger_type)) PARTITION BY LIST (ledger_type);-- Khởi tạo các phân vùng vật lý tự động cho Sổ cáiCREATE TABLE business_ledger_financial PARTITION OF business_ledger FOR VALUES IN ('FINANCIAL');CREATE TABLE business_ledger_governance PARTITION OF business_ledger FOR VALUES IN ('GOVERNANCE');CREATE TABLE business_ledger_ritual PARTITION OF business_ledger FOR VALUES IN ('RITUAL');CREATE TABLE business_ledger_audit PARTITION OF business_ledger FOR VALUES IN ('AUDIT');CREATE INDEX idx_ledger_correlation ON business_ledger(correlation_id);CREATE INDEX idx_ledger_tenant_aggregate ON business_ledger(tenant_id, aggregate_type, aggregate_id);-- 3. PHÂN HỆ QUẢN TRỊ VÒNG ĐỜI TRUYỀN THÔNG (COMMUNICATION LEDGER)CREATE TABLE communication_ledger (    message_id UUID PRIMARY KEY,    tenant_id UUID NOT NULL,    deduplication_key VARCHAR(255) UNIQUE NOT NULL,    recipient_member_id UUID NOT NULL,    channel channel_type NOT NULL,    current_status message_state NOT NULL,    rendered_payload TEXT NOT NULL,    created_at TIMESTAMP WITH TIME ZONE NOT NULL,    dispatched_at TIMESTAMP WITH TIME ZONE);CREATE TABLE communication_delivery_logs (    log_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,    message_id UUID NOT NULL REFERENCES communication_ledger(message_id) ON DELETE CASCADE,    status_snapshot message_state NOT NULL,    channel_response_code VARCHAR(100),    occurred_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP);CREATE TABLE communication_receipts (    receipt_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,    message_id UUID NOT NULL REFERENCES communication_ledger(message_id) ON DELETE CASCADE,    reader_member_id UUID NOT NULL,    device_context VARCHAR(100) NOT NULL, -- Ví dụ: "MOBILE_ELDER_MODE"    acknowledged_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP);CREATE INDEX idx_comm_lookup ON communication_ledger(tenant_id, recipient_member_id, current_status);-- 4. PHÂN HỆ TRỢ NĂNG & TRẢI NGHIỆM THÍCH ỨNG (ACXDPERSISTENCE)CREATE TABLE user_accessibility_preferences (    member_id UUID PRIMARY KEY,    preferred_font_size font_size_option DEFAULT 'STANDARD' NOT NULL,    preferred_contrast contrast_option DEFAULT 'NORMAL' NOT NULL,    preferred_language VARCHAR(10) DEFAULT 'vi' NOT NULL,    preferred_input_mode VARCHAR(20) DEFAULT 'TOUCH' NOT NULL,    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP);CREATE TABLE delegate_mappings (    mapping_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,    elder_member_id UUID NOT NULL,    delegate_member_id UUID NOT NULL,    kinship_proof_reference VARCHAR(255) NOT NULL,    is_active BOOLEAN DEFAULT TRUE NOT NULL,    granted_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,    revoked_at TIMESTAMP WITH TIME ZONE,    CONSTRAINT uq_elder_delegate UNIQUE(elder_member_id, delegate_member_id));-- 5. LỚP HIỂN THỊ TINH GIẢN DI ĐỘNG (MOBILE-FIRST READ PROJECTIONS)CREATE TABLE member_summary_projections (    member_id UUID PRIMARY KEY,    tenant_id UUID NOT NULL,    full_name VARCHAR(255) NOT NULL,    generation_number INT NOT NULL,    branch_id UUID NOT NULL,    avatar_url VARCHAR(500),    last_synchronized_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP);CREATE INDEX idx_projection_mobile_lookup ON member_summary_projections (tenant_id, member_id);-- 6. HÀNG ĐỢI SỰ KIỆN NGUYÊN TỬ (OUTBOX EVENT LOG - TIME PARTITIONED)CREATE TABLE outbox_event_log (    event_id UUID DEFAULT gen_random_uuid(),    aggregate_type VARCHAR(100) NOT NULL,    aggregate_id VARCHAR(100) NOT NULL,    event_type VARCHAR(100) NOT NULL,    payload JSONB NOT NULL,    is_dispatched BOOLEAN DEFAULT FALSE NOT NULL,    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,    PRIMARY KEY (event_id, created_at)) PARTITION BY RANGE (created_at);-- Thiết lập Partial Index tăng tốc độ quét cho CDC Daemon RelayerCREATE INDEX idx_outbox_undispatched ON outbox_event_log (created_at) WHERE is_dispatched = FALSE;
5. CRYPTOGRAPHIC LEDGER AUDIT HASH-CHAIN (MÔ HÌNH XÍCH BĂM SỬ LIỆU VẬT LÝ)
Mỗi khi một dòng nghiệp vụ được ghi nhận vào business_ledger, Database Session Layer bắt buộc thực thi hàm băm liên chuỗi mật mã học trước khi commit transaction: current_entry_hash = SHA256(previous_entry_hash + current_row_payload_jsonb). Hội đồng dòng họ nắm giữ cặp khóa dùng để ký số đóng băng cấu trúc định kỳ mỗi 24 giờ thông qua HSM/KMS.
6. DATA LIFECYCLE & IMMUTABLE OBJECT STORAGE
Bucket clan-heritage-documents (Kho di sản vĩnh cửu): Bật Object Versioning và AWS S3 Bucket WORM Lock 100 năm (COMPLIANCE 100-year Retention Policy). Chặn đứng 100% lệnh ghi đè hoặc xóa thủ công từ lớp biên.
Bucket clan-financial-evidences (Chứng từ minh bạch): Bật Lifecycle Transition Policy. Lưu tại vùng lưu trữ nóng (Hot Storage) trong 12 tháng; hết chu kỳ, hệ thống tự động đẩy tệp xuống vùng Glacier Deep Archive để tối ưu chi phí. Thời hạn lưu kho pháp lý bắt buộc là 10 năm.
7. CROSS REFERENCES
Tham chiếu các ràng buộc kích thước Payload di động tại [VOL I - 03] Product Architecture Blueprint V2.1 và [VOL III - 10] Canonical Enterprise API Spec V5.1.
Ánh xạ thực thể logic của phả hệ và preferences người già tại [VOL II - 04] Lineage & Member Domain V2.1.
Ánh xạ thực thể logic thu chi tài chính tổng hợp tại [VOL II - 06] Financial & Governance Ledger Domain Spec V2.1.
[KẾT THÚC TÀI LIỆU VOL III - 11 V3.1 - BASELINE APPROVED - ABSOLUTE PERSISTENCE BASELINE LOCKED]