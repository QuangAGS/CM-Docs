# TFD-301 — Quy trình quản lý nguồn, chứng cứ và dị bản

## Kiểm soát tài liệu

| Trường | Giá trị |
|---|---|
| Mã tài liệu | TFD-301 |
| Tên | TFD-301 — Quy trình quản lý nguồn, chứng cứ và dị bản |
| Phiên bản | 0.1 — Dự thảo để thảo luận và thử nghiệm |
| Ngày | 20-10-2026 |
| Trạng thái | Dự thảo; chưa phải tiêu chuẩn chính thức |
| Phạm vi | Quy trình tiếp nhận, mô tả, số hóa, phiên âm, trích dẫn, lập nhận định, đánh giá chứng cứ, quản lý mâu thuẫn, dị bản và kết luận trong dữ liệu gia phả. |
| Tài liệu nền | TFD-001 — Tổng quan và nguyên tắc quy chuẩn; TFD-101 — Mô hình dữ liệu; TFD-102 — Quy tắc định danh và quan hệ; TFD-103 — Quy tắc sự kiện, niên đại và nguồn chứng cứ; TFD-201 — Quy tắc gia phả Việt Nam và chi phái. |
| Đối tượng áp dụng | Người quản lý gia phả, người nhập liệu, người phiên âm/dịch thuật, người nghiên cứu, người thẩm định, nhà phát triển hệ thống và đơn vị lưu trữ. |

> **Quy ước từ ngữ:** “PHẢI”, “KHÔNG ĐƯỢC”, “BẮT BUỘC” biểu thị yêu cầu bắt buộc trong phạm vi áp dụng; “NÊN” là khuyến nghị mạnh; “CÓ THỂ” là lựa chọn được phép. Các mã trạng thái và ngưỡng trong bản dự thảo chỉ là đề xuất cho tới khi được phê duyệt trong bộ TFD.

## 1. Mục đích

TFD-301 quy định cách một hệ thống gia phả tiếp nhận, bảo quản và sử dụng nguồn tư liệu để tạo lập, đánh giá, công bố hoặc sửa đổi các nhận định về cá nhân, quan hệ, sự kiện, niên đại, địa điểm, dòng phả hệ và chi phái.

Mục tiêu chính:

1. Bảo toàn nguồn và xuất xứ của nguồn; không làm mất dấu bản gốc, bản sao, bản dịch hoặc bản chép lại.
2. Phân biệt nội dung nguồn với cách phiên âm, dịch, chuẩn hóa, diễn giải và kết luận của người nghiên cứu.
3. Bảo đảm mỗi nhận định quan trọng có thể truy nguyên tới vị trí chứng cứ hoặc ghi rõ vì sao chưa có chứng cứ.
4. Cho phép các nguồn và nhận định mâu thuẫn cùng tồn tại mà không buộc chọn một bên quá sớm.
5. Quản lý dị bản tên người, địa danh, niên đại, quan hệ và nội dung gia phả theo cách có thể kiểm tra và sửa đổi.
6. Lưu lại ai đã làm gì, dựa trên căn cứ nào, vào thời điểm nào và theo quy tắc nào.
7. Hỗ trợ việc thẩm định có trách nhiệm, công bố đúng mức độ chắc chắn và bảo vệ tư liệu nhạy cảm.

TFD-301 là quy trình quản lý tri thức và chứng cứ; không phải một phán quyết về lịch sử, không xác nhận tính xác thực của mọi tư liệu được nhập và không thay thế chuyên môn Hán Nôm, lịch sử, văn bản học, lưu trữ hoặc pháp lý.

## 2. Phạm vi và giới hạn

### 2.1 Trong phạm vi

- Tiếp nhận nguồn vật lý, nguồn số, lời kể, dữ liệu có cấu trúc và nguồn được cung cấp bởi bên thứ ba.
- Đăng ký nguồn, nơi lưu giữ, chủ thể cung cấp, nguồn gốc được khai báo, quyền sử dụng và điều kiện truy cập.
- Tạo bản số hóa, bản sao làm việc, phiên âm, bản dịch, ghi chú và mô tả vật mang tin.
- Tạo citation/trích dẫn định vị nội dung cụ thể trong nguồn.
- Tách các mệnh đề có thể kiểm tra thành assertion/nhận định độc lập.
- Liên kết chứng cứ với nhận định theo vai trò hỗ trợ, phản bác, bối cảnh hoặc chưa xác định.
- Đánh giá chất lượng, tính độc lập, độ trực tiếp, độ đầy đủ và giới hạn của nguồn.
- Quản lý mâu thuẫn, dị bản, giả thuyết, kết luận tạm thời và quyết định biên tập.
- Sửa đổi, thay thế, rút lại hoặc mở lại nhận định nhưng vẫn giữ lịch sử.
- Kiểm soát quyền truy cập, xuất bản, sao lưu và kiểm tra toàn vẹn theo chính sách liên quan.

### 2.2 Ngoài phạm vi

- Quy định toàn bộ mô hình dữ liệu kỹ thuật, được xác định chủ yếu trong TFD-101.
- Quy định chi tiết mọi loại quan hệ và quy tắc định danh, thuộc TFD-102.
- Quy tắc chi tiết về mô hình sự kiện, niên đại và lịch, thuộc TFD-103.
- Quy tắc dòng họ, thế hệ, chi/phái và tập quán địa phương, thuộc TFD-201.
- Quy định đầy đủ về bảo mật, phân quyền và quản trị, thuộc TFD-401.
- Quy tắc chuyển đổi GEDCOM và xử lý mất mát khi trao đổi dữ liệu, thuộc TFD-501.
- Bộ kiểm thử tuân thủ chính thức và quy trình chứng nhận, thuộc TFD-601.

Khi tài liệu liên quan chưa chốt một mã, trạng thái hoặc quy tắc, triển khai PHẢI ghi nhận đó là quyết định còn mở; KHÔNG ĐƯỢC tự trình bày lựa chọn cục bộ như một quy tắc phổ quát của TFD.

## 3. Nguyên tắc bắt buộc

### 3.1 Tách biệt các lớp thông tin

Hệ thống PHẢI phân biệt tối thiểu:

1. **Nguồn (Source):** tư liệu hoặc vật mang tin được dùng làm căn cứ.
2. **Bản thể hiện của nguồn:** tệp số hóa, ảnh, bản quét, bản ghi âm hoặc bản sao lưu giữ.
3. **Trích dẫn (Citation):** vị trí cụ thể trong nguồn hoặc bản thể hiện.
4. **Phiên âm/bản chép (Transcription):** phần nội dung được chép lại từ nguồn.
5. **Bản dịch/diễn giải (Translation/Interpretation):** cách chuyển ngữ hoặc giải thích nội dung.
6. **Nhận định (Assertion):** mệnh đề được nêu ra và có thể đánh giá.
7. **Liên kết chứng cứ (Evidence link):** cách một trích dẫn hoặc phần nguồn liên quan đến một nhận định.
8. **Đánh giá chứng cứ (Evidence assessment):** đánh giá có căn cứ về sức nặng và giới hạn của chứng cứ.
9. **Kết luận (Conclusion):** tổng hợp có điều kiện về một vấn đề nghiên cứu tại một thời điểm.
10. **Giá trị hiển thị:** cách ứng dụng trình bày dữ liệu cho người dùng.

Các lớp này CÓ THỂ được lưu bằng nhiều bảng hoặc cấu trúc kỹ thuật, nhưng không được gộp theo cách khiến hệ thống không thể truy nguyên nội dung đã ghi trong nguồn và lý do của kết luận.

### 3.2 Không biến diễn giải thành nguyên văn

Bản phiên âm phải được đánh dấu là phiên âm, không được gắn nhãn “nguyên văn nguồn” nếu đã âm thầm sửa chính tả, thay chữ, chuẩn hóa niên đại hoặc thêm nội dung. Mọi phần bổ sung của người biên tập PHẢI được đánh dấu bằng quy ước đã công bố.

### 3.3 Bảo toàn mâu thuẫn

Khi hai nguồn đưa ra dữ kiện khác nhau, hệ thống PHẢI giữ được cả hai lời ghi nhận và nguồn tương ứng. Việc lựa chọn giá trị hiển thị hoặc kết luận hiện hành không được xóa dữ liệu trái chiều.

### 3.4 Không đồng nhất “không thấy” với “không tồn tại”

Không tìm thấy một thông tin trong một nguồn không tự động chứng minh thông tin đó sai hoặc sự kiện không xảy ra. Nhận định về sự vắng mặt của thông tin PHẢI giới hạn trong nguồn, phạm vi và phương pháp đã khảo sát.

### 3.5 Không tự suy ra tính độc lập của nguồn

Hai bản chép có cùng nội dung không mặc nhiên là hai chứng cứ độc lập. Khi biết hoặc nghi ngờ các nguồn phụ thuộc cùng một bản gốc, lời kể hoặc công trình trung gian, hệ thống NÊN ghi mối phụ thuộc và người thẩm định PHẢI cân nhắc nó.

### 3.6 Không tạo độ chắc chắn giả

Giá trị chuẩn hóa, điểm số, nhãn “đã xác minh” hoặc giao diện trực quan KHÔNG ĐƯỢC khiến người đọc hiểu rằng dữ liệu chắc chắn hơn căn cứ thực tế. Nếu chỉ biết năm thì không hiển thị như ngày chính xác; nếu là giả thuyết thì không trình bày như sự thật đã được xác nhận.

### 3.7 Có thể sửa, nhưng phải truy nguyên

Bản ghi đã được sử dụng trong kết luận hoặc công bố không được sửa theo cách làm mất lịch sử. Sửa đổi PHẢI lưu người thực hiện, thời điểm, nội dung trước/sau hoặc tham chiếu phiên bản, lý do và căn cứ liên quan theo chính sách lưu trữ.

### 3.8 Tôn trọng quyền và giới hạn nguồn

Việc sở hữu một bản sao không đồng nghĩa có quyền công bố, phân phối hoặc cung cấp bản tải xuống cho mọi người. Quyền truy cập nội dung nguồn và quyền xem phần mô tả/citation CÓ THỂ khác nhau.

