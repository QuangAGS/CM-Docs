# FAMILY TREE DOCTRINE & DOMAIN SPECIFICATION
## Quy chuẩn đề xuất cho hệ thống gia phả số myclan.com.vn

| Thuộc tính | Giá trị |
|---|---|
| Mã tài liệu | FT-DOCTRINE-SPEC |
| Phiên bản | 2.0.2-draft |
| Ngày biên soạn | 2026-10-20 |
| Kế thừa | 2.0.1-draft; tổng hợp đầy đủ nội dung nền tảng và các hiệu chỉnh tiếp theo |
| Trạng thái | ĐỀ XUẤT CHỜ DUYỆT |
| Phạm vi | Doctrine, mô hình miền, projection, mutation, quyền, tích hợp, triển khai và nghiệm thu |
| Đối tượng | Product, UI/UX, Backend, Frontend, Data Engineering, vận hành và AI coding agents |

> Đây là tài liệu đầy đủ, độc lập để review; không cần ghép bản trước để hiểu quy chuẩn đề xuất. Đây không phải Prisma schema, migration, source patch hoặc bằng chứng đã kiểm thử hệ thống. Các tên trường/API/enum là khái niệm trừ khi có tài liệu mapping implementation được duyệt. Chưa đối chiếu repository/schema hiện tại trong lần hiệu chỉnh này. Không quyết định nào tự chuyển sang APPROVED chỉ vì được ghi trong bản draft.

---

# PHẦN A — DOCTRINE

## 1. Mục tiêu và mức hiệu lực

FT quản lý cá nhân, quan hệ gia đình và bằng chứng; tạo góc nhìn gia phả có thể giải thích mà không đồng nhất hình vẽ với dữ liệu gốc.

Mục tiêu:

1. Một người không bị nhân bản vì có nhiều vị trí hiển thị.
2. Ngày thiếu, thông tin ước lượng và claim tranh luận được giữ trung thực.
3. Ghi dữ liệu có quyền, preview phù hợp, kiểm soát đồng thời và audit.
4. Tenant isolation được áp dụng ở API, cache, search, file, export và job.
5. Mobile ưu tiên thao tác an toàn; giữ hành vi/UI ngoài phạm vi sửa.
6. Giới hạn tính năng bản đầu không được âm thầm làm sai dữ liệu.
7. Tối ưu theo bằng chứng đo; không lấy tổng Person làm thước đo duy nhất.

### 1.1. Ngôn ngữ

- PHẢI/KHÔNG ĐƯỢC: yêu cầu bắt buộc khi phần liên quan đã được duyệt cho release.
- NÊN: khuyến nghị mặc định; ngoại lệ có lý do.
- CÓ THỂ: tùy chọn.
- ĐỀ XUẤT/CHỜ CHỐT: chưa được hard-code như chính sách đã phê duyệt.

Mọi mặc định trong bản draft vẫn là đề xuất. Phạm vi hiệu lực cần decision record và release cụ thể.

### 1.2. Không thuộc cam kết

Tài liệu không xác nhận schema/endpoint hiện hữu, SLA, tương thích GEDCOM đầy đủ, độ đúng lịch sử của một engine lịch, ngưỡng tuổi pháp lý hoặc kết luận pháp lý về công khai dữ liệu. Tài liệu không cho phép AI tự migration, reset, deploy hay ghi repository.

## 2. Nguyên tắc nền tảng

### 2.1. Tách dữ liệu và biểu diễn

Person là cá nhân; Union/Parentage là quan hệ; RenderNode/RenderEdge là biểu diễn. Nút nối hôn nhân không phải Person. Pan, zoom, chọn, collapse và layout không tự sửa dữ liệu quan hệ.

### 2.2. Định danh

UUID Person ổn định. Mã vị trí phụ thuộc scheme/root/path/version, không làm khóa ngoại chính. Không tái sử dụng định danh người đã merge cho người khác.

### 2.3. Sự không chắc chắn

Không điền 01/01 khi chỉ biết năm; không tạo phối ngẫu giả cho đẹp cây; không suy ra sinh học từ Union. Được duyệt nội bộ không đồng nghĩa sự thật lịch sử tuyệt đối.

### 2.4. Backend quyết định cuối cùng

Frontend hỗ trợ preview/cảnh báo; backend kiểm tra tenant, quyền, version và bất biến ở thời điểm ghi. Che UI không thay kiểm soát payload.

### 2.5. Bảo toàn hiện hữu

Ưu tiên mapping và patch nhỏ. Không viết lại ứng dụng hay tái tạo database để khớp tên thực thể. Phân biệt source of truth, derived read-model, dữ liệu công bố và cấu hình vận hành.

---

# PHẦN B — DOMAIN SPECIFICATION

## 3. Thuật ngữ

| Khái niệm | Ý nghĩa |
|---|---|
| Clan | Miền dữ liệu và chính sách của dòng họ |
| Person | Cá nhân, không phải tài khoản hoặc occurrence |
| UserAccount | Chủ thể xác thực |
| PersonAccountLink | Liên kết danh tính được xác minh, không tự cấp quyền rộng |
| Union | Bối cảnh kết đôi/gia đình, không mặc định chứng minh hôn nhân hay sinh học |
| Parentage | Quan hệ một cha/mẹ tới một người con |
| Source | Tư liệu/người cung cấp có thể tham chiếu |
| Claim | Phát biểu có nguồn và trạng thái |
| Branch | Phân nhóm/phạm vi quản trị được định nghĩa |
| OrderingContext | Phạm vi xác định thứ tự con |
| NumberingScheme | Hệ quy chiếu cấp mã vị trí |
| Projection | Phép chọn và biểu diễn đồ thị |
| Occurrence | Một lần xuất hiện trong ngữ cảnh hiển thị |
| Publication | Phiên bản nội dung đã công bố/phê duyệt |

Không bắt buộc mỗi khái niệm là một bảng. Thiết kế vật lý phải đối chiếu schema hiện hữu.

## 4. Person và tài khoản

```text
Person
- id / clan_id
- display_name / names[]
- gender_or_sex_fields: ngữ nghĩa được xác định riêng
- life_status: living | deceased | missing | unknown
- identity_status: identified | partially_known | unidentified
- review_status: draft | reviewed | disputed
- birth_event_ref? / death_event_ref?
- record_version
- created_at / updated_at
```

