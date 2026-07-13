Table of Contents


KCAT-001 — Knowledge Catalog Specification
EGAL KOS Foundation Specification
PATH: /home/workdir/artifacts/KCAT-001_Knowledge_Catalog_Specification_v1.0_Draft.mdDATETIME: 2026-07-07 13:25 +07VERSION: v1.0 (Draft for Review)STATUS: Draft – Ready for Architecture Review toward Frozen Baseline v1.0ARTIFACT TYPE: Foundation SpecificationTARGET BASELINE: v1.0 FrozenAUTHOR: QuangAGS + Grok (EGAL KOS Documentation Series)RELATED DOCUMENTS:- KINV-001 v1.0 Frozen – Knowledge Inventory Specification- CORE-000 → CORE-007 (EGAL KOS Core Standards)- Product Realization Charter

Big Picture Overview
CORE-000 → CORE-007        │        ▼Product Realization Charter        │        ▼KINV-001(How to build Repository)        │        ▼KCAT-001(How Repository is represented)        │        ▼Inventory Architecture Bible        │        ▼Knowledge Repository        │        ▼Working Context Assembly        │        ▼Product Realization (myclan.com.vn & EGAL KOS Products)
KCAT-001 là lớp Foundation Specification cuối cùng cần thiết để hoàn tất tầng Foundation của Knowledge Repository.

1. Purpose (Normative)
KCAT-001 định nghĩa mô hình chuẩn của Knowledge Catalog dùng để lưu trữ, tổ chức, quản trị và truy vấn toàn bộ Knowledge Objects của EGAL KOS.
KCAT-001 không: - Định nghĩa cách inventory (đó là KINV-001). - Định nghĩa ontology. - Định nghĩa Product Mapping. - Định nghĩa quy trình inventory.
KCAT-001 chỉ định nghĩa:
Repository được biểu diễn như thế nào.
Cấu trúc, schema, views, query model và quy tắc quản trị của Knowledge Catalog.
Điều kiện để một Catalog được coi là KCAT-compliant.
Mục tiêu cuối cùng là tạo ra một biểu diễn chuẩn, ổn định, có thể truy vấn và có thể tiêu thụ của Knowledge Repository.
2. Objectives (Normative)
KCAT-001 phải đạt được các mục tiêu sau:
Lưu trữ toàn bộ Knowledge Objects cùng với metadata đầy đủ.
Lưu trữ Relationships giữa các Knowledge Objects một cách rõ ràng và có quy tắc.
Lưu trữ Deep References và Traceability (bao gồm Impact Traceability).
Hỗ trợ Versioning và Lifecycle management của Knowledge Objects và Relationships.
Hỗ trợ Verification và Confidence level.
Cho phép Query theo nhiều chiều (ID, Type, Domain, Source, Relationship, Impact…).
Hỗ trợ Change Impact Analysis.
Hỗ trợ Working Context Assembly tiêu thụ trực tiếp.
Đảm bảo Determinism — hai nhóm độc lập xây dựng Catalog từ cùng một tập Knowledge Objects phải tạo ra kết quả tương đương về mặt ngữ nghĩa.
Giữ tính Repository Neutral và Implementation Independent.
3. Scope (Normative)
In Scope:
Knowledge Object Record
Knowledge Source metadata
Knowledge Identity (Canonical ID)
Relationships
Knowledge Metadata
Traceability (Forward, Backward, Cross-document, Impact)
Verification & Confidence
Catalog Views
Query Model
Versioning & Deprecation
Validation Rules
Change Management
Out of Scope:
Ontology
Inventory Process (KINV-001)
Logical Architecture
Physical Implementation
Storage Engine / Database
API / UI
Specific serialization format (JSON, RDF, etc.)
4. Guiding Principles (Normative)
Catalog is Repository Representation — Repository không phải là folder hay collection document. Repository được thể hiện qua Catalog.
Everything is Metadata Driven — Catalog không lưu document. Catalog lưu metadata và relationships.
Knowledge Object First — Document chỉ là nguồn. Knowledge Object là trung tâm của Catalog.
Immutable Canonical Identity — Canonical ID không bao giờ thay đổi sau khi Record được tạo.
Relationship First — Relationships là công dân hạng nhất trong Catalog, không phải thuộc tính phụ.
Traceability by Default — Mọi Record phải có traceability đầy đủ (bao gồm Impact).
Deterministic Query — Cùng một tập Knowledge Objects phải cho ra Catalog có cấu trúc ngữ nghĩa tương đương, không phụ thuộc vào thứ tự xử lý.
Incremental Evolution — Catalog được xây dựng và mở rộng theo từng bước, hỗ trợ feedback loop.
Non-destructive — Việc cập nhật Catalog không làm mất lịch sử hoặc traceability.
Repository Neutral — Catalog không phụ thuộc vào bất kỳ cơ sở dữ liệu, storage engine hay công nghệ cụ thể nào.
Implementation Independent — Catalog schema và model phải có thể triển khai bằng nhiều công nghệ khác nhau mà vẫn giữ được ngữ nghĩa.
Human + AI Readable — Catalog phải dễ đọc và khai thác bởi con người lẫn các công cụ tự động / AI.
5. Knowledge Catalog Model (Normative)
5.1 Cấu trúc tổng thể
Knowledge Catalog    ├── Knowledge Object Records (1..n)    ├── Relationships (0..n)    ├── Catalog Views (multiple)    └── Query Interface
5.2 Knowledge Object Record
Mỗi Knowledge Object trong Catalog được biểu diễn bằng một và chỉ một Knowledge Object Record.
Knowledge Object Record bao gồm các nhóm thông tin sau:
Identity
Classification
Authority & Ownership
Lifecycle & Version
Verification
References
Relationships
Impact
Metadata

