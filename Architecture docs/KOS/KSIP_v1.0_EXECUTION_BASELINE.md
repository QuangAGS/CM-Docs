KSIP v1.0 — Approved Execution Baseline
EGAL Knowledge Operating System (KOS)
Document Type: Execution Artifact (Knowledge Source Inventory Plan)Version: 1.0Status: ApprovedDate: 2026-07-07Baseline Reference: KINV-001 v1.0 Frozen, KCAT-001 v1.0 Frozen, Product Realization CharterOutcome: O1 — Knowledge Source Inventory Plan

Document Control
Attribute
Value
Document ID
KSIP-001
Version
1.0
Status
Approved
Approval Date
2026-07-07
Classification
Execution Baseline
Owner
Knowledge Inventory Realization Thread
Review Result
APPROVED WITH MINOR EDITORIAL REVISIONS
Version History
Version
Date
Author
Changes
Status
0.1
2026-07-07
Grok (with Project Lead review)
Initial draft
Reviewed
1.0
2026-07-07
Project Lead
Approved as Execution Baseline
Approved

1. Overview
1.1 Purpose
KSIP trả lời bốn câu hỏi cốt lõi của giai đoạn Knowledge Inventory Realization:
Inventory cái gì? — Xác định toàn bộ Knowledge Sources nằm trong phạm vi của Repository.
Inventory theo thứ tự nào? — Thiết lập thứ tự xử lý (Execution Order) và kế hoạch phân kỳ thực hiện.
Inventory với phạm vi nào? — Xác định mức độ xử lý (Whole Source / Partial Source / Incremental) của từng nguồn.
Hoàn thành khi nào? — Đưa ra tiêu chí rõ ràng để đánh giá sự sẵn sàng chuyển sang bước tiếp theo.
KSIP là Execution Artifact, không phải Foundation Specification. Nó được tạo ra theo KINV-001 để phục vụ việc thực thi, không định nghĩa chuẩn mới.
1.2 Scope
Tài liệu này bao gồm: - Tất cả Knowledge Sources thuộc phạm vi EGAL Knowledge Repository theo baseline đã đóng băng. - Phân loại nguồn theo vai trò thực tế trong hệ thống (Constitutional, Canonical, Derived). - Thứ tự xử lý và chiến lược thực hiện theo từng Inventory Phase.
1.3 Assumptions
Toàn bộ baseline (CORE-000 → CORE-007, Product Realization Charter, KINV-001 v1.0 Frozen, KCAT-001 v1.0 Frozen) là bất biến.
Mọi Knowledge Source trong danh sách đều có thể truy vết được về artifact đã được phê duyệt.
Không có Knowledge Source mới được thêm vào ngoài danh sách đã phê duyệt tại thời điểm KSIP này được phê chuẩn.
1.4 Out of Scope
Mô tả chi tiết nội dung hoặc cấu trúc của Knowledge Objects.
Thiết kế Knowledge Catalog schema hoặc metadata model.
Lựa chọn phân đoạn cụ thể của Architecture Bible để pilot (được xử lý trong Pilot Inventory Plan riêng).
Quy tắc chi tiết về cách tách object, Deep Reference depth, hoặc relationship registration.

2. Knowledge Source Register
Bảng dưới đây liệt kê toàn bộ Knowledge Sources sẽ được đưa vào Repository. Mỗi nguồn được phân loại theo vai trò và được gán Execution Order rõ ràng.
Phân loại nguồn: - A — Constitutional Sources: Các tài liệu nền tảng xác định phạm vi, quy tắc và nguyên tắc của toàn bộ Repository. - B — Canonical Knowledge Sources: Nguồn chính để trích xuất Knowledge Objects. - C — Derived Knowledge Sources: Các nguồn được tạo ra từ các nguồn trên, inventory sau khi nhóm A và B ổn định.
Execution Order
Knowledge Source
Classification
Status
Inventory Scope
Inventory Phase
Notes
1
CORE-000 → CORE-007
A — Constitutional
Ready
Whole Source
Baseline Registration
Nguồn gốc của mọi quy tắc và nguyên tắc. Không inventory thành Knowledge Objects trong pilot, nhưng phải đăng ký để đảm bảo traceability toàn hệ thống.
2
Product Realization Charter
A — Constitutional
Ready
Whole Source
Baseline Registration
Xác định Product Realization pipeline và vai trò của Repository. Là tài liệu tham chiếu bắt buộc cho mọi quyết định inventory.
3
Architecture Bible
B — Canonical
Ready
Whole Source (initial pilot on selected segment)
Phase 1 (Pilot)
Nguồn chính để trích xuất Knowledge Objects trong giai đoạn pilot. Được chọn làm nguồn đầu tiên vì có cấu trúc rõ ràng và đa dạng loại object.
4
Ontology
B — Canonical
Ready
Whole Source
Phase 2
Nguồn Canonical quan trọng để định nghĩa khái niệm và mối quan hệ cốt lõi. Inventory sau khi pilot trên Architecture Bible hoàn tất.
5
Product Mapping
C — Derived
Ready
Whole Source
Phase 3
Liên kết giữa Product và Knowledge Objects. Phụ thuộc vào Ontology và Architecture Bible đã ổn định.
6
Product Specifications
C — Derived
Ready
Whole Source
Phase 3
Chi tiết kỹ thuật của sản phẩm. Inventory sau Product Mapping.
7
Approved Implementation Documents
C — Derived
Ready
Incremental
Phase 4
Các tài liệu triển khai đã được phê duyệt. Xử lý theo từng đợt khi có nhu cầu mở rộng Repository.
Ghi chú về Execution Order: Execution Order phản ánh thứ tự xử lý thực tế, không phải mức độ ưu tiên chủ quan. Nguồn có số thấp hơn được xử lý trước.