## 4. Thuật ngữ

### 4.1 Nguồn (Source)

Một tài liệu, hiện vật, bản ghi, cơ sở dữ liệu, lời kể hoặc nguồn thông tin được đăng ký để tham chiếu. Nguồn là đối tượng tư liệu, không phải tự thân là kết luận đúng.

### 4.2 Vật mang tin (Carrier)

Vật hoặc phương tiện mang nội dung: sách, tờ giấy, bia đá, ảnh, tệp PDF, tệp âm thanh, trang web hoặc bản ghi dữ liệu. Một nguồn có thể có nhiều vật mang tin hoặc bản thể hiện.

### 4.3 Bản gốc, bản sao và bản dẫn xuất

- **Bản gốc:** vật/tài liệu được xem là bản gốc trong phạm vi xác định; trạng thái này cần căn cứ, không chỉ dựa vào tên tệp.
- **Bản sao:** bản sao vật lý hoặc số của một vật mang tin khác.
- **Bản dẫn xuất:** bản chép, bản dịch, bản tóm lược, bản biên tập hoặc sản phẩm được tạo từ một hay nhiều nguồn khác.
- **Bản số hóa:** biểu diễn số của vật mang tin, chẳng hạn ảnh chụp hoặc bản quét.

Một bản dẫn xuất có thể là nguồn trực tiếp cho việc nghiên cứu bản dẫn xuất đó, nhưng không mặc nhiên tương đương việc đã kiểm tra bản gốc mà nó dẫn lại.

### 4.4 Citation — Trích dẫn định vị

Bản ghi chỉ ra vị trí cụ thể có liên quan trong một nguồn: trang, tờ, mặt bia, dòng, mục, số hồ sơ, thời điểm trong bản ghi âm, vùng ảnh, đoạn văn hoặc mã định vị tương đương.

### 4.5 Assertion — Nhận định

Một mệnh đề có thể được hỗ trợ, phản bác, để ngỏ hoặc rút lại. Ví dụ: “Nguyễn Văn A sinh khoảng năm 1820”; “Bà B là con của ông C”; “Tên trên bia được đọc là…”. Một nhận định nên chỉ chứa một mệnh đề có thể đánh giá độc lập.

### 4.6 Evidence — Chứng cứ

Nội dung hoặc đặc điểm của nguồn được viện dẫn để đánh giá một nhận định. Chứng cứ không chỉ là bản thân tên tệp hoặc liên kết nguồn; cần xác định nội dung nào liên quan và liên quan theo cách nào.

### 4.7 Evidence assessment — Đánh giá chứng cứ

Ghi nhận có cấu trúc về độ trực tiếp, chất lượng, tính độc lập, tính toàn vẹn, độ phù hợp và giới hạn của chứng cứ đối với một nhận định hoặc câu hỏi.

### 4.8 Conclusion — Kết luận

Kết quả tổng hợp các nhận định và đánh giá tại một thời điểm, có phạm vi, lý do, người chịu trách nhiệm và trạng thái. Kết luận có thể tạm thời, có điều kiện hoặc được mở lại khi có chứng cứ mới.

### 4.9 Dị bản (Variant)

Một cách ghi khác nhau của cùng một đối tượng hoặc nội dung được cho là có liên quan: tên, chữ, địa danh, niên đại, chức tước, quan hệ hoặc câu chữ. Dị bản không nhất thiết là lỗi; có thể phản ánh khác biệt thời đại, phương ngữ, hệ chữ, người chép hoặc cách diễn giải.

### 4.10 Mâu thuẫn (Conflict)

Tình trạng hai hoặc nhiều nhận định không thể đồng thời đúng theo cùng một cách hiểu và phạm vi, hoặc các nguồn đưa ra thông tin không tương thích. Không phải mọi khác biệt bề ngoài đều là mâu thuẫn thực chất.

### 4.11 Provenance — Xuất xứ và lịch sử hình thành

Thông tin về nguồn được tạo ra, lưu giữ, chuyển giao, sao chép, số hóa, biên tập hoặc dẫn xuất như thế nào; gồm các chủ thể, thời điểm và quan hệ nguồn gốc đã biết.

### 4.12 Người/đại lý thực hiện (Agent)

Cá nhân, tổ chức hoặc hệ thống tự động thực hiện một hành động như tiếp nhận, số hóa, phiên âm, dịch, thẩm định, sửa đổi hoặc công bố.

## 5. Mô hình quản lý thông tin

### 5.1 Mô hình logic tối thiểu

```text
Nguồn (Source)
  ├── Vật mang tin / Tệp số hóa / MediaAsset
  ├── Nguồn gốc, nơi lưu giữ, quyền và điều kiện truy cập
  ├── Phiên âm / Bản dịch / Diễn giải
  └── Citation (vị trí cụ thể)
          └── Liên kết chứng cứ
                  └── Assertion (nhận định)
                         ├── EvidenceAssessment
                         ├── Quan hệ hỗ trợ / phản bác / bối cảnh
                         └── Conclusion (kết luận tổng hợp)
```

Đây là sơ đồ khái niệm, không phải sơ đồ vật lý bắt buộc. TFD-101 là nguồn tham chiếu chính cho thực thể và quan hệ dữ liệu.

### 5.2 Quy tắc một nguồn — nhiều trích dẫn

Một nguồn có thể được trích dẫn ở nhiều vị trí. Mỗi citation PHẢI có định danh ổn định trong phạm vi hệ thống và phải chỉ tới một nguồn hợp lệ. Không tạo nguồn mới chỉ vì cùng một tài liệu được dùng để hỗ trợ nhiều nhận định.

### 5.3 Quy tắc một trích dẫn — nhiều nhận định

Một đoạn văn có thể hỗ trợ nhiều nhận định, nhưng mỗi nhận định PHẢI được tách riêng nếu có thể đánh giá độc lập. Ví dụ một câu ghi “ông X, con trưởng ông Y, mất năm 1890” có thể tạo ít nhất ba nhận định: danh tính/tên, quan hệ cha-con, và niên đại mất.

### 5.4 Quy tắc nhiều nguồn — một nhận định

Một nhận định có thể liên kết với nhiều citation từ nhiều nguồn. Mỗi liên kết phải thể hiện vai trò chứng cứ riêng, không chỉ gắn một danh sách nguồn không có giải thích.

### 5.5 Nguồn không có citation

Nguồn có thể được đăng ký trước khi xác định vị trí chứng cứ. Tuy nhiên, nhận định quan trọng được đánh dấu đã thẩm định PHẢI có đường truy nguyên đến vị trí cụ thể hoặc ghi rõ ngoại lệ được phê duyệt. Không được tạo citation giả chỉ để vượt qua kiểm tra.

### 5.6 Nguồn, sự kiện và nhận định không đồng nhất

Một nguồn có thể mô tả nhiều sự kiện; một sự kiện có thể được phản ánh trong nhiều nguồn; một nhận định có thể nói về sự kiện hoặc thuộc tính; kết luận có thể tổng hợp nhiều nhận định. Hệ thống KHÔNG ĐƯỢC coi một dòng trong nguồn là một sự kiện duy nhất hoặc mặc định mọi câu trong nguồn là đúng.

## 6. Quy trình tổng thể

Quy trình khuyến nghị gồm các bước sau. Có thể lặp lại hoặc quay lại bước trước khi phát hiện dữ kiện mới; mọi thao tác phải bảo toàn lịch sử.

1. **Tiếp nhận:** ghi nhận nguồn, người cung cấp, tình trạng và quyền.
2. **Đăng ký:** tạo định danh, mô tả, xuất xứ đã biết và nơi lưu giữ.
3. **Bảo quản/số hóa:** lưu bản thể hiện, kiểm tra tệp và ghi lịch sử xử lý.
4. **Phiên âm/dịch:** tách nguyên văn khỏi chuẩn hóa và diễn giải.
5. **Tạo citation:** xác định vị trí cụ thể và cách truy cập lại.
6. **Lập nhận định:** chia nội dung thành các mệnh đề có thể đánh giá.
7. **Liên kết chứng cứ:** ghi rõ chứng cứ hỗ trợ, phản bác hoặc cung cấp bối cảnh.
8. **Đánh giá:** xem xét chất lượng, tính độc lập, độ trực tiếp, giới hạn và mâu thuẫn.
9. **Tổng hợp:** lập kết luận có phạm vi và trạng thái rõ ràng nếu đủ căn cứ.
10. **Rà soát và công bố:** kiểm tra chất lượng, quyền riêng tư, cách hiển thị và truy nguyên.
11. **Theo dõi sau công bố:** tiếp nhận phản hồi, bổ sung nguồn, sửa đổi hoặc mở lại kết luận.

Không phải nguồn nào cũng cần đi đến bước công bố hoặc kết luận. Việc dừng ở trạng thái “đã đăng ký”, “chưa phiên âm” hoặc “chưa đủ căn cứ” là hợp lệ nếu phản ánh đúng tình trạng.

## 7. Tiếp nhận và đăng ký nguồn

### 7.1 Thông tin tối thiểu

Khi tạo bản ghi Source, hệ thống NÊN ghi tối thiểu:

- Định danh nguồn ổn định.
- Tiêu đề hoặc mô tả nhận diện.
- Loại nguồn hoặc dạng tư liệu, nếu biết.
- Người/tổ chức tạo ra nguồn, nếu biết.
- Thời điểm tạo nguồn hoặc khoảng thời gian ước tính, nếu biết.
- Người cung cấp hoặc nguồn tiếp nhận, theo quyền riêng tư.
- Nơi lưu giữ hoặc vị trí tham chiếu, nếu biết.
- Trạng thái tiếp nhận và tình trạng vật mang tin.
- Quyền sở hữu/quyền sử dụng và giới hạn truy cập đã biết.
- Thời điểm đăng ký và Agent thực hiện.

Thiếu một trường không được biết PHẢI được biểu diễn là chưa biết/không cung cấp, không được tự tạo giá trị giả như ngày 01/01 hoặc tên tác giả suy đoán.

### 7.2 Không xác nhận quá mức tính xác thực

