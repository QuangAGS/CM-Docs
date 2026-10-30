# TFD-102 — Quy tắc định danh và quan hệ
**Family Tree Doctrine (TFD)**  
**Mã tài liệu:** TFD-102  
**Phiên bản:** 0.1 (Dự thảo)  
**Trạng thái:** Đề xuất để rà soát  
**Ngôn ngữ:** Tiếng Việt  
**Phụ thuộc:** TFD-001 — Tổng quan và nguyên tắc quy chuẩn; TFD-101 — Mô hình dữ liệu

---

## 1. Mục đích

TFD-102 quy định cách định danh thực thể, biểu diễn quan hệ huyết thống và quan hệ gia đình, quản lý dữ liệu không chắc chắn, và duy trì tính nhất quán giữa cây phả hệ, hồ sơ cá nhân, sự kiện lịch sử và nguồn tư liệu.

Mục tiêu là để các phần mềm/cơ sở dữ liệu gia phả có thể trao đổi dữ liệu, kiểm chứng quan hệ, tránh gán nhầm người, đồng thời tôn trọng cách ghi chép gia phả Việt Nam.

## 2. Phạm vi

Áp dụng cho:
- Người/cá nhân và hồ sơ định danh của họ.
- Quan hệ cha mẹ–con, phối ngẫu/hôn phối, nhận nuôi, dưỡng dục và quan hệ được ghi nhận theo gia phả.
- Dòng họ, chi/phái, đời thứ, thứ tự trong thế hệ và vai vế.
- Bí danh, tự, hiệu, thụy, tên húy, tên thường gọi, tên sau khi kết hôn và các biến thể tên.
- Sự kiện sinh, mất, kết hôn, nhận nuôi, di cư, an táng, giỗ kỵ và các sự kiện liên quan.
- Nguồn chứng cứ, độ tin cậy và lịch sử chỉnh sửa.

Không quy định nghi lễ, cách xưng hô bắt buộc hay kết luận pháp lý về huyết thống. Các trường hợp có ý nghĩa pháp lý cần được xử lý theo pháp luật áp dụng và nguồn chứng cứ có thẩm quyền.

## 3. Thuật ngữ

| Thuật ngữ | Định nghĩa trong TFD |
|---|---|
| Person | Một cá nhân được mô hình hóa trong hệ thống. |
| Person ID | Mã định danh nội bộ, ổn định, không mang ý nghĩa gia phả. |
| Name Assertion | Một lần ghi nhận tên/biến thể tên, có loại tên, nguồn và khoảng thời gian nếu biết. |
| Relationship Assertion | Một khẳng định rằng hai cá nhân có một quan hệ cụ thể, kèm nguồn và mức độ chắc chắn. |
| Biological parent | Quan hệ cha/mẹ sinh học được nguồn tư liệu hoặc người quản trị ghi nhận. |
| Legal parent | Quan hệ cha/mẹ theo hồ sơ pháp lý. |
| Adoptive parent | Quan hệ cha/mẹ nuôi theo ghi nhận hoặc hồ sơ. |
| Social/raising parent | Người nuôi dưỡng, không mặc định là cha/mẹ sinh học hay pháp lý. |
| Spouse/partner | Quan hệ hôn phối/phối ngẫu được ghi nhận; cần phân biệt hôn nhân pháp lý với ghi chép truyền thống khi nguồn không rõ. |
| Lineage / branch | Dòng họ và chi/phái theo cấu trúc gia phả. |
| Generation number | Đời thứ trong một dòng/chi theo quy ước được khai báo. |
| Assertion | Một phát biểu dữ liệu có thể kiểm chứng, sửa đổi hoặc bị phản bác. |
| Source | Nguồn hỗ trợ cho một khẳng định: gia phả, sắc phong, bia mộ, văn bản hộ tịch, lời kể, v.v. |

## 4. Nguyên tắc định danh

### 4.1. Định danh nội bộ ổn định
1. Mỗi cá nhân MUST có một `person_id` duy nhất trong phạm vi hệ thống.
2. `person_id` MUST không được tạo từ họ tên, ngày sinh, giới tính, số đời hoặc tên chi; các thuộc tính này có thể sai hoặc thay đổi.
3. `person_id` SHOULD là UUID/ULID hoặc mã ngẫu nhiên ổn định tương đương. Có thể dùng số thứ tự nội bộ nếu hệ thống đảm bảo không tái sử dụng và có kiểm soát nhập/xuất.
4. Khi hợp nhất hai hồ sơ trùng người, hệ thống MUST giữ dấu vết chuyển đổi ID (redirect/merge record); không được xóa âm thầm ID cũ.
5. ID đã được công bố trong dữ liệu trao đổi MUST NOT được cấp lại cho người khác.

