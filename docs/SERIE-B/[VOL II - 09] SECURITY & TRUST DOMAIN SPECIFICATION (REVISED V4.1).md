VOLUME II: BUSINESS DOMAINS
[VOL II - 09] SECURITY & TRUST DOMAIN SPECIFICATION (REVISED V4.1)
Trạng thái: Baseline Approved | Phiên bản: V4.1 (Integrated Cross-cutting Security Doctrines)
Hệ thống: Web App Quản lý Dòng họ (Clan Management Platform)
Cấu trúc thực thi: Unified Domain Specification Contract (Domain-Driven Design Enforced)
1. PURPOSE (MỤC ĐÍCH)
Tài liệu này đặc tả chi tiết miền nghiệp vụ Security & Trust Domain (Miền Danh Tính, Bảo Mật & Quản Trị Ủy Quyền). Miền này đóng vai trò là "Hiến pháp bảo mật kỹ thuật số" tối cao, chịu trách nhiệm canh giữ tính toàn vẹn sử liệu và phân định quyền bính số trong không gian của dòng tộc. Nhiệm vụ cốt lõi bao gồm: Mô hình hóa danh tính phả hệ đặc thù; Thiết lập mô hình Quản trị Ủy quyền thông qua phê duyệt đa chữ ký (Multi-sig Governance) của Hội đồng gắn liền với Sổ cái quản trị; Cách ly bảo vệ dữ liệu nhạy cảm của con em vị thành niên; và Thực thi bộ quy tắc chống lạm dụng, càn quét sử liệu. Toàn bộ miền được xây dựng để độc lập hoàn toàn với hạ tầng kỹ thuật gửi nhận tin (OTP/SMS) hay công nghệ định danh vật lý, bảo toàn giá trị kiến trúc trường tồn qua nhiều thập kỷ.
2. PRIMARY DESIGN QUESTION (CÂU HỎI THIẾT KẾ CỐT LÕI)
"Làm thế nào để kiến trúc một mô hình kiểm soát truy cập động theo tọa độ huyết thống (Lineage-Aware Access Control - LAAC) hỗ trợ ủy quyền thích ứng ACXD, tích hợp bộ máy đồng thuận phi trạng thái phục vụ luồng Multi-sig Hội đồng, khống chế payload di động dưới 100 KB, đồng thời chuẩn hóa hệ thống 9 chính sách bảo mật trừu tượng để cô lập tuyệt đối dữ liệu con em một cách độc lập với mọi biến động công nghệ?"
3. SCOPE & RESPONSIBILITIES (RANH GIỚI & BẢN ĐỒ NĂNG LỰC)
3.1 Khung phân rã Năng lực Miền (Domain Capability Structure)
Để triệt tiêu sự chồng chéo nghiệp vụ và tối ưu hóa tính độc lập theo triết lý Domain-Driven Design, miền được quy hoạch thành 4 Capability lõi:
Capability 1: Lineage-Aware Identity (Danh tính Phả hệ): Quản lý, xác thực thực thể bảo mật số gắn chặt với tọa độ sinh học của thành viên trên cây gia phả chính sử, định hình cấu trúc vai trò huyết tộc động và xử lý bản đồ ủy quyền trực hệ (Delegate Mapping).
Capability 2: Council Multi-sig Governance (Quản trị Ủy quyền Hội đồng): Điều phối vòng đời biểu quyết, thu thập chữ ký số từ các thành viên Hội đồng tộc sự đối với các thay đổi trọng yếu liên quan đến Doctrine, phả hệ hoặc ngân sách lớn; ép buộc đồng bộ dữ liệu sang phân hệ Ledger.
Capability 3: Minor Data Protection (Bảo vệ Dữ liệu Con em): Cách ly, che mờ và áp dụng các cấp độ bảo vệ nghiêm ngặt đối với thông tin của thành viên dưới tuổi vị thành niên theo nguyên lý Zero-Knowledge Proof (ZKP).
Capability 4: Anti-Abuse & Data Audit (Chống Lạm dụng & Kiểm toán): Giám sát các mẫu hành vi tương tác dữ liệu, phân tích chỉ số bất thường nhằm ngăn chặn càn quét (scraping), rò rỉ sử liệu và duy trì sổ nhật ký kiểm toán bất biến băm chuỗi liên kết.
3.2 Ngoài phạm vi (Out of Scope)
Không sở hữu và xử lý kỹ thuật hạ tầng viễn thông, gửi nhận tin nhắn OTP/SMS/Email (trách nhiệm thuộc về [VOL II - 07] Communication Domain).
Không quản lý số dư tài khoản tiền mặt, không can thiệp lệnh chuyển tiền vật lý của quỹ tộc (trách nhiệm thuộc về [VOL II - 06] Ledger Domain).
Không ràng buộc vào bất kỳ giải pháp thiết bị xác thực phần cứng cụ thể nào (như khóa Yubikey, FaceID cụ thể) mà chỉ giao tiếp qua các giao thức mật mã học chuẩn hóa trừu tượng.
3.3 Bản đồ Trách nhiệm Miền (Domain Responsibilities)
Sở hữu thực thể (Owns)
Tham chiếu ngoài (References)
Phát sự kiện (Publishes)
Tiêu thụ sự kiện (Consumes)
 
