VOLUME II: BUSINESS DOMAINS
[VOL II - 06] FINANCIAL & GOVERNANCE LEDGER DOMAIN SPECIFICATION (REVISED V2.1)
Trạng thái: Baseline Approved | Phiên bản: V2.1 (Integrated Cross-cutting Doctrines)
Hệ thống: Web App Quản lý Dòng họ (Clan Management Platform)
Cấu trúc thực thi: Unified Domain Specification Contract (Domain-Driven Design Enforced)
1. PURPOSE (MỤC ĐÍCH)
Tài liệu này đặc tả chi tiết miền nghiệp vụ Financial & Governance Ledger Domain (Miền Hệ Thống Sổ Cái Tổng Hợp). Miền này chịu trách nhiệm độc quyền hạch toán, lưu vết và bảo toàn tính toàn vẹn tuyệt đối cho mọi hành vi biến động tài chính, luật tục, nghi lễ và an ninh tộc hệ. Không chỉ dừng lại ở kế toán tiền tệ, miền này hiện thực hóa tối cao Học thuyết Sổ cái nghiệp vụ (Business Ledger Doctrine), chuyển hóa toàn bộ các hoạt động có ý nghĩa sử liệu của dòng họ thành các mẩu tin sổ cái bất biến, phục vụ lưu trữ trường tồn vĩnh cửu.
2. PRIMARY DESIGN QUESTION (CÂU HỎI THIẾT KẾ CỐT LÕI)
"Làm thế nào để kiến trúc một hạ tầng đa sổ cái chỉ ghi tiếp (Multi-Ledger Architecture), ép buộc ràng buộc kế toán kép nghiêm ngặt đối với tài chính, mã hóa liên chuỗi mật mã học đối với sử liệu tộc vụ, đồng thời cung cấp các mô hình truy xuất tinh gọn dưới 100 KB cho di động và quy trình phê duyệt an toàn, chịu lỗi cao cho người cao tuổi (ACXD)?"
3. SCOPE & RESPONSIBILITIES (RANH GIỚI & TRÁCH NHIỆM MIỀN)
3.1 Trong phạm vi (Scope)
Multi-Ledger Core Topology: Thiết lập và vận hành 4 phân hệ sổ cái logic độc lập:1. Financial Ledger: Kế toán kép kinh điển (Debit/Credit) quản lý các quỹ dòng họ.2. Governance Ledger: Ghi nhận lịch sử thay đổi luật tộc ước, kết nạp, trục xuất thành viên.3. Ritual Ledger: Lưu vết lịch sử tổ chức giỗ chạp, nghi lễ qua các đời.4. Audit Ledger: Nhật ký kiểm toán an ninh hệ thống và truy vết thao tác.
Immutable Transaction Processing: Ghi nhận các bút toán chỉ ghi tiếp (Append-only), cấm tuyệt đối lệnh UPDATE/DELETE vật lý trên mọi dòng lịch sử.
Asynchronous Bank Reconciliation: Tiếp nhận, phân tích OCR chứng từ hình ảnh và đối soát bất đồng bộ với dòng tiền khai báo.
Adaptive Financial Workflows: Cấu trúc các phiên làm việc lưu tạm (Wizard) cho việc thu quỹ và thiết lập luồng xác thực đa lớp (Guardian Approval) cho tài khoản người cao tuổi.
3.2 Ngoài phạm vi (Out of Scope)
Không trực tiếp tích hợp cổng thanh toán trực tuyến hoặc API ví điện tử đại chúng (quy trình dừng ở đối soát bằng chứng chuyển khoản).
Không sở hữu logic tính toán lịch Âm - Dương hoặc lên lịch giỗ chạp (trách nhiệm của [VOL II - 05] Event & Ritual Domain).
3.3 Bản đồ Trách nhiệm Miền (Domain Responsibilities)
Sở hữu thực thể (Owns)
Tham chiếu ngoài (References)
Phát sự kiện (Publishes)
Tiêu thụ sự kiện (Consumes)
 
