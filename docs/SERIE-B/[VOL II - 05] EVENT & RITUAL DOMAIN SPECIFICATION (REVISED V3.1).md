VOLUME II: BUSINESS DOMAINS
[VOL II - 05] EVENT & RITUAL DOMAIN SPECIFICATION (REVISED V3.1)
Trạng thái: Baseline Approved | Phiên bản: V3.1 (Integrated Cross-cutting Doctrines)
Hệ thống: Web App Quản lý Dòng họ (Clan Management Platform)
Cấu trúc thực thi: Unified Domain Specification Contract (Domain-Driven Design Enforced)
1. PURPOSE (MỤC ĐÍCH)
Tài liệu này đặc tả chi tiết miền nghiệp vụ Event & Ritual Domain (Miền Sự Kiện & Nghi Lễ). Miền này chịu trách nhiệm quản lý vòng đời các sự kiện định kỳ và nghi lễ của dòng họ dựa trên lịch Âm–Dương và các quy tắc nghiệp vụ tộc sự. Chức năng cốt lõi là tự động hóa tính toán ngày kỷ niệm, ngày kỵ nhật, điều phối các kịch bản chuẩn bị công tác hậu cần, lập kế hoạch nhắc nhở đại sự nhằm bảo toàn dòng chảy văn hóa truyền thống xuyên suốt các thế hệ gia tộc, đồng thời hiện thực hóa triết lý Sổ cái sử liệu bất biến, Quản trị truyền thông toàn vẹn và Trải nghiệm thích ứng nhân văn (ACXD).
2. PRIMARY DESIGN QUESTION (CÂU HỎI THIẾT KẾ CỐT LÕI)
"Làm thế nào để kiến trúc một bộ máy tính toán lịch (Calendar Engine) mang tính đơn trị định trước (Deterministic), thiết lập ma trận nhiệm vụ hậu cần chịu lỗi cao cho người già (Elder-First UX), và hoạch định các lịch trình nhắc nhở tối giản payload cho di động (Mobile-First) mà vẫn tuân thủ tuyệt đối quy trình quản lý vòng đời truyền thông và ghi sổ cái vĩnh viễn?"
3. SCOPE & RESPONSIBILITIES (RANH GIỚI & TRÁCH NHIỆM MIỀN)
3.1 Trong phạm vi (Scope)
Clan Calendar Engine: Tính toán, chuyển đổi chu kỳ mốc ngày Âm lịch sang Dương lịch thực tế thông qua cơ chế cập nhật tăng trưởng (Incremental Refresh).
Ritual Lifecycle Management: Khởi tạo, theo dõi và quản lý các trạng thái thực thi của ma trận đầu việc hậu cần phục vụ tế tự, giỗ chạp, hội làng.
Reminder Planning Logic: Lập kế hoạch thời gian nhắc nhở tự động (Reminder Plan) dựa trên vai vế và phân cấp Chi phái của thành viên lấy từ mô hình định danh phả hệ.
Adaptive Integration Support: Cung cấp các giao diện tinh giản (Projections) và lưu vết phiên làm việc tạm thời cho hoạt động phân bổ đầu việc của Trưởng lão tộc sự.
3.2 Ngoài phạm vi (Out of Scope)
Không sở hữu hay cho phép sửa đổi trực tiếp dữ liệu hồ sơ sinh học, trạng thái sinh/tử của thành viên (trách nhiệm thuộc về [VOL II - 04] Lineage & Member Domain).
Không thực hiện luồng bắn tin nhắn vật lý đa nền tảng như SMS, Push Notification, OTT (trách nhiệm của phân hệ Communication Domain).
Không quản lý việc thu chi, hạch toán biên lai tài chính (trách nhiệm của [VOL II - 06] Ledger Domain).
3.3 Bản đồ Trách nhiệm Miền (Domain Responsibilities)
Sở hữu thực thể (Owns)
Tham chiếu ngoài (References)
Phát sự kiện (Publishes)
Tiêu thụ sự kiện (Consumes)
 