SecurityIdentity
GovernanceProposal
CouncilSignature
MinorPrivacyRule
AuditAnomalyRecord
CouncilVotingProjection
Member Root (VOL II-04)
DelegateMapping (VOL II-04)
AccountLedger (VOL II-06)
DoctrineMatrix (VOL I-02)
IdentityStateChanged
MultiSigFlowInitiated
CouncilVoteCast
GovernanceProposalConcluded
PrivacyBreachDetected
AnomalousBehaviorBlocked
CircuitBreakerActivated
IdentityVerificationRequested
GovernanceReviewTriggered
DataAccessEventCaptured
SystemThresholdExceeded
4. CANONICAL VOCABULARY & ENTITIES (TỪ ĐIỂN THUẬT NGỮ & THỰC THỂ CHUẨN TẮC)
Lineage-Aware Access Control (LAAC): Mô hình kiểm soát truy cập đặc thù dựa trên đồ thị phả hệ, trong đó quyền bính số của thực thể được tính toán động từ mối quan hệ huyết thống, thứ bậc, chi phái và bản đồ ủy quyền trực hệ.
Authorization Formula (Công thức Phân quyền): Hàm logic chuẩn hóa để tính toán ra tập hợp các hành vi hợp lệ của một danh tính số tại một thời điểm ngữ cảnh xác định.
High Assurance Identity Verification: Quy trình xác thực danh tính mức độ tin cậy cao, sử dụng các phương thức mật mã hóa hoặc đối soát sinh trắc học không thể chối từ nhằm phục vụ các lệnh Multi-sig tối cao cấp Hội đồng.
Configured Emergency Channel: Kênh thông báo khẩn cấp được thiết lập động qua cấu hình hệ thống (không định danh cứng công nghệ như SMS hay Telegram) để phát tín hiệu cảnh báo an ninh tức thời.
5. RELATED DOCUMENTS (TÀI LIỆU LIÊN QUAN)
Consumer of (Tiêu thụ đầu vào): Trực tiếp kế thừa và bảo vệ khung Hiến pháp dòng tộc tại [VOL I - 02] V2.1. Tiếp nhận các cấu trúc đề xuất logic từ [VOL II - 08] V3.1 để chuyển đổi thành luồng biểu quyết Hội đồng. Tiêu thụ mô hình Cursor Pagination từ [VOL I - 03] V2.1.
Referenced By (Được sử dụng bởi): Là bộ lọc an ninh tối cao, cấp phát Token/Session an toàn cho mọi tiến trình mutation bên [VOL II - 04] Lineage & Member Domain và [VOL II - 06] Financial & Governance Ledger Domain trước khi các miền này commit dữ liệu.
6. DOMAIN COMMANDS, MODEL & WORKFLOWS (LỆNH MIỀN, MÔ HÌNH & TIẾN TRÌNH)
6.1 Mô hình Công thức Phân quyền LAAC (LAAC Authorization Formula)
Quyền truy cập hợp lệ (Permission) của một thực thể số đối với một tài nguyên hệ thống (Resource) tại một thời điểm được tính toán động dựa trên hàm logic chuẩn hóa sau:
Permission = $f$(Role, LineagePosition, BranchOwnership, DelegateMapping, DoctrineMatrix, SessionContext, ResourceClassification)
Trong đó biến số tích hợp mới: DelegateMapping cho phép một thành viên được ủy quyền hợp pháp (con cái hành động thay cha mẹ bách niên lão thành) thực thi các tác vụ trong phạm vi cấu hình mà không làm ô nhiễm hay vi phạm quy tắc LAAC gốc, hiện thực hóa triệt để học thuyết trải nghiệm khách thích ứng ACXD.
6.2 Máy trạng thái Vòng đời Thực thể Danh tính (SecurityIdentity State Machine)
[PENDING_VERIFICATION] ───(Xác thực Danh tính)───> [ACTIVE]
       │                                             │
  (Từ chối/Hết hạn)                          (Phát hiện Rủi ro)
       │                                             │
       ▼                                             ▼
   [REVOKED]                                   [SUSPENDED]
                                                    │
                                               (Tấn công vi phạm nặng)
                                                    │
                                                    ▼
   [ARCHIVED] <────────(Hủy kích hoạt) <──────── [LOCKED]
