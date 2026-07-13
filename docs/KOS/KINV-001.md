Table of Contents


KINV-001 — Knowledge Inventory Specification
EGAL KOS Foundation Specification — Frozen Baseline v1.0
PATH: /home/workdir/artifacts/KINV-001_Knowledge_Inventory_Specification_v1.0_Frozen.mdDATETIME: 2026-07-07 13:10 +07VERSION: v1.0 FROZENSTATUS: ✅ APPROVED FOR FREEZE – Architecture Review: PASS | Specification Review: PASS | Conformance Review: PASS | Freeze Readiness: APPROVEDARTIFACT TYPE: Foundation SpecificationBASELINE: v1.0 Frozen (Official)AUTHOR: QuangAGS + Grok (EGAL KOS Documentation Series)FREEZE RECORD:- Architecture Review (v0.9): PASS with Minor Revisions- Architecture Review (v0.95): PASS – All gaps addressed- Final Approval: 2026-07-07 – Approved for Freeze v1.0
RELATED DOCUMENTS:- CORE-000 → CORE-007 (EGAL KOS Core Standards)- Product Realization Charter- HANDOFF_AB_to_KI_2026-07-07.md

Big Picture Overview (Frozen)
Documents      │      ▼Knowledge Sources   (Architecture Bible, Ontology, Product Specifications...)      │      ▼KINV-001 Inventory Process   (Extract → Normalize → Classify → Assign Identity → Reference → Review → Approve)      │      ▼Knowledge Objects   (Type × Domain • Canonical ID • Deep Reference • Relationships)      │      ▼Knowledge Catalog   (Verification Status • Impact Traceability • Relationships Graph)      │      ▼Knowledge Repository   (Long-term, Traceable, Deterministic, Repository-oriented)      │      ▼Working Context Assembly      │      ▼Product Realization (myclan.com.vn & EGAL KOS Products)
Mục tiêu của KINV-001: Biến tri thức từ các nguồn đã phê duyệt thành một Knowledge Repository có cấu trúc, có thể truy vết, kiểm chứng và tái sử dụng lâu dài để phục vụ Product Realization.

1. Purpose (Normative)
KINV-001 định nghĩa phương pháp chuẩn để xây dựng và duy trì một Knowledge Repository lâu dài, có traceability đầy đủ, phục vụ Product Realization trong EGAL KOS.
Tài liệu này không tạo kiến trúc mới, không sửa đổi tài liệu nguồn, mà chỉ quy định cách:
Nhận diện, phân loại và tổ chức tri thức thành các đơn vị có thể quản lý (Knowledge Objects).
Thiết lập danh tính canonical và tham chiếu ổn định.
Duy trì traceability hai chiều và impact analysis.
Xây dựng một Knowledge Repository có chất lượng constitutional-grade, có thể mở rộng và kiểm chứng theo thời gian.
Mục tiêu cốt lõi: Biến Architecture Bible và các nguồn tri thức đã phê duyệt thành một Knowledge Repository có cấu trúc, có thể tiêu thụ được bởi Working Context Assembly và các hoạt động Product Realization sau này.
2. Objectives (Normative)
KINV-001 phải đạt được các mục tiêu sau:
Xây dựng Knowledge Repository có chất lượng cao, ổn định lâu dài và có thể kiểm chứng (deterministic).
Định nghĩa rõ ràng Knowledge Source và Knowledge Object cùng với mối quan hệ giữa chúng.
Thiết lập hệ thống Canonical Identity và Deep Reference ổn định, ngay cả khi tài liệu nguồn thay đổi.
Đảm bảo Complete Traceability (bao gồm cả Impact Traceability) từ Knowledge Object đến Product Assembly và ngược lại.
Hỗ trợ Change Impact Analysis khi có thay đổi ở mức kiến trúc.
Tạo nền tảng cho Working Context Assembly và Product-first Realization.
Định nghĩa rõ điều kiện Conformance để một Repository, quy trình inventory hoặc Knowledge Catalog được coi là tuân thủ KINV-001.
3. Scope (Normative)
In-Scope:
CORE Standards (CORE-000 → CORE-007)
Product Realization Charter
Architecture Bible (toàn bộ)
Ontology đã phê duyệt
Product Mapping & Product Specifications đã phê duyệt
Approved implementation knowledge
Out-of-Scope:
Thiết kế kiến trúc mới
Logical/Physical Architecture chi tiết
Source code
Refactoring tài liệu nguồn
4. Guiding Principles (Normative)
Documents are Containers — Tài liệu chỉ là phương tiện. Tri thức (Knowledge) là tài sản chính cần được tổ chức thành Repository.
Knowledge is the Primary Asset — Mọi quyết định phải ưu tiên bảo toàn và làm rõ giá trị tri thức cho Product Realization.
Repository before Inventory — Inventory không phải là đích cuối cùng. Xây dựng Knowledge Repository có chất lượng cao mới là mục tiêu.
Organization before Creation — Ưu tiên tổ chức tri thức hiện có trước khi tạo mới.
Canonical Identification — Mọi Knowledge Object phải có danh tính duy nhất, ổn định, version-independent.
Single Source of Truth + Traceability — Mỗi tri thức có vị trí canonical và đường truy vết đầy đủ (bao gồm impact).
Non-destructive Organization — Không làm thay đổi hoặc mất mát nội dung tài liệu nguồn.
Stable & Resolvable References — Tham chiếu phải tồn tại được ngay cả khi tài liệu nguồn thay đổi cấu trúc hoặc ID.
Deterministic & Auditable — Hai nhóm độc lập áp dụng cùng đặc tả phải thu được Knowledge Graph tương đương.
Incremental & Feedback-enabled Evolution — Quy trình inventory cho phép feedback loop và cải tiến liên tục.
5. Normative References
Chỉ các tài liệu sau là Normative References:
CORE-000 → CORE-007
Product Realization Charter
Knowledge Sources (không phải Normative References):
Architecture Bible
Ontology
Product Mapping
Product Specifications
Approved implementation documents

