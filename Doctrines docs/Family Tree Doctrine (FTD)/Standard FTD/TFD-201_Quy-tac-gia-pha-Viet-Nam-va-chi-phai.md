# TFD-201 — Quy tắc gia phả Việt Nam và chi phái

**Family Tree Doctrine (TFD)**  
**Mã tài liệu:** TFD-201  
**Phiên bản:** 0.1 — Dự thảo để rà soát và thử nghiệm  
**Ngày:** 20/10/2026  
**Trạng thái:** Dự thảo; chưa phải tiêu chuẩn chính thức  
**Ngôn ngữ:** Tiếng Việt  
**Tài liệu nền:** TFD-001 — Tổng quan và nguyên tắc quy chuẩn; TFD-101 — Mô hình dữ liệu; TFD-102 — Quy tắc định danh và quan hệ; TFD-103 — Quy tắc sự kiện, niên đại và nguồn chứng cứ  
**Tài liệu liên quan:** TFD-301 — Quy trình quản lý nguồn, chứng cứ và dị bản; TFD-401 — Quy chuẩn bảo mật, phân quyền và quản trị; TFD-501 — Quy chuẩn nhập/xuất GEDCOM và chuyển đổi dữ liệu; TFD-601 — Bộ kiểm thử tuân thủ và tiêu chí nghiệm thu

---

## Kiểm soát tài liệu

| Thuộc tính | Giá trị |
|---|---|
| Chủ sở hữu quy chuẩn | Chưa chỉ định |
| Người soạn thảo | Chưa chỉ định |
| Người phê duyệt | Chưa chỉ định |
| Phạm vi áp dụng | Phần mềm, cơ sở dữ liệu và quy trình lập, số hóa, trao đổi gia phả có tuyên bố tuân thủ TFD |
| Tính chất | Quy tắc ngữ nghĩa và nghiệp vụ; không phải hướng dẫn nghi lễ hoặc kết luận pháp lý |
| Trạng thái phê duyệt | Chưa phê duyệt |

### Lịch sử phiên bản

| Phiên bản | Ngày | Nội dung |
|---|---|---|
| 0.1 | 20/10/2026 | Bản dự thảo ban đầu để rà soát; cần đối chiếu với TFD-001, TFD-101, TFD-102 và TFD-103 trước khi phê duyệt |

### Quy ước từ khóa

- **PHẢI:** yêu cầu bắt buộc để tuyên bố tuân thủ.
- **KHÔNG ĐƯỢC:** hành vi bị cấm theo quy chuẩn.
- **NÊN:** khuyến nghị mạnh; nếu không áp dụng cần ghi lý do.
- **CÓ THỂ:** lựa chọn được phép khi không làm sai lệch ngữ nghĩa hoặc vi phạm yêu cầu bắt buộc.
- **Chưa xác định:** thông tin hiện chưa có căn cứ đủ để ghi nhận.
- **Không áp dụng:** trường hợp đã xác định không thuộc phạm vi của thuộc tính; khác với chưa biết.

## 1. Mục đích

TFD-201 quy định cách mô hình hóa và trình bày các khái niệm gia phả Việt Nam — bao gồm dòng họ, chi/phái, tổ tiên, hậu duệ, thế hệ, vai vế, tên và danh xưng, hôn phối, quan hệ cha mẹ–con, thứ tự con và các quy ước gia phả theo phạm vi cụ thể.

Mục tiêu là để các hệ thống khác nhau có thể lưu trữ, trao đổi và trình bày thông tin gia phả mà không nhầm lẫn giữa:

1. quan hệ gia đình được khẳng định;
2. tư cách thành viên trong một dòng họ hoặc chi phái;
3. đời thứ theo một quy ước gia phả;
4. thứ tự sinh hoặc thứ tự được ghi trong tài liệu;
5. vai vế và cách xưng hô;
6. dữ kiện được nguồn ghi nhận, cách diễn giải và kết luận nghiên cứu.

TFD-201 không nhằm áp đặt một quy tắc duy nhất cho mọi dòng họ, vùng miền, thời kỳ hoặc truyền thống địa phương. Các quy tắc có tính địa phương hoặc riêng của một gia phả PHẢI được khai báo phạm vi, nguồn gốc và thời điểm áp dụng.

## 2. Phạm vi

### 2.1. Trong phạm vi

TFD-201 quy định:

- Khái niệm dòng họ, dòng phả hệ, chi/phái và nhánh gia phả.
- Tư cách thành viên trong dòng họ/chi/phái.
- Đời thứ, thế hệ, cách đánh số đời và phạm vi áp dụng.
- Quan hệ cha/mẹ–con và phân biệt các loại quan hệ.
- Quan hệ hôn phối/phối ngẫu và việc ghi nhận nhiều cuộc hôn nhân theo nguồn.
- Thứ tự con, trưởng/thứ và cách ghi nhận khi không rõ căn cứ.
- Tên, tên húy, tên tự, tên hiệu, tên thụy, tên thường gọi, tên sau kết hôn, tên chữ Hán/Nôm, phiên âm và dị bản tên.
- Vai vế, danh xưng và cách xưng hô khi được ghi nhận như dữ liệu hoặc quy ước hiển thị.
- Sự khác biệt giữa quan hệ thực tế, quan hệ pháp lý, quan hệ huyết thống, quan hệ nhận nuôi/nuôi dưỡng và quan hệ được gia phả ghi chép.
- Cách thể hiện bất đồng, khoảng trống, giả thuyết và mức độ chưa chắc chắn.
- Các kiểm tra toàn vẹn và ca kiểm thử nghiệp vụ liên quan.

### 2.2. Ngoài phạm vi

TFD-201 không:

- Quy định nghi lễ, tập tục thờ cúng hoặc cách xưng hô bắt buộc trong đời sống.
- Phán quyết tính hợp pháp của hôn nhân, nhận nuôi, quyền thừa kế hoặc huyết thống.
- Xác định ai “đúng” trong tranh chấp lịch sử chỉ bằng quy tắc phần mềm.
- Đưa ra một quy tắc chung áp dụng cho mọi dòng họ về việc ai được tính là thành viên hoặc cách tính đời thứ.
- Cho phép suy ra quan hệ sinh học chỉ từ họ, tên, giới tính, vị trí trên cây hoặc việc cùng thuộc một chi.
- Thay thế TFD-301 về quy trình nguồn/chứng cứ, TFD-401 về quyền truy cập, TFD-501 về chuyển đổi hoặc TFD-601 về đánh giá tuân thủ.

## 3. Nguyên tắc nền tảng

### 3.1. Tách cá nhân, quan hệ và tư cách dòng họ

