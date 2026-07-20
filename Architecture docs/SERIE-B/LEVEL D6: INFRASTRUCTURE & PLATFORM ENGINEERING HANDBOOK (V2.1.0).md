EGAL CLAN MANAGEMENT PLATFORM
(NỀN TẢNG QUẢN LÝ DÒNG HỌ SỐ)
LEVEL D6: INFRASTRUCTURE & PLATFORM ENGINEERING HANDBOOK
Phiên Bản V2.1.0 - Hợp Nhất Ý Kiến Phản Biện Sản Xuất
Mã Tài Liệu: EGAL-ARCH-LEVEL-D6-HANDBOOK
Trạng Thái: FROZEN BASELINE - PRODUCTION APPROVED
Phương Pháp Luận: ISO 42010 / TOGAF / DDD / Clean Hexagonal Architecture
CHƯƠNG 1: PURPOSE (MỤC ĐÍCH & ĐỐI TƯỢNG)
Tài liệu này đóng vai trò là Cẩm nang Kỹ thuật Hạ tầng và Nền tảng (Infrastructure & Platform Engineering Handbook) chuẩn Production tối cao của Nền tảng Dòng họ số EGAL. Mục tiêu cốt lõi của Level D6 là chuyển hóa toàn bộ các ràng buộc kiến trúc cấp cao (Level B/C) và bản đồ nền tảng (D1-D5) thành các Hợp đồng Kỹ thuật (Engineering Contracts) bất biến, rõ ràng, cho phép một AI DevOps Engineer hoặc hệ thống GitOps tự động hóa khởi tạo, cấu hình, vận hành và phục hồi toàn bộ hệ thống mà không cần sự can thiệp thủ công.
CHƯƠNG 2: PLATFORM DECISIONS (QUYẾT ĐỊNH NỀN TẢNG CỐT LÕI)
Hạ tầng EGAL dựa trên các quyết định công nghệ mang tính chiến lược sau:
Lớp Điều Phối: Managed Kubernetes (v1.30+) làm nền tảng tính toán phân tán thống nhất.
Lớp Biên Dịch/Cửa Ngõ: KONG Enterprise API Gateway xử lý định tuyến, bảo mật biên, nén Brotli thích ứng mạng yếu.
Lớp Trục Tin Nhắn: Apache Kafka (KRaft Mode) bảo đảm Communication Doctrine thông qua Transactional Outbox/Inbox đạt độ trễ < 30 giây với ngữ nghĩa Exactly-Once (EOS).
Lớp Lưu Trữ Hợp Nhất (Polyglot Persistence): PostgreSQL (Giao dịch/Ledger) + Patroni HA, Neo4j Enterprise (Đồ thị phả hệ), Redis Cluster (Bộ nhớ đệm/Phân tán), OpenSearch (Tìm kiếm), MinIO WORM (Lưu trữ vĩnh viễn tài liệu cổ vật).
CHƯƠNG 3: ENVIRONMENT MATRIX (MA TRẬN MÔI TRƯỜNG TRIỂN KHAI)
Môi trường triển khai của EGAL được chuẩn hóa nghiêm ngặt trên toàn hệ thống:
Environment
Kubernetes Namespace
Cluster Type / Hosting
Traffic Purpose
 
Local
local
Kind / Minikube (Local Dev)
Nhà phát triển và AI Testing nội bộ
Dev
dev
AWS EKS (Developer Cluster)
Tích hợp mã nguồn tự động (CI)
SIT
sit
AWS EKS (System Integration Test)
Kiểm thử tích hợp hệ thống chéo
UAT
uat
AWS EKS (User Acceptance Test)
Hội đồng dòng họ nghiệm thu tính năng
Production
prod (Phân rã theo Doctrine)
AWS EKS Multi-AZ (Production Tier-III)
Vận hành thực tế, dữ liệu dòng họ thật
CHƯƠNG 4: CLUSTER TOPOLOGY MATRIX (MA TRẬN TỔ CHỨC CỤM)
Bảo đảm tính sẵn sàng cao thông qua việc định hình trạng thái lưu trữ và số lượng bản sao tối thiểu:
Component
Stateful Type
Minimum Replicas
Anti-Affinity Rule
Storage Provisioner
 