ClanLedger Core
FinancialJournal
GovernanceEntry
RitualHistoryRecord
TransactionEvidence
LedgerProjection
Member ID (VOL II-04)
Branch ID (VOL II-04)
ClanEvent ID (VOL II-05)
Doctrine Rules
TransactionLogged
TransactionVerified
TransactionRejected
GovernanceLedgerCommitted
RitualLedgerCommitted
BalanceUpdated
CorrectionEntryPosted
DisbursementApprovalRequested
MemberCreated
MemberDeceased
BranchCreated
EventScheduled
EventConcluded
EventCancelled
ConsensusAchieved
4. CANONICAL VOCABULARY & ENTITIES (TỪ ĐIỂN THUẬT NGỮ & THỰC THỂ CHUẨN TẮC)
4.1 Từ điển Thuật ngữ (Vocabulary)
Financial Ledger: Sổ cái kế toán quản lý biến động số dư các quỹ (Khuyến học, xây dựng) dựa trên nguyên lý Tổng DEBIT = Tổng CREDIT.
Governance Ledger: Sổ cái quản trị ghi nhận các quyết định mang tính "Hiến pháp dòng họ", khóa cứng các phiên bản thay đổi tộc ước.
Append-only Entry: Bản ghi cơ sở dữ liệu logic có đặc tính chỉ cho phép chèn mới, ngăn chặn hoàn toàn mọi tác động thay đổi dữ liệu cũ.
Guardian Approval (Duyệt giám hộ): Cơ chế an ninh thích ứng yêu cầu tài khoản người giám hộ ký số xác nhận khi tài khoản người cao tuổi thực hiện các giao dịch đóng góp tài chính lớn hoặc chuyển giao quyền lực phả hệ.
4.2 Mô hình Thực thể Chuẩn tắc (Canonical Entities)
ClanFund: [fund_id (UUIDv7), name (String), owner_branch_id (UUIDv7), total_debit (Decimal), total_credit (Decimal), status (Enum)]
LedgerTransaction: [transaction_id (UUIDv7), fund_id (UUIDv7), ledger_type (Enum: FINANCIAL/GOVERNANCE/RITUAL/AUDIT), money_amount (MoneyValueObject), correlation_id (UUIDv7), transaction_hash (String), occurred_at (Timestamp), recorded_at (Timestamp)]
5. RELATED DOCUMENTS (TÀI LIỆU LIÊN QUAN)
Consumer of (Tiêu thụ đầu vào): Kế thừa triết lý Sổ cái nghiệp vụ bất biến từ [VOL I - 02] V2.1, quy tắc Payload < 100 KB và CQRS phân tách từ [VOL I - 03] V2.1, tiêu thụ dữ liệu danh tính thành viên từ [VOL II - 04] V2.1, và lắng nghe tín hiệu kết thúc nghi lễ event_concluded từ [VOL II - 05] V2.1 để lập sổ cái quyết toán tế tự.
Referenced By (Được sử dụng bởi): Cung cấp dữ liệu Bảng vàng vinh danh (Aura Value Object) cho [VOL II - 07] Communication Domain Specification, cung cấp vết kiểm toán cho [VOL II - 09] Security & Trust Domain.
6. DOMAIN COMMANDS, MODEL & WORKFLOWS (LỆNH MIỀN, MÔ HÌNH & TIẾN TRÌNH)
6.1 Cấu trúc Cụm Tổng hợp Bất biến (Aggregate Root Strategy)
                              [ClanLedger (Aggregate Root)]                                            │        ┌───────────────────┬───────────────┴───────────────┬───────────────────┐        ▼                   ▼                               ▼                   ▼[Financial Ledger]  [Governance Ledger]              [Ritual Ledger]     [Audit Ledger]   (Quỹ & Bút toán)    (Tộc ước & Thành viên)          (Lịch sử tế tự)     (Nhật ký an ninh)
6.2 Máy Trạng thái Vòng đời Giao dịch Tài chính (Transaction Lifecycle Machine)
[SUBMITTED] → [UNVERIFIED] &──(Đối soát khớp hoặc OCR thành công)──> [VERIFIED]
                                   │
                                   └──(Sai lệch minh chứng chứng từ)──> [REJECTED]
