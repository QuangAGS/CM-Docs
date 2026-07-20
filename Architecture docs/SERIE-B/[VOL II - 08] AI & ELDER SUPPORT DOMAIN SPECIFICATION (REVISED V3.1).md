VOLUME II: BUSINESS DOMAINS
[VOL II - 08] AI & ELDER SUPPORT DOMAIN SPECIFICATION (REVISED V3.1)
Trạng thái: Baseline Approved | Phiên bản: V3.1 (Integrated Cross-cutting Doctrines)
Hệ thống: Web App Quản lý Dòng họ (Clan Management Platform)
Cấu trúc thực thi: Unified Domain Specification Contract (Domain-Driven Design Enforced)
1. PURPOSE (MỤC ĐÍCH)
Tài liệu này đặc tả chi tiết miền nghiệp vụ AI & Elder Support Domain (Miền Trợ Lý Thông Minh & Hỗ Trợ Lão Thành). Miền này nắm giữ hai sứ mệnh chiến lược dài hạn: Một là thiết lập hạ tầng trí tuệ nhân tạo chuyên trách bóc tách, dịch thuật di sản chữ cổ (Hán-Nôm) dựa trên nền tảng tri thức dòng tộc độc lập; Hai là cung cấp giải pháp dịch chuyển giao tiếp không chạm (Voice-First UX) nhằm tối ưu hóa và hiện thực hóa tuyệt đối Học thuyết Trải nghiệm khách thích ứng nhân văn (ACXD). Toàn bộ năng lực phân tích của AI trong miền này được định vị như một công cụ thực thi của ACXD, vận hành trên nguyên tắc tối cao: AI chỉ kiến nghị dưới dạng các đề xuất bất biến; quyền quyết định dữ liệu thuộc về con người.
2. PRIMARY DESIGN QUESTION (CÂU HỎI THIẾT KẾ CỐT LÕI)
"Làm thế nào để kiến trúc một hệ thống AI đa năng lực (Multi-capability) đóng gói mọi kết quả suy luận thành các Đề xuất bất biến (AI Proposal Pattern), hỗ trợ máy trạng thái lưu tạm tiến trình chịu lỗi cao cho người già (Elder-First UX), khống chế payload dưới 100 KB cho di động (Mobile-First) và cô lập hoàn toàn rào cản ảo giác mà không xâm lấn ranh giới sạch của các Business Ledgers?"
3. SCOPE & RESPONSIBILITIES (RANH GIỚI & BẢN ĐỒ NĂNG LỰC)
3.1 Khung phân rã Năng lực Miền (Domain Capability Structure)
Năng lực miền được quy hoạch chặt chẽ thành 4 cấu phần độc lập nhằm hiện thực hóa học thuyết ACXD:
Capability 1: Heritage Intelligence (Trí tuệ Di sản): Thực thi tiến trình OCR, phân đoạn đồ họa hình ảnh văn bia, câu đối, sách cổ và khớp dịch ngữ nghĩa Hán-Nôm dựa trên ngữ cảnh gia tộc.
Capability 2: Voice Interaction (Tương tác Thoại - ACXD Engine): Tiếp nhận luồng âm thanh streaming từ người cao tuổi, bóc tách phương ngữ, khẩu âm già tuổi để chuyển dịch sóng âm thành Ý định logic (Speech-to-Intent), chuyển giao sang Stateful Wizard API.
Capability 3: Accessibility (Hỗ trợ Tiếp cận): Giám sát phi chèn ép hành vi cơ học (phát hiện rung tay, timeout, thao tác lặp lại) để tự động điều chỉnh font chữ lớn, độ tương phản hiển thị theo User Preference gốc.
Capability 4: AI Orchestration (Điều phối Trí tuệ): Đóng gói toàn bộ đầu ra thành thực thể chung AIProposal, chạy qua bộ lọc Prompt Sanitizer phòng vệ mã độc văn bia và định tuyến kiểm duyệt theo ma trận độ tự tin.
3.2 Ngoài phạm vi (Out of Scope)
Không sở hữu, không phát sinh Command và cấm tuyệt đối hành vi trực tiếp ghi/sửa dữ liệu vào phả hệ gốc (trách nhiệm của [VOL II - 04] Lineage & Member Domain).
Không thực hiện luồng phát tán tin nhắn hay thông báo vật lý ra nền tảng viễn thông (trách nhiệm của [VOL II - 07] Communication Domain).
Không cung cấp các dịch vụ theo dõi chỉ số sinh tồn hoặc chẩn đoán y tế cho người già.
3.3 Bản đồ Trách nhiệm Miền (Domain Responsibilities)
Sở hữu thực thể (Owns)
Tham chiếu ngoài (References)
Phát sự kiện (Publishes)
Tiêu thụ sự kiện (Consumes)
 
