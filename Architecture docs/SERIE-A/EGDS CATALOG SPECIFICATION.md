EGAL PLATFORM V4 - EGDS CATALOG SPECIFICATION V2.1

Framework Compliance: ISO/IEC 42010, TOGAF 10, MOF Level 2
Classification: Level 6 Product Architecture Specification (Absolute Frozen Sign-Off)
Status: ABSOLUTE BASELINE FROZEN
Invariants Enforced: AXIOM-EASAS-00, Technology Neutrality, API Neutrality, Domain Independence, Single Source of Truth
CHƯƠNG 1 — INTRODUCTION
1.1. Purpose (Mục đích)
EGDS Catalog đóng vai trò là Product Architecture Specification tối cao cho toàn bộ các Tiêu chuẩn Miền Chuyên ngành (Level 6 Domain Standards) thuộc hệ sinh thái EGAL Platform. Vượt trên tư duy của một Enterprise Architecture Framework mang tính mô tả lý thuyết, tài liệu này xác định cách thức các cấu trúc sản phẩm độc lập (Domain Standards) được định danh, tổ chức, tương tác và quản lý như một hệ sinh thái nền tảng thống nhất và bền vững qua nhiều năm.
1.2. Scope (Phạm vi)
Áp dụng bắt buộc đối với toàn bộ các hoạt động đề xuất, đăng ký danh mục, kiểm định tuân thủ và vận hành tự động các công cụ sinh mã/tài liệu (generators) thuộc lớp Level 6.
1.3. Relationship với EDA, AKRM, ADRM, EASC
Duy trì cơ chế tham chiếu tĩnh một chiều hướng thượng (Upward Static Reference), đảm bảo sự tách biệt tuyệt đối và bảo toàn các bất biến toán học của khối móng hiến pháp từ Level 1 đến Level 5 đã đóng băng.
CHƯƠNG 2 — EGDS OVERVIEW & CORE DEFINITIONS
2.1. Định nghĩa EGAL Domain Standard (EGDS)
Một EGDS (EGAL Domain Standard) là một chuẩn độc lập mô tả đầy đủ một miền kiến thức hoặc miền quản trị của EGAL Platform. Mỗi EGDS hoạt động như một module tự trị, bao hàm toàn vẹn cấu trúc logic bao gồm: vocabulary, canonical meta-model, registry schema, validation rules, traceability rules, governance rules và các quy định mở rộng của chính miền đó.
2.2. Khái niệm Canonical Domain Contract (Hợp đồng Miền Chuẩn tắc)
Mọi EGDS khi phát triển bắt buộc phải triển khai (implement) cùng một "giao diện kiến trúc" chuẩn tắc. Canonical Domain Contract đóng vai trò như một Interface lập trình cấp độ kiến trúc, buộc các miền có nội dung nghiệp vụ chuyên môn khác nhau phải tuân thủ một phom phác thảo cấu trúc, cơ chế versioning và phương thức thẩm định đồng nhất, tạo điều kiện cho AI hoặc generator có thể tự động hóa hoàn toàn luồng sinh mã và kiểm định.
CHƯƠNG 3 — DESIGN PRINCIPLES
Mọi quyết định thiết kế và tích hợp sản phẩm tại Level 6 phải tuân thủ tuyệt đối 10 nguyên lý cốt lõi sau:
Domain Independence (Tính Tự trị của Miền): Mỗi Domain phải có khả năng biên soạn, đánh giá, phát hành, quản trị và tiến hóa phiên bản một cách hoàn toàn độc lập, loose-coupling với các miền còn lại.
Single Source of Truth (Nguồn Thật Duy nhất): Mỗi khái niệm kiến trúc chỉ được phép có duy nhất một Domain sở hữu chuẩn tắc (Every architectural concept shall have exactly one canonical owner domain). Nghiêm cấm sự chồng lấn định nghĩa hoặc sở hữu song trùng giữa các miền (ví dụ: một thực thể không thể vừa được sở hữu bởi Requirement Domain vừa được sở hữu bởi Process Domain).
Reuse Before Reinvent (Tái sử dụng trước khi Tái chế): Triệt để sử dụng lại các thực thể và cấu trúc đã được chuẩn hóa ở các miền nền tảng, nghiêm cấm việc định nghĩa lại các khái niệm đã có.
Technology Neutrality (Trung hòa Công nghệ): Không phụ thuộc vào bất kỳ hạ tầng lưu trữ vật lý hay công nghệ cơ sở dữ liệu cụ thể nào (Prisma, Neo4j, PostgreSQL, MongoDB...).
API Neutrality (Trung hòa Giao tiếp): Thiết kế logic trừu tượng độc lập hoàn toàn với các giao thức giao tiếp mạng hoặc ngôn ngữ truy vấn (GraphQL, REST, SQL, RDF, JSON).
Registry First (Ưu tiên Cơ sở Định danh): Mọi đối tượng thuộc miền đều phải được bao đóng và định danh duy nhất thông qua một Registry chính thức trước khi tham gia vào các luồng nghiệp vụ.
Traceability by Design (Khả năng Truy vết Định sẵn): Mối quan hệ và vết liên kết sang các miền lân cận phải được thiết kế ngay từ cấu trúc lõi của meta-model dựa trên các kiểu quan hệ chuẩn tắc.
Canonical Vocabulary (Từ điển Thuật ngữ Chuẩn tắc): Sử dụng duy nhất một bộ từ vựng thống nhất, loại bỏ hoàn toàn hiện tượng đồng nghĩa dị nghĩa trên toàn hệ sinh thái sản phẩm.
Stable Identifier (Định danh Bền vững): Hệ thống định danh thực thể phải đảm bảo tính duy nhất toàn cục và không thay đổi theo thời gian, môi trường vật lý hay runtime.
Backward Compatibility (Tương thích Ngược): Các phiên bản nâng cấp của từng EGDS phải bảo toàn tính hợp lệ của dữ liệu lịch sử được quản lý bởi các phiên bản trước đó.
CHƯƠNG 4 — DOMAIN IDENTITY MODEL
Để đảm bảo khả năng gọi API, cấu hình hệ thống registry phân tán và tích hợp tự động hóa, mỗi Domain tham gia vào hệ sinh thái sản phẩm EGAL bắt buộc phải được đặc tả đầy đủ qua bộ thuộc tính **Domain Identity** định danh trừu tượng tĩnh sau:
Identifier (Mã định danh): Mã số chuẩn hóa dạng chuỗi ký tự cố định (e.g., EGDS-001).
Canonical Name (Tên chuẩn tắc): Tên định danh mang tính tường minh kỹ thuật (e.g., Requirement Domain Standard).
Namespace (Không gian tên): Không gian phân tách logic phân cấp dạng dot-notation phục vụ định tuyến API và lưu trữ (e.g., egal.requirement).
Short Name / Alias (Tên viết tắt / Bí danh): Chuỗi ký tự viết tắt viết hoa đại diện cho miền, tối ưu hóa cho các biểu thức logic tham chiếu (e.g., REQ).
CHƯƠNG 5 — DOMAIN CLASSIFICATION
Hệ thống Domain được phân rã thành 6 phân lớp chức năng cụ thể:
Core Domains: Miền lõi định vị các tính năng và giá trị nghiệp vụ trực tiếp cấu thành lõi của EGAL Platform (e.g., Requirement, Capability).
Shared Domains: Miền dùng chung cung cấp các cấu trúc dữ liệu và thực thể nền tảng cho nhiều miền khác kế thừa (e.g., Vocabulary Master, Common Datatypes).
Supporting Domains: Miền hỗ trợ mô hình hóa luồng dữ liệu và quản lý nghiệp vụ phụ trợ (e.g., Process, Data).
Platform Domains: Miền hạ tầng logic phục vụ riêng cho cơ chế vận hành nội tại của hệ thống EGAL Platform (e.g., Registry Engine, Notification).
Extension Domains: Miền mở rộng theo nhu cầu chuyên biệt của từng tổ chức, ngành dọc hoặc đối tác liên kết.
Experimental Domains: Miền thử nghiệm dành cho các nghiên cứu, tính năng mới (e.g., AI Research Sandbox) trước khi được xem xét phân loại chính thức.
CHƯƠNG 6 — ADMISSION CRITERIA (TIÊU CHÍ GIA NHẬP)
Một miền kiến thức hoặc một đề xuất tiêu chuẩn chỉ được phép phê duyệt và tích hợp vào EGDS Catalog nếu đáp ứng đầy đủ tất cả các tiêu chí ngặt nghèo sau:
Phạm vi rõ ràng (Clear Scope Boundary): Có ranh giới nghiệp vụ tường minh, không chồng lấn hay trùng lặp với bất kỳ Domain nào đã tồn tại trong Catalog. Tránh triệt để hiện tượng phân rã thừa (ví dụ: cấm tách rời Person Domain và Human Domain nếu không chứng minh được sự khác biệt logic cấu trúc).
Sở hữu vai trò quản trị (Explicit Governance Roles): Phải được chỉ định rõ vai trò chịu trách nhiệm quản trị (Stewardship Roles) theo quy định tại Chương 7, loại bỏ toàn bộ thông tin cá nhân/đội nhóm runtime vật lý.
Sẵn sàng về Registry (Registry Availability): Có thiết kế cơ chế bao đóng dữ liệu và schema Registry tương thích với nền tảng.
Từ điển chuẩn tắc (Canonical Vocabulary): Sở hữu bộ từ vựng đã được chuẩn hóa và không xung đột thuật ngữ toàn cục.
Khả năng liên vết (Traceability Readiness): Xác định rõ các vector liên kết hướng vào và hướng ra với các miền lân cận.
Hiện diện kịch bản sử dụng (Valid Use Cases): Chứng minh bằng tối thiểu 3 kịch bản ứng dụng thực tế trong kiến trúc doanh nghiệp.
CHƯƠNG 7 — DOMAIN CATALOG
Bảng tổng hợp đăng ký siêu dữ liệu (Metadata) quản lý danh mục sản phẩm. Toàn bộ các thông tin về Owner vật lý đã được tổng quát hóa thành các **Owner Roles** mang tính kiến trúc tĩnh, đảm bảo Catalog độc lập với các biến động nhân sự hay tái cấu trúc tổ chức tại runtime:
Identifier
Canonical Name
Namespace
Alias
Classification
Owner Role (Stewardship)
 
EGDS-001
Requirement Domain Standard
egal.requirement
REQ
Core Domain
Domain Steward
EGDS-002
Capability Domain Standard
egal.capability
CAP
Core Domain
Domain Steward
EGDS-003
Decision Domain Standard
egal.decision
DEC
Core Domain
Architecture Authority
EGDS-004
Policy Domain Standard
egal.policy
POL
Supporting Domain
Domain Steward
EGDS-005
Risk Domain Standard
egal.risk
RSK
Supporting Domain
Domain Steward
EGDS-006
Process Domain Standard
egal.process
PRO
Supporting Domain
Domain Steward
EGDS-007
Data Domain Standard
egal.data
DAT
Supporting Domain
Domain Steward
EGDS-008
Application Domain Standard
egal.application
APP
Supporting Domain
Domain Steward
EGDS-009
Evidence Domain Standard
egal.evidence
EVI
Supporting Domain
Platform Authority
EGDS-010
Vocabulary Master Standard
egal.shared.vocabulary
VOC
Shared Domain
Architecture Authority
EGDS-011
Registry Engine Standard
egal.platform.registry
RGE
Platform Domain
Platform Authority
CHƯƠNG 8 — DEPENDENCY MAP (GRAPH ARCHITECTURE)
Bản đồ phụ thuộc logic vĩ mô giữa các Domain được mô hình hóa toán học chặt chẽ dưới dạng Directed Acyclic Graph (DAG - Đồ thị có hướng không chu trình) nhằm loại bỏ hoàn toàn các chuỗi tuyến tính đơn giản hoặc nguy cơ lặp vòng lặp vô hạn hệ thống:
          Requirement (EGDS-001)               │       ┌───────┴───────┐       ▼               ▼  Capability       Decision (EGDS-003)  (EGDS-002)           │       │               ▼       │            Policy (EGDS-004)       │               │       └───────┬───────┘               ▼            Process (EGDS-006)               │               ▼          Application (EGDS-008)    
CHƯƠNG 9 — DOMAIN INTERACTION MODEL & RELATIONSHIP TYPES
Hệ thống loại bỏ tư duy mô tả Interaction dưới dạng luồng công việc hay workflow nghiệp vụ động. Tại mức kiến trúc sản phẩm Level 6, tương tác giữa các miền được xác lập bằng việc định nghĩa các **Relationship Types (Kiểu quan hệ cấu trúc)** chuẩn hóa đóng vai trò là xương sống cho ma trận Traceability:
9.1. Các Kiểu Quan hệ Cấu trúc Chuẩn hóa (Standard Relationship Types)
dependsOn: Biểu thị sự phụ thuộc logic tồn tại bắt buộc giữa hai thực thể miền.
references: Tham chiếu thông tin hoặc ngữ cảnh không ràng buộc vòng đời giữa các đối tượng.
realizes: Hiện thực hóa một khái niệm trừu tượng tầng trên xuống một thực thể cụ thể tầng dưới.
constrains: Ràng buộc, giới hạn hoặc quy định hành vi biên của thực thể đích.
produces: Sinh ra hoặc tạo mới một thực thể kết quả từ quá trình vận hành của một thực thể gốc.
consumes: Tiêu thụ, sử dụng đầu vào hoặc triệt tiêu thực thể đích.
governs: Quản trị, kiểm soát quyền hạn và cấu hình của miền mục tiêu.
9.2. Biểu diễn Mối quan hệ giữa các Thực thể Miền (Domain-to-Domain Semantic Links)
Mô hình tương tác ngữ nghĩa giữa các miền được mô tả thông qua các bộ ba (predicates) chặt chẽ:
* Requirement ──[references]──> Capability* Policy ───────[constrains]──> Process* Process ──────[produces]────> Evidence* Risk ─────────[mitigatedBy]─> Control* Decision ─────[governs]─────> Core/Supporting Domains    
CHƯƠNG 10 — REGISTRY INTEGRATION & TRACEABILITY SEPARATION
EGDS Catalog thực hiện tách biệt rạch ròi hai khái niệm quản trị dữ liệu nhằm đảm bảo tính phân lớp triệt để:
Registry Engine (Identity Layer): Chịu trách nhiệm bao đóng, cấp phát và quản lý danh tính thực thể dựa trên các siêu dữ liệu tĩnh trừu tượng như: Persistent Identifier, Universal Identifier, và Canonical Reference.
Traceability Framework (Relationship Layer): Hoạt động độc lập trên lớp Identity, chịu trách nhiệm thiết lập, kết xuất đồ thị quan hệ và kiểm tra tính liên vết xuyên suốt dựa trên các Relationship Types quy định tại Chương 9.
CHƯƠNG 11 — DUAL LIFECYCLE MODEL
Nhằm loại bỏ sự nhập nhằng giữa tài liệu mô tả kỹ thuật và trạng thái vận hành thực tế của bản thân miền kiến thức đó, EGAL Platform áp dụng mô hình vòng đời đôi (Dual Lifecycle):
11.1. Document Lifecycle (Vòng đời Tài liệu Đặc tả Tiêu chuẩn)
Quản lý trạng thái phê duyệt của văn bản EGDS-XXX biên soạn bởi các đội ngũ kỹ sư:
Draft ──> Review ──> Approved ──> Deprecated ──> Archived
11.2. Domain Lifecycle (Vòng đời Vận hành của Miền Kiến trúc)
Quản lý trạng thái tồn tại và hiệu lực áp dụng của bản thân miền đối tượng đó trong lõi runtime của sản phẩm:
Proposed ──> Candidate ──> Official ──> Legacy ──> Retired
CHƯƠNG 12 — CANONICAL DOMAIN CONTRACT
Mọi tài liệu EGAL Domain Standard (EGDS) khi xây dựng cấu trúc chi tiết bắt buộc phải tuân thủ và triển khai đầy đủ 12 mục thành phần cấu thành cấu trúc chuẩn dưới đây (Hợp đồng Kiến trúc Giao diện):
STT
Thành phần Hợp đồng (Contract Item)
Yêu cầu Đặc tả Chi tiết trong từng EGDS
 
1
Purpose
Mục tiêu chuẩn hóa của riêng miền chuyên ngành.
2
Scope
Ranh giới và các đối tượng thuộc quyền quản lý của miền.
3
Vocabulary
Bộ từ điển thuật ngữ chi tiết của riêng miền đó.
4
Concept Model
Mô hình khái niệm vĩ mô giải thích cho người đọc nghiệp vụ.
5
Meta-model
Mô hình thực thể quan hệ logic chuẩn tắc (Canonical) của miền.
6
Registry Schema
Cấu trúc bao đóng, lưu trữ và định nghĩa siêu dữ liệu định danh thực thể.
7
Validation Rules
Tập các quy tắc logic toán học phục vụ việc thẩm định tính hợp lệ tĩnh.
8
Traceability Rules
Quy định rõ cấu trúc liên kết và ánh xạ sang các Registry của miền khác.
9
Governance Rules
Quy trình phê duyệt, cập nhật dữ liệu và kiểm soát thẩm quyền miền.
10
Extension Model
Các điểm cắm (Extension Points) cho phép cấu hình riêng biệt tại miền.
11
Versioning Policy
Nguyên tắc quản lý xung đột cấu trúc khi nâng cấp phiên bản miền.
12
Conformance Statement
Bản tuyên bố tuân thủ tiêu chuẩn, làm rõ: Conformance Criteria, Conformance Evidence, và Assessment Method.
CHƯƠNG 13 — PRIORITY CLASSES & CONFORMANCE
13.1. Phân lớp Ưu tiên Kiến trúc (Priority Classes)
Mandatory (Bắt buộc Khởi tạo): Nhóm sản phẩm lõi nền tảng phải hoàn thành lập tức để kích hoạt hệ thống: EGDS-001 (Requirement), EGDS-002 (Capability), EGDS-003 (Decision).
Recommended (Khuyến nghị Tích hợp): Nhóm sản phẩm hỗ trợ vận hành tối ưu hóa: EGDS-004 (Policy), EGDS-006 (Process), EGDS-007 (Data).
Optional (Tùy chọn Mở rộng): Nhóm module chuyên biệt tùy thuộc vào mô hình triển khai: EGDS-005 (Risk), EGDS-008 (Application).
Future (Lộ trình Tương lai): Các miền nghiên cứu và phát triển dài hạn: EGDS-009 (Evidence) cùng các module thuộc phân lớp Experimental Domains.
13.2. Linh hoạt hóa Khung Thẩm định Tuân thủ (Conformance Framework)
Loại bỏ cơ chế Questionnaire bảng hỏi bắt buộc cứng nhắc. Cơ chế kiểm tra tuân thủ được đánh giá động dựa trên 3 trụ cột:
Conformance Criteria: Bộ tiêu chí định lượng logic cụ thể trích xuất từ cấu trúc miền.
Conformance Evidence: Các bằng chứng kiến trúc thực tế được xuất ra từ Registry Layer.
Assessment Method: Phương thức thẩm tra tự động hoặc bán tự động thông qua việc biên dịch và khớp nối đồ thị DAG.