Một cá nhân là một thực thể riêng có định danh ổn định. Quan hệ gia đình và tư cách thành viên trong dòng họ/chi phái là những dữ liệu riêng, có căn cứ và lịch sử riêng. Một người có thể có nhiều tên, nhiều quan hệ và nhiều tư cách thành viên được ghi nhận trong những phạm vi khác nhau.

### 3.2. Không suy diễn khi thiếu căn cứ

Hệ thống KHÔNG ĐƯỢC tự động xác nhận quan hệ cha/mẹ–con, quan hệ huyết thống, thứ tự sinh, đời thứ, trưởng/thứ hoặc tư cách chi phái chỉ từ họ tên, giới tính, địa chỉ, cách bố trí trên sơ đồ hoặc quy ước trình bày.

### 3.3. Quy tắc có phạm vi

Mỗi quy ước gia phả có ảnh hưởng đến việc tính toán hoặc trình bày PHẢI gắn với một phạm vi áp dụng xác định, chẳng hạn một gia phả, một dòng họ, một chi/phái, một tài liệu, một giai đoạn lịch sử hoặc một bản quy ước được phê chuẩn.

### 3.4. Nguyên bản và chuẩn hóa cùng tồn tại

Tên gọi, địa danh, chức tước, quan hệ và cách ghi trong tài liệu nguồn PHẢI được bảo toàn. Dữ liệu chuẩn hóa, phiên âm, dịch nghĩa hoặc tên dùng để hiển thị PHẢI được lưu riêng hoặc được phân biệt rõ; không được âm thầm ghi đè nguyên bản.

### 3.5. Bảo toàn bất đồng

Nếu các nguồn hoặc người nghiên cứu đưa ra thông tin khác nhau, hệ thống PHẢI cho phép lưu các khẳng định khác nhau cùng nguồn, căn cứ, người ghi nhận và trạng thái đánh giá. Không được xóa một phương án chỉ vì phương án khác được chọn làm mặc định để hiển thị.

### 3.6. Dữ liệu và sơ đồ độc lập

Sơ đồ cây, bảng đời, sơ đồ chi phái hoặc danh sách thành viên là các cách trình bày dữ liệu. Vị trí trực quan của một người trên sơ đồ không tự nó tạo ra hoặc chứng minh quan hệ gia đình.

## 4. Thuật ngữ

| Thuật ngữ | Định nghĩa dùng trong TFD-201 |
|---|---|
| Dòng họ (Lineage/Clan) | Tập hợp người hoặc nhánh được một quy tắc gia phả xác định là thuộc cùng một dòng họ; tiêu chí thành viên phải được khai báo. |
| Dòng phả hệ | Chuỗi hoặc cấu trúc quan hệ tổ tiên–hậu duệ được ghi nhận trong một gia phả; không nhất thiết đồng nhất với tư cách thành viên dòng họ. |
| Chi/phái (Branch) | Nhánh được xác định theo quy ước của một dòng họ hoặc một gia phả; tiêu chí hình thành chi/phái phải được ghi rõ. |
| Nhánh hiển thị | Nhóm hoặc phần cây được tạo để trình bày; không mặc nhiên là một chi/phái có ý nghĩa nghiệp vụ. |
| Tư cách thành viên (Lineage Membership) | Bản ghi cho biết một người được xem là thành viên của dòng họ/chi/phái theo một quy tắc, nguồn hoặc quyết định cụ thể. |
| Đời thứ (Generation Number) | Số đời của một người theo một quy tắc và điểm quy chiếu được xác định trong phạm vi cụ thể. |
| Thế hệ | Nhóm người được phân loại theo quy tắc đã khai báo; không mặc nhiên đồng nghĩa với cùng năm sinh hoặc cùng độ tuổi. |
| Thủy tổ | Người được một nguồn hoặc quy ước gia phả xác định là tổ tiên khởi đầu của dòng/nhánh trong phạm vi đang xét. |
| Tiên tổ/tổ tiên | Người được ghi nhận là thuộc thế hệ trước trong một quan hệ phả hệ cụ thể. |
| Hậu duệ | Người có quan hệ tổ tiên–hậu duệ được ghi nhận theo loại quan hệ và căn cứ cụ thể. |
| Trưởng/thứ | Nhãn hoặc quy tắc thứ tự được ghi nhận theo nguồn hay quy ước; không tự động suy ra từ tuổi, giới tính hoặc vị trí sơ đồ. |
| Thứ tự sinh | Thứ tự sinh được nguồn xác nhận hoặc được ghi nhận là chưa chắc chắn; cần phân biệt với thứ tự trong gia phả. |
| Vai vế | Vị trí quan hệ theo một hệ quy chiếu gia đình/dòng họ; không nhất thiết có thể suy ra duy nhất từ quan hệ huyết thống. |
| Quy ước gia phả | Bộ quy tắc xác định cách tính đời, thành viên, chi phái, thứ tự hoặc cách trình bày trong phạm vi đã khai báo. |
| Dị bản | Các dạng ghi khác nhau của tên, sự kiện, quan hệ hoặc nội dung tư liệu có liên quan đến cùng một đối tượng hay khẳng định. |
| Khẳng định (Assertion) | Một phát biểu có thể kiểm tra, được gắn với chủ thể, nội dung, nguồn/căn cứ và trạng thái đánh giá nếu có. |

## 5. Mô hình dòng họ và chi/phái

### 5.1. Dòng họ không phải là một quan hệ cha–con

1. Dòng họ/chi/phái PHẢI được mô hình hóa như thực thể hoặc cấu trúc riêng, không thay thế bằng một quan hệ cha–con duy nhất.
2. Một người thuộc dòng họ theo quy ước không nhất thiết đã có đủ dữ kiện để xác định toàn bộ chuỗi huyết thống.
3. Một quan hệ huyết thống được ghi nhận không tự động quyết định tư cách thành viên của một dòng họ hoặc chi phái.
4. Việc cùng họ không đủ để kết luận hai người thuộc cùng một dòng họ, cùng chi hoặc có quan hệ huyết thống.
5. Việc khác họ không đủ để phủ nhận quan hệ huyết thống hoặc tư cách thành viên được ghi nhận.

### 5.2. Định danh dòng họ và chi/phái

1. Mỗi dòng họ và chi/phái được quản lý trong hệ thống PHẢI có định danh ổn định, không phụ thuộc vào tên hiển thị.
2. Tên dòng họ/chi/phái PHẢI hỗ trợ nhiều dạng ghi, tên thay thế, tên lịch sử hoặc tên địa phương khi có căn cứ.
3. Việc đổi tên hiển thị KHÔNG ĐƯỢC làm thay đổi định danh nội bộ.
4. Nếu một nhánh được tách, hợp nhất, đổi tên hoặc tái phân loại, lịch sử thay đổi NÊN được bảo toàn; không được tự động chuyển tất cả thành viên nếu chưa có quy tắc hoặc quyết định áp dụng.
5. Không được xem hai chi/phái là cùng một thực thể chỉ vì tên giống nhau.