Người tiếp nhận PHẢI phân biệt “đã nhận được tư liệu”, “đã kiểm tra vật mang tin”, “đã đối chiếu với bản gốc” và “đã xác minh nguồn gốc”. Đây là các trạng thái khác nhau. Việc một người cung cấp gọi tệp là “bản gốc” không đủ để hệ thống khẳng định tính nguyên gốc.

### 7.3 Mô tả vật mang tin

Với nguồn vật lý, NÊN ghi loại vật liệu, kích thước, số tờ/trang, tình trạng hư hại, chữ viết, ngôn ngữ và dấu hiệu nhận diện phù hợp. Với nguồn số, NÊN ghi định dạng, kích thước, độ phân giải nếu có, thời điểm tiếp nhận, công cụ tạo/chuyển đổi nếu biết và các đặc tính kỹ thuật hỗ trợ kiểm tra toàn vẹn.

### 7.4 Nguồn truyền khẩu

Khi tiếp nhận lời kể, NÊN phân biệt:

- Người kể và vai trò/quan hệ với nội dung được kể.
- Ngày, địa điểm và bối cảnh ghi nhận.
- Ghi âm, ghi hình, ghi chép trực tiếp hay tóm lược sau cuộc nói chuyện.
- Nội dung do người kể nhớ trực tiếp, nghe từ người khác hay suy luận.
- Sự đồng ý và điều kiện sử dụng/công bố.
- Các giới hạn về danh tính, riêng tư hoặc an toàn của người kể.

Không được trình bày lời kể là lời chứng trực tiếp nếu người kể chỉ thuật lại thông tin nghe từ người khác.

### 7.5 Nguồn trực tuyến

NÊN ghi URL, tiêu đề trang, tổ chức/tác giả hiển thị, ngày truy cập, ngày công bố nếu có, phiên bản hoặc bản lưu, và điều kiện truy cập. URL có thể thay đổi hoặc biến mất; khi được phép, hãy lưu bản chụp/bản lưu có thể bảo quản. Không được coi nội dung trang web hiện tại là bản ghi nguyên trạng của nội dung ở thời điểm trước nếu không có bản lưu hoặc chứng cứ khác.

### 7.6 Nguồn không rõ xuất xứ

Nguồn vẫn có thể được đăng ký khi chưa rõ xuất xứ. Bản ghi phải thể hiện rõ giới hạn này và không được tự điền tác giả, niên đại, địa điểm hoặc tính xác thực bằng suy đoán không có căn cứ.

### 7.7 Trùng nguồn

Trước khi tạo nguồn mới, NÊN kiểm tra xem tài liệu đó đã được đăng ký hay chưa. Nếu có nhiều bản sao của cùng một tài liệu, có thể quản lý chúng như các vật mang tin/bản thể hiện riêng gắn với cùng nguồn logic, hoặc như nguồn riêng có quan hệ bản sao; lựa chọn mô hình cần thống nhất trong triển khai và không được làm mất khả năng truy nguyên từng bản.

## 8. Bảo quản, số hóa và toàn vẹn

### 8.1 Giữ bản tiếp nhận

Khi được phép và khả thi, hệ thống NÊN giữ bản tiếp nhận nguyên trạng riêng với bản đã xử lý. Mọi thao tác cắt ảnh, chỉnh độ tương phản, xoay, làm sạch, nén, OCR, chuyển định dạng hoặc chỉnh sửa âm thanh phải tạo bản dẫn xuất hoặc có nhật ký đủ để xác định đã xử lý gì.

### 8.2 Không ghi đè âm thầm

Không được ghi đè bản tư liệu duy nhất bằng bản đã chỉnh sửa. Nếu phải thay thế do lỗi lưu trữ, PHẢI ghi nhận lý do, người thực hiện, thời điểm, bản bị thay thế và cách xác định bản thay thế.

### 8.3 Kiểm tra toàn vẹn tệp

Hệ thống NÊN hỗ trợ mã băm mật mã (ví dụ SHA-256) cho tệp số để kiểm tra thay đổi ngoài dự kiến. Mã băm chứng minh hai chuỗi byte giống nhau khi so sánh, nhưng không tự chứng minh nội dung có thật, đúng lịch sử hoặc do ai tạo ra.

### 8.4 Siêu dữ liệu số hóa

NÊN ghi Agent, thời điểm, thiết bị/phần mềm nếu biết, quy trình, định dạng đầu ra, quan hệ với bản nguồn và các biến đổi đã thực hiện. Siêu dữ liệu thiếu phải được giữ là thiếu; không được suy ra chỉ từ tên tệp.

### 8.5 Bản sao lưu và khả năng đọc lâu dài

Chính sách sao lưu, khôi phục, lưu trữ dài hạn và kiểm soát truy cập thuộc TFD-401. TFD-301 yêu cầu mọi bản sao phục vụ nghiên cứu phải giữ liên kết tới nguồn logic và lịch sử xử lý, tránh tạo các bản tệp rời không có ngữ cảnh.

### 8.6 Nguồn bị hỏng hoặc không đọc được

Ghi lại tình trạng và phạm vi đọc được. Không suy đoán phần mất để tạo thành câu hoàn chỉnh mà không đánh dấu. Nếu cần phục nguyên, lưu riêng phần phục nguyên, người thực hiện, phương pháp và mức chắc chắn.

## 9. Phiên âm, dịch thuật và diễn giải

### 9.1 Các lớp biểu diễn

Một triển khai NÊN phân biệt ít nhất:

- **Ảnh/bản ghi nguồn:** biểu diễn trực quan hoặc âm thanh của vật mang tin.
- **Phiên âm ngoại giao (diplomatic transcription):** giữ tối đa đặc điểm chính tả, dấu câu, cách viết, xuống dòng và dị thể quan trọng của nguồn theo quy ước được công bố.
- **Phiên âm đọc được:** có thể chuẩn hóa một số đặc điểm trình bày nhưng phải khai báo quy tắc.
- **Bản dịch:** chuyển ngữ sang ngôn ngữ khác, ghi người dịch và ngày/phiên bản.
- **Diễn giải/chú giải:** giải thích thuật ngữ, nhân danh, địa danh, niên hiệu, chữ khó đọc hoặc ngữ cảnh.
- **Giá trị chuẩn hóa:** giá trị dùng cho tìm kiếm/đối chiếu; phải liên kết trở lại nội dung nguồn và phương pháp chuẩn hóa.

Không phải dự án nào cũng cần tất cả các lớp, nhưng lớp nào đã tạo thì phải được gắn nhãn đúng.

### 9.2 Quy tắc phiên âm

Phiên âm NÊN ghi ngôn ngữ, hệ chữ, quy ước phiên âm, người thực hiện, thời điểm, phiên bản và trạng thái rà soát. Ký hiệu mất chữ, chữ không đọc được, phần bổ sung và phần nghi ngờ phải có quy ước rõ ràng.

Ví dụ quy ước có thể dùng: `[khuyết]`, `[không rõ]`, `[chữ?]`, hoặc dấu ngoặc vuông cho phần người biên tập bổ sung. Đây là ví dụ, không phải hệ ký hiệu bắt buộc toàn TFD cho đến khi được chuẩn hóa.

### 9.3 Chữ Hán, Nôm và dị thể

Khi xử lý chữ Hán/Nôm, NÊN giữ ảnh hoặc vị trí chữ gốc; lưu dạng ký tự được phiên đọc; ghi nhận dị thể, chữ chưa xác định hoặc nhiều cách đọc. Không được âm thầm thay một chữ khó đọc bằng chữ phổ biến hơn chỉ vì tên người hoặc ngữ cảnh “có vẻ hợp lý”.

Nếu dùng Unicode, phải lưu chuỗi ký tự và, khi cần cho nghiên cứu, cách biểu diễn dị thể hoặc tham chiếu ảnh glyph. Unicode giúp mã hóa ký tự nhưng không tự quyết định cách đọc, ý nghĩa lịch sử hoặc việc hai dạng chữ có tương đương hay không.

### 9.4 Bản dịch

Bản dịch PHẢI được phân biệt với nguyên văn. NÊN ghi người dịch, ngôn ngữ nguồn/đích, ngày, phiên bản và chú thích những đoạn không chắc chắn. Nếu bản dịch đã sửa hoặc cập nhật, phiên bản cũ vẫn phải truy xuất được khi đã được dùng làm căn cứ cho một kết luận.

### 9.5 OCR và nhận dạng tự động

Kết quả OCR/ASR hoặc mô hình tự động PHẢI được coi là bản đề xuất do hệ thống tạo ra, không mặc nhiên là phiên âm đã xác minh. NÊN lưu tên/cấu hình công cụ nếu phù hợp, thời điểm xử lý, trạng thái kiểm tra của con người và các phần có độ tin cậy thấp nếu công cụ cung cấp.

### 9.6 Hiệu đính

Người hiệu đính không được sửa bản phiên âm cũ theo cách xóa dấu vết. Có thể tạo phiên bản mới hoặc lưu diff; phải ghi người hiệu đính, lý do và căn cứ. Những sửa đổi có thể làm thay đổi nhận định gia phả cần kích hoạt quy trình đánh giá lại các nhận định phụ thuộc.

## 10. Tạo citation và định vị chứng cứ

### 10.1 Yêu cầu chung

Citation PHẢI định vị đủ cụ thể để một người có quyền truy cập có thể tìm lại đoạn liên quan mà không phải dò toàn bộ nguồn một cách không cần thiết. Citation PHẢI gắn với một nguồn hợp lệ và không được chỉ tới một nguồn không liên quan.

### 10.2 Thành phần gợi ý

Tùy loại nguồn, citation có thể gồm:

- source_id;
- mã hồ sơ, ký hiệu lưu trữ hoặc số hiệu tài liệu;
- trang, tờ, mặt, dòng, mục, chương hoặc đoạn;
- thời điểm bắt đầu/kết thúc trong âm thanh/video;
- tọa độ vùng ảnh hoặc định danh trang ảnh;
- đoạn văn được trích hoặc bản phiên âm liên quan;
- URI/tên tệp bản thể hiện, nếu được phép truy cập;
- người định vị, ngày tạo và ghi chú.

Các trường bắt buộc cụ thể phải được quy định theo loại nguồn và chính sách triển khai. Không phải nguồn nào cũng có số trang hoặc dòng.

