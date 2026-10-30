# FAMILY TREE DOCTRINE & DOMAIN SPECIFICATION
## Quy chuẩn đề xuất cho hệ thống gia phả số myclan.com.vn

| Thuộc tính | Giá trị |
|---|---|
| Mã tài liệu | FT-DOCTRINE-SPEC |
| Phiên bản | 2.0.1-draft |
| Ngày biên soạn | 2026-10-20 |
| Thay thế về nội dung đề xuất | 2.0.0-draft ngày 2026-10-19 |
| Trạng thái | ĐỀ XUẤT CHỜ DUYỆT |
| Phạm vi | Doctrine, mô hình miền, projection, ghi dữ liệu, quyền, tích hợp và nghiệm thu |
| Đối tượng | Product, UI/UX, Backend, Frontend, Data Engineering, vận hành và AI coding agents |

> Đây là full specification đề xuất, không phải quyết định migration, Prisma schema, bản vá mã nguồn hoặc tuyên bố hệ thống đã production-ready. Các tên thực thể, trường, API và enum là mô hình khái niệm trừ khi được ghi rõ đã đối chiếu implementation. Chưa xác minh schema/repository hiện tại trong lần biên soạn này. Tài liệu không tự thay thế quy chuẩn đang có hiệu lực trước khi được chủ dự án phê duyệt.

---

# PHẦN A — DOCTRINE: NGUYÊN TẮC SẢN PHẨM

## 1. Mục tiêu, phạm vi và mức hiệu lực

FT quản lý cá nhân, quan hệ gia đình và bằng chứng gia phả; tạo các góc nhìn có thể giải thích mà không đánh đồng hình vẽ với dữ liệu gốc.

Mục tiêu:

1. Một người không bị nhân bản chỉ vì xuất hiện ở nhiều vị trí trên canvas.
2. Ngày thiếu, thông tin ước lượng và quan hệ còn tranh luận được biểu diễn trung thực.
3. Thao tác ghi có kiểm tra quyền, preview phù hợp, bảo vệ đồng thời và truy vết.
4. Ngăn truy cập chéo tenant ở API, cache, search, file, export và background job.
5. Ưu tiên thao tác an toàn trên mobile và bảo toàn UI/hành vi ngoài phạm vi sửa.
6. Đơn giản hóa bản đầu bằng giới hạn tính năng, không bằng việc âm thầm làm sai dữ liệu.
7. Tối ưu dựa trên dữ liệu đo và fixture; không suy ra hiệu năng từ số Person đơn lẻ.

### 1.1. Ngôn ngữ quy chuẩn

- PHẢI / KHÔNG ĐƯỢC: bắt buộc khi phần liên quan được phê duyệt cho một bản phát hành.
- NÊN: mặc định khuyến nghị; ngoại lệ phải có lý do.
- CÓ THỂ: tính năng tùy chọn.
- ĐỀ XUẤT: phương án đang được kiến nghị, chưa mặc nhiên được chấp thuận.
- CHỜ CHỐT: chưa được phép hard-code như chính sách cố định.

Trong phiên bản draft, các mặc định dưới đây vẫn là đề xuất. Việc một quyết định được mô tả chi tiết không có nghĩa chủ dự án đã duyệt nó.

### 1.2. Không thuộc cam kết của tài liệu

- Không xác nhận tên bảng, endpoint hay enum đang tồn tại.
- Không cam kết ngưỡng hiệu năng, tương thích GEDCOM đầy đủ hay độ chính xác lịch sử của engine lịch chưa được kiểm chứng.
- Không đặt ngưỡng tuổi pháp lý hoặc đưa ra kết luận pháp lý về quyền riêng tư.
- Không cho phép AI tự chạy migration, reset database, deploy hay ghi repository.
- Không coi bộ fixture là bằng chứng đã chạy kiểm thử thành công.

## 2. Nguyên tắc nền tảng

### 2.1. Tách người, quan hệ và hình vẽ

Person là cá nhân; Union và Parentage là bối cảnh/quan hệ; RenderNode và RenderEdge là dữ liệu biểu diễn. Nút nối hôn nhân không phải Person. Pan, zoom, chọn, collapse và đổi layout không được tự sửa quan hệ nguồn.

### 2.2. Định danh ổn định

UUID của Person không đổi khi đổi tên, sửa cha mẹ, đổi nhánh hoặc đổi anchor. Mã vị trí có ngữ cảnh; không dùng làm khóa ngoại chính hoặc định danh tuyệt đối.

### 2.3. Không tạo sự chắc chắn giả

Không tự thêm ngày 01/01 khi chỉ biết năm; không tạo người phối ngẫu giả cho đẹp sơ đồ; không suy ra con sinh học chỉ từ hôn nhân; không đồng nhất được duyệt nội bộ với sự thật lịch sử tuyệt đối.

### 2.4. Backend là nơi kiểm tra cuối cùng

Frontend cung cấp hướng dẫn và preview; backend kiểm tra lại tenant, quyền, phiên bản và bất biến tại thời điểm ghi. Che trường trên UI không thay kiểm soát payload.

### 2.5. Bảo toàn hệ thống hiện hữu

Ưu tiên patch nhỏ và mapping dữ liệu có kiểm soát. Không viết lại toàn ứng dụng hoặc tái tạo database chỉ để đổi tên thực thể theo tài liệu. Phân biệt dữ liệu gốc, dữ liệu dẫn xuất và cấu hình vận hành.

---

# PHẦN B — DOMAIN SPECIFICATION: MÔ HÌNH MIỀN

## 3. Thuật ngữ và thực thể

| Khái niệm | Vai trò | Không đồng nhất với |
|---|---|---|
| Clan | Không gian dữ liệu và chính sách dòng họ | Toàn nền tảng |
| Person | Cá nhân trong phạm vi quản lý | UserAccount hoặc RenderNode |
| UserAccount | Chủ thể xác thực | Hồ sơ gia phả |
| PersonAccountLink | Liên kết được xác minh | Quyền tự sửa mọi quan hệ |
| Union | Bối cảnh kết đôi/gia đình | Khẳng định kết hôn hay sinh học mặc định |
| Parentage | Quan hệ một cha/mẹ tới một con | Cạnh render tùy ý |
| Source | Tư liệu hoặc người cung cấp có thể tham chiếu | Chứng nhận tuyệt đối đúng |
| Claim | Phát biểu có trạng thái và nguồn | Giá trị đã chắc chắn |
| Branch | Phân nhóm hoặc phạm vi quản trị được định nghĩa | Subtree đang mở trên canvas |
| OrderingContext | Phạm vi xác định thứ tự con | Thuộc tính toàn cục của Person |
| NumberingScheme | Hệ quy chiếu cấp mã vị trí | UUID cá nhân |
| Projection | Phép chọn và biểu diễn đồ thị | Bản sao dữ liệu nguồn |
| Occurrence | Một lần xuất hiện theo một ngữ cảnh | Cá nhân mới |

Thiết kế vật lý phải đối chiếu schema thực tế; không bắt buộc mỗi khái niệm là một bảng.

## 4. Person, người chưa rõ danh tính và tài khoản

### 4.1. Thuộc tính khái niệm