### 5.3. Quan hệ giữa dòng họ và chi/phái

1. Một chi/phái CÓ THỂ được liên kết với một dòng họ hoặc nhánh cấp trên.
2. Nếu mô hình cho phép nhiều cấp nhánh, mỗi quan hệ cha–nhánh PHẢI có ngữ nghĩa rõ ràng và không được nhầm với quan hệ cha–con giữa cá nhân.
3. Không được mặc định mọi gia phả có cấu trúc phân cấp đầy đủ hoặc không có nhánh chồng lấn.
4. Trường hợp quan hệ giữa các chi/phái còn tranh luận PHẢI được biểu diễn là chưa xác định hoặc có nhiều khẳng định, thay vì ép thành một cây duy nhất.

### 5.4. Tư cách thành viên

Mỗi bản ghi tư cách thành viên NÊN xác định được:

- cá nhân;
- dòng họ/chi/phái liên quan;
- loại hoặc căn cứ thành viên theo quy ước đang áp dụng;
- nguồn, tài liệu hoặc quyết định làm căn cứ nếu có;
- thời điểm hoặc khoảng thời gian hiệu lực nếu biết;
- trạng thái: đang được ghi nhận, đã kết thúc, bị tranh chấp hoặc chưa xác định;
- người/hệ thống ghi nhận và lịch sử thay đổi.

Không được diễn giải việc không có bản ghi thành viên là bằng chứng chắc chắn rằng người đó không thuộc dòng họ.

### 5.5. Các trường hợp thành viên đặc biệt

TFD-201 không đặt ra một quy tắc chung cho mọi dòng họ về tư cách của con nuôi, con riêng, con ngoài hôn nhân, con gái sau kết hôn, người đổi họ, người nhập chi hoặc người được ghi nhận theo quan hệ nuôi dưỡng. Những trường hợp này PHẢI được xử lý theo quy ước cụ thể của gia phả, nguồn có liên quan và quy định pháp luật áp dụng khi có vấn đề pháp lý.

Phần mềm PHẢI cho phép ghi nhận các trường hợp khác nhau mà không ép tất cả vào một thuộc tính nhị phân “thuộc/không thuộc” không có căn cứ.

## 6. Quy tắc về đời thứ và thế hệ

### 6.1. Đời thứ luôn có phạm vi

1. Đời thứ PHẢI gắn với một dòng họ, chi/phái, gia phả hoặc bộ quy ước cụ thể.
2. Đời thứ KHÔNG ĐƯỢC được lưu hoặc trình bày như thuộc tính tuyệt đối, không có điểm quy chiếu.
3. Hai tài liệu có thể đánh số đời khác nhau cho cùng một người; hệ thống PHẢI cho phép lưu cả hai cách đánh số kèm phạm vi và nguồn.
4. Việc chọn một cách đánh số làm cách hiển thị mặc định không được xóa cách đánh số khác.
5. Nếu không biết điểm khởi đầu, quy tắc tính hoặc căn cứ đời thứ, phải ghi chưa xác định; không tự suy ra số đời chỉ từ độ sâu của sơ đồ.

### 6.2. Bộ quy tắc tính đời

Một `HouseholdRuleSet` hoặc cấu trúc tương đương NÊN khai báo tối thiểu:

- mã và tên quy tắc;
- dòng họ/chi/phái/gia phả áp dụng;
- người hoặc nhóm người được chọn làm điểm quy chiếu, nếu có;
- quy tắc xác định thế hệ kế tiếp;
- loại quan hệ được dùng để tính đời;
- cách xử lý quan hệ nhận nuôi, nuôi dưỡng, quan hệ pháp lý hoặc trường hợp khác nếu quy ước có đề cập;
- cách xử lý nhiều dòng quan hệ hoặc quan hệ chưa xác minh;
- thời điểm bắt đầu áp dụng, phiên bản và nguồn phê chuẩn;
- trạng thái và người chịu trách nhiệm quản lý quy tắc.

Nếu một trường chưa được quy ước xác định, hệ thống PHẢI nêu rõ đó là phần chưa quy định, không tự điền một quy tắc mặc định có tính phổ quát.

### 6.3. Không đồng nhất đời thứ với tuổi

Đời thứ không được tự động tính từ năm sinh, tuổi, khoảng cách tuổi giữa cha mẹ và con hoặc thế hệ sinh học ước lượng. Nếu phần mềm cung cấp phép tính đời tự động, phép tính PHẢI sử dụng một quy tắc được khai báo và quan hệ đầu vào đã xác định; kết quả phải truy nguyên được về quy tắc và dữ liệu đầu vào.

### 6.4. Thiếu hoặc mâu thuẫn dữ liệu

Nếu có nhiều quan hệ tổ tiên–hậu duệ khả dĩ, quan hệ tranh chấp hoặc điểm quy chiếu không rõ, hệ thống PHẢI có thể trả về trạng thái chưa xác định, cảnh báo hoặc nhiều kết quả theo các quy tắc khác nhau. Không được tự chọn một kết quả mà không nêu căn cứ.

## 7. Quan hệ gia đình trong ngữ cảnh gia phả Việt Nam

### 7.1. Quan hệ cha/mẹ–con

Hệ thống PHẢI phân biệt ít nhất về mặt ngữ nghĩa giữa các loại quan hệ được TFD-102 quy định hoặc cho phép mở rộng, bao gồm:

- cha/mẹ sinh học;
- cha/mẹ pháp lý;
- cha/mẹ nuôi;
- người nuôi dưỡng hoặc quan hệ chăm sóc;
- quan hệ cha/mẹ–con được ghi nhận trong gia phả nhưng chưa xác định rõ loại;
- khẳng định quan hệ đang tranh chấp hoặc chưa xác minh.

Các loại quan hệ trên không được tự động quy đổi cho nhau. Nếu nguồn chỉ ghi “cha”, “mẹ”, “con” mà không đủ thông tin xác định loại quan hệ, phải bảo toàn cách ghi nguồn và để loại quan hệ ở trạng thái chưa xác định hoặc theo quy tắc ánh xạ đã công bố.

### 7.2. Hôn phối và phối ngẫu

1. Hệ thống PHẢI cho phép ghi nhận nhiều cuộc hôn nhân/phối ngẫu nếu được nguồn hỗ trợ.
2. Mỗi quan hệ cần phân biệt dữ kiện được ghi nhận với tình trạng pháp lý đã xác minh.
3. Các cách gọi như chính thất, thứ thất, vợ lẽ, phối ngẫu hoặc danh xưng lịch sử PHẢI được bảo toàn theo nguồn và thời kỳ; không được tự động coi các thuật ngữ lịch sử là các loại quan hệ pháp lý hiện hành tương đương.
4. Không được suy ra thứ tự hôn nhân, tình trạng hôn nhân hoặc quan hệ cha/mẹ của một người chỉ từ vị trí trên sơ đồ.
5. Nếu nguồn không cho biết ngày bắt đầu/kết thúc, không được tự tạo ngày chính xác.