### 4.2. Định danh bên ngoài và mã hiển thị
- Mã hiển thị như `NGUYEN-000123` chỉ là mã tra cứu, không phải khóa chính bắt buộc.
- Mã GEDCOM hoặc mã từ phần mềm khác phải lưu trong bảng ánh xạ external identifier, kèm hệ thống nguồn và phạm vi.
- Không dùng số đời, thứ tự con, tên chi hay danh xưng làm định danh duy nhất.

### 4.3. Một người, nhiều tên
Mỗi cá nhân có thể có nhiều bản ghi tên. Không tạo hồ sơ mới chỉ vì khác:
- Tên húy, tên tự, tên hiệu, tên thụy;
- Tên thường gọi, tên trong văn bản Hán/Nôm và cách phiên âm;
- Chữ viết khác nhau, dị thể chữ Hán, lỗi chép hoặc biến thể chính tả;
- Tên theo hôn nhân hoặc tên dùng ở địa phương;
- Tên được phục nguyên hoặc tên chưa chắc chắn.

Mỗi bản ghi tên SHOULD có `name_type`, `script/language`, `is_preferred`, `valid_from`, `valid_to`, `source_id`, `certainty` và ghi chú. Không tự động chuẩn hóa mất dấu vết nguyên văn.

### 4.4. Trùng người và hợp nhất hồ sơ
Trước khi tạo hồ sơ mới, hệ thống SHOULD cảnh báo ứng viên trùng dựa trên nhiều tín hiệu: tên/biến thể, niên đại, cha mẹ, phối ngẫu, địa danh, chức tước, mộ phần và nguồn. Không được tự động hợp nhất chỉ vì tên giống nhau.
- Hợp nhất phải do người có quyền thực hiện.
- Lưu ID hồ sơ hợp nhất, ID đích, thời điểm, người thực hiện, lý do và bằng chứng.
- Có cơ chế hoàn tác hoặc phục hồi từ nhật ký.
- Nếu chưa đủ chứng cứ, giữ hai hồ sơ và tạo ghi chú “có thể cùng một người”.

## 5. Quy tắc biểu diễn quan hệ

### 5.1. Mô hình quan hệ dạng khẳng định
Quan hệ phải được lưu thành thực thể độc lập, không chỉ suy ra từ vị trí nút trên hình cây. Mỗi quan hệ SHOULD có:
- `relationship_id`
- `person_a_id`, `person_b_id`
- `relationship_type`
- `valid_from`, `valid_to` hoặc thời điểm sự kiện tương ứng nếu biết
- `status` (proposed, accepted, disputed, rejected, superseded)
- `certainty`
- `source_id` hoặc liên kết đến một hay nhiều nguồn
- `recorded_by`, `recorded_at`, `reviewed_by`, `reviewed_at`
- `notes`

Các quan hệ có thể có nhiều nguồn ủng hộ hoặc phản bác. Không nên lưu nguồn chỉ dưới dạng một trường văn bản tự do nếu cần kiểm toán.

### 5.2. Quan hệ cha/mẹ–con
Phải phân biệt tối thiểu:
- `biological_parent`
- `legal_parent`
- `adoptive_parent`
- `foster_or_raising_parent`
- `step_parent` (cha/mẹ kế)
- `guardian` (người giám hộ, nếu phạm vi hệ thống cần)

Không suy diễn `biological_parent` từ `legal_parent`, `adoptive_parent`, người nuôi dưỡng hoặc từ cách gọi “cha/mẹ” trong lời kể.
Quan hệ cha/mẹ–con có hướng: người cha/mẹ là chủ thể nguồn, người con là đích. Nếu cơ sở dữ liệu dùng bảng cạnh chung, cần bảo đảm ý nghĩa hướng được chuẩn hóa.