```text
Person
- id: UUID
- clan_id
- display_name
- names[]
- gender_or_sex_fields: ngữ nghĩa phải được định nghĩa riêng
- life_status: living | deceased | missing | unknown
- identity_status: identified | partially_known | unidentified
- review_status: draft | reviewed | disputed
- birth_event_ref?
- death_event_ref?
- record_version
- created_at / updated_at
```

Danh tính, tình trạng sống, mức duyệt và liên kết tài khoản là các trục độc lập. Không gộp vào một cờ active. Không suy ra giới từ vai trò cha/mẹ, tên gọi hoặc vị trí phối ngẫu.

### 4.2. Placeholder

- Có bằng chứng một người tồn tại nhưng chưa rõ tên: có thể tạo Person chưa rõ danh tính, kèm nguồn/lý do.
- Nút “Thêm cha/mẹ”, điểm nối cạnh hoặc chỗ trống layout: chỉ là UI, không lưu như Person.
- Khi xác định được người, cập nhật hoặc merge có kiểm soát; không để bản ghi placeholder mồ côi.

### 4.3. PersonAccountLink

Liên kết cần xác minh, trạng thái, người duyệt nếu áp dụng và cơ chế thu hồi. Có liên kết không tự cấp quyền sửa người thân. Chính sách đại diện, người giám hộ và số Person một tài khoản có thể quản lý là CHỜ CHỐT.

## 5. Union, Parentage và Claim

### 5.1. Union

```text
Union
- id / clan_id
- union_type
- participants[]
- events[]
- review_status
- sources[]
- record_version
```

ĐỀ XUẤT V1:

- Mỗi Union có tối đa hai Person đã biết; cho phép chưa rõ một bên nếu có căn cứ về bối cảnh gia đình.
- Một Person có thể tham gia nhiều Union.
- Không bắt buộc các Union có ngày đầy đủ hoặc không chồng lấn.
- Không suy ra hôn nhân pháp lý từ việc có Union.
- Không cấm lưu quan hệ chỉ vì giới của các bên; quyền nhập, thuật ngữ UI và tương thích export là các quyết định riêng.
- Mô hình Union trên hai người là ngoài phạm vi V1; dữ liệu import không biểu diễn được phải được báo cáo, không âm thầm bỏ người.

Giới hạn số người trong một Union khác với giới hạn số Union đồng thời của một Person. Dữ liệu lịch sử chồng lấn được ghi nhận/cảnh báo theo nguồn, không mặc định bị chặn vì layout.

### 5.2. Vai trò lịch sử và thứ tự kết đôi

Chính thất, thứ thất, kế thất và nhãn tương tự là thông tin có chủ thể, thời kỳ và nguồn. Không suy ra từ giới hoặc thứ tự bản ghi. Thứ tự kết đôi theo từng Person có thể khác nhau; không mặc định một marriage_order dùng chung cho cả cặp.

Sự kiện có thể gồm kết hôn, ly hôn, chấm dứt, tái hợp và ghi nhận khác. Một bên qua đời không được chuyển thành sự kiện ly hôn. Chính sách tái hợp dùng Union cũ hay mới là CHỜ CHỐT trước unique constraint.

### 5.3. Parentage

```text
Parentage
- id / clan_id
- parent_person_id / child_person_id
- relationship_type: biological | adoptive | foster | other
- relationship_role?
- effective_period?
- review_status / certainty
- source_refs[]
- record_version
```

Danh mục phải map dữ liệu hiện tại trước triển khai.

Quy tắc:

1. Không dùng cả type và cờ mang cùng sự thật như `is_adopted` nếu không có lý do tương thích đã ghi rõ.
2. Con trong một Union không tự là con sinh học của mọi người tham gia.
3. “Con riêng của phối ngẫu” không tự tạo Parentage với cha/mẹ kế.
4. Một người có thể có quan hệ sinh học và nhận nuôi khác nhau.
5. Không dùng giới của Person như bằng chứng duy nhất về vai trò quan hệ.
6. Giới hạn quan hệ sinh học được chọn phải định nghĩa theo ngữ nghĩa, không theo tổng số cạnh cha mẹ mọi loại.

### 5.4. Claim và đồ thị được chọn

Các trạng thái đề xuất: proposed, accepted, disputed, rejected, superseded. Chấp nhận nội bộ không đồng nghĩa chắc chắn lịch sử. Không xóa claim cũ chỉ vì chọn giả thuyết khác.

Projection mặc định chỉ dùng tập quan hệ được chọn theo chính sách. Chế độ nghiên cứu có thể so sánh giả thuyết nhưng phải phân biệt trực quan; không trộn thành một đồ thị chuẩn duy nhất.

## 6. Đồ thị, đời, thứ tự con và mã gia phả

### 6.1. Các tập quan hệ độc lập

- Biological ancestry: Parentage sinh học được chọn.
- Family ancestry: quan hệ cha mẹ được công nhận theo cấu hình, có phân biệt sinh học/nhận nuôi.
- Lineage graph: quan hệ dùng cho truyền thừa theo chính sách clan đã duyệt.
- Display graph: dữ liệu sau chọn phạm vi, quyền và projection.

Không mặc định biological + adoptive cho mọi phép tính. Con nuôi có thể thuộc truyền thừa của clan mà không trở thành khẳng định tổ tiên sinh học.

Mỗi tập cạnh phải có policy/version. Spouse/Union không được gộp vào cùng phép kiểm tra DAG với cạnh tổ tiên. Các loại Parentage làm phát sinh ràng buộc chu trình nào cần được chốt; không mặc định foster đồng nghĩa tổ tiên.

### 6.2. Ba nghĩa về đời

1. declared_generation: đời được nguồn hoặc clan ghi nhận.
2. relative_depth: khoảng cách theo anchor và đường đi trong projection.
3. layout_rank: hàng bố trí của một occurrence.

Nếu tính đời chuẩn, phải có root/scheme, tập quan hệ, quy tắc nhiều đường đi và xử lý mâu thuẫn. Đổi anchor không ghi đè đời đã xác nhận.

### 6.3. Thứ tự con theo ngữ cảnh

Không đặt duy nhất một birth_order_index toàn cục trên Person.

```text
ChildOrderAssignment
- ordering_context_id
- child_person_id
- order_index?
- order_status: known | partial | unknown | disputed
- source_ref?
- manually_confirmed
```

OrderingContext phải nêu rõ nhóm con của một phụ huynh, gia đình hay numbering scheme. Phân biệt thứ bậc được nguồn xác nhận, thứ tự hiển thị và thứ tự đã công bố trong mã.

Sinh đôi, thiếu ngày sinh hoặc chỉ biết anh/em phải được hỗ trợ. Không tự dùng created_at làm thứ bậc sinh. Nếu cần tiebreak cho layout, đánh dấu là kỹ thuật và không trình bày thành con trưởng/con thứ. Chi tiết tại Phụ lục B.

### 6.4. Mã vị trí kiểu d’Aboville sửa đổi

Tách:

- Mã tham chiếu theo một root/scheme đã công bố của clan.
- Mã đường đi tạm thời theo góc nhìn.

```text
PositionAssignment
- numbering_scheme_id / root_person_id
- path_key / person_id / position_code
- scheme_version / validity
- publication_state?
```

Quy tắc:

- UUID là định danh chính; position_code không là khóa ngoại chính.
- Mã là dữ liệu dẫn xuất nhưng có thể được materialize/version để tra cứu hoặc xuất bản ổn định.
- Một Person có thể có nhiều mã theo đường đi/scheme.
- Đổi anchor không tự đánh lại mã tham chiếu đã công bố.
- Khi sửa quan hệ/thứ tự, preview mã bị thay đổi; không âm thầm sửa sách hoặc bản export cũ.
- Alias mã cũ cần scheme/version; không hứa mọi mã cũ luôn ánh xạ một người.
- Nếu chưa rõ thứ bậc, không công bố mã như thứ bậc lịch sử chắc chắn.

## 7. Ngày, lịch và sự kiện

### 7.1. Giá trị ngày khái niệm

```text
GenealogicalDate
- calendar
- year? / month? / day?
- is_leap_month?
- precision: day | month | year | unknown
- qualifier: exact | about | before | after | between | unknown
- range_end?
- original_text?
- source_ref?
- conversion_metadata?
```

Implementation phải quy định tổ hợp hợp lệ và phân biệt khoảng ngày có thể xảy ra với khoảng một trạng thái kéo dài.

### 7.2. Dữ liệu gốc và quy đổi

- Giữ lịch gốc và độ chính xác.
- Không ép mọi sự kiện thành Unix timestamp.
- Timestamp hệ thống không thay cho ngày lịch sử thiếu giờ/ngày/tháng.
- Giá trị quy đổi lưu engine/version, giả định múi giờ, phạm vi và trạng thái.
- Thiếu năm không được quy đổi thành ngày dương chính xác giả.
- Mâu thuẫn âm/dương giữ lại nguồn và cảnh báo, không chọn theo lần nhập cuối.

### 7.3. Engine lịch

ĐỀ XUẤT khảo sát implementation dựa trên thuật toán Hồ Ngọc Đức; chưa chốt package hoặc cam kết chuẩn xác chỉ từ tên thuật toán.

Phải xác minh: license, phiên bản, phạm vi năm, múi giờ, test vector và hành vi ngoài miền hỗ trợ. Phân biệt lịch Việt Nam hiện đại tính toán với lịch ghi nhận trong tư liệu lịch sử. Không mặc định UTC+7 tái hiện đúng mọi lịch lịch sử.

Tính nhắc giỗ hiện tại dùng calendar policy được chọn; không ghi đè ngày lịch sử gốc. Chi tiết tại Phụ lục D.

### 7.4. Ngày giỗ và chính sách lặp

```text
MemorialRule
- person_id
- calendar / month / day
- original_is_leap_month
- leap_month_policy
- missing_day_policy
- notification_offsets
- recipient_policy
- policy_version
```

ĐỀ XUẤT mặc định chờ duyệt: tháng thường tương ứng, nhưng cho phép chính sách khác theo clan hoặc từng sự kiện. Không khẳng định một tập quán áp dụng phổ quát.

Quy tắc ngày 30 trong tháng chỉ có 29 ngày cần lựa chọn riêng. Thiếu lựa chọn không được âm thầm dịch ngày. Cấu hình nghi lễ/giờ hoàng đạo có thể là metadata văn hóa, không là trường bắt buộc.

## 8. Bất biến, cảnh báo và ngoại lệ

### 8.1. Lỗi chặn ghi

- Self-parent và chu trình trong tập đồ thị phải không chu trình theo policy.
- Liên kết trái tenant, tham chiếu không hợp lệ hoặc bản ghi không còn khả dụng.
- Thiếu quyền, version conflict hoặc scope đã thay đổi mà chưa preview lại.
- Quan hệ trùng theo khóa nghiệp vụ đã phê duyệt.
- Ghi một trạng thái không hợp lệ của mô hình miền.

Không bypass các lỗi này bằng nút xác nhận cảnh báo.

### 8.2. Cảnh báo thời gian

Kết quả gồm valid, inconsistent, uncertain, not_evaluable. So sánh phải xét precision và miền thời gian; không tự điền ngày giả.

Ngưỡng tuổi sinh con, tuổi thọ, thời điểm sau mất và kết hôn là cấu hình có phiên bản. Công thức kiểm tra ngưỡng hai người, khi đủ dữ liệu:

```text
marriage_date >= max(birth_A + threshold_A,
                     birth_B + threshold_B)
```

Đây không phải quy tắc pháp lý. Với dữ liệu mâu thuẫn nghiêm trọng, có thể giữ tư liệu như claim chờ xử lý thay vì tự đưa vào dữ liệu chuẩn. Ngày sinh và mất cùng ngày cần chính sách theo độ chính xác, không tự suy ra thứ tự đến giây.

### 8.3. Xác nhận ngoại lệ

Lưu mã cảnh báo, rule version, người xác nhận, lý do, nguồn và phạm vi. Thay đổi quy tắc không làm mất lịch sử đã xác nhận; cần khả năng rà soát lại nếu phù hợp.

### 8.4. Đồng thời

Preview không phải khóa. Mọi mutation phải kiểm tra lại trên trạng thái được bảo vệ tại commit. Quy trình lock, reachability, merge và import tại Phụ lục A.

## 9. Chi, nhánh và truyền thừa

Branch có tiêu chí và phạm vi độc lập với collapse/viewport. Cần xác định root/tiêu chí, quan hệ phân cấp, membership động/cố định, người thuộc nhiều nhánh và thay đổi sau sửa Parentage.

Chi trưởng, thứ bậc truyền thừa và danh vị do clan xác nhận theo nguồn. Hệ thống có thể gợi ý nhưng không tự quyết định từ giới, ngày sinh hoặc thời điểm nhập. Quy tắc truyền thừa không được dùng để xóa dữ liệu về phụ nữ, con gái, con nuôi hoặc quan hệ hợp lệ khác.

---

# PHẦN C — PROJECTION, CANVAS VÀ THAO TÁC GHI

## 10. Hợp đồng projection

Các góc nhìn: ancestors, descendants, hourglass và clan overview. Overview không giả định có đúng một thủy tổ hoặc tất cả thành phần đã nối nhau.

Đầu vào khái niệm:

```text
clan_id / anchor_person_id? / root_set?
view_mode / relationship_policy
max_depth / people_budget / edge_budget / occurrence_budget
expansion_state / privacy_context
projection_version / data_version
```

Đầu ra:

```text
RenderNode
- render_node_id
- person_id? / union_id?
- occurrence_context
- layout_rank
- permitted_display_fields

RenderEdge
- render_edge_id
- source_render_node_id / target_render_node_id
- relationship_refs[]
- visual_type

ProjectionMetadata
- data_version / policy_versions
- truncated / truncation_reason?
- expandable_contexts[]
```

Một Person có thể có nhiều occurrence; render ID không thay person ID. Cần thuật toán ID occurrence có tính ổn định trong phạm vi thích hợp; không dùng ID ngẫu nhiên mới mỗi lần render khiến mất selection/collapse ngoài ý muốn.

Ngân sách phải được áp dụng cả khi tạo occurrence: dữ liệu DAG ít Person vẫn có thể sinh nhiều đường đi. Khi cắt kết quả, trả trạng thái rõ ràng; không trình bày như toàn bộ cây đã hiển thị.

## 11. Layout và UX

### 11.1. Layout

Ưu tiên không chồng node và không cho cạnh xuyên nội dung node không liên quan. Không hứa mọi đồ thị không có cạnh giao nhau.