### 7.3. Anh chị em và thứ tự con

1. Quan hệ anh chị em có thể được ghi nhận trực tiếp hoặc suy ra từ các quan hệ cha/mẹ–con đã được xác định, nhưng hệ thống PHẢI phân biệt hai trường hợp.
2. Thứ tự sinh PHẢI được phân biệt với thứ tự được liệt kê trong gia phả, thứ tự đặt tên hoặc thứ tự trình bày.
3. Các nhãn trưởng, thứ, út hoặc thứ tự tương tự PHẢI gắn với nguồn hoặc quy ước nếu chúng có ý nghĩa nghiệp vụ.
4. Nếu thứ tự không rõ hoặc các nguồn mâu thuẫn, phải lưu trạng thái không chắc chắn hoặc các phương án khác nhau.
5. Không được tự động xác định “con trưởng” chỉ từ việc một người xuất hiện đầu tiên trong danh sách.

### 7.4. Quan hệ tổ tiên–hậu duệ

Quan hệ tổ tiên–hậu duệ là quan hệ có thể được truy vấn hoặc hiển thị từ các quan hệ thành phần. Khi tạo kết quả suy diễn, hệ thống NÊN lưu hoặc cung cấp khả năng truy nguyên chuỗi quan hệ đã dùng. Kết quả suy diễn KHÔNG ĐƯỢC trình bày như một khẳng định trực tiếp từ nguồn nếu nó chỉ được tính từ các quan hệ thành phần.

### 7.5. Chu trình và quan hệ bất thường

Chu trình trong quan hệ cha/mẹ–con hoặc dữ liệu mâu thuẫn PHẢI được phát hiện hoặc đưa ra cảnh báo theo quy tắc toàn vẹn của TFD-101/102. Hệ thống KHÔNG ĐƯỢC tự động xóa hoặc sửa quan hệ nguồn chỉ để làm cho cây hiển thị thành một cây không chu trình. Người xử lý phải xem xét nguồn, ghi nhận quyết định và bảo toàn lịch sử.

## 8. Tên, danh xưng và văn bản Hán-Nôm

### 8.1. Một cá nhân có thể có nhiều tên

Một cá nhân CÓ THỂ có nhiều dạng tên theo thời kỳ, ngôn ngữ, mục đích hoặc nguồn, bao gồm nhưng không giới hạn ở họ tên khai sinh/được ghi nhận, tên húy, tên tự, tên hiệu, tên thụy, tên thường gọi, tên sau kết hôn, tên chữ Hán/Nôm, phiên âm, tên dịch và biến thể do chép hoặc đọc khác nhau.

Không phải mọi loại tên đều áp dụng cho mọi cá nhân hoặc mọi thời kỳ. Hệ thống KHÔNG ĐƯỢC tự tạo một loại tên hoặc giá trị tên chỉ vì quy ước văn hóa có đề cập đến loại đó.

### 8.2. Bảo toàn nguyên văn

1. Khi có bản ghi từ nguồn, dạng tên nguyên văn PHẢI được giữ lại.
2. Dạng chuẩn hóa, phiên âm Latin, dịch nghĩa hoặc tên ưu tiên hiển thị PHẢI được phân biệt với nguyên văn.
3. Mỗi dạng tên NÊN có loại tên, ngôn ngữ/chữ viết nếu biết, nguồn, thời kỳ hiệu lực nếu biết và ghi chú về độ chắc chắn.
4. Việc chọn tên hiển thị không làm mất các dạng tên khác.
5. Không được gộp hai cá nhân chỉ vì tên giống nhau hoặc tách một cá nhân thành nhiều người chỉ vì tên khác nhau mà chưa xem xét chứng cứ.

### 8.3. Chữ Hán/Nôm, phiên âm và dịch nghĩa

Nếu dữ liệu chứa chữ Hán/Nôm, bản chép, phiên âm hoặc dịch nghĩa, hệ thống NÊN phân biệt rõ:

- ảnh hoặc tư liệu gốc;
- bản chép nguyên văn;
- phiên âm/chuyển tự;
- dịch nghĩa;
- chú giải hoặc diễn giải của người nghiên cứu.

Các lớp trên không được tự động coi là tương đương. Nếu có nhiều cách đọc hoặc dịch, phải có khả năng lưu nhiều phương án và gắn với người thực hiện, nguồn tham khảo hoặc lý do lựa chọn.

### 8.4. Tên và quyết định hợp nhất hồ sơ

Quyết định hợp nhất hai hồ sơ cá nhân PHẢI dựa trên việc đánh giá tổng hợp dữ kiện và nguồn, không chỉ dựa trên tên. Khi hợp nhất, hệ thống NÊN lưu lịch sử, định danh cũ, định danh được giữ lại, căn cứ và người thực hiện; không được tái sử dụng định danh cũ cho một người khác.

## 9. Vai vế, danh xưng và quy ước trình bày

1. Vai vế và cách xưng hô phụ thuộc vào ngữ cảnh gia đình, dòng họ, vùng miền, thời kỳ và quy ước cụ thể.
2. Hệ thống PHẢI phân biệt dữ liệu quan hệ với nhãn vai vế được tính toán hoặc hiển thị.
3. Nhãn như ông, bà, bác, chú, cô, cậu, dì, anh, chị, em hoặc danh xưng truyền thống khác không được dùng làm bằng chứng duy nhất để xác nhận quan hệ sinh học hoặc đời thứ.
4. Nếu hệ thống tính vai vế, phải nêu hệ quy chiếu, quy tắc và những giả định đã dùng; khi dữ liệu không đủ, phải cho phép kết quả chưa xác định.
5. Quy tắc hiển thị NÊN cho phép cấu hình theo gia phả hoặc người quản trị được ủy quyền. Việc cấu hình cách xưng hô không được sửa đổi quan hệ dữ liệu nền.
6. Danh xưng lịch sử, chức tước hoặc phẩm hàm phải được phân biệt với tên cá nhân và với vai trò hiện tại trong hệ thống.

## 10. Ngày tháng, lịch và địa danh trong dữ liệu gia phả

TFD-201 áp dụng các nguyên tắc nền của TFD-103:

- Bảo toàn cách ghi ngày tháng trong nguồn.
- Phân biệt ngày dương lịch, ngày âm lịch, niên hiệu, ngày ước lượng và khoảng thời gian khi dữ liệu có thông tin đó.
- Không tự bổ sung ngày hoặc tháng còn thiếu.
- Không coi một giá trị ngày đã chuẩn hóa là thay thế cho cách ghi nguyên bản.
- Lưu quy tắc chuyển đổi hoặc diễn giải khi có chuyển đổi lịch.
- Phân biệt địa danh theo thời kỳ và tên địa danh hiện hành; không tự động thay địa danh lịch sử bằng địa danh hiện đại nếu điều đó làm mất ngữ nghĩa.

Các chi tiết cấu trúc, biểu diễn và kiểm chứng ngày tháng thuộc TFD-103. TFD-201 chỉ quy định yêu cầu ngữ nghĩa trong bối cảnh gia phả.

## 11. Quy tắc địa phương và khác biệt giữa các gia phả

### 11.1. Không áp đặt một tập quán duy nhất

Các dòng họ có thể khác nhau về cách tính đời, tiêu chí chi phái, thứ tự con, cách ghi tên, cách dùng danh xưng hoặc cách xác định thành viên. TFD không mặc định một tập quán là đúng cho tất cả.

### 11.2. Khai báo quy tắc địa phương

Một quy tắc địa phương NÊN ghi nhận:

- tên và mã quy tắc;
- phạm vi gia phả/dòng họ/chi phái;
- nội dung quy tắc và các thuật ngữ được dùng;
- nguồn hoặc quyết định làm căn cứ;
- thời kỳ hoặc phiên bản áp dụng;
- người/nhóm chịu trách nhiệm xác nhận;
- trạng thái: dự thảo, đang áp dụng, thay thế hoặc không còn áp dụng;
- các ngoại lệ đã biết.

### 11.3. Quy tắc xung đột

Nếu hai quy tắc khác nhau cùng có vẻ áp dụng cho một người hoặc một quan hệ, hệ thống PHẢI xác định phạm vi của từng quy tắc và không được âm thầm chọn một quy tắc. Có thể hiển thị kết quả theo từng quy tắc, yêu cầu người quản trị xem xét hoặc ghi nhận trạng thái chưa giải quyết.

## 12. Trạng thái dữ liệu và mức độ xác minh

TFD-201 không quy định một điểm số duy nhất để biểu thị độ tin cậy. Các hệ thống PHẢI phân biệt tối thiểu về mặt nghiệp vụ giữa:

- dữ kiện được ghi trực tiếp trong nguồn;
- bản chuẩn hóa hoặc diễn giải;
- khẳng định đã được đánh giá;
- kết luận nghiên cứu được chọn để trình bày;
- thông tin chưa xác minh;
- thông tin đang tranh chấp;
- thông tin đã bị phản bác hoặc thay thế nhưng cần giữ lịch sử.

Trạng thái trên không được làm mất nguồn gốc của khẳng định. Việc chuyển trạng thái PHẢI truy nguyên được nếu ảnh hưởng đến dữ liệu gia phả đã công bố hoặc đã dùng trong các kết quả khác.

## 13. Yêu cầu đối với mô hình dữ liệu

TFD-201 sử dụng các khái niệm logic đã được xác định trong TFD-101; không yêu cầu một tên bảng hoặc công nghệ lưu trữ cụ thể nếu ngữ nghĩa và ràng buộc được bảo toàn.

| Khái niệm | Vai trò trong TFD-201 |
|---|---|
| `Person` | Cá nhân có định danh ổn định |
| `Name` | Các dạng tên và danh xưng của cá nhân |
| `Relationship` / `RelationshipParticipant` | Quan hệ có kiểu và vai trò của các bên |
| `Lineage` | Dòng họ, dòng phả hệ hoặc nhánh theo định nghĩa TFD-101 |
| `LineageMembership` | Tư cách thành viên của cá nhân trong dòng/chi |
| `HouseholdRuleSet` | Bộ quy tắc áp dụng cho gia phả/dòng họ trong phạm vi xác định |
| `GenerationAssignment` | Gán đời/thế hệ theo một quy tắc và phạm vi |
| `Assertion` | Khẳng định có thể kiểm chứng, phản bác hoặc sửa đổi |
| `Source`, `Citation`, `EvidenceAssessment`, `Conclusion` | Nguồn, trích dẫn, đánh giá chứng cứ và kết luận |
| `Event`, `Place`, `PlaceName` | Sự kiện, địa điểm và các tên địa danh |
| `ChangeLog` | Truy nguyên các thay đổi theo khả năng của mô hình triển khai |

### 13.1. Ràng buộc ngữ nghĩa

1. Định danh cá nhân, dòng họ, chi/phái và quy tắc PHẢI ổn định.
2. Gán đời thứ PHẢI tham chiếu được quy tắc và phạm vi áp dụng.
3. Tư cách thành viên PHẢI phân biệt với quan hệ cha/mẹ–con.
4. Các quan hệ gia đình PHẢI có loại/ngữ nghĩa; không dùng một quan hệ không phân biệt cho mọi loại quan hệ.
5. Khẳng định có ý nghĩa gia phả quan trọng NÊN liên kết nguồn hoặc ghi rõ rằng nguồn chưa được cung cấp.
6. Dữ liệu mâu thuẫn hoặc chưa đủ căn cứ PHẢI có cách biểu diễn; không được buộc thành một giá trị chắc chắn.
7. Việc thay đổi quy tắc tính đời không được âm thầm ghi đè lịch sử gán đời trước đó.
8. Sơ đồ và báo cáo phải lấy dữ liệu từ mô hình nền; không được dùng vị trí hiển thị làm dữ liệu quan hệ ngầm.

### 13.2. Ràng buộc không thể chỉ kiểm tra bằng cấu trúc dữ liệu

Một số yêu cầu — như tính hợp lý của việc hợp nhất hồ sơ, độ phù hợp của nguồn hoặc việc áp dụng đúng tập quán địa phương — cần quy trình xem xét, quyền hạn và bằng chứng. Không nên tuyên bố chúng đã được bảo đảm chỉ vì cơ sở dữ liệu có khóa ngoại hoặc ràng buộc duy nhất.

## 14. Yêu cầu hiển thị và báo cáo

1. Giao diện PHẢI phân biệt được thông tin đã xác minh, chưa xác minh và đang tranh chấp nếu trạng thái đó có trong dữ liệu.
2. Khi hiển thị đời thứ, NÊN cho biết dòng/chi hoặc quy tắc đang dùng, nhất là khi người đó có nhiều cách gán đời.
3. Khi hiển thị quan hệ suy diễn, NÊN cho phép người dùng xem chuỗi quan hệ thành phần hoặc nguồn liên quan.
4. Khi hiển thị nhiều tên, nên có tên ưu tiên nhưng vẫn cho phép tra cứu các biến thể.
5. Không được dùng biểu tượng, màu sắc hoặc vị trí sơ đồ khiến người dùng hiểu một giả thuyết là dữ kiện đã xác minh nếu dữ liệu không hỗ trợ kết luận đó.
6. Báo cáo in hoặc xuất PHẢI giữ đủ ngữ cảnh để không làm sai lệch ý nghĩa của đời thứ, chi phái, quan hệ và trạng thái chưa chắc chắn.
7. Nếu lược bỏ ghi chú hoặc nguồn trong một bản trình bày rút gọn, hệ thống NÊN thông báo rõ rằng đây là bản rút gọn.

