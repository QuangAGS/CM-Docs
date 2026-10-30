# TFD-001 — Tổng quan và nguyên tắc quy chuẩn

**Mã tài liệu:** TFD-001  
**Tên bộ quy chuẩn:** Family Tree Doctrine (TFD)  
**Phiên bản:** 0.1 — Dự thảo để thẩm định  
**Ngày phát hành dự thảo:** 20/10/2026  
**Trạng thái:** Dự thảo; chưa được phê duyệt hoặc ban hành chính thức  
**Chủ sở hữu quy chuẩn:** Chưa chỉ định  
**Tài liệu liên quan:** TFD-101 — Mô hình dữ liệu; các tài liệu TFD-102 trở đi dự kiến

---

## Kiểm soát tài liệu

| Thuộc tính | Giá trị |
|---|---|
| Mục đích | Định nghĩa nền tảng, phạm vi, nguyên tắc và cơ chế quản trị của TFD |
| Đối tượng sử dụng | Chủ dự án, chuyên gia gia phả, nhà nghiên cứu Hán Nôm, kiến trúc sư dữ liệu, kỹ sư phần mềm, quản trị viên và người biên tập |
| Phân loại | Đặc tả quy chuẩn dự thảo |
| Ngôn ngữ chuẩn | Tiếng Việt; thuật ngữ tiếng Anh dùng trong ngoặc khi cần |
| Quy tắc diễn giải | “PHẢI” là yêu cầu bắt buộc; “NÊN” là khuyến nghị; “CÓ THỂ” là lựa chọn được phép |
| Phê duyệt | Chưa phê duyệt |

## Lịch sử phiên bản

| Phiên bản | Ngày | Nội dung |
|---|---|---|
| 0.1 | 20/10/2026 | Bản dự thảo đầu tiên, làm nền tảng cho TFD-101 |

## 1. Tóm tắt

Family Tree Doctrine (TFD) là bộ quy chuẩn đề xuất để chuẩn hóa việc mô hình hóa, ghi nhận, kiểm chứng, lưu trữ, trao đổi và trình bày dữ liệu gia phả, với trọng tâm là gia phả Việt Nam. TFD kết hợp:

1. Các chuẩn và thông lệ quốc tế có liên quan, đặc biệt là GEDCOM cho trao đổi dữ liệu phả hệ.
2. Mô hình dữ liệu độc lập với một sản phẩm hoặc nhà cung cấp cụ thể.
3. Các quy tắc nghiệp vụ dành cho tên gọi, thế hệ, chi phái, quan hệ huyết thống và quan hệ xã hội, ngày âm lịch, địa danh lịch sử, văn bản Hán Nôm và dị bản.
4. Quản lý nguồn tư liệu, chứng cứ, mức độ chắc chắn và lịch sử thay đổi.
5. Bảo vệ dữ liệu cá nhân, quản trị quyền truy cập và bảo toàn dữ liệu lâu dài.

TFD không mặc định rằng một bản gia phả là hoàn toàn chính xác; cũng không mặc định mọi quan hệ xã hội hoặc truyền thống dòng họ đều có thể suy ra từ quan hệ sinh học. Hệ thống phải lưu được dữ kiện, nguồn, cách diễn giải và kết luận như các lớp thông tin phân biệt.

## 2. Mục tiêu

TFD hướng tới các mục tiêu sau:

- **Tính nhất quán:** dữ liệu được biểu diễn theo quy tắc thống nhất giữa các dự án và phần mềm.
- **Khả năng truy nguyên:** thông tin quan trọng có thể truy ngược về nguồn, vị trí trích dẫn và lịch sử xử lý.
- **Bảo toàn nguyên bản:** giữ nguyên chữ viết, văn bản, tên gọi và cách ghi trong tài liệu gốc bên cạnh bản chuẩn hóa.
- **Tương thích:** cho phép trao đổi dữ liệu bằng GEDCOM và các định dạng được quy định sau này, đồng thời báo cáo phần mở rộng không thể biểu diễn đầy đủ.
- **Tính thận trọng:** không tự tạo dữ kiện hoặc chuyển điều chưa biết thành sự thật.
- **Khả năng mở rộng:** hỗ trợ nhiều dòng họ, vùng miền, thời kỳ, hệ thống danh xưng và quy tắc địa phương.
- **Bảo mật và quyền riêng tư:** hạn chế dữ liệu cá nhân không cần thiết, đặc biệt với người còn sống.
- **Khả năng kiểm thử:** yêu cầu được diễn đạt sao cho có thể kiểm tra bằng quy tắc, dữ liệu mẫu và tiêu chí nghiệm thu.

