EGAL DOCUMENTATION ARCHITECTURE (EDA)
VERSION: V3.0.0-ULTIMATE
STATUS: ENTERPRISE CONSTITUTION HARD-FROZEN (ABSOLUTE ABSTRACTION)
FRONT MATTER
Document Information
Title: EGAL Documentation Architecture (EDA)
Authority: Chief Enterprise Architect & Architecture Review Board (CAB)
Framework Compliance: ISO/IEC 42010, TOGAF 10, MOF Level 2, EASS v1.2.0-FINAL
Classification: Enterprise Architecture Meta-Documentation (Strictly Confidential)
Revision History
Version
Date
Author
Description of Change
 
V1.0.0-FROZEN
07-2026
Chief AI Architect & CAB Core
Initial Publication (Superseded due to implementation leakage).
V2.0.0-META
07-2026
Chief AI Architect & CAB Core
Overhaul to technology-neutral container framework. (Superseded due to ontology leakage).
V3.0.0-ULTIMATE
07-2026
Chief AI Architect & CAB Core
Ultimate structural alignment. Separated Documentation System from Knowledge System (AKRM). Replaced DAG with Semantic Graph, shifted specific routing to Abstract Document Classes, eliminated naming syntaxes, and redefined the Documentation System as the ultimate architectural abstraction.

Preface & Introduction
Tài liệu này xác lập hiến pháp tối cao cho Hệ thống Tài liệu (Documentation System) của EGAL Platform V4. EDA V3.0.0-ULTIMATE thiết lập một hành lang độc lập tuyến tính, tách biệt hoàn toàn vỏ bọc quản trị tài liệu khỏi bản thể học hạt nhân tri thức (AKRM). Tài liệu này không quản lý các tệp tin cô lập, mà quản trị toàn bộ cấu trúc, luồng định tuyến và thuộc tính vận hành của Hệ thống Tài liệu Enterprise.

PART I — DOCUMENTATION SYSTEM PHILOSOPHY
1. Purpose Statement
The purpose of the EGAL Documentation Architecture (EDA) is to define the architecture of the EGAL documentation ecosystem by establishing the classes of architectural documents, their purposes, semantic responsibilities, dependency relationships, governance rules, lifecycle, traceability, and evolution principles, thereby ensuring that every architectural question has a single authoritative source of truth and every document has a well-defined role within the Enterprise Knowledge System.
2. Scope
EDA điều chỉnh tối cao và duy nhất cấu trúc thiết lập, phân lớp và điều phối của Hệ thống Tài liệu (Documentation System). Phạm vi tài liệu dừng lại ở biên giới của các Vỏ bọc quản trị (Containers) và Lớp tài liệu trừu tượng (Document Classes), không định nghĩa cấu trúc nội tại của các thực thể tri thức bên trong.
3. Documentation System vs. Knowledge System
Hệ thống phân tách tường minh ranh giới kiến trúc thượng tầng:
EDA (Architecture of Documentation System): Mô tả hệ thống tài liệu bao gồm các lớp tài liệu trừu tượng, quan hệ bao bọc, vòng đời, mô hình quản trị, và quy tắc định tuyến ngữ nghĩa.
AKRM (Architecture of Knowledge System): Mô tả hệ thống tri thức, định nghĩa bản thể học (Ontology) chi tiết của từng loại đối tượng tri thức (Knowledge Objects), các thuộc tính nguyên tử và quan hệ ngữ nghĩa nội tại của chúng.