## 15. Bảo vệ dữ liệu và trách nhiệm quản trị

TFD-201 tuân theo nguyên tắc riêng tư theo mặc định của TFD-001 và các yêu cầu chi tiết của TFD-401.

- Dữ liệu người còn sống PHẢI được xử lý theo chính sách truy cập và công bố phù hợp.
- Không được mặc định mọi dữ liệu trong gia phả đều là dữ liệu công khai.
- Quyền sửa quy tắc đời thứ, thành viên hoặc cấu trúc chi phái NÊN được giới hạn cho vai trò được ủy quyền.
- Các thay đổi có ảnh hưởng lớn — như hợp nhất người, đổi điểm quy chiếu, đổi quy tắc đời hoặc tái cấu trúc chi — NÊN có lịch sử và lý do.
- Việc xuất dữ liệu phải tuân theo TFD-401 và TFD-501; bản xuất không được vượt quyền của người thực hiện.

## 16. Kiểm tra toàn vẹn và xử lý cảnh báo

Hệ thống tuân thủ TFD-201 PHẢI hỗ trợ hoặc chứng minh được các kiểm tra tương ứng với những quy tắc bắt buộc dưới đây. Một cảnh báo không đồng nghĩa với kết luận dữ liệu sai; trong nhiều trường hợp, đó là yêu cầu xem xét của con người.

| Mã | Kiểm tra | Kết quả mong đợi |
|---|---|---|
| GEN-001 | Gán đời thứ không có quy tắc/phạm vi | Từ chối gán như dữ liệu chuẩn đã xác định hoặc đánh dấu chưa xác định và cảnh báo |
| GEN-002 | Cùng một người có nhiều gán đời theo các quy tắc khác nhau | Cho phép lưu nếu phân biệt rõ quy tắc/phạm vi; không ghi đè âm thầm |
| GEN-003 | Hai người cùng họ tên | Không tự động gộp hồ sơ |
| GEN-004 | Hai người cùng họ nhưng chưa có căn cứ quan hệ | Không tự tạo quan hệ huyết thống hoặc cùng chi |
| GEN-005 | Tư cách thành viên chi phái không có nguồn hoặc quy tắc | Cho phép ghi nhận theo chính sách nhưng phải thể hiện căn cứ chưa cung cấp/chưa xác định |
| GEN-006 | Quan hệ cha/mẹ–con chỉ ghi chung chung | Không tự chuyển thành quan hệ sinh học nếu không có căn cứ |
| GEN-007 | Thứ tự danh sách bị dùng làm thứ tự sinh | Cảnh báo hoặc từ chối phép suy diễn không có căn cứ |
| GEN-008 | Mâu thuẫn về trưởng/thứ hoặc thứ tự con | Bảo toàn các khẳng định và nguồn; không âm thầm chọn một phương án |
| GEN-009 | Đổi tên dòng/chi | Giữ nguyên định danh ổn định và lịch sử tên |
| GEN-010 | Tách hoặc hợp nhất chi/phái | Yêu cầu quy tắc/quyết định và bảo toàn lịch sử thay đổi |
| GEN-011 | Hợp nhất cá nhân chỉ vì tên giống nhau | Không tự động hợp nhất |
| GEN-012 | Có nhiều dạng tên hoặc chữ viết | Bảo toàn nguyên bản và các dạng chuẩn hóa riêng biệt |
| GEN-013 | Quy tắc địa phương xung đột | Nêu rõ phạm vi và yêu cầu giải quyết; không âm thầm áp dụng một quy tắc |
| GEN-014 | Quan hệ cha/mẹ–con tạo chu trình | Phát hiện/cảnh báo theo TFD-101/102; không tự xóa quan hệ nguồn |
| GEN-015 | Sơ đồ hiển thị quan hệ suy diễn như quan hệ trực tiếp | Phải phân biệt hoặc cho phép truy nguyên quan hệ thành phần |
| GEN-016 | Xuất bản dữ liệu có trạng thái tranh chấp | Không được trình bày sai thành dữ kiện chắc chắn |

## 17. Bộ ca kiểm thử nghiệm thu

Các ca dưới đây là bộ kiểm thử tối thiểu. TFD-601 sẽ chuẩn hóa cách quản lý mã ca, dữ liệu thử, kết quả thực tế và hồ sơ nghiệm thu.

### TC-201-01 — Đời thứ có phạm vi

**Tiền điều kiện:** Một người có hai bản ghi đời thứ thuộc hai gia phả hoặc bộ quy tắc khác nhau.  
**Thao tác:** Truy vấn đời thứ của người đó theo từng phạm vi.  
**Kết quả mong đợi:** Hệ thống trả về kết quả tương ứng với từng phạm vi và không gộp thành một đời thứ tuyệt đối.

### TC-201-02 — Không tự tính đời khi thiếu quy tắc

**Tiền điều kiện:** Có chuỗi quan hệ nhưng không có bộ quy tắc hoặc điểm quy chiếu được khai báo.  
**Thao tác:** Yêu cầu hệ thống xác định đời thứ.  
**Kết quả mong đợi:** Hệ thống không tuyên bố kết quả là đã xác định; phải trả về trạng thái chưa xác định hoặc cảnh báo rõ.

### TC-201-03 — Thành viên không đồng nghĩa huyết thống

**Tiền điều kiện:** Một cá nhân có bản ghi thành viên trong chi phái nhưng chưa có chuỗi quan hệ huyết thống xác minh.  
**Thao tác:** Xem hồ sơ và truy vấn tổ tiên.  
**Kết quả mong đợi:** Hệ thống giữ tư cách thành viên riêng biệt; không tự tạo chuỗi huyết thống.

### TC-201-04 — Cùng họ không đồng nghĩa cùng chi

**Tiền điều kiện:** Hai hồ sơ có cùng họ hoặc tên dòng họ tương tự, không có khẳng định quan hệ.  
**Thao tác:** Tìm kiếm hoặc nhập dữ liệu.  
**Kết quả mong đợi:** Không tự động liên kết quan hệ hoặc cùng chi chỉ dựa trên tên.

### TC-201-05 — Phân biệt các loại quan hệ cha/mẹ

