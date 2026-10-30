# BÁO CÁO GAP ANALYSIS & KẾ HOẠCH HIỆU CHỈNH DATABASE / BE / FE
## myclan.com.vn — Đối chiếu FT-DOCTRINE-SPEC 2.0.2

| Thuộc tính | Giá trị |
|---|---|
| Mã báo cáo | MYCLAN-FTD-GAP-REPORT |
| Phiên bản | 1.1.0 |
| Ngày | 21/10/2026 |
| Trạng thái báo cáo | BẢN HIỆU CHỈNH ĐỂ REVIEW THIẾT KẾ TRIỂN KHAI |
| Chuẩn đích | FTD 2.0.2, coi là đã APPROVED theo giả định làm việc của chủ dự án |
| Bối cảnh dữ liệu | Chủ dự án xác nhận chưa có dữ liệu production |
| Thay thế | Báo cáo GAP/refactor được cung cấp ngày 21/10/2026, không có version rõ trong nội dung |
| Phạm vi | Độ lệch schema, quyết định thiết kế, tác động BE/FE, chuyển đổi dev/test và readiness trước go-live |

> Doctrine đã approved không đồng nghĩa schema vật lý, migration hoặc bản vá trong báo cáo này đã được phê duyệt. Báo cáo không thực thi hoặc cho phép tự động reset, xóa dữ liệu, chạy migration, deploy hay ghi repository.

## 1. Tóm tắt điều hành

Schema hiện hữu có nền tảng đáng giữ: members tách users; định danh sinh UUID; tenant_id; marriages và parent_union_id; ngày sinh/mất tách ngày/tháng/năm; workflow onboarding/proposals; privacy theo nhóm trường; audit và media.

Khoảng trống lớn nhất là quan hệ cha mẹ–con đang được biểu diễn bằng father_id, mother_id và child_type trên cá nhân. Cấu trúc này không đủ cho nhiều loại quan hệ theo từng cha/mẹ và cho các claim mâu thuẫn.

Chưa có dữ liệu production làm giảm nhu cầu duy trì tương thích dữ liệu production lâu dài. Vì vậy, có thể ưu tiên mô hình đích sạch và cập nhật BE/FE theo lát cắt hoàn chỉnh trước go-live, thay vì mặc định duy trì dual-write qua nhiều giai đoạn.

Tuy nhiên, chưa có dữ liệu production không có nghĩa database rỗng, dữ liệu dev/test bỏ được, chưa có migration được áp dụng ở môi trường dùng chung hoặc được phép reset. Các điều kiện này cần xác nhận riêng.

Kết luận: Parentage độc lập là thay đổi nền tảng cần triển khai để đáp ứng FTD; thêm một bảng không đủ để tuyên bố toàn hệ thống đã đạt FTD. Cần bổ sung đúng phạm vi các cơ chế tenant, validation/concurrency, authorization, ordering, ngày, projection và publication.

## 2. Nguồn và giới hạn bằng chứng

### 2.1. Đầu vào

1. FT-DOCTRINE-SPEC-2.0.2-draft-20261020.docx do chủ dự án cung cấp. Tên file còn chứa draft; theo yêu cầu hiện tại, nội dung được dùng như chuẩn đích đã approved trong giả định triển khai. Báo cáo không tự sửa metadata hoặc tạo chứng nhận phê duyệt lịch sử.
2. schema.prisma được upload, có generator prisma-client-js, datasource PostgreSQL và các model hiện hữu.
3. BÁO CÁO PHÂN TÍCH GAP & REFACTOR DATABASE SCHEMA MYCLAN.COM.VN.docx.
4. Thông tin chủ dự án: chưa có dữ liệu production.
5. Kết quả review tĩnh code ở vòng trước tại commit f3828880b68d7c4f71df725857cbacbb65b0efdd, chỉ dùng như danh sách phát hiện cần xử lý/xác minh lại khi triển khai. Chưa kiểm tra commit mới hơn trong lần xuất báo cáo này.

### 2.2. Giới hạn