AIProposal
HeritageDocument
TranslationTask
VoiceSession
AIProposalProjection
Member Core (VOL II-04)
UserPreference (VOL II-04)
DelegateMapping
ClanEvent (VOL II-05)
ClanKnowledgeBase
AIProposalCreated
AIProposalApproved
AIProposalRejected
VoiceSessionStarted
VoiceSessionEnded
TranslationCompleted
AccessibilityDetected
PromptAttackIsolated
MediaUploaded
MemberSpoke
InteractionFailed
DoctrineChanged
4. CANONICAL VOCABULARY & ENTITIES (TỪ ĐIỂN THUẬT NGỮ & THỰC THỂ CHUẨN TẮC)
AI Proposal (Đề xuất thông minh): Thực thể trung tâm chứa kết quả suy luận của AI, đóng vai trò như một wrapper nghiệp vụ bất biến chờ con cháu hoặc hội đồng phê duyệt để sinh Sổ cái.
Clan Knowledge Base (Cơ sở tri thức dòng tộc): Kho tri thức cục bộ biệt lập chứa gia huấn, tộc ước, danh sách tên húy, chữ lót, danh xưng vùng miền để LLM truy vấn ngữ cảnh, triệt tiêu ảo giác lịch sử.
Prompt Sanitizer (Bộ lọc làm sạch): Cơ chế phòng vệ kỹ thuật nhằm kiểm tra và vô hiệu hóa dữ liệu văn bản thô từ OCR di sản cổ trước khi nạp vào mô hình, chặn đứng các cuộc tấn công mã độc văn bia (Prompt Injection).
Confidence Score (Điểm số tin cậy): Chỉ số toán học ($0.0 \rightarrow 1.0$) thể hiện độ chính xác của kết quả suy luận do mô hình AI tự đánh giá để định tuyến phê duyệt.
5. RELATED DOCUMENTS (TÀI LIỆU LIÊN QUAN)
Consumer of (Tiêu thụ đầu vào): Triển khai học thuyết ACXD thượng tầng từ [VOL I - 02] V2.1, quy tắc Cursor Pagination và Payload di động từ [VOL I - 03] V2.1, tiêu thụ dữ liệu danh tính, Preferences và Mappings của người già từ [VOL II - 04] V2.1.
Referenced By (Được sử dụng bởi): Phát hành thực thể wrapper AIProposal để làm đầu vào chờ kiểm duyệt cho [VOL II - 04] Lineage & Member Domain và [VOL II - 06] Financial & Governance Ledger Domain.
6. DOMAIN COMMANDS, MODEL & WORKFLOWS (LỆNH MIỀN, MÔ HÌNH & TIẾN TRÌNH)
6.1 Cấu trúc Cụm Tổng hợp Kiểm duyệt (Aggregate Root Strategy)
Quy hoạch ranh giới miền dựa trên các thực thể lõi tối cao độc lập nhằm bảo toàn dữ liệu sạch:
[AIProposal (Aggregate Root)]  |  [HeritageDocument (Aggregate Root)]  |  [VoiceSession (Aggregate Root)]
6.2 Học thuyết Quản trị Độ tin cậy (Confidence Doctrine Matrix)
Hệ thống ép buộc định tuyến thực thể AIProposal dựa trên ma trận ranh giới toán học nghiêm ngặt:
Chỉ số độ tin cậy (Score)
Trạng thái định tuyến (Route Status)
Hành vi nghiệp vụ (Action Enforcement)
 
≥ 0.98
PENDING
Hiển thị dạng Kiến nghị một chạm (Auto-suggest) trên giao diện tối giản của Trưởng chi phái để bấm duyệt nhanh, không cần đi qua hội đồng tộc sự.
0.90 → 0.98
UNDER_REVIEW (Mức thường)
Bắt buộc đưa vào hàng đợi rà soát của Ban tộc sự nghiệp vụ chi phái để thực hiện đối soát thủ công bằng mắt.
0.70 → 0.90
UNDER_REVIEW (Mức cao)
Bắt buộc đính kèm cảnh báo nghi vấn lỗi hệ thống, chuyển tiếp luồng Multi-sig yêu cầu sự phê duyệt đồng thuận của Hội đồng Gia tộc tối cao.
< 0.70
REJECTED
Tự động hủy bỏ đề xuất đề xuất, phát sự kiện lỗi và ra lệnh cho hệ thống ghi nhận tái thực thi tác vụ OCR/Biên dịch lại từ đầu.