### 10.3 Gia phả đóng quyển

Đối với gia phả, tộc phả hoặc sách đóng quyển, citation NÊN ghi tên bản/phiên bản, quyển, tờ, mặt, dòng và tiêu đề mục nếu có. Phải phân biệt số trang in với số tờ viết tay hoặc số trang do người số hóa tự đánh.

### 10.4 Bia mộ và hiện vật

Citation NÊN xác định hiện vật, mặt/bề mặt, vùng chữ, vị trí ảnh và phần phiên âm liên quan. Nếu chữ bị mòn hoặc mất, ghi phạm vi không đọc được và tránh trích dẫn như thể toàn bộ nội dung còn rõ.

### 10.5 Hồ sơ hành chính

NÊN ghi cơ quan lập/lưu, loại hồ sơ, mã hồ sơ, số trang/tờ và ngày truy cập hoặc tra cứu. Nếu thông tin chỉ được đọc qua bản trích lục hoặc bản chụp do người khác cung cấp, phải nói rõ đó là bản đang được kiểm tra.

### 10.6 Nguồn truyền khẩu

Citation có thể trỏ tới bản ghi âm/video với dấu thời gian, hoặc tới biên bản phỏng vấn và đoạn tương ứng. Nếu không có bản ghi, phải mô tả cách ghi nhận và giới hạn; không được giả lập timestamp hoặc vị trí chính xác.

### 10.7 Nguồn trực tuyến

Citation NÊN gồm URL, tiêu đề, ngày truy cập, đoạn/mục hoặc mã bản lưu. Nếu trang có thể thay đổi, hãy lưu thông tin phiên bản hoặc bản chụp khi được phép. Không được gán số trang cho trang web nếu không có cơ chế trang hóa ổn định.

### 10.8 Trích dẫn nguyên văn

Đoạn trích nguyên văn phải giữ nguyên chính tả và dấu hiệu cần thiết theo nguồn. Phần lược bỏ, bổ sung, dịch hoặc chú thích phải được phân biệt. Nội dung trích dẫn phải tuân thủ quyền tác giả, quyền riêng tư và điều kiện sử dụng nguồn.

### 10.9 Citation không còn truy cập được

Nếu nguồn hoặc liên kết biến mất, không xóa citation đã dùng. Cập nhật trạng thái truy cập, thời điểm kiểm tra và bản lưu thay thế nếu có. Citation hỏng không tự làm mất giá trị lịch sử của hồ sơ nhưng làm giảm khả năng kiểm tra lại và phải được thể hiện trong đánh giá.

## 11. Lập và quản lý nhận định (Assertion)

### 11.1 Nhận định nguyên tử

Nhận định NÊN chứa một mệnh đề có thể được đánh giá độc lập. Tránh gộp nhiều nội dung khác loại vào một trường mô tả nếu chúng cần căn cứ riêng.

Ví dụ không nên dùng một assertion duy nhất cho “ông A sinh năm 1820, là con ông B, đỗ đạt năm 1840 và mất tại làng C”. Nên tách các mệnh đề về năm sinh, quan hệ cha-con, sự kiện đỗ đạt, niên đại và địa điểm mất.

### 11.2 Nội dung và chủ thể

Một nhận định nên ghi:

- định danh ổn định;
- loại nhận định hoặc đối tượng được mô tả;
- nội dung/mệnh đề và giá trị được khẳng định;
- đối tượng liên quan;
- người hoặc hệ thống tạo nhận định;
- thời điểm tạo và trạng thái;
- nguồn/citation liên quan;
- phương pháp hoặc giả định nếu có;
- lịch sử sửa đổi và liên kết tới nhận định bị thay thế nếu có.

Cấu trúc vật lý cụ thể do TFD-101 và triển khai quyết định.

### 11.3 Phân biệt ghi nhận trực tiếp và suy luận

Nhận định NÊN được phân loại theo cách hình thành, ví dụ:

- nội dung được ghi trực tiếp trong nguồn;
- phiên đọc/phiên âm của người nghiên cứu;
- chuẩn hóa từ một dạng ghi;
- suy luận từ nhiều dữ kiện;
- giả thuyết cần kiểm tra;
- nhận định do nguồn thứ cấp dẫn lại;
- kết luận biên tập được thông qua theo quy trình.

Danh mục mã chính thức còn phải được thống nhất. Dù dùng mã nào, giao diện và dữ liệu không được làm mất sự phân biệt này.

### 11.4 Không dùng một trường “certainty” thay cho mọi thứ

Độ rõ của chữ, độ tin cậy của nguồn, mức độ trực tiếp, mức đồng thuận giữa nguồn và độ tin cậy của nhận định là những chiều khác nhau. Không nên gộp tất cả thành một điểm duy nhất nếu không có phương pháp đã định nghĩa và kiểm định.

### 11.5 Nhận định chưa có nguồn

Nhận định chưa có nguồn có thể được ghi để phục vụ nghiên cứu hoặc tiếp nhận lời truyền lại. Phải đánh dấu tình trạng thiếu căn cứ và không hiển thị như đã xác minh. NÊN ghi ai cung cấp thông tin và bối cảnh nếu được phép.

### 11.6 Rút lại và thay thế

Khi nhận định sai, không còn phù hợp hoặc bị chứng cứ mới phản bác, hệ thống PHẢI cho phép đánh dấu rút lại/thay thế và lưu lý do. Không xóa nhận định cũ nếu nó đã được dùng trong báo cáo, liên kết hoặc quyết định quan trọng, trừ trường hợp bắt buộc theo chính sách pháp lý/quyền riêng tư; ngay cả khi xóa nội dung hiển thị, phải lưu dấu vết tối thiểu phù hợp chính sách.

## 12. Liên kết chứng cứ với nhận định

### 12.1 Vai trò liên kết

Mỗi liên kết chứng cứ NÊN thể hiện vai trò, ví dụ:

- **Hỗ trợ:** nội dung làm tăng cơ sở chấp nhận nhận định.
- **Phản bác:** nội dung làm giảm cơ sở chấp nhận nhận định hoặc đưa ra giá trị không tương thích.
- **Bối cảnh:** giúp hiểu nguồn hoặc hoàn cảnh nhưng không trực tiếp chứng minh mệnh đề.
- **Không xác định:** có liên quan nhưng chưa rõ hỗ trợ hay phản bác.
- **Dẫn lại:** nguồn hiện tại nhắc lại thông tin từ một nguồn khác.

Tên/mã chuẩn hóa của các vai trò phải được thống nhất trong bộ TFD; các nhãn trên là định hướng ngữ nghĩa.

### 12.2 Lý do liên kết

Với nhận định trọng yếu, người nhập hoặc thẩm định NÊN ghi lý do tại sao đoạn nguồn liên quan đến nhận định. Không nên chỉ đính kèm hàng loạt nguồn mà không nói chúng chứng minh điều gì.

### 12.3 Chứng cứ âm tính

Khi dùng việc không thấy thông tin làm căn cứ, phải ghi phạm vi tìm kiếm, phiên bản nguồn, phần đã kiểm tra và khả năng nguồn bị thiếu, hư hỏng hoặc không đầy đủ. “Không thấy tên trong quyển A” chỉ chứng minh kết quả khảo sát trong quyển A theo phạm vi được mô tả, không tự động chứng minh người đó không tồn tại hoặc không thuộc gia đình.

### 12.4 Nhiều chứng cứ từ cùng nguồn

Nhiều citation từ một nguồn không nhất thiết tương đương nhiều nguồn độc lập. Việc đếm số citation không được dùng thay cho đánh giá tính độc lập và chất lượng.

### 12.5 Chứng cứ gián tiếp

Nếu một nguồn chỉ dẫn lại nguồn khác, liên kết phải phân biệt nội dung được nguồn hiện tại ghi trực tiếp với nội dung được thuật lại. Nếu nguồn được dẫn chưa được kiểm tra, phải ghi rõ.

### 12.6 Chứng cứ cho các phần khác nhau của nhận định

Một citation có thể hỗ trợ một phần nhưng không hỗ trợ toàn bộ nhận định. Khi cần, hãy tách nhận định hoặc ghi rõ phạm vi chứng minh. Không gắn nhãn “hỗ trợ” cho toàn bộ mệnh đề nếu citation chỉ xác nhận một phần.

## 13. Đánh giá chất lượng và sức nặng chứng cứ

### 13.1 Không có thang điểm phổ quát mặc định

TFD-301 không ấn định một điểm số tin cậy phổ quát cho mọi nguồn và mọi loại nhận định. Mỗi dự án CÓ THỂ thiết lập rubric, nhưng phải công bố tiêu chí, cách dùng, giới hạn và người có thẩm quyền áp dụng. Điểm số không thay thế giải thích bằng văn bản.

### 13.2 Các chiều đánh giá đề xuất

Người thẩm định NÊN xem xét riêng các chiều sau:

1. **Tính trực tiếp:** nguồn ghi trực tiếp hay dẫn lại?
2. **Xuất xứ:** nguồn gốc và chuỗi lưu giữ có rõ không?
3. **Tính toàn vẹn:** có dấu hiệu sửa chữa, mất trang, hư hại hoặc chỉnh sửa không được ghi nhận không?
4. **Thời điểm:** nguồn được lập gần hay xa sự kiện được nói đến?
5. **Năng lực quan sát:** tác giả/người kể có khả năng biết điều được ghi không?
6. **Mục đích và bối cảnh:** nguồn được tạo ra để làm gì; có thể có thiên lệch hoặc quy ước riêng không?
7. **Độ rõ:** nội dung có đọc được, hiểu được và định vị được không?
8. **Tính độc lập:** nguồn có phụ thuộc vào nguồn khác đang xét không?
9. **Tính nhất quán:** có phù hợp với các dữ kiện khác không, và sự khác biệt có thể giải thích được không?
10. **Phù hợp loại mệnh đề:** loại nguồn này có thích hợp để chứng minh điều đang xét không?

Các chiều này không phải danh sách chấm điểm máy móc. Một nguồn gần sự kiện nhưng bị hư hại vẫn có giới hạn; một nguồn muộn hơn có thể giữ lại thông tin đáng giá nhưng cần truy nguyên.