## 3. Phạm vi

### 3.1. Trong phạm vi

TFD quy định hoặc định hướng quy định về:

- Cá nhân, tên gọi và các dạng tên.
- Quan hệ cha mẹ–con, quan hệ huyết thống, nhận nuôi, hôn nhân và các quan hệ được ghi nhận khác.
- Sự kiện đời người và sự kiện gia đình.
- Địa điểm và tên địa danh qua các thời kỳ.
- Nguồn tư liệu, trích dẫn, mệnh đề, chứng cứ và kết luận nghiên cứu.
- Thế hệ, thủy tổ, tiên tổ, chi phái, trưởng/thứ khi có quy tắc và căn cứ.
- Văn bản Hán Nôm, phiên âm, dịch nghĩa, bản chép và ảnh chụp.
- Lịch âm, lịch dương, ngày tháng không đầy đủ hoặc không chắc chắn.
- Định danh, chất lượng dữ liệu, lịch sử thay đổi, phân quyền, sao lưu.
- Nhập/xuất, ánh xạ dữ liệu và kiểm thử tuân thủ.

### 3.2. Ngoài phạm vi hoặc cần quy chuẩn riêng

- Phán quyết pháp lý về huyết thống, thừa kế, quốc tịch hoặc quyền nhân thân.
- Xác thực tuyệt đối tính chân thực của tài liệu lịch sử chỉ bằng phần mềm.
- Quy định thống nhất nghi lễ, tín ngưỡng hoặc tập quán của mọi dòng họ.
- Tự động quyết định ai là trưởng họ, trưởng chi hoặc người kế tự nếu không có quy tắc được dòng họ thông qua.
- Công khai mặc định toàn bộ dữ liệu về người còn sống.
- Thay thế chuyên gia sử học, gia phả học, Hán Nôm hoặc tư vấn pháp lý.

## 4. Đối tượng và thuật ngữ

### 4.1. Thuật ngữ chính

- **Cá nhân (Person):** hồ sơ định danh một người; không đồng nhất với một dòng tên trong một tài liệu.
- **Tên (Name):** một dạng tên gắn với cá nhân, có thể gồm tên khai sinh, tên húy, tên tự, tên hiệu, tên thụy, tên thường gọi, tên chữ Hán/Nôm hoặc biến thể.
- **Quan hệ (Relationship):** liên kết có kiểu rõ ràng giữa các cá nhân hoặc giữa cá nhân với gia đình/nhóm.
- **Sự kiện (Event):** việc xảy ra có thời gian, địa điểm và chủ thể liên quan, ví dụ sinh, mất, kết hôn, an táng, di cư hoặc phong tặng.
- **Nguồn (Source):** tài liệu, hiện vật, lời kể, hồ sơ hoặc tập dữ liệu được dùng làm căn cứ.
- **Trích dẫn (Citation):** chỉ dẫn cụ thể đến phần của nguồn hỗ trợ một mệnh đề.
- **Mệnh đề (Assertion):** phát biểu có thể đánh giá, ví dụ “A là cha của B” hoặc “A mất năm 1890”.
- **Chứng cứ (Evidence):** nội dung nguồn được đánh giá là hỗ trợ, phản bác hoặc không quyết định một mệnh đề.
- **Kết luận (Conclusion):** nhận định sau quá trình đối chiếu và đánh giá chứng cứ.
- **Dòng phả hệ (Lineage):** cấu trúc phân nhánh hoặc tư cách thành viên trong một hệ thống gia phả, có quy tắc và nguồn căn cứ.
- **Bản ghi nguyên văn (Verbatim record):** nội dung được chép đúng theo tài liệu, giữ dấu hiệu bất thường nếu có.
- **Chuẩn hóa (Normalization):** tạo biểu diễn nhất quán nhưng không xóa bản ghi nguyên văn.
- **Dị bản (Variant):** các cách ghi khác nhau của cùng một nội dung hoặc các giả thuyết khác nhau chưa thể đồng nhất.
- **Chưa biết (Unknown):** chưa có giá trị xác định.
- **Chưa xác minh (Unverified):** có thông tin nhưng chưa đủ quy trình đánh giá.
- **Không có trong nguồn đã kiểm tra (Not found in searched source):** kết quả của một lần tra cứu có phạm vi cụ thể; không đồng nghĩa với “không tồn tại”.