6.3 Máy Trạng thái Vòng đời Đề xuất (AI Proposal State Machine)
[INITIALIZED] &──(Sanitizer Pass & Score Check)──> [PENDING] / [UNDER_REVIEW]
                                                │
                                        ┌───────┴───────┐
                               (Con người duyệt) (Con người từ chối)
                                        │ │
                                        ▼ ▼
                                   [APPROVED] [REJECTED]
Ràng buộc luồng kết thúc: Khi chuyển sang trạng thái APPROVED hoặc REJECTED bởi hành vi con người, hệ thống lập tức khóa vĩnh viễn thực thể và đồng thời phát tín hiệu ép buộc sinh một bản ghi lịch sử vào Governance Ledger để làm bằng chứng kiểm toán sử liệu.
6.4 Hạ tầng Nén Tải trọng Di động (Mobile-First API Layout)
AIProposalSummaryProjection: Để kiểm soát nghiêm ngặt ranh giới payload < 100 KB, danh sách các đề xuất AI nạp lên thiết bị di động của Ban tộc sự bắt buộc phải đi qua bộ lọc Projection tinh gọn. Triệt tiêu toàn bộ payload JSON nghiệp vụ phức tạp, chỉ kết xuất các trường cốt lõi: [proposal_id, type, confidence_score, status, short_description] kết hợp phân trang Cursor.
7. DOMAIN INVARIANTS (CÁC RÀNG BUỘC TOÀN VẸN BẤT BIẾN)
INV-01 (Quy tắc Không Quyền lực - AI Governance Principal): Mô hình trí tuệ nhân tạo tuyệt đối cấm mọi hành vi tự động thực thi Command vật lý, sửa đổi sơ đồ cây phả hệ chính sử, xóa dữ liệu vĩnh viễn, phê duyệt giao dịch tài chính hay thay đổi ma trận cấu hình Doctrine của hệ thống. Mọi đầu ra bắt buộc phải tồn tại dưới dạng wrapper trung gian AIProposal chờ con cháu phê duyệt.
INV-02 (Tính bất biến của Đề xuất): Thực thể AIProposal một khi đã khởi tạo và gán chỉ số confidence_score thành công thì nghiêm cấm tuyệt đối mọi hành vi can thiệp sửa đổi trường thuộc tính payload hoặc chỉnh sửa nâng hạ điểm số tin cậy thô bằng tay.
INV-03 (Bảo mật sinh trắc học giọng nói): Hệ thống ghi nhận âm thanh thoại chỉ được trích xuất ra Intent logic. Tuyệt đối cấm lưu kho tệp âm thanh giọng nói thô (Raw Audio) lên bất kỳ phân hệ hạ tầng đám mây nào nhằm bảo vệ an toàn tuyệt đối dữ liệu sinh trắc học của gia tộc.
8. FAILURE POLICIES (CHÍNH SÁCH XỬ LÝ LỖI ẢO GIÁC & HẠ TẦNG)
Nghi vấn Ảo giác (LLM Hallucination Suspected): Khi mô hình LLM sinh văn bản có dấu hiệu mâu thuẫn dữ liệu hoặc không khớp từ khóa trong Clan Knowledge Base, hệ thống tự động hạ chỉ số confidence_score xuống mức $< 0.70$ để kích hoạt chính sách REJECTED, cấm hệ thống đoán mò thông tin lịch sử dòng họ.
Prompt Injection Tấn công chữ cổ: Bộ lọc Prompt Sanitizer quét văn bản OCR đầu vào, nếu phát hiện chuỗi ký tự chứa mã lệnh độc hại hoặc câu lệnh ghi đè cấu trúc hệ thống (như "Ignore previous instructions"), hệ thống lập tức cô lập bản ghi, chặn đứng tiến trình nạp vào LLM, phát sự kiện PromptAttackIsolated và gửi cảnh báo an ninh cấp cao đến SecOps.
Mạng kết nối LLM Cloud ngoại tuyến: Hệ thống tự động chuyển đổi luồng xử lý giọng nói sang lớp mô hình nén trọng số nhẹ thực thi hoàn toàn ngoại tuyến (Offline Edge-AI Module) tại thiết bị đầu cuối nội bộ nhà thờ tổ để duy trì tính liên tục cho các cụ già bách niên.
9. ARCHITECTURE DECISIONS (QUYẾT ĐỊNH KIẾN TRÚC MIỀN - ADR)
Mã Quyết định
Nội dung giải pháp & Ràng buộc kiến trúc (ADR Core)
 