### 13.3 Không xếp hạng nguồn theo loại một cách tuyệt đối

Không được mặc định mọi bia mộ tốt hơn mọi gia phả, hoặc mọi giấy tờ hành chính tốt hơn mọi lời kể. Giá trị nguồn phụ thuộc mệnh đề cần kiểm tra, bối cảnh tạo lập, tính xác thực, khả năng quan sát, lịch sử truyền bản và các giới hạn cụ thể.

### 13.4 Mức độ đồng thuận

Nhiều nguồn đồng thuận có thể làm tăng cơ sở chấp nhận nhận định chỉ khi chúng đủ độc lập và liên quan trực tiếp. Nếu nhiều bản sao cùng chép từ một bản duy nhất, sự đồng thuận có thể phản ánh một nguồn gốc chung chứ không phải nhiều xác nhận độc lập.

### 13.5 Người thẩm định

Đánh giá quan trọng NÊN ghi người thẩm định, thời điểm, tiêu chí, kết quả, giới hạn và xung đột lợi ích nếu có. Đánh giá tự động phải được phân biệt với đánh giá do con người thực hiện.

### 13.6 Đánh giá lại

Đánh giá cần được mở lại khi có nguồn mới, phát hiện nguồn phụ thuộc, sửa phiên âm có ảnh hưởng, xác định sai định danh, thay đổi quy tắc hoặc phát hiện lỗi trong phương pháp trước đó.

## 14. Quản lý mâu thuẫn

### 14.1 Khi nào tạo hồ sơ mâu thuẫn

NÊN tạo hồ sơ mâu thuẫn khi các nhận định có cùng đối tượng/phạm vi nhưng không thể cùng đúng theo cách hiểu hiện hành, ví dụ hai năm sinh khác nhau mà không phải khác lịch hoặc khác khái niệm. Khác biệt có thể giải thích được phải được xử lý bằng cách làm rõ định nghĩa trước khi kết luận là mâu thuẫn.

### 14.2 Quy trình xử lý

1. Ghi nhận tất cả nhận định và citation liên quan.
2. Xác định các khái niệm có thật sự cùng nghĩa không (ví dụ ngày sinh, ngày đăng ký, ngày làm lễ, ngày giỗ).
3. Kiểm tra lịch, niên hiệu, quy đổi, phiên âm, dị thể tên và khả năng nhầm người.
4. Kiểm tra bản gốc/bản sao, lịch sử sao chép và sự phụ thuộc giữa nguồn.
5. Đánh giá từng nguồn theo tiêu chí công bố.
6. Ghi các giả thuyết giải thích mâu thuẫn và căn cứ của từng giả thuyết.
7. Ghi quyết định hiện tại hoặc giữ trạng thái chưa giải quyết.
8. Ghi người quyết định, ngày, lý do và điều kiện mở lại.

### 14.3 Không ép chọn một giá trị

Nếu căn cứ chưa đủ để ưu tiên một nhận định, hệ thống PHẢI cho phép giữ trạng thái chưa giải quyết. Ứng dụng CÓ THỂ chọn một giá trị trình bày mặc định vì lý do giao diện, nhưng phải ghi đó là lựa chọn hiển thị và cung cấp cách xem các giá trị khác theo quyền truy cập.

### 14.4 Kết luận tạm thời

Kết luận tạm thời PHẢI được đánh dấu là tạm thời, nêu căn cứ hiện có và giới hạn. Không được biến kết luận tạm thời thành trạng thái “đã xác minh” chỉ vì đã tồn tại lâu hoặc được nhiều người lặp lại.

### 14.5 Khi mâu thuẫn được giải quyết

Trạng thái mâu thuẫn có thể chuyển sang đã giải quyết theo quy trình được xác định. Tuy nhiên, các nhận định nguồn ban đầu và lịch sử đánh giá vẫn phải truy xuất được. “Đã giải quyết” không đồng nghĩa mọi nguồn trái chiều đã biến mất hoặc chắc chắn không còn cách giải thích khác.

### 14.6 Mâu thuẫn do đồng danh/nhầm người

Trước khi kết luận nguồn sai, phải xem xét khả năng hai nguồn nói về hai người khác nhau có tên giống nhau, tên hiệu khác nhau hoặc cùng một người ở các giai đoạn khác nhau. Việc hợp nhất hai hồ sơ cá nhân phải là quyết định có thể đảo ngược và có căn cứ, không phải thao tác gộp tên đơn thuần.

## 15. Quản lý dị bản

### 15.1 Dị bản không mặc nhiên là lỗi

Dị bản có thể do biến đổi ngôn ngữ, phương ngữ, hệ chữ, cách đọc Hán Nôm, phiên âm, tên húy/tên tự/tên hiệu, thay đổi địa danh, lỗi sao chép hoặc cách chuẩn hóa hiện đại. Không được xóa một dạng ghi chỉ vì nó khác giá trị đang được dùng làm nhãn chính.

### 15.2 Các loại dị bản

Có thể phân loại dị bản theo phạm vi:

- Dị bản tên người: tên khai sinh, tên húy, tên tự, tên hiệu, tên thường gọi, tên sau khi mất, cách ghi khác.
- Dị bản địa danh: tên cũ/mới, tên làng/xã/tổng/huyện/tỉnh theo thời kỳ, biến thể chữ viết.
- Dị bản niên đại: cách ghi theo âm lịch, dương lịch, can chi, niên hiệu hoặc ước lượng.
- Dị bản quan hệ: cách gọi thân tộc hoặc cách phân loại quan hệ theo quy ước địa phương.
- Dị bản văn bản: khác biệt giữa các bản chép, bản in, bản dịch hoặc phiên âm.
- Dị bản phiên đọc: nhiều cách đọc có căn cứ cho cùng một chữ/chuỗi chữ.

Danh mục này là gợi ý và không loại trừ loại khác.

### 15.3 Liên kết dị bản với đối tượng

Mỗi dị bản NÊN liên kết với nguồn/citation nơi nó xuất hiện và, khi có căn cứ, với đối tượng chuẩn hóa mà nó được cho là chỉ tới. Nếu chưa chắc hai dạng thuộc cùng một người/địa danh, phải giữ quan hệ “có thể liên quan” hoặc trạng thái chưa xác định thay vì hợp nhất chắc chắn.

### 15.4 Giá trị hiển thị chính

Hệ thống CÓ THỂ chọn một tên hiển thị chính hoặc giá trị chuẩn hóa để tìm kiếm, nhưng phải giữ các dạng khác và căn cứ chọn giá trị chính. Giá trị hiển thị không được thay thế nguyên văn của nguồn.

### 15.5 Dị bản và định danh

Định danh ổn định của cá nhân hoặc thực thể không nên phụ thuộc vào một tên duy nhất. Khi tên thay đổi hoặc phát hiện tên khác, định danh không được đổi chỉ vì giá trị hiển thị đổi. Quy tắc định danh cụ thể theo TFD-102.

### 15.6 Dị bản văn bản

Khi hai bản gia phả khác nhau, NÊN lưu chúng như hai witness/bản chứng văn bản riêng và ghi các khác biệt quan trọng. Không nên tạo một “bản tổng hợp” rồi trình bày như thể đó là nội dung nguyên gốc của bất kỳ bản nào.

### 15.7 Chuẩn hóa có thể tái lập

Mọi phép chuẩn hóa có ảnh hưởng đáng kể NÊN ghi quy tắc, người thực hiện hoặc phiên bản công cụ. Nếu quy tắc thay đổi, có thể chạy lại chuẩn hóa nhưng không được ghi đè các bản gốc và kết quả đã dùng làm căn cứ mà không giữ lịch sử.

## 16. Kết luận nghiên cứu và trạng thái

### 16.1 Cấu trúc kết luận

Một kết luận nghiên cứu NÊN ghi:

- câu hỏi/phạm vi cần giải quyết;
- các nhận định được xem xét;
- nguồn/citation và đánh giá chứng cứ trọng yếu;
- cách xử lý mâu thuẫn;
- giả định và giới hạn;
- kết quả/kết luận;
- trạng thái và ngày hiệu lực;
- người lập và người duyệt nếu có;
- điều kiện hoặc dấu hiệu cần mở lại kết luận.

### 16.2 Trạng thái đề xuất

Có thể sử dụng các trạng thái khởi đầu sau, cần thống nhất mã chính thức trong bộ TFD:

- **DRAFT:** bản nháp, chưa hoàn tất.
- **UNASSESSED:** đã ghi nhận nhưng chưa đánh giá.
- **UNDER_REVIEW:** đang thẩm định.
- **SUPPORTED:** có căn cứ hỗ trợ nhưng chưa được xác nhận theo quy trình của dự án.
- **CONFLICTED:** đang có mâu thuẫn đáng kể chưa giải quyết.
- **PROVISIONAL:** kết luận tạm thời với giới hạn được nêu.
- **ACCEPTED:** được chấp nhận theo tiêu chí/quy trình đã công bố.
- **REJECTED:** không được chấp nhận theo căn cứ hiện tại; không có nghĩa nguồn chứa thông tin đó bị xóa.
- **RETRACTED:** rút lại vì có sai sót hoặc không còn được duy trì.
- **SUPERSEDED:** được thay thế bởi nhận định/kết luận phiên bản sau.

Các nhãn trên là đề xuất, không phải bộ mã đã được phê duyệt. Hệ thống không nên dùng một trạng thái chung cho nguồn, assertion, assessment và conclusion nếu làm mất ý nghĩa riêng của từng loại.

### 16.3 Điều kiện chấp nhận

Trước khi một kết luận được chấp nhận, quy trình NÊN xác định loại nhận định, tiêu chí đánh giá, nguồn trọng yếu, mâu thuẫn còn tồn tại, quyền hạn người duyệt và giới hạn công bố. Không có một ngưỡng duy nhất áp dụng cho mọi dữ kiện gia phả.

### 16.4 Quyết định hiển thị

