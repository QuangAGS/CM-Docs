BFA — Học thuyết Chi / Gia đình

PATH       : docs/BFA-Branch-Family-Doctrine-v1.0.md
DATETIME   : 2026-09-12T10:45:00+07:00
VERSION    : 1.0.0
STATUS     : Migrate 20260912081914
SSOT-CÙNG  : BFA-Branch-v1.1.0 · HandOver-M13-Branch-2026-09-11
KHÓA       : Q1 bảo toàn · ALS · EDITOR ≠ users.status · place ≠ usage
             A01 không sửa users.phone/email, members.gender, members.is_alive
             Multi-home = nợ · RP/OP/SM CLOSED

Tài liệu này đóng ý nghĩa và phân tầng cửa. Migrate 20260912081914. API M13 hiện tại (DRAFT / SUBMIT / APPROVE = tem) vẫn đúng với học thuyết này.



0. Vấn đề cần giải

Ba nhầm lẫn làm vỡ sổ:





Gộp chi (đơn vị tổ chức họ) với gia đình (hộ trực hệ của một người).



Gộp Tổ nghiệp (người đời ≤ n, đã đứng sổ) với người khai chi (đời n+1, mở hồ sơ).



Gộp vai trên sổ (Founder / Origin) với tài khoản và quyền ghi (users.status, EDITOR).

Hậu quả đã thấy: gà–trứng founder / branch_id, clone người đời cũ, rác chi, khóa nhầm field khi APPROVED.

Học thuyết tách từng lớp, rồi mới nói cửa User / Admin.



1. Hai đơn vị — không đồng nghĩa

1.1 Chi / Ngành / Nhánh (branches)

Đơn vị tổ chức dòng họ. Một chi chứa nhiều hộ, nhiều đời, nhiều quan hệ — trong hạn ngạch đời Admin đã chốt.

Hiệu lực pháp lý trên sổ = tem APPROVED của CLAN_ADMIN / SYSTEM_ADMIN.
Hàng DRAFT / PROVISIONAL / SUBMITTED / REJECTED chưa là chi chính thức.

Cây chi (branches.parent_id) là cây tổ chức. Không thay cây người.

1.2 Gia đình tôi

Tập trực hệ của một member đã bind login: cha/mẹ tôi → tôi → vợ/chồng (nếu cùng họ, quyết riêng) → con. Không mặc định gồm chú bác, anh em, ông bà như vai phải khai trên cửa User.

Gia đình tôi không sinh hàng branches. Nó sinh / sửa hàng members và father_id / mother_id.

1.3 Lý do tách

Nếu mỗi login = một chi, đời n+2 có hàng chục «chi» cùng một ông tổ — cây tổ chức không đọc được.
Nếu chi = hộ, toàn bộ parent_id chi, MERGE, offset đời, EDITOR chi, cấm USER tạo chi 2 trở thành thừa — trái BFA-Branch đã đóng.

Họ nhỏ, một hộ: hình trùng tạm thời. Mô hình vẫn hai lớp.



2. Ba vai — không gộp cột

2.1 Origin — Tổ nghiệp (origin_member_id, cột chưa có)

Người được suy tôn là tổ của chi.





Là hàng members đã có. Cấm clone.



Được phép đã có branch_id khác (đời ≤ n do Admin dựng sẵn).



Gắn Origin không đổi branch_id của người đó.



Có thể chưa đứng chi nào (branch_id null).

Lý do: người đời n là neo lịch sử, không phải nhân sự chi mới. Cướp hoặc nhân bản hàng member = dư thừa + xung đột.

2.2 Founder — Người tổ chức hồ sơ chi (founder_id, đã có)

Người đứng tên mở hồ sơ, hiểu sổ chi, chịu hạn ngạch đời.





Là hàng members. Không phải users.



Mang branch_id = chi này khi hồ sơ đã gắn (Lát 1).



Không mặc định = Origin.



Cửa User + grant: Founder thường = chính member login.



Cửa Admin: chọn tự do (chi lịch sử không cần login của tổ).

Lý do: «người khai» phải thuộc chi mới; «tổ» thường thuộc chi cũ. Một cột không gánh hai nghĩa.

2.3 EDITOR — Quyền ghi sổ chi

Cửa được phép tạo / lắp / (hạn chế) tháo member trong chi, trong quota.





Không đồng nhất users.status.



Không mặc định vĩnh viễn = Founder.



Founder mất hoặc không login: Admin giao EDITOR khác.