- Không chạy Prisma validate/generate, build hoặc unit/integration/UI test trong lần lập báo cáo.
- Chưa đối chiếu SQL migration, constraint, trigger, RLS policy và database thực tế.
- Không xác nhận schema upload giống hoàn toàn schema trong commit GitHub được review trước đó.
- Không dùng chú thích VERSION của một model làm version toàn bộ database.
- Không coi một điểm chưa thể hiện trong Prisma schema là bằng chứng database/backend chắc chắn không có cơ chế đó.
- Không đưa ra tỷ lệ phần trăm tuân thủ khi chưa có checklist/test chứng minh.

### 2.3. Mức bằng chứng

| Ký hiệu | Ý nghĩa |
|---|---|
| S | Xác nhận trực tiếp từ schema upload |
| D | Yêu cầu của doctrine chuẩn đích |
| C | Phát hiện review code vòng trước, cần xác minh lại trên snapshot triển khai |
| U | Chưa đủ bằng chứng, cần khảo sát |
| P | Thiết kế/giải pháp đề xuất của báo cáo, chưa phải quyết định vật lý đã duyệt |

## 3. Phân loại ưu tiên và phạm vi release

P0: chặn việc chốt thiết kế hoặc go-live của FT core nếu chưa xử lý.
P1: cần hoàn thiện cho các luồng FT core được phát hành, có thể triển khai sau khi nền tảng được chốt.
P2: nâng cao hoặc tối ưu theo phạm vi sản phẩm và bằng chứng đo.

Ưu tiên không phải kết luận có sự cố production. Chức năng chưa nằm trong release phải được đánh dấu chưa hỗ trợ, không mô phỏng là đã đầy đủ.

## 4. Bảng GAP tổng hợp

| ID | Yêu cầu / phạm vi | Hiện trạng được thấy | Đánh giá | Ưu tiên / hướng xử lý |
|---|---|---|---|---|
| G01 | Person độc lập account | members và users riêng; users.member_id unique | Nền tảng phù hợp, cần chốt identity/link policy (S,D) | Giữ ID và mapping; không đổi tên hàng loạt |
| G02 | Parentage theo từng quan hệ | father_id, mother_id, child_type trên members | Thiếu biểu đạt nhiều loại cha mẹ và nguồn từng quan hệ (S,D) | P0: thiết kế Parentage |
| G03 | Union khác Parentage | marriages, parent_union_id nullable | Cần chốt ngữ nghĩa; không chứng minh bị ép tạo marriage (S,D) | P0: source-of-truth/context contract |
| G04 | Tenant consistency | tenant_id và FK chủ yếu theo id riêng | Chưa đủ bằng chứng đồng nhất tenant giữa các đầu quan hệ (S,U) | P0: khảo sát DB; bổ sung protection phù hợp |
| G05 | Claim/source | Có proposals, data_suggestions, media; chưa thấy claim quan hệ chuyên biệt | Không đồng nhất proposal workflow với bằng chứng gia phả (S,D) | P1: source/assertion design theo phạm vi |
| G06 | Ordering context | sibling_seq trên members | Chỉ có một giá trị toàn cục (S,D) | P1: context/partial-order policy |
| G07 | Đời và mã | generation; generation_naming_rules | Chưa thấy numbering/publication model riêng (S,D) | Chốt semantics trước layout; publication theo release |
| G08 | Ngày thiếu/ước lượng/âm | day/month/year nullable, is_lunar, note; marriage date đầy đủ | Có nền tảng nhưng thiếu cấu trúc nhuận/qualifier/range (S,D) | P1 cho dữ liệu ngày dùng trong release |
| G09 | Trạng thái cá nhân | is_alive nullable, status DU_BI/CHINH_THUC | Không đủ mọi life/identity/review state (S,D) | P1: tách trục, giữ onboarding semantics |
| G10 | Concurrency/version | Chưa thấy version lõi chuyên biệt | Advisory lock không phải bảng bắt buộc trong schema (S,U,D) | P0 design; P1 service/test |
| G11 | Authorization/privacy | users.role, member_offices, grants, privacy SELF/TENANT | Nền tảng có nhưng cần evaluator và impact classes (S,D) | P0 với các endpoint phát hành |
| G12 | Audit/operation | audit_logs, business_process_logs và correlation | Tái sử dụng; chưa chứng minh atomicity mọi write (S,C) | P1: transaction và operation contract |
| G13 | Projection/occurrence | Schema không cần lưu mọi RenderNode; code legacy cần đối chiếu | Không coi thiếu bảng render là GAP database (D,C) | P1–P2: API/projection/UX |
| G14 | Memorial/export/GEDCOM | Có sự kiện, notification, media, mộ | Chưa chứng minh contract mở rộng đầy đủ (S,U,D) | P2 theo phạm vi release |

