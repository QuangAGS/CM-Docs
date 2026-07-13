VOLUME II: BUSINESS DOMAINS
[VOL II - 04] LINEAGE & MEMBER DOMAIN SPECIFICATION (FINAL FROZEN VERSION)
Trạng thái: Frozen (Bất biến) | Phiên bản: V2.0 (Refactored & Closed via Architecture Review)
Hệ thống: Web App Quản lý Dòng họ (Clan Management Platform)
Cấu trúc thực thi: Unified Domain Specification Contract (Domain-Driven Design Enforced)
1. PURPOSE (MỤC ĐÍCH)
Tài liệu này đặc tả chi tiết miền nghiệp vụ cốt lõi tối cao của hệ thống: Lineage & Member Domain (Miền Phả Hệ & Thành Viên). Miền này chịu trách nhiệm độc quyền quản lý toàn bộ vòng đời của thực thể con người (Thành viên), các cấp phân tách đơn vị dòng họ (Chi phái) và các mối quan hệ cấu trúc (Huyết thống, Hôn nhân, Nhận nuôi) cấu thành Đồ thị phả hệ dòng họ. Đây là nút gốc (Root Node) trong Đồ thị hướng không chu trình (DAG) phụ thuộc của tổng thể hệ thống, cung cấp cơ chế định danh độc nhất toàn cục cho mọi phân hệ nghiệp vụ khác tham chiếu tới.
2. PRIMARY DESIGN QUESTION (CÂU HỎI THIẾT KẾ CỐT LÕI)
"Làm thế nào để mô hình hóa cấu trúc phả hệ đa tầng, đa nhánh phức tạp trong văn hóa truyền thống Việt Nam (bao gồm các ca đặc biệt như: tái hôn đa phu/đa thê, con nuôi, nhận họ muộn, tuyệt tự) thành một mô hình đồ thị logic (Graph Model) bất biến, kiểm soát chặt chẽ các ràng buộc toàn vẹn (Invariants), ngăn chặn tuyệt đối lỗi đệ quy vòng lặp (Circular Pedigree Error), và tối ưu hóa tốc độ truy vấn cây hàng vạn nút thời gian thực?"
3. SCOPE & RESPONSIBILITIES (RANH GIỚI & TRÁCH NHIỆM MIỀN)
3.1 Trong phạm vi (Scope)
Member Profile Lifecycle: Khởi tạo, cập nhật thông tin sinh học (Biographical Data), trạng thái sinh/tử, và lưu vết hồ sơ cá nhân của một thành viên.
Relationship Linkage & Taxonomy: Thiết lập và quản lý các cạnh quan hệ (Edges) đa dạng: Huyết thống, Hôn nhân, Con nuôi, Người giám hộ.
Clan Structure Hierarchy: Quản lý phân cấp cấu trúc dòng họ thành các Chi, Nhánh, Cành, Đời (Thế hệ) tương ứng với mô hình tự trị phân cấp.
Kinship Derivation: Logic tính toán đường đi trên đồ thị để trích xuất danh xưng xưng hô chuẩn xác giữa hai thành viên bất kỳ.
3.2 Ngoài phạm vi (Out of Scope)
Không quản lý việc tính toán lịch giỗ chạp hay điều phối sự kiện tâm linh (trách nhiệm của [VOL II - 05] Event & Ritual Domain).
Không quản lý lịch sử đóng góp tài chính hay sổ cái thu chi dòng họ (trách nhiệm của [VOL II - 06] Ledger Domain).
Không đặc tả giao thức truyền tải API hay lưu trữ tệp tin media vật lý (nhường chỗ cho Volume III).
3.3 Bản đồ Trách nhiệm Miền (Domain Responsibilities)
Sở hữu thực thể (Owns)
Tham chiếu ngoài (References)
Phát sự kiện (Publishes)
Tiêu thụ sự kiện (Consumes)
 