6.3 Máy trạng thái Đề xuất Quản trị Hội đồng (GovernanceProposal State Machine)
[INITIATED] ───(Kích hoạt Luồng)───> [VOTING]
                                        │
                      ┌─────────────────┴─────────────────┐
               (Đạt ngưỡng chữ ký) (Hết hạn / Bị phủ quyết)
                      │ │
                      ▼ ▼
                 [APPROVED] [EXPIRED]
                      │ │
              (Thực thi Command & Ghi Sổ cái) ▼
                      │ [ARCHIVED]
                      ▼
                 [EXECUTED] ──────────────────────────────┘
Ràng buộc tích hợp Sổ cái tối cao: Khi một đề xuất chuyển sang trạng thái APPROVED/EXECUTED hoặc bị EXPIRED do hết hạn, hệ thống bắt buộc phải phát ra sự kiện đồng bộ để phân hệ Financial & Governance Ledger Domain lập biên bản ghi sổ vĩnh viễn (Governance Ledger Entry), ký số băm chuỗi chống tẩy xóa.
6.4 Hạ tầng Nén Tải trọng Di động (Mobile-First API Layout)
CouncilVotingSummaryProjection: Định hình cấu trúc trả về tối giản qua GraphQL Gateway cho ứng dụng di động của các thành viên Hội đồng tộc sự. Khống chế nghiêm ngặt Payload luôn dưới ngưỡng 100 KB bằng cách loại bỏ toàn bộ chuỗi JSON lệnh Mutation phức tạp, chỉ kết xuất: [governance_proposal_id, source_domain, threshold_required, current_signature_count, status, expires_at] phối hợp kỹ thuật phân trang Cursor Pagination.
7. DOMAIN INVARIANTS (CÁC RÀNG BUỘC TOÀN VẸN BẤT BIẾN)
INV-01 (Tính Bất biến của Luồng Biểu quyết - Multi-sig Immutability): Một khi thực thể GovernanceProposal đã chuyển sang trạng thái VOTING, tuyệt đối không một cá nhân hay tiến trình hệ thống nào có quyền chỉnh sửa payload lệnh, hạ thấp tỷ lệ ngưỡng phê duyệt tối thiểu (threshold_required) hoặc chèn thêm chữ ký số giả mạo. Mọi chữ ký gán vào thực thể bắt buộc phải chứa bằng chứng mật mã hóa (cryptographic_proof) không thể phủ nhận của chính danh tính số đó.
INV-02 (Cách ly Tuyệt đối Dữ liệu Vị thành niên): Mọi bản ghi thuộc diện quản lý của MinorPrivacyRule bắt buộc phải được mã hóa ở tầng lưu trữ dữ liệu thô bằng một khóa mã hóa động biệt lập. Nghiêm cấm mọi hành vi kết xuất dữ liệu thô của trẻ em ra bên ngoài mà không thông qua bộ lọc che mờ (Data Redaction Filter).
INV-03 (Bất biến Nhật ký Kiểm toán): Toàn bộ thực thể AuditAnomalyRecord và log an ninh hệ thống chỉ được phép ghi thêm (Append-only). Bất kỳ hành vi nào cố tình sửa đổi hoặc xóa vết log an ninh sẽ bị hệ thống nhận diện là một sự cố phá hoại an ninh nghiêm trọng cấp độ cao nhất, tự động kích hoạt lệnh khóa cứng tức thời toàn hệ thống.
8. SECURITY POLICY MODEL (MÔ HÌNH CHÍNH SÁCH BẢO MẬT NGHIỆP VỤ ĐA TẦNG)
Lớp chính sách bảo mật nghiệp vụ trừu tượng độc lập hoàn toàn với các giải pháp công nghệ hiện thực hóa thương mại bên dưới:
Nhóm Chính sách (Policy Type)
Nội dung Quy tắc & Cơ chế Kiểm soát (Enforcement Rules)
 