Danh tính, tình trạng sống, mức duyệt và account link độc lập. Không gộp vào active; không suy giới từ tên hoặc vai trò.

### 4.1. Placeholder

Có bằng chứng một cá nhân tồn tại nhưng chưa rõ danh tính: có thể tạo Person có nguồn/lý do. Nút “Thêm cha/mẹ”, điểm nối và khoảng trống layout chỉ là UI. Khi xác định được người, cập nhật hoặc merge có kiểm soát, không bỏ lại bản ghi dư.

### 4.2. Account link

Liên kết cần xác minh, trạng thái và thu hồi. Không tự cấp quyền sửa người thân. Số Person một account đại diện, người giám hộ và quyền người đại diện là CHỜ CHỐT.

## 5. Union, Parentage và Claim

### 5.1. Union

```text
Union
- id / clan_id / union_type
- participants[] / events[]
- review_status / source_refs[] / record_version
```

ĐỀ XUẤT V1: tối đa hai Person đã biết trong một Union; cho phép chưa rõ một bên nếu có căn cứ. Một Person có nhiều Union. Ngày có thể thiếu/chồng lấn; không tự cấm vì layout. Không suy hôn nhân pháp lý từ Union, không loại quan hệ chỉ vì giới của các bên.

Union trên hai người ngoài phạm vi V1; khi import không biểu diễn được phải báo, không âm thầm bỏ người. Giới hạn participant khác giới hạn số Union đồng thời.

### 5.2. Vai trò và sự kiện

Chính thất/thứ thất/kế thất cần chủ thể, thời kỳ và nguồn. Không suy từ thứ tự nhập hoặc giới. Thứ tự kết đôi thuộc góc nhìn từng người. Kết hôn, ly hôn, chấm dứt, tái hợp là sự kiện riêng; qua đời không thành ly hôn. Chính sách tái hợp dùng Union cũ/mới CHỜ CHỐT.

### 5.3. Parentage

```text
Parentage
- id / clan_id
- parent_person_id / child_person_id
- relationship_type: biological | adoptive | foster | other
- relationship_role? / effective_period?
- review_status / certainty / source_refs[] / record_version
```

Danh mục phải map dữ liệu cũ. Không vừa type vừa cờ đồng nghĩa làm hai nguồn sự thật. Con thuộc Union không tự là con sinh học của mọi participant. Con riêng không tự tạo Parentage với cha/mẹ kế. Một người có thể có quan hệ sinh học và nhận nuôi khác nhau. Giới hạn cha/mẹ phải theo ngữ nghĩa/policy, không theo tổng cạnh mọi loại.

### 5.4. Claim

Trạng thái đề xuất: proposed, accepted, disputed, rejected, superseded. Không xóa bằng chứng vì chọn giả thuyết khác. Graph chuẩn chỉ dùng claim được chọn theo policy; chế độ nghiên cứu phải phân biệt phương án. Review status không phải mức chắc chắn lịch sử.

## 6. Graph, đời, thứ tự và numbering

### 6.1. Graph policy

- Biological ancestry: quan hệ sinh học được chọn.
- Family ancestry: cha mẹ được công nhận theo cấu hình, phân biệt loại.
- Lineage: quan hệ dùng cho truyền thừa theo policy clan.
- Display: dữ liệu sau phạm vi/quyền/projection.

Không mặc định biological + adoptive cho mọi phép tính. Con nuôi có thể thuộc lineage nhưng không trở thành tổ tiên sinh học. Mỗi graph có edge policy/version. Spouse edge không tự tham gia kiểm tra DAG tổ tiên. Foster và loại quan hệ khác cần quy định riêng.

### 6.2. Đời

Tách declared_generation, relative_depth theo anchor/path và layout_rank của occurrence. Đời chuẩn cần root/scheme, loại quan hệ và cách xử lý nhiều đường đi. Đổi anchor không ghi đè đời đã xác nhận.

### 6.3. Thứ tự con

```text
ChildOrderAssignment
- ordering_context_id / child_person_id
- order_index?
- order_status: known | partial | unknown | disputed
- source_ref? / manually_confirmed
```

Không đặt duy nhất birth_order_index toàn cục trên Person. Context có thể là nhóm con của một phụ huynh, gia đình hoặc numbering scheme. Phân biệt historical order, display order và published position. Không dùng created_at hoặc giới làm thứ bậc sinh. Sinh đôi/thứ tự chưa rõ cần trạng thái riêng. Xem Phụ lục B.

### 6.4. Mã d’Aboville sửa đổi

Tách mã tham chiếu theo root/scheme của clan khỏi mã đường đi theo góc nhìn.

```text
PositionAssignment
- numbering_scheme_id / root_person_id
- path_key / person_id / position_code
- scheme_version / validity / publication_state?
```

Mã là dẫn xuất nhưng có thể materialize/version. Một Person có nhiều mã theo path/scheme. Đổi anchor không tự đổi mã tham chiếu đã công bố. Renumber cần preview, mapping và quyền publication khi phù hợp. Alias mã cũ cần scheme/version. Nếu thứ bậc chưa rõ, không trình bày mã tạm như sự thật đã xác nhận.

## 7. Ngày, lịch và lịch giỗ

```text
GenealogicalDate
- calendar / year? / month? / day? / is_leap_month?
- precision: day | month | year | unknown
- qualifier: exact | about | before | after | between | unknown
- range_end? / original_text? / source_ref? / conversion_metadata?
```

Phải định nghĩa tổ hợp hợp lệ và phân biệt khoảng khả dĩ của ngày sự kiện với thời kỳ kéo dài.

### 7.1. Source và conversion

Giữ ngày gốc/precision. Không ép ngày lịch sử thành timestamp. Không bịa năm để quy đổi. Kết quả quy đổi có engine/version/múi giờ/policy/status. Mâu thuẫn âm–dương giữ nguồn và cảnh báo, không lấy lần nhập cuối làm đúng.

### 7.2. Engine lịch

Đề xuất khảo sát implementation dựa trên thuật toán Hồ Ngọc Đức; chưa chọn package. Kiểm tra license, miền năm, timezone, test vector và dữ liệu ngoài miền. Không coi một thuật toán lịch hiện đại tự tái hiện đúng mọi lịch lịch sử. Không ghi đè ngày nguồn khi quy đổi khác. Xem Phụ lục D.

### 7.3. Memorial