## 5. Những nhận định cần sửa so với báo cáo trước

### 5.1. Không kết luận parent_union_id bắt buộc tạo hôn nhân giả

Trong schema, father_id, mother_id và parent_union_id đều nullable. Xét riêng schema, có thể lưu mẹ đã biết, cha chưa rõ và không có parent_union. Nếu UI/service bắt tạo marriage thì phải chỉ ra write path đó.

Nhận định thay thế: parent_union_id chỉ giữ một bối cảnh và chưa có contract đủ rõ với cha/mẹ trực tiếp; cần tách Parentage và định nghĩa context, không mặc định xóa cột vì tên gọi.

### 5.2. Không gọi adjacency list là bản thân lỗi kiến trúc

Đồ thị theo edge table vẫn có thể dùng adjacency traversal. GAP là thiếu ngữ nghĩa/quan hệ và bảo vệ đúng, không phải cứ dùng danh sách kề thì sai hoặc phải đổi graph database.

### 5.3. Không đánh giá advisory lock từ việc có/không có bảng

Advisory lock được triển khai qua transaction/service; không cần model lock riêng. Schema có thể cần version/operation state nhưng phải review writer, isolation và concurrency test để xác nhận.

### 5.4. Không kết luận claim mới hoàn toàn không có lịch sử cũ

Schema có audit và proposal. Điều chưa đủ là biểu diễn nhiều khẳng định/nguồn và chọn claim cho đồ thị. Chưa có căn cứ để khẳng định mọi lần sửa trước đây đều mất toàn bộ lịch sử.

### 5.5. Không cam kết đạt toàn bộ FTD chỉ bằng parentages

Cần checklist truy vết yêu cầu sang schema, service, API, UI và test. Định nghĩa Parentage còn là quan hệ nhiều bản ghi giữa các cá nhân theo mô hình one-parent/one-child trên mỗi bản ghi, không gọi cardinality toàn mô hình là quan hệ một-một.

## 6. Kiến trúc đích đề xuất

### 6.1. Giữ và ánh xạ

| Khái niệm FTD | Tái sử dụng hiện hữu |
|---|---|
| Person | members |
| UserAccount | users |
| Union | marriages trong giai đoạn đầu, sau khi mở rộng semantics |
| Branch | branches |
| Proposal/workflow | proposals và onboarding_cases theo đúng loại tiến trình |
| Audit | audit_logs / business_process_logs |
| Media | media |

Không đổi UUID hiện hữu. Không đổi sang PostgreSQL uuid hoặc đổi tên bảng chỉ để giống thuật ngữ nếu không có lợi ích và kế hoạch riêng.

### 6.2. Bổ sung Parentage

Các nhóm trường khái niệm:

```text
parentages
- id / tenant_id
- parent_member_id / child_member_id
- relationship_type / relationship_role?
- review_status
- certainty?                  # ngữ nghĩa chờ chốt, không default chắc chắn tuyệt đối
- source_refs hoặc liên kết nguồn phù hợp
- effective_period?           # chỉ khi có nhu cầu/ngữ nghĩa được chốt
- record_version
- created_at / updated_at / changed_by / deleted_at
```

Đây không phải đoạn Prisma có thể copy chạy ngay. Thiết kế vật lý phải có relation ngược, index, keys, nullability và referential action đầy đủ, được Prisma validate với phiên bản thực dùng.

### 6.3. Accepted edge và claim

Hai lựa chọn vật lý cần quyết định trước triển khai:

