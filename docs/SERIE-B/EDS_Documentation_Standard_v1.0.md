EGAL DOCUMENTATION STANDARD (EDS) v1.0
Document ID: EGAL-EDS-1.0.0
Title: EGAL Technical Architecture Documentation Standard
Version: 1.0.0-Baseline
Status: FROZEN
Author: Chief AI Architect & Chief Architect Collaboration
Reviewer: Architecture Board
Approval: Frozen by Project Decree
Created Date: 2026-07-04T07:35:00+07:00
Updated Date: 2026-07-04T07:35:00+07:00
Related Documents: N/A (Root Document)
Keywords: Documentation Standard, EDS, Governance, Architecture Hiến Pháp
REVISION HISTORY (LỊCH SỬ SỬA ĐỔI)
Phiên bản
Ngày cập nhật
Người sửa
Nội dung thay đổi chi tiết
Rationale (Lý do sửa)
 
1.0.0
2026-07-04
Core AI
Khởi tạo tài liệu bản gốc chi tiết 15 chương
Đóng băng nền móng kiến trúc và quy chuẩn tài liệu của dự án EGAL.
CHƯƠNG 1. DOCUMENT TAXONOMY (PHÂN LOẠI TÀI LIỆU)
Hệ thống tài liệu EGAL được phân ranh giới thành 9 loại tài liệu độc lập vật lý. Không một tài liệu nào được phép chứa nội dung xâm lấn phạm vi của loại khác.
1. Architecture Handbook (Sách hướng dẫn kiến trúc): Định nghĩa các nguyên lý nền tảng, học thuyết phát triển (Doctrines) và các ràng buộc kiến trúc bất biến. Trả lời câu hỏi "WHAT" và "WHY". Cấm chứa cấu hình hạ tầng vật lý cụ thể.
2. Architecture Decision Record (ADR - Hồ sơ quyết định): Lưu trữ vết lịch sử của các quyết định kỹ thuật quan trọng và giải trình lý do lựa chọn. Chỉ trả lời duy nhất câu hỏi: "Vì sao lại làm như vậy?". Không dạy lập trình, không mô tả nghiệp vụ.
3. Business Specification (BS - Đặc tả nghiệp vụ): Định nghĩa luồng nghiệp vụ tĩnh, các quy tắc bất biến nghiệp vụ (Business Invariants), máy trạng thái (State Machine) và các quy tắc kiểm thử. Trả lời câu hỏi "Hệ thống xử lý nghiệp vụ gì?". Cấm chứa code triển khai.
4. Architecture Map (Bản đồ kiến trúc): Trực quan hóa cấu trúc hệ thống, dòng chảy dữ liệu và vòng đời dữ liệu bằng các sơ đồ tĩnh (Context, Container, Module, Sequence...). Tuyệt đối không dùng để giải thích dài dòng bằng chữ.
5. Migration Guide (Hướng dẫn dịch chuyển): Quản lý toàn bộ lộ trình, rủi ro, kế hoạch rollback và tương thích ngược (Backward Compatibility) của quá trình Refactor/Dịch chuyển dữ liệu qua các thời kỳ.
6. Coding Standard (Tiêu chuẩn lập trình): Chuẩn hóa cách thức viết mã nguồn trong IDE, quy chuẩn đặt tên file, module, hàm, cấu trúc header bắt buộc và quy tắc chú thích "WHY comment". Được tích hợp trực tiếp vào Volume 03 của Handbook.
7. Review Checklist (Danh mục kiểm tra): Cơ chế chốt chặn kỹ thuật tự động và thủ công nhằm bảo vệ kiến trúc khi kiểm thử Pull Request (PR). Chứa các mã kiểm tra tĩnh, mô tả lỗi và ví dụ vi phạm.
8. UAT Guide (Hướng dẫn kiểm thử chấp nhận): Kịch bản kiểm thử (Test Scenarios), bộ dữ liệu mẫu (Test Vectors) và kết quả mong đợi nhằm xác minh hệ thống sau khi refactor bảo toàn đúng 100% hành vi nghiệp vụ ban đầu.
9. Deployment Guide (Hướng dẫn triển khai): Mô tả hạ tầng vật lý, file cấu hình Docker, script CI/CD, phân vùng mạng, cấu hình Supabase Cloud/Local Shadow DB. Đây là nơi duy nhất chứa các chi tiết môi trường vật lý.
CHƯƠNG 2. HIERARCHY (PHÂN CẤP QUYỀN LỰC TÀI LIỆU)
Để giải quyết triệt để các xung đột thông tin giữa các tầng tài liệu, EGAL thiết lập Hệ thống Thứ bậc Quyền lực Kiến trúc (Hierarchy of Truth) bất biến theo sơ đồ phân cấp sau:
[MỨC TỐI CAO]  EGAL Documentation Standard (EDS)                     ↓               Architecture Principles (Handbook Vol 01)                     ↓               Architecture Doctrines (Handbook Vol 02)                     ↓               Architecture Decision Records (ADR)                     ↓               Business Specifications (BS)                     ↓               [MỨC THI HÀNH] Source Code & Migration Guides
Quy tắc xử lý mâu thuẫn 01: Tài liệu tầng trên luôn thắng tài liệu tầng dưới. Nếu Source Code chạy đúng nhưng lệch với Business Specification → Source Code SAI. Nếu Business Specification viết trúng nghiệp vụ nhưng phá vỡ Doctrine trong Handbook Vol 02 → Business Specification SAI, buộc phải thiết kế lại giải pháp nghiệp vụ.
Quy tắc xử lý mâu thuẫn 02: Nếu Handbook và ADR mâu thuẫn → Handbook thắng. ADR chỉ có vai trò giải trình bối cảnh tại thời điểm đưa ra quyết định; mọi luật hóa của quyết định đó phải được cập nhật vào Handbook để trở thành luật chính thống.
CHƯƠNG 3. REFERENCE RULES (QUY TẮC VIỆN DẪN)
Mọi thực thể tài liệu và mã nguồn không được tồn tại độc lập mà phải nằm trong mạng lưới truy vết toàn cục (Traceability Net).
Từ Source Code ra thế giới tài liệu: Mỗi file mã nguồn bắt buộc phải chứa khối liên kết JSDoc trỏ đến đúng mã tài liệu tham chiếu. Cấm viện dẫn chung chung không có ID.Ví dụ: @doctrine_references: Handbook V4 Vol 02 (Ch 02: Prisma Doctrine)
Từ Review Checklist sang Handbook/ADR: Mỗi tiêu chí kiểm tra (Checklist Item) phải mang ID tĩnh và viện dẫn trực tiếp điều khoản làm căn cứ đánh giá Pass/Fail.Ví dụ: [RC-DB-001] Cấm gọi Prisma Client thô ngoài Repository. Căn cứ: Handbook Vol 02: Ch 02.
CHƯƠNG 4. VERSIONING (QUY CHUẨN PHIÊN BẢN TÀI LIỆU)
Áp dụng quy chuẩn Semantic Versioning (SemVer) cải tiến dành riêng cho Tài sản Kiến trúc: MAJOR.MINOR.PATCH.
Tăng MAJOR (X.0.0): Kích hoạt khi thay đổi cấu trúc cốt lõi mang tính phá vỡ toàn hệ thống (Breaking Changes). Ví dụ: Thay đổi mô hình từ Layered Architecture sang Hexagonal Architecture; thay đổi mô hình dữ liệu từ Multi-tenant cô lập sang Shared Database.
Tăng MINOR (0.X.0): Kích hoạt khi bổ sung thêm một Học thuyết (Doctrine) mới, một ADR mới hoặc một Business Specification mới mà không làm thay đổi hay gãy đổ các quy định đã đóng băng trước đó.
Tăng PATCH (0.0.X): Kích hoạt khi sửa lỗi diễn đạt, làm rõ nghĩa ví dụ, cập nhật thông tin Metadata (Author/Reviewer) hoặc sửa link liên kết Markdown bị hỏng.
CHƯƠNG 5. FREEZE POLICY (CHÍNH SÁCH ĐÓNG BĂNG)
Một tài liệu phải trải qua vòng đời trạng thái được kiểm soát bằng khóa phân quyền nghiêm ngặt:
[DRAFT] ──(Peer Review)──► [UNDER_REVIEW] ──(Architect Board Approve)──► [APPROVED] ──(Baseline Tag)──► [FROZEN]
Trạng thái
Ý nghĩa
Quyền chuyển đổi
Chế tài sửa đổi
 
