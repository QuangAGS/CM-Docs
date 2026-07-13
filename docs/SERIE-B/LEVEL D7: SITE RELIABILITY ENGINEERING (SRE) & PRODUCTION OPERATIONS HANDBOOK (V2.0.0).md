EGAL CLAN MANAGEMENT PLATFORM (NỀN TẢNG QUẢN LÝ DÒNG HỌ SỐ)
LEVEL D7: SITE RELIABILITY ENGINEERING (SRE) & PRODUCTION OPERATIONS HANDBOOK
Mã Tài Liệu: EGAL-ARCH-LEVEL-D7-OPERATIONS-HANDBOOK-V2
Phiên Bản: V2.0.0-RELEASE (Enterprise Production Baseline)
Trạng Thái: APPROVED & ENGINE LOCK ACTIVATED
Phương Pháp Luận: Google SRE / ISO 42010 / Chaos Engineering Enterprise Standards
CHƯƠNG 1: PURPOSE, SCOPE & SERVICE DEPENDENCY TOPOLOGY
Văn bản LEVEL D7 đóng vai trò là Sổ tay Vận hành Sản xuất (Production Operations Handbook) cấp Enterprise của Nền tảng Dòng họ số EGAL. Rời bỏ hoàn toàn các mô tả kiến trúc thuần lý thuyết, tài liệu này thiết lập các khế ước kỹ thuật và quy trình thực chiến tối cao cho đội ngũ SRE/DevOps và hệ thống AI Autonomous SRE Agent. LEVEL D7 giải quyết bài toán: "Khi hệ thống trên môi trường Production hỏng hóc hoặc suy giảm hiệu năng, các Agent và kỹ sư phải xử lý thế nào để tự chữa lành, bảo vệ tính toàn vẹn tuyệt đối của chuỗi khối Ledger và đồ thị phả hệ Elder-First?"
1.1 Sơ Đồ Chuỗi Phụ Thuộc Dịch Vụ (Service Dependency Graph)
Mọi quy trình chẩn đoán lỗi (Troubleshooting) và phản ứng sự cố (Incident Response) bắt buộc phải đối chiếu theo đồ thị phụ thuộc bất biến dưới đây để định vị nhanh điểm nghẽn:
[Mobile Client / Web Frontend]              │              ▼    [KONG API Gateway] ──> [Keycloak (OIDC Auth & Token Validation)]              │              ▼    [Command Bus / NestJS App Core] ──> [PostgreSQL (Patroni Primary Core)]                                                    │                                                    ▼                                      [Transaction Outbox Table]                                                    │                                                    ▼ (Debezium CDC Connector)                                           [Apache Kafka KRaft]                                                    │                                                    ▼ (Projection Worker / Consumer)                                      [Neo4j Graph & OpenSearch Engines]
CHƯƠNG 2: PRODUCTION RUNBOOKS (QUY TRÌNH ỨNG CỨU SỰ CỐ CHUẨN INCIDENT LIFECYCLE)
Mọi mã lệnh ứng cứu sự cố bắt buộc phân rã theo 7 pha chuẩn hóa để AI SRE Agent có thể tự động quét trạng thái, thực thi, kiểm tra và chuyển cấp cảnh báo an toàn.
2.1 Runbook P1-001: Khôi phục Kết nối CDC Debezium và Xử lý Tràn Hàng Đợi (Consumer Lag)
Detection: Prometheus kích hoạt cảnh báo khi chỉ số kafka_consumergroup_lag{group="connect-egal-postgresql-outbox-connector"} > 50000 duy trì trong 5 phút liên tiếp.
Impact: Sự kiện Ledger ghi nhận thành công ở PostgreSQL nhưng không thể đồng bộ sang lớp Tìm kiếm (OpenSearch) và Đồ thị (Neo4j). Người dùng gặp hiện tượng dữ liệu cập nhật bị trễ hoàn toàn.
Immediate Mitigation:# 1. Kiểm tra trạng thái Connector qua Kafka Connect REST APIcurl -s http://kafka-connect-api.service-infra.svc.cluster.local:8083/connectors/egal-postgresql-outbox-connector/status# 2. Chụp và lưu trữ snapshot của offset hiện tại vào Vault để làm căn cứ phục hồi nếu xảy ra lỗikafka-consumer-groups.sh --bootstrap-server kafka-cluster-kafka-bootstrap.service-infra.svc.cluster.local:9092 \  --group connect-egal-postgresql-outbox-connector --describe --state > /tmp/debezium-offset-snapshot-$(date +%s).txt# 3. Tự động gọi lệnh restart Task lỗicurl -X POST http://kafka-connect-api.service-infra.svc.cluster.local:8083/connectors/egal-postgresql-outbox-connector/tasks/0/restart# 4. CHỈ khi xác nhận cơ chế Inbox/Idempotency hoạt động đúng và được phê duyệt, mới tiến hành reset dịch chuyển offset thủ công/phạm vi nhỏ# TUYỆT ĐỐI không dùng --to-earliest mặc định đối với Ledger để tránh trùng lặp chuỗi khối (Event Playback Storm)        
Verification: Đảm bảo chỉ số lag giảm liên tục: sum(kafka_consumergroup_lag{group="connect-egal-postgresql-outbox-connector"}) < 100, Connector chuyển sang trạng thái RUNNING và không phát sinh lỗi trùng lặp sự kiện (Duplicate Events).
Rollback: Nếu lệnh khôi phục gây crash loop, hoàn tác cấu hình offset về bản ghi snapshot vừa chụp lưu tại Vault.
Escalation: Nếu sau 15 phút thực thi, chỉ số lag không giảm, tự động nâng cấp sự cố lên mức P0 War Room, thông báo trực tiếp cho Platform Lead.
Closure: Đóng incident sau khi hệ thống ổn định 30 phút liên tục, tự động xuất log chuyển pha Postmortem.
2.2 Runbook P1-002: Xử lý Hồi phục Đồ thị Phả Hệ Neo4j Khi Mất Đồng Bộ Node (Split-Brain)
Detection: Prometheus metric neo4j_cluster_core_is_leader == 0 trên toàn cụm (Không bầu chọn được Leader).
Impact: Toàn bộ các thao tác đọc/ghi vào sơ đồ cây phả hệ, phân tách huyết thống dòng tộc bị phong tồn toàn diện.
Immediate Mitigation:# 1. Áp dụng NetworkPolicy cô lập ngay Node lỗi để ngăn chặn Dirty Writes ghi nhiễm dữ liệu vào cụmcat <<EOF | kubectl apply -f -apiVersion: networking.k8s.io/v1kind: NetworkPolicymetadata:  name: isolate-neo4j-failed-node  namespace: service-dataspec:  podSelector:    matchLabels:      statefulset.kubernetes.io/pod-name: neo4j-core-2  policyTypes: [Ingress, Egress]  ingress: []  egress: []EOF# 2. Thực hiện ép buộc thăng cấp và giải phóng trạng thái khóa cụm Raft trên các Node còn lạikubectl exec -it neo4j-core-0 -n service-data -- cypher-shell -u neo4j -p ${NEO4J_PASSWORD} "CALL dbms.cluster.forceReconfiguration(['neo4j-core-0.neo4j.svc:5000', 'neo4j-core-1.neo4j.svc:5000']);"        
Verification: Xác nhận trạng thái cụm trả về neo4j_cluster_core_is_leader == 1 tại node lành mạnh.
Rollback: Gỡ bỏ NetworkPolicy khẩn cấp nếu phát hiện các node lành mạnh bị cô lập ngoài ý muốn.
Escalation: Nếu việc thăng cấp cưỡng bức thất bại quá 5 phút, chuyển cấp sự cố đến Database Lead để can thiệp thủ công.
Closure: Hủy bỏ chính sách cô lập mạng sau khi cụm đã đồng bộ đầy đủ các phân đoạn dữ liệu.
CHƯƠNG 3: CHAOS ENGINEERING & GAMEDAY FRAMEWORK
Hệ thống bắt buộc phải tự diễn tập lỗi định kỳ để chứng minh năng lực tự phục hồi mà không ảnh hưởng tới trải nghiệm người dùng lớn tuổi.
3.1 Khung Diễn Tập Mở Rộng Sử Dụng LitmusChaos
Bên cạnh các kịch bản về độ trễ mạng và sập node cơ sở dữ liệu, các kịch bản kiểm thử thảm họa sau đây phải được kích hoạt tự động:
Kafka Broker Loss & ISR Shrink Chaos: Giết ngẫu nhiên 1 trong 3 Kafka Brokers khi đang xử lý hàng đợi giao dịch dòng họ, ép buộc cụm thực hiện bầu chọn Leader Partition mới mà không làm giảm tập hợp In-Sync Replicas (ISR) về mức nguy hiểm.
Redis Unavailable & Cache Miss Storm: Ngắt kết nối cụm Redis Cache để ép toàn bộ luồng đọc quay trở lại PostgreSQL/Neo4j, chứng minh hệ thống có cơ chế Circuit Breaker bảo vệ cơ sở dữ liệu lõi khỏi tình trạng sập do quá tải (Thùng sập domino).
HashiCorp Vault & KMS Timeout Chaos: Giả lập lỗi timeout giải mã Token bí mật, chứng minh hệ thống có cơ chế local memory fallback an toàn để duy trì dịch vụ đọc dữ liệu gia phả tạm thời.
Keycloak / OIDC Unavailable Experiment: Ngắt kết nối phân hệ xác thực, kiểm tra tính đúng đắn của cơ chế offline token validation tại Kong API Gateway giúp người dùng cũ duy trì phiên đăng nhập mà không bị đẩy văng khỏi ứng dụng.
Clock Skew Chaos Experiment: Bơm lỗi lệch giờ NTP (NTP Clock Drift > 5 giây) giữa các Worker Nodes nhằm đảm bảo các thuật toán mã hóa chữ ký Token JWT và logic sắp xếp thứ tự log giao dịch của Kafka không bị gãy đổ do sai lệch thời gian vật lý.
3.2 Quarterly GameDay: Kịch Bản Mô Phỏng Thảm Họa Thực Tế (Business Simulation)
Mỗi quý một lần, môi trường Staging phải tự động giả lập sự kiện: Một Trưởng tộc/Người có tầm ảnh hưởng lớn trong dòng họ số qua đời đột ngột. Hệ thống sẽ tự động kích hoạt luồng tải cực đại mô phỏng:
100,000 Người Dùng Truy Cập Đồng Thời → Đọc và cập nhật Đồ thị phả hệ số (Graph Engine) → Tạo lập lệnh phúng điếu, ghi sổ kế toán dòng tộc tập trung (Ledger Engine) → Kích hoạt luồng thông báo đẩy thời gian thực (Notification Burst) → Quét tìm kiếm thông tin trên lớp OpenSearch.
Hệ thống SRE đạt chuẩn chỉ khi giữ vững chỉ số SLO và không tiêu hao quá 10% Error Budget quý trong suốt thời gian diễn ra GameDay kéo dài 2 tiếng.
CHƯƠNG 4: INCIDENT MANAGEMENT (SEVERITY MATRIX & INCIDENT COMMAND SYSTEM)
4.1 Ma Trận Phân Cấp Sự Cố (Severity Matrix)