8.1 Authentication Policy
Phân tầng 3 cấp độ tin cậy danh tính (identity_level). Cấp 1 (Tương tác thông thường: password/mTLS ngắn hạn); Cấp 2 (Quản lý thu chi thường nhật, xem sử liệu sâu: Yêu cầu MFA); Cấp 3 (Biểu quyết Hội đồng, phê duyệt ngân sách lớn vượt hạn mức: Bắt buộc sử dụng High Assurance Identity Verification).
8.2 Authorization Policy
Thực thi LAAC thời gian thực dựa trên đồ thị phả hệ và ma trận Doctrine. Cấm tuyệt đối tồn tại quyền hạn bắc cầu xuyên biên giới chi phái trừ khi có cấu hình hợp lệ của thực thể DelegateMapping kế thừa từ Vol II-04.
8.3 Privacy Policy
Ma trận bảo vệ trẻ vị thành niên qua 4 cấp độ lọc: FULL_ACCESS (Cha mẹ/Người giám hộ); MASKED (Tên viết tắt + năm sinh cho nội tộc); AGGREGATED (Số liệu thống kê khuyến học tổng hợp); DENIED (Chặn toàn bộ quyền truy cập đối với tài khoản ngoài tộc hoặc có chỉ số rủi ro cao).
8.4 Audit Policy
Nhật ký kiểm toán bắt buộc phải băm liên kết mã hóa khối (Internal Blockchain SHA-256) tuần tự giữa bản ghi trước và bản ghi sau. Định kỳ chạy tiến trình đối soát tự động, mọi sai lệch mã băm sẽ lập tức kích hoạt báo động khẩn cấp.
8.5 Threat Response Policy
Cắt mạch phòng thủ tự động (Circuit Breaker). Khi violation_score của một tài khoản vượt ngưỡng quy định trong chính sách động, hệ thống tự động khóa danh tính bảo mật, chấm dứt toàn bộ Session hiện hành và chặn IP mà không cần can thiệp thủ công.
8.6 Key Management Policy
Xoay vòng khóa mã hóa dữ liệu trẻ em và chữ ký số Hội đồng (encryption_key_reference) tự động định kỳ theo chính sách an ninh hệ thống, tách biệt hoàn toàn khỏi lớp lưu trữ dữ liệu nghiệp vụ.
8.7 Session Policy
Phiên làm việc cấp 3 của thành viên Hội đồng tộc sự có thời hạn tồn tại tối đa không quá 15 phút và lập tức hủy bỏ nếu phát hiện thay đổi dấu vân tay trình duyệt hoặc thay đổi mạng IP đột ngột.
8.8 Registration Policy
Hồ sơ danh tính mới tạo mặc định nằm ở trạng thái PENDING_VERIFICATION. Quyền hạn bị giới hạn ở mức Zero-Trust cho đến khi hoàn tất đối soát thực tế bởi Trưởng chi phái sở tại.
8.9 Data Retention Policy
Vết log an ninh và thực thể kiểm toán được lưu trữ vĩnh viễn, nghiêm cấm hành vi dọn dẹp (Purge/Truncate) dữ liệu thô dưới mọi hình thức để bảo toàn lịch sử hệ thống qua nhiều thế hệ.

9. FAILURE POLICIES (CHÍNH SÁCH XỬ LÝ SỰ CO BẢO MẬT & KHẨN CẤP)
Tình huống lỗi / Tấn công (Threat Scenario)
Chính sách phản ứng khẩn cấp (Enforcement Policy)
 
Vượt ngưỡng Tần suất Khai thác Dữ liệu (Scraping Detected)
Lập tức khóa trạng thái danh tính về `LOCKED`, phát sự kiện `AnomalousBehaviorBlocked`, giải phóng toàn bộ Token hiện hành, cắt mạch kết nối IP nguồn và bắn tín hiệu báo động khẩn cấp về Configured Emergency Channel.
Nghi ngờ Rò rỉ Khóa Bảo mật Hội đồng
Hủy bỏ toàn bộ các đề xuất `GovernanceProposal` đang nằm trong luồng biểu quyết liên quan, chuyển trạng thái về `EXPIRED`. Đình chỉ quyền ký số của danh tính nghi ngờ, ép buộc chuyển trạng thái về `SUSPENDED` cho đến khi thực hiện thành công quy trình xác thực trực tiếp.
Tấn công Leo thang Đặc quyền Hệ thống
Kích hoạt trạng thái phòng thủ đóng băng (Read-only mode) trên toàn cục phả hệ trong vòng 30 phút. Phát sự kiện `CircuitBreakerActivated` ra Event Bus để cô lập hoàn toàn phân hệ API Mutation, bảo vệ tính bất biến của chính sử dòng họ khỏi nguy cơ bị sửa đổi trái phép.