- Một bảng assertion/Parentage có lifecycle và policy chọn bản ghi hoạt động.
- Edge được chọn riêng, claim/source records riêng tham chiếu edge hoặc assertion.

Không bắt buộc một framework Claim tổng quát cho mọi trường ngay V1. Tuy nhiên, nếu release hỗ trợ quan hệ tranh luận thì phải biểu diễn được phương án thay thế mà không đưa tất cả vào graph chuẩn.

Không mặc định ACCEPTED cho mọi input/backfill. Độ chắc chắn lịch sử khác trạng thái được chấp nhận vận hành. Nếu cần giữ quan hệ legacy hoạt động, phải nêu cơ chế chấp nhận theo quy trình, không đặt certainty=1.0 để lấp chỗ trống.

### 6.4. Loại quan hệ

Biological, adoptive, foster, other là tập đề xuất căn bản cần duyệt mapping cụ thể. STEPCHILD không tự sinh từ CON_RIENG. Con đỡ đầu không tự đồng nghĩa foster. Vai trò cha/mẹ không suy hoàn toàn từ gender.

### 6.5. Parentage và Union context

Mặc định edge cha/mẹ–con tồn tại độc lập Union. Nếu lưu union_id trên edge phải định nghĩa nó là bối cảnh nào và cách đối xử khi một edge có nhiều bối cảnh. Nếu nhu cầu là một người thuộc nhiều gia đình, cân nhắc liên kết context riêng thay vì ép một union_id giải quyết mọi trường hợp.

V1 có thể giữ parent_union_id làm primary display/family context sau khi chốt nghĩa. Không dùng nó để tự suy biological cho mọi participant. Không thêm kết hôn chỉ từ việc có con chung.

## 7. Toàn vẹn và tenant consistency

Yêu cầu:

- Parent và child cùng tenant theo scope P0–P1.
- Union/context/source link cùng tenant hoặc theo policy explicit được duyệt.
- Không self-parent; không tham chiếu đối tượng không hợp lệ.
- Không tạo duplicate active relation theo khóa nghiệp vụ đã chốt.
- Claim inactive không tự tham gia DAG.
- Soft-delete/archive không làm graph/reference rơi vào trạng thái không được giải thích.

Đề xuất khảo sát composite FK tenant+id cho quan hệ cốt lõi, cùng unique key được tham chiếu; thiết kế phải tương thích nullability/referential actions. Không coi FK id riêng là bằng chứng cùng tenant.

Unique(parent,child,type) cố định có thể xung đột với nhiều claim/lịch sử/soft-delete. Phải chọn mô hình trước khi đặt constraint. Không thêm deleted_at vào unique rồi giả định đã bảo đảm một active row; chính sách unique-active cần được thiết kế và test đúng trên database thực.

Cycle là invariant toàn graph; không giả định một CHECK từng hàng có thể thay giao thức traversal/concurrency. RLS/trigger/constraint ngoài Prisma cần quản lý trong migration đúng phiên bản.

## 8. Version, concurrency và operation contract

### 8.1. Version

Xác định record_version cho entity cạnh tranh, topology/data version theo tenant và policy/authorization/publication version khi cần. updated_at không được coi là token đầy đủ nếu mọi writer chưa cập nhật/so sánh nhất quán.

Có thể dùng bảng trạng thái FT hoặc cột tenant phù hợp; không cần thêm mọi version lên mọi bảng.

### 8.2. Transaction P1

```text
preview ngoài transaction
BEGIN
  lấy topology transaction-level advisory lock theo clan
  đọc trạng thái/version/quyền phù hợp sau lock
  xác minh candidate change và impact
  validate candidate graph + authorization
  ghi source + audit + version/rebuild marker
COMMIT
```

Tất cả writers topology phải tham gia, kể cả MFO, onboarding merge, import, undo và admin jobs. Không giữ lock khi chờ người dùng, layout hoặc tải media. Không mặc định mọi sửa profile phải dùng topology lock; vẫn phối hợp với merge/archive qua row/version contract.

### 8.3. Fail-closed

Cycle validation trả ACYCLIC_CONFIRMED, CYCLE_DETECTED hoặc VALIDATION_INCOMPLETE. Incomplete do timeout/work budget không cho commit graph hoạt động. Budget canvas không là giới hạn chứng minh graph an toàn.