### 5.3. Quan hệ hôn phối/phối ngẫu
- Lưu sự kiện/quan hệ hôn phối độc lập với quan hệ cha mẹ.
- Một người có thể có nhiều quan hệ hôn phối trong các giai đoạn khác nhau, nếu nguồn cho thấy điều đó.
- Không mặc định rằng mọi người con của một người đều có cùng người mẹ/người cha.
- Phân biệt hôn nhân được pháp luật công nhận, hôn phối theo ghi chép gia phả, và quan hệ chưa rõ tính chất.
- Lưu ngày/niên đại, địa điểm, thứ tự phối ngẫu theo nguồn, tình trạng kết thúc nếu biết, và nguồn chứng cứ.
- Các từ “chính thất”, “thứ thất”, “vợ cả”, “vợ lẽ”, “phu nhân” chỉ ghi như thuộc tính/diễn đạt nguồn có xuất xứ; không tự động suy ra địa vị pháp lý hay phẩm giá cá nhân.

### 5.4. Anh chị em và quan hệ suy diễn
Quan hệ anh/chị/em SHOULD được suy ra từ cha/mẹ chung khi có dữ liệu đủ chắc chắn, thay vì nhập lặp thành quan hệ gốc. Nếu gia phả nguồn ghi thứ tự anh em trực tiếp nhưng không rõ cha/mẹ chung, lưu một khẳng định riêng về thứ tự/nhóm anh em và gắn nguồn.
- Anh chị em cùng cha cùng mẹ: suy diễn khi cả hai quan hệ cha mẹ đều được xác nhận.
- Cùng cha khác mẹ/cùng mẹ khác cha: chỉ suy diễn khi quan hệ cha mẹ tương ứng đủ căn cứ.
- Anh chị em nuôi/kế: phải phân biệt với anh chị em sinh học.
- Không dùng thứ tự hiển thị để suy ra quan hệ huyết thống.

### 5.5. Quan hệ tổ tiên–hậu duệ
Quan hệ tổ tiên/hậu duệ thường được tính qua chuỗi cha/mẹ–con. Không lưu bản sao cứng cho mọi cặp tổ tiên–hậu duệ trừ khi cần tối ưu truy vấn; nếu lưu bảng closure, phải có quy trình đồng bộ và kiểm tra tính nhất quán.
Không tự động coi người đứng đầu gia phả hoặc người cùng họ là tổ tiên sinh học của mọi thành viên trong dòng.

### 5.6. Dòng họ, chi/phái và thành viên
- Tư cách thành viên dòng họ/chi là một quan hệ tổ chức/gia phả riêng, không đồng nhất với quan hệ huyết thống.
- Một người có thể liên quan đến nhiều nhánh do hôn phối, nhận nuôi, di cư, nhập tộc hoặc cách ghi chép của địa phương.
- Lưu cơ sở/nguồn xác lập tư cách thành viên, thời điểm hiệu lực nếu biết, và người xác nhận.
- Tên chi/phái có thể thay đổi; lưu lịch sử tên và quan hệ chi–dòng theo thời gian.
- Không suy ra huyết thống chỉ từ việc một người được ghi trong một quyển gia phả.

## 6. Đời thứ, vai vế và thứ tự con

### 6.1. Đời thứ
Đời thứ là thuộc tính theo quy ước của từng dòng/chi hoặc từng tài liệu, không phải thuộc tính phổ quát của cá nhân.
- Phải xác định người/nhóm làm mốc đời thứ nhất.
- Ghi rõ phạm vi áp dụng: toàn tộc, một chi, một bản gia phả hay một bản hiệu đính.
- Một người có thể có số đời khác nhau giữa các tài liệu hoặc các nhánh; hệ thống phải hỗ trợ nhiều ghi nhận có nguồn.
- Không ghi đè giá trị cũ khi có bản gia phả mới; tạo phiên bản/khẳng định mới và đánh dấu quan hệ giữa các bản ghi.

### 6.2. Thứ tự con
Thứ tự con cần phân biệt:
- Thứ tự sinh thực tế (nếu biết);
- Thứ tự được ghi trong gia phả;
- Thứ tự theo nghi lễ/quy ước của tài liệu;
- Thứ tự hiển thị trên sơ đồ.

Không mặc định rằng vị trí trái–phải trên sơ đồ là thứ tự sinh. Lưu `order_type`, `ordinal_value`, phạm vi nhóm anh chị em, nguồn và mức độ chắc chắn.

### 6.3. Vai vế và cách xưng hô
Vai vế (ông/bà, bác/chú/cô/cậu, anh/chị/em họ...) nên được tính từ quan hệ và quy tắc xưng hô được cấu hình theo văn hóa/vùng miền. Nếu nhập tay, phải đánh dấu là cách gọi theo nguồn hoặc theo người cung cấp; không dùng vai vế làm bằng chứng thay thế cho quan hệ.