10. ARCHITECTURE DECISIONS (QUYẾT ĐỊNH KIẾN TRÚC MIỀN - ADR)
Mã Quyết định
Nội dung giải pháp & Ràng buộc kiến trúc (ADR Core)
 
ADR-01: Lineage-Aware Access Control (LAAC) Framework
Kiến trúc chính thức khai sinh mô hình phân quyền động LAAC thay thế cho các giải pháp RBAC thương mại tĩnh thông thường. Quyền hạn thao tác dữ liệu được tính toán thời gian thực dựa trên đồ thị phả hệ, tôn ti trật tự, mối quan hệ trực hệ giữa danh tính và tài nguyên chi phái cụ thể, kết hợp biến số ủy quyền thích ứng ACXD (Delegate Mapping).
ADR-02: Cryptographic Multi-sig via Stateless Order Verification
Tiến trình gom chữ ký số của Hội đồng tộc sự được thiết kế theo mô hình phi trạng thái. Hệ thống kiểm chứng trực tiếp tính hợp lệ của mảng chuỗi liên kết bằng chứng mật mã hóa kèm mã băm SHA-256 của payload lệnh tại thời điểm kiểm tra, loại bỏ nguy cơ tấn công thay đổi biến trạng thái trong RAM.
ADR-03: Zero-Knowledge Proof (ZKP) Strategy for Minor Privacy
Thông tin của thành viên trẻ vị thành niên được bảo vệ nghiêm ngặt theo nguyên lý ZKP. Các phân hệ tìm kiếm bên ngoài dòng họ hoặc ứng dụng bên thứ ba khi kiểm tra thông tin của trẻ em chỉ nhận được kết quả logic Đúng/Sai (Ví dụ: Đứa trẻ này có thuộc dòng họ hay không để cấp học bổng khuyến học) mà không được quyền tiếp cận dữ liệu thô.
ADR-04: Append-Only Immutable Ledger for Security Auditing
Toàn bộ nhật ký kiểm toán và vết an ninh hệ thống được cấu trúc theo mô hình Blockchain nội bộ gắn mã băm liên kết chuỗi. Quyết định này triệt tiêu hoàn toàn rủi ro một quản trị viên hệ thống quản lý cơ sở dữ liệu biến chất thực hiện hành vi sửa đổi dữ liệu bất hợp pháp rồi vào log xóa vết tương tác.
ADR-05: Technology-Agnostic Blueprint Isolation
Kiến trúc loại bỏ triệt để việc định danh cứng các giải pháp công nghệ cụ thể (như Telegram, Passkey cụ thể) ra khỏi tài liệu thiết kế. Mọi luồng xử lý tương tác được trừu tượng hóa bằng các khái niệm nghiệp vụ cao cấp như `Configured Emergency Channel` hay `High Assurance Identity Verification`, bảo toàn tuổi thọ vận hành qua nhiều kỷ nguyên số.
ADR-06: Governance Ledger Integration Blueprint
Mọi thay đổi trạng thái của thực thể `GovernanceProposal` bắt buộc phải đồng bộ phát sinh một mẩu tin `Governance Ledger Entry` sang miền Ledger để khóa cứng lịch sử phê duyệt của Hội đồng, phục vụ đối soát sử liệu.
ADR-07: Council Payload Compression Constraint
Cấm nạp trực tiếp toàn bộ payload JSON thô đồ sộ của Đề xuất biểu quyết lên thiết bị di động của Hội đồng. Lớp hiển thị bắt buộc sử dụng `CouncilVotingSummaryProjection` để khống chế kích thước phản hồi qua GraphQL Gateway luôn dưới 100 KB.

11. CROSS REFERENCES (THAM CHIẾU CHÉO)
Tham chiếu cơ chế mã hóa và thiết lập cổng bảo mật an toàn tại [VOL I - 03] Product Architecture Blueprint V2.1.
Tham chiếu sơ đồ cấu trúc nút phả hệ để tính toán hàm toán học LAAC và tích hợp Delegate Mapping tại [VOL I - 02] V2.1 và [VOL II - 04] Lineage & Member Domain Specification V2.1.
Tham chiếu luồng bóc tách đề xuất dịch thuật chữ cổ từ AI chuyển hóa thành luồng Multi-sig tại [VOL II - 08] AI & Elder Support Domain Specification V3.1.
Tham chiếu luồng đóng băng giao dịch chờ phê duyệt Multi-sig và đồng bộ Governance Ledger tại [VOL II - 06] Financial & Governance Ledger Domain Specification V2.1.
[KẾT THÚC TÀI LIỆU VOL II - 09 V4.1 - BASELINE APPROVED]