lock wait timeout, statement budget, operation deadline và retry budget là cấu hình riêng. Giá trị ví dụ trong doctrine không tự trở thành SLA đã chứng minh; lock_timeout chỉ giới hạn thời gian chờ lock, không nghĩa lỗi trả tức thì.

### 8.4. Tối ưu

P1 giữ baseline đúng. P2 chỉ tối ưu khi benchmark cho thấy contention cần giải quyết. OCC/version endpoint đơn lẻ không bảo vệ mọi đường graph; subtree lock trên DAG cần chứng minh phối hợp liên vùng. Không cam kết đổi baseline nếu tải thực tế đã đạt.

## 9. Authorization và privacy

Tái sử dụng evaluator hiện có nếu đáp ứng, không tự tạo hệ role song song.

Tách bốn impact sets:

1. Direct write: entity nguồn bị sửa, kiểm tra quyền ghi.
2. Derived: mã tạm/layout/cache, không yêu cầu ACL profile từng hậu duệ.
3. Authorization: scope/member access thay đổi, kiểm tra policy và chống tự nâng quyền.
4. Publication: mã/bản phả ký đã duyệt, kiểm tra quyền renumber/publish và phiên bản.

Explicit deny phải có scope; absence of allow không tự là deny gắn trên mọi nhánh, nhưng kết quả cuối deny-by-default nếu thiếu allow hợp lệ.

Rà soát quan hệ members.role, member_offices và users.role; chức danh không tự thành quyền tài khoản. Rà priority giữa is_contact_public và member_privacy_rules. SELF/TENANT không tự biểu diễn mọi cấp public/branch của sản phẩm; mở rộng đúng nhu cầu và evaluator thực tế.

Mọi list/detail/tree/profile/export/search/notification phải dùng field policy phù hợp, không trả raw member row rồi chỉ ẩn trên UI. HEALTH và tư liệu tranh luận cần kiểm tra riêng.

## 10. Các mô hình bổ sung theo phạm vi release

| Hạng mục | Thiết kế cần chốt | Không nên làm |
|---|---|---|
| Ordering | Context, known/partial/unknown/disputed, display tiebreak | Thêm birth_order_index thứ hai toàn cục |
| Generation | Đời được ghi nhận khác relative_depth/layout_rank | Sửa đời trong DB mỗi khi đổi anchor |
| Numbering | Scheme/root/path/version, published assignments | Dùng mã làm primary key hoặc đổi mã công bố ngầm |
| Date | Ngày thiếu, qualifier/range, lịch gốc, leap month, source | Bịa ngày đầy đủ khi chuyển dữ liệu |
| Life/identity/review | Các trục độc lập với DU_BI/CHINH_THUC | Dùng status onboarding cho mọi trạng thái |
| Memorial | Policy nhuận/ngày thiếu, override/version, dedupe | Chỉ dùng is_lunar để suy mọi quy tắc giỗ |
| Sources | Citation/claim relation theo loại thông tin | Coi media upload là bằng chứng đã xác minh |
| Graves | Trạng thái hiện tại và lịch sử nếu cần | Bỏ unique hiện tại khi chưa có nhu cầu/contract |
| GEDCOM | Intermediate model, hai profile, loss report | Coi GEDCOM là backup toàn ứng dụng |

Những chức năng chưa thuộc V1 có thể được hoãn bằng phạm vi release explicit. Không dùng hoãn tính năng để ghi dữ liệu sai hoặc tuyên bố hỗ trợ đầy đủ.

## 11. Tác động Backend và Frontend

### 11.1. Backend

- Liệt kê writer/readers cho father_id, mother_id, child_type, parent_union_id, sibling_seq và generation.
- Đưa topology mutation về service chuẩn có tenant, capability, version, validation và audit nguyên tử.
- Projection API nhận anchor, graph policy, depth và ngân sách people/edge/occurrence; báo truncated rõ.
- Dùng DTO theo search/tree/profile/admin, không raw row mặc định.
- Query theo hướng cha/mẹ→con và con→cha/mẹ có index phù hợp tenant/status; đo kế hoạch thực thi trước thêm index hàng loạt.
- Tách dữ liệu nguồn khỏi layout jobs/cache. Kết quả job stale không ghi đè version mới.