ADR-01: AI as an Implementation of ACXD Strategy
Miền này xác lập nguyên tắc kiến trúc đặt Giao diện Giọng nói và AI làm công cụ thực thi tối cao của học thuyết ACXD. AI có trách nhiệm bóc tách khẩu lệnh thoại từ người già để tự động dựng cấu trúc phiên làm việc lưu tạm (Stateful Wizard API), tự động điền thông tin người gánh vác việc họ dựa trên bản đồ ủy quyền trực hệ (Delegate Mapping), triệt tiêu sự lệ thuộc vào nút chạm màn hình.
ADR-02: Mandatory AI Proposal Pattern Integration
Mọi kết quả sinh ra từ trí tuệ nhân tạo bắt buộc phải được biểu diễn dưới dạng wrapper thực thể `AIProposal` bất biến. AI nghiêm cấm phát sinh mã lệnh Command hoặc thực thi Mutation trực tiếp lên nhân hệ thống của các Business Domains khác, bảo toàn ranh giới sạch cho dữ liệu chính sử.
ADR-03: Confidence-Based Routing Governance
Hệ thống thiết lập chỉ số tin cậy bắt buộc bám sát ma trận kiểm duyệt. Chỉ số này chỉ đóng vai trò tối ưu hóa luồng công việc và hỗ trợ con người ra quyết định, không bao giờ được phép thay thế quyền quyết định tối cao của Hội đồng Gia tộc.
ADR-04: Knowledge Isolation via Local Clan Corpus
Mọi mô hình ngôn ngữ lớn (LLM) sử dụng trong hệ thống chỉ được quyền truy cập và suy luận dựa trên vùng biên tri thức đã được phê duyệt thuộc về `ClanKnowledgeBase`. Hệ thống cấm sử dụng dữ liệu trần nằm ngoài ranh giới ngữ cảnh gia tộc để tránh lỗi sai sót kính ngữ văn hóa.
ADR-05: Deep Prompt Isolation for OCR Text Ingestion
Tiến trình bóc tách văn bản thô từ di sản cổ bắt buộc phải đi qua một lớp làm sạch độc lập (`Prompt Sanitizer`) trước khi chuyển tiếp ngữ cảnh sang LLM Core. Việc này ngăn chặn tuyệt đối các kịch bản tấn công leo thang đặc quyền phần mềm ẩn nấp bên trong các bản dịch sách cổ hoặc văn bia ngoài đời thực.
ADR-06: Mandatory Ledger Logging for Human Approvals
Mọi hành vi phê duyệt hoặc từ chối thực thể `AIProposal` của con người bắt buộc phải phát tín hiệu đồng bộ về phân hệ `Governance Ledger` để lập biên bản ghi sổ vĩnh viễn, băm liên chuỗi chống tẩy xóa.
ADR-07: Hard Payload Restriction via Proposal Projection
Cấm nạp trực tiếp toàn bộ payload JSON thô đồ sộ của Đề xuất AI lên các thiết bị di động. Lớp hiển thị bắt buộc sử dụng `AIProposalSummaryProjection` để khống chế kích thước phản hồi qua GraphQL Gateway luôn dưới 100 KB.

10. CROSS REFERENCES (THAM CHIẾU CHÉO)
Đối chiếu chỉ số năng lực tiếp cận giọng nói của người già (KPI 2) tại [VOL I - 01] Product Vision Blueprint V3.1.
Tham chiếu học thuyết Trải nghiệm khách thích ứng (ACXD) và Sổ cái Nghiệp vụ tại [VOL I - 02] Business Doctrine Blueprint V2.1.
Tham chiếu mô hình phân tầng hệ thống và ADR-04 về giới hạn payload di động tại [VOL I - 03] Product Architecture Blueprint V2.1.
Tham chiếu ranh giới tiếp nhận Đề xuất sửa đổi cây phả hệ, UserPreference và cấu hình Delegate Mapping tại [VOL II - 04] Lineage & Member Domain Specification V2.1.
Tham chiếu luồng bóc tách lệnh thoại hỗ trợ ban tế lễ phân bổ đầu việc hậu cần tại [VOL II - 05] Event & Ritual Domain Specification V2.1.
Tham chiếu ranh giới kiểm soát luồng phê duyệt duyệt chi tài chính lớn vượt hạn mức định tuyến qua Multi-sig tại [VOL II - 06] Financial & Governance Ledger Domain Specification V2.1.
[KẾT THÚC TÀI LIỆU VOL II - 08 V3.1 - BASELINE APPROVED]