Founder có thể được giao EDITOR lúc APPROVE — đó là quyết định Admin, không phải hệ quả tự động của cột founder_id.

Lý do: khóa đã đóng «EDITOR chi ≠ users.status». Gộp Founder = full editor khóa sổ khi người khai không còn dùng được tài khoản.

2.4 User login

Tài khoản. Chỉ có nghĩa khi đã bind users ↔ members (hạng mục 4 đời login — chưa xong thì cửa «Gia đình tôi» / «xin Founder» chưa mở cho User).

User không phải Origin, không phải Chi.



3. Máy trạng thái chi (đã đóng)

DRAFT | PROVISIONAL ──submit──► SUBMITTED ──approve──► APPROVED ──► MERGED (lát sau)
         ▲                         │
         └── reject ──► REJECTED ──┘ submit lại (ticket mới; ticket cũ WITHDRAWN)





Tạo DRAFT / PROVISIONAL: rẻ, chưa hiện sổ chính thức.



APPROVED = tem thừa nhận. Không niêm phong tên, mô tả, origin, parent_id (khóa field là lát riêng nếu cần).



APPROVED không reject / không submit lại.



REJECTED được submit lại: ticket BRANCH_REVIEW mới; ticket cũ WITHDRAWN.



MERGED = gắn cây tổ chức (parent_id + offset đời) — chưa mở.

Lý do: chống rác ở cửa duyệt, không ở cấm nháp. Nháp xóa/ARCHIVED được; tem không đảo.

Mặc định schema CRUD hiện tại: chi mới = PROVISIONAL. Submit chấp nhận DRAFT | REJECTED | PROVISIONAL. Không mở lại OP/SM.



4. Điều kiện từng cửa

4.1 POST tạo hàng chi (nháp)





CLAN_ADMIN / SYSTEM_ADMIN: luôn được.



USER: không mặc định được. Chỉ khi có grant Founder (ticket / cờ — chưa làm).



Không đòi Origin, không đòi 4 đời, không đòi cặp huyết thống.

Lý do: cấm POST trước khi có chi = gà–trứng «Founder của chi nào?». Chống rác bằng Submit + tem, không bằng cấm nháp.

Route hiện USER được POST /branches — lệch mục 4.1. Nợ siết.

4.2 Submit (đã cài)

Bắt buộc:





Người gọi: chủ hồ sơ (changed_by) nếu USER; hoặc CLAN_ADMIN / SYSTEM.



Status: DRAFT | REJECTED | PROVISIONAL.



Có founder_id.



Có ≥ 1 cặp cha/mẹ–con cùng branch_id chi này.

422 BRANCH_SUBMIT_PRECOND nếu thiếu, kèm missing.

Nợ khi có cột Origin: thêm Origin vào precond Submit.
Không đưa «đủ 4 đời trên sổ» vào precond Submit — đưa vào quota sau tem.

Lý do: 4 đời là hạn ngạch hiểu biết được Admin chốt, không phải điều kiện tồn tại hồ sơ. Sổ thật thường thiếu ông cố.

4.3 Approve

Chỉ CLAN_ADMIN / SYSTEM_ADMIN.

Trên ticket BRANCH_REVIEW Admin ghi:





Tem APPROVED.



Quota đời (max_generation_span) — số đời được phép tính từ Origin (khi đã có cột) hoặc từ Founder (tạm).



Có thể giao EDITOR.

Nới quota sau này = ticket mới. Không sửa ý nghĩa tem cũ.

4.4 Reject

reason bắt buộc. Chi REJECTED. Ticket REJECTED. Gửi lại = ticket mới.



5. Quota đời

Sau APPROVE, Chi được phép sâu tối đa N đời.





Mốc: đời Origin = neo (0 hoặc members.generation của Origin trên sổ toàn họ).
Span trên chi = max(đời người đã gắn chi này) − đời Origin.



Vượt quota: 422 lúc gắn / tạo member vào chi, không lúc sửa tên chi.



Đếm chỉ trên father_id / mother_id đã ghi + branch_id chi này. Không đếm chú bác nếu chưa có trên cây người.

Lý do: Admin biết độ tin cậy của Founder và độ dày sổ họ. Founder bị giới hạn bởi sự hiểu biết đã được tem, không phải bởi ham ghi.

Cột max_generation_span chưa có — nợ schema.



6. Cửa User — Gia đình tôi

Áp khi user đã bind member.

Được:





Tạo / sửa người trực hệ: cha/mẹ (nếu chưa có trên sổ), mình (đã có), con.



Ghi father_id / mother_id (kể cả khi mình sẽ là Founder).



Origin mặc định gợi ý = father_id của mình — không bắt nếu thiếu.

Không được mặc định:





POST chi.



Khai chú bác, anh em như thành viên bắt buộc của «Gia đình tôi».



Đổi branch_id người đời ≤ n đã đứng chi khác.



Tạo chi thứ hai (nợ đã ghi).

Thiếu cha trên sổ: vẫn khai mình + con; Submit chi (nếu có grant) 422 vì thiếu Origin / thiếu cặp — đúng.

Hai anh em cùng bố: hai gia đình tôi, cùng Origin, một chi do Admin / Founder lắp — không hai chi.



7. Cửa Admin





Dựng chi lịch sử tới đời n mà không cần login của tổ.



Chọn Origin = người đời ≤ n; không đổi branch_id người đó.



Phong / thu Founder và EDITOR.



Lắp hộ (gia đình) vào chi: ghi members.branch_id trong quota.



Tem APPROVE / REJECT + quota.



Ghép cây chi (lát MERGED).

Admin không bị luật «cha của người login = Origin».



8. Gà–trứng — thứ tự bắt buộc

Chi và người sinh độc lập. Gặp nhau ở bước gắn. Khóa ở bước gửi.

1. Nhập người (CRUD members)     và/hoặc     tạo chi nháp
2. Gắn tổ chức: Origin (trỏ, không chuyển chi)
              Founder + members.branch_id (người của chi mới)
3. Cặp huyết thống cùng branch_id (thường Founder + con)
4. Submit → Admin tem + quota

Không tạo member ma lúc POST chi.
Không tạo chi ẩn lúc POST member.
Không nới FK founder_id sang users.

Khi tạo member từ màn chi: luôn cho nhập cha/mẹ, kể cả Founder. Không bắt cha/mẹ trên chi này khi tạo Founder.



9. Tháo / chuyển người







Trạng thái chi



Founder / EDITOR tháo branch_id





DRAFT, PROVISIONAL, REJECTED



Được, trong tenant





SUBMITTED, UNDER_REVIEW



Không — đang xét





APPROVED, MERGED



Không tự do. Proposal hoặc Admin

Lý do: không đảo tem, cũng không để rút nửa sổ đã công nhận.



10. Chọn người có sẵn

Gợi ý, không chặn cứng đồng danh:





Tên, alias, đời, sống/mất, cha/mẹ nếu có, chi hiện tại (có thể chưa có / unknown).



Cảnh báo nếu người đã đứng chi khác — Origin thì cho trỏ; Founder / thành viên chi mới thì không cướp branch_id.



11. Note và VoiceHelp

members.note, branches.description là định hướng cho người sau (vì sao tách chi, nguồn gia phả, chỗ không chắc).

VoiceHelp dẫn cách viết Note — tài liệu UX, không thêm cột. Không biến Note thành field bắt buộc Submit.



12. Khóa và nợ — không làm chệch doctrine

Đã khóa:





ALS; không nhét tenant_id vào findUnique / update.



A01: không sửa users.phone, users.email, members.gender, members.is_alive.



EDITOR ≠ users.status.



place ≠ usage (member_residences).



Không sửa schema audit_logs.



members.phone / email không unique.



Multi-home (một người hai họ / hai chi hành chính) = nợ.



RP / OP / SM không mở lại.

Nợ schema / lát (chưa sinh):





origin_member_id



max_generation_span



Grant Founder trước khi USER được POST chi



Siết route POST /branches bỏ USER mặc định



Bind 4 đời login



EDITOR grant



MERGED + offset đời



Cấm USER tạo chi 2



Form FE duyệt / VoiceHelp

API đã có: catalog silentIntent, SUBMIT / APPROVE / REJECT, tem không khóa field, ticket mới khi gửi lại.



13. Một trang — câu đóng

Chi là tổ chức họ, do Admin tem.
Gia đình tôi là trực hệ của member login, không phải chi.
Origin là tổ nghiệp, không chuyển chi.
Founder là người mở hồ sơ chi, không phải tài khoản.
EDITOR là quyền ghi, giao riêng.
Nháp thì rẻ. Tem thì một chiều. Quota đời do Admin chốt trên ticket.
Người và chi sinh độc lập; gắn rồi mới gửi; gửi rồi mới thành chi.

Hết.