### 11.2. Frontend

- Phân biệt Person, Union/context và RenderNode/occurrence.
- Một primary occurrence; cùng Person nhận diện phụ, collapse local theo context.
- Mobile dùng menu/modal chọn loại sửa và đối tượng; drag chỉ mở preview.
- Không suy quan hệ từ gender/child_type hay nét vẽ.
- Không reset viewport theo mọi children update; fit theo key đổi cây/anchor hoặc yêu cầu người dùng.
- Search/detail API hợp policy, UI hiển thị trạng thái chưa rõ/thay thế/truncated.
- Giữ khối cặp đôi hiển thị nếu đó là UX đã chốt; không buộc đổi UI chỉ vì thêm Parentage.

### 11.3. Phát hiện code vòng trước cần đưa vào kế hoạch

Tại commit được review trước đó:

- member.controller gọi deleteMember/getRawMembersForTree/getFocalTreeData chưa thấy định nghĩa trong member.service đã đọc.
- PUT member cho USER/V​IEWER có đường kiểm tra khác PATCH profile; cần thống nhất quyền theo target/capability.
- List/detail member trả dữ liệu rộng, cần đối chiếu privacy evaluator.
- createFullMember gọi audit không truyền tx, trong khi audit helper fallback basePrisma và nuốt lỗi.
- Tenant guardrail model lists cần đồng bộ model mới; findUnique projection không có tenant_id và single-record writes cần test coverage.
- buildTreeLogic ưu tiên father_id||mother_id; overview utility chỉ nối cha; chưa đủ cho projection tổng quát.

Đây là dữ kiện review tĩnh vòng trước, không phải kết quả retest runtime hoặc khẳng định tất cả đang được production sử dụng. Không kết luận auth không có rate limiting: auth.routes đã có limiter riêng trong lần review đó.

## 12. Chiến lược chuyển đổi vì CHƯA CÓ DỮ LIỆU PRODUCTION

### 12.1. Chính sách nền

Không bắt buộc duy trì dual-write lâu dài để tương thích production chưa tồn tại. Có thể triển khai schema đích và cập nhật BE/FE đồng bộ trước go-live, với branch/staging/fixture kiểm soát.

Tuy nhiên, phải xác nhận riêng: database dev nào, staging nào, người dùng test nào, dữ liệu nào phải giữ, migration nào đã áp dụng và ứng dụng nào đang dùng API.

### 12.2. Hai phương án

| Phương án | Điều kiện | Thực hiện |
|---|---|---|
| A: môi trường thử nghiệm có thể tái tạo | Chủ dự án xác nhận dữ liệu bỏ được và phê duyệt việc tái tạo môi trường cụ thể | Chốt schema, migration strategy, seed mới và BE/FE cùng release; rehearsal trước go-live |
| B: giữ dữ liệu dev/staging | Có dữ liệu cần bảo toàn hoặc còn bên phụ thuộc | Additive schema, classify/backfill theo nguồn, chuyển readers/writers và đối chiếu trước cleanup |

Không mặc định chọn A chỉ từ câu chưa có production. Reset là thao tác riêng phải xác nhận đúng environment/target; không thực thi trong phạm vi báo cáo này.

### 12.3. Migration history

Ưu tiên migration tiến tới, không sửa lịch sử đã áp dụng trên môi trường cần giữ. Nếu muốn re-baseline trước production, cần quyết định riêng về toàn bộ môi trường, backup cần thiết, chain tái tạo và kiểm chứng clean bootstrap. Không reset database dùng chung chỉ để đổi lịch sử migration.

### 12.4. Không phát sinh dual-write nếu không cần

Nếu không có API/client cũ cần hỗ trợ, có thể cut over đồng thời BE/FE và bỏ phụ thuộc legacy sau khi test. Nếu còn luồng cũ, dùng compatibility projection ngắn hạn, chỉ định một canonical writer và tiêu chí hết hạn. Không để API cũ và mới sửa hai nguồn độc lập.