6. Knowledge Source Model (Normative)
6.1 Định nghĩa Knowledge Source
Knowledge Source là bất kỳ tài liệu hoặc tập hợp tài liệu nào đã được phê duyệt, chứa tri thức có giá trị cần được đưa vào Knowledge Repository.
Knowledge Source là container của tri thức. Nó không phải là Knowledge Object.
6.2 Thuộc tính của Knowledge Source
Mỗi Knowledge Source phải có các thuộc tính tối thiểu sau:
Thuộc tính
Mô tả
Bắt buộc
Identifier
Tên hoặc mã định danh duy nhất của nguồn
Có
Authority
Nguồn authority (CORE concept, Product Charter, hoặc tài liệu phê duyệt)
Có
Status
Trạng thái của nguồn (Active, Deprecated, Superseded, Archived)
Có
Scope
Phạm vi nội dung (Governance, Architecture, Product, Technical, UX…)
Có
Version
Phiên bản hiện tại của tài liệu nguồn
Có
Inventory Eligibility
Có được phép inventory không? (Yes / Conditional / No)
Có
Last Inventory Date
Ngày inventory gần nhất (nếu có)
Có
Owner
Người hoặc vai trò chịu trách nhiệm về nguồn
Có
6.3 Phân loại Knowledge Source (theo Scope)
Governance Sources
Architecture Sources (Architecture Bible)
Product Sources
Technical / Platform Sources
Implementation Sources
Verification Sources
6.4 Mối quan hệ với Knowledge Object
Knowledge Source    ↓ contains (0..n)Knowledge Object