ClanCalendar
ClanEvent
RitualTask
ReminderSchedule
EventProjection
Member Core (VOL II-04)
Branch Hierarchy
Doctrine Matrix
EventScheduled
EventRescheduled
EventCancelled
TaskAssigned
TaskStarted
TaskCompleted
TaskReopened
ReminderPlanned
MemberCreated
MemberUpdated
MemberDeceased
BranchChanged
DoctrineChanged
ConsensusAchieved
4. CANONICAL VOCABULARY (TỪ ĐIỂN THUẬT NGỮ CHUẨN TẮC)
Anniversary (Ngày kỷ niệm/Kỵ nhật): Điểm mốc thời gian lặp lại hàng năm tính theo chu kỳ Âm lịch (Ví dụ: Ngày giỗ cụ tổ, ngày giỗ thành viên).
Clan Event (Sự kiện dòng họ): Một thực thể công việc được lên lịch biểu cụ thể của gia tộc vào một thời điểm xác định.
Ritual Task (Đầu việc nghi lễ): Công việc hậu cần chi tiết cần hoàn thành nhằm phục vụ Clan Event (Ví dụ: Soạn văn tế, sắm lễ vật, dọn dẹp nhà thờ tổ).
Assignee (Người gánh vác): Thành viên được chỉ định chịu trách nhiệm thực thi Ritual Task.
Reminder Plan (Kế hoạch nhắc nhở): Tập hợp lịch trình thời gian định sẵn phục vụ cho việc thông báo đại sự tộc sự, cấu thành từ dữ liệu thô của bộ máy tính lịch.
Event Summary Projection (Góc nhìn sự kiện tinh giản): Cấu trúc dữ liệu thu gọn của sự kiện phục vụ hiển thị siêu tốc trên ứng dụng di động.
5. RELATED DOCUMENTS (TÀI LIỆU LIÊN QUAN)
Consumer of (Tiêu thụ đầu vào): Kế thừa trục kiến trúc hướng sự kiện phi trạng thái, mô hình Outbox từ [VOL I - 03] Product Architecture Blueprint V2.1 và tiêu thụ ID, trạng thái của hai thực thể cốt lõi Member, Branch phát ra từ [VOL II - 04] Lineage & Member Domain Specification V2.1.
Referenced By (Được sử dụng bởi): Cung cấp các ID sự kiện phục vụ liên kết lập chứng từ ngân sách dòng họ tại [VOL II - 06] Ledger Domain Specification, và định hướng cho hệ trợ lý thông minh bóc tách lệnh thoại tại [VOL II - 08] AI & Elder Support Domain.
6. DOMAIN MODEL & WORKFLOWS (MÔ HÌNH MIỀN & TIẾN TRÌNH)
6.1 Cấu trúc Cụm Tổng hợp (Aggregate Root Strategy)
                        [ClanCalendar (Aggregate Root)]                                      │                    ┌─────────────────┴─────────────────┐                    ▼                                   ▼              [ClanEvent]                       [ReminderSchedule]                    │                                   │                    ▼                                   ▼              [RitualTask]                       [ReminderPlan Output]                    │                    ▼          [Assignees Reference]
Mọi thao tác quản lý trạng thái hoặc cập nhật tiến độ công tác chuẩn bị nghi lễ bắt buộc phải đi qua ngữ cảnh của Aggregate Root ClanCalendar để thực thi đồng bộ luồng kiểm tra học thuyết dòng họ.
6.2 Quy tắc Bản số Nghiệp vụ (Cardinality Rules)
Một ClanCalendar quản lý: 0..N ClanEvents.
Một ClanEvent sở hữu: 0..N RitualTasks phục vụ công tác chuẩn bị hậu cần.
Một RitualTask được gánh vác bởi: 1..N Assignees (Tham chiếu qua Member ID của miền Phả hệ).
6.3 Máy Trạng thái Vòng đời Sự kiện Nghi lễ (Event Lifecycle Machine)
Mọi sự kiện dòng họ vận hành qua chuỗi trạng thái logic nghiêm ngặt, tích hợp cơ chế đóng băng sử liệu:
[SCHEDULED] ──(Đến kỳ chuẩn bị hậu cần)──> [IN_PROGRESS] ──(Tất cả Ritual Tasks hoàn thành)──> [CONCLUDED] (Khóa vĩnh viễn)
       │
       └──(Hội đồng / Trưởng tộc duyệt hủy)──> [CANCELLED] (Hủy bỏ sự kiện)