KONG Gateway
Stateless
3
topologyKey: kubernetes.io/hostname
N/A
NestJS Core Services
Stateless
3 (Mỗi dịch vụ)
topologyKey: topology.kubernetes.io/zone
N/A
Apache Kafka (KRaft)
StatefulSet
3 Controllers + 3 Brokers
Strict Physical Node Isolation
EBS gp3 (Dedicated)
PostgreSQL (Patroni)
StatefulSet
3 (1 Primary, 2 Replicas)
Strict Multi-AZ Isolation
EBS io2 Block Storage
Neo4j Enterprise
StatefulSet
3 (Core Members)
Strict Multi-AZ Isolation
EBS gp3 (High IOPS)
Redis Cluster
StatefulSet
6 (3 Masters, 3 Slaves)
Cross-Node Pairing
EBS gp3 / Local NVMe
CHƯƠNG 5: NAMESPACE DOCTRINE & OWNERSHIP
Không cho phép gom tất cả ứng dụng vào một không gian tên chung. Hệ thống phân rã và gán quyền sở hữu rõ ràng:
service-apps: Chứa các Microservices xử lý CommandBus và QueryBus (Gia phả, Tài chính dòng họ). Owner: Application Team / AI Coding Agent.
service-infra: Chứa API Gateway (KONG) và Trục thông điệp (Kafka). Owner: Core Platform Team.
service-data: Cô lập toàn bộ Cơ sở dữ liệu (PostgreSQL, Neo4j, Redis, MinIO). Owner: Data Platform / DBA Team.
service-monitoring: Chứa hạ tầng giám sát (Prometheus, Grafana, Loki, Jaeger). Owner: SRE Team.
service-security: Chứa thành viên bảo mật (Keycloak, HashiCorp Vault). Owner: SecOps Team.
CHƯƠNG 6: NETWORK DOCTRINE (PHÂN CHỈ VÙNG VÀ BẢO MẬT)
Hệ thống chia làm 3 phân vùng cách ly mạng tuyệt đối. Kiểm soát lưu lượng Ingress/Egress thông qua Calico NetworkPolicy:
Public DMZ (Ingress Edge): Tiếp nhận kết nối HTTPS TLS 1.3 ngoại vi từ các client ACXD, chuyển tiếp trực tiếp đến lớp KONG Gateway.
Private Application Zone (Internal Apps): Không thể định tuyến từ Internet. Giao tiếp chéo qua gRPC mTLS.
Isolated Secure Storage Zone: Chỉ chấp nhận kết nối từ Pods thuộc tầng Repository Adapter đã xác thực.
CHƯƠNG 7: STORAGE DOCTRINE & WORM RETENTION
Dữ liệu phả hệ số, văn bản gia phả gốc là bất biến vĩnh viễn. Quy định lưu trữ:
Dữ liệu tệp tin văn bản, sắc phong cổ vật phải lưu vào MinIO/S3 cấu hình Object Lock ở chế độ COMPLIANCE tối thiểu 100 năm.
Các khối lưu trữ cơ sở dữ liệu phải bật tính năng mã hóa tĩnh (Encryption-at-Rest) bằng khóa quản lý bởi AWS KMS hoặc HashiCorp Vault thông qua StorageClass.
CHƯƠNG 8: INFRASTRUCTURE & PLATFORM FOLDER LAYOUT
Cấu trúc thư mục kho lưu trữ cấu hình hệ thống (GitOps Repository) bắt buộc tuân thủ layout chuẩn hóa:
infra-platform-gitops/├── terraform/          # Mã nguồn cấu hình hạ tầng đám mây (VPC, EKS, KMS, S3)├── kubernetes/         # Các manifest Kubernetes thô (Custom Resource Definitions, Common Configs)├── helm/               # Định nghĩa hoặc bọc các ứng dụng nội bộ thông qua Helm Charts│   ├── gateway/│   ├── lineage-service/│   ├── ledger-service/│   └── persistence-stores/├── argocd/             # Khai báo các Application Manifest để triển khai tự động (GitOps Engine)├── monitoring/         # Dashboard Grafana, Cấu hình Alertmanager, Prometheus Rules├── network/            # Calico NetworkPolicies chung cho toàn hệ thống├── storage/            # Định nghĩa PersistentVolume, StorageClass mã hóa tĩnh├── vault/              # Cấu hình Policy, Secrets Engine, AppRole cho dịch vụ└── scripts/            # Kịch bản tự động hóa vận hành, kiểm tra chất lượng hạ tầng
CHƯƠNG 9: IAC STANDARDS (TIÊU CHUẨN TERRAFORM MANIFEST)
Cấu hình mẫu khởi tạo hạ tầng lõi trên AWS Cloud vùng Singapore (ap-southeast-1):
# main.tfterraform {  required_version = ">= 1.5.0"  required_providers {    aws = {      source  = "hashicorp/aws"      version = "~> 5.0"    }    kubernetes = {      source  = "hashicorp/kubernetes"      version = "~> 2.23"    }  }}provider "aws" {  region = "ap-southeast-1"}resource "aws_vpc" "egal_vpc" {  cidr_block           = "10.100.0.0/16"  enable_dns_hostnames = true  enable_dns_support   = true  tags = { Name = "egal-production-vpc" }}resource "aws_eks_cluster" "egal_eks" {  name     = "egal-prod-k8s-cluster"  role_arn = aws_iam_role.eks_cluster_role.arn  vpc_config {    subnet_ids              = aws_subnet.private_subnets[*].id    endpoint_private_access = true    endpoint_public_access  = false # BẬT CHẾ ĐỘ PRIVATE HOÀN TOÀN KHÔNG LỘ RA NGOÀI  }}# RÀNG BUỘC KỸ THUẬT CHO CI/CD TRUY CẬP PRIVATE CLUSTER# Để cho phép Github Actions Runner hoặc Quản trị viên truy cập vào cụm Cluster EKS khi endpoint_public_access = false:# AI SHALL cấu hình một Bastion Host (EC2) nằm trong Public Subnet được bảo vệ bằng mã hóa SSH Key, # hoặc triển khai AWS Client VPN nội bộ kết nối trực tiếp vào mạng VPC Private. # Tất cả các yêu cầu kubectl từ bên ngoài bắt buộc phải đi qua đường truyền VPN hoặc Proxy được kiểm toán.
CHƯƠNG 10: GITOPS DOCTRINE (QUY TRÌNH TRIỂN KHAI TỰ ĐỘNG KHÉP KÍN)
EGAL nghiêm cấm mọi hành vi sử dụng lệnh thủ công (kubectl apply) tại môi trường Production. Luồng GitOps được đóng băng như sau:
Git Code Push (Developer/AI) → Pull Request (PR) → GitHub Actions (Build Image, Sign Image, Tạo SBOM) → Container Registry (Mã hóa, quét lỗ hổng) → ArgoCD Engine (Tự động phát hiện thay đổi cấu hình) → Kubernetes Production Cluster Synchronization.
ArgoCD được thiết lập cơ chế selfHeal: true và prune: true nhằm triệt tiêu hoàn toàn hiện tượng lệch cấu hình (Configuration Drift) so với mã nguồn trong Git.
CHƯƠNG 11: DEPLOYMENT STRATEGY (CHIẾN LƯỢC PHÁT HÀNH ỨNG DỤNG)
Mỗi nhóm dịch vụ phải tuân thủ nghiêm ngặt chiến lược phát hành quy định:
Dịch vụ Stateless (Microservices): Sử dụng chiến lược Canary Deployment hoặc Blue/Green. Phân bổ lưu lượng ban đầu 5% thông qua KONG Gateway, kiểm tra lỗi tự động trong 10 phút trước khi mở rộng lên 100%.
Sửa đổi Khẩn cấp (Hotfix): Phải đi qua nhánh Git chuyên biệt, chạy đầy đủ QA Gates trước khi đóng gói thành Immutable Image, tuyệt đối không sửa đổi tag latest.
Cơ Chế Phục Hồi (Rollback): Khi phát hiện tỷ lệ lỗi HTTP 5xx tăng quá 1% trong quá trình Canary, ArgoCD tự động thực hiện hoàn tác về Git Commit ID ổn định gần nhất trong thời gian dưới 10 giây.
CHƯƠNG 12: HELM CHART LAYOUT & ARTIFACT MANIFESTS
Toàn bộ tài nguyên được đóng gói thành các cấu trúc Helm trực quan và tường minh:
12.1 Cấu hình KONG Enterprise API Gateway Manifest (Sửa đổi đồng bộ Redis)
Nhằm đồng bộ với tài liệu D4, chính sách Rate-Limiting tại lớp biên KONG Gateway bắt buộc sử dụng bộ đệm phân tán Redis Cluster thay vì chính sách local bị phân rã độc lập theo từng Pod Instance:
# kong.yml_format_version: "3.0"services:  - name: clan-lineage-service    url: http://clan-lineage-service.service-apps.svc.cluster.local:8080    routes:      - name: lineage-routes        paths:          - /api/v1/lineage        strip_path: true    plugins:      - name: rate-limiting        config:          minute: 100          hour: 3000          policy: redis   # THỐNG NHẤT CHÍNH SÁCH PHÂN TÁN TOÀN CỤM THEO D4          redis_host: "redis-cluster.service-data.svc.cluster.local"          redis_port: 6379          redis_password: "${file:/vault/secrets/redis:password}"          fault_tolerant: true      - name: jwt        config:          uri_param_names: [token]          cookie_names: [access_token]          key_claims_to_verify: [exp]
12.2 Cấu hình Patroni PostgreSQL HA Cluster (`patroni.yml`)
scope: postgres-patroninamespace: /service/patronibootstrap:  dcs:    ttl: 30    loop_wait: 10    retry_timeout: 10    postgresql:      use_pg_rewind: true      use_slots: true      parameters:        max_connections: 500        shared_buffers: 16GB        effective_cache_size: 48GB        wal_level: logical # KÍCH HOẠT LOGICAL PHỤC VỤ CDC DEBEZIUM CONNECT        max_wal_size: 16GB        min_wal_size: 1GB        archive_mode: "on"        archive_command: "pgbackrest --stanza=egal_ledger archive-push %p"
12.3 Cấu hình Debezium PostgreSQL CDC Connector
{  "name": "egal-postgresql-outbox-connector",  "config": {    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",    "tasks.max": "3",    "plugin.name": "pgoutput",    "database.hostname": "postgres-patroni.storage.svc.cluster.local",    "database.dbname": "egal_business_ledger",    "table.include.list": "public.transaction_outbox",    "decimal.handling.mode": "string" # SỐ THẬP PHÂN LƯU THÀNH CHUỖI KHÔNG MẤT ĐỘ CHÍNH XÁC  }}
12.4 Cấu hình Giới Hạn Thao Tác Neo4j Enterprise (`neo4j.conf`)
Thực thi nguyên tắc an toàn dữ liệu huyết thống, hạn chế thủ tục APOC phạm vi rộng:
# Chỉ cho phép các thủ tục APOC an toàn và cần thiết cho đồ thị gia phả số, thay vì cho phép apoc.* rộngdbms.security.procedures.allowlist=apoc.nodes.*,apoc.path.*,apoc.meta.*,gds.bfs.*,gds.shortestPath.*# Không sử dụng cơ chế Native Cascading (ON DELETE CASCADE) tại tầng CSDLdbms.read_only=false
12.5 Cấu hình Kubernetes Deployment & NetworkPolicy cho Core App
apiVersion: apps/v1kind: Deploymentmetadata:  name: egal-gateway-service  namespace: service-appsspec:  replicas: 3  template:    metadata:      labels:        app: egal-gateway-service    spec:      containers:      - name: gateway-app        image: registry.tocduongso.vn/egal/gateway-service:v2.0.0-release        resources:          requests:            cpu: "500m"            memory: "1024Mi"          limits:            cpu: "2000m"            memory: "2048Mi"        securityContext:          allowPrivilegeEscalation: false          readOnlyRootFilesystem: true          runAsNonRoot: true          runAsUser: 10001---apiVersion: networking.k8s.io/v1kind: NetworkPolicymetadata:  name: gateway-network-policy  namespace: service-appsspec:  podSelector:    matchLabels:      app: egal-gateway-service  policyTypes: [Ingress, Egress]  ingress:  - from:    - namespaceSelector:        matchLabels:          kubernetes.io/metadata.name: service-infra      podSelector:        matchLabels:          app: kong
CHƯƠNG 13: SCALING POLICY (CHÍNH SÁCH TỰ ĐỘNG MỞ RỘNG)
Tự động điều chỉnh năng lực xử lý tính toán dựa trên Horizontal Pod Autoscaler (HPA) tích hợp Prometheus Adapter:
Stateless Microservices: HPA sẽ tự động kích hoạt nâng số lượng Pods từ 3 lên tối đa 10 khi chỉ số sử dụng CPU Average > 70% hoặc Memory Average > 80% duy trì liên tục trong 2 phút.
Kafka Consumer Group Autoscaling: HPA kích hoạt co giãn các consumer microservices dựa trên Custom Metrics: kafka_consumergroup_lag > 5000 messages nhằm đảm bảo tốc độ đồng bộ thông điệp của Communication Doctrine.
CHƯƠNG 14: RESOURCE POLICY (QUẢN LÝ TÀI NGUYÊN NGẶT NGHÈO)
Mọi cấu hình Pod Manifest bắt buộc phải định nghĩa rõ ràng vùng tài nguyên:
Phải có đủ requests và limits cho cả CPU và Memory để tránh hiện tượng sập Node do tranh chấp tài nguyên (OOM-Killed).
Môi trường Production bắt buộc khai báo PodDisruptionBudget (PDB) với cấu hình minAvailable: 2 hoặc maxUnavailable: 1 để bảo đảm tính sẵn sàng cao khi K8s nâng cấp Cluster Node.
Gán cấu hình PriorityClass cấp độ cao (system-cluster-critical) đối với KONG Gateway, Kafka Brokers và PostgreSQL để ngăn chặn Scheduler trục xuất các Pods này khi Cluster đầy tải.
CHƯƠNG 15: BACKUP MATRIX (MA TRẬN SAO LƯU TOÀN DIỆN)
Chiến lược sao lưu bảo vệ an toàn tuyệt đối tài sản dữ liệu dòng họ số được định hình như sau:
Component
Backup Tool Engine
Backup Type / Frequency
Retention Period
 
PostgreSQL (Ledger)
pgBackRest
Full (Hằng tuần), Incremental (Mỗi 6 tiếng) + WAL streaming liên tục
365 Ngày (1 năm) lưu tại S3 Cold Archive
Neo4j Enterprise
neo4j-admin backup
Online Backup toàn diện vào lúc 01:00 AM hằng ngày
90 Ngày
Apache Kafka
Kafka MirrorMaker 2
Replication liên tục sang DR Cluster phân vùng địa lý khác
Phụ thuộc vào Retention Policy của Topic
Redis Cluster
N/A (Cache Layer)
Không áp dụng (Dữ liệu có thể dựng lại từ PostgreSQL/Neo4j)
N/A
HashiCorp Vault
Vault Raft Snapshot
Mã hóa và trích xuất Snapshot tự động sau mỗi 12 tiếng
30 Ngày (Lưu trữ cô lập tối mật)
CHƯƠNG 16: DISASTER RECOVERY DOCTRINE (QUY TRÌNH PHỤC HỒI THẤT BẠI)
Mục tiêu thiết kế (Design Goals): RTO ≤ 5\text{ phút} đối với hạ tầng dịch vụ, RPO \le 10\text{ giây} đối với cấu trúc đồ thị Neo4j. Đối với hệ thống sổ cái kế toán (Ledger), cam kết thiết kế hướng tới RPO = 0 giây nhờ vào cơ chế nhân bản đồng bộ đa vùng của Kafka log replication, đồng bộ hóa chặt chẽ PostgreSQL WAL và cơ chế Failover tự động qua Patroni.
Quy trình tự động hóa xử lý thảm họa (Disaster Recovery Flow):
Node / Zone Failure → K8s Pod Restart / Reschedule → Patroni Replica Promotion (Tự động bầu chọn Slave thành Master mới nếu Primary chết trong < 10 giây) → Traffic Switch via Kong/Core-DNS → Full System Recovery Validation.
CHƯƠNG 17: SECRET LIFECYCLE (VÒNG ĐỜI BẢO MẬT KHÓA/MẬT MÃ)
Không lưu trữ bất kỳ mật mã phẳng (Plaintext Secrets) nào trên mã nguồn Git hoặc cấu hình Kubernetes Secret thông thường. Chu trình xử lý:
Generate (Khởi tạo tự động bằng mã hóa mạnh) → Vault Storage (Lưu trữ an toàn trong HashiCorp Vault K/V Engine) → Inject (Nhúng động trực tiếp vào bộ nhớ RAM của Pod khi khởi động qua Vault Secret Agent Sidecar làm tệp tin ảo) → Rotate (Tự động xoay vòng khóa định kỳ mỗi 30 ngày) → Expire/Audit (Thu hồi mã thông báo hết hạn và ghi vết nhật ký truy cập vào Audit Log tập trung).
CHƯƠNG 18: OBSERVABILITY STACK (HỆ THỐNG GIÁM SÁT TOÀN DIỆN)
Hạ tầng giám sát tối cao phục vụ việc đo lường độ trễ D_{total} = D_{ingress\_kong} + D_{command\_bus} + D_{libsodium\_encrypt} + D_{postgres\_patroni} + D_{cdc\_kafka} bao gồm:
Prometheus & OpenTelemetry Collector: Thu thập toàn bộ log, metrics và traces chuẩn hóa từ hệ thống ứng dụng và cơ sở dữ liệu nền tảng.
Alertmanager: Phân tích chỉ số cảnh báo trực thì. Kích hoạt mức độ khẩn cấp Critical P1 gửi tới đội ngũ SRE nếu tổng độ trễ D_{total} \ge 30\text{ giây} kéo dài quá 3 chu kỳ lấy mẫu.
Grafana: Trực quan hóa toàn bộ sức khỏe hệ thống.
Loki & Jaeger: Quản lý bản ghi log tập trung và lần vết phân tán (Distributed Tracing) của từng Command đi qua CommandBus.
CHƯƠNG 19: RELEASE MANAGEMENT & IMMUTABLE IMAGES
Quy trình quản lý phiên bản vận hành ứng dụng:
Semantic Versioning (vX.Y.Z) → Release Tag Production Đóng Băng → Immutable Container Image (Gắn thẻ bằng Git SHA và Version, không dùng tag biến động) → GitOps Deployment via ArgoCD.
CHƯƠNG 20: PLATFORM SECURITY & COMPLIANCE
Đảm bảo an toàn tuyệt đối cho Cluster chống lại các cuộc tấn công khai thác leo thang đặc quyền:
Kích hoạt Pod Security Admission (PSA) ở chế độ enforce: restricted trên toàn bộ các không gian tên ứng dụng.
Sử dụng Kyverno / OPA Gatekeeper để từ chối bất kỳ manifest nào vi phạm quy tắc an ninh hạ tầng.
Toàn bộ Container Image phải được ký số bằng Cosign và đính kèm danh mục thành phần phần mềm SBOM (Software Bill of Materials) được quét tự động bởi Trivy trước khi nạp vào hệ thống triển khai.
CHƯƠNG 21: COST GOVERNANCE (QUẢN TRỊ CHI PHÍ TRIỂN KHAI)
Tối ưu hóa ngân sách vận hành Production nhưng không ảnh hưởng tới chất lượng Elder-First:
Thiết lập hạn mức tài nguyên ResourceQuota chặt chẽ cho từng Namespace (Namespace Budget).
Sử dụng AWS EC2 Spot Instances cho các Node Pool chạy môi trường Dev/SIT/UAT và các tác vụ phi trạng thái có thể tái khởi động. Toàn bộ cơ sở dữ liệu Statefull bắt buộc dùng On-Demand hoặc Reserved Instances.
Tự động chuyển các bản sao lưu cơ sở dữ liệu cũ hơn 30 ngày sang AWS S3 Glacier Flexible Archive Tier nhằm cắt giảm chi phí lưu trữ lên đến 70%.
CHƯƠNG 22: QA INFRASTRUCTURE GATES
Hệ thống tự động kiểm tra trước khi đồng ý cho ArgoCD đồng bộ mã hạ tầng lên Production:
Chạy lệnh tflint và checkov quét toàn bộ mã nguồn Terraform để loại bỏ lỗi cấu hình bảo mật hớ hênh.
Sử dụng helm lint và kubeconform kiểm tra tính hợp lệ của toàn bộ tệp tin YAML cấu hình tài nguyên.
CHƯƠNG 23: AI INFRASTRUCTURE CONTRACTS (HỢP ĐỒNG BẤT BIẾN CHO AI AGENT)
Ràng buộc bắt buộc (GLOBAL ENGINE LOCK) - AI DEVOPS ENGINEER SHALL NOT thực hiện các hành vi sau:
AI SHALL NOT deploy container images utilizing the latest tag or any mutable tags in production manifests.
AI SHALL NOT expose raw database endpoints or internal service ports via public LoadBalancer service type; all ingress traffic must traverse the KONG API Gateway.
AI SHALL NOT disable or omit livenessProbe, readinessProbe, or startupProbe configurations for any service deployed within the cluster.
AI SHALL NOT disable, modify, or bypass NetworkPolicy configurations that enforce isolation between application zones and data zones.
AI SHALL NOT deploy privileged containers, allow privilege escalation (allowPrivilegeEscalation: true), or permit containers to run as root user (runAsRoot: true).
AI SHALL NOT mount the host docker.sock or any container runtime sockets inside application pods.
AI SHALL NOT disable readOnlyRootFilesystem unless a temporary writable directory (e.g., emptyDir) is explicitly declared and justified for ephemeral data processing.
CHƯƠNG 24: CROSS REFERENCES (TÀI LIỆU THAM CHIẾU CHÉO)
LEVEL_B (Kiến trúc Doanh nghiệp EGAL - 12 Tập Phim): Bản gốc cấu trúc định vị chiến lược.
LEVEL_C V3.0 (Cơ chế Hiện thực hóa Kiến trúc): Ràng buộc lõi về Command/Query Bus.
LEVEL_D4 V2.0 (Bản đồ Tích hợp Hệ thống): Đồng bộ nhất quán về giải pháp mã hóa, lưu trữ đệm phân tán Redis Cluster và quản trị API.
--- KẾT THÚC CẨM NANG V2.1.0 HANDBOOK ---
Mọi hành vi tự động biên dịch bởi AI Agent bắt buộc lấy tệp cấu hình này làm Hợp đồng triển khai hạ tầng gốc. Không được phép sai lệch một byte dữ liệu.