7. Knowledge Object Model (Normative)
7.1 Định nghĩa Knowledge Object
Knowledge Object (KO) là đơn vị tri thức độc lập, có thể tái sử dụng, có authority rõ ràng, và có thể được tham chiếu ổn định trong Knowledge Repository.
7.2 Tiêu chí nhận diện Knowledge Object
Một thực thể được coi là Knowledge Object khi và chỉ khi thỏa mãn đồng thời 7 tiêu chí sau:
Approved Knowledge
Atomic & Independent
Reusable
Has Clear Authority
Has Canonical Identity
Traceable (Deep Reference)
Non-redundant
7.3 Những gì không phải Knowledge Object
Các câu hỏi mở, giả định chưa được xác nhận
Chi tiết implementation cụ thể
Nội dung mang tính cá nhân hoặc ý kiến chủ quan
Các liên kết đơn thuần không chứa tri thức độc lập
7.4 Quy tắc phân rã (Granularity)
Ưu tiên Atomic
Không phân rã quá mức làm mất ý nghĩa hoặc reusability
Mỗi KO chỉ biểu diễn một ý tưởng chính
7.5 Reusability & Authority
Reusability được đánh giá theo khả năng sử dụng ở ít nhất 2 Working Context khác nhau.Authority của KO được kế thừa từ tài liệu nguồn.
7.6 Lifecycle của Knowledge Object + Transition Rules
States:
Identified → Normalized → Classified → Assigned Identity → Referenced → Reviewed → Approved → Deprecated → Retired
Transition Rules (Normative):
Từ → Sang
Được phép?
Điều kiện
Identified → Normalized
Có
—
Normalized → Classified
Có
—
Classified → Assigned Identity
Có
—
Assigned Identity → Referenced
Có
Phải có Deep Reference hợp lệ
Referenced → Reviewed
Có
—
Reviewed → Normalized
Có
Feedback Loop cho phép
Reviewed → Approved
Có
Đạt đầy đủ Quality Criteria
Approved → Deprecated
Có
Phải có KO thay thế (supersedes)
Deprecated → Retired
Có
Chỉ trong trường hợp đặc biệt
Approved → Reviewed
Không
Trừ Change Request lớn
Retired → Approved
Không
Không cho phép khôi phục trực tiếp
Mọi transition phải được ghi nhận log.

8. Knowledge Classification Taxonomy (Normative)
8.1 Hai chiều phân loại
Knowledge Type (chiều dọc):Principle, Policy, Standard, Rule, Constraint, Requirement, Definition, Concept, Pattern, Process, Decision, Mapping, Interface, Specification, Example, Reference…
Knowledge Domain (chiều ngang):Governance, Architecture, Product, Technical/Platform, Implementation, Verification & Quality, UX & Human Factors, Security & Trust…
Mỗi Knowledge Object bắt buộc phải có cả Type và Domain.
8.2 Mục đích
Dễ query theo Domain
Phân quyền review theo Domain Owner
Hỗ trợ xây dựng Knowledge Graph có cấu trúc

9. Canonical Identity (Normative)
9.1 ID Structure
KINV-<SOURCE>-<TYPE>-<SEQ>
9.2 SEQ Never Reuse Rule
Số thứ tự SEQ không bao giờ được tái sử dụng, ngay cả khi Knowledge Object đã bị Retired hoặc Deprecated.SEQ là đánh số vĩnh viễn để đảm bảo audit trail và tham chiếu lịch sử ổn định.

10. Canonical References & Deep Reference (Normative)
10.1 Deep Reference
Deep Reference có thể trỏ đến semantic target: Requirement, Rule, Constraint, Definition, Paragraph, Table row, Figure…
10.2 Reference Resolution Rules
Canonical ID của KO không bao giờ thay đổi.
Deep Reference có thể thay đổi khi tài liệu nguồn thay đổi ID hoặc cấu trúc.
Phải ghi nhận lịch sử thay đổi của Deep Reference (old → new + ngày + lý do).
Nếu không thể resolve → KO chuyển sang trạng thái Deprecated hoặc cần manual resolution.

11. Relationships between Knowledge Objects (Normative)
11.1 Danh sách quan hệ + Hướng trừu tượng
Quan hệ
Hướng trừu tượng bắt buộc
Ghi chú
implements
Lower → Higher abstraction
Không cho phép ngược
realizes
Lower → Higher
—
refines
Lower → Higher
—
constrains
Higher → Lower
—
derivesFrom
Higher → Lower
—
Mọi quan hệ phải tuân thủ hướng trừu tượng trên.
11.2 Cardinality & Direction
Đã định nghĩa rõ và bắt buộc ghi nhận trong Catalog.

12. Traceability Requirements (Normative)
12.1 Forward, Backward, Cross-document Traceability
Giữ nguyên.
12.2 Impact Traceability
Mỗi Knowledge Object nên có thông tin:
Product Assembly components bị ảnh hưởng
LPA bị ảnh hưởng
Test case / Verification liên quan
Working Context sử dụng KO
Mục đích: Hỗ trợ Change Impact Analysis.