Severity
Ý Nghĩa Vận Hành
Ví Dụ Thực Tế
Mục Tiêu RTO
Cơ Chế Khẩn Cấp
 
P0
Platform Downtime toàn bộ cụm cluster, Ingress gãy hoàn toàn.
Sập KONG Gateway, Keycloak OIDC sập toàn diện.
≤ 5 Phút
Tự động kích hoạt War Room, thông báo khẩn cấp tới CEO và CTO.
P1
Dịch vụ cốt lõi không khả dụng (Core Business Unavailable).
Sai lệch chuỗi khối Ledger, Mất Leader cụm Neo4j, CDC lỗi.
≤ 15 Phút
Kích hoạt Runbooks tự động, báo động trực thì cho Incident Commander.
P2
Tính năng phụ thuộc bị suy giảm (Domain Degraded).
Mất cụm OpenSearch khiến tính năng tìm kiếm lỗi, Command vẫn chạy.
≤ 2 Giờ
Chuyển giao cho Platform/Application Lead thông qua Feature Flag.
P3
Lỗi nhỏ không ảnh hưởng trải nghiệm trực tiếp (Minor Degradation).
Grafana Dashboard hiển thị chậm, lỗi tải ảnh avatar cổ vật.
≤ 24 Giờ
Ghi vết hệ thống, lập lịch xử lý ưu tiên trong phiên làm việc kế tiếp.
4.2 Hệ Thống Điều Hành Sự Cố (Incident Command System - ICS)
Khi sự cố P0/P1 kích hoạt, quyền điều hành vận hành tối cao thuộc về các vai trò cấu trúc rõ ràng sau:
Incident Commander (IC): Người giữ quyền điều hành cao nhất trong War Room. IC giữ toàn quyền đưa ra quyết định tối cao: cho phép Rollback hệ thống, kích hoạt nút ngắt khẩn cấp (Kill Switch), thăng cấp cơ sở dữ liệu (Promote Replica) hoặc đóng băng toàn bộ luồng phát hành code mới.
Communication Lead: Chịu trách nhiệm cập nhật trạng thái hệ thống lên trang Status Page và truyền thông thông tin chuẩn xác cho khách hàng/hội đồng dòng tộc.
Database Lead: Kỹ sư/Agent chịu trách nhiệm duy nhất đối với sự an toàn của Patroni PostgreSQL, Neo4j và Redis Cluster.
Platform Lead: Chịu trách nhiệm xử lý các vấn đề liên quan đến mạng, cụm K8s Cluster, KONG Gateway và định tuyến lưu lượng Cloud.
Application Lead: Điều phối việc cô lập mã nguồn ứng dụng lỗi, bật tắt Feature Flags hoặc chuẩn bị gói vá lỗi Hotfix khẩn cấp.
CHƯƠNG 5: ERROR BUDGET & SLO GOVERNANCE (QUẢN TRỊ NGÂN SÁCH LỖI)
5.1 Ràng Buộc Ngân Sách Lỗi Hệ Thống
Availability SLO: Hệ thống Production cam kết đạt mức độ sẵn sàng tối thiểu 99.95% tính theo tháng.
Monthly Error Budget: Tương đương hệ thống chỉ được phép gián đoạn tối đa 21.6 phút trong vòng 30 ngày cuốn chiếu.
5.2 Quy Chế Điều Hành Ngân Sách Lỗi (Error Budget Governance Policy)
Hệ thống tự động hóa giám sát tiêu hao ngân sách lỗi và áp dụng các chế tài cưỡng bức vô điều kiện sau:
Tiêu Hao > 50% Ngân Sách Lỗi: Hệ thống tự động kích hoạt trạng thái hạn chế. Đóng băng tất cả các tính năng mới có mức độ rủi ro trung bình và cao trên ArgoCD (Freeze Feature Releases).
Tiêu Hao > 80% Ngân Sách Lỗi: Toàn bộ đội ngũ kỹ sư ứng dụng và AI Coding Agent bắt buộc phải chuyển sang phiên làm việc tập trung 100% vào nhiệm vụ tối ưu độ ổn định hệ thống (Reliability Sprint / Overhaul).
Tiêu Hao > 100% Ngân Sách Lỗi: Tự động đình chỉ quyền tự động deploy của AI Agent, bắt buộc tổ chức phiên họp kiểm thảo sự cố (Incident Review) có chữ ký phê duyệt của Giám đốc Công nghệ (CTO) mới được mở khóa hệ thống.
CHƯƠNG 6: CAPACITY & AUTO SCALING OPERATIONS