## 7. Thời gian, niên đại và dữ liệu chưa chắc chắn

- Hỗ trợ ngày chính xác, tháng/năm, năm, khoảng thời gian, niên hiệu, âm lịch, dương lịch và niên đại ước đoán.
- Không chuyển đổi ngày âm/dương nếu thiếu thông tin về lịch, múi giờ hoặc quy ước chuyển đổi; lưu giá trị gốc cùng giá trị chuẩn hóa và phương pháp.
- Với niên hiệu, lưu nguyên văn niên hiệu, triều đại, năm thứ, và ngày/tháng nếu có; chuyển sang năm dương lịch chỉ là giá trị chuẩn hóa có ghi chú.
- Cho phép các giá trị “trước”, “sau”, “khoảng”, “không rõ”, “mâu thuẫn”.
- Không biến giá trị ước đoán thành ngày chính xác trong giao diện hoặc xuất dữ liệu.
- Tuổi thọ và trình tự sự kiện cần kiểm tra logic nhưng không tự động bác bỏ dữ liệu lịch sử ngoại lệ.

## 8. Nguồn, chứng cứ và độ chắc chắn

### 8.1. Nguyên tắc nguồn
Mỗi khẳng định quan trọng về danh tính, huyết thống, hôn phối, đời thứ, thứ tự con hoặc mộ phần SHOULD gắn ít nhất một nguồn khi có thể.
Nguồn có thể gồm:
- Bản gia phả gốc/bản sao/bản dịch/bản hiệu đính;
- Văn bia, bia mộ, sắc phong, thần tích, địa bạ, hộ tịch;
- Hồ sơ lưu trữ hoặc tài liệu lịch sử;
- Lời kể truyền khẩu, phỏng vấn, ký ức gia đình;
- Tài liệu số hóa, ảnh chụp, bản phiên âm hoặc bản dịch.

### 8.2. Không dùng một điểm số thay cho giải thích
Nếu hệ thống có thang độ tin cậy, phải công bố ý nghĩa của từng mức và không trình bày điểm số như xác suất khoa học nếu chưa được hiệu chuẩn.
Đề xuất mức:
- `unassessed`: chưa đánh giá;
- `low`: chứng cứ yếu hoặc chỉ có một nguồn gián tiếp;
- `medium`: có nguồn hợp lý nhưng còn điểm chưa rõ;
- `high`: có nhiều nguồn độc lập hoặc nguồn có độ tin cậy cao;
- `conflicted`: nguồn mâu thuẫn.
Mức độ tin cậy và trạng thái tranh chấp là hai khía cạnh khác nhau; không nên ép chúng thành một trường duy nhất.

### 8.3. Nguyên văn và diễn giải
Lưu riêng:
1. Nội dung nguyên văn;
2. Bản phiên âm/chuyển tự;
3. Bản dịch;
4. Diễn giải/ghi chú của người biên tập;
5. Kết luận cấu trúc được hệ thống sử dụng.

Không ghi đè nguyên văn nguồn khi chuẩn hóa chính tả, tên gọi hoặc niên đại.

## 9. Quy tắc dữ liệu Việt Nam và Hán-Nôm

- Tên người phải hỗ trợ Unicode đầy đủ; không giả định tên chỉ có bảng chữ cái Latin.
- Với tên chữ Hán/Nôm, lưu nguyên tự khi có thể, kèm âm đọc/phiên âm, nguồn phiên âm và mức chắc chắn.
- Phân biệt họ, tên đệm, tên gọi khi dữ liệu cho phép; không bắt buộc tách tên cổ hoặc tên Hán-Nôm nếu không có căn cứ.
- Các danh xưng như tự, hiệu, thụy, húy, tước, chức, phẩm hàm cần là loại tên hoặc danh xưng riêng, có thời kỳ và nguồn.
- Địa danh lịch sử phải lưu tên tại thời điểm nguồn ghi và địa danh chuẩn hóa hiện nay (nếu xác định được) thành hai thuộc tính.
- Quy tắc “nối đời”, “đặt tên theo chữ lót/chi phái”, “thứ tự trưởng–thứ”, “nhập tộc”, “hậu duệ nữ”, hoặc cách ghi con nuôi có thể khác nhau giữa các họ và địa phương. TFD không áp đặt một phong tục duy nhất; mỗi gia phả phải khai báo quy ước áp dụng.
- Không mặc định rằng người mang cùng họ có quan hệ huyết thống, hoặc người khác họ không thuộc dòng tộc.
- Không sửa tên lịch sử theo chuẩn hiện đại nếu không giữ nguyên dạng nguồn.