6.3 Mô hình Hiển thị Hội tụ Thích ứng (ACXD Projections)
FundBalanceView (Mobile-First): Bản sao hiển thị số dư khả dụng tối giản dành riêng cho di động. Giới hạn cứng dung lượng phản hồi < 100 KB bằng cách nén cấu trúc mảng, chỉ trả về số dư ròng đã được tổng hợp (Sum Aggregation) từ chuỗi sự kiện VERIFIED.
PersonalContributionView: Nhật ký hiển thị chuỗi tăng tiến các giao dịch phân trang bằng Cursor, phục vụ con cháu tra cứu lịch sử phụng hiến cá nhân cực tốc.
Elder-First Simplified Report: Góc nhìn báo cáo thu chi triệt tiêu đồ thị phức tạp, biểu diễn dữ liệu dưới dạng các con số lớn trực quan, hỗ trợ đọc thành tiếng thông qua hệ thống trợ lý thoại ([VOL II - 08]).
6.4 Luồng Xử lý Phê duyệt Hạn mức và Kiểm toán Liên chuỗi
Khi Thủ quỹ thực hiện một Command chi ngân sách lớn hoặc điều chỉnh hiến pháp tộc ước:
Disbursement Command → Hạn mức Thẩm định (Doctrine Limit) → Kích hoạt Luồng Đa chữ ký (Multi-sig Pending) → ConsensusAchieved → Write DB + Outbox Table → Hash Chain Calculation (SHA256)
Hash Chain Calculation: Mỗi mẩu tin sổ cái nghiệp vụ khi được commit thành công bắt buộc phải tính toán trường transaction_hash bằng cách băm chuỗi nội dung bản ghi hiện tại kết hợp cùng mã băm của bản ghi liền trước, thiết lập cấu trúc dữ liệu Append-only bất biến tuyệt đối cấp DB.
7. DOMAIN INVARIANTS (CÁC RÀNG BUỘC TOÀN VẸN BẤT BIẾN)
INV-01 (Bảo toàn số âm): Số dư khả dụng tính toán của một quỹ bất kỳ không được phép nhỏ hơn 0 sau khi thực hiện bút toán chi (Balance >= 0), loại bỏ hoàn toàn rủi ro vỡ quỹ dòng họ.
INV-02 (Tính bất biến tuyệt đối): Giao dịch một khi đã ở trạng thái VERIFIED hoặc REJECTED nghiêm cấm tuyệt đối mọi hành vi can thiệp chỉnh sửa thô số tiền, mã quỹ hoặc danh tính chủ thể.
INV-03 (Ràng buộc toán học kế toán kép): Đối với phân hệ Financial Ledger, mọi bút toán phát sinh bắt buộc phải đảm bảo tính cân đối kế toán tuyệt đối: Σ DEBIT = Σ CREDIT.
INV-04 (Ràng buộc Payload tài chính - ACXD): Mọi Query kết xuất lịch sử thu chi lên thiết bị di động bắt buộc phải đi qua bộ lọc Projection tinh tinh giản, chặn đứng payload vượt ngưỡng 100 KB để chống DoS client.
INV-05 (Xác thực ủy quyền giám hộ): Mọi hành vi chi vượt hạn mức hoặc đóng góp thay từ tài khoản Trưởng lão thông qua Delegate Mapping bắt buộc phải có sự phê duyệt đồng thuận (Guardian Approval) từ tài khoản người giám hộ số được liên kết huyết thống.
8. DOMAIN EVENTS (DANH SÁCH SỰ KIỆN MIỀN)
Các sự kiện nghiệp vụ phát ra dưới cấu trúc chuẩn snake_case và định dạng CloudEvents v1.0:
fund_created: Một quỹ tộc sự mới được khởi tạo thành công dưới một Chi hoặc Tộc hệ tổng.
transaction_logged: Thủ quỹ đệ trình một giao dịch thu/chi lên hệ thống kèm chứng từ.
transaction_verified: Giao dịch tài chính được đối soát khớp, kích hoạt cập nhật số dư Read Model.
transaction_rejected: Giao dịch bị từ chối ghi nhận do sai lệch minh chứng hình ảnh.
correction_entry_posted: Bút toán đảo toán/điều chỉnh được thiết lập để cân bằng sai sót nhập liệu.
governance_ledger_committed: Một mẩu tin sổ cái quản trị (Tộc ước/Thành viên) được khóa xích băm thành công.
ritual_ledger_committed: Lịch sử tổ chức nghi lễ giỗ chạp được ghi nhận vĩnh viễn vào sử liệu dòng họ.
9. ARCHITECTURE DECISIONS (QUYẾT ĐỊNH KIẾN TRÚC MIỀN - ADR)
Mã Quyết định
Nội dung giải pháp & Ràng buộc kiến trúc (ADR Core)
 