### 4.2. Phân biệt dữ kiện, diễn giải và kết luận

TFD PHẢI phân biệt tối thiểu:
1. Nội dung được ghi trong nguồn.
2. Bản phiên âm hoặc dịch nghĩa.
3. Mệnh đề được rút ra từ nguồn.
4. Đánh giá chứng cứ.
5. Kết luận của người nghiên cứu.
6. Trạng thái phê duyệt của kết luận trong dự án.

Một bản ghi không được nâng trạng thái từ “truyền khẩu” lên “đã xác minh” chỉ vì đã nhập vào phần mềm.

## 5. Nguyên tắc quy chuẩn

### P-01. Định danh ổn định

Mỗi cá nhân, nguồn, sự kiện, địa điểm và quan hệ được quản lý phải có định danh ổn định, duy nhất trong phạm vi hệ thống. Định danh không được tạo từ họ tên, ngày sinh hoặc vị trí trong cây.

### P-02. Không suy diễn khi thiếu chứng cứ

Phần mềm không được tự kết luận quan hệ huyết thống chỉ dựa trên họ, tên, địa điểm hoặc sự trùng hợp ngày tháng. Các gợi ý tự động phải được đánh dấu là gợi ý chưa xác minh.

### P-03. Nguyên bản được bảo toàn

Dữ liệu gốc, ảnh chụp, chữ Hán/Nôm, cách ghi cổ, dấu câu và sai biệt quan trọng phải được giữ nguyên hoặc lưu trong bản chụp/bản phiên chép có kiểm soát. Chuẩn hóa không được ghi đè nguyên bản.

### P-04. Nguồn gắn với mệnh đề

Các khẳng định quan trọng về quan hệ, ngày tháng, danh xưng, địa điểm và sự kiện NÊN gắn với nguồn và trích dẫn cụ thể. Khi chưa có nguồn, trạng thái phải thể hiện rõ.

### P-05. Mô hình quan hệ có kiểu

Quan hệ sinh học, quan hệ pháp lý, quan hệ nhận nuôi, quan hệ hôn nhân, quan hệ xã hội và tư cách trong dòng họ PHẢI được phân biệt. Không gộp tất cả thành một liên kết “cha/mẹ” chung không có ngữ nghĩa.

### P-06. Không ép dữ liệu bất định thành giá trị chính xác

Hệ thống PHẢI hỗ trợ ngày/thời kỳ không đầy đủ, xấp xỉ, khoảng thời gian và giá trị đang tranh chấp. Không tự chuyển ngày âm lịch sang dương lịch nếu thiếu thông tin cần thiết như loại lịch, năm và quy tắc chuyển đổi.

### P-07. Độc lập giữa dữ liệu và cách hiển thị

Sơ đồ cây, bảng thế hệ, danh sách chi phái và bản in là các cách trình bày từ dữ liệu. Thay đổi bố cục hoặc cách sắp xếp không được làm thay đổi quan hệ dữ liệu gốc.

### P-08. Quy tắc dòng họ có phạm vi

Quy tắc về thế hệ, trưởng/thứ, phân chi, người kế tự và cách tính đời PHẢI được gắn với một bộ gia phả hoặc quy ước dòng họ cụ thể, có phiên bản và nguồn căn cứ. Không mặc định một quy tắc áp dụng cho mọi dòng họ.

### P-09. Truy nguyên và lịch sử thay đổi

Các thay đổi quan trọng PHẢI có người thực hiện, thời điểm, nội dung trước/sau và lý do hoặc tham chiếu đến yêu cầu sửa đổi. Không xóa âm thầm kết luận đã được công bố.

### P-10. Tương thích có báo cáo

Khi nhập/xuất GEDCOM hoặc định dạng khác, hệ thống PHẢI báo cáo dữ liệu được chuyển đổi, dữ liệu được mở rộng, dữ liệu bị lược bỏ và dữ liệu cần xử lý thủ công. Không tuyên bố tương thích hoàn toàn nếu có mất mát ngữ nghĩa.