## 10. Mã quan hệ khuyến nghị

| Mã | Ý nghĩa | Hướng | Ghi chú |
|---|---|---|---|
| `BIO_PARENT_OF` | Cha/mẹ sinh học của | Có hướng | Không suy ra từ quan hệ pháp lý |
| `LEGAL_PARENT_OF` | Cha/mẹ pháp lý của | Có hướng | Cần nguồn phù hợp |
| `ADOPTIVE_PARENT_OF` | Cha/mẹ nuôi của | Có hướng | Có thể pháp lý hoặc theo ghi nhận; ghi rõ loại |
| `RAISING_PARENT_OF` | Người nuôi dưỡng | Có hướng | Không mặc định huyết thống |
| `STEP_PARENT_OF` | Cha/mẹ kế của | Có hướng | Không suy ra quan hệ cha/mẹ sinh học |
| `GUARDIAN_OF` | Người giám hộ | Có hướng | Tùy phạm vi hệ thống |
| `SPOUSE_OF` | Phối ngẫu/hôn phối | Không hướng về mặt ngữ nghĩa | Nên chuẩn hóa cặp ID và giữ sự kiện hôn phối |
| `PARTNER_OF` | Bạn đời/quan hệ phối ngẫu chưa phân loại | Không hướng | Không tự động đồng nhất với hôn nhân pháp lý |
| `MEMBER_OF_LINEAGE` | Thành viên dòng họ | Có hướng | Quan hệ tổ chức/gia phả |
| `MEMBER_OF_BRANCH` | Thành viên chi/phái | Có hướng | Có thể thay đổi theo tài liệu |
| `RECORDED_AS_SIBLING_OF` | Được nguồn ghi là anh/chị/em | Không hướng | Dùng khi chưa đủ dữ liệu để suy diễn |
| `SAME_PERSON_AS` | Có thể/được xác nhận là cùng người | Có hướng đến hồ sơ chuẩn | Nên dùng quy trình hợp nhất riêng |
| `DISPUTED_RELATIONSHIP` | Quan hệ đang tranh chấp | Tùy loại | Tốt hơn là trạng thái tranh chấp trên khẳng định gốc |

Mã trên là danh mục khuyến nghị ban đầu. Triển khai thực tế phải quản lý bằng bảng danh mục hoặc registry có phiên bản, không hard-code rải rác trong ứng dụng.

## 11. Quy tắc toàn vẹn và kiểm tra

### 11.1. Ràng buộc bắt buộc
1. ID cá nhân và ID quan hệ duy nhất.
2. Mọi đầu mút quan hệ phải trỏ đến cá nhân tồn tại.
3. Không cho phép một cá nhân làm cha/mẹ sinh học của chính mình.
4. Quan hệ cha/mẹ–con không được tạo chu trình.
5. Quan hệ `SPOUSE_OF` không tự liên kết cá nhân với chính họ.
6. Mọi thao tác hợp nhất hồ sơ phải có nhật ký.
7. Dữ liệu đã bị phản bác không được xóa lịch sử; phải chuyển trạng thái và giữ nguồn.
8. Xóa cá nhân có quan hệ phải được chặn hoặc thực hiện theo chính sách lưu trữ/ẩn danh có kiểm soát.

### 11.2. Cảnh báo, không tự động sửa
Hệ thống SHOULD cảnh báo:
- Cha/mẹ có niên đại quá trẻ/quá cao so với con;
- Ngày mất trước ngày sinh;
- Hôn phối trùng lặp hoặc khoảng thời gian chồng lấn đáng ngờ;
- Đời thứ không nhất quán trong cùng một quy ước;
- Một cá nhân có hai hồ sơ rất giống nhau;
- Cùng một sự kiện có ngày/địa điểm mâu thuẫn;
- Quan hệ tổ tiên có chu trình;
- Thứ tự con trùng nhau trong cùng một nhóm;
- Nguồn bị thiếu hoặc trích dẫn không xác định được.

Các kiểm tra lịch sử phải cho phép ngoại lệ có lý do; cảnh báo không phải kết luận rằng dữ liệu sai.