ADR-01: Quad-Ledger Decoupled Topology
Hệ thống từ bỏ thiết kế lưu nhật ký chung chung. Ép buộc chia tách logic thành 4 phân hệ Sổ cái chuyên trách (Financial, Governance, Ritual, Audit). Mọi hành vi thay đổi dữ liệu sử liệu ở các tập Volume khác bắt buộc phải được ánh xạ và đóng gói thành bản ghi ghi chép tại đây.
ADR-02: Strict Append-Only via Adjusting Entries
Nghiêm cấm tuyệt đối lệnh SQL UPDATE/DELETE thô đối với lịch sử giao dịch. Sai sót của thủ quỹ chỉ được phép xử lý bằng cách phát hành bút toán đảo toán hoặc bút toán điều chỉnh (`Correction Entry`), bảo toàn vết tích kiểm toán vĩnh viễn của dòng họ.
ADR-03: Volatile In-Memory Balance Projections
Giá trị số dư hiển thị của các quỹ không được lưu trực tiếp vào một trường tĩnh của database nhằm tránh race condition. Số dư được cache trên lớp bộ nhớ trong và có thể bị xóa sạch, tự động tính toán lại cực tốc bằng cách Replay chuỗi lịch sử sự kiện giao dịch từ điểm khởi đầu bất cứ lúc nào.
ADR-04: Money Value Object Enforcement
Mọi thuộc tính liên quan đến giá trị tiền tệ bắt buộc sử dụng kiểu dữ liệu `Decimal` có độ chính xác cao hoặc đóng gói hoàn chỉnh trong một Value Object mang cấu trúc `Money` gồm `amount` (Decimal) và `currency` (String), triệt tiêu hoàn toàn lỗi làm tròn nhị phân của CPU.
ADR-05: Cryptographic Chain-Hashing for Sử liệu Trường tồn
Mỗi bản ghi thuộc nhóm Sổ cái sử liệu phải chứa trường `transaction_hash` tính toán từ mã băm của chính nó và bản ghi trước đó. Cơ chế này đảm bảo phát hiện ngay lập tức bất kỳ hành vi thao túng dữ liệu thô nào từ tầng cơ sở dữ liệu vật lý vật lý.
ADR-06: Guardian Approval for Vulnerable Accounts
Để thực thi triết lý chống thao tác sai của học thuyết ACXD, miền tích hợp chặt chẽ với phân hệ An ninh nhằm áp đặt luồng xác thực Giám hộ. Các giao dịch tài chính phát sinh từ tài khoản người cao tuổi vượt ngưỡng quy định sẽ bị đóng băng cho đến khi tài khoản người thân (Guardian) ký duyệt qua ứng dụng di động.

10. CROSS REFERENCES (THAM CHIẾU CHÉO)
Đối chiếu tiêu chí minh bạch tài chính tối cao tại [VOL I - 01] Product Vision Blueprint V3.1.
Tham chiếu định nghĩa Business Ledger Doctrine và ranh giới tự trị quỹ tài chính chi phái tại [VOL I - 02] Business Doctrine Blueprint V2.1.
Tham chiếu nguyên lý Read Models are Disposable và ADR-04 về giới hạn payload di động tại [VOL I - 03] Product Architecture Blueprint V2.1.
Tham chiếu liên kết thực thể thành viên gánh vác đóng góp tài chính tại [VOL II - 04] Lineage & Member Domain Specification V2.1.
Tham chiếu PostgreSQL Cluster cấu hình phân mảnh Partition theo thời gian/Tenant để lưu trữ bảng `business_ledger` vật lý tại [VOL III - 11] Enterprise Data & Persistence Architecture.
[KẾT THÚC TÀI LIỆU VOL II - 06 V2.1 - BASELINE APPROVED]