Kết luận nghiên cứu và giá trị hiển thị phải được tách biệt. Ứng dụng có thể hiển thị một tên hoặc một niên đại mặc định, nhưng phải cho biết giá trị đó là chuẩn hóa, được ưu tiên theo quy tắc nào và có dị bản/mâu thuẫn nào cần công khai.

### 16.5 Mở lại kết luận

Kết luận PHẢI có thể được xem xét lại khi xuất hiện chứng cứ mới hoặc có lỗi trọng yếu. Mở lại không tự động xóa kết luận trước; lưu ngày, lý do, người mở lại và trạng thái tiếp theo.

## 17. Nhật ký, phiên bản và truy nguyên

### 17.1 Sự kiện cần ghi nhật ký

Theo mức độ rủi ro và chính sách dự án, nhật ký NÊN bao gồm: tạo/sửa nguồn; tải lên hoặc thay tệp; tạo phiên âm/bản dịch; tạo/sửa citation; lập nhận định; thay đổi liên kết chứng cứ; đánh giá; giải quyết mâu thuẫn; chấp nhận/rút lại kết luận; thay đổi quyền truy cập; công bố hoặc gỡ công bố.

### 17.2 Nội dung nhật ký

Nhật ký nên xác định Agent, thời điểm, đối tượng, hành động, giá trị trước/sau hoặc tham chiếu phiên bản, lý do, căn cứ và correlation/reference ID nếu hệ thống có. Không ghi dữ liệu nhạy cảm vượt quá nhu cầu kiểm toán.

### 17.3 Phiên bản nội dung

Phiên âm, bản dịch, đánh giá và kết luận có thể được quản lý bằng phiên bản hoặc lịch sử thay đổi. Cần phân biệt:

- phiên bản của vật mang tin;
- phiên bản của bản phiên âm/dịch;
- phiên bản của nhận định;
- phiên bản của quy tắc hoặc rubric đánh giá;
- trạng thái hiện tại của kết luận.

### 17.4 Tái lập kết quả

Khi có thể, hệ thống NÊN cho phép xác định kết luận tại một thời điểm được tạo từ những phiên bản nhận định, citation, phiên âm, quy tắc và đánh giá nào. Nếu không thể tái lập đầy đủ, phải ghi rõ giới hạn.

### 17.5 Không sửa lịch sử để khớp kết luận mới

Không được thay nội dung nguồn hoặc citation cũ để làm cho chúng phù hợp với kết luận hiện tại. Khi phát hiện sai, sửa ở lớp phù hợp, ghi lý do và bảo toàn dấu vết.

## 18. Quyền truy cập và công bố tư liệu

### 18.1 Tách quyền mô tả khỏi quyền xem tệp

Một người dùng có thể được phép biết rằng nguồn tồn tại và xem metadata/citation nhưng không được xem hoặc tải tệp. Hệ thống NÊN hỗ trợ các quyền tách biệt này.

### 18.2 Tư liệu hạn chế

Với tư liệu có thông tin người còn sống, hồ sơ cá nhân, dữ liệu nhạy cảm hoặc giới hạn do người cung cấp đặt ra, phải áp dụng chính sách TFD-401 và luật/quy định liên quan. Không được công khai nội dung chỉ vì nội dung đã được nhập vào hệ thống gia phả.

### 18.3 Trích dẫn và nội dung trích

Citation có thể được hiển thị mà không tiết lộ toàn bộ nguồn, nhưng chính citation, đoạn trích hoặc tên người cung cấp cũng có thể nhạy cảm. Quyền truy cập phải được đánh giá cho cả metadata và nội dung.

### 18.4 Gỡ công bố

Nếu một nguồn hoặc nhận định bị hạn chế hoặc gỡ khỏi giao diện công khai, lịch sử nghiên cứu nội bộ có thể cần giữ lại theo chính sách và nghĩa vụ áp dụng. Không được hứa giữ mọi dữ liệu trong mọi tình huống; việc lưu trữ phải tuân thủ yêu cầu pháp lý, quyền của chủ thể dữ liệu và chính sách được phê duyệt.

### 18.5 Chia sẻ và xuất dữ liệu

Khi xuất dữ liệu, hệ thống NÊN giữ liên kết nguồn/citation/nhận định nếu định dạng hỗ trợ, và phải áp dụng quyền truy cập, che dữ liệu hoặc ghi nhận mất mát theo TFD-401/TFD-501. Không được để tệp riêng tư lộ qua URL công khai không kiểm soát.

## 19. Kiểm tra toàn vẹn và quy tắc nghiệp vụ

Các mã dưới đây là mã kiểm tra dự thảo để giúp kiểm thử. Cần ánh xạ sang bộ mã chính thức của TFD-601 khi bộ kiểm thử được chốt.

| Mã | Quy tắc kiểm tra | Mức đề xuất |
|---|---|---|
| SRC-001 | Mỗi Source phải có định danh ổn định và mô tả nhận diện tối thiểu. | MUST |
| SRC-002 | Không được đánh dấu nguồn là bản gốc đã xác minh chỉ dựa vào lời khai chưa kiểm tra. | MUST |
| SRC-003 | Citation phải tham chiếu một Source tồn tại và có vị trí/định vị phù hợp với loại nguồn. | MUST |
| SRC-004 | Bản số hóa hoặc bản dẫn xuất phải liên kết với nguồn/bản thể hiện gốc đã biết. | SHOULD |
| SRC-005 | Tệp số nên có thông tin định dạng và kiểm tra toàn vẹn khi khả thi. | SHOULD |
| SRC-006 | Không ghi đè âm thầm bản tiếp nhận hoặc phiên bản đã được sử dụng. | MUST |
| EVD-001 | Nhận định trọng yếu được thẩm định phải truy nguyên đến citation hoặc có ngoại lệ được ghi rõ. | MUST |
| EVD-002 | Vai trò hỗ trợ/phản bác/bối cảnh phải được phân biệt. | MUST |
| EVD-003 | Không coi nhiều citation từ cùng nguồn là nhiều nguồn độc lập. | MUST |
| EVD-004 | Suy luận phải được phân biệt với nội dung ghi trực tiếp. | MUST |
| EVD-005 | Đánh giá quan trọng phải lưu căn cứ, người thực hiện và thời điểm. | SHOULD |
| EVD-006 | “Không tìm thấy” phải nêu phạm vi khảo sát, không suy ra phủ định tuyệt đối. | MUST |
| VAR-001 | Dị bản phải giữ được dạng ghi nguồn và liên kết tới nguồn/citation. | MUST |
| VAR-002 | Chuẩn hóa không được xóa hoặc ghi đè nguyên văn. | MUST |
| VAR-003 | Chưa chắc hai dạng thuộc cùng một đối tượng thì không tự động hợp nhất. | MUST |
| CON-001 | Mâu thuẫn chưa giải quyết phải được biểu diễn rõ. | MUST |
| CON-002 | Kết luận tạm thời phải có nhãn trạng thái và giới hạn. | MUST |
| CON-003 | Rút lại/thay thế phải giữ lịch sử theo chính sách. | MUST |
| AUD-001 | Thay đổi trọng yếu phải có nhật ký truy nguyên. | MUST |
| SEC-001 | Quyền xem metadata và quyền xem/tải nội dung nguồn phải được kiểm soát phù hợp. | MUST |

## 20. Bộ kiểm thử nghiệm thu dự thảo

### TC-301-01 — Đăng ký nguồn chưa rõ tác giả

**Tiền điều kiện:** Có tài liệu được cung cấp nhưng chưa biết người tạo và niên đại.

**Thao tác:** Tạo Source với các trường đã biết, để tác giả/niên đại ở trạng thái chưa biết.

**Kết quả mong đợi:** Nguồn được đăng ký; hệ thống không tự tạo tên tác giả hoặc ngày giả; giới hạn được hiển thị.

### TC-301-02 — Bản sao không phải bản gốc đã xác minh

**Tiền điều kiện:** Người dùng tải lên bản chụp được cho là sao từ gia phả cũ.

**Thao tác:** Đăng ký nguồn và khai báo nguồn gốc theo lời người cung cấp.

**Kết quả mong đợi:** Hệ thống ghi nhận lời khai nhưng không tự đặt trạng thái “bản gốc đã xác minh”.

### TC-301-03 — Một nguồn có nhiều citation

**Thao tác:** Tạo hai citation ở hai vị trí khác nhau trong cùng Source và gắn với các nhận định khác nhau.

**Kết quả mong đợi:** Cả hai citation tồn tại riêng, cùng tham chiếu Source hợp lệ; không phát sinh nguồn trùng không cần thiết.

### TC-301-04 — Citation thiếu vị trí

**Thao tác:** Tạo citation cho một nguồn nhiều trang nhưng không cung cấp vị trí hoặc mô tả định vị.

**Kết quả mong đợi:** Hệ thống cảnh báo hoặc yêu cầu bổ sung theo chính sách; không đánh dấu citation là định vị đầy đủ nếu chưa đạt tiêu chí.

### TC-301-05 — Phiên âm và chuẩn hóa tách biệt

**Thao tác:** Nhập nguyên văn có chính tả cổ và tạo giá trị chuẩn hóa.

**Kết quả mong đợi:** Cả hai lớp lưu được; giao diện cho biết lớp nào là nguyên văn, lớp nào là chuẩn hóa; sửa chuẩn hóa không thay nguyên văn.

### TC-301-06 — OCR chưa được kiểm tra

**Thao tác:** Nhập kết quả OCR làm bản phiên âm.

**Kết quả mong đợi:** Bản ghi mang trạng thái tự động/chưa thẩm định; không tự hiển thị như phiên âm đã xác minh.

### TC-301-07 — Nhận định nguyên tử

**Thao tác:** Tạo nội dung có nhiều mệnh đề độc lập.

**Kết quả mong đợi:** Quy trình khuyến nghị tách mệnh đề; mỗi nhận định có thể liên kết chứng cứ và đánh giá riêng.

### TC-301-08 — Một citation chỉ hỗ trợ một phần nhận định

**Thao tác:** Gắn đoạn nguồn chỉ ghi năm mất vào nhận định gồm cả năm mất và quan hệ cha-con.

**Kết quả mong đợi:** Hệ thống cho phép chỉ rõ phạm vi hỗ trợ hoặc cảnh báo rằng citation không đủ hỗ trợ toàn bộ mệnh đề.