## 12. Quy tắc hiển thị và xuất dữ liệu

- Giao diện cây là một cách trình bày, không phải mô hình dữ liệu gốc.
- Cần phân biệt đường huyết thống, hôn phối, nhận nuôi và quan hệ đang tranh chấp bằng nhãn/ký hiệu có chú giải; không chỉ dựa vào màu.
- Người dùng có thể chọn hiển thị theo dòng cha, dòng mẹ, tất cả hậu duệ, một chi hoặc một mốc đời.
- Dữ liệu xuất phải giữ ID ổn định, các loại quan hệ, nguồn, trạng thái và thông tin không chắc chắn trong giới hạn định dạng đích.
- Khi định dạng đích không hỗ trợ một loại quan hệ, phải tạo báo cáo mất mát dữ liệu; không âm thầm đổi quan hệ nhận nuôi thành quan hệ sinh học.
- Khi nhập dữ liệu từ GEDCOM hoặc phần mềm khác, lưu ID nguồn và báo cáo các quan hệ không ánh xạ được.

## 13. Bảo mật, quyền riêng tư và quản trị

- Thông tin người còn sống cần kiểm soát quyền xem, sửa, xuất và chia sẻ.
- Ghi nhật ký các thay đổi quan trọng: tạo, sửa, hợp nhất, phản bác, khôi phục, xuất dữ liệu.
- Ghi rõ người nhập dữ liệu và người duyệt nếu có quy trình biên tập.
- Không công khai dữ liệu cá nhân nhạy cảm của người còn sống nếu không có cơ sở và quyền phù hợp.
- Có cơ chế phân quyền theo vai trò: người xem, người nhập liệu, biên tập viên, người duyệt, quản trị viên.
- Mọi chính sách lưu trữ, đồng thuận và công bố phải tuân thủ pháp luật áp dụng.

## 14. Mô hình triển khai tham khảo

Bảng lõi được khuyến nghị:
- `person`
- `person_name`
- `relationship_assertion`
- `relationship_source`
- `source`
- `lineage`
- `branch`
- `lineage_membership`
- `generation_assertion`
- `sibling_group`
- `event`
- `place`
- `external_identifier`
- `merge_history`
- `audit_log`

Không bắt buộc tên bảng vật lý phải trùng hoàn toàn; bắt buộc là ngữ nghĩa, ràng buộc và khả năng truy xuất phải được giữ.

## 15. SQL mẫu (PostgreSQL)

Đây là mẫu tham khảo để thể hiện các ràng buộc cơ bản, không phải migration sản xuất hoàn chỉnh. Cần kiểm thử theo phiên bản PostgreSQL, chiến lược xóa, phân quyền và yêu cầu hiệu năng thực tế.

```sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE person (
    person_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    record_status TEXT NOT NULL DEFAULT 'active'
        CHECK (record_status IN ('active','merged','archived','restricted')),
    notes TEXT
);

CREATE TABLE person_name (
    person_name_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    person_id UUID NOT NULL REFERENCES person(person_id) ON DELETE RESTRICT,
    name_text TEXT NOT NULL,
    name_type TEXT NOT NULL,
    language_code TEXT,
    script_code TEXT,
    is_preferred BOOLEAN NOT NULL DEFAULT FALSE,
    source_id UUID,
    certainty TEXT NOT NULL DEFAULT 'unassessed'
        CHECK (certainty IN ('unassessed','low','medium','high','conflicted')),
    notes TEXT
);

CREATE TABLE relationship_assertion (
    relationship_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    person_a_id UUID NOT NULL REFERENCES person(person_id) ON DELETE RESTRICT,
    person_b_id UUID NOT NULL REFERENCES person(person_id) ON DELETE RESTRICT,
    relationship_type TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'proposed'
        CHECK (status IN ('proposed','accepted','disputed','rejected','superseded')),
    certainty TEXT NOT NULL DEFAULT 'unassessed'
        CHECK (certainty IN ('unassessed','low','medium','high','conflicted')),
    valid_from TEXT,
    valid_to TEXT,
    notes TEXT,
    CHECK (person_a_id <> person_b_id)
);

CREATE INDEX idx_relationship_a ON relationship_assertion(person_a_id);
CREATE INDEX idx_relationship_b ON relationship_assertion(person_b_id);
CREATE INDEX idx_relationship_type_status
    ON relationship_assertion(relationship_type, status);
CREATE INDEX idx_person_name_text ON person_name(name_text);
```