PART II — CONSTITUTION & CORE INVARIANTS
4. Documentation System Invariants
INVARIANT-DOC-01 (Authoritative Source Rule): Mỗi lớp tài liệu trừu tượng nắm giữ thẩm quyền duy nhất đối với một tập hợp câu hỏi kiến trúc tương ứng. Nghiêm cấm hành vi phân rã một câu hỏi meta-question sang nhiều lớp tài liệu khác nhau.
INVARIANT-DOC-02 (Absolute Root Rule): EDA là thực thể tối cao và duy nhất tại đỉnh của hệ thống siêu tài liệu (Meta-documentation). Mọi văn bản tiêu chuẩn, handbook hoặc guide chỉ được phép tham chiếu hoặc kế thừa từ EDA, không được phép đứng song song hoặc định nghĩa đè lên EDA.
5. Technology and Syntax Neutrality
EDA bảo toàn tính trung lập tuyệt đối. Tài liệu nghiêm cấm rò rỉ các cấu phần triển khai (như định dạng tệp, cấu trúc thư mục, hệ thống quản lý mã nguồn, cơ chế kiểm soát ghi khóa tự động) và các biểu thức cú pháp định danh cụ thể (Naming Syntax strings). Cú pháp định danh chi tiết thuộc thẩm quyền tối cao của EDS (Enterprise Documentation Standards).

PART III — DOCUMENT CONTAINER ARCHITECTURAL ABSTRACTION
6. Container Abstraction
Trong EDA, một Document không được xem xét như một đơn vị tệp vật lý, mà được định nghĩa là một Document Container (Vỏ bọc tài liệu trừu tượng). Document Container hoạt động như một thực thể kiến trúc sở hữu các biên giới quản trị độc lập và các thuộc tính hệ thống xác định.
7. Container Structural Composition
Một Document Container được cấu thành từ các thành phần thuộc tính logic sau:
Document Container = { Authority Domain, Lifecycle State, Abstract Class Type, Document-Level Relationships, Governance Attributes, Unique Identifier }
Document Container đóng vai trò chứa các Knowledge Objects. Bản thể học, cấu trúc nguyên tử và các luật logic nội tại của các Knowledge Objects này được định nghĩa hoàn toàn độc lập tại mô hình tham chiếu của Kiến trúc Tri thức (AKRM).

PART IV — SEMANTIC ROUTING MODEL (META-QUESTION MATRIX)
8. Abstract Semantic Routing
Mô hình Định tuyến Ngữ nghĩa (Semantic Routing Model) thực hiện việc ánh xạ đơn trị từ các câu hỏi kiến trúc cốt lõi của doanh nghiệp (Meta-Questions) về các Lớp Tài liệu Trừu tượng (Abstract Document Classes) tương ứng, hoàn toàn không phụ thuộc vào tên gọi vật lý của các tập tệp hay chuỗi tài liệu cụ thể:
Mã định tuyến
Câu hỏi Kiến trúc cốt lõi (Meta-Question)
Lớp Tài liệu Trừu tượng (Authoritative Class)
 
Q-ROUT-01
Khái niệm/Thực thể này nghĩa là gì về mặt bản thể học?
Meta-Model Document Class
Q-ROUT-02
Tri thức/Mô hình được biểu diễn bằng cú pháp hình thức nào?
Modeling Language Document Class
Q-ROUT-03
Vì sao phải áp dụng nguyên tắc này? Các bất biến runtime là gì?
Doctrinal Document Class
Q-ROUT-04
Hệ thống logic phải thực hiện hành vi gì để đáp ứng yêu cầu?
Specification Document Class
Q-ROUT-05
Vì sao giải pháp kỹ thuật cụ thể này được lựa chọn tại thời điểm t?
Decision Record Document Class
Q-ROUT-06
Cách thức hiện thực hóa cấu hình và mã nguồn vật lý là gì?
Implementation Guide Document Class
Q-ROUT-07
Bằng chứng định lượng nào chứng minh hệ thống tuân thủ kiến trúc?
Evidence Document Class
Q-ROUT-08
Toàn bộ các quy tắc điều phối và phân cấp tài liệu nằm ở đâu?
Meta-Documentation Architecture Class (EDA)