### TC-301-09 — Hai nguồn phụ thuộc nhau

**Tiền điều kiện:** Bản chép B được tạo từ bản chép A.

**Thao tác:** Đăng ký quan hệ phụ thuộc và dùng cả hai để đánh giá một nhận định.

**Kết quả mong đợi:** Giao diện/đánh giá không tự coi chúng là hai nguồn độc lập chỉ vì có hai bản ghi.

### TC-301-10 — Hai niên đại mâu thuẫn

**Thao tác:** Tạo hai nhận định về năm sinh khác nhau, mỗi nhận định có citation.

**Kết quả mong đợi:** Cả hai nhận định được giữ; hồ sơ mâu thuẫn có thể được tạo; không ghi đè một giá trị lên giá trị kia.

### TC-301-11 — Khác biệt lịch không phải mâu thuẫn tự động

**Thao tác:** Nhập ngày theo âm lịch và ngày dương lịch được cho là tương ứng nhưng chưa xác minh quy đổi.

**Kết quả mong đợi:** Hệ thống cho phép ghi cả biểu thức gốc và giá trị chuẩn hóa có căn cứ; không tự kết luận mâu thuẫn hoặc tương đương khi chưa đủ thông tin.

### TC-301-12 — Dị bản tên

**Thao tác:** Ghi hai dạng tên trong hai nguồn khác nhau.

**Kết quả mong đợi:** Hai dạng được bảo toàn và gắn với citation; việc coi chúng là cùng một người cần có trạng thái/căn cứ phù hợp.

### TC-301-13 — Kết luận tạm thời

**Thao tác:** Tạo kết luận từ chứng cứ chưa đầy đủ và đánh dấu tạm thời.

**Kết quả mong đợi:** Trạng thái tạm thời, giới hạn và căn cứ hiển thị; không tự đổi thành “đã xác minh”.

### TC-301-14 — Rút lại nhận định

**Thao tác:** Rút lại một nhận định đã được dùng trong báo cáo.

**Kết quả mong đợi:** Nhận định cũ và lý do rút lại vẫn truy xuất được theo chính sách; báo cáo có thể xác định dữ liệu đã thay đổi.

### TC-301-15 — Tệp bị thay đổi

**Thao tác:** Thay đổi byte của tệp số đã có mã băm và kiểm tra lại.

**Kết quả mong đợi:** Kiểm tra toàn vẹn phát hiện hash không khớp; hệ thống không tuyên bố nội dung lịch sử chắc chắn giả chỉ dựa vào hash.

### TC-301-16 — Nguồn không còn trực tuyến

**Thao tác:** Citation trỏ đến trang web không còn truy cập được.

**Kết quả mong đợi:** Citation được giữ; trạng thái truy cập và ngày kiểm tra được cập nhật; không xóa lịch sử.

### TC-301-17 — Quyền xem tệp bị hạn chế

**Thao tác:** Người không có quyền truy cập mở citation của nguồn hạn chế.

**Kết quả mong đợi:** Không xem/tải được nội dung bị hạn chế; chỉ xem metadata được phép; không rò rỉ URL tệp riêng tư.

### TC-301-18 — Sửa phiên âm đã dùng trong kết luận

**Thao tác:** Tạo phiên bản mới của phiên âm và sửa một chữ làm thay đổi cách hiểu nhận định.

**Kết quả mong đợi:** Phiên bản cũ được bảo toàn; nhận định phụ thuộc được đánh dấu cần xem xét lại; lịch sử thể hiện người sửa và lý do.

### TC-301-19 — Không tìm thấy dữ kiện

**Thao tác:** Ghi nhận đã tra cứu một quyển gia phả nhưng không tìm thấy tên.

**Kết quả mong đợi:** Phạm vi tra cứu được lưu; hệ thống không tự kết luận người đó không tồn tại hoặc không có quan hệ với dòng họ.

### TC-301-20 — Mở lại kết luận

**Thao tác:** Thêm nguồn mới có thể ảnh hưởng kết luận đã chấp nhận.

**Kết quả mong đợi:** Kết luận có thể được mở lại; kết luận cũ, căn cứ cũ và hành động mở lại được giữ trong lịch sử.

## 21. Tiêu chí hoàn thành TFD-301

Bản triển khai được xem là đáp ứng phạm vi TFD-301 khi tối thiểu:

1. Có mô hình phân biệt nguồn, vật mang tin, citation, phiên âm/bản dịch, nhận định, liên kết chứng cứ, đánh giá và kết luận.
2. Mỗi nguồn có định danh ổn định và thông tin xuất xứ/quyền ở mức có thể biết.
3. Citation có thể định vị nội dung và liên kết đến nguồn hợp lệ.
4. Nguyên văn được bảo toàn khi tạo giá trị chuẩn hóa.
5. Nhận định quan trọng có thể truy nguyên tới chứng cứ hoặc nêu rõ ngoại lệ.
6. Hỗ trợ chứng cứ hỗ trợ, phản bác, bối cảnh và nguồn dẫn lại.
7. Cho phép giữ các nhận định mâu thuẫn và dị bản mà không ép hợp nhất.
8. Có quy trình đánh giá và kết luận với trạng thái minh bạch.
9. Có lịch sử sửa đổi, rút lại, thay thế và mở lại kết luận.
10. Quyền xem metadata và nội dung nguồn được kiểm soát theo chính sách.
11. Các ca kiểm thử phù hợp đã được thực hiện, kết quả và lỗi tồn tại được ghi nhận.
12. Các mã trạng thái, vai trò chứng cứ, rubric và ngoại lệ chưa được phê duyệt được liệt kê thành quyết định mở, không giả định là quy tắc toàn TFD.

## 22. Quyết định còn mở trước phiên bản 1.0

Các mục dưới đây cần được thảo luận và chốt trong quá trình hoàn thiện bộ TFD. Không nên âm thầm biến chúng thành yêu cầu chính thức.

### 22.1 Bộ mã trạng thái

Cần chốt danh mục mã riêng cho Source, Citation, Assertion, EvidenceAssessment, Conflict và Conclusion; quy tắc chuyển trạng thái; ai có quyền chuyển; và trạng thái nào được xuất bản.

### 22.2 Vai trò chứng cứ

Cần chốt mã chuẩn cho hỗ trợ, phản bác, bối cảnh, dẫn lại, không xác định và các trường hợp khác; xác định liên kết được gắn vào Citation, Assertion hay thực thể trung gian.

### 22.3 Rubric đánh giá

Cần quyết định TFD có cung cấp rubric tối thiểu dùng chung hay chỉ yêu cầu từng dự án công bố rubric. Nếu có rubric chung, phải định nghĩa rõ ý nghĩa từng mức, phạm vi áp dụng và cách xử lý bất đồng giữa người thẩm định.

### 22.4 Quy tắc nguồn độc lập

Cần định nghĩa cách mô hình hóa quan hệ “được sao từ”, “dẫn lại”, “cùng nguồn gốc”, “bản dịch của”, “bản biên tập từ” và mức độ chắc chắn của quan hệ phụ thuộc.

### 22.5 Mức truy nguyên bắt buộc

Cần xác định nhóm dữ kiện nào bắt buộc có citation trước khi được công bố hoặc chấp nhận; trường hợp truyền khẩu, hồ sơ không thể truy cập hoặc nguồn thất lạc được xử lý ra sao.

### 22.6 Phiên âm và ký hiệu biên tập

Cần thống nhất quy ước tối thiểu cho chữ không đọc được, phần khuyết, bổ sung của biên tập viên, chữ nghi vấn, phiên âm ngoại giao và phiên âm đọc được; cân nhắc yêu cầu riêng cho Hán Nôm.

### 22.7 Quản lý phiên bản

Cần chốt yêu cầu tối thiểu về phiên bản nội dung, diff, thời hạn lưu lịch sử và cách tái lập một kết luận tại thời điểm quá khứ.

### 22.8 Quyền riêng tư và thời hạn lưu

Cần phối hợp với TFD-401 để xác định quyền truy cập, dữ liệu người cung cấp, nội dung người còn sống, xử lý yêu cầu gỡ/xóa và thông tin tối thiểu có thể giữ trong nhật ký.

### 22.9 Tương thích GEDCOM

Cần xác định ánh xạ cho source, citation, multimedia, note, assertion, đánh giá và mâu thuẫn; trường nào không thể biểu diễn phải có báo cáo mất mát theo TFD-501.

### 22.10 Phê duyệt kết luận

Cần chốt khi nào cần người duyệt thứ hai, cách khai báo xung đột lợi ích, quy trình khi các chuyên gia bất đồng và cơ chế phản hồi từ thành viên gia đình.

### 22.11 Mức bắt buộc của kiểm thử

Cần phân loại ca kiểm thử thành bắt buộc, khuyến nghị hoặc theo loại nguồn; quy định bằng chứng kiểm thử và tiêu chí nghiệm thu trong TFD-601.

## 23. Quan hệ với các tài liệu TFD khác

| Tài liệu | Quan hệ với TFD-301 |
|---|---|
| TFD-001 | Cung cấp nguyên tắc nền: bảo toàn dữ liệu gốc, không suy luận không có căn cứ, hỗ trợ lịch sử và truy nguyên. |
| TFD-101 | Định nghĩa mô hình logic và các thực thể như Source, Citation, Assertion, EvidenceAssessment, Conclusion, MediaAsset, Transcription, Translation, Agent và ChangeLog. |
| TFD-102 | Cung cấp quy tắc định danh và quan hệ; TFD-301 yêu cầu các nhận định về quan hệ có căn cứ và giữ trạng thái tranh chấp. |
| TFD-103 | Chi tiết hóa sự kiện, niên đại, nguồn, citation và chứng cứ; TFD-301 bổ sung quy trình thao tác, đánh giá, mâu thuẫn và dị bản. |
| TFD-201 | Áp dụng quản lý chứng cứ vào tên, quan hệ, thế hệ, dòng phả hệ, chi/phái và quy tắc địa phương. |
| TFD-401 | Chi phối quyền truy cập, quyền riêng tư, phân quyền, lưu trữ và công bố. |
| TFD-501 | Quy định cách nhập/xuất nguồn và citation, chuyển đổi, báo cáo mất mát và xử lý dữ liệu không ánh xạ được. |
| TFD-601 | Chuyển các quy tắc và ví dụ trong TFD-301 thành ca kiểm thử, tiêu chí nghiệm thu và hồ sơ tuân thủ. |