## 13. Quy tắc xử lý dữ liệu dev/test cần giữ

1. Lập inventory dữ liệu và mục đích giữ.
2. Chụp snapshot/export phù hợp, kiểm tra khả năng phục hồi nếu cần bảo toàn.
3. Phân loại liên kết và ghi provenance từ cột/bản ghi nguồn.
4. Không chuyển mọi father_id/mother_id sang BIOLOGICAL tự động.
5. CON_DE cũng phải kiểm tra vì có default; không mặc định là xác nhận chủ đích.
6. CON_NUOI không đủ để kết luận cả hai parent đều adoptive.
7. CON_RIENG không tự thành cạnh với cha/mẹ kế; CON_DAU/CON_RE không thành Parentage.
8. Trường hợp thiếu căn cứ giữ staging/unresolved hoặc giữ fixture gốc chờ quyết định; không công bố như claim chắc chắn.
9. Chạy cycle/tenant/invariant validation trước publish graph hoạt động.
10. Lưu batch/version/report và làm backfill idempotent.

Staging có thể chứa record chưa giải quyết để phân tích. Việc giữ record lỗi trong staging khác đưa cạnh đó vào graph chuẩn. Có thể tách cảnh báo thời gian khỏi lỗi cấu trúc; không bypass self-parent/cycle/tenant khi publish.

## 14. Lộ trình triển khai đề xuất

| Đợt | Đầu ra | Điều kiện hoàn tất |
|---|---|---|
| R0: inventory | Commit/schema/migration/runtime versions và environment matrix | Biết dữ liệu nào giữ và target nào được phép thay |
| R1: physical design | Parentage/Union context, keys, version, claim và legacy policy | Thiết kế có review, không còn ngữ nghĩa mơ hồ cốt lõi |
| R2: schema + fixtures | Migration/seed, tenant constraints và graph fixtures | Prisma validate/generate và bootstrap môi trường thử nghiệm đạt |
| R3: BE write path | Mutation service, authorization, lock/version, atomic audit | Integration và concurrency tests đạt |
| R4: BE read + FE | Projection/DTO, occurrence UX, giữ UI đã chốt | Contract/UI tests theo scope đạt |
| R5: conversion nếu cần | Backfill dev/staging hoặc seed sạch | Đối chiếu nguồn, invariants, provenance và số lượng |
| R6: pre-go-live | Benchmark, security, restore/runbook và scope release | Readiness gate được phê duyệt |
| R7: cleanup | Bỏ compatibility/cột legacy đủ điều kiện | Không reader/writer/job/export/test nào còn phụ thuộc |

Có thể phát triển song song trên branch nhưng thứ tự publish phải bảo đảm tương thích. Cleanup không chỉ dựa việc bảng mới đã được tạo.

## 15. Tiêu chí kiểm thử và đối chiếu

### 15.1. Mô hình

Một người có cha mẹ sinh học và nhận nuôi; một parent chưa rõ; không có Union nhưng có Parentage; nhiều Union/chồng mốc; claim tranh luận; nhiều root; cùng Person nhiều occurrence; sinh đôi và thứ tự khác nhau theo context.

### 15.2. An toàn ghi

- Self-parent/cross-tenant bị chặn.
- Hai transaction A→B/B→A và ba transaction A→B/B→C/C→A không cùng commit tạo cycle.
- Merge/re-parent/import/undo cùng giao thức.
- Validation incomplete không commit.
- Preview/version/quyền cũ không được dùng ghi đè.
- Audit/source commit/rollback theo contract; retry không nhân bản operation.

### 15.3. Quyền

Sửa mã tạm 500 hậu duệ không cần quyền profile từng người, nhưng thay scope/mã công bố phải theo policy. Contact/health/docs bị hạn chế không lộ qua list/detail/tree/search/export/notification.

### 15.4. FE và lịch

Primary/secondary occurrence đúng; collapse local; sửa Person đồng bộ; không reset viewport ngoài ý muốn; ngày thiếu không thành ngày giả; tháng nhuận/ngày 30 theo policy và override/version; job cũ không gửi lịch lỗi sau thay policy.