Căn hàng theo layout_rank và policy, không theo một generation_level toàn cục chưa định nghĩa. Xác định tâm/mép node, kích thước đo và padding trước công thức spacing. Cùng dữ liệu/cấu hình/kích thước nên cho bố trí xác định.

Mở nhánh nên hạn chế dịch vùng không liên quan và giữ anchor. Không tính lại layout chỉ vì pan/zoom hoặc mở panel không đổi kích thước node. Worker/layout nền phải loại kết quả cũ theo request/version.

### 11.2. Điều hướng và mobile

Zoom/pan có cấu hình theo thiết bị; 10%–500% chỉ là mức khảo sát, chưa phải nghiệm thu. Không phụ thuộc double-click để mở hồ sơ. Phân biệt tap, pan và sửa dữ liệu. Có phương thức điều hướng thay thế, không chỉ truyền trạng thái bằng màu.

Mobile mặc định dùng menu hành động → chọn loại sửa → chọn đối tượng → preview → xác nhận. Drag & drop chỉ là bổ sung và luôn khởi tạo cùng quy trình nghiệp vụ; không ghi ngay khi thả.

### 11.3. Nhiều occurrence

- Chọn một occurrence là chọn Person và một vị trí focus cụ thể.
- Occurrence chính có trạng thái chọn; occurrence cùng Person có nhận diện phụ.
- Không tự pan sang occurrence ngoài màn hình; có chỉ báo/chuyển vị trí chủ động.
- Không mặc định nhấp nháy tất cả occurrence.
- Sửa thông tin Person đồng bộ mọi occurrence đang hiển thị trong quyền được phép.
- Collapse áp dụng theo occurrence/ngữ cảnh, không mặc định toàn Person.

Contract chi tiết tại Phụ lục C.

### 11.4. Search và collapse

Search áp dụng quyền ngay từ kết quả/gợi ý. Không lộ trường ẩn qua số liệu hoặc index. Nếu kết quả ở nhánh thu gọn hoặc ngoài độ sâu, cho biết và mở phần cần thiết sau hành động phù hợp. Collapse không sửa quan hệ nguồn.

## 12. Sửa quan hệ và chuyển nhánh

### 12.1. Phân loại hành động

Phân biệt thay cha/mẹ sinh học, thêm nhận nuôi/chăm sóc, sửa Union, đổi phân nhóm nhánh và đổi bố trí. Không dùng một lệnh “chuyển nhánh” để che nhiều nghĩa khác nhau.

### 12.2. Quy trình

```text
Chọn thao tác
→ Backend tính impact và kiểm tra sơ bộ
→ Preview trước/sau, cảnh báo và phạm vi quyền
→ Người dùng xác nhận
→ Backend lấy cơ chế bảo vệ đồng thời
→ Đọc lại version, quyền và đồ thị liên quan
→ Kiểm tra bất biến trên trạng thái ứng viên
→ Ghi transaction + audit + trạng thái rebuild
→ Trả kết quả hoặc conflict
```

Preview nêu cạnh thêm/thay/kết thúc hiệu lực, dữ liệu nguồn thực sự thay đổi, mã/đời/quyền dẫn xuất bị ảnh hưởng và hậu duệ chung. Không làm lộ chi tiết ngoài quyền.

### 12.3. Version và dữ liệu dẫn xuất

Token preview ràng buộc actor, tenant, thao tác, target, phiên bản liên quan và thời hạn theo thiết kế. Token không thay authorization. Khi version/quyền đã đổi, yêu cầu preview lại.

Ghi dữ liệu nguồn liên quan phải nguyên tử. Rebuild lớn có thể bất đồng bộ nhưng cần status, retry, idempotency và chính sách đọc snapshot cũ/mới rõ ràng; không trả một nửa kết quả như đã nhất quán.

### 12.4. Quyền và impact

Kiểm tra quyền theo action, endpoint và impact set. Không chỉ hỏi người dùng có quyền trên “hai nhánh” hay không. Người chưa thuộc nhánh, nhiều nhánh và thay đổi làm tăng quyền phải được xử lý riêng. Nếu vượt phạm vi editor, chuyển ClanAdmin hoặc quy trình phê duyệt, không tự mở rộng quyền.

## 13. Trùng lặp, merge, archive và xóa

### 13.1. Phát hiện trùng

Score chỉ là gợi ý nếu chưa hiệu chuẩn; không mặc định 80% là xác suất đúng. Dùng tên/biến thể, ngày theo khoảng, cha mẹ, phối ngẫu, địa điểm và nguồn, kèm lý do. Không tự đối soát chéo tenant.

### 13.2. Merge

Preview người giữ ID, trường xung đột, chuyển hướng tham chiếu, tài khoản, nguồn, Union, nhánh và mã. Kiểm tra self-parent, chu trình, duplicate edge, Union cùng người hai phía và mâu thuẫn quyền trên đồ thị sau merge.

Không xóa cạnh gây lỗi một cách âm thầm. Nếu cần xử lý claim/quan hệ tranh luận, yêu cầu quyết định tường minh và audit. Không tự merge chỉ từ similarity score. Không cam kết unmerge hoàn hảo nếu chưa có contract và dữ liệu phục hồi.

### 13.3. Archive/xóa

Không cascade xóa người thân. Phân biệt ẩn occurrence, xóa/kết thúc quan hệ, archive Person và xóa cứng. Soft-delete không thay mọi chính sách xóa dữ liệu. Tham chiếu, file, audit và yêu cầu lưu giữ cần chính sách riêng.

---

# PHẦN D — SECURITY, AUDIT VÀ TÍCH HỢP

## 14. Multi-tenancy, quyền và privacy

### 14.1. Tenant isolation đề xuất P0–P1

Mỗi Person thuộc một clan; chưa mở liên kết hoặc merge cross-clan. Cùng người được ghi ở hai clan hiện là hai bản ghi độc lập trong hai miền quản lý; không tự liên kết từ tên hoặc tài khoản. Đây là giới hạn phiên bản, không cam kết vĩnh viễn.

Mọi truy vấn/mutation/job/search/cache/file/export kiểm tra tenant từ ngữ cảnh tin cậy, không chỉ từ clan_id client gửi. Cross-tenant identity là quyết định kiến trúc riêng về sau.

### 14.2. Vai trò khái niệm

| Vai trò | Phạm vi |
|---|---|
| PlatformAdmin | Vận hành; không mặc định đọc toàn bộ dữ liệu gia phả |
| ClanAdmin | Quyền được cấp trong một clan |
| BranchEditor | Sửa trong scope đã định nghĩa |
| Member | Xem/đề xuất theo policy |
| Guest | Chỉ nội dung đã công bố |

Phải map với vai trò hiện hữu, không tự thêm role production.

### 14.3. Allow, deny và nhánh chồng lấn

ĐỀ XUẤT mô hình quyết định: explicit_allow, explicit_deny, not_applicable. Không có allow khác với một explicit_deny trên mọi nhánh. Sau tổng hợp theo policy: explicit deny phù hợp thắng allow; nếu không có allow hợp lệ thì từ chối mặc định.

Phạm vi deny, kế thừa, ngoại lệ và quyền quản trị phải được chốt/test. Không dùng ngoại lệ ngầm cho admin. Quyền sửa topology là capability riêng, không mặc định suy ra từ quyền sửa tiểu sử.