```text
MemorialRule
- person_id / calendar / month / day / original_is_leap_month
- leap_month_policy / missing_day_policy
- notification_offsets / recipient_policy / policy_version
```

ĐỀ XUẤT default: regular_month và last_day_of_month; override từng sự kiện được phép và hiển thị nguồn policy. Đây là lựa chọn sản phẩm, không khẳng định tập quán phổ quát. Chưa APPROVED thì không tự bật gửi thực tế. Thiếu ngày/năm phải giữ nguyên mức biết. Metadata nghi lễ không là điều kiện bắt buộc để lưu ngày.

## 8. Bất biến, validation và cảnh báo

### 8.1. Chặn ghi

Self-parent; cycle trong graph phải không chu trình; cross-tenant trái policy; tham chiếu không hợp lệ; thiếu quyền; version/scope conflict; duplicate theo khóa nghiệp vụ đã duyệt; trạng thái miền bất hợp lệ.

Không bypass lỗi bất biến/quyền bằng xác nhận cảnh báo.

### 8.2. Validation có ba kết luận

```text
ACYCLIC_CONFIRMED
CYCLE_DETECTED
VALIDATION_INCOMPLETE
```

Không phát hiện cycle trước khi hết budget không đồng nghĩa acyclic. VALIDATION_INCOMPLETE không cho commit topology; cần retry có kiểm soát hoặc luồng xử lý khác được duyệt, không bypass.

Depth/budget hiển thị khác depth/budget chứng minh bất biến. Không lấy max_depth canvas làm độ sâu tối đa rồi kết luận graph an toàn. Chi tiết Phụ lục A.

### 8.3. Thời gian

Phân loại valid, inconsistent, uncertain, not_evaluable. So sánh theo precision/khoảng; không điền ngày giả. Ngưỡng tuổi sinh con, tuổi thọ, kết hôn là cấu hình có version, không là luật phổ quát.

```text
marriage_date >= max(birth_A + threshold_A,
                     birth_B + threshold_B)
```

Biểu thức không là quy định pháp lý. Ngày mất trước sinh hoặc hôn nhân trước sinh là xung đột nghiêm trọng; nguồn vẫn có thể lưu như claim chờ xử lý, không tự thành dữ liệu chuẩn. Ngày sinh/mất cùng ngày cần policy theo precision.

### 8.4. Ngoại lệ

Lưu rule version, warning code, actor, lý do, nguồn và phạm vi chấp nhận. Ngoại lệ không cho bỏ qua tenant/quyền/cycle. Rule đổi cần khả năng rà soát theo phạm vi đã chốt.

## 9. Branch và truyền thừa

Branch độc lập viewport/collapse. Cần root/tiêu chí, membership động/cố định, chồng lấn, phân cấp và cách thay đổi khi Parentage đổi.

Chi trưởng và danh vị được clan xác nhận theo nguồn; không tự quyết định từ giới, ngày sinh hay thứ tự nhập. Không xóa dữ liệu phụ nữ, con gái, con nuôi vì quy tắc truyền thừa.

Phân nhóm văn hóa và scope cấp quyền có thể liên quan nhưng không được coi đồng nghĩa nếu chưa có policy. Không dùng thay đổi cây để tự tăng quyền.

---

# PHẦN C — PROJECTION, CANVAS VÀ MUTATION

## 10. Projection contract

Views: ancestors, descendants, hourglass, clan overview. Overview có thể nhiều root/thành phần chưa nối.

```text
ProjectionRequest
- clan_id / anchor_person_id? / root_set?
- view_mode / relationship_policy
- max_depth / people_budget / edge_budget / occurrence_budget
- expansion_state / privacy_context / data_version

RenderNode
- render_node_id / person_id? / union_id?
- occurrence_context / layout_rank / permitted_display_fields

RenderEdge
- render_edge_id / source_render_node_id / target_render_node_id
- relationship_refs[] / visual_type

ProjectionMetadata
- data_version / policy_versions
- truncated / truncation_reason? / expandable_contexts[]
```

Occurrence ID ổn định trong ngữ cảnh thích hợp; không tạo random ID mỗi render làm mất state. Ngân sách occurrence quan trọng khi DAG sinh nhiều đường đi. Khi cắt kết quả phải báo rõ không phải toàn bộ cây.

## 11. Layout và UX

### 11.1. Layout

Ưu tiên không chồng node/cạnh không xuyên nội dung không liên quan. Không hứa mọi graph không giao cạnh. Căn theo layout_rank, không một generation_level chưa định nghĩa. Chốt tâm/mép node và kích thước trước công thức spacing.

Cùng input/cấu hình/kích thước nên cho kết quả xác định. Mở nhánh hạn chế nhảy viewport. Không tính lại layout khi chỉ pan/zoom. Worker phải loại kết quả stale theo request/data version.

### 11.2. Điều hướng/mobile

Zoom/pan theo thiết bị; dải 10%–500% chỉ là mục tiêu khảo sát. Không chỉ dựa double-click. Phân biệt tap/pan/sửa. Có điều hướng thay thế, không chỉ truyền ý nghĩa bằng màu.

Mobile mặc định menu → loại sửa → chọn đối tượng → preview → xác nhận. Drag & drop là bổ sung mở cùng quy trình, không ghi ngay lúc thả.

### 11.3. Occurrence

Một primary occurrence; các occurrence cùng Person nhận diện phụ. Không tự pan tới occurrence ngoài màn hình, không mặc định nhấp nháy mọi nơi. Sửa Person cập nhật mọi occurrence được phép thấy. Collapse theo occurrence/path. Xem Phụ lục C.

### 11.4. Search/collapse

Search/gợi ý/index không lộ trường ẩn. Kết quả ngoài độ sâu/nhánh thu gọn phải được thông báo và mở có kiểm soát. Collapse không sửa source. Minimap/level of detail tùy thiết bị và benchmark.

## 12. Mutation, preview và impact authorization

### 12.1. Phân loại hành động

Tách sửa Parentage sinh học, nhận nuôi/chăm sóc, Union, phân nhóm Branch và bố trí. “Chuyển nhánh” không đủ định nghĩa thao tác.

### 12.2. Quy trình chuẩn

```text
Chọn thao tác
→ Tính candidate change và impact sơ bộ
→ Preview trước/sau và policy áp dụng
→ Xác nhận
→ BEGIN + cơ chế bảo vệ đồng thời
→ Đọc lại version/quyền/trạng thái phù hợp
→ Tính và kiểm tra candidate graph
→ Authorization theo các nhóm tác động
→ Ghi source + audit + version/rebuild marker
→ COMMIT
→ Rebuild có kiểm soát nếu cần
```