PART V — DOCUMENT CLASSIFICATION ARCHITECTURE
9. Document Class as an Abstract Functional Type
Một Document Class là một Kiểu chức năng trừu tượng (Abstract Functional Type), không đại diện cho một thư mục, một tệp tin hay một phần mở rộng trong không gian lưu trữ vật lý. Hệ thống tài liệu bao gồm 7 lớp đối tượng trực giao tuyến tính:
Standard Class: Xác lập các rào chắn hình thức bắt buộc và luật đóng hệ thống.
Handbook Class: Diễn giải hệ học thuyết, nguyên lý vận hành và các ràng buộc logic.
Reference Model Class: Cung cấp cấu trúc khuôn mẫu và các mô hình trừu tượng tiêu chuẩn.
Catalog Class: Tổ chức, phân loại và lưu trữ các thực thể tri thức hoặc quyết định có khả năng tái sử dụng.
Specification Class: Đặc tả chi tiết hành vi logic và các yêu cầu kỹ thuật của hệ thống.
Guide Class: Hướng dẫn trình tự các bước thực thi và triển khai chi tiết vật lý.
Evidence Class: Tập hợp dữ liệu xác minh trạng thái và chứng minh tính tuân thủ trên thực tế.

PART VI — GOVERNANCE LOOPS & STATE TRANSITIONS
10. Abstract Lifecycle Graph
Trạng thái quản trị của các Document Containers dịch chuyển trong một Đồ thị Trạng thái trừu tượng độc lập:
Draft ──► Under Review ──► Approved ──► Frozen ──► Deprecated ──► Archived
11. Governance Transition Rules
Frozen Rule: Khi đạt trạng thái Frozen, Container áp đặt một khóa logic bất biến lên toàn bộ thuộc tính cấu trúc của nó. Mọi hành vi làm thay đổi nội dung ngữ nghĩa bắt buộc phải kích hoạt chu trình tiến hóa phiên bản mới.
Exception Loop: Việc dịch chuyển trạng thái đặc biệt từ Frozen sang Deprecated được thực thi thông qua Sắc lệnh Thẩm quyền Tối cao (Authoritative Decree). Chu trình này bắt buộc phải gắn kèm một nhãn định lượng nợ kiến trúc (Architecture Debt Tag) sở hữu điều kiện hết hạn logic (Logical Expiry Condition), hoàn toàn cách ly khỏi các tham số thời gian vật lý.

PART VII — DOCUMENTATION SYSTEM QUALITY ATTRIBUTES
12. Quality Framework Aligned with International Standards
Chất lượng cấu trúc của Hệ thống Tài liệu được đánh giá định lượng dựa trên bộ thuộc tính trừu tượng (Conceptually aligned với khung tiêu chuẩn ISO/IEC 25010):
Authority (Tính thẩm quyền): Mọi Container phải được định vị chính xác trong một Authority Domain chịu trách nhiệm phê duyệt và quản trị độc quyền.
Traceability (Tính truy vết): Đảm bảo khả năng thiết lập vectơ liên kết logic hai chiều giữa các Container thuộc các lớp tài liệu khác nhau.
Discoverability (Tính khả kiến): Khả năng định tuyến chính xác nguồn thông tin dựa trên mô hình ánh xạ chức năng Q-ROUT.
Evolvability (Tính tiến hóa): Khả năng thay đổi trạng thái hoặc cô lập một miền Container mà không phá vỡ tính toàn vẹn của các miền độc lập khác trên đồ thị.
Auditability (Tính kiểm toán): Container tự cung cấp các thuộc tính trạng thái và chỉ số bao phủ logic phục vụ việc kiểm tra tự động.
Determinism (Tính xác định): Đảm bảo một Meta-Question chỉ nhận được một câu trả lời đơn trị từ một nguồn thẩm quyền xác định tại một thời điểm trạng thái.