Không yêu cầu quyền sửa mọi hậu duệ chỉ vì có dữ liệu dẫn xuất ảnh hưởng. Phải phân biệt đối tượng bị ghi trực tiếp, đối tượng đổi quyền và đối tượng chỉ đổi layout/mã.

### 14.4. Privacy theo trường

Không mặc định người đã mất công khai đầy đủ. Ngày sinh chi tiết, liên hệ, vị trí, mộ, nguồn, tranh luận và hồ sơ gia đình có policy riêng. “Gần 3 đời” không được cấp quyền cho đến khi định nghĩa cách đếm và loại quan hệ.

Áp dụng ở API, export, search, notification và audit viewer. Không gửi dữ liệu nhạy cảm rồi che bằng CSS. Consent, đại diện trẻ vị thành niên, rút chia sẻ và yêu cầu xóa cần review chính sách riêng.

### 14.5. Cache và file

Cache dữ liệu đã lọc quyền cần tenant, data version và scope/policy version thích hợp. Thu hồi quyền phải ngăn dùng cache cũ. File export, media và link tải cần kiểm soát truy cập/lưu giữ; không công khai mặc định. Kiểm tra quyền khi tải hoặc áp dụng chính sách phân phối snapshot đã duyệt.

## 15. Audit, undo và restore

### 15.1. Audit

```text
operation_id / correlation_id / clan_id
actor_id / actor_context
action_type / entity_refs
before_after_or_diff
expected_versions / resulting_versions
reason / source_refs
rule_versions / warning_acknowledgements
occurred_at
```

Không lưu password/token hoặc dữ liệu nhạy cảm dư thừa. Phân quyền đọc, retention và tính toàn vẹn cần thiết kế. Không cho người sửa dữ liệu thường tự sửa log liên quan.

### 15.2. Undo

Undo là mutation mới tham chiếu mutation gốc. Kiểm tra quyền, bất biến và thay đổi sau đó. Nếu xung đột, trả lỗi/đề xuất chỉnh sửa thay vì ghi đè mù toàn bản ghi.

### 15.3. Restore

Restore snapshot là quy trình vận hành riêng: phạm vi tenant, snapshot, preview mất dữ liệu, bản bảo vệ trước restore, cửa sổ vận hành, file/index/job và kiểm thử. RPO/RTO CHỜ CHỐT. Audit không đồng nghĩa phục hồi về mọi thời điểm.

## 16. Nhắc giỗ, mộ phần, xuất bản và GEDCOM

### 16.1. Nhắc giỗ

Tính ngày theo policy version. Job có khóa chống trùng phù hợp sự kiện/người nhận/kênh/lần nhắc, kiểm tra quyền/consent trước gửi, retry và hủy nhận. Không gửi mặc định toàn nhánh hoặc đưa thông tin bị ẩn vào notification.

### 16.2. Mộ phần

Lưu vị trí và lịch sử cải táng nếu cần; không giới hạn cứng một vị trí suốt đời. Altitude không bắt buộc. Ghi độ chính xác tọa độ và mức công khai. GIS nâng cao không là điều kiện để lưu người đã mất.

### 16.3. SVG/PDF và sách

Chốt snapshot, filter, quyền, khổ trang, đơn vị, font tiếng Việt, tỷ lệ và phân trang. Vector nghiệm thu theo hình học/nét/font; DPI áp dụng riêng cho raster khi cần. Báo nội dung bị lược bỏ mà không tiết lộ chính nội dung đó. Export lớn có job, status và retention.

### 16.4. GEDCOM

Một specification tương tác chung với hai profile độc lập: 5.5.1 và 7.0. Dùng mô hình trung gian nhưng reader/writer/validator riêng. Ghi bản đặc tả/hiệu chỉnh làm căn cứ.

Mapping matrix phải ghi mức bảo toàn cho người, tên, ngày thiếu/âm lịch, Parentage/Union, nguồn, media và dữ liệu riêng. Không mặc định Union ↔ FAM hoặc Parentage ↔ PEDI bảo toàn một-một mọi ngữ nghĩa.

Import: giới hạn file và dung lượng giải nén → parse/staging → resolve reference → validation → preview → xác nhận → publish có kiểm soát. Không tạo dữ liệu hoạt động nửa chừng rồi trình bày như hoàn tất. Import phải tuân thủ cùng bảo vệ topology.

Export: snapshot/phạm vi quyền → mô hình trung gian → writer profile → validation → báo cáo mất dữ liệu → file/gói media. Nên xử lý theo batch/stream và background job khi cần.

Không xuất credential, ACL nội bộ, session hoặc cấu hình vận hành trong GEDCOM mặc định. Không coi GEDCOM là backup toàn ứng dụng. Extension/sidecar có contract riêng; không hứa phần mềm khác hiểu chúng. Kiểm thử round-trip phải chỉ rõ trường bảo toàn và mất mát.

---

# PHẦN E — DELIVERY SPECIFICATION

## 17. Phân giai đoạn

| Giai đoạn | Phạm vi | Điều kiện ra |
|---|---|---|
| P0 | Map schema, Person/quan hệ, ngày, graph policy, ordering/numbering, tenant/privacy | Quyết định miền và fixture được duyệt |
| P1 | Mutation contract, preview, lock/version, audit, merge trong phạm vi | Test quyền, transaction và concurrency đạt |
| P2 | Projection, occurrence UX, layout, mobile, query/cache/performance | Đo trên thiết bị và dataset mục tiêu |
| P3 | Nhắc giỗ, GIS, export, GEDCOM, sách | Contract và nghiệm thu riêng |

Đây là thứ tự phụ thuộc, không phải lịch/ước lượng nhân lực. Tái sử dụng chức năng hiện hữu nếu phù hợp; không bắt buộc viết lại.

## 18. Fixture, benchmark và tiêu chí nghiệm thu

### 18.1. Fixture chức năng

1. Gia đình đơn giản đủ nguồn/ngày.
2. Một phụ huynh chưa rõ, không tạo người giả.
3. Nhiều Union, mốc thiếu/chồng lấn.
4. Quan hệ sinh học và nhận nuôi cùng Person.
5. Hậu duệ chung, nhiều đường đi, nhiều occurrence.
6. Nhiều root và thành phần chưa nối.
7. Ngày chỉ có năm, khoảng, âm lịch thiếu năm và nguồn mâu thuẫn.
8. Quan hệ tranh luận và giả thuyết được chọn.
9. Sửa quan hệ đổi mã, branch và scope quyền.
10. Đồng thời tạo chu trình qua hai hoặc nhiều mutation.
11. Cross-tenant access qua API/search/cache/file/export/job.
12. Merge sinh self-parent, chu trình, Union bất thường hoặc duplicate edge.
13. Undo khi có thay đổi mới hợp lệ.
14. Thứ tự con chưa rõ, sinh đôi, thứ bậc khác ngày sinh và mã đã xuất bản.
15. Giỗ tháng nhuận và ngày 30 trong tháng thiếu.
16. Worker/job trả kết quả cũ sau khi đổi anchor/version.

### 18.2. Tiêu chí chức năng