Không giữ topology lock khi người dùng đang xem preview. Preview token ràng buộc actor/tenant/action/target/version/thời hạn, nhưng không thay authorization khi ghi.

### 12.3. Bốn tập tác động

| Tập | Nội dung | Kiểm tra |
|---|---|---|
| Direct write set | Person/Parentage/Union và source record thực sự bị sửa | Quyền ghi trực tiếp và bất biến |
| Derived recomputation set | Layout, cache, mã tạm/read-model | Không yêu cầu quyền sửa từng descendant |
| Authorization impact set | Membership/scope/access thay đổi | Policy thay đổi quyền, chống tự nâng quyền |
| Publication impact set | Mã tham chiếu đã công bố, nội dung được duyệt | Quyền renumber/publish và version |

Không đồng nhất impact set với toàn bộ node phải có BranchEditor. Không thu hẹp authorization thành “chỉ source write” nếu thao tác làm đổi scope hoặc dữ liệu công bố.

Ví dụ sửa quan hệ của B khiến 500 hậu duệ đổi mã tạm: không yêu cầu quyền sửa hồ sơ cả 500 người. Nhưng nếu làm đổi quyền xem hoặc mã đã công bố, phải qua policy tương ứng. Không cần quyền trên mọi descendant chỉ vì bị tính lại.

### 12.4. Impact calculation theo quy mô

Có thể dùng mô tả phạm vi/count/job thay vì đưa mọi người vào payload; không bỏ kiểm tra cần thiết chỉ vì không materialize toàn impact set trong RAM. Preview không lộ danh tính ngoài quyền. Nếu chưa thể xác định impact bắt buộc, không coi thao tác đã được phê duyệt an toàn.

### 12.5. Version và rebuild

Version/quyền thay đổi: conflict và preview lại theo contract. Source có liên quan ghi nguyên tử. Derived lớn có thể async, có status/idempotency/retry và policy snapshot cũ/mới; không trả dữ liệu một phần như đã nhất quán. Publication không bị job rebuild âm thầm ghi đè.

## 13. Duplicate, merge và xóa

Similarity là gợi ý, không xác suất đúng nếu chưa hiệu chuẩn; không hard-code 80% từ ví dụ. Dùng tên, ngày theo khoảng, quan hệ, địa điểm và nguồn, trả lý do. Không match chéo tenant mặc định.

Merge phải preview ID giữ lại, trường xung đột, quan hệ, Union, nguồn, account, Branch và numbering. Kiểm tra candidate graph toàn thao tác, self-parent, cycle, duplicate edge, Union bất thường và quyền. Không tự drop cạnh để merge thành công. Không hứa unmerge nếu chưa có contract/dữ liệu phục hồi.

Phân biệt ẩn occurrence, kết thúc/xóa quan hệ, archive và xóa cứng Person. Không cascade xóa người thân. Soft-delete không thay mọi nghĩa vụ xóa; file/audit/retention có policy riêng.

---

# PHẦN D — SECURITY VÀ TÍCH HỢP

## 14. Tenant, RBAC và privacy

### 14.1. Isolation đề xuất P0–P1

Một Person thuộc một clan; chưa liên kết/merge cross-clan. Cùng người ở hai clan là hai record quản lý độc lập, không tự merge từ tên/account. Đây là phạm vi phiên bản, không cam kết vĩnh viễn.

Tenant lấy từ ngữ cảnh tin cậy và xác minh ở mọi read/write/cache/search/job/file/export; không chỉ tin clan_id client. Các tham chiếu liên thực thể phải kiểm tra tenant.

### 14.2. Roles khái niệm

PlatformAdmin vận hành nhưng không mặc định đọc mọi gia phả. ClanAdmin quản trị trong clan theo quyền. BranchEditor theo scope. Member theo quyền xem/đề xuất. Guest chỉ nội dung công bố. Map role thật trước triển khai.

### 14.3. Deny và scope

Đề xuất ba trạng thái: explicit_allow, explicit_deny, not_applicable. Không có allow không tự tạo explicit deny ở mọi nhánh; kết quả tổng hợp vẫn deny-by-default nếu không có allow hợp lệ. Explicit deny phù hợp scope thắng allow theo policy đã chốt.

Cần định nghĩa kế thừa, ngoại lệ/admin, chồng lấn Branch và đối tượng áp dụng. Topology write là capability riêng, không mặc định suy ra từ sửa tiểu sử. Không dùng quy tắc “3 đời” cấp quyền khi chưa định nghĩa cách đếm.

### 14.4. Privacy

Không mặc định người mất công khai đầy đủ. Có quyền theo trường với ngày chi tiết, liên hệ, vị trí/mộ, nguồn, tranh chấp và dữ liệu gia đình. Áp dụng API/search/export/notification/audit, không che CSS sau khi đã gửi payload. Consent, trẻ vị thành niên, đại diện và xóa dữ liệu cần review riêng.

### 14.5. Cache/file

Cache đã lọc quyền có tenant/data version/access scope/policy version phù hợp; thu hồi quyền phải vô hiệu kết quả không còn hợp lệ. File export/media có quyền, retention và link tải được kiểm soát. Không công khai snapshot nội bộ mặc định.

## 15. Audit, undo và restore

Audit có operation/correlation, tenant, actor/context, action, entity refs, diff/before-after phù hợp, version, lý do/nguồn, warning/rule version và timestamp. Không log credential hoặc dữ liệu dư thừa. Quyền đọc, retention và tính toàn vẹn cần thiết kế.

Undo là mutation mới tham chiếu mutation cũ; kiểm tra conflict, quyền, bất biến và publication/scope impact. Không ghi đè mù bản ghi để hoàn tác một trường.

Restore snapshot là quy trình riêng: tenant/phạm vi/thời điểm, preview mất dữ liệu, bản bảo vệ, cửa sổ vận hành, file/index/job và test. RPO/RTO chờ chốt. Audit không chứng minh có thể phục hồi mọi thời điểm.

## 16. Memorial, GIS, export và GEDCOM

### 16.1. Notification

Dùng policy version, dedupe occurrence/người nhận/kênh/lần nhắc; kiểm tra quyền/consent lúc gửi, có retry/hủy. Không gửi mặc định toàn nhánh. Đổi policy cần xử lý job cũ để tránh hai lịch.