Component Trigger
Điều Kiện Kích Hoạt Chỉ Số (Metrics)
Hành Động Khẩn Cấp Của SRE / AI DevOps
 
Stateless Core App
CPU Utilization > 80% hoặc Memory > 85% trong 2 phút.
HPA tự động mở rộng số lượng Pods lên tối đa 15 bản sao (Scale Out).
Kafka Consumer Group
kafka_consumergroup_lag > 5000 thông điệp duy trì quá 3 chu kỳ quét.
Tự động nâng số lượng bản sao Consumer Pods bằng với số lượng Partitions tối đa của Topic.
Redis Memory Storage
Redis Cache Hit Ratio < 90% do hiện tượng tràn Eviction bộ nhớ.
Tự động mở rộng dung lượng RAM cấp cho Redis Cluster Node thêm 25% qua Terraform/Operator.
Neo4j Graph Engine
neo4j_pagecache_hit_ratio < 98% dẫn đến hiện tượng đọc đĩa tăng vọt.
Tự động điều chỉnh tham số tệp cấu hình, mở rộng bộ đệm Page Cache và restart Pod cuốn chiếu.
CHƯƠNG 7: BACKUP, RESTORE & DISASTER RECOVERY PROCEDURES
7.1 Phân Tách Quy Trình Sao Lưu / Nhân Bản Dữ Liệu Thực Tế
Tuyệt đối không gộp chung cơ chế lưu trữ. Quy trình DR tách biệt rạch ròi luồng nhân bản dữ liệu:
PostgreSQL Core Data Layer: Sử dụng pgBackRest thực hiện chuyển giao bản sao lưu snapshot hằng ngày lên AWS S3 độc lập, kết hợp cơ chế Streaming Replication đồng bộ liên tục dữ liệu sang cụm Patroni Slave tại Vùng dự phòng (Secondary DR Region).
Apache Kafka Event Log Layer: Sử dụng Kafka MirrorMaker 2 thực hiện đồng bộ hóa liên tục tất cả các Topic, Partition và Offset của chuỗi sự kiện Ledger sang cụm Kafka đích tại Vùng dự phòng.
7.2 Quy Trình DR Chuyển Vùng Khi Gặp Thảm Họa Diện Rộng (Region Outage)
Bước 1 (Mở Biên Mạng An Toàn): Thay vì dùng TTL=0 không thực tế, AWS Route53 bắt buộc cấu hình bản ghi với TTL = 30s hoặc 60s kết hợp cơ chế Weighted Routing và tự động Health Check để dịch chuyển dần lưu lượng tải.
Bước 2 (Thăng Cấp Cơ Sở Dữ Liệu Lõi): Truy cập cụm pgBackRest tại vùng dự phòng, thực thi lệnh thăng cấp (Promote) Patroni Slave DB đang nhận Streaming Replication thành Primary Master hoạt động độc lập.
Bước 3 (Khai Hỏa Cụm Sự Kiện): Kích hoạt ArgoCD tại Cluster dự phòng thực hiện đồng bộ hóa cưỡng bức tất cả các StatefulSet của Neo4j và Redis với các snapshot dữ liệu được kiểm toán gần nhất.
7.3 Backup Verification & Monthly Restore Drill
Một bản sao lưu không qua kiểm thử phục hồi được coi là không tồn tại. Hệ thống bắt buộc phải thiết lập một pipeline tự động vào lúc 02:00 AM ngày Chủ nhật đầu tiên của tháng để kéo tệp tin sao lưu mới nhất về một Isolate Sandbox Namespace. Sau khi phục hồi thành công, chạy thuật toán **Checksum Validation Gate đối soát mã hóa SHA-256 ngẫu nhiên 1,000 bản ghi**. Chỉ khi đạt tỷ lệ khớp đúng 100%, bản sao lưu mới được gắn nhãn hợp lệ (Backup Verified).
CHƯƠNG 8: RELEASE, FEATURE FLAGS & MAINTENANCE WINDOWS
8.1 Chiến Lược Sử Dụng Feature Flags (Vận Hành Khẩn Cấp)
Mọi tính năng mới phát hành bắt buộc phải được bọc trong các Feature Flags quản lý tập trung qua OpenFeature / Unleash:
Kill Switch (Nút ngắt khẩn cấp): Nếu mã nguồn mới gây rò rỉ bộ nhớ hoặc lỗi logic, Incident Commander có quyền nhấn nút tắt khẩn cấp trên Dashboard, lập tức cô lập luồng code mới và trả traffic về luồng cũ ổn định trong vòng dưới 1 giây.
Emergency Disable & Canary Launch: Cấu hình dịch chuyển tải tăng dần theo tỷ lệ: 1% → 5% → 10% → 100% kèm theo điều kiện giám sát chặt chẽ Error Budget.
8.2 Maintenance Window Doctrine (Quy Chuẩn Cập Nhật Cấu Trúc Dữ Liệu)
Các tác vụ thay đổi cấu trúc dữ liệu lớn (Schema Migration) bắt buộc phải tuân thủ trình tự vận hành an toàn: Kích hoạt chế độ Read-Only tạm thời cho phân vùng bị ảnh hưởng → Thực thi công cụ Migration theo mô hình tuần tự không khóa bảng (Zero-downtime Schema Change như gh-ost) → Tạo bản sao Blue/Green Deployment cho lớp dịch vụ → Dịch chuyển dần 10% lưu lượng kiểm tra ứng dụng → Xác minh → Khôi phục hoàn toàn quyền Read/Write thực tế.
CHƯƠNG 9: PRODUCTION READINESS REVIEW (PRR) CHECKLIST
Trước khi bất kỳ dịch vụ nào được ArgoCD cho phép đồng bộ lên môi trường Production, Service Owner hoặc AI Agent bắt buộc phải kiểm tra và đánh dấu tích đầy đủ vào danh mục PRR Checklist tối cao:
Dashboard: Dịch vụ đã cấu hình đầy đủ Grafana Dashboard chuẩn với 4 chỉ số vàng (Latency, Traffic, Errors, Saturation).
Alert: Đã khai báo và nạp thành công các quy tắc cảnh báo Warning/Critical vào Alertmanager cho dịch vụ mới.
Runbook: Đã đính kèm tài liệu Runbook hướng dẫn xử lý sự cố chuẩn hóa 7 pha vào phần mô tả tài nguyên.
Rollback Plan: Đã kiểm thử thành công kịch bản hoàn tác tự động thông qua ArgoCD chỉ bằng một Git commit revert.
Capacity & Backup: Đã cấu hình auto-scaling tương thích và tích hợp thành công cấu hình sao lưu dữ liệu tự động vào hệ thống pgBackRest/Neo4j-Admin.
CHƯƠNG 10: AI OPERATIONS CONTRACTS (HỢP ĐỒNG HÀNH VI VẬN HÀNH CHO AI AGENT)
Chương này thiết lập các rào cản hành vi kỹ thuật tối cao (GLOBAL ENGINE LOCKS) trên môi trường Production. AI SRE/DevOps AGENT MUST COMPLY WITH THE FOLLOWING CONTRACTS:
AI SHALL NOT automatically trigger a restart or destruction of any StatefulSet database nodes (PostgreSQL, Neo4j, Kafka) during a P0/P1 incident without obtaining an explicit cryptographic signature approval from the human Incident Commander.
AI SHALL NOT execute an automated failover promotion (Promoting a database replica to Primary Master) unless the automated validation script confirms that the replication quorum is fully satisfied.
AI SHALL NOT perform a destructive reset of Apache Kafka topic offsets (such as --to-earliest) on production clusters without first executing an automated backup snapshot verification of the target data consumers.
AI SHALL always execute an automated end-to-end integration test (Smoke Test Suite) immediately following any automated self-healing or recovery action to guarantee that system integrity is fully restored.
CHƯƠNG 11: POSTMORTEM DOCTRINE & CONTINUOUS RELIABILITY IMPROVEMENT
Sửa lỗi bằng Runbook chỉ giúp hệ thống sống sót qua cơn thảm họa, quy trình Postmortem mới là thứ giúp hệ thống EGAL tiến hóa không ngừng.
Blameless Postmortem (Kiểm thảo không đổ lỗi): Trong vòng tối đa 48 tiếng kể từ khi giải cứu sự cố P0/P1 thành công, Incident Commander bắt buộc phải triệu tập cuộc họp Postmortem. Quy trình tập trung vào việc mổ xẻ lỗ hổng hệ thống hạ tầng và logic code, tuyệt đối không quy trách nhiệm hoặc đổ lỗi cho cá nhân con người hay AI.
Cấu Trúc Tài Liệu Postmortem Bắt Buộc:
Timeline: Dòng thời gian chi tiết từng phút từ lúc sự cố phát sinh, hệ thống kích hoạt cảnh báo, Runbook thực thi, cho đến khi hồi phục hoàn toàn.
Root Cause Analysis (RCA): Áp dụng phương pháp luận Five Whys (5 Câu hỏi Tại sao) để đào sâu tận gốc rễ vấn đề kỹ thuật hạ tầng.
Action Items Matrix: Danh sách các đầu việc cải tiến hạ tầng được khóa cấu hình. Mỗi đầu việc phải chỉ định rõ ràng duy nhất một cá nhân (hoặc Agent Team) làm chủ quản (Owner), đi kèm với thời hạn hoàn thành (Due Date) và bắt buộc phải được theo dõi thực thi tự động.
--- KẾT THÚC CẨM NANG VẬN HÀNH LEVEL D7 - V2.0.0 ---
Tài liệu này đã được đóng băng toàn phần làm khế ước vận hành lõi cho hệ thống EGAL Production Cluster. Không một thực thể nào được phép can thiệp gỡ bỏ trừ khi có quyết định bằng chữ ký số của Hội đồng Kiến trúc sư Trưởng.