### 15.5. Hiệu năng

Dataset 500/5.000/20.000+ Person là benchmark đề xuất, không cam kết render tất cả. Ghi people/edges/occurrences/graph shape/concurrency, latency distribution, memory, lock wait/hold và validation work. Ngưỡng phải chốt từ baseline, không phát minh SLA trong báo cáo.

### 15.6. Chuyển đổi và cleanup

So sánh số bản ghi nguồn với accepted/unresolved/rejected theo quy tắc, không bắt tổng mọi loại bằng một con số thiếu ngữ nghĩa. Mỗi liên kết được chuyển truy ra nguồn, không có orphan/cross-tenant hoặc duplicate active edge trái policy. Clean bootstrap và upgrade rehearsal phải đạt theo phương án chọn.

## 16. Các quyết định triển khai còn cần chốt

FTD đã approved về hướng nghiệp vụ trong giả định này; các mục dưới là quyết định kỹ thuật cụ thể hóa, không mở lại doctrine.

| ID | Quyết định kỹ thuật | Trạng thái |
|---|---|---|
| T01 | Tên/vị trí vật lý Parentage và claim/source | Chờ thiết kế |
| T02 | Ý nghĩa primary parent_union_id và có cần context links riêng | Chờ thiết kế |
| T03 | Compatibility legacy có cần không và thời hạn | Chờ inventory callers |
| T04 | Lưu/kiểm tra tenant constraints và migration SQL ngoài Prisma | Chờ review DB/Prisma version |
| T05 | Accepted/active edge selection, certainty và duplicate/history keys | Chờ thiết kế |
| T06 | Environment/data retention, chọn phương án A/B | Chờ chủ dự án xác nhận |
| T07 | Version/isolation/lock keys, timeout và error contract | Chờ thiết kế và benchmark |
| T08 | Schema ngày/order/identity tối thiểu cho V1 | Chờ chốt scope |
| T09 | Chuẩn DTO/privacy/capability và integration contract | Chờ review BE/FE |
| T10 | Điều kiện cleanup/re-baseline nếu có | Chờ phê duyệt riêng |

## 17. Những phần chưa được thực hiện

- Chưa thay schema, không tạo migration chạy được từ bản phác thảo.
- Chưa chạy backfill hoặc reset bất kỳ database nào.
- Chưa sửa BE/FE, tạo commit hoặc deploy.
- Chưa kiểm tra dữ liệu trong database hoặc xác minh môi trường không có dữ liệu test cần giữ.
- Chưa chạy test/benchmark; chưa công bố production-ready.

## 18. Changelog báo cáo 1.1.0

- Bổ sung bối cảnh chưa có dữ liệu production và hai phương án môi trường.
- Bỏ mặc định dual-write kéo dài; cho phép cutover BE/FE đồng bộ khi phù hợp.
- Sửa kết luận parent_union_id bắt buộc tạo marriage giả.
- Bỏ backfill toàn bộ thành biological và default accepted/certainty tuyệt đối.
- Sửa phân loại stepchild/foster/con đỡ đầu và cardinality Parentage.
- Tách schema gap khỏi kiểm chứng runtime/DB.
- Bổ sung tenant consistency, version, impact authorization, publication và test gates.
- Không coi việc thêm Parentage là đủ đạt toàn bộ FTD.
- Không dùng model-level comment làm version toàn schema.

## 19. Kết luận

Vì chưa có dữ liệu production, myclan có cơ hội triển khai mô hình FTD đích trước go-live mà không phải gánh mặc định một giai đoạn tương thích production dài. Cách phù hợp là chốt physical design, sửa write/read paths và FE theo phạm vi có kiểm thử, dùng seed hoặc chuyển dữ liệu dev/test theo quyết định rõ ràng.

Parentage là nền tảng quan trọng, nhưng không thay Union, không tự giải quyết claim, quyền, concurrency hoặc projection. Báo cáo này là cơ sở thiết kế và kế hoạch nghiệm thu, không phải quyền thực thi migration/reset hoặc xác nhận đã nâng cấp hệ thống.
