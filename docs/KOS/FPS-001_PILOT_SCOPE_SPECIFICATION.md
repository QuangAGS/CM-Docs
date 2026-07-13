FPS-001
Frozen Pilot Scope Specification
Execution Artifact — Pilot Instance
Document ID
FPS-001
Version
1.0
Status
Draft — Proposed for Review
Date
2026-07-07
Classification
Execution Artifact (Pilot Instance)
Lifecycle
Draft → Review → Frozen → Inventory Starts (Immutable after Frozen)

Mục đích (Purpose)
FPS-001 định nghĩa chính xác phạm vi của Pilot Inventory đầu tiên. Đây là execution artifact đầu tiên và là "điểm khởi tạo bất biến" (immutable execution baseline) của một lần inventory cụ thể.
Mục tiêu chính:
Đảm bảo toàn bộ nhóm inventory luôn làm việc trên cùng một tập nguồn tri thức.
Loại bỏ hoàn toàn khái niệm "inventory thêm một chút" hoặc "đổi phạm vi giữa chừng".
Trở thành điểm neo (anchor) liên kết toàn bộ chuỗi: Architecture → Frozen Pilot Scope → Knowledge Objects → Catalog → Repository → PIR → KCR.
Mục tiêu (Objectives)
Một FPS đạt chuẩn phải trả lời rõ ràng các câu hỏi sau:
Inventory cái gì?
Inventory đến đâu?
Không inventory phần nào?
Tại sao chọn phạm vi này?
Phạm vi này có đủ để kiểm chứng toàn bộ pipeline (Object Extraction → PIR → KCR) hay không?
Cấu trúc bắt buộc (Required Sections)
1. Pilot Identification
Pilot ID
PILOT-001
Pilot Name
Architecture Bible Initial Inventory
FPS Version
FPS-001 v1.0
Status
Draft
2. Objective
Mục tiêu ngắn gọn của Pilot:
Validate end-to-end Knowledge Inventory workflow trên một phạm vi nhỏ nhưng đủ phức tạp, chứng minh toàn bộ chuỗi Architecture → Inventory → Catalog → Repository vận hành trọn vẹn và có thể kiểm toán.
3. Source Definition
Chỉ được phép có một nguồn authoritative duy nhất.
Source Name
Architecture Bible
Version
[Sẽ điền khi có tài liệu thực tế]
Revision
[Sẽ điền khi có tài liệu thực tế]
Authoritative Source
Architecture Bible Repository (EGAL KOS)
4. Frozen Scope (Phạm vi đã đóng băng)
Đây là phần quan trọng nhất. Phạm vi phải được xác định chính xác, không mơ hồ.
Included (Được inventory)
PART I — Introduction & Foundations
Chapter 1 — Knowledge Architecture Principles
Section 1.1 — Core Definitions
Section 1.2 — Knowledge Object Model
Excluded (Không được inventory)
Toàn bộ các phần còn lại của Architecture Bible
Product documents, Implementation specs, Roadmap, Templates
Lưu ý: Sau khi Frozen, không được thêm/bớt section. Muốn thay đổi → phải kết thúc Pilot và tạo Pilot mới + FPS mới.
5. Scope Boundary (Ranh giới phạm vi)
Ranh giới phải có thể kiểm chứng được (có marker rõ ràng).
Start Marker
Heading: "Knowledge Architecture Principles"
End Marker
Heading: "Canonical Knowledge Objects"
Verification Method
Đọc trực tiếp từ Heading trong Architecture Bible (có thể kiểm tra bằng text search hoặc mục lục)
6. Out-of-Scope
Product documents và user guides
Implementation specifications và source code
Roadmap và planning documents
Templates và governance artifacts (KINV, KCAT, KSIP, PIP, KCR…)
7. Pilot Coverage Goals
Pilot này phải chứng minh được toàn bộ các năng lực sau:
✓ Object Extraction — Trích xuất Knowledge Object rõ ràng từ nguồn
✓ Canonical ID Assignment — Gán ID ổn định, không trùng lặp
✓ Knowledge Catalog — Tạo Catalog Record đầy đủ
✓ Relationship Registration — Đăng ký Relationship chính xác
✓ Deep Reference & Traceability — Truy vết ngược về nguồn
✓ Validation — Thực hiện validation theo quy trình
✓ PIR-001 Instance — Tạo báo cáo inventory hoàn chỉnh
✓ KCR-001 Instance — Vượt qua Knowledge Conformance Review
8. Complexity Assessment
Đánh giá độ phức tạp dự kiến (sẽ cập nhật sau khi phân tích Architecture Bible thực tế):
Metric
Estimated Range
Estimated Knowledge Objects
35 – 60 objects
Estimated Relationships
120 – 180 relationships
Expected Catalog Records
35 – 60 records
Expected Complexity Level
Medium (đủ để test pipeline, không quá lớn)
9. Success Criteria
Không có sự mơ hồ về phạm vi (scope ambiguity = 0)
100% object traceability về Frozen Scope
Không có duplicated Canonical IDs
Relationships được đăng ký đầy đủ và chính xác
Catalog hoàn chỉnh và có thể kiểm toán
Tạo thành công PIR-001 và vượt qua KCR-001 mà không cần thay đổi Governance baseline
10. Freeze Declaration
KHAI BÁO ĐÓNG BĂNG PHẠM VI
Pilot Scope is hereby frozen.
Không được thêm nguồn nào khác vào Pilot này.
Không được thêm hoặc bớt section sau khi đã Frozen.
Mọi thay đổi phạm vi đều yêu cầu kết thúc Pilot hiện tại và khởi tạo Pilot mới + FPS mới.
Tiêu chí chấp nhận (Acceptance Criteria)
Một FPS được coi là đạt chuẩn khi thỏa mãn đầy đủ các tiêu chí sau:
A. Boundary Completeness
Có thể xác định chính xác "đọc từ đâu" và "đến đâu". Không được có bất kỳ sự mơ hồ nào về ranh giới.
B. Scope Stability
Sau khi Frozen, không ai được phép thêm section, bớt section hoặc đổi source. Mọi thay đổi đều phải qua quy trình Pilot mới.
C. Single Source of Truth
Chỉ tồn tại một nguồn, một version, một revision. Không được phép có nhiều nguồn authoritative trong cùng một Pilot.
D. Pipeline Sufficiency
Phạm vi phải đủ lớn để sinh ra Knowledge Objects, Catalog Records, Relationships, Validation, PIR và KCR. Nếu quá nhỏ sẽ không chứng minh được pipeline hoạt động.
E. Repeatability
Một người khác, chỉ cần đọc FPS, phải có thể inventory ra đúng cùng phạm vi mà không cần hỏi tác giả.
F. Auditability
Auditor có thể xác định đúng nguồn, đúng section, đúng boundary mà không cần hỏi tác giả hoặc tra cứu thêm tài liệu bên ngoài.
G. Traceability
Mọi Knowledge Object được tạo ra đều phải truy ngược được về phạm vi đã đóng băng trong FPS. Không được có Knowledge Object nào nằm ngoài phạm vi đã Frozen.
H. Repository Integrity
Sau khi Pilot kết thúc, mọi Catalog Record phải chứng minh được chuỗi truy vết liên tục: Object → Source Section → Frozen Scope → Pilot → PIR → KCR. Không được có "điểm đứt" trong chuỗi traceability.
Ghi chú quan trọng: FPS-001 được xem là execution baseline đầu tiên của mỗi Pilot, không phải là governance artifact mới. Nó là điểm neo (anchor) đảm bảo toàn bộ Knowledge Repository sau này có cơ sở hợp lệ và khả năng kiểm toán đầy đủ.