3. Execution Strategy
3.1 Chiến lược tổng thể
KSIP tuân thủ nguyên tắc Pilot trước — Mở rộng sau và Repository-first.
Baseline Registration (Phase 0)    │   • Đăng ký các nguồn nền tảng (Constitutional)    │   • Thiết lập traceability ban đầu    ▼Phase 1: Pilot Inventory (Architecture Bible)    │   • Chọn phân đoạn đại diện    │   • Áp dụng quy tắc inventory theo KINV-001    │   • Tạo Knowledge Objects + Catalog records    │   • Validation & Conformance Review    ▼Phase 2: Expansion — Canonical Sources (Ontology)    │    ▼Phase 3: Expansion — Derived Sources (Product Mapping → Specifications)    │    ▼Phase 4: Continuous Expansion (Approved Implementation Documents + nguồn mới)
3.2 Nguyên tắc thực hiện
Không inventory ngược: Chỉ bắt đầu inventory nguồn tiếp theo khi nguồn trước đó đã đạt trạng thái ổn định.
Traceability by Default: Mọi Knowledge Source đều có liên kết rõ ràng về artifact gốc đã phê duyệt.
Non-destructive & Deterministic: Mọi thay đổi sau này tuân thủ Change Management và không ảnh hưởng đến baseline frozen.
Readiness Gate: Chỉ chuyển sang Phase tiếp theo khi Phase hiện tại đạt Readiness criteria.

4. Deliverables
Sau khi KSIP v1.0 được phê chuẩn, các deliverables của Outcome O1 là:
Approved Knowledge Source Register — Danh sách đầy đủ các nguồn tri thức cùng Execution Order và Inventory Scope.
Approved Inventory Execution Order — Thứ tự xử lý chính thức cho toàn bộ giai đoạn Knowledge Inventory Realization.
Approved Inventory Phases — Kế hoạch phân kỳ thực hiện (Baseline Registration → Phase 1 → Phase 2 → Phase 3 → Phase 4).
Approved Pilot Candidate Source — Xác nhận Architecture Bible là nguồn được chọn cho pilot đầu tiên.
Authorization to create Pilot Inventory Plan — Cho phép chuyển sang bước tiếp theo: xây dựng Pilot Inventory Plan chi tiết (lựa chọn phân đoạn, quy tắc inventory, tiêu chí đánh giá).
Các deliverable trên trở thành baseline thực thi cho toàn bộ pha Knowledge Inventory Realization.

5. Acceptance Criteria
KSIP v1.0 được coi là đạt yêu cầu khi Hội đồng Review xác nhận Có cho tất cả các câu hỏi sau:
Completeness
Tất cả Knowledge Sources trong phạm vi Repository đã được liệt kê đầy đủ?
Không thiếu nguồn Constitutional (CORE documents + Charter)?
Correctness
Phân loại (A — Constitutional / B — Canonical / C — Derived) là chính xác?
Mỗi nguồn có mô tả ngắn gọn về vai trò và lý do được đưa vào?
Execution Order & Planning
Execution Order phản ánh đúng thứ tự xử lý hợp lý?
Inventory Phase được đặt tên rõ ràng và không nhầm lẫn với roadmap dự án?
Traceability
Mỗi Knowledge Source đều có thể truy vết được tới artifact đã được phê duyệt trong baseline?
Không có nguồn “vô danh” hoặc ngoài phạm vi?
Conformance
KSIP không mâu thuẫn với KINV-001 v1.0 Frozen?
KSIP không mâu thuẫn với KCAT-001 v1.0 Frozen?
KSIP không tạo ra Foundation Specification mới?
Readiness
Sau khi KSIP được phê chuẩn, có thể bắt đầu bước tiếp theo (Pilot Inventory Plan) ngay mà không cần quyết định thêm về danh sách nguồn?

Kết luận phê chuẩn
KSIP v1.0 hoàn thành vai trò của Outcome O1. Tài liệu này được phê chuẩn làm Execution Baseline cho toàn bộ giai đoạn Knowledge Inventory Realization.
Từ thời điểm này, mọi hoạt động inventory phải tuân thủ Execution Order, Inventory Scope và Inventory Phase đã được xác lập trong tài liệu này.

Document Type: Approved Execution BaselineNext authorized artifact: Pilot Inventory Plan (sau khi KSIP v1.0 được phê chuẩn)
End of KSIP v1.0 — Approved Execution Baseline