### 16.2. Mộ phần

Hỗ trợ vị trí và lịch sử cải táng nếu cần; altitude không bắt buộc. Độ chính xác và quyền tọa độ rõ ràng. GIS nâng cao không là điều kiện để lưu người mất.

### 16.3. Xuất bản

Chốt snapshot, filter, quyền, khổ/đơn vị/tỷ lệ/font tiếng Việt/phân trang. Vector nghiệm thu bằng hình học/nét/font; DPI cho raster riêng. Báo nội dung lược bỏ mà không lộ nội dung đó. Job lớn có status/retention. Dữ liệu đã công bố không bị rebuild ghi đè ngầm.

### 16.4. GEDCOM

Một spec tương tác chung, hai profile độc lập 5.5.1 và 7.0; reader/writer/validator riêng và bản đặc tả hiệu chỉnh được ghim. Mapping phải ghi mức bảo toàn, không giả định Union↔FAM hoặc Parentage↔PEDI hoàn hảo.

Import: giới hạn đầu vào/giải nén → staging/parse theo batch phù hợp → resolve refs → validation → preview → publish theo concurrency protocol. Không công bố dữ liệu nửa chừng hoặc bypass topology lock bằng job import.

Export: snapshot/quyền → intermediate model → writer → validation → loss report → file/media. Có thể stream/batch/background. Không xuất credential/ACL/session/cấu hình vận hành mặc định. GEDCOM không là backup toàn ứng dụng; extension/sidecar có contract riêng, không hứa phần mềm đích hiểu. Round-trip ghi rõ trường được/mất.

---

# PHẦN E — DELIVERY SPECIFICATION

## 17. Giai đoạn

| Giai đoạn | Phạm vi | Gate |
|---|---|---|
| P0 | Map schema, graph/order/number/date, tenant/privacy | Quyết định miền được duyệt |
| P1 | Mutation, preview, concurrency, impact authorization, audit/merge | Test quyền, transaction, race và giới hạn tài nguyên |
| P2 | Projection/UX/layout/query/cache/benchmark | Ngưỡng đo đạt; tối ưu khi có bằng chứng |
| P3 | Memorial, GIS, GEDCOM, xuất bản | Contract/fixture từng tính năng |

Không phải lịch hoặc ước lượng nhân lực. Không mặc định P2 phải thay clan lock bằng subtree lock. Tái sử dụng hiện hữu nếu phù hợp.

## 18. Nghiệm thu

### 18.1. Fixture nền tảng

Gia đình đơn giản; người chưa rõ; nhiều Union thiếu/chồng ngày; sinh học và nhận nuôi; hậu duệ chung; nhiều root; ngày thiếu/khoảng/âm; claim tranh luận; sửa cây đổi scope/mã; merge xung đột; undo sau thay đổi mới; sinh đôi/thứ tự không rõ; giỗ tháng nhuận/ngày thiếu; cross-tenant mọi kênh; worker stale; ghi đồng thời nhiều cạnh.

### 18.2. Tiêu chí

- Đổi view không ghi quan hệ.
- Mỗi Person vẫn một bản ghi trong tenant dù nhiều occurrence.
- Preview/version cũ không ghi đè trạng thái mới.
- Không commit nếu cycle check chưa kết luận.
- Không lộ dữ liệu qua search/cache/file/job.
- Derived-only descendants không bị yêu cầu quyền sửa hồ sơ; scope/publication impact vẫn được bảo vệ.
- Mã công bố không tự đổi do anchor/tiebreak.
- Retry/rebuild không tạo bản ghi trùng hoặc ghi đè phiên bản mới.

### 18.3. Benchmark

500, 5.000, 20.000+ Person là mức thử đề xuất, không cam kết render đồng thời/SLA. Ghi cạnh, độ sâu, cấu trúc, path/occurrence, tốc độ ghi topology, concurrency, thiết bị/mạng và cache.

Đo API/query/projection/layout/render/memory, mutation latency, lock hold/wait, validation work, timeout/retry và import. Báo phân phối latency, không chỉ một lần nhanh. Threshold/budget chờ baseline và phê duyệt kỹ thuật.

### 18.4. Readiness

Production-ready theo phạm vi: decisions duyệt, mapping code, test chức năng/quyền/race, migration rehearsal nếu có, backup/restore theo contract, benchmark, monitoring và rollback vận hành. Tài liệu hoặc tạo file thành công không thay các bằng chứng.

## 19. Áp dụng và AI agents

1. Chốt repo/branch/commit/phạm vi.
2. Đọc schema/API/UI/migration history.
3. Map hiện tại→đề xuất; báo xung đột/chỗ chưa biết.
4. Chốt quyết định, không phỏng đoán.
5. Patch nhỏ, giữ UI/hành vi không liên quan.
6. Migration có impact/backfill/lock/backup/phục hồi.
7. Staging rehearsal, đối chiếu người/quan hệ trước sau.
8. Test và báo đúng mức kiểm chứng.
9. Production sau gate/phê duyệt.

Không sửa/xóa migration đã áp dụng hoặc reset production để làm sạch lịch sử. Ngoại lệ cần quy trình được duyệt.

AI không tự schema giả, migration/reset/deploy/ghi repository. Draft không cao hơn quy chuẩn đã duyệt. Phải đọc file thật, nêu file đã đọc/chưa xác minh, trình bày diff/rủi ro, xuất full source đúng phiên bản khi được yêu cầu. Không nói đã test khi chưa chạy, không nói đã duyệt vì đã tạo tài liệu.

## 20. Decision Register

Tất cả dưới đây là PROPOSED. Bảng thể hiện phương án trình duyệt, không phải lịch sử phê duyệt.