Nếu TFD-103 và TFD-301 có nội dung giao nhau, TFD-103 là tài liệu tham chiếu cho quy tắc sự kiện/niên đại và mô hình nguồn/chứng cứ ở mức dữ liệu; TFD-301 là tài liệu quy trình cho việc tiếp nhận, đánh giá, xử lý dị bản và lập kết luận. Các mâu thuẫn giữa tài liệu phải được ghi thành vấn đề cần giải quyết, không tự ý ưu tiên một quy tắc chưa được phê duyệt.

## Phụ lục A — Ví dụ quy trình minh họa

### A.1 Hai nguồn ghi hai năm sinh khác nhau

**Tình huống:** Một gia phả chép năm sinh 1820; một bia mộ được đọc là năm 1823.

**Cách xử lý đề xuất:**

1. Đăng ký hai nguồn riêng, ghi rõ bản đang xem là bản gốc, bản sao hay bản chụp theo mức đã xác minh.
2. Tạo citation cho vị trí trong gia phả và vùng chữ trên bia.
3. Tạo hai assertion riêng; không sửa một giá trị để khớp giá trị còn lại.
4. Kiểm tra liệu hai năm có dùng cùng lịch, cùng cách tính hoặc cùng định nghĩa ngày sinh không.
5. Đánh giá xuất xứ, độ rõ chữ, thời điểm lập và tính độc lập của nguồn.
6. Ghi hồ sơ mâu thuẫn cùng các giả thuyết hợp lý.
7. Nếu chưa đủ căn cứ, giữ trạng thái chưa giải quyết; giao diện có thể trình bày cả hai năm cùng ghi chú.
8. Nếu sau này có nguồn mới, mở lại đánh giá và giữ lịch sử quyết định cũ.

### A.2 Bản gia phả hiện có là bản chép lại

**Tình huống:** Một bản gia phả năm 1950 ghi rằng nó được chép từ bản cũ hơn nhưng bản cũ chưa tìm thấy.

**Cách xử lý đề xuất:** Đăng ký bản năm 1950 là nguồn trực tiếp đang có; ghi lời khai về bản cũ trong trường provenance; không tạo citation giả cho bản chưa tiếp cận; không nói rằng người nghiên cứu đã kiểm tra bản cũ. Nếu bản cũ được tìm thấy sau này, tạo nguồn mới và đánh giá lại mức độ phụ thuộc.

### A.3 Dị bản tên chữ Hán/Nôm

**Tình huống:** Hai nguồn có một chữ tên đọc theo hai cách khác nhau.

**Cách xử lý đề xuất:** Giữ ảnh/vị trí chữ trong mỗi nguồn; tạo các phiên đọc riêng; ghi người đọc và lý do; liên kết chúng như các dị bản có thể cùng chỉ một người nếu có căn cứ. Không thay ảnh hoặc nguyên văn bằng cách đọc được ưu tiên. Nếu danh tính chưa chắc chắn, không tự động hợp nhất cá nhân.

### A.4 Ngày giỗ và ngày mất

**Tình huống:** Gia phả ghi ngày giỗ âm lịch, nhưng không ghi rõ ngày mất.

**Cách xử lý đề xuất:** Tạo nhận định về ngày giỗ truyền thống; không tự coi ngày đó là ngày mất. Chỉ tạo ngày mất hoặc chuyển đổi lịch khi có căn cứ và lưu cách suy luận/đối chiếu. Quy tắc chi tiết về lịch thuộc TFD-103.

### A.5 Lời kể truyền khẩu

**Tình huống:** Một thành viên gia đình kể rằng ông cố từng chuyển nơi ở sau một biến cố.

**Cách xử lý đề xuất:** Ghi người kể, thời điểm và bối cảnh; phân biệt ký ức trực tiếp với thông tin nghe kể; lập nhận định có trạng thái phù hợp; nếu không có ghi âm thì mô tả biên bản/ghi chép đang được dùng. Không tự biến lời kể thành sự kiện đã được xác minh độc lập.

## Phụ lục B — Danh sách trường dữ liệu khuyến nghị

Bảng dưới đây là danh sách khái niệm phục vụ rà soát thiết kế, không phải lược đồ SQL bắt buộc.

| Đối tượng | Trường/nhóm thông tin gợi ý | Ghi chú |
|---|---|---|
| Source | id, title/label, source_type, creator, creation_date_expression, repository_id, provenance_note, access_rights, status, created_at, updated_at | Không tạo giá trị giả khi chưa biết. |
| Source representation / MediaAsset | id, source_id, file_uri, media_type, format, byte_size, checksum, derivative_of, processing_note, created_by, created_at | Phải tuân thủ quyền truy cập; hash không chứng minh tính xác thực lịch sử. |
| SourceRepository | id, name, repository_type, location/uri, reference_code, access_conditions | Có thể là nơi lưu trữ vật lý hoặc số. |
| Transcription | id, source_id/media_asset_id, language, script, method, text, convention, version, status, agent_id, created_at | Phân biệt OCR, phiên âm chưa rà soát và phiên âm đã duyệt. |
| Translation | id, transcription_id/source_id, source_language, target_language, text, translator, version, status, notes | Bản dịch không thay thế nguyên văn. |
| Citation | id, source_id, locator_type, locator_value, quoted_text, transcription_id, media_asset_id, notes, created_by, created_at | Vị trí phù hợp theo loại nguồn. |
| Assertion | id, subject/reference, predicate/type, value/object, assertion_method, status, agent_id, created_at, updated_at | Mệnh đề nên đủ nhỏ để đánh giá độc lập. |
| Assertion–Evidence link | assertion_id, citation_id/source_id, role, rationale, created_by, created_at | Vai trò và lý do của liên kết. |
| EvidenceAssessment | id, assertion_id, scope, criteria/rubric_version, assessment, rationale, limitations, assessor_id, assessed_at | Tránh một điểm số không giải thích được. |
| Conflict | id, scope/question, assertion_ids, status, hypotheses, resolution_note, opened_at, closed_at | Có thể là thực thể riêng hoặc cấu trúc tương đương. |
| Conclusion | id, question/scope, status, summary, rationale, limitations, version, agent_id, reviewer_id, effective_at | Kết luận phải mở lại được theo quy trình. |
| Provenance relation | from_object, relation_type, to_object, certainty/note, agent_id, created_at | Ví dụ bản sao của, dịch từ, dẫn lại, tạo từ. |
| ChangeLog | id, object_type, object_id, action, before/after reference, reason, agent_id, timestamp, correlation/reference_id | Phối hợp với chính sách nhật ký và bảo mật. |

## Phụ lục C — Mẫu biên bản đánh giá nhận định

```text
Mã nhận định:
Nội dung nhận định:
Đối tượng/phạm vi:
Phương pháp hình thành: ghi trực tiếp / phiên âm / chuẩn hóa / suy luận / dẫn lại / khác

Nguồn và citation liên quan:
- Nguồn:
- Vị trí:
- Nội dung liên quan:
- Vai trò: hỗ trợ / phản bác / bối cảnh / dẫn lại / chưa xác định
- Lý do liên kết:

Đánh giá:
- Xuất xứ và tính toàn vẹn:
- Độ trực tiếp:
- Tính độc lập:
- Độ rõ và khả năng truy nguyên:
- Giới hạn/thiên lệch có thể có:
- Mâu thuẫn với nguồn khác:

Kết quả hiện tại:
Trạng thái:
Giới hạn và giả định:
Điều kiện cần xem xét lại:
Người đánh giá / ngày:
Người duyệt (nếu cần) / ngày:
Lịch sử thay đổi hoặc tham chiếu phiên bản:
```

## Phụ lục D — Tài liệu tham khảo định hướng

- **TFD-001, TFD-101, TFD-102, TFD-103 và TFD-201:** tài liệu nội bộ trong bộ TFD; cần kiểm soát phiên bản để bảo đảm thuật ngữ và mô hình thống nhất.
- **FamilySearch GEDCOM:** tài liệu tham khảo cho trao đổi dữ liệu gia phả, nguồn, trích dẫn và tư liệu đa phương tiện; phải kiểm tra phiên bản cụ thể khi thiết kế ánh xạ TFD-501.
- **W3C PROV:** mô hình khái niệm tham khảo cho xuất xứ dữ liệu và hoạt động tạo ra dữ liệu.
- **Unicode Standard:** tham khảo cho mã hóa ký tự và xử lý văn bản đa ngôn ngữ; không tự giải quyết vấn đề phiên đọc hoặc dị thể lịch sử.
- **Các quy tắc lưu trữ, bảo quản số và quyền tác giả áp dụng:** phải xác định theo loại tư liệu, nơi lưu trữ, quyền sử dụng và pháp luật có liên quan.

Các tài liệu tham khảo trên không có nghĩa TFD-301 tự động tuân thủ đầy đủ mọi tiêu chuẩn bên ngoài. Phiên bản áp dụng và phạm vi tương thích phải được xác định khi phát hành.

## Phụ lục E — Tuyên bố trạng thái

TFD-301 phiên bản 0.1 là bản dự thảo đầy đủ để thảo luận, thử nghiệm và đối chiếu với các tài liệu khác trong bộ TFD. Tài liệu chưa phải tiêu chuẩn chính thức; các mã trạng thái, vai trò chứng cứ, mức bắt buộc, mẫu dữ liệu và rubric đánh giá nêu trong tài liệu là đề xuất cho đến khi được phê duyệt.

Trước khi công bố phiên bản 1.0, cần rà soát tính nhất quán với TFD-001, TFD-101, TFD-102, TFD-103, TFD-201 và các tài liệu TFD-401, TFD-501, TFD-601; giải quyết các quyết định mở; thực hiện kiểm thử với tư liệu gia phả thực tế; ghi nhận kết quả và phê duyệt theo cơ chế quản trị TFD.