- Đổi góc nhìn không ghi dữ liệu quan hệ.
- Không tạo chu trình qua mutation, merge, import và các lịch đồng thời được kiểm thử.
- Preview cũ không ghi đè trạng thái mới.
- Ngày thiếu không bị nâng thành ngày chính xác giả.
- Occurrence không trở thành Person mới; chọn/collapse tuân thủ Phụ lục C.
- Quyền áp dụng ở mọi kênh; không tự nâng quyền qua sửa cây.
- Có audit cho mutation thành công và trạng thái retry/rebuild rõ ràng.
- Mã tham chiếu đã công bố không tự đổi vì anchor hoặc tiebreak kỹ thuật.

### 18.3. Benchmark

500, 5.000 và 20.000+ Person là tập quy mô thử đề xuất, không phải cam kết render cùng lúc hoặc ngưỡng đạt.

Ghi số cạnh, độ sâu, hình dạng đồ thị, đường đi/occurrence, concurrency, thiết bị, trình duyệt, mạng và cold/warm cache. Đo riêng query, projection, layout, render, bộ nhớ, lock wait, thời gian mutation và job.

Ngưỡng latency/timeout và giới hạn payload/node CHỜ CHỐT theo baseline. Không tăng timeout vô hạn để che lỗi. Đạt test chức năng không tự chứng minh hiệu năng; đạt benchmark không tự chứng minh không có race.

### 18.4. Readiness gate

Chỉ gọi một phạm vi production-ready sau khi: quyết định được duyệt, mapping schema hoàn tất, quyền và concurrency được test, migration rehearsal đạt nếu có migration, backup/restore được kiểm chứng theo phạm vi, benchmark đạt và có monitoring/rollback vận hành.

## 19. Quy trình áp dụng và AI coding agents

### 19.1. Triển khai hệ thống hiện hữu

1. Chốt repo/branch/commit/phạm vi.
2. Đọc schema, API, UI và migration history.
3. Map hiện tại → đề xuất, ghi phần đã phù hợp và xung đột.
4. Chốt quyết định, không tự lấp chỗ trống.
5. Patch nhỏ, giữ UI/hành vi không liên quan.
6. Nếu migration: báo impact, backfill, lock, backup và phục hồi.
7. Rehearsal trên staging/dữ liệu đại diện; đối chiếu số người/quan hệ trước sau.
8. Chạy test và báo đúng cấp kiểm chứng.
9. Production chỉ sau phê duyệt và readiness gate tương ứng.

Không sửa/xóa migration đã áp dụng hoặc reset production để làm sạch lịch sử. Ngoại lệ có quy trình vận hành được duyệt riêng.

### 19.2. Contract cho AI

- Draft không tự cao hơn quy chuẩn đã duyệt; phải báo xung đột.
- Đọc file thật, nêu file đã đọc và phần chưa xác minh.
- Không phát minh schema/endpoint từ ví dụ khái niệm.
- Không tự migration/reset/deploy/ghi repository.
- Ưu tiên patch tối thiểu, trình bày diff và rủi ro.
- Khi xuất source, cung cấp full file đúng nguồn đã đọc, đường dẫn/version và thay đổi.
- Không nói đã test nếu chưa thực thi test tương ứng.
- Tạo tài liệu không được báo như đã triển khai kiến trúc hoặc phê duyệt policy.

## 20. Decision register

Tất cả hướng xử lý dưới đây là ĐỀ XUẤT, chưa được phê duyệt chỉ bởi việc xuất bản draft.

| ID | Vấn đề | Hướng đề xuất | Gate |
|---|---|---|---|
| D01 | Person/cross-clan | P0–P1 strict isolation; chưa liên kết/merge cross-clan | P0 |
| D02 | Union | Tối đa hai Person mỗi Union V1; một người nhiều Union; không cấm overlap/giới để né layout | P0 |
| D03 | Graph policy | Biological, family và lineage tách biệt; loại cạnh/version rõ ràng | P0 |
| D04 | Đời/mã/order | Tách đời, ordering context, mã tham chiếu và mã view; công bố theo scheme/version | P0 |
| D05 | Occurrence UX | Primary selection, nhận diện phụ, local collapse, không auto-pan | P2 trước UI |
| D06 | Lịch/ngày giỗ | Engine có version/test; policy tháng nhuận và ngày thiếu theo cấu hình | P0 mô hình; P3 chức năng |
| D07 | Cảnh báo | Ngưỡng có version; xác nhận theo quyền, không bỏ qua bất biến | P0 |
| D08 | Branch/RBAC | Explicit deny tách absence; topology capability và impact-based authorization | P0–P1 |
| D09 | Privacy | Quyền theo trường/kênh; không mặc định người mất công khai | P0 |
| D10 | Concurrency | Khảo sát transaction-level clan topology lock, đọc/validate sau lock; rebuild có version | P1 |
| D11 | Undo/restore | Hai contract riêng; retention/RPO/RTO chờ duyệt | P1 và vận hành |
| D12 | GEDCOM | Một spec, hai profile, mapping/loss report; không là backup ứng dụng | P3 |
| D13 | Performance | Baseline + budget + tải đại diện; chưa công bố SLA | P2 |
| D14 | Mapping hiện hữu | Khảo sát repo/schema/role trước thay đổi vật lý | P0 |
| D15 | Ordering publication | Chính sách mã tạm, sinh đôi, renumber và mã lịch sử | P0 |
| D16 | Readiness | Gate theo phạm vi, không chỉ theo tài liệu | Mọi release |

## 21. Lịch sử thay đổi

### 21.1. 2.0.0-draft so với tài liệu ban đầu

Tách Person/quan hệ/render; thêm claim và ngày thiếu; phân biệt đời/mã/layout; sửa công thức ngưỡng kết hôn; thêm tenant/privacy, transaction, audit/undo/restore, giai đoạn và fixture.

### 21.2. 2.0.1-draft so với 2.0.0-draft

- Thêm graph mutation contract cho re-parent/merge và giao thức ghi đồng thời.
- Thứ tự con theo context, không là một số toàn cục của Person.
- Chốt hành vi UX mặc định đề xuất cho nhiều occurrence và mobile.
- Tách mã tham chiếu đã công bố với mã theo anchor; cho phép materialize/version dẫn xuất.
- Sửa hướng D02: giới hạn Union không đồng nghĩa cấm overlap hoặc quan hệ theo giới.
- Sửa D03: không gộp sinh học/nhận nuôi cho mọi ancestry/lineage.
- Làm rõ explicit deny, scope và kiểm tra impact thay vì “quyền cả hai nhánh” đơn giản.
- Bổ sung engine lịch, giới hạn lịch sử và policy giỗ tháng nhuận/ngày thiếu.
- Thêm projection budget, cache/version và benchmark concurrency.
- Bổ sung readiness gate và cập nhật decision register.
- Đưa các contract chi tiết vào phụ lục nhưng giữ đầy đủ nội dung nền tảng trong một file.

## 22. Phê duyệt và quản lý phiên bản

Mỗi quyết định cần người duyệt, ngày, lý do, phiên bản áp dụng, migration/tương thích và tiêu chí nghiệm thu.

Có thể tách sau khi duyệt thành FT-DOCTRINE, FT-DOMAIN-SPEC và FT-DELIVERY-SPEC. Phiên bản này giữ đầy đủ các phần và phụ lục trong một file để review.

Nếu nội dung chính và phụ lục xung đột: dừng triển khai phần đó, tạo decision/change request; không tự chọn quy tắc thuận tiện hơn. Mọi chỉnh sửa policy sau duyệt phải có version và kế hoạch xử lý dữ liệu dẫn xuất.