| ID | Quyết định đề xuất | Gate |
|---|---|---|
| D01 | Strict isolation P0–P1; không merge/link cross-clan | P0 |
| D02 | Union tối đa hai Person V1; Person nhiều Union có thể chồng lấn | P0 |
| D03 | Biological/family/lineage độc lập, policy/version rõ | P0 |
| D04 | UUID chính; mã theo scheme/root/version; snapshot khi công bố | P0 |
| D05 | Một primary occurrence, highlight phụ, local collapse | P2 trước UI |
| D06 | regular_month + last_day_of_month, có override/version | P0 model; P3 gửi |
| D07 | Warning ngưỡng có version; không bypass bất biến | P0 |
| D08 | Explicit deny có scope; direct-write + authorization + publication checks, không ACL từng derived descendant | P0–P1 |
| D09 | Privacy theo trường/kênh; không mặc định công khai người mất | P0 |
| D10 | P1 topology advisory lock/clan; P2 đánh giá tối ưu, không cam kết subtree lock | P1 |
| D11 | Undo/restore riêng; retention/RPO/RTO cần duyệt | P1/vận hành |
| D12 | GEDCOM một spec/hai profile/loss report | P3 |
| D13 | Baseline + projection/validation budget; chưa SLA | P1–P2 |
| D14 | Mapping role/schema/repo trước thay đổi vật lý | P0 |
| D15 | Ordering context, mã tạm và renumber/publication policy | P0 |
| D16 | Readiness gate theo phạm vi release | Mọi release |
| D17 | Ba kết luận cycle validation, incomplete không commit | P1 |
| D18 | Mutation class/fast path có chứng minh và phối hợp writer | P1 baseline; P2 nghiên cứu |

Mẫu decision record bắt buộc khi duyệt:

```text
Decision ID / nội dung và revision
Status: PROPOSED | APPROVED | DEFERRED | REJECTED | SUPERSEDED
Approved by / Approved at
Effective release
Conditions / exceptions
Evidence / test references
Supersedes?
```

Approved by/at đang để trống cho toàn bộ draft. Không điền tên/ngày giả. Một quyết định có thể được duyệt với điều kiện; điều kiện chưa đạt thì không bật chức năng tương ứng.

## 21. Lịch sử thay đổi

### 21.1. Nền tảng 2.0.0

Tách Person/quan hệ/render, thêm claim/ngày thiếu, đời/mã/layout, sửa công thức kết hôn, tenant/privacy, audit/undo/restore, giai đoạn/fixture.

### 21.2. 2.0.1

Thêm graph concurrency contract, order theo context, occurrence/mobile UX, mã công bố vs view, sửa D02/D03/D08, engine lịch và memorial policy, readiness và phụ lục.

### 21.3. 2.0.2

- Bỏ diễn đạt safety tuyệt đối chỉ từ advisory lock.
- Làm rõ lock chỉ tuần tự writer cùng giao thức, không mọi write trong clan.
- Phân loại mutation; fast path không dựa vào nhãn “nhỏ”.
- OCC/commit validation không tự bảo vệ reachability; yêu cầu giao thức chống race đầy đủ.
- Subtree lock là hướng nghiên cứu, không mốc bắt buộc P2.
- Thêm ba kết luận cycle check và fail-closed khi incomplete.
- Phân biệt lock wait/statement/operation budget; thêm observability.
- Chia impact thành direct, derived, authorization và publication.
- Derived descendants không cần quyền sửa riêng; scope/publication vẫn cần kiểm soát.
- Thêm decision approval metadata và fixture/acceptance tương ứng.

## 22. Quản lý hiệu lực

Tài liệu đầy đủ gồm phần chính và phụ lục. Nếu xung đột: dừng phần liên quan, tạo change request, không tự chọn quy tắc thuận tiện. Sau duyệt có thể tách Doctrine/Domain/Delivery nhưng phải giữ cross-reference và version.

Mỗi thay policy có version, impact, tương thích và test. Phiên bản này không tự cấp quyền triển khai hoặc phê duyệt các điểm chờ chốt.

---

# PHỤ LỤC A — GRAPH MUTATION & CONCURRENCY CONTRACT

## A.1. Đồ thị ứng viên

Cạnh parent→child. Chỉ tập cạnh theo graph policy tham gia DAG check; không gộp spouse edge. Candidate graph là trạng thái sau toàn bộ thay đổi dự kiến, không phải từng trạng thái trung gian được kiểm tra rời rạc.

## A.2. Re-parent

1. Kiểm tra identity/tenant/quyền/version.
2. Xác định tập cạnh bỏ/kết thúc và cạnh thêm.
3. Với P→C, chặn P=C.
4. Trên candidate state thích hợp, kiểm tra reachability C→...→P.
5. Có đường đi thì CYCLE_DETECTED; không có chỉ được xác nhận khi kiểm tra đủ.
6. Nhiều cạnh thêm phải xét tổng hợp; không cho từng cạnh vượt qua trên graph cũ rồi ghép lại.

Có thể dùng BFS/DFS có visited set hoặc recursive query được thiết kế đúng. Chi phí phụ thuộc phần graph được duyệt; thao tác gần root có thể lớn. Không dùng độ sâu hiển thị để cắt chứng minh bất biến.

## A.3. Validation budget

Các giới hạn khái niệm:

```text
lock_wait_budget
validation_statement_budget
traversal_work_budget
operation_deadline
retry_budget
```

Ngưỡng là cấu hình được benchmark/duyệt, chưa có con số bắt buộc trong doctrine. Work budget có thể xét đỉnh/cạnh/trạng thái trung gian, không chỉ số người trả về.

Kết quả:

| Kết luận | Ghi topology |
|---|---|
| ACYCLIC_CONFIRMED | Có nếu mọi điều kiện khác đạt |
| CYCLE_DETECTED | Không |
| VALIDATION_INCOMPLETE | Không |

Hết depth/time/work không trả acyclic. Khi statement bị hủy/lỗi, rollback theo transaction contract; không tiếp tục ghi bằng đường bypass. Không dùng LIMIT ở query ngoài như bằng chứng đã kiểm tra đầy đủ. Có thể lên lịch validation chuyên biệt có tài nguyên phù hợp nhưng phải revalidate version và concurrency trước commit; kết quả trên snapshot cũ không tự cấp phép ghi.

## A.4. Giao thức P1 đề xuất

Transaction-level advisory lock theo clan cho topology writers có tham gia giao thức:

```text
preview ngoài transaction
BEGIN
  lấy lock theo namespace/key thống nhất
  đọc lại graph/version/quyền với snapshot phù hợp sau lock
  kiểm tra expected versions
  tính candidate graph + các impact bắt buộc
  validate invariants + authorization
  ghi source, audit, versions, rebuild marker
COMMIT
```

Điều kiện:

- Mọi writer topology dùng cùng protocol: API/import/merge/undo/admin jobs.
- Lock key có namespace, không va chạm tùy tiện giữa subsystem.
- Lock ở database phù hợp đa instance; không thay bằng mutex Node.js đơn lẻ.
- Không giữ lock chờ người dùng, media, layout, export hoặc notification.
- Isolation/snapshot bảo đảm validation thấy trạng thái cần thiết; không dùng snapshot trước chờ lock một cách mù quáng.
- Nếu thao tác còn phải chặn profile edit/merge/archive liên quan, phối hợp row/version contract riêng.
- Thay quyền đồng thời có cơ chế version/lock phù hợp, không dựa vào auth cũ.
- Nhiều lock có thứ tự thống nhất và deadlock test.
- Retry bounded và idempotent theo operation key có scope/actor/payload phù hợp.

Advisory lock không tự tạo tính toàn vẹn 100%. Nó chỉ có ý nghĩa khi writer tuân thủ, validation đúng và transaction đọc/ghi đúng. Không hứa bao phủ đường SQL/job không tham gia protocol.

## A.5. Phạm vi tuần tự

| Thao tác | Clan topology lock mặc định đề xuất |
|---|---|
| Tạo/thay/kết thúc Parentage hoạt động | Có |
| Merge/undo có topology | Có |
| Publish import làm đổi graph hoạt động | Có theo publish contract |
| Union mutation liên quan graph invariant | Theo classification đã duyệt; P1 có thể bảo thủ cho vào topology protocol |
| Sửa tên/tiểu sử | Không mặc định; version/row protection phù hợp |
| Tải ảnh/tư liệu | Không mặc định |
| Pan/zoom/collapse | Không |
| Layout/rebuild read-model | Không giữ topology lock dài; dùng version/snapshot protocol |

Không phải mọi write trong clan tuần tự. Thời gian chờ còn phụ thuộc rate và thời gian giữ lock, không chỉ số user online.

## A.6. Merge

Lập replacement map, chọn ID giữ lại, liệt kê refs: Parentage/Union/source/account/Branch/numbering/file. Tính candidate graph, kiểm tra self-loop/cycle/duplicate/cardinality/Union cùng người hai phía và scope/publication.

Không chỉ kiểm tra hai người có phải tổ tiên của nhau. Không tự bỏ cạnh xung đột. Ghi nguyên tử nguồn và redirect theo phạm vi; dẫn xuất rebuild có version. Unmerge cần contract riêng.

## A.7. OCC/Serializable và subtree lock

Version của hai endpoint không tự bảo vệ mọi path trên graph. Kiểm tra candidate ngay trước commit vẫn có race nếu transaction khác thay đổi graph ngoài read/write set được bảo vệ.

Nếu nghiên cứu Serializable, phải có isolation thực tế, validation đầy đủ, retry toàn transaction và test serialization failure. Không hứa tự giải quyết mọi nghiệp vụ chỉ bằng đổi isolation.

Subtree trên DAG có thể chồng lấn/hậu duệ chung; nối giữa vùng lock tạo rủi ro mới. Đổi lock scope cần chứng minh writer coordination, root/membership stability, thứ tự lock và các đường liên vùng. Không cam kết P2 nhất thiết triển khai.

## A.8. Observability và lỗi

Log operation/correlation, tenant nội bộ, loại mutation, version, lock wait/hold, validation duration/work, kết luận, timeout/retry và rebuild. Log không lộ dữ liệu ngoài quyền.

Mã đề xuất: SELF_PARENT, ANCESTRY_CYCLE, VALIDATION_INCOMPLETE, TOPOLOGY_VERSION_CONFLICT, PERMISSION_SCOPE_CHANGED, TOPOLOGY_BUSY_RETRY, MERGE_RELATIONSHIP_CONFLICT, CROSS_TENANT_REFERENCE. Map API thật trước dùng.

---

# PHỤ LỤC B — CHILD ORDERING & NUMBERING

## B.1. Context

Một người có thể là con thứ ba của cha, thứ hai của mẹ và thứ nhất trong nhóm nhận nuôi. Order cần context và nguồn. Biết A lớn hơn B là partial order, không buộc bịa số vị trí toàn nhóm.

## B.2. Sinh đôi/chưa rõ

Nếu biết thứ tự sinh đôi thì ghi nguồn; chưa rõ thì unresolved. Layout có tiebreak kỹ thuật nhưng không hiển thị như con trưởng. Nếu nguồn thứ bậc khác ngày sinh, giữ cả hai và cảnh báo; không tự sửa.

## B.3. Scheme và publication

Scheme có root, tập quan hệ, ordering context, uncertainty rule và version. Mã provisional phải có nhãn. Renumber cần preview và quyền publication phù hợp, không cần quyền sửa hồ sơ mọi người bị mã dẫn xuất tác động.

Lưu assignment snapshot để đối chiếu bản in. Alias cũ có scheme/version; không hứa mã cũ giữ nguyên nghĩa trong scheme mới. UUID ổn định.

---

# PHỤ LỤC C — MULTIPLE OCCURRENCES UX

## C.1. Selection

```text
selection = { person_id, primary_occurrence_id }
focus = { occurrence_id, viewport_context }
```

Primary có trạng thái chọn; occurrence cùng Person có nhận diện phụ. Không auto-pan ngoài viewport. Chỉ báo số vị trí chỉ trong projection được phép thấy. Không bắt buộc nhấp nháy; tôn trọng giảm chuyển động.

## C.2. Collapse

State theo projection/occurrence path, không chỉ person ID. Collapse A không reset A′. Node dùng chung xét đường còn mở. Nếu selection bị thu gọn, chuyển focus điểm collapse hoặc giữ panel kèm thông báo; không mất im lặng.

## C.3. Edit/search/state restore

Sửa Person đồng bộ occurrence; sửa quan hệ cần relationship_ref đúng, không suy từ nét vẽ mơ hồ. Tách collapse/ẩn/sửa/archive. Search ưu tiên occurrence đang thấy/theo tiêu chí xác định, cho phép chuyển vị trí. Data đổi thì phục hồi theo Person/ngữ cảnh hợp lệ, không tái dùng render ID cho người khác.

---

# PHỤ LỤC D — CALENDAR & MEMORIAL POLICY

## D.1. Engine

```text
engine_id / engine_version
calendar_policy_id / policy_version
timezone_assumption / supported_range
input_precision / conversion_status
```

Status: converted, not_evaluable, out_of_range, ambiguous, source_conflict. Kiểm tra license, boundary, conversion round-trip và đối chiếu reference dates. Round-trip nhất quán nội bộ không chứng minh đúng lịch sử. Thiếu năm không dùng năm hiện tại để giả ngày mất.