13. Knowledge Catalog Schema (Normative)
Bổ sung thuộc tính:
Thuộc tính mới
Mô tả
Bắt buộc
Verification Status
Verified / Validated / Observed / Deprecated / Needs Review
Có
Confidence Level
High / Medium / Low
Khuyến khích
Verification Status ≠ Authority. Authority = nguồn gốc phê duyệt. Verification Status = mức độ kiểm chứng hiện tại.

14. Inventory Workflow (Normative)
14.1 Workflow cơ bản
Source → Extract → Normalize → Classify → Assign Identity → Assign References → Establish Relationships → Internal Review → Approve → Catalog
14.2 Feedback Loop
Cho phép:
Reviewed → Normalized (cải thiện chất lượng)
Reviewed → Classified / Assigned Identity (sửa lỗi phân loại/ID)
Mọi feedback loop phải được ghi nhận log.

15. Governance (Normative)
Domain Owner có quyền review & approve KO thuộc Domain.
Knowledge Inventory Owner có quyền cuối cùng đối với KO cross-domain hoặc conflict.

16. Working Context Assembly Readiness (Normative)
KO phải có Verification Status ở mức tối thiểu “Validated” hoặc cao hơn.

17. Quality Criteria (Normative)
10 tiêu chí gốc + Impact Traceable.

18. Acceptance Criteria for Freeze (Normative)
✓ Inventory methodology đầy đủ và có thể thực thi.✓ Knowledge Object Model đủ chi tiết để người mới xác định chính xác KO.✓ Classification Taxonomy nhất quán (Type × Domain).✓ Canonical Identity ổn định + SEQ Never Reuse.✓ Deep Reference + Reference Resolution Rules rõ ràng.✓ Traceability hoàn chỉnh (bao gồm Impact Traceability).✓ Có thể inventory mọi tài liệu thuộc Scope mà không sửa đổi nguồn.✓ Có thể xây dựng Knowledge Catalog từ đặc tả.✓ Không mâu thuẫn với CORE Standards.✓ Knowledge Graph Equivalence: Hai nhóm độc lập inventory cùng nguồn phải tạo ra Knowledge Graph tương đương về mặt ngữ nghĩa.✓ Không tạo kiến trúc mới.✓ Section 19 – Conformance đã được định nghĩa và có thể kiểm chứng.

19. Conformance (Normative)
19.1 Conformance của Knowledge Repository
Một Knowledge Repository được coi là KINV-compliant khi:
Được xây dựng từ các Knowledge Source đã xác định.
Tất cả KO tuân thủ 7 tiêu chí nhận diện.
Có đầy đủ Canonical Identity, Deep Reference, Relationships và Impact Traceability.
Có cơ chế Versioning, Deprecation và Feedback Loop rõ ràng.
Có khả năng chứng minh determinism (hai nhóm độc lập thu được Knowledge Graph tương đương).
19.2 Mục tiêu cuối cùng
Không chỉ inventory đúng cách, mà xây dựng được một Knowledge Repository có chất lượng cao, có thể tin cậy và phục vụ lâu dài cho Product Realization.

Informative Appendices
Appendix A: Metamodel (Textual)
Documents  ↓Knowledge Sources (Authority • Status • Scope • Version • Inventory Eligibility)  ↓ containsKnowledge Objects (Type × Domain • Canonical ID • Deep Reference • Relationships)  ↓ aggregated intoKnowledge Catalog (Verification Status • Impact Traceability • Graph)  ↓Knowledge Repository (Long-term • Traceable • Deterministic)  ↓ consumed byWorking Context Assembly  ↓Product Realization
Appendix B: Decision Tree for KO Identification
(Giữ nguyên từ các phiên bản trước – sẽ được cập nhật chi tiết sau khi có ví dụ thực tế)
Appendix C–F: Glossary, FAQ, Examples, Authoring Guidelines
(Dành cho các phiên bản sau khi có dữ liệu inventory thực tế từ Architecture Bible)

KINV-001 v1.0 FROZEN – END OF DOCUMENT
Quyết định chính thức:KINV-001 đã được phê chuẩn đóng băng thành Foundation Specification v1.0 cho Knowledge Inventory Workstream của EGAL Knowledge Operating System.
Từ thời điểm này, chương trình có đủ nền tảng để chuyển sang giai đoạn xây dựng Knowledge Catalog và thực hiện Inventory theo phương pháp chuẩn hóa, có khả năng truy vết, kiểm chứng và tái sử dụng lâu dài.