---

# PHỤ LỤC A — GRAPH MUTATION & CONCURRENCY CONTRACT

## A.1. Quy ước đồ thị

Cạnh parent → child. Tập cạnh được kiểm tra là tập đã xác định bởi graph policy, không chứa spouse edge một cách tùy ý. Claim không hoạt động không tự đưa vào DAG chuẩn.

Một mutation có candidate graph: trạng thái sau khi áp dụng toàn bộ thay đổi dự kiến, trước commit. Phải kiểm tra candidate graph, không kiểm tra từng bước trung gian rồi giả định tổng hợp vẫn hợp lệ.

## A.2. Re-parent

Với cạnh mới P → C:

1. Xác minh identity, tenant, quyền và version.
2. Lập tập cạnh bị xóa/kết thúc hiệu lực và tập cạnh thêm.
3. Từ chối P = C.
4. Trên đồ thị ứng viên phù hợp, kiểm tra reachability C → ... → P.
5. Nếu tồn tại đường đi, từ chối cycle; không đưa cạnh lỗi thành dữ liệu chuẩn.
6. Với nhiều cạnh thêm trong một operation, phải kiểm tra tác động tổng hợp.

Có thể dùng traversal có visited set hoặc recursive query đúng ngữ nghĩa. Giới hạn tài nguyên/timeout phải trả trạng thái chưa thể kiểm chứng, không coi “chưa tìm thấy trong giới hạn” là không có chu trình.

BFS/DFS trên tập đạt tới có chi phí phụ thuộc số đỉnh/cạnh được duyệt. Không hứa chỉ duyệt một nhánh nhỏ trong mọi trường hợp; một thay đổi gần root có thể ảnh hưởng lớn.

## A.3. Merge

1. Chọn Person giữ ID và lập replacement map.
2. Liệt kê tham chiếu cần chuyển: quan hệ, Union, nguồn, account link, branch, numbering và tệp phù hợp.
3. Tính candidate graph sau chuyển.
4. Kiểm tra self-loop, cycle, duplicate, cardinality, Union, quyền và claim conflict.
5. Yêu cầu quyết định tường minh cho xung đột; không tự drop cạnh.
6. Ghi nguyên tử nguồn sự thật và mapping redirect, tạo audit, bump version.
7. Rebuild dẫn xuất theo contract.

Không chỉ kiểm tra hai người có đường tổ tiên trực tiếp với nhau. Không tái sử dụng ID đã merge cho người khác.

## A.4. Giao thức đồng thời đề xuất ban đầu

Một lựa chọn cần phê duyệt kỹ thuật: transaction-level advisory lock theo tenant cho mọi topology mutation.

```text
Preview ngoài transaction dài
BEGIN
  lấy topology lock cho clan theo quy ước thống nhất
  đọc lại trạng thái cần thiết sau lock
  xác minh expected versions + quyền hiện tại
  tính candidate graph và validate
  ghi thay đổi nguồn + audit + version/rebuild marker
COMMIT
```

Yêu cầu:

- Lock database có hiệu lực giữa các process/instance, không chỉ mutex trong Node.js.
- Mọi writer topology dùng cùng giao thức: API, merge, import, undo và admin job.
- Lock key namespace phải rõ và tránh dùng hash không được đánh giá xung đột.
- Không giữ lock lúc người dùng đọc preview, tải media hoặc chạy layout.
- Snapshot/isolation phải bảo đảm phần validation sau lock nhìn thấy các thay đổi đã commit cần thiết; không mặc định snapshot cũ vẫn hợp lệ.
- Có lock timeout, retry có giới hạn và phản hồi dễ hiểu; retry phải chống ghi trùng.
- Nếu có nhiều lock, thứ tự lấy lock thống nhất và có test deadlock.
- Các thay đổi quyền cần được phối hợp hoặc kiểm tra version để không ghi theo authorization cũ.

Đây là phương án ưu tiên đơn giản/tính đúng, có thể làm nghẽn khi clan ghi nhiều. Chỉ chia lock theo component/region sau benchmark và chứng minh không lọt chu trình qua ranh giới. Không chỉ thay bằng row lock ở hai endpoint rồi giả định toàn đồ thị được bảo vệ.

## A.5. Kết quả và mã lỗi đề xuất

```text
SELF_PARENT
ANCESTRY_CYCLE
TOPOLOGY_VERSION_CONFLICT
PERMISSION_SCOPE_CHANGED
MERGE_RELATIONSHIP_CONFLICT
VALIDATION_RESOURCE_LIMIT
TOPOLOGY_BUSY_RETRY
CROSS_TENANT_REFERENCE
```

Tên lỗi cần map contract API thật. Lỗi không được tiết lộ đường tổ tiên hoặc đối tượng ngoài quyền.

---

# PHỤ LỤC B — CHILD ORDERING & NUMBERING POLICY

## B.1. Thứ tự có nguồn

Một Person có thể có order khác trong nhóm con của cha, mẹ, gia đình nhận nuôi và scheme truyền thừa. Mỗi order phải có context. Chỉ biết A lớn hơn B là partial order, không bắt buộc bịa vị trí chính xác trong toàn nhóm.

Phân biệt:

- historical_order: được nguồn khẳng định.
- display_order: dùng để bố trí, có thể dùng tiebreak kỹ thuật.
- published_position: số trong scheme/version đã công bố.

Không tự ghi display_order thành historical_order.

## B.2. Sinh đôi và dữ liệu chưa rõ

- Nếu biết thứ tự sinh đôi, có thể ghi thứ tự kèm nguồn.
- Nếu chưa rõ, giữ trạng thái unresolved; layout vẫn ổn định theo tiebreak không mang ý nghĩa lịch sử.
- Nếu biết thứ bậc nhưng ngày mâu thuẫn, giữ cả nguồn và cảnh báo; không tự hoán đổi.
- Không tự lấy gender làm ưu tiên thứ bậc sinh.

## B.3. Đánh mã

Scheme xác định root, tập quan hệ, nhóm thứ tự, quy tắc uncertainty và version. Nếu dùng mã tạm phải có nhãn provisional; người dùng không hiểu nhầm là mã đã xác nhận.

Renumber cần preview số mã đổi, người ảnh hưởng, mapping mã cũ và các bản xuất đã công bố. Mã cũ có thể tiếp tục được tra theo scheme/version nhưng không được hứa giữ nguyên vị trí hiện tại.

Việc chỉ lưu mã động theo anchor là không đủ cho nhu cầu xuất bản ổn định. Có thể lưu assignment dẫn xuất/version mà vẫn giữ quan hệ và nguồn làm sự thật gốc.

---

# PHỤ LỤC C — MULTIPLE OCCURRENCES UX CONTRACT

## C.1. Selection và focus

```text
selection = { person_id, primary_occurrence_id }
focus = { occurrence_id, viewport_context }
```

Chọn occurrence A làm primary; A′ cùng Person đang thấy có viền/badge phụ, không mang trạng thái primary thứ hai. Không bắt buộc animation; tôn trọng cấu hình giảm chuyển động nếu có.

Occurrence ngoài viewport không tự kéo màn hình. Panel có thể báo “có vị trí khác trong góc nhìn này” và nút chuyển. Số vị trí chỉ tính trong projection người dùng được phép thấy, không ám chỉ dữ liệu ngoài quyền.