6.4 Luồng Xử lý Lịch và ACXD Read Models
Incremental Refresh (Tối ưu hóa máy tính lịch): Để bảo vệ hiệu năng hạ tầng, Calendar Engine thực hiện quét tăng trưởng để tự động sinh ma trận ngày Dương lịch tương ứng cho block 24 tháng kế tiếp ngay khi hệ thống bước sang mốc thời gian mới, loại bỏ hoàn toàn cơ chế tính toán On-the-fly khi người dùng nhấn xem lịch.
EventSummaryProjection (Mobile-First): Bản sao hiển thị siêu tinh giản của sự kiện dành riêng cho Mobile Client. Giới hạn cứng phản hồi qua GraphQL Gateway tối đa 5 trường dữ liệu: [id, title, lunar_date, solar_date, status]. Đảm bảo dung lượng Payload nén luôn dưới ngưỡng 100 KB, ngăn chặn thắt nút cổ chai băng thông di động.
Simplified Ritual Checklist (Elder-First UX): Góc nhìn danh sách đầu việc hậu cần được tối ưu hóa trợ năng cao độ: ẩn toàn bộ mô tả chi tiết phức tạp, hiển thị dưới dạng thẻ chạm lớn, hỗ trợ đánh dấu hoàn thành chỉ bằng một chạm hoặc thông qua lệnh thoại (Voice Confirmation).
6.5 Chuỗi Tiến trình Ép buộc Sổ cái và Truyền thông (Ledger & Communication Pipeline)
Khi một sự kiện chuyển sang trạng thái CONCLUDED hoặc CANCELLED, hoặc khi kế hoạch nhắc nhở được đóng gói:
State Change Command → Domain Execution → Write DB + Outbox → Force Generate Business Ledger Record → Publish reminder_planned (To Communication Domain)
Force Generate Business Ledger Record: Tầng ứng dụng tự động đóng gói payload thô của sự kiện thành mẩu tin sổ cái bất biến (event_ledger), băm liên chuỗi mật mã học để ngăn chặn tuyệt đối các lệnh UPDATE/DELETE từ quản trị viên hệ thống.
Publish reminder_planned: Bản kế hoạch nhắc nhở được đóng gói và bắn đi dưới dạng sự kiện CloudEvent. Phân hệ Communication Domain ở ngoài biên chịu trách nhiệm tiếp nhận bản thiết kế này, tự động quản lý vòng đời tin nhắn phát ra từ trạng thái Draft đến Delivered và lưu vết kiểm toán vào communication_ledger.
7. DOMAIN INVARIANTS (CÁC RÀNG BUỘC TOÀN VẸN BẤT BIẾN)
INV-01 (Tính nhất quán ngày kỵ): Ngày giỗ của một thành viên đã mất bắt buộc phải lấy chính xác mốc ngày/tháng Âm lịch được ghi nhận tại hồ sơ sinh học gốc bên miền Phả hệ, cấm tuyệt đối hành vi chỉnh sửa tự phát cấu trúc ngày tại miền Sự kiện.
INV-02 (Ranh giới phát thông tin): Sự kiện mang phạm vi nội bộ Chi tộc tuyệt đối không được lập kế hoạch nhắc nhở sang các thành viên thuộc Chi tộc khác (Tuân thủ quyền tự trị chi phái).
INV-03 (Chính danh người gánh vác): Thực thể Assignee nhận nhiệm vụ trong một công tác nghi lễ bắt buộc phải là một Member đang ở trạng thái hoạt động sinh học bình thường (ACTIVE) bên miền Phả hệ.
INV-04 (Bất biến sử liệu): Toàn bộ các sự kiện lịch sử dòng họ đã chuyển sang trạng thái CONCLUDED được khóa cứng vĩnh viễn, không cho phép bất kỳ hành vi sửa đổi dữ liệu quá khứ nào.
INV-05 (Ràng buộc Payload sự kiện - ACXD): Mọi Query nạp danh sách sự kiện tộc sự lên thiết bị di động bắt buộc phải đi qua bộ lọc EventSummaryProjection để kiểm soát dung lượng phản hồi thô dưới 100 KB.
8. DOMAIN EVENTS (DANH SÁCH SỰ KIỆN MIỀN)
Các sự kiện nghiệp vụ phát ra dưới cấu trúc chuẩn snake_case và định dạng CloudEvents v1.0:
event_scheduled: Một ngày đại sự hoặc việc họ được lên lịch biểu thành công.
event_rescheduled: Sự kiện có sự thay đổi điều chỉnh về mốc thời gian thực hiện.
event_cancelled: Hội đồng tộc sự quyết định hủy bỏ sự kiện đại sự.
task_assigned: Một đầu việc nghi lễ được phân bổ cho người gánh vác.
task_started: Người gánh vác xác nhận bắt tay vào triển khai công tác hậu cần.
task_completed: Đầu việc nghi lễ được nghiệm thu hoàn thành.
task_reopened: Đầu việc đã xong nhưng cần mở lại do phát sinh yêu cầu mới từ ban tế lễ.
reminder_planned: Bản kế hoạch nhắc nhở truyền thông được đóng gói toàn diện, sẵn sàng gửi sang phân hệ truyền thông để thực thi vòng đời thông điệp.
9. ARCHITECTURE DECISIONS (QUYẾT ĐỊNH KIẾN TRÚC MIỀN - ADR)
Mã Quyết định
Nội dung giải pháp & Ràng buộc kiến trúc (ADR Core)
 