PART VIII — TRACEABILITY & SYSTEM GRAPH INTEGRITY
13. The Documentation Semantic Graph
Mạng lưới liên kết giữa các Document Containers hình thành một Đồ thị Ngữ nghĩa (Semantic Graph) toàn cục. EDA công nhận rằng tại tầng ngữ nghĩa sâu của tri thức, các vòng lặp liên kết logic (Cycles) hoàn toàn có thể phát sinh do tính chất tham chiếu chéo giữa các thực thể (ví dụ: Quyết định kỹ thuật tham chiếu Yêu cầu, và Yêu cầu điều chỉnh ngược Quyết định kỹ thuật). Do đó, EDA không ép buộc cấu hình DAG (Directed Acyclic Graph) lên toàn bộ đồ thị tri thức tổng thể; việc quản lý các chu trình ngữ nghĩa này thuộc thẩm quyền điều phối của AKRM.
14. Container Inter-dependency Rules
Mối quan hệ phụ thuộc giữa các Container tuân thủ nguyên tắc phân tầng nghiêm ngặt. Các Container thuộc lớp tài liệu cấp dưới chỉ được phép phụ thuộc chức năng vào các Container thuộc lớp tài liệu cấp trên. Sự phụ thuộc ngược từ lớp trên xuống lớp dưới bị cấm tuyệt đối nhằm bảo toàn tính độc lập của hiến pháp kiến trúc.

PART IX — EVOLUTION & COMPATIBILITY LAYER
15. Evolution Levels of the Documentation System
Sự biến đổi trạng thái và nâng phiên bản của các Document Containers được phân tách thành 3 cấp độ trừu tượng:
Major Modification: Biến đổi làm thay đổi các quy tắc điều phối tối cao của hệ thống tài liệu hoặc phá vỡ tính tương thích ngữ nghĩa hiện hành, yêu cầu thẩm định lại toàn bộ các mối quan hệ phụ thuộc tầng dưới.
Minor Modification: Bổ sung các cấu phần Container mới hoặc mở rộng không gian quản trị (Namespaces) mà không làm ảnh hưởng đến các luật hệ thống đang thực thi.
Patch Modification: Chỉnh sửa hình thức ngôn từ biểu diễn trong Container, hoàn toàn không làm thay đổi các thuộc tính quản trị, trạng thái vòng đời hoặc liên kết logic.

PART X — HIGH-LEVEL SYSTEM HIERARCHY
16. Pure Functional Layering of the Documentation System
Cấu trúc phân tầng hệ thống tài liệu tuân thủ mô hình phân lớp chức năng thuần khiết của các Document Classes, loại bỏ toàn bộ các khái niệm thuộc về tầng tri thức (Knowledge Layers):
EDA Layer (Root) ──► Standard Class Layer ──► Handbook Class Layer ──► Reference Model Class Layer ──► Catalog Class Layer ──► Specification Class Layer ──► Guide Class Layer ──► Evidence Class Layer

APPENDICES
Appendix A. Container Abstract Metadata Framework
Mọi Document Container khi được thiết lập trong hệ thống bắt buộc phải chứa các thuộc tính logic để định cấu hình trạng thái, bao gồm:
Unique_Identifier: Khóa định danh duy nhất toàn cục của Container.
Abstract_Class_Type: Định vị lớp chức năng của tài liệu.
Authority_Domain_Ref: Tham chiếu đến miền thẩm quyền sở hữu.
Integrity_Attribute: Thuộc tính bảo toàn toàn vẹn logic của nội dung nội tại.
Lifecycle_Status: Trạng thái vận hành hiện tại trong đồ thị vòng đời.
Appendix B. Container Unique Identifier Rule
Mỗi Document Container bắt buộc phải sở hữu một Khóa định danh Duy nhất (Unique Identifier). Bản thân EDA không quy định biểu thức cú pháp vật lý của chuỗi định danh này (ví dụ: dấu gạch ngang, chữ hoa, hay định dạng số). EDA chỉ áp đặt nguyên tắc kiến trúc: Khóa định danh phải là duy nhất toàn cục, có tính phân tách miền năng lực, và phải được hệ thống EDS ánh xạ 1-1 vào các cấu phần vật lý ở tầng triển khai hạ tầng.