**Tiền điều kiện:** Một người có khẳng định cha/mẹ nuôi hoặc người nuôi dưỡng.  
**Thao tác:** Truy vấn quan hệ sinh học.  
**Kết quả mong đợi:** Quan hệ nuôi dưỡng không tự động được trả về như quan hệ sinh học.

### TC-201-06 — Nhiều cuộc hôn nhân

**Tiền điều kiện:** Nguồn ghi nhận nhiều cuộc hôn nhân/phối ngẫu của một cá nhân.  
**Thao tác:** Nhập và hiển thị các quan hệ.  
**Kết quả mong đợi:** Hệ thống lưu được nhiều quan hệ, giữ nguồn và không tự suy ra thứ tự hoặc tình trạng pháp lý khi chưa có căn cứ.

### TC-201-07 — Thứ tự con không rõ

**Tiền điều kiện:** Có nhiều con nhưng nguồn không xác định thứ tự sinh.  
**Thao tác:** Hiển thị danh sách con hoặc cây gia phả.  
**Kết quả mong đợi:** Thứ tự trình bày không được ghi nhận ngầm thành thứ tự sinh; dữ liệu cho phép trạng thái chưa xác định.

### TC-201-08 — Mâu thuẫn trưởng/thứ

**Tiền điều kiện:** Hai nguồn ghi nhận khác nhau về thứ tự con.  
**Thao tác:** Nhập cả hai khẳng định và chọn một phương án hiển thị.  
**Kết quả mong đợi:** Cả hai khẳng định và nguồn vẫn được bảo toàn; phương án hiển thị không xóa phương án còn lại.

### TC-201-09 — Nhiều tên của một người

**Tiền điều kiện:** Một người có tên nguyên văn, phiên âm và tên dùng trong tài liệu khác.  
**Thao tác:** Chuẩn hóa tên và chọn tên hiển thị.  
**Kết quả mong đợi:** Tên nguyên văn và các biến thể được giữ lại; tên ưu tiên không thay thế dữ liệu nguồn.

### TC-201-10 — Hai người trùng tên

**Tiền điều kiện:** Hai người có tên giống nhau nhưng dữ liệu khác nhau.  
**Thao tác:** Nhập hoặc xử lý gợi ý trùng hồ sơ.  
**Kết quả mong đợi:** Hệ thống không tự động gộp; nếu có gợi ý thì phải yêu cầu đánh giá thêm căn cứ.

### TC-201-11 — Đổi tên chi phái

**Tiền điều kiện:** Chi phái có định danh ổn định và một tên hiển thị.  
**Thao tác:** Đổi tên hiển thị.  
**Kết quả mong đợi:** Định danh không đổi; tên cũ hoặc lịch sử tên được bảo toàn theo chính sách.

### TC-201-12 — Tách chi phái

**Tiền điều kiện:** Một chi phái được đề nghị tách thành hai nhánh.  
**Thao tác:** Thực hiện thao tác tách.  
**Kết quả mong đợi:** Hệ thống yêu cầu căn cứ/quyết định theo quyền được cấp, giữ lịch sử và không tự động phân bổ mọi thành viên nếu chưa có quy tắc.

### TC-201-13 — Quy tắc địa phương khác nhau

**Tiền điều kiện:** Hai bộ quy tắc đời thứ khác nhau được gán cho hai phạm vi.  
**Thao tác:** Truy vấn cùng một người theo từng phạm vi.  
**Kết quả mong đợi:** Mỗi kết quả phản ánh đúng bộ quy tắc; hệ thống không coi khác biệt là lỗi tự động cần xóa.

### TC-201-14 — Quan hệ suy diễn trên sơ đồ

**Tiền điều kiện:** Một quan hệ tổ tiên–hậu duệ được suy ra từ nhiều quan hệ thành phần.  
**Thao tác:** Hiển thị và xem chi tiết quan hệ.  
**Kết quả mong đợi:** Người dùng có thể phân biệt quan hệ suy diễn với khẳng định trực tiếp và xem được căn cứ thành phần nếu chức năng hỗ trợ.

### TC-201-15 — Chu trình quan hệ

**Tiền điều kiện:** Dữ liệu thử có chu trình trong quan hệ cha/mẹ–con.  
**Thao tác:** Lưu hoặc kiểm tra dữ liệu.  
**Kết quả mong đợi:** Hệ thống phát hiện/cảnh báo theo TFD-101/102; không tự xóa dữ liệu gốc để làm đẹp sơ đồ.

### TC-201-16 — Trạng thái tranh chấp khi xuất báo cáo

**Tiền điều kiện:** Một quan hệ hoặc đời thứ có hai khẳng định chưa được giải quyết.  
**Thao tác:** Xuất báo cáo gia phả.  
**Kết quả mong đợi:** Báo cáo không thể hiện khẳng định đang tranh chấp như một dữ kiện chắc chắn nếu không có chú thích phù hợp.

## 18. Tiêu chí hoàn thành TFD-201

Một triển khai tuyên bố tuân thủ TFD-201 phải chứng minh tối thiểu:

1. Có mô hình tách biệt cá nhân, quan hệ, dòng họ/chi phái, tư cách thành viên và gán đời/thế hệ.
2. Đời thứ luôn có quy tắc và phạm vi hoặc được đánh dấu chưa xác định.
3. Các loại quan hệ gia đình không bị tự động quy đổi thành nhau.
4. Có thể lưu nhiều tên và bảo toàn nguyên văn.
5. Có thể lưu quy tắc địa phương và xử lý quy tắc khác nhau theo phạm vi.
6. Không tự suy ra huyết thống, thứ tự sinh, trưởng/thứ hoặc tư cách thành viên từ tên hoặc cách hiển thị.
7. Có thể bảo toàn các khẳng định mâu thuẫn, trạng thái chưa xác minh và lịch sử thay đổi theo khả năng của mô hình.
8. Giao diện/báo cáo phân biệt được dữ kiện, kết quả suy diễn và thông tin tranh chấp.
9. Các ca kiểm thử bắt buộc đã được thực hiện; kết quả, lỗi còn tồn tại và ngoại lệ được ghi nhận.
10. Các vấn đề phụ thuộc TFD-101, TFD-102, TFD-103, TFD-301, TFD-401 và TFD-501 đã được truy vết; không tuyên bố hoàn thành nếu có xung đột ngữ nghĩa chưa giải quyết ảnh hưởng đến yêu cầu bắt buộc.

## 19. Các vấn đề cần quyết định trước phiên bản 1.0

Các nội dung sau cần chủ sở hữu quy chuẩn và đại diện chuyên môn phê duyệt trước khi tuyên bố đây là quy chuẩn chính thức:

1. Phân biệt thuật ngữ “dòng họ”, “dòng phả hệ”, “chi”, “phái” và “nhánh” trong từ điển thuật ngữ chung của TFD.
2. Danh mục loại quan hệ và mã quan hệ chuẩn dùng xuyên suốt TFD-102 và TFD-201.
3. Các trạng thái chuẩn cho tư cách thành viên và gán đời/thế hệ.
4. Cách biểu diễn phiên bản, hiệu lực thời gian và việc thay thế bộ quy tắc gia phả.
5. Cách quản lý quy tắc địa phương và quyền phê duyệt thay đổi cấu trúc chi phái.
6. Cách xử lý trường hợp một người được ghi nhận thuộc nhiều dòng/chi hoặc có nhiều hệ quy chiếu đời thứ.
7. Mức độ bắt buộc của việc gắn nguồn với tư cách thành viên, đời thứ và quan hệ lịch sử.
8. Danh mục ca kiểm thử bắt buộc cho mọi triển khai so với các ca nâng cao theo lựa chọn.
9. Cách biểu diễn các loại quan hệ hoặc danh xưng lịch sử mà nguồn không cho phép phân loại chắc chắn.
10. Mức tương thích cần đạt với GEDCOM; nội dung ánh xạ cụ thể thuộc TFD-501.

Các mục này là vấn đề mở, không phải quyết định đã được phê duyệt. Trong thời gian chờ, triển khai phải ghi rõ giả định cục bộ và không trình bày giả định đó như quy tắc TFD chung.

## 20. Quan hệ với các tài liệu TFD khác

| Tài liệu | Phần TFD-201 kế thừa hoặc chuyển giao |
|---|---|
| TFD-001 | Nguyên tắc quy chuẩn, phạm vi, tính thận trọng, quyền riêng tư, khả năng kiểm thử |
| TFD-101 | Mô hình logic `Person`, `Relationship`, `Lineage`, `LineageMembership`, `HouseholdRuleSet`, `GenerationAssignment` và các ràng buộc dữ liệu |
| TFD-102 | Định danh ổn định, kiểu quan hệ, hợp nhất hồ sơ, đời thứ, thứ tự con, quan hệ và dữ liệu Việt Nam/Hán-Nôm |
| TFD-103 | Sự kiện, niên đại, lịch âm/dương, nguồn, trích dẫn, khẳng định, đánh giá chứng cứ và lịch sử chỉnh sửa |
| TFD-301 | Quy trình tiếp nhận nguồn, đánh giá chứng cứ, quản lý dị bản và giải quyết mâu thuẫn |
| TFD-401 | Quyền truy cập, dữ liệu người còn sống, kiểm soát thay đổi và trách nhiệm quản trị |
| TFD-501 | Ánh xạ sang GEDCOM, phần mở rộng và báo cáo thông tin không chuyển đổi đầy đủ |
| TFD-601 | Bộ kiểm thử tuân thủ, mức độ nghiêm trọng và tiêu chí nghiệm thu xuyên tài liệu |

Nếu có xung đột giữa TFD-201 và tài liệu nền, không được tự ý sửa lược đồ hoặc thay đổi ngữ nghĩa để giải quyết. Phải ghi nhận xung đột, xác định tài liệu chịu trách nhiệm và đưa ra quyết định quản lý phiên bản.

## Phụ lục A — Ví dụ minh họa

Các ví dụ sau chỉ minh họa cách áp dụng quy tắc; không thiết lập tập quán chung cho mọi dòng họ.

### A.1. Một người có hai cách ghi đời thứ

Một gia phả ghi một người là đời thứ 8 tính từ tổ được chọn trong tài liệu A; một gia phả khác ghi là đời thứ 9 theo điểm quy chiếu trong tài liệu B. Hệ thống lưu hai `GenerationAssignment` khác nhau, mỗi bản ghi tham chiếu quy tắc và phạm vi tương ứng. Không tự động chọn một con số làm giá trị tuyệt đối.

### A.2. Thành viên dòng họ nhưng thiếu chuỗi huyết thống

Một danh sách thành viên của dòng họ có ghi một cá nhân, nhưng hiện chưa tìm được tài liệu thể hiện đầy đủ quan hệ cha/mẹ qua các đời. Hệ thống có thể lưu tư cách thành viên theo nguồn danh sách, đồng thời đánh dấu chuỗi quan hệ huyết thống là chưa xác định. Không được tự tạo các quan hệ trung gian để nối cây.

### A.3. Tên khác nhau trong các tài liệu

Một bia ghi tên bằng chữ Hán/Nôm, một bản chép ghi cách đọc khác và một tài liệu sau này dùng tên thường gọi. Hệ thống giữ ảnh/bản nguồn, bản chép, các cách đọc và tên hiển thị riêng. Việc xác định các dạng tên có cùng chỉ một người phải dựa trên đánh giá căn cứ, không chỉ trên sự tương tự.

### A.4. Thứ tự con không chắc chắn

Một gia phả liệt kê ba người con theo một thứ tự nhưng không nói đó là thứ tự sinh. Hệ thống giữ thứ tự trình bày của nguồn như thông tin nguồn, không tự gán người đứng đầu là con trưởng hoặc người sinh trước.

### A.5. Hai quy ước thành viên khác nhau

Một quy ước của chi A có tiêu chí thành viên riêng; một quy ước của chi B sử dụng tiêu chí khác. Hệ thống quản lý hai quy tắc theo hai phạm vi. Nếu một trường hợp có thể thuộc cả hai phạm vi, cần áp dụng đúng các quy tắc đã được công bố và giữ lại mọi bất đồng chưa giải quyết.

## Phụ lục B — Tài liệu tham chiếu

1. TFD-001 — Tổng quan và nguyên tắc quy chuẩn, bản dự thảo 0.1 ngày 20/10/2026.
2. TFD-101 — Mô hình dữ liệu, bản dự thảo 0.1 ngày 20/10/2026.
3. TFD-102 — Quy tắc định danh và quan hệ, bản dự thảo 0.1.
4. TFD-103 — Quy tắc sự kiện, niên đại và nguồn chứng cứ, bản dự thảo 0.1 ngày 20/10/2026.
5. GEDCOM 7.0 và các tài liệu liên quan được TFD-501 xác định là chuẩn trao đổi được hỗ trợ.

Các tài liệu tham chiếu nêu trên không tự động làm cho TFD-201 trở thành tiêu chuẩn đã được phê duyệt. Tính áp dụng của từng tài liệu và phiên bản cụ thể cần được xác định trong quy trình quản lý quy chuẩn.

## Phụ lục C — Tuyên bố trạng thái

TFD-201 phiên bản 0.1 là dự thảo để rà soát và thử nghiệm. Các yêu cầu có từ khóa PHẢI/KHÔNG ĐƯỢC thể hiện đề xuất nội dung quy chuẩn trong bản dự thảo này; chúng chỉ trở thành yêu cầu chính thức sau khi quy trình phê duyệt TFD xác nhận phiên bản tương ứng.