ADR-01: Pre-Calculated Annual Calendar Cache via Incremental Refresh
Miền thực thi tính toán sẵn các ngày kỵ trong block 24 tháng kế tiếp thông qua tiến trình quét tăng trưởng và đẩy thẳng lên Read Model Cache, loại bỏ hoàn toàn cơ chế tính toán On-the-fly khi người dùng truy xuất lịch, đảm bảo hiệu năng tối cao cho hệ thống di động.
ADR-02: Disposable and Re-generable Notification Schedules
Lịch trình bản hoạch định nhắc nhở được thiết kế theo mô hình có thể hủy bỏ và tái lập tự động. Nếu thông tin ngày mất của một cụ tổ được đính chính bên miền Phả hệ, toàn bộ kế hoạch cũ của cụ tổ đó tại miền Sự kiện sẽ bị hủy sạch và tự động tái thiết lập dựa trên dòng chảy sự kiện Member`_updated` hoặc `BranchChanged`.
ADR-03: Deterministic Calendar Engine Specification
Hệ thống quyết định ép buộc bộ lõi `Calendar Engine` phải vận hành theo cơ chế đơn trị định trước (Deterministic). Nghĩa là với cùng một tập dữ liệu đầu vào (Ngày mất Âm lịch, mốc năm tính toán), thuật toán bắt buộc phải sinh ra một đầu ra Dương lịch duy nhất, bất biến tuyệt đối, không được phụ thuộc vào múi giờ thiết bị, hệ điều hành, hay Server Locale của hạ tầng vật lý triển khai.
ADR-04: Business Ledger Immutability for Concluded Events
Mọi sự kiện khi chuyển sang trạng thái kết thúc `CONCLUDED` bắt buộc phải sinh một bản ghi đóng băng sử liệu vào `event_ledger`. Cơ chế này loại bỏ hoàn toàn khả năng chỉnh sửa lịch sử tài sản tâm linh của dòng họ qua nhiều thế hệ.
ADR-05: Stateful Wizard Session for Ritual Task Assignment
Để hỗ trợ thuộc tính Elder-First, tiến trình phân bổ ma trận đầu việc hậu cần của ban tế lễ phải chạy qua một Stateful Session. Trưởng lão có thể thực hiện giao việc qua lệnh thoại hoặc thao tác từng bước (Wizard API), hệ thống tự động lưu tạm tiến trình nhập liệu phòng trường hợp rớt mạng hoặc thao tác lỗi giữa chừng.
ADR-06: Hard Decoupling from Push Messaging Infrastructures
Miền Sự kiện tuyệt đối không tích hợp trực tiếp bất kỳ thư viện hay SDK gửi tin nhắn vật lý nào (như Firebase Cloud Messaging, Twilio, SendGrid). Miền chỉ chịu trách nhiệm sinh bản thiết kế `reminder_planned` thông qua Outbox Table, nhường trọn vẹn việc quản lý vòng đời thông điệp cho lớp truyền thông ngoài biên.

10. CROSS REFERENCES (THAM CHIẾU CHÉO)
Đối chiếu chỉ số hiệu năng máy tính lịch và trải nghiệm người già tại [VOL I - 01] Product Vision Blueprint V3.1.
Tham chiếu học thuyết Sổ cái sử liệu và học thuyết quản lý vòng đời Truyền thông tại [VOL I - 02] Business Doctrine Blueprint V2.1.
Tham chiếu nguyên lý giao tiếp hướng sự kiện phi trạng thái (Events over Shared State) và kiến trúc Outbox tại [VOL I - 03] Product Architecture Blueprint V2.1.
Tham chiếu nguồn chân lý dữ liệu phả hệ để trích xuất sơ đồ quan hệ trực hệ tại [VOL II - 04] Lineage & Member Domain Specification V2.1.
Tham chiếu thiết kế vật lý của cơ sở dữ liệu sổ cái sự kiện tại [VOL III - 11] Enterprise Data & Persistence Architecture.
[KẾT THÚC TÀI LIỆU VOL II - 05 V3.1 - BASELINE APPROVED]