## D.2. Tháng nhuận

Ví dụ ngày 10 tháng 4 nhuận:

| Policy | Năm có đúng tháng 4 nhuận | Năm không có tháng 4 nhuận |
|---|---|---|
| regular_month | 10/4 thường | 10/4 thường |
| matching_leap_month_else_regular | 10/4 nhuận | 10/4 thường |
| manual_schedule | Ngày được xác nhận | Ngày được xác nhận |

Năm nhuận dương khác tháng nhuận âm; có tháng nhuận khác không phải tháng tương ứng. Default regular_month là PROPOSED. Override sự kiện thắng clan default theo policy đã duyệt và phải hiển thị.

## D.3. Ngày thiếu

Ngày 30 trong tháng chỉ có 29:

- last_day_of_month: ngày 29, default PROPOSED.
- first_day_of_next_month: ngày 1 tháng sau.
- manual_schedule: chờ xác nhận, chưa gửi.

Xử lý chuyển tháng/năm đúng calendar policy. Không tự bật job trước khi D06 và policy nguồn được phê duyệt.

## D.4. Scheduling

Lưu intended occurrence, ngày dương, policy version và lịch gửi. Dedupe theo sự kiện nghiệp vụ/người nhận/kênh, không chỉ ngày chạy job. Policy đổi phải hủy/cập nhật job cũ; lúc gửi kiểm tra consent/quyền lại.

---

# PHỤ LỤC E — FIXTURE VÀ BẰNG CHỨNG

## E.1. Concurrency

- T1 thêm A→B, T2 thêm B→A: không cùng commit thành cycle.
- T1 A→B, T2 B→C, T3 C→A: test vòng nhiều transaction.
- Merge endpoint đồng thời re-parent: version/lock xử lý đúng.
- Import/admin job không bypass protocol.
- Thu hồi quyền khi preview mở: commit không dùng quyền cũ.
- Timeout sau gửi/đứt kết nối: retry không nhân bản operation.
- Job cũ hoàn tất muộn: không ghi đè version mới.

## E.2. Validation budget

- Cycle sâu hơn giới hạn view vẫn phải bị phát hiện hoặc trả incomplete.
- Chạm work/time/depth budget không trả acyclic.
- Lock timeout khác validation timeout trong response/metrics nội bộ.
- Query bị hủy không được tiếp tục commit mutation.
- Retry hết budget không thành vòng lặp vô hạn.

## E.3. Impact authorization

- Đổi mã tạm 500 descendants không đòi quyền profile từng người.
- Cùng thao tác đổi access scope thì áp policy quyền riêng.
- Mã đã published không bị rebuild âm thầm ghi đè.
- Source write đúng quyền nhưng tự nâng quyền qua cây phải bị chặn/escalate.
- Preview count/impact không lộ danh tính ngoài quyền.

## E.4. Order/UX/lịch

Sinh đôi chưa rõ vẫn layout ổn định; partial order giữ nguồn; đổi anchor không đổi mã công bố; nhiều occurrence một Person; collapse local; search theo quyền; tháng nhuận đúng policy; tháng thiếu 30 xử lý đúng; thiếu năm không bịa; policy đổi không gửi hai lịch.

## E.5. Evidence

Lưu commit/build/environment/fixture/steps/results/limitations. Benchmark có phân phối và tải. Migration có đối chiếu trước/sau và phục hồi. Review code, xuất file và test pass một fixture không thay readiness gate.

---

# PHỤ LỤC F — MUTATION CLASSIFICATION & FAST-PATH GATE

## F.1. Phân lớp

| Class | Ví dụ | Bảo vệ nền tảng |
|---|---|---|
| UI-only | Pan, zoom, collapse | Không source mutation |
| Profile/content | Tên, tiểu sử, nguồn | Authorization + row/version và phối hợp merge/archive |
| Topology baseline | Parentage, merge, thao tác graph hoạt động | P1 clan topology protocol |
| Publication | Renumber công bố, phê duyệt bản in | Publication capability/version |
| Authorization | Membership/scope/grant/deny | Security policy và coordination với mutation |
| Derived job | Layout/cache/projection rebuild | Versioned input/output, không ghi source trái quyền |

Một operation có thể thuộc nhiều class; phải áp dụng tổng hợp, không chọn class nhẹ nhất để bỏ kiểm tra.

## F.2. Thêm con mới và nối người cũ

Tạo Person hoàn toàn mới trong cùng operation rồi gắn làm con khác với nối một Person đã tồn tại. “Nút lá” tại preview chỉ là quan sát, không là bằng chứng không thể có race.

P1 giữ topology protocol cho cả hai. Fast path chỉ nghiên cứu khi chứng minh các tiền điều kiện như: Person mới chưa thể được writer khác tham chiếu trước publish; operation không kèm cạnh ngược/merge; rollback nguyên tử; policy/quyền/tenant hợp lệ; coordination với writers baseline không bị phá vỡ.

Không coi danh sách này là đủ để tự bật fast path; cần thiết kế cụ thể và test.

## F.3. Gate trước tối ưu concurrency

1. Có benchmark chứng minh lock contention là điểm nghẽn đáng xử lý.
2. Định nghĩa rõ invariant, read/write set và graph region.
3. Liệt kê tất cả writers, kể cả import/undo/admin và SQL vận hành.
4. Chứng minh phối hợp giữa fast path, baseline và quyền thay đổi.
5. Test race hai/nhiều transaction, liên vùng, retry, deadlock, abort và crash.
6. Có fallback/feature flag/monitoring và kế hoạch rollback.
7. Phê duyệt design record; không chỉ đổi vài dòng lock theo phỏng đoán.

Nếu baseline đạt nhu cầu, có thể giữ clan lock qua P2. Mục tiêu là đúng và đáp ứng tải, không phải bắt buộc sử dụng cơ chế concurrency phức tạp hơn.

---

## Kết thúc

FT-DOCTRINE-SPEC 2.0.2-draft là bản đầy đủ để phản biện và trình phê duyệt. Trọng tâm hiệu chỉnh: phân biệt phạm vi lock, validation incomplete không commit, impact authorization nhiều lớp và tối ưu concurrency dựa trên bằng chứng. Chưa có quyết định APPROVED hoặc thay đổi production phát sinh chỉ từ tài liệu này.