### P-11. Riêng tư theo mặc định

Dữ liệu cá nhân của người còn sống phải được giới hạn theo mục đích và quyền truy cập. Bản xuất công khai phải áp dụng chính sách ẩn/giảm thiểu dữ liệu được cấu hình và ghi lại.

### P-12. Khả năng kiểm thử

Mỗi yêu cầu bắt buộc PHẢI có tiêu chí nghiệm thu hoặc cách kiểm tra xác định. Các yêu cầu mơ hồ như “dễ sử dụng” phải được chuyển thành tiêu chí kiểm thử phù hợp trước khi phát hành.

### P-13. Tách biệt sự thật lịch sử và quy ước trình bày

Màu sắc, vị trí trên cây, số đời hiển thị hoặc cách viết danh xưng không tự thân là chứng cứ lịch sử. Phần mềm phải phân biệt thuộc tính dữ liệu với quy ước hiển thị.

### P-14. Không xóa bất đồng

Khi nguồn mâu thuẫn, TFD ưu tiên lưu các phát biểu cạnh tranh và kết quả đánh giá. Hệ thống có thể chỉ định một giá trị hiển thị mặc định nhưng phải bảo toàn lịch sử và căn cứ.

## 6. Quy tắc nghiệp vụ dành cho gia phả Việt Nam

### 6.1. Tên và danh xưng

- Một cá nhân CÓ THỂ có nhiều tên, với loại tên và khoảng thời gian sử dụng riêng.
- Tên nguyên văn trong nguồn và tên chuẩn hóa PHẢI là các giá trị tách biệt.
- Tên chữ Hán/Nôm, phiên âm Hán Việt, phiên âm ngôn ngữ khác và bản dịch nghĩa không được gộp vào một trường duy nhất.
- Không suy đoán tên khai sinh từ tên tự, tên hiệu hoặc tên thụy.
- Cách viết không chắc chắn phải được lưu như một biến thể có nguồn.

### 6.2. Thế hệ và chi phái

- Số thế hệ ghi trong gia phả là một thuộc tính theo quy ước hoặc nguồn; không nhất thiết bằng khoảng cách cạnh trong đồ thị sinh học.
- Hệ thống phải cho phép cùng một người xuất hiện trong nhiều bản phả hoặc nhiều cách phân nhánh mà vẫn có thể liên kết tới một hồ sơ cá nhân chung khi đủ căn cứ.
- Tư cách “trưởng chi”, “chi trưởng”, “chi thứ”, “kế tự” hoặc “nhập phả” phải có nguồn hoặc quyết định/quy ước được ghi nhận.
- Không tự động gán thứ tự trưởng/thứ từ tuổi, ngày sinh hoặc giới tính.
- Quy tắc tính đời phải được khai báo rõ: lấy ai làm tổ, loại quan hệ nào được tính, cách xử lý con nuôi, người nhập phả và nhánh không rõ.

### 6.3. Quan hệ

- Quan hệ cha/mẹ–con cần cho biết loại quan hệ nếu biết: sinh học, nhận nuôi, pháp lý, xã hội hoặc được ghi trong gia phả nhưng chưa xác định bản chất.
- Hôn nhân và các quan hệ phối ngẫu được ghi thành các thực thể/quan hệ riêng, có thời gian và nguồn nếu biết.
- Không suy ra quan hệ cha mẹ từ quan hệ hôn nhân.
- Có thể lưu một quan hệ được văn bản ghi nhận ngay cả khi chưa thể xác minh theo chuẩn nghiên cứu hiện đại; trạng thái chứng cứ phải thể hiện điều đó.

### 6.4. Ngày tháng và lịch

- Lưu nguyên văn cách ghi ngày tháng trong nguồn.
- Khi có thể xác định, lưu loại lịch, thành phần ngày/tháng/năm, mức độ chính xác và quy tắc chuyển đổi.
- Ngày âm lịch và ngày dương lịch là các biểu diễn liên quan nhưng không được ghi đè lẫn nhau.
- Các trường hợp “khoảng”, “trước”, “sau”, “ước chừng”, “không muộn hơn” phải được mô hình hóa, không biến thành ngày chính xác giả tạo.

### 6.5. Địa danh lịch sử