DRAFT
Tài liệu đang được soạn thảo độc lập.
Kỹ sư biên soạn chính
Tự do sửa đổi, không cần ghi lịch sử.
UNDER_REVIEW
Đã xong cấu trúc sơ bộ, đang đợi phản biện.
Tech Lead / Peer Reviewer
Mọi chỉnh sửa phải thông báo qua comment phản biện.
APPROVED
Được Architecture Board ký duyệt đạt yêu cầu.
Chief Architect
Cấm sửa đổi trực tiếp. Muốn đổi phải mở đề xuất CR.
FROZEN
Đóng băng làm Hiến pháp tối cao. Gắn Tag Release.
Project Steering Committee
TUYỆT ĐỐI BẤT BIẾN. Chỉ được ghi đè bằng Major mới.
DEPRECATED
Hết hiệu lực, chuyển sang chế độ lưu trữ.
Chief Architect
Chỉ đọc (Read-only).
CHƯƠNG 6. CHANGE MANAGEMENT (QUY TRÌNH QUẢN LÝ THAY ĐỔI)
Quy trình sửa đổi tài liệu khi đã ở trạng thái APPROVED hoặc FROZEN tuân thủ nghiêm ngặt chuỗi phản ứng dây chuyền (Chain Reaction Workflow):
Yêu cầu thay đổi (CR) ──► Cập nhật Handbook/ADR trước ──► Sửa Business Spec ──► Cập nhật Review Checklist ──► Cập nhật Source Code
Cấm 01 (Code-First Change): Nghiêm cấm việc lập trình viên sửa đổi Source Code trước rồi quay lại cập nhật tài liệu sau để "hợp thức hóa". PR vi phạm điều này sẽ bị hệ thống tự động Reject lập tức.
Cấm 02 (Silent Edit): Không được sửa bất kỳ ký tự nào trong một tài liệu đã đóng băng mà không nâng số hiệu phiên bản và không ghi vết vào bảng Revision History.
CHƯƠNG 7. TRACEABILITY (BẢN ĐỒ TRUY VẾT TỪ ĐẦU CUỐI)
Mọi sự thay đổi trên hệ thống EGAL phải được chứng minh tính chính danh thông qua chuỗi liên kết 10 mắt xích (Ten-Link Traceability Chain):
Requirement → Business Specification → Handbook Vol 01 → Handbook Vol 02 → ADR → Architecture Map → Source Code → Review Checklist → Migration Guide → UAT Guide
Một tính năng được coi là sạch sẽ và đủ điều kiện Release khi và chỉ khi Kỹ sư vận hành có thể chỉ ra chính xác chuỗi liên kết tĩnh của nó từ đầu đến cuối trên không gian Git repository.
CHƯƠNG 8. DOCUMENT LIFECYCLE (VÒNG ĐỜI VĂN BẢN TÀI SẢN)
Mỗi tài liệu kỹ thuật của EGAL là một thực thể sống, vận hành theo vòng đời khép kín 6 bước:
Khởi tạo (Create): Dựng file .md dựa trên Template chuẩn (Chương 15). Trạng thái mặc định: DRAFT.
Thẩm định (Review): Đưa lên hệ thống Pull Request tài liệu. Đội ngũ kiểm duyệt chéo (Peer Review) đối chiếu với các Quality Gates (Chương 14). Trạng thái: UNDER_REVIEW.
Phê duyệt (Approve): Chief Architect ký duyệt điện tử, xác nhận tài liệu không vi phạm EDS v1.0. Trạng thái: APPROVED.
Đóng băng (Freeze): Gắn thẻ phiên bản hệ thống, khóa quyền ghi (Write-lock) của file. Trạng thái: FROZEN.
Bảo trì (Maintain): Áp dụng quy trình Change Management khi có yêu cầu CR hệ thống.
Lưu trữ lịch sử (Archive): Khi hệ thống lên thế hệ kiến trúc mới, chuyển file sang trạng thái DEPRECATED và di dời vào thư mục Archive/.
CHƯƠNG 9. METADATA STANDARD (TIÊU CHUẨN DỮ LIỆU ĐẦU FILE)
Mọi tài liệu thuộc hệ thống EGAL bắt buộc phải khai báo khối Metadata ở ngay trang đầu tiên/dòng đầu tiên của tệp tin theo đúng cấu trúc chuẩn sau. Thiếu một trường → Tài liệu vô hiệu.
# [TÊN LOẠI TÀI LIỆU] | [TIÊU ĐỀ HỒ SƠ]* **Document ID:** EGAL-[LOẠI]-[MÃ SỐ TUẦN TỰ] (Ví dụ: EGAL-BS-0002)* **Title:** [Tiêu đề ngắn gọn, tường minh]* **Version:** [X.Y.Z]* **Status:** [DRAFT / UNDER_REVIEW / APPROVED / FROZEN / DEPRECATED]* **Author:** [Tên kỹ sư biên soạn chính]* **Reviewer:** [Tên người phản biện]* **Approval:** [Chữ ký / Tên Chief Architect phê duyệt]* **Created Date:** [ISO 8601 Format: YYYY-MM-DDTHH:mm:ss+07:00]* **Updated Date:** [ISO 8601 Format: YYYY-MM-DDTHH:mm:ss+07:00]* **Related Documents:** [Link Markdown trỏ đến các tài liệu liên quan]* **Keywords:** [Các từ khóa phục vụ tra cứu nhanh toàn cục]
CHƯƠNG 10. SOURCE CODE METADATA (DỮ LIỆU ĐẦU MÃ NGUỒN)
Mọi tệp tin mã nguồn triển khai (*.js, *.ts) bắt buộc phải bọc khối JSDoc Metadata ở dòng 1 để phục vụ kiểm tra linter tĩnh:
/** * @path: src/repository/user.repository.js * @datetime: 2026-07-04T07:35:00+07:00 * @version: 1.0.0 * @description: Quản lý toàn bộ các thao tác đọc/ghi thô vào bảng users qua Prisma Client. * @doctrine_references: Handbook V4 Vol 02 (Ch 01: Repository Doctrine) * @adr_references: ADR-0001 (Layered Architecture Isolation) * @business_references: BS-0001 (User Registration Flow) * @review_references: RC-DB-001, RC-SE-005 * @uat_compatibility: PHASE_6B_CRITICAL * @behavior_preservation: Cam kết giữ nguyên vẹn cấu trúc JSON trả về của EGAL-24.x/25.x. * @change_history: * - v1.0.0: Khởi tạo bóc tách từ tầng cũ sang phân tầng Repository mới. */
CHƯƠNG 11. DIAGRAM STANDARD (TIÊU CHUẨN SƠ ĐỒ KỸ THUẬT)
Nghiêm cấm việc vẽ sơ đồ tự phát bằng hình vẽ tự chế vãng lai. Dự án EGAL chỉ công nhận 7 loại sơ đồ kỹ thuật dưới đây và bắt buộc phải kết xuất từ code đồ họa tĩnh (PlantUML hoặc Mermaid) để lưu trữ phiên bản trong Git:
Context Diagram (Sơ đồ ngữ cảnh): Trực quan hóa mối quan hệ giữa EGAL Platform và các hệ thống ngoại vi (Supabase Auth, Mail Server, Zalo API).
Container Diagram (Sơ đồ thùng chứa): Định hình mối liên kết giữa Web App, API Service, Node.js Engine và Database Node.
Package/Module Diagram (Sơ đồ phân ranh gói): Định ranh giới các thư mục trong src/ và luật cấm import chéo.
Sequence Diagram (Sơ đồ tuần tự): Mô tả dòng chảy thời gian của Request đi qua Controller → Service → Repository → Prisma → DB.
Activity Diagram (Sơ đồ hoạt động): Mô tả các bước Validation, rẽ nhánh nghiệp vụ logical bên trong Service.
State Machine Diagram (Sơ đồ máy trạng thái): Mô tả chu kỳ biến động State của User/Member/Tenant.
Dependency Graph (Đồ thị phụ thuộc): Minh họa mối quan hệ phụ thuộc giữa các Doctrine trong Handbook.
CHƯƠNG 12. NAMING CONVENTION (QUY ƯỚC ĐẶT TÊN ĐỒNG BỘ)
Mọi định danh trong dự án phải tuân thủ nghiêm ngặt bộ luật Kebab-case cho tệp vật lý và viết hoa tiền tố cho mã tài liệu:
Document ID Prefix:
Handbook: EGAL-VOL[Số Volume]-CH[Số Chương]-[TÊN MÔ-ĐUN]
ADR ID: EGAL-ADR-[Số thứ tự 4 số] (Ví dụ: EGAL-ADR-0001)
Business Specification ID: EGAL-BS-[Số thứ tự 4 số] (Ví dụ: EGAL-BS-0002)
Review Checklist ID: EGAL-RC-[MÃ TẦNG]-[Số thứ tự 3 số] (Ví dụ: EGAL-RC-DB-001)
File & Folder Name: Kebab-case toàn phần (lower-case-with-hyphens). Cấm viết hoa camelCase. Ví dụ: member-onboarding.service.js.
CHƯƠNG 13. REVIEW POLICY (CHÍNH SÁCH KIỂM DUYỆT VĂN BẢN)
Một tài liệu muốn được chuyển sang trạng thái APPROVED bắt buộc phải vượt qua vòng kiểm duyệt chéo gồm 3 vai trò độc lập:
Author (Người viết): Tự cam kết tuân thủ đầy đủ Definition of Done (DoD) của tài liệu và cấu trúc quy định tại EDS v1.0.
Peer Reviewer (Kỹ sư đồng cấp):** Kiểm tra tính logic, phát hiện các điểm mơ hồ, mâu thuẫn từ ngữ hoặc rò rỉ phân tầng kiến trúc.
Chief Architect (Chốt chặn tối cao): Kiểm tra sự tương thích kiến trúc toàn cục, xác nhận tính bất biến của hệ thống và ký duyệt điện tử đóng băng văn bản.
CHƯƠNG 14. QUALITY GATES (CỔNG KIỂM SOÁT CHẤT LƯỢNG)
Hệ thống CI/CD Tài liệu sẽ tự động REJECT (Từ chối) xuất bản bất kỳ tài liệu nào vi phạm một trong 5 Cổng Chất Lượng sau:
Gate 01: Thiếu hoặc khai báo không đầy đủ khối Metadata Standard quy định tại Chương 9.
Gate 02: Có các đầu mục Outline trống không có nội dung đặc tả chi tiết (Tài liệu chỉ có tiêu đề không có văn bản thực thi kỹ thuật).
Gate 03: Thiếu phần References hoặc các đường dẫn tĩnh Markdown (*.md) nội bộ cấu trúc thư mục bị gãy hỏng.
Gate 04: Không có bảng lịch sử sửa đổi Revision History ở phần đầu trang.
Gate 05: Không phản hồi đầy đủ tiêu chí của bộ khung 7 câu hỏi đóng băng kiến trúc đối với các Doctrine cốt lõi.
CHƯƠNG 15. APPENDIX (BIỂU MẪU CỐT LÕI MẪU TĨNH)
1. Template Đóng Gói Một ADR Chuẩn Bản Tin Enterprise
# 📑 EGAL ARCHITECTURE DECISION RECORD | [TIÊU ĐỀ QUYẾT ĐỊNH]* **Document ID:** EGAL-ADR-[XXXX]* **Title:** [Tiêu đề quyết định]* **Status:** [PROPOSED / ACCEPTED / REJECTED / SUPERSEDED]* **Created Date:** [ISO 8601]* **Updated Date:** [ISO 8601]---### 1. Bối cảnh hệ thống (Context)[Mô tả chi tiết môi trường thực tế, các rào cản công nghệ và thực trạng mã nguồn dẫn đến việc cần ra quyết định này].### 2. Vấn đề kiến trúc (Problem)[Đặc tả tường minh nút thắt cổ chai, rủi ro sụp đổ kiến trúc hoặc lỗi hệ thống nếu không có giải pháp can thiệp].### 3. Quyết định kỹ thuật tối cao (Decision)[Tuyên bố giải pháp kỹ thuật được chọn lựa để áp đặt lên hệ thống].### 4. Các phương án thay thế đã bị từ chối (Alternatives Considered & Rejected Options)* **Phương án A:** [Tên giải pháp] -> [Lý do từ chối: Vì sao không chọn].* **Phương án B:** [Tên giải pháp] -> [Lý do từ chối: Vì sao không chọn].### 5. Hệ quả kiến trúc mang lại (Consequences)* **Hệ quả tích cực (Benefits):** [Những gì hệ thống đạt được].* **Hệ quả tiêu cực / Rủi ro đánh đổi (Trade-offs):** [Những gì lập trình viên phải chịu đựng hoặc khối lượng công việc tăng thêm].### 6. Ảnh hưởng trực tiếp đến Implementation (Implementation Impact)[Định hướng trực tiếp cho Senior Engineer cách viết code tuân thủ quyết định này].### 7. Tài liệu viện dẫn (References)[Link trỏ đến Handbook Vol và Chương liên quan].
2. Template Đóng Gói Một Business Specification Chuẩn
# 📑 EGAL BUSINESS SPECIFICATION | [TIÊU ĐỀ LUỒNG NGHIỆP VỤ]* **Document ID:** EGAL-BS-[XXXX]* **Title:** [Tiêu đề luồng nghiệp vụ]* **Version:** [X.Y.Z]* **Status:** [DRAFT / APPROVED / FROZEN]---### 1. Business Invariants (Bất biến nghiệp vụ)[Mô tả các điều kiện bắt buộc luôn luôn đúng trong mọi trạng thái hệ thống].### 2. Workflow Specification* **Trigger:** [Tác nhân kích hoạt]* **Precondition:** [Điều kiện tiên quyết]* **Input:** [Cấu trúc dữ liệu đầu vào]* **Validation Rules:** [Quy tắc kiểm tra dữ liệu]* **Transaction Boundary:** [Phạm vi bọc transaction]* **Output / State Transition:** [Kết quả đầu ra và dịch chuyển trạng thái]