**Lưu ý kỹ thuật:** SQL trên chưa tự ngăn được chu trình trong quan hệ cha/mẹ–con. Phải bổ sung trigger hoặc kiểm tra ở tầng dịch vụ bằng truy vấn đệ quy có giao dịch phù hợp; không chỉ dựa vào `CHECK` constraint. Bảng `person_name.source_id` cần được liên kết khóa ngoại tới bảng `source` trong migration đầy đủ.

## 16. Bộ ca kiểm thử nghiệm thu

| ID | Tình huống | Kết quả mong đợi |
|---|---|---|
| TFD102-T01 | Tạo hai người cùng tên | Cho phép hai hồ sơ riêng; có thể cảnh báo trùng |
| TFD102-T02 | Một người có tên húy và tên tự | Một `person_id`, nhiều bản ghi tên |
| TFD102-T03 | Đổi tên hiển thị | ID cá nhân không đổi |
| TFD102-T04 | Cha/mẹ sinh học và cha/mẹ nuôi khác nhau | Lưu được hai loại quan hệ riêng |
| TFD102-T05 | Một người có nhiều phối ngẫu theo thời kỳ | Lưu được từng quan hệ/sự kiện và nguồn |
| TFD102-T06 | Gán một người làm cha/mẹ của chính họ | Bị từ chối |
| TFD102-T07 | Tạo chu trình A là cha B, B là cha C, C là cha A | Bị chặn hoặc bị đánh dấu lỗi toàn vẹn trước khi chấp nhận |
| TFD102-T08 | Hai tài liệu ghi đời thứ khác nhau | Lưu hai khẳng định có nguồn, không ghi đè âm thầm |
| TFD102-T09 | Thứ tự con chỉ được ghi trong gia phả, không rõ thứ tự sinh | Lưu `order_type` theo nguồn, không gán thành thứ tự sinh |
| TFD102-T10 | Quan hệ bị phản bác | Giữ lịch sử, đổi trạng thái và ghi lý do/nguồn |
| TFD102-T11 | Hợp nhất hai hồ sơ | Giữ lịch sử ID cũ và liên kết đến hồ sơ chuẩn |
| TFD102-T12 | Xuất sang định dạng thiếu loại quan hệ | Có báo cáo mất mát, không âm thầm đổi ngữ nghĩa |

## 17. Tiêu chí hoàn thành TFD-102

TFD-102 được xem là sẵn sàng cho phê duyệt khi:
1. Danh mục ID và loại quan hệ được thống nhất với TFD-101.
2. Quy tắc về người, tên, cha mẹ, phối ngẫu, đời thứ và thứ tự con được rà soát bởi đại diện chuyên môn gia phả.
3. Các kiểm tra chu trình và tính toàn vẹn được triển khai, kiểm thử.
4. Các trường nguồn, mức chắc chắn, trạng thái tranh chấp và lịch sử sửa đổi có thể truy xuất.
5. Có quy trình nhập/xuất và báo cáo mất mát dữ liệu.
6. Có chính sách riêng tư cho người còn sống.
7. Các ca kiểm thử nghiệm thu ở Mục 16 được thực hiện và lưu kết quả.

## 18. Tài liệu tham chiếu và giới hạn

TFD là bộ quy chuẩn đề xuất, không phải tiêu chuẩn quốc gia hay tiêu chuẩn quốc tế đã được công nhận. Khi triển khai cần đối chiếu phiên bản hiện hành của các định dạng và tiêu chuẩn liên quan, đặc biệt:
- GEDCOM (định dạng trao đổi dữ liệu phả hệ; cần xác định phiên bản hỗ trợ cụ thể);
- Unicode Standard (biểu diễn văn bản đa ngôn ngữ);
- ISO 8601 (biểu diễn ngày/giờ ở những trường hợp phù hợp; không thay thế mô hình niên đại lịch sử);
- W3C PROV (mô hình hóa nguồn gốc/provenance, nếu cần tương thích);
- Nguyên tắc bảo vệ dữ liệu cá nhân và pháp luật Việt Nam có liên quan.

Không tuyên bố tuân thủ hoàn toàn một chuẩn bên ngoài nếu chưa có bảng ánh xạ, kiểm thử tương thích và xác định rõ phiên bản áp dụng.

---

**Kết thúc tài liệu TFD-102 — Phiên bản dự thảo 0.1**