- Lưu tên địa danh như nguồn ghi và tên hiện đại nếu xác định được.
- Thay đổi địa giới, tên làng/xã/tổng/huyện/tỉnh phải có thời kỳ hiệu lực hoặc ghi chú về độ bất định.
- Không tự gán một địa danh lịch sử vào đơn vị hành chính hiện tại chỉ vì tên gần giống.

### 6.6. Nguồn và bản dịch

- Ảnh nguồn, bản chép, phiên âm, bản dịch và bản hiệu đính phải được phân biệt.
- Ghi người thực hiện, thời điểm và phương pháp nếu biết.
- Các chỗ mất chữ, chữ không đọc được hoặc phần phục nguyên phải được đánh dấu.
- Trích dẫn phải chỉ tới trang, tờ, mặt bia, dòng hoặc vị trí tương đương nếu khả dụng.

## 7. Yêu cầu tương thích và kiến trúc

### 7.1. GEDCOM

TFD sử dụng GEDCOM làm định dạng trao đổi ưu tiên cho dữ liệu gia phả thông dụng. Việc hỗ trợ phiên bản GEDCOM cụ thể phải được ghi rõ trong tuyên bố tuân thủ của phần mềm.

Các phần mở rộng đặc thù Việt Nam PHẢI:
- Có quy tắc ánh xạ rõ ràng.
- Không ghi đè dữ liệu chuẩn bằng dữ liệu mở rộng.
- Có thể bảo toàn qua quy trình xuất/nhập vòng lặp nếu định dạng cho phép.
- Được liệt kê trong báo cáo mất mát hoặc chuyển đổi.

### 7.2. Kiến trúc triển khai

TFD không bắt buộc một hệ quản trị cơ sở dữ liệu cụ thể. Mô hình quan hệ được khuyến nghị cho tính toàn vẹn; truy vấn đồ thị có thể được triển khai qua truy vấn đệ quy, chỉ mục hoặc hệ thống đồ thị riêng khi cần. Dữ liệu chuẩn không được phụ thuộc vào một công cụ trực quan hóa duy nhất.

### 7.3. Mã hóa và ngôn ngữ

- Hệ thống nên dùng Unicode và bảo toàn ký tự tiếng Việt cùng chữ Hán/Nôm.
- Bản gốc, phiên âm, dịch nghĩa và dạng tìm kiếm chuẩn hóa cần được lưu tách biệt.
- Chuẩn hóa Unicode phục vụ tìm kiếm không được làm mất dạng gốc cần bảo tồn.
- Quy tắc sắp xếp theo âm đọc, chữ viết hoặc thứ bậc phải được cấu hình và công bố.

## 8. Chất lượng dữ liệu và trạng thái xác minh

TFD đề xuất các trạng thái cho mệnh đề hoặc kết luận, không phải nhãn chất lượng tuyệt đối của một người:

- `U` — Chưa xác minh.
- `T` — Ghi nhận từ truyền khẩu/truyền tụng.
- `S` — Có nguồn hỗ trợ.
- `C` — Đã đối chiếu nguồn.
- `P` — Kết luận đạt tiêu chí chứng minh đã quy định.
- `D` — Có tranh chấp/chưa giải quyết.

Các trạng thái này là phân loại đề xuất của TFD, không phải phân loại chính thức của GEDCOM. Dự án triển khai phải định nghĩa tiêu chí, quyền thay đổi trạng thái và lịch sử đánh giá. Trạng thái `P` không có nghĩa là chân lý tuyệt đối; nó có nghĩa quy trình chứng minh đã được đáp ứng theo tiêu chí đã công bố.

## 9. Bảo mật, quyền riêng tư và quản trị

- Phân quyền theo vai trò và phạm vi dữ liệu.
- Tối thiểu hóa dữ liệu người còn sống và hạn chế xuất công khai.
- Có nhật ký truy cập/sửa đổi phù hợp với mức rủi ro.
- Có quy trình sửa dữ liệu sai, phản đối kết luận và khôi phục phiên bản.
- Mã hóa khi truyền và khi lưu trữ nếu phù hợp với kiến trúc và mức rủi ro.
- Định kỳ kiểm thử sao lưu và khôi phục.
- Quyền truy cập không được mặc định cấp chỉ vì người dùng thuộc cùng dòng họ.
- Việc thu thập, xử lý, công bố và chia sẻ dữ liệu phải được rà soát theo pháp luật hiện hành và quyền của chủ thể dữ liệu.