## C.2. Collapse

Collapse key dựa projection context và occurrence path ổn định, không chỉ person_id. Collapse A chỉ ẩn phần mở từ ngữ cảnh A; A′ giữ trạng thái riêng.

Node/cạnh dùng chung được tính theo các đường còn mở, không xóa khỏi dữ liệu nguồn. Selection đang nằm trong vùng bị thu gọn cần chuyển focus về điểm collapse hoặc giữ panel với thông báo; không biến mất im lặng. Quy tắc cụ thể phải nhất quán trong UI.

## C.3. Chỉnh sửa

Sửa tên/ngày Person cập nhật mọi occurrence trong quyền. Sửa Parentage/Union phải chọn đúng relationship_ref; không suy ra quan hệ cần sửa chỉ từ một đường canvas khi có nhiều cách đi.

Menu phải tách “Thu gọn”, “Ẩn khỏi góc nhìn” nếu có, “Sửa quan hệ” và “Archive/xóa”. Không đặt thao tác phá hủy ở hành động tap mặc định.

## C.4. Search và state restore

Ưu tiên occurrence đang chọn/đang thấy nếu phù hợp; nếu không, chọn theo tiêu chí xác định và thông báo còn vị trí khác. Lưu viewport/expansion theo user/view khi có tính năng, không theo toàn clan.

Khi data version làm occurrence không còn hợp lệ, phục hồi hợp lý theo person_id và thông báo; không gắn nhầm state vào một người khác do tái sử dụng render ID.

---

# PHỤ LỤC D — CALENDAR ENGINE & MEMORIAL POLICY

## D.1. Engine contract

```text
CalendarConversionContext
- engine_id / engine_version
- calendar_policy_id / policy_version
- timezone_assumption
- supported_range
- input_precision
- conversion_status
```

Các trạng thái đề xuất: converted, not_evaluable, out_of_range, ambiguous, source_conflict. Không dùng ngày hiện tại làm năm giả khi nguồn thiếu năm.

Chọn thư viện sau khi kiểm tra license, bảo trì, đầu vào hợp lệ, round-trip trong miền hỗ trợ và đối chiếu bộ ngày tham chiếu. Phân biệt tính nhất quán nội bộ round-trip với tính đúng theo lịch lịch sử.

## D.2. Chính sách tháng nhuận

Ví dụ nguồn: ngày 10 tháng 4 nhuận. Các lựa chọn đề xuất:

| Policy | Năm có tháng 4 nhuận | Năm không có tháng 4 nhuận |
|---|---|---|
| regular_month | Ngày 10 tháng 4 thường | Ngày 10 tháng 4 thường |
| matching_leap_month_else_regular | Ngày 10 tháng 4 nhuận | Ngày 10 tháng 4 thường |
| manual_schedule | Theo ngày được xác nhận riêng | Theo ngày được xác nhận riêng |

Một năm có tháng nhuận khác tháng 4 không có nghĩa có “tháng nhuận tương ứng”. Năm nhuận dương lịch không đồng nghĩa có tháng nhuận âm lịch.

ĐỀ XUẤT regular_month là default để review, CHƯA CHỐT. Override từng sự kiện rõ ràng hơn clan default; nguồn chính sách được hiển thị. Không tạo hai lần nhắc trong cùng năm nếu policy chỉ định một lần.

## D.3. Ngày không tồn tại

Với ngày giỗ 30 mà tháng đích có 29 ngày, lựa chọn đề xuất:

- last_day_of_month: dùng ngày 29.
- first_day_of_next_month: dùng ngày 1 tháng kế tiếp.
- manual_schedule: yêu cầu xác nhận riêng; không tự gửi trước khi có lịch.

Không chọn mặc định im lặng; D06 phải phê duyệt trước bật nhắc giỗ. Hỗ trợ chuyển năm/tháng đúng calendar policy.

## D.4. Notification

Ghi intended lunar occurrence, ngày dương tính ra, policy version và lịch gửi. Dedupe theo occurrence nhận diện nghiệp vụ, không chỉ ngày chạy job. Khi đổi policy, cập nhật/hủy job cũ để không gửi hai lịch khác nhau. Kiểm tra quyền/consent lúc gửi; không chỉ lúc tạo job.

---

# PHỤ LỤC E — BỘ KIỂM THỬ BỔ SUNG VÀ ĐIỀU KIỆN ÁP DỤNG

## E.1. Concurrency scenarios

1. T1 thêm A → B, T2 thêm B → A: không được cùng commit thành chu trình.
2. T1 thêm A → B, T2 thêm B → C, T3 thêm C → A: kiểm tra vòng dài, không chỉ cặp cạnh.
3. Re-parent cùng lúc merge endpoint: preview/version cũ bị từ chối hoặc được xử lý đúng giao thức.
4. Import đồng thời API edit: không bypass lock hoặc phát hành dữ liệu nửa chừng.
5. Thu hồi quyền khi preview còn mở: commit không dựa vào quyền đã hết hiệu lực.
6. Retry sau timeout/đứt kết nối: không tạo mutation trùng; tra được kết quả operation.
7. Job rebuild cũ hoàn tất sau job mới: không ghi đè version mới.

## E.2. Ordering và numbering

- Sinh đôi không rõ thứ tự vẫn layout ổn định, không công bố con trưởng giả.
- Biết anh/em nhưng không biết ngày: giữ được partial order.
- Thay anchor không đổi mã tham chiếu đã công bố.
- Đổi thứ tự theo nguồn mới có preview renumber và alias/version phù hợp.
- Người có nhiều đường đi giữ một Person và nhiều assignment có ngữ cảnh.

## E.3. Occurrence UX

- Chọn A nhận diện A′ mà không auto-pan.
- Collapse A không reset expansion A′.
- Sửa Person cập nhật mọi occurrence được phép thấy.
- Sửa cạnh chọn đúng relationship_ref.
- Đổi projection không tái sử dụng selection cho người khác.
- Tìm kiếm không làm lộ occurrence ngoài quyền.

## E.4. Lịch và nhắc giỗ

- Ngày tháng nhuận với từng policy, cả năm có/không có đúng tháng nhuận đó.
- Ngày 30 trong tháng 29 ngày theo từng missing_day_policy.
- Chỉ biết ngày/tháng âm: không bịa năm mất.
- Ngoài phạm vi engine: không trả kết quả “chính xác” giả.
- Policy đổi khi job đã lên lịch: không gửi trùng/lịch cũ ngoài ý muốn.
- Hai worker cùng chạy occurrence: chống trùng phù hợp.

## E.5. Bằng chứng nghiệm thu

Lưu commit/build, môi trường, fixture, bước chạy, kết quả, thời gian và hạn chế. Với hiệu năng cần phân phối latency và tải, không chỉ một lần chạy nhanh. Với migration cần đối chiếu trước/sau và thử phục hồi theo phạm vi.

Duyệt tài liệu, tạo file thành công hoặc review code không thay cho các bằng chứng trên.

---

## Kết thúc tài liệu

FT-DOCTRINE-SPEC 2.0.1-draft là bản đầy đủ để phản biện và phê duyệt. Các chính sách đề xuất, đặc biệt D02, D03, D04, D06, D08 và D10, cần quyết định tường minh trước khi chuyển thành schema, migration hoặc hành vi production.