Member
Relationship
Branch
Generation
Doctrine
Security
Event
Ledger
MemberCreated
MemberUpdated
MemberDeceased
RelationshipCreated
RelationshipRemoved
BranchCreated
DoctrineChanged
4. CANONICAL VOCABULARY (TỪ ĐIỂN THUẬT NGỮ CHUẨN TẮC)
Bộ từ điển này thiết lập ngôn ngữ chung (Ubiquitous Language) bắt buộc cho việc đặt tên thực thể, mã nguồn và dữ liệu:
Clan (Dòng họ): Tổ chức gia tộc tổng thể sở hữu một không gian số độc lập.
Branch (Chi/Nhánh): Đơn vị phân cấp tự trị dưới Clan (Ví dụ: Chi trưởng, Chi hai, Nhánh ngành).
Member (Thành viên): Một cá nhân sinh học thuộc phả hệ hoặc có quan hệ hôn nhân với dòng họ.
Root Ancestor (Cụ Tổ Khởi Tổ): Nút cội nguồn tối cao cao nhất của toàn bộ cây đồ thị phả hệ.
Ancestor (Tổ tiên): Bất kỳ nút tiền bối nào nằm trên đường đi ngược dòng của một Member.
Descendant (Hậu duệ): Bất kỳ nút hậu bối nào phát triển từ một Member xuống dưới.
Generation (Thế hệ/Đời): Thứ tầng tính từ Root Ancestor (Đời 1) tăng dần xuống dưới.
Relationship (Quan hệ): Cạnh kết nối logic giữa hai thực thể cá nhân.
Biological Parent (Cha mẹ đẻ): Người có quan hệ huyết thống trực tiếp sinh ra thành viên.
Adopted Child (Con nuôi): Thành viên được nhận nuôi, có ràng buộc pháp lý/văn hóa nhưng không mang huyết thống gốc.
Spouse (Phối ngẫu): Vợ hoặc chồng của thành viên.
5. DEPENDENCIES (SỰ PHỤ THUỘC TÀI LIỆU)
Kế thừa cốt lõi (Inputs): Chịu sự định hướng chiến lược từ [VOL I - 01] Product Vision Blueprint, tuân thủ nguyên tắc chủ quyền dữ liệu của [VOL I - 02] Business Doctrine Blueprint và kế thừa bộ 7 nguyên lý kỹ thuật của [VOL I - 03] Product Architecture Blueprint.
Cung cấp nền tảng (Outputs): Cung cấp ID thực thể cốt lõi cho các miền nghiệp vụ phụ thuộc: [VOL II - 05] Event & Ritual Domain Specification, [VOL II - 06] Ledger Domain Specification, và [VOL II - 09] Security & Trust Domain Specification.
6. DOMAIN MODEL & WORKFLOWS (MÔ HÌNH MIỀN & TIẾN TRÌNH)
6.1 Cấu trúc Cây Tổng hợp (Aggregate Root Strategy)
Miền thực thi mô hình phân cấp nghiêm ngặt nhằm phục vụ kiến trúc cô lập dữ liệu:
Clan (Aggregate Root) $\longrightarrow$ Branch $\longrightarrow$ Member
Mọi truy cập hoặc biến đổi thông tin lên thành viên bắt buộc phải đi qua ngữ cảnh của không gian Dòng họ tổng thể để thực thi cơ chế ranh giới dữ liệu.
6.2 Mô hình Khái niệm Đồ thị Phả hệ & Cardinality (Conceptual Graph & Cardinality)
Member Node (Nút Thành viên): Chứa thông tin sinh học, ID Chi tộc trực thuộc.
Phân loại Quan hệ (Relationship Types Taxonomy):
BLOOD: Quan hệ huyết thống trực系 (Cha/Mẹ đẻ - Con).
MARRIAGE: Quan hệ hôn nhân chính danh (Vợ/Chồng).
ADOPTION: Quan hệ nhận nuôi (Cha mẹ nuôi - Con nuôi).
STEP_PARENT: Quan hệ cha dượng / mẹ kế.
GUARDIANSHIP: Quan hệ người giám hộ văn hóa/tộc sự.
Quy tắc Bản số (Cardinality Rules):
Mỗi Thành viên có: 0..2 Biological Parents (Cha mẹ đẻ).
Mỗi Thành viên có: 0..2 Adoptive Parents (Cha mẹ nuôi).
Mỗi Thành viên có: 0..N Spouses (Phối ngẫu - xử lý ca đa phu/đa thê/tái hôn).
Mỗi Thành viên có: 0..N Children (Con cái).
6.3 Máy Trạng thái Vòng đời Hồ sơ Thành viên (Member Profile State Machine)
Vòng đời trạng thái của một cá nhân được chuẩn hóa để tránh nhầm lẫn với việc xóa dữ liệu vật lý:
[PROPOSED] ──(Hội đồng / Trưởng chi duyệt chính danh)──> [ACTIVE] (Còn sống)                                                              │                                                   (Phát sinh sự kiện tạ thế)                                                              │                                                              ▼                                                    [MEMORIALIZED] (Đã tạ thế)
Trạng thái MEMORIALIZED giữ nguyên vị trí Node trên cây phả hệ, khóa các trường thông tin thay đổi sinh học, chỉ mở các luồng thông tin tâm linh tâm đức.
6.4 Mô hình Hiển thị Phổ quát (Read Models)
Để phục vụ các nhu cầu trích xuất hiển thị đa dạng của người dùng, hệ thống định nghĩa sẵn 5 cấu trúc Read Models chuyên trách:
Pedigree Tree: Mô hình đồ thị dạng cây phục vụ vẽ sơ đồ tổng thể dòng họ.
Generation View: Mô hình hiển thị phân mảnh đồng phẳng theo từng cấp thế hệ/đời.
Branch View: Mô hình cắt lọc dữ liệu riêng biệt cho một Chi phái tự trị cụ thể.
Ancestor Path: Đường đi ngược dòng tìm cội nguồn từ một nút bất kỳ về Root Ancestor.
Kinship Path: Chuỗi liên kết quan hệ giữa hai thành viên bất kỳ để xác định vai vế xưng hô.
6.5 Chuỗi Tiến trình Thẩm định Biến đổi Cây (Lineage Mutation Pipeline)
Mutation Request $\longrightarrow$ Doctrine Evaluation $\longrightarrow$ Domain Validation $\longrightarrow$ Commit $\longrightarrow$ Event Publication
7. DOMAIN INVARIANTS (CÁC RÀNG BUỘC TOÀN VẸN BẤT BIẾN)
Mọi dòng mã nguồn được sinh ra hoặc hành vi dữ liệu phải bảo vệ tuyệt đối các Invariants sau:
INV-01 (Mã định danh bất biến): Member ID và Branch ID sau khi khởi tạo thành công không bao giờ được phép thay đổi trong suốt vòng đời hệ thống.
INV-02 (Tính vĩnh cửu của cội nguồn): Nút cụ tổ khởi tổ (Root Ancestor Node) không bao giờ được phép xóa bỏ khỏi hệ thống.
INV-03 (Tính sở hữu đơn nhất): Mỗi thành viên tại một thời điểm chỉ thuộc về duy nhất một cấu trúc Clan Instance xác định.
INV-04 (Tính phi chu trình): Mọi liên kết quan hệ dạng huyết thống không được tạo thành vòng lặp đệ quy kín trên đồ thị (No Graph Cycles).
INV-05 (Bảo toàn lịch sử): Các sự kiện lịch sử tiểu sử đã ghi nhận không bao giờ được phép ghi đè hay xóa bỏ, chỉ cho phép tạo phiên bản sửa đổi mới.
8. DOMAIN EVENTS (DANH SÁCH SỰ KIỆN MIỀN)
Đây là danh sách các sự kiện nghiệp vụ thuần túy phát ra khi trạng thái miền biến đổi:
MemberCreated: Phát ra khi một hồ sơ thành viên mới được khởi tạo ở trạng thái đề xuất.
MemberUpdated: Phát ra khi thông tin tiểu sử, thông tin sinh học của thành viên có đính chính.
MemberDeceased: Phát ra khi thành viên chuyển trạng thái từ ACTIVE sang MEMORIALIZED.
RelationshipCreated: Phát ra khi thiết lập thành công một cạnh quan hệ (Huyết thống/Hôn nhân/Nhận nuôi) giữa hai cá nhân.
RelationshipRemoved: Phát ra khi gỡ bỏ một cạnh quan hệ (ví dụ: hủy quan hệ hôn nhân do ly hôn).
BranchCreated: Phát ra khi một Chi phái mới được khai sinh trong dòng họ tổng thể.
9. ARCHITECTURE DECISIONS (QUYẾT ĐỊNH KIẾN TRÚC MIỀN - ADR)
Decision 01: Graph Abstraction Framework. Miền quyết định biểu diễn phả hệ bằng mô hình đồ thị thuần túy ở tầng logic, tách biệt khỏi cơ sở dữ liệu vật lý để tối ưu các truy vấn đệ quy sâu tìm cụ tổ hoặc quan hệ họ hàng gần xa, nhưng mô hình miền phải có khả năng export ra định dạng kịch bản chuỗi cạnh (Edge-List) để phục vụ mục tiêu lưu giữ trường tồn vĩnh viễn.
Decision 02: Append-Only Biographical Audit Chain. Các thông tin tiểu sử nhạy cảm (như thay đổi tên họ, đính chính ngày mất) không được phép sửa đè trực tiếp mà phải lưu vết dưới dạng một chuỗi Audit log tăng tiến nhằm hiện thực hóa triết lý "Lịch sử bất biến".
Decision 03: Unified Relationship Modeling Strategy. Hệ thống quyết định không thiết kế các bảng thực thể riêng biệt cho từng loại quan hệ phức tạp. Thay vào đó, quy hoạch đồng nhất về một cấu trúc Cạnh quan hệ tổng thể kèm theo siêu dữ liệu phân loại (`Relationship Types Taxonomy`). Thiết kế này đảm bảo hệ thống có khả năng thích ứng cao, sẵn sàng mở rộng các hình thái quan hệ phát sinh trong tương lai mà không cần tái cấu trúc cơ sở dữ liệu cốt lõi.
10. CROSS REFERENCES (THAM CHIẾU CHÉO)
Đối chiếu tiêu chí thành công của trải nghiệm dựng cây tại [VOL I - 01] Product Vision Blueprint.
Kế thừa nguyên tắc chủ quyền dữ liệu phân cấp chi tộc tại [VOL I - 02] Business Doctrine Blueprint.
Tham chiếu mô hình 7 nguyên lý kỹ thuật xương sống tại [VOL I - 03] Product Architecture Blueprint.
[KẾT THÚC TÀI LIỆU VOL II - 04 V2. TOÀN BỘ NỘI DUNG ĐÃ ĐƯỢC KHÓA CỨNG - FINAL FROZEN]