## 10. Quy trình quản lý quy chuẩn

1. **Đề xuất:** ghi vấn đề, lý do, phạm vi và tác động.
2. **Phân tích:** đánh giá tương thích, ảnh hưởng tới dữ liệu cũ, bảo mật và quy tắc dòng họ.
3. **Tham vấn:** chuyên gia gia phả, Hán Nôm, nghiệp vụ, dữ liệu và đại diện người sử dụng.
4. **Thử nghiệm:** kiểm tra trên tập dữ liệu mẫu có trường hợp đơn giản và ngoại lệ.
5. **Phê duyệt:** người/cơ quan quản trị quy chuẩn phê duyệt bằng quyết định có lưu vết.
6. **Phát hành:** gắn phiên bản, ngày hiệu lực, ghi chú thay đổi và tài liệu chuyển đổi.
7. **Duy trì:** tiếp nhận lỗi, phát hành bản sửa đổi và bảo đảm khả năng đọc dữ liệu cũ.

### 10.1. Chính sách phiên bản đề xuất

- **Major:** thay đổi phá vỡ tương thích hoặc thay đổi ngữ nghĩa cốt lõi.
- **Minor:** bổ sung trường/quy tắc tương thích ngược.
- **Patch:** sửa lỗi diễn đạt hoặc lỗi không thay đổi ngữ nghĩa.

Đây là chính sách phiên bản đề xuất và cần được cơ quan quản trị TFD phê duyệt.

## 11. Yêu cầu nghiệm thu TFD-001

TFD-001 được chấp nhận khi:
- Phạm vi, thuật ngữ và nguyên tắc không mâu thuẫn với TFD-101.
- Các từ “PHẢI”, “NÊN”, “CÓ THỂ” được sử dụng nhất quán.
- Mỗi nguyên tắc bắt buộc có thể ánh xạ đến ít nhất một yêu cầu dữ liệu, quy trình hoặc kiểm thử.
- Phần mở rộng Việt Nam được phân biệt với nội dung kế thừa từ tiêu chuẩn quốc tế.
- Có quy trình quản lý phiên bản và phê duyệt.
- Có rà soát về dữ liệu cá nhân và rủi ro mất mát khi nhập/xuất.

## 12. Các quyết định cần phê duyệt trước phiên bản 1.0

1. Tổ chức/cá nhân sở hữu và quản trị TFD.
2. Có bắt buộc lưu mọi mệnh đề cùng nguồn hay chỉ các mệnh đề trọng yếu.
3. Bộ trạng thái chứng cứ chính thức và tiêu chí chuyển trạng thái.
4. Quy tắc mô hình hóa “gia đình”, “hôn nhân” và các quan hệ lịch sử.
5. Cách biểu diễn lịch âm, niên hiệu và ngày không đầy đủ.
6. Cách quản lý nhiều hệ thống phân chi và quy tắc tính đời.
7. Phiên bản GEDCOM bắt buộc hỗ trợ.
8. Chính sách dữ liệu người còn sống, quyền truy cập và công khai.
9. Yêu cầu lưu trữ dài hạn, bản quyền và định dạng ảnh/tài liệu.
10. Quy trình giải quyết bất đồng và phê duyệt kết luận phả hệ.

## Phụ lục A — Tài liệu tham khảo nền tảng

- FamilySearch GEDCOM: https://gedcom.io/specifications/FamilySearchGEDCOMv7.html
- GEDCOM specifications: https://gedcom.io/specs/
- GEDCOM X: https://developers.familysearch.org/main/docs/gedcom-x
- Board for Certification of Genealogists — Ethics & Standards: https://www.bcgcertification.org/ethics-standards

Các nguồn trên là tài liệu tham khảo để thiết kế TFD; việc viện dẫn không có nghĩa TFD được các tổ chức đó chứng nhận hoặc bảo trợ.

## Phụ lục B — Tuyên bố trạng thái

Tài liệu này là dự thảo quy chuẩn do dự án TFD đề xuất. Nó chưa phải tiêu chuẩn quốc gia, tiêu chuẩn quốc tế, văn bản pháp luật hoặc quy chuẩn đã được một tổ chức độc lập chứng nhận. Các quy tắc đặc thù cần được thẩm định bằng dữ liệu gia phả thực tế và thông qua bởi cơ quan quản trị được chỉ định.