6. Knowledge Object Record – Field Specification (Normative)
Dưới đây là đặc tả chi tiết từng field.
6.1 Core Identity Fields
Field
Purpose
Cardinality
Required
Allowed Values
Validation Rules
Canonical ID
Danh tính duy nhất và bất biến của KO
1
Yes
KINV---
Không được thay đổi sau khi tạo. Phải unique toàn Catalog.
Name
Tên ngắn gọn, rõ ràng bằng tiếng Việt
1
Yes
String
Nên ≤ 120 ký tự
Description
Mô tả ngắn gọn mục đích và nội dung của KO
0..1
No
String
Nên ≤ 500 ký tự
6.2 Classification Fields
Field
Purpose
Cardinality
Required
Allowed Values
Validation Rules
Type
Loại Knowledge Object
1
Yes
Theo Taxonomy KINV-001
Phải là một giá trị hợp lệ trong Taxonomy
Domain
Lĩnh vực / phạm vi áp dụng
1
Yes
Governance, Architecture, Product, Technical, Implementation, Verification, UX, Security…
Phải là một Domain đã định nghĩa
6.3 Authority & Ownership
Field
Purpose
Cardinality
Required
Allowed Values
Validation Rules
Authority
Nguồn authority (tài liệu nguồn + section)
1
Yes
String (Deep Reference)
Phải trỏ đến tài liệu đã phê duyệt
Owner
Người/vai trò chịu trách nhiệm về KO
1
Yes
String
—
Source
Knowledge Source chứa KO gốc
1
Yes
Identifier của Knowledge Source
Phải tồn tại trong danh sách Knowledge Sources đã đăng ký
6.4 Lifecycle & Version
Field
Purpose
Cardinality
Required
Allowed Values
Validation Rules
Status
Trạng thái hiện tại trong Lifecycle
1
Yes
Identified, Normalized, Reviewed, Approved, Deprecated, Retired
Chỉ chuyển theo Transition Rules của KINV-001
Version
Phiên bản của Record
1
Yes
Semantic Versioning (Major.Minor.Patch)
Tăng khi có thay đổi ngữ nghĩa
Created
Thời điểm Record được tạo
1
Yes
ISO 8601 Timestamp
—
Modified
Thời điểm Record được sửa đổi gần nhất
1
Yes
ISO 8601 Timestamp
Cập nhật mỗi khi có thay đổi
Deprecated Date
Thời điểm bị Deprecated (nếu có)
0..1
No
ISO 8601 Timestamp
Bắt buộc nếu Status = Deprecated
Superseded By
Canonical ID của KO thay thế (nếu có)
0..1
No
Canonical ID
Bắt buộc nếu Status = Deprecated
6.5 Verification
Field
Purpose
Cardinality
Required
Allowed Values
Validation Rules
Verification Status
Mức độ kiểm chứng hiện tại
1
Yes
Verified, Validated, Observed, Needs Review, Deprecated
—
Confidence Level
Mức độ tin cậy chủ quan
0..1
No
High, Medium, Low
—
Last Verified
Thời điểm verification gần nhất
0..1
No
ISO 8601 Timestamp
—
Verified By
Người/vai trò thực hiện verification
0..1
No
String
—
6.6 References
Field
Purpose
Cardinality
Required
Allowed Values
Validation Rules
Deep Reference
Tham chiếu sâu đến vị trí chính xác trong nguồn
1
Yes
String (theo quy tắc KINV-001)
Phải có khả năng resolve hoặc có trạng thái hợp lệ
Source Document
Tài liệu nguồn gốc
1
Yes
Identifier
Phải là Knowledge Source đã đăng ký
6.7 Relationships
Field
Purpose
Cardinality
Required
Allowed Values
Validation Rules
Relationships
Danh sách các quan hệ với KO khác
0..n
No
Danh sách Relationship Record
Tuân thủ Relationship Model tại Section 7
6.8 Impact
Field
Purpose
Cardinality
Required
Allowed Values
Validation Rules
Impact
Thông tin về phạm vi ảnh hưởng khi thay đổi
0..1
No
Structured Impact Data
Nên có khi KO được sử dụng rộng rãi

7. Relationship Representation (Normative)
Mỗi Relationship trong Catalog phải được biểu diễn dưới dạng Relationship Record với các thông tin sau:
Field
Purpose
Cardinality
Required
Allowed Values
Validation Rules
Relationship Type
Loại quan hệ (derivesFrom, implements…)
1
Yes
Theo danh sách KINV-001
Phải là loại đã định nghĩa
Direction
Chiều quan hệ
1
Yes
Outgoing / Incoming
—
Source KO
Canonical ID của KO nguồn
1
Yes
Canonical ID
Phải tồn tại trong Catalog
Target KO
Canonical ID của KO đích
1
Yes
Canonical ID
Phải tồn tại trong Catalog
Multiplicity
Số lượng (1, 0..1, 0..n, 1..n)
1
Yes
Theo định nghĩa quan hệ
—
Confidence
Mức độ tin cậy của quan hệ
0..1
No
High / Medium / Low
—
Authority
Nguồn authority của quan hệ
0..1
No
String
—
Reason
Lý do thiết lập quan hệ
0..1
No
String
—
Valid From
Thời điểm quan hệ có hiệu lực
0..1
No
ISO 8601
—
Valid Until
Thời điểm quan hệ hết hiệu lực
0..1
No
ISO 8601
—
Quy tắc bắt buộc: - Không được có Relationship orphan (Source hoặc Target KO không tồn tại). - Không được có circular Relationship trừ khi loại quan hệ cho phép. - Hướng trừu tượng phải tuân thủ quy tắc đã định nghĩa trong KINV-001.

8. Catalog Views (Normative)
Catalog không chỉ có một view. Nó phải hỗ trợ nhiều góc nhìn khác nhau:
View
Mô tả
Use Case chính
Object View
Tập trung vào Knowledge Object Record
Truy vấn chi tiết một KO
Source View
Nhóm KO theo Knowledge Source
Audit nguồn gốc
Domain View
Nhóm KO theo Domain
Review theo Domain Owner
Type View
Nhóm KO theo Type
Thống kê phân loại
Relationship View
Biểu đồ / danh sách Relationships
Phân tích liên kết
Impact View
Hiển thị Impact Traceability
Change Impact Analysis
Verification View
Trạng thái Verification của các KO
Chất lượng Repository
Lifecycle View
Phân bố trạng thái Lifecycle
Quản lý vòng đời
Owner View
Nhóm theo Owner
Phân quyền & trách nhiệm
Working Context View
Các KO phù hợp để sử dụng trong một Working Context cụ thể
Working Context Assembly
Product View
Các KO liên quan đến một Product / Feature cụ thể
Product Realization
Mỗi View phải có thể được truy vấn độc lập mà vẫn đảm bảo tính nhất quán của Catalog.

9. Query Model (Normative)
Catalog phải hỗ trợ truy vấn theo các tiêu chí sau (ít nhất):
Canonical ID (exact match)
Type
Domain (single hoặc multiple)
Source / Knowledge Source
Relationship Type + Target
Verification Status
Authority / Owner
Lifecycle Status
Impact (có ảnh hưởng đến Product / LPA / Context cụ thể)
Full-text search trên Name + Description (khuyến khích)
Combination (AND / OR) của các tiêu chí trên
Determinism yêu cầu: Cùng một tập KO và cùng một tập truy vấn phải cho ra kết quả tương đương về mặt ngữ nghĩa, không phụ thuộc vào thứ tự xử lý hoặc công nghệ triển khai.

10. Change Management (Normative)
Catalog phải hỗ trợ các loại thay đổi sau:
KO Update — Cập nhật metadata, verification, impact (không thay đổi Canonical ID)
Relationship Update — Thêm / sửa / xóa Relationship
Reference Update — Cập nhật Deep Reference khi tài liệu nguồn thay đổi
Deprecation — Đánh dấu KO là Deprecated + trỏ đến KO thay thế
Supersession — Thay thế hoàn toàn một KO bằng KO khác
Merge — Gộp hai KO thành một (tạo KO mới + deprecated hai KO cũ)
Split — Tách một KO thành nhiều KO mới
Retire — Loại bỏ hoàn toàn KO khỏi Catalog (chỉ trong trường hợp đặc biệt)
Mọi thay đổi phải được ghi nhận với: - Thời điểm - Người thực hiện - Lý do - Version tăng tương ứng

11. Versioning (Normative)
Catalog Version: Toàn bộ Catalog có phiên bản (Semantic Versioning).
Record Version: Mỗi Knowledge Object Record có phiên bản riêng.
Relationship Version: Mỗi Relationship có thể có phiên bản.
Reference Version: Deep Reference có lịch sử thay đổi.
Khi Major version của Catalog tăng → cần review lại toàn bộ Validation Rules và Conformance.

12. Validation Rules (Normative)
Catalog phải tuân thủ các quy tắc kiểm tra hợp lệ sau (ít nhất):
Không có duplicate Canonical ID.
Không có orphan Relationship (Source hoặc Target KO không tồn tại trong Catalog).
Deep Reference phải có khả năng resolve hoặc có trạng thái hợp lệ.
Không có circular Relationship trừ khi loại quan hệ cho phép.
Mọi KO phải có đúng một Canonical Record.
Transition giữa các trạng thái Lifecycle phải tuân thủ Transition Rules.
Relationship Type phải là loại đã được định nghĩa trong KINV-001.
Owner phải là giá trị hợp lệ trong danh sách Owner đã đăng ký.
Verification Status phải phù hợp với trạng thái Lifecycle.
Không được mất traceability khi thực hiện Merge / Split / Deprecation.

13. Catalog Quality (Normative)
Knowledge Catalog phải đạt các tiêu chí chất lượng sau:
Completeness — Bao quát được toàn bộ Knowledge Objects đã được approve từ KINV-001.
Consistency — Không có mâu thuẫn giữa Record, Relationship và Traceability.
Traceability — Forward + Backward + Impact traceability đầy đủ.
Relationship Integrity — Không orphan, không circular (trừ khi cho phép), multiplicity đúng.
Identity Stability — Canonical ID không thay đổi sau khi tạo.
Reference Stability — Deep Reference có cơ chế xử lý khi nguồn thay đổi.
Queryability — Hỗ trợ truy vấn theo mọi chiều đã định nghĩa.
Determinism — Kết quả query và Catalog structure có tính dự đoán được.
Auditability — Mọi thay đổi đều được ghi nhận đầy đủ.
Repository Integrity — Catalog phản ánh đúng trạng thái của Knowledge Repository tại mọi thời điểm.

14. Working Context Readiness (Normative)
Một Knowledge Catalog được coi là sẵn sàng cho Working Context Assembly khi đạt được các điều kiện sau:
100% Knowledge Object đã Approved đều có Canonical Record hợp lệ.
Tất cả Relationships cần thiết cho Working Context đã được biểu diễn đầy đủ.
Verification Status của các KO liên quan ở mức Validated trở lên.
Impact Traceability đã được cập nhật.
Deep Reference của các KO liên quan đều có khả năng resolve.
Có ít nhất một Catalog View phù hợp với Working Context (Working Context View).

15. Acceptance Criteria for Freeze (Normative)
KCAT-001 chỉ được phép Freeze thành v1.0 khi đồng thời thỏa mãn các tiêu chí sau:
✓ Mô hình Catalog hoàn chỉnh, bao quát toàn bộ thành phần của Knowledge Repository.✓ Knowledge Object Record được chuẩn hóa, mỗi field có ngữ nghĩa và quy tắc rõ ràng.✓ Relationship Model đầy đủ, hỗ trợ mọi quan hệ đã định nghĩa trong KINV-001.✓ Metadata Schema nhất quán, không chồng chéo hoặc mâu thuẫn.✓ Query Model đầy đủ, hỗ trợ truy vấn theo ID, Domain, Type, Source, Relationship, Impact…✓ Traceability toàn diện (Forward, Backward, Cross-document và Impact).✓ Versioning & Lifecycle được quản lý rõ ràng, giữ tính ổn định của Repository.✓ Validation Rules đầy đủ, có thể kiểm tra tính hợp lệ của Catalog một cách tự động hoặc bán tự động.✓ Working Context Readiness đạt yêu cầu — Catalog đủ thông tin để Working Context Assembly tiêu thụ trực tiếp.✓ AI Readiness — Catalog có cấu trúc ổn định để AI và công cụ tự động khai thác.✓ Determinism — Hai nhóm độc lập xây dựng Catalog từ cùng một tập Knowledge Objects sẽ tạo ra các Catalog tương đương về mặt ngữ nghĩa.✓ Repository Neutrality — Không phụ thuộc vào cơ sở dữ liệu, API hay công nghệ lưu trữ cụ thể.✓ Không mở rộng scope ra ngoài Foundation (không bổ sung ontology, inventory process hay implementation).✓ Hoàn toàn tương thích và không mâu thuẫn với KINV-001 v1.0 Frozen và CORE Standards.✓ Có thể serialize, version, audit và hỗ trợ Change Impact Analysis.✓ Có thể biểu diễn mọi Knowledge Object đã được approve mà không mất thông tin.

16. Conformance (Normative)
Một Knowledge Repository được coi là KCAT-compliant khi:
Mọi Knowledge Object đã được approve đều được biểu diễn bằng đúng một Catalog Record.
Mọi Relationship đều được biểu diễn đầy đủ và tuân thủ Relationship Model.
Mọi Canonical ID là duy nhất và ổn định (không bao giờ thay đổi sau khi tạo).
Mọi Deep Reference đều có khả năng resolve hoặc có trạng thái hợp lệ được ghi nhận.
Catalog hỗ trợ đầy đủ truy vấn, traceability (bao gồm Impact), versioning, verification và change management.
Hai nhóm độc lập xây dựng Catalog từ cùng một tập Knowledge Objects sẽ tạo ra các Catalog tương đương về mặt ngữ nghĩa, không phụ thuộc vào cách triển khai cụ thể (determinism).

Informative Appendices
Appendix A: Metamodel (Textual)
Knowledge Catalog    ├── Knowledge Object Record    │       ├── Identity (Canonical ID)    │       ├── Classification (Type × Domain)    │       ├── Authority & Ownership    │       ├── Lifecycle & Version    │       ├── Verification    │       ├── References (Deep Reference)    │       ├── Relationships    │       └── Impact    ├── Relationship Records    ├── Catalog Views (multiple perspectives)    └── Query Model
Appendix B: Ví dụ Knowledge Object Record (Informative)
(Sẽ được bổ sung chi tiết sau khi có dữ liệu inventory thực tế từ Architecture Bible)
Appendix C: Glossary
Knowledge Catalog: Biểu diễn chuẩn của Knowledge Repository.
Knowledge Object Record: Bản ghi duy nhất đại diện cho một Knowledge Object trong Catalog.
Catalog View: Một góc nhìn (perspective) cụ thể lên Catalog.
Determinism: Khả năng hai nhóm độc lập thu được kết quả tương đương về mặt ngữ nghĩa.

Kết thúc KCAT-001 v1.0 Draft
Tài liệu này đã được xây dựng theo đúng đặc tả và tiêu chí nghiệm thu mà bạn đã đề ra. Đây là lớp Foundation Specification cuối cùng cần thiết để hoàn tất tầng Foundation của EGAL Knowledge Operating System.
Sau khi KCAT-001 được đóng băng, toàn bộ các bước tiếp theo chỉ còn là hiện thực hóa (realization) trên nền tảng đã chuẩn hóa.