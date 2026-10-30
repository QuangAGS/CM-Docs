# TFD-601 — Bộ kiểm thử tuân thủ và tiêu chí nghiệm thu

## Kiểm soát tài liệu

| Thuộc tính | Giá trị |
|---|---|
| Mã tài liệu | TFD-601 |
| Tên | Bộ kiểm thử tuân thủ và tiêu chí nghiệm thu |
| Bộ tài liệu | TFD — Family Tree Doctrine |
| Phiên bản | 0.1 |
| Ngày lập | 21/10/2026 |
| Trạng thái | Dự thảo đầy đủ để rà soát và thử nghiệm; chưa phải tiêu chuẩn chính thức |
| Chủ sở hữu | Chưa xác định — cần quyết định trong quản trị TFD |
| Phạm vi áp dụng | Phần mềm, dịch vụ, quy trình và bộ chuyển đổi dữ liệu tuyên bố tuân thủ TFD |
| Tài liệu liên quan | TFD-001, TFD-101, TFD-102, TFD-103, TFD-201, TFD-301, TFD-401, TFD-501 |

### Lịch sử phiên bản

| Phiên bản | Ngày | Nội dung |
|---|---|---|
| 0.1 | 21/10/2026 | Bản dự thảo đầu tiên: mô hình tuân thủ, ma trận truy vết, bộ ca kiểm thử và tiêu chí nghiệm thu. |

### Quy ước từ ngữ quy phạm

- **MUST / PHẢI**: yêu cầu bắt buộc để đạt mức tuân thủ có áp dụng yêu cầu đó.
- **MUST NOT / KHÔNG ĐƯỢC**: hành vi bị cấm.
- **SHOULD / NÊN**: khuyến nghị mạnh; nếu không thực hiện phải nêu lý do và rủi ro.
- **MAY / CÓ THỂ**: tùy chọn được phép.
- **N/A / Không áp dụng**: chỉ được dùng khi có giải thích và bằng chứng cho thấy yêu cầu nằm ngoài phạm vi sản phẩm.
- **Ca kiểm thử**: phép kiểm tra có mã, tiền điều kiện, dữ liệu, thao tác, kết quả mong đợi và bằng chứng.

Các mã, ngưỡng và mức tuân thủ trong bản 0.1 là đề xuất để thử nghiệm. Không được diễn giải chúng thành quyết định quản trị đã được phê chuẩn.

---

## 1. Mục đích

TFD-601 định nghĩa cách kiểm tra một sản phẩm hoặc quy trình có thực hiện đúng các yêu cầu TFD đã tuyên bố hay không. Tài liệu tạo ra một cơ chế kiểm chứng có thể lặp lại, có bằng chứng và truy nguyên từ yêu cầu đến kết quả thử nghiệm.

TFD-601 nhằm:

1. Biến các nguyên tắc TFD thành kiểm tra cụ thể, có thể quan sát và tái thực hiện.
2. Xác định phạm vi tuyên bố tuân thủ; không cho phép tuyên bố chung chung khi chỉ kiểm tra một phần.
3. Kiểm tra cả dữ liệu, hành vi nghiệp vụ, giao diện, nhập/xuất, bảo mật và khả năng khôi phục.
4. Bảo đảm lỗi hoặc thiếu dữ liệu không bị âm thầm biến thành kết luận chắc chắn.
5. Bảo đảm kết quả kiểm thử có thể được tái lập trên cùng phiên bản sản phẩm, cấu hình và bộ dữ liệu.
6. Cung cấp tiêu chí nghiệm thu, báo cáo sai lệch và quy trình xử lý ngoại lệ.

## 2. Phạm vi

### 2.1 Trong phạm vi

- Tính toàn vẹn và ổn định của định danh.
- Biểu diễn cá nhân, tên, quan hệ, sự kiện, niên đại, địa điểm, nguồn, trích dẫn, nhận định, đánh giá chứng cứ, kết luận và lịch sử thay đổi.
- Quy tắc gia phả Việt Nam: dòng họ, chi/phái, tư cách thành viên, đời thứ, thứ tự con, tên và biến thể, lịch âm/dương, địa danh lịch sử.
- Quy trình quản lý nguồn, chứng cứ, dị bản, mâu thuẫn và sửa đổi.
- Quyền truy cập, quyền riêng tư, dữ liệu người còn sống, nhật ký bảo mật và vận hành quản trị.
- Nhập/xuất GEDCOM hoặc định dạng khác được sản phẩm tuyên bố hỗ trợ; báo cáo mất mát và xung đột.
- Giao diện hiển thị và báo cáo khi có nguy cơ gây hiểu nhầm về quan hệ, độ chắc chắn hoặc dữ liệu thiếu.
- Tính tái lập của kiểm thử, báo cáo và bằng chứng nghiệm thu.

### 2.2 Ngoài phạm vi

TFD-601 không tự xác định chân lý lịch sử của một phả hệ; không thay thế việc thẩm định chuyên môn gia phả, pháp lý, bảo mật độc lập hoặc kiểm toán theo luật; không phê chuẩn một hồ sơ GEDCOM cụ thể nếu TFD-501 chưa xác định phiên bản/hồ sơ tương ứng; không biến các quy ước gia tộc địa phương thành quy tắc phổ quát.

### 2.3 Đối tượng áp dụng

- **Sản phẩm dữ liệu gia phả**: phần mềm hoặc dịch vụ lưu trữ, biên tập và xuất bản dữ liệu.
- **Bộ chuyển đổi**: công cụ nhập, xuất, đồng bộ hoặc di trú dữ liệu.
- **Quy trình vận hành**: quy trình duyệt, sửa, công bố, sao lưu, khôi phục và xử lý yêu cầu dữ liệu.
- **Bộ tích hợp**: thành phần kết nối hệ thống khác và có thể làm thay đổi hoặc truyền dữ liệu TFD.

Mỗi đối tượng chỉ được đánh giá trên phạm vi, phiên bản, cấu hình và chức năng được khai báo trong hồ sơ kiểm thử.

## 3. Nguyên tắc kiểm thử

### 3.1 Truy vết hai chiều

Mỗi yêu cầu bắt buộc áp dụng phải truy được đến ít nhất một ca kiểm thử hoặc một phương pháp kiểm chứng được phê duyệt. Mỗi ca kiểm thử phải nêu yêu cầu, tài liệu nguồn và phiên bản liên quan. Kết quả kiểm thử phải truy ngược được đến lần chạy cụ thể và bằng chứng.

### 3.2 Kiểm thử theo rủi ro

Ưu tiên kiểm thử các lỗi có thể làm sai lệch quan hệ gia đình, mất nguồn gốc dữ liệu, công bố trái phép dữ liệu cá nhân, phá hủy lịch sử hoặc gây mất dữ liệu khi nhập/xuất.

### 3.3 Không kiểm thử chỉ bằng giao diện

Các yêu cầu về toàn vẹn dữ liệu phải được kiểm tra ở lớp dữ liệu/API hoặc bằng xuất dữ liệu kiểm tra, không chỉ dựa vào hình ảnh trên giao diện. Ngược lại, các yêu cầu về thông báo, cảnh báo và khả năng người dùng hiểu đúng phải được kiểm tra trên giao diện thực tế.

### 3.4 Không sửa dữ liệu âm thầm

Khi dữ liệu mơ hồ, mâu thuẫn hoặc không thể ánh xạ, hệ thống phải bảo toàn nguyên bản và hiển thị cảnh báo, yêu cầu lựa chọn hoặc ghi nhận báo cáo. Ca kiểm thử không được coi việc tự đoán giá trị là kết quả đạt.

### 3.5 Dữ liệu kiểm thử an toàn

Bộ kiểm thử mặc định phải dùng dữ liệu tổng hợp. Dữ liệu thật chỉ được dùng khi đã có căn cứ, phê duyệt, giảm thiểu dữ liệu và kiểm soát truy cập phù hợp theo TFD-401.

### 3.6 Lặp lại được

Một lần chạy phải ghi lại phiên bản ứng dụng, phiên bản bộ quy tắc TFD, cấu hình, phiên bản bộ dữ liệu, môi trường, thời gian, kết quả và mã bằng chứng. Không được kết luận đạt nếu không xác định được đối tượng đã thử.

## 4. Thuật ngữ

- **Yêu cầu kiểm thử**: một yêu cầu TFD có thể xác minh bằng phép kiểm tra.
- **Ca kiểm thử (test case)**: định nghĩa một kịch bản thử nghiệm cụ thể.
- **Lần chạy (test run)**: việc thực thi một ca kiểm thử trên môi trường và phiên bản xác định.
- **Bằng chứng**: log, bản ghi, ảnh chụp giao diện đã che dữ liệu, báo cáo nhập/xuất, checksum, truy vấn kiểm tra hoặc tài liệu khác hỗ trợ kết luận.
- **Sai lệch (deviation)**: khác biệt giữa hành vi thực tế và yêu cầu áp dụng.
- **Lỗi chặn nghiệm thu (blocker)**: lỗi khiến không thể chấp nhận phạm vi đánh giá.
- **Không phù hợp nghiêm trọng (critical)**: lỗi có nguy cơ gây mất dữ liệu, lộ dữ liệu nghiêm trọng, thay đổi quan hệ/dữ kiện không thể truy nguyên hoặc phá vỡ tính toàn vẹn cốt lõi.
- **Ngoại lệ được chấp thuận**: sai lệch có hồ sơ, đánh giá rủi ro, biện pháp giảm thiểu, người phê duyệt và thời hạn xem xét.
- **Bộ dữ liệu chuẩn (fixture)**: dữ liệu kiểm thử có cấu trúc, phiên bản và kết quả mong đợi đã xác định.
- **Kiểm thử âm tính**: kiểm tra rằng hành động không hợp lệ hoặc không được phép bị từ chối đúng cách.

## 5. Mô hình tuân thủ đề xuất

### 5.1 Tuyên bố tuân thủ theo phạm vi

Không dùng một nhãn “tuân thủ TFD” đơn lẻ nếu chưa xác định rõ các tài liệu, phiên bản, mô-đun và chức năng được đánh giá. Hồ sơ phải nêu ít nhất:

- Tên sản phẩm/thành phần và đơn vị chịu trách nhiệm.
- Phiên bản phát hành hoặc mã commit/build.
- Phiên bản TFD được viện dẫn.
- Chức năng trong phạm vi và ngoài phạm vi.
- Các yêu cầu áp dụng, không áp dụng và lý do.
- Kết quả kiểm thử, ngoại lệ, rủi ro còn lại và ngày đánh giá.

### 5.2 Các mức tuân thủ đề xuất

Các mức dưới đây là đề xuất của bản 0.1, cần được cơ quan quản trị TFD phê chuẩn trước khi dùng làm chứng nhận chính thức.

| Mức | Tên đề xuất | Phạm vi tối thiểu |
|---|---|---|
| T0 | Khai báo | Công bố phạm vi, phiên bản TFD và danh sách tính năng; chưa được coi là đã kiểm chứng. |
| T1 | Toàn vẹn dữ liệu cốt lõi | Định danh ổn định, kiểu quan hệ, dữ liệu chưa chắc chắn, lịch sử và các ràng buộc dữ liệu áp dụng. |
| T2 | Nguồn và quy tắc gia phả | T1 cộng với nguồn/chứng cứ/dị bản và quy tắc TFD-201/301 áp dụng. |
| T3 | Bảo mật và trao đổi dữ liệu | T2 cộng với TFD-401 và các chức năng nhập/xuất TFD-501 được tuyên bố hỗ trợ. |
| T4 | Tuân thủ phạm vi đầy đủ | Tất cả yêu cầu bắt buộc áp dụng trong các tài liệu TFD đã được sản phẩm viện dẫn, với bằng chứng nghiệm thu và quy trình tái kiểm thử. |

Không được suy ra rằng T1–T4 là chứng chỉ độc lập hoặc bảo đảm an toàn tuyệt đối. Chỉ cơ chế quản trị được phê chuẩn mới có quyền xác lập chương trình chứng nhận.

### 5.3 Quy tắc tính kết quả

- Mọi ca kiểm thử bắt buộc trong phạm vi phải có kết quả **Đạt** để kết luận đạt mức tương ứng, trừ khi ngoại lệ đã được phê chuẩn theo quy trình.
- **Không đạt** không được đổi thành **Không áp dụng** chỉ để tăng tỷ lệ đạt.
- **Chưa chạy**, **Bị chặn** và **Thiếu bằng chứng** không được tính là Đạt.
- Tỷ lệ đạt có thể báo cáo để tham khảo, nhưng không thay thế điều kiện bắt buộc và phân loại mức độ lỗi.

## 6. Ma trận truy vết tài liệu

| Tài liệu | Vùng cần kiểm chứng | Nhóm kiểm thử chính |
|---|---|---|
| TFD-001 | Nguyên tắc nền tảng, tách dữ kiện/diễn giải/kết luận, riêng tư, kiểm thử | Tính toàn vẹn, nguồn gốc, không suy diễn, lịch sử, riêng tư |
| TFD-101 | Thực thể và mô hình dữ liệu logic | Định danh, khóa liên kết, kiểu dữ liệu, toàn vẹn tham chiếu |
| TFD-102 | Định danh và quan hệ | Trùng người, hợp nhất, kiểu quan hệ, đời thứ và cảnh báo |
| TFD-103 | Sự kiện, niên đại, nguồn và chứng cứ | Ngày không đầy đủ, lịch, sự kiện, citation, assertion, evidence |
| TFD-201 | Quy tắc gia phả Việt Nam và chi phái | Dòng/chi, thành viên, thế hệ, tên, lịch, địa danh và quy ước địa phương |
| TFD-301 | Quy trình quản lý nguồn, chứng cứ và dị bản | Provenance, bản gốc/bản dẫn xuất, mâu thuẫn, đánh giá, sửa đổi |
| TFD-401 | Bảo mật, phân quyền và quản trị | Phân quyền, người còn sống, công bố, nhật ký, sao lưu/khôi phục |
| TFD-501 | Nhập/xuất và chuyển đổi | Tương thích, ánh xạ, mã hóa, trùng lặp, mất mát và manifest |
| TFD-601 | Quy trình kiểm thử và nghiệm thu | Truy vết, tái lập, báo cáo, ngoại lệ và tái kiểm thử |

Đây là ma trận cấp cao. Trước khi phát hành bản TFD-601 v1.0, mỗi yêu cầu bắt buộc trong từng tài liệu phải được ánh xạ tới mã kiểm thử cụ thể hoặc được ghi rõ là chưa có phương pháp kiểm chứng.

## 7. Yêu cầu tổ chức bộ kiểm thử

### 7.1 Nhóm kiểm thử bắt buộc

1. **Mô hình dữ liệu**: định danh, liên kết, kiểu dữ liệu, ràng buộc và trạng thái.
2. **Nghiệp vụ gia phả**: quan hệ, chi phái, đời thứ, tên và quy ước địa phương.
3. **Nguồn và nghiên cứu**: nguồn, trích dẫn, nhận định, đánh giá chứng cứ, kết luận, dị bản.
4. **Niên đại và địa điểm**: độ chính xác ngày, lịch âm/dương, can chi/niên hiệu nếu hỗ trợ, địa danh biến thể.
5. **Giao diện và khả năng hiểu đúng**: nhãn quan hệ, cảnh báo, trạng thái chưa chắc chắn, thông báo mất dữ liệu.
6. **Bảo mật và quyền riêng tư**: quyền tối thiểu, kiểm tra truy cập, công bố, nhật ký và dữ liệu nhạy cảm.
7. **Nhập/xuất**: định dạng hỗ trợ, lỗi tệp, ký tự, trùng lặp, xung đột, báo cáo mất mát.
8. **Khôi phục và vận hành**: sao lưu, phục hồi, sự cố, lưu giữ và tính nhất quán sau khôi phục.
9. **Hồi quy**: bảo đảm sửa lỗi không làm hỏng chức năng đã đạt.
10. **Khả năng tái lập**: dữ liệu chuẩn, cấu hình, bằng chứng và báo cáo.

### 7.2 Phân loại kỹ thuật kiểm thử

- Kiểm thử đơn vị.
- Kiểm thử tích hợp.
- Kiểm thử API và hợp đồng dữ liệu.
- Kiểm thử cơ sở dữ liệu và ràng buộc toàn vẹn.
- Kiểm thử giao diện thủ công hoặc tự động.
- Kiểm thử nhập/xuất và so sánh dữ liệu trước/sau.
- Kiểm thử bảo mật âm tính.
- Kiểm thử khôi phục và diễn tập vận hành.
- Rà soát thủ công có biên bản đối với yêu cầu không thể tự động hóa đáng tin cậy.

Một yêu cầu có thể cần nhiều kỹ thuật. Kiểm thử tự động không thay thế việc xem xét thủ công khi yêu cầu liên quan đến cách trình bày, khả năng hiểu đúng hoặc phán đoán của người nghiên cứu.

## 8. Bộ dữ liệu kiểm thử chuẩn

### 8.1 Nguyên tắc

Bộ dữ liệu chuẩn phải nhỏ, có thể tái tạo, không chứa dữ liệu cá nhân thật và bao gồm cả trường hợp bình thường lẫn trường hợp biên. Mỗi fixture phải có mã, phiên bản, mô tả, dữ liệu đầu vào, trạng thái ban đầu, thao tác dự kiến và kết quả mong đợi.

### 8.2 Fixture tối thiểu đề xuất

| Mã | Nội dung | Mục tiêu |
|---|---|---|
| FIX-01 | Gia đình ba thế hệ với định danh riêng biệt | Kiểm tra định danh và liên kết cơ bản |
| FIX-02 | Một người có tên khai sinh, tên húy, tên tự hoặc tên gọi khác | Bảo toàn nhiều tên và vai trò tên |
| FIX-03 | Quan hệ cha/mẹ–con có kiểu quan hệ khác nhau | Không gộp quan hệ sinh học, pháp lý, nuôi dưỡng hoặc giám hộ |
| FIX-04 | Một người là thành viên của chi phái nhưng quan hệ huyết thống chưa xác minh | Tách tư cách dòng họ khỏi quan hệ huyết thống |
| FIX-05 | Đời thứ theo hai bộ quy tắc khác nhau | Bảo đảm phạm vi và quy tắc tính đời được nêu rõ |
| FIX-06 | Ngày chỉ có năm; khoảng thời gian; ngày âm lịch; nguyên văn niên đại | Không tự thêm độ chính xác không có trong nguồn |
| FIX-07 | Địa danh lịch sử với nhiều tên theo thời kỳ | Bảo toàn tên gốc và tên chuẩn hóa |
| FIX-08 | Hai nguồn mâu thuẫn về ngày sinh hoặc quan hệ | Bảo toàn bất đồng và provenance |
| FIX-09 | Nguồn, bản sao, bản dịch, phiên âm và trích dẫn | Giữ liên kết giữa nguồn và nhận định |
| FIX-10 | Cá nhân giả lập còn sống và trường dữ liệu nhạy cảm | Kiểm tra quyền riêng tư và công bố |
| FIX-11 | Tệp nhập có ký tự tiếng Việt và Hán-Nôm | Kiểm tra Unicode và khả năng đọc lại |
| FIX-12 | Tệp nhập có bản ghi trùng, tham chiếu thiếu và trường không hỗ trợ | Kiểm tra cảnh báo, xung đột và báo cáo mất mát |
| FIX-13 | Người dùng có quyền đọc nhưng không có quyền sửa/xuất | Kiểm tra phân quyền theo hành động |
| FIX-14 | Lịch sử chỉnh sửa, hợp nhất và hoàn tác nếu hỗ trợ | Kiểm tra truy nguyên và phục hồi |
| FIX-15 | Bộ dữ liệu tối thiểu trước/sau xuất nhập | Kiểm tra đối chiếu, manifest và sai khác |

Mỗi fixture phải được lưu cùng mã băm hoặc phương pháp nhận diện phiên bản tương đương. Không đưa dữ liệu cá nhân thật vào kho fixture công khai.

## 9. Quy tắc đánh giá ca kiểm thử

### 9.1 Trạng thái

| Trạng thái | Ý nghĩa |
|---|---|
| PASS — Đạt | Kết quả thực tế đáp ứng toàn bộ điều kiện đạt đã định nghĩa và có bằng chứng. |
| FAIL — Không đạt | Kết quả thực tế vi phạm ít nhất một điều kiện bắt buộc. |
| BLOCKED — Bị chặn | Không thể thực thi do môi trường, quyền, phụ thuộc hoặc dữ liệu chuẩn không sẵn sàng. |
| NOT RUN — Chưa chạy | Chưa thực thi. |
| N/A — Không áp dụng | Có lý do và phê duyệt hoặc căn cứ phạm vi rõ ràng. |
| INCONCLUSIVE — Chưa kết luận | Bằng chứng chưa đủ để xác định đạt hay không đạt. |

### 9.2 Mức độ phát hiện

| Mức | Mô tả | Ví dụ minh họa |
|---|---|---|
| S0 — Critical | Lộ dữ liệu nghiêm trọng; mất hoặc sửa sai dữ liệu cốt lõi không truy nguyên; thay đổi quan hệ quan trọng âm thầm; phá hủy dữ liệu diện rộng | Người không có quyền tải dữ liệu nhạy cảm; nhập tệp làm ghi đè hàng loạt mà không có khả năng khôi phục |
| S1 — High | Sai lệch đáng kể về quan hệ, nguồn, lịch sử, phân quyền hoặc mất mát xuất dữ liệu không được báo cáo | Quan hệ nhận nuôi bị đổi thành quan hệ sinh học; nguồn gốc nhận định bị mất |
| S2 — Medium | Chức năng quan trọng suy giảm nhưng có thể khoanh vùng, không gây mất dữ liệu nghiêm trọng | Cảnh báo xung đột không hiện ở một luồng phụ |
| S3 — Low | Lỗi trình bày hoặc tiện ích không ảnh hưởng đến tính đúng đắn cốt lõi | Nhãn hiển thị chưa nhất quán nhưng dữ liệu vẫn đúng |

Ví dụ chỉ nhằm hướng dẫn phân loại. Mức độ thực tế phải căn cứ tác động, khả năng khai thác, phạm vi ảnh hưởng và khả năng khôi phục.

### 9.3 Điều kiện đạt của một ca

Một ca chỉ được đánh dấu PASS khi:

1. Tiền điều kiện được xác nhận.
2. Đúng phiên bản và fixture đã khai báo được sử dụng.
3. Tất cả bước bắt buộc được thực hiện.
4. Kết quả thực tế phù hợp tiêu chí đạt.
5. Bằng chứng được lưu và liên kết với mã lần chạy.
6. Không có tác dụng phụ trái yêu cầu phát hiện trong phạm vi ca.

## 10. Quy trình kiểm thử và nghiệm thu

### 10.1 Chuẩn bị

- Chốt phạm vi và tài liệu TFD áp dụng.
- Ghi nhận phiên bản phần mềm, cấu hình và môi trường.
- Kiểm tra bộ fixture, quyền truy cập và dữ liệu giả lập.
- Lập ma trận yêu cầu–ca kiểm thử.
- Xác định người thực hiện, người rà soát và người có thẩm quyền chấp thuận.

### 10.2 Thực thi

1. Tạo mã lần chạy duy nhất.
2. Ghi lại trạng thái môi trường và phiên bản.
3. Khôi phục trạng thái đầu vào theo fixture.
4. Thực hiện các bước theo thứ tự đã định nghĩa.
5. Thu thập bằng chứng tối thiểu, không ghi lộ dữ liệu nhạy cảm.
6. Ghi kết quả thực tế, trạng thái, lỗi và mức độ.
7. Nếu bị chặn, ghi nguyên nhân và điều kiện để chạy lại; không coi là đạt.

### 10.3 Xử lý lỗi

- Tạo mã lỗi hoặc liên kết đến hệ thống quản lý lỗi.
- Mô tả bước tái hiện, kết quả mong đợi, kết quả thực tế và tác động.
- Đính kèm bằng chứng đã giảm thiểu dữ liệu nhạy cảm.
- Phân loại mức độ và phạm vi ảnh hưởng.
- Sau khi sửa, chạy lại ca lỗi và các ca hồi quy liên quan.
- Không đóng lỗi chỉ dựa trên việc giao diện không còn hiển thị triệu chứng nếu dữ liệu nền chưa được xác minh.

### 10.4 Nghiệm thu

Người nghiệm thu rà soát phạm vi, ma trận truy vết, kết quả, lỗi còn mở, ngoại lệ, bằng chứng và rủi ro còn lại. Kết luận phải ghi rõ **Đạt**, **Đạt có ngoại lệ** hoặc **Không đạt** cho phạm vi cụ thể. “Đạt có ngoại lệ” chỉ được dùng khi chính sách quản trị cho phép và ngoại lệ có người phê duyệt, thời hạn, biện pháp giảm thiểu và kế hoạch đóng.

### 10.5 Tái kiểm thử

Phải đánh giá nhu cầu tái kiểm thử khi có thay đổi đối với:

- Mô hình dữ liệu, khóa, kiểu quan hệ hoặc ràng buộc.
- Logic định danh, hợp nhất, đời thứ, chi phái hoặc ngày tháng.
- Cấu trúc nguồn/chứng cứ hoặc lịch sử chỉnh sửa.
- Quyền truy cập, chính sách công bố hoặc xử lý dữ liệu người còn sống.
- Bộ phân tích/ghi GEDCOM, ánh xạ, mã hóa hoặc báo cáo mất mát.
- Cơ chế sao lưu, khôi phục hoặc lưu giữ.
- Phiên bản TFD hoặc cấu hình được viện dẫn.

Mức độ tái kiểm thử phụ thuộc tác động thay đổi; mọi quyết định bỏ qua ca hồi quy phải có lý do ghi nhận.

## 11. Định dạng hồ sơ ca kiểm thử

Mỗi ca kiểm thử phải có các trường tối thiểu:

| Trường | Nội dung |
|---|---|
| Test Case ID | Mã duy nhất, không tái sử dụng |
| Tiêu đề | Mục tiêu kiểm tra |
| Tài liệu/yêu cầu nguồn | Mã tài liệu, mục hoặc mã yêu cầu |
| Mức độ | Bắt buộc, khuyến nghị hoặc tùy chọn theo phạm vi |
| Rủi ro | Tác động nếu yêu cầu không được đáp ứng |
| Tiền điều kiện | Trạng thái môi trường, quyền và dữ liệu |
| Fixture | Mã bộ dữ liệu và phiên bản |
| Các bước | Trình tự thực hiện cụ thể |
| Kết quả mong đợi | Điều kiện quan sát được, có thể xác minh |
| Kết quả thực tế | Quan sát được trong lần chạy |
| Trạng thái | PASS/FAIL/BLOCKED/NOT RUN/N/A/INCONCLUSIVE |
| Bằng chứng | Mã tệp/log/báo cáo/checksum hoặc tham chiếu lưu trữ |
| Người thực hiện/ngày | Thông tin truy nguyên cần thiết |
| Lỗi liên quan | Mã lỗi, nếu có |
| Ghi chú | Sai lệch, giới hạn và quyết định liên quan |

## 12. Bộ ca kiểm thử tuân thủ TFD-601

Các ca dưới đây là bộ lõi đề xuất. Trước khi công bố bản 1.0, cần bổ sung liên kết tới mã yêu cầu cụ thể trong từng tài liệu và xác nhận tiêu chí theo mô hình dữ liệu thực tế của sản phẩm.

### Nhóm A — Định danh và toàn vẹn dữ liệu

#### TC-601-001 — Định danh cá nhân ổn định
- **Yêu cầu nguồn:** TFD-001 P-01; TFD-101; TFD-102.
- **Tiền điều kiện:** Có fixture FIX-01.
- **Thực hiện:** Tạo cá nhân; sửa tên và thông tin không định danh; tải lại hồ sơ; xuất rồi nhập lại theo luồng được hỗ trợ.
- **Mong đợi:** Định danh nội bộ không đổi do chỉ sửa thuộc tính; các liên kết đến cá nhân vẫn đúng; định danh không bị tái sử dụng cho cá nhân khác.
- **Bằng chứng:** ID trước/sau, liên kết tham chiếu và kết quả đối chiếu.

#### TC-601-002 — Nhiều tên của cùng một cá nhân
- **Yêu cầu nguồn:** TFD-101; TFD-102; TFD-201.
- **Tiền điều kiện:** FIX-02.
- **Thực hiện:** Thêm tên gốc và các biến thể; đặt vai trò/nguồn nếu được hỗ trợ; hiển thị và xuất dữ liệu.
- **Mong đợi:** Các tên được giữ như những biến thể có ngữ cảnh; không tạo cá nhân mới chỉ vì tên khác; tên gốc không bị ghi đè âm thầm.

#### TC-601-003 — Kiểu quan hệ không bị đồng nhất
- **Yêu cầu nguồn:** TFD-001 P-05; TFD-102; TFD-201.
- **Tiền điều kiện:** FIX-03.
- **Thực hiện:** Tạo các quan hệ sinh học, pháp lý, nuôi dưỡng hoặc giám hộ theo khả năng mô hình.
- **Mong đợi:** Mỗi quan hệ giữ đúng kiểu và vai trò; giao diện, API và xuất dữ liệu không tự chuyển thành cùng một loại quan hệ nếu không có quy tắc ánh xạ minh bạch.

#### TC-601-004 — Tư cách dòng họ tách khỏi huyết thống
- **Yêu cầu nguồn:** TFD-102; TFD-201.
- **Tiền điều kiện:** FIX-04.
- **Thực hiện:** Gán cá nhân vào dòng/chi nhưng không tạo quan hệ huyết thống đã xác minh.
- **Mong đợi:** Thành viên được biểu diễn đúng tư cách; hệ thống không tự tạo quan hệ cha–con hoặc tổ tiên–hậu duệ.

#### TC-601-005 — Ràng buộc tham chiếu và dữ liệu mồ côi
- **Yêu cầu nguồn:** TFD-101; TFD-102.
- **Thực hiện:** Thử tạo tham chiếu đến cá nhân hoặc nguồn không tồn tại, rồi kiểm tra dữ liệu sau thao tác.
- **Mong đợi:** Hành vi bị từ chối hoặc được xử lý theo chính sách rõ ràng; không để liên kết mồ côi không được phát hiện; lỗi được báo có thể truy nguyên.

### Nhóm B — Đời thứ, chi phái và quy tắc Việt Nam

#### TC-601-006 — Đời thứ có phạm vi và quy tắc
- **Yêu cầu nguồn:** TFD-102; TFD-201.
- **Tiền điều kiện:** FIX-05.
- **Thực hiện:** Gán đời thứ theo hai bộ quy tắc khác nhau trong các phạm vi riêng.
- **Mong đợi:** Mỗi giá trị đời thứ gắn với dòng/chi hoặc bộ quy tắc tương ứng; không tự coi đời thứ là tuổi hoặc một con số phổ quát cho mọi phả hệ.

#### TC-601-007 — Thứ tự con không bị suy ra từ thứ tự hiển thị
- **Yêu cầu nguồn:** TFD-102; TFD-201.
- **Thực hiện:** Thay đổi bố cục sơ đồ hoặc cách sắp xếp danh sách mà không sửa dữ liệu thứ tự con.
- **Mong đợi:** Dữ liệu thứ tự con không đổi chỉ vì thay đổi vị trí hiển thị; nếu thứ tự chưa rõ, hệ thống không tự tạo thứ tự chắc chắn.

#### TC-601-008 — Quy ước địa phương có phạm vi
- **Yêu cầu nguồn:** TFD-001 P-08/P-13; TFD-201.
- **Thực hiện:** Tạo hoặc áp dụng một quy tắc địa phương cho một dòng họ/chi cụ thể.
- **Mong đợi:** Quy tắc không tự áp dụng cho phạm vi khác; người dùng có thể xác định quy tắc và phạm vi dùng trong báo cáo.

#### TC-601-009 — Bảo toàn tên chữ và biến thể
- **Yêu cầu nguồn:** TFD-201; TFD-301.
- **Thực hiện:** Lưu tên tiếng Việt, dạng Hán-Nôm nếu có, phiên âm, dịch nghĩa và chú giải.
- **Mong đợi:** Nguyên bản và các lớp biên tập được phân biệt; không thay thế ký tự gốc bằng phiên âm hoặc dịch nghĩa.

### Nhóm C — Sự kiện và niên đại

#### TC-601-010 — Không tăng độ chính xác ngày tháng
- **Yêu cầu nguồn:** TFD-001 P-06; TFD-103; TFD-201.
- **Tiền điều kiện:** FIX-06.
- **Thực hiện:** Nhập dữ liệu chỉ có năm hoặc tháng/năm; lưu, tải lại và xuất.
- **Mong đợi:** Phần chưa biết vẫn chưa biết; hệ thống không tự thêm ngày hoặc tháng; nguyên văn nguồn được bảo toàn nếu có.

#### TC-601-011 — Bảo toàn loại lịch và nguyên văn niên đại
- **Yêu cầu nguồn:** TFD-103; TFD-201.
- **Thực hiện:** Nhập ngày âm lịch hoặc niên đại nguyên văn theo khả năng hỗ trợ; hiển thị và xuất.
- **Mong đợi:** Không nhầm ngày âm với ngày dương; chuyển đổi nào được thực hiện phải có quy tắc và có thể truy nguyên; giá trị nguyên văn không bị mất.

#### TC-601-012 — Địa danh lịch sử và tên biến thể
- **Yêu cầu nguồn:** TFD-103; TFD-201.
- **Tiền điều kiện:** FIX-07.
- **Thực hiện:** Gắn sự kiện với địa danh có tên theo nhiều thời kỳ.
- **Mong đợi:** Tên được ghi trong nguồn và tên chuẩn hóa có thể cùng tồn tại; hệ thống không viết lại tên lịch sử thành tên hiện đại mà không giữ thông tin gốc.

### Nhóm D — Nguồn, chứng cứ, dị bản và lịch sử

#### TC-601-013 — Nhận định có thể truy về nguồn
- **Yêu cầu nguồn:** TFD-001 P-04; TFD-103; TFD-301.
- **Thực hiện:** Tạo nguồn, trích dẫn, nhận định và kết luận; truy ngược từ kết luận về nguồn.
- **Mong đợi:** Quan hệ truy nguyên được giữ; hệ thống không trình bày kết luận như dữ kiện gốc nếu đó là diễn giải.

#### TC-601-014 — Bản gốc, bản sao, phiên âm và bản dịch
- **Yêu cầu nguồn:** TFD-301.
- **Thực hiện:** Tạo nguồn gốc và các bản dẫn xuất; chỉnh sửa bản dịch.
- **Mong đợi:** Các lớp nội dung và quan hệ xuất xứ được giữ riêng; sửa bản dịch không làm đổi nội dung bản gốc.

#### TC-601-015 — Bảo toàn mâu thuẫn giữa các nguồn
- **Yêu cầu nguồn:** TFD-001 P-14; TFD-301.
- **Tiền điều kiện:** FIX-08.
- **Thực hiện:** Ghi hai nguồn đưa ra ngày sinh hoặc quan hệ khác nhau.
- **Mong đợi:** Cả hai mệnh đề và nguồn vẫn tồn tại; hệ thống có thể ghi nhận đánh giá/kết luận nhưng không âm thầm xóa một phía.

#### TC-601-016 — Không tạo độ chắc chắn giả
- **Yêu cầu nguồn:** TFD-001 P-02/P-06; TFD-103; TFD-301.
- **Thực hiện:** Lưu nhận định chưa đủ chứng cứ và xem báo cáo/sơ đồ.
- **Mong đợi:** Trạng thái bất định được biểu diễn rõ; không tự nâng thành kết luận xác thực; không dùng một điểm số đơn lẻ thay cho giải thích khi tài liệu nguồn yêu cầu giải thích.

#### TC-601-017 — Sửa đổi có lịch sử
- **Yêu cầu nguồn:** TFD-001 P-09; TFD-101; TFD-301.
- **Thực hiện:** Sửa một dữ kiện hoặc nhận định; kiểm tra lịch sử và thông tin người thực hiện nếu chức năng được hỗ trợ.
- **Mong đợi:** Thay đổi có thể truy nguyên; dữ liệu cũ không bị xóa mất nếu chính sách yêu cầu giữ lịch sử; quyền xem lịch sử được kiểm soát.

### Nhóm E — Bảo mật và quyền riêng tư

#### TC-601-018 — Quyền tối thiểu theo hành động
- **Yêu cầu nguồn:** TFD-401.
- **Tiền điều kiện:** FIX-13.
- **Thực hiện:** Tài khoản chỉ có quyền đọc thử sửa, xóa, xuất, chia sẻ hoặc đổi quyền.
- **Mong đợi:** Mỗi hành động trái quyền bị từ chối ở phía máy chủ/API, không chỉ ẩn nút trên giao diện; không có thay đổi dữ liệu ngoài ý muốn.

#### TC-601-019 — Dữ liệu người còn sống không bị công bố mặc định
- **Yêu cầu nguồn:** TFD-001 P-11; TFD-401.
- **Tiền điều kiện:** FIX-10.
- **Thực hiện:** Thử xem và xuất bản dữ liệu theo vai trò/quyền công bố khác nhau.
- **Mong đợi:** Chính sách mặc định hạn chế phù hợp; dữ liệu không được công khai chỉ vì đã tồn tại trong cơ sở dữ liệu; ngoại lệ phải có quyền và căn cứ.

#### TC-601-020 — Không rò rỉ dữ liệu qua log và thông báo lỗi
- **Yêu cầu nguồn:** TFD-401.
- **Thực hiện:** Gây lỗi xác thực, truy cập trái phép hoặc lỗi xử lý dữ liệu có trường nhạy cảm.
- **Mong đợi:** Thông báo và log không phơi bày dữ liệu nhạy cảm, thông tin xác thực hoặc nội dung không cần thiết; vẫn có mã lỗi đủ để điều tra.

#### TC-601-021 — Nhật ký hành động quản trị
- **Yêu cầu nguồn:** TFD-401; TFD-101.
- **Thực hiện:** Thực hiện thao tác quản trị quan trọng theo quyền được cấp.
- **Mong đợi:** Hành động được ghi nhận theo chính sách; nhật ký có thể truy nguyên; người dùng thông thường không thể tự sửa/xóa nhật ký trái quyền.

#### TC-601-022 — Sao lưu và khôi phục
- **Yêu cầu nguồn:** TFD-401.
- **Thực hiện:** Tạo bản sao lưu kiểm thử, khôi phục vào môi trường tách biệt, đối chiếu dữ liệu và quyền.
- **Mong đợi:** Kết quả khôi phục đáp ứng mục tiêu đã khai báo; định danh, quan hệ, nguồn và lịch sử quan trọng được đối chiếu; dữ liệu khôi phục không vô tình được công bố.

### Nhóm F — Nhập/xuất và chuyển đổi

#### TC-601-023 — Tệp nhập không hợp lệ được xử lý an toàn
- **Yêu cầu nguồn:** TFD-501.
- **Tiền điều kiện:** FIX-12.
- **Thực hiện:** Nhập tệp hỏng, thiếu cấu trúc, tham chiếu lỗi hoặc vượt giới hạn đã công bố.
- **Mong đợi:** Hệ thống từ chối hoặc cô lập phần lỗi theo chính sách; không để trạng thái nhập nửa chừng không được báo cáo; có thông tin chẩn đoán phù hợp.

#### TC-601-024 — Unicode tiếng Việt và Hán-Nôm
- **Yêu cầu nguồn:** TFD-201; TFD-501.
- **Tiền điều kiện:** FIX-11.
- **Thực hiện:** Nhập, lưu, tìm kiếm, xuất và đọc lại dữ liệu ký tự.
- **Mong đợi:** Ký tự không bị thay thế hoặc mất dấu ngoài giới hạn đã công bố; nếu định dạng đích không hỗ trợ đầy đủ, báo cáo mất mát nêu rõ trường/giá trị bị ảnh hưởng.

#### TC-601-025 — Báo cáo mất mát khi xuất
- **Yêu cầu nguồn:** TFD-001 P-10; TFD-501.
- **Tiền điều kiện:** FIX-15 có dữ liệu không biểu diễn đầy đủ trong định dạng đích.
- **Thực hiện:** Xuất theo hồ sơ đã khai báo; kiểm tra tệp, manifest và báo cáo.
- **Mong đợi:** Mất mát hoặc biến đổi có ý nghĩa được báo cáo; không tuyên bố chuyển đổi không mất dữ liệu nếu chưa có bằng chứng đối chiếu.

#### TC-601-026 — Nhập lại không tạo trùng ngoài chính sách
- **Yêu cầu nguồn:** TFD-102; TFD-501.
- **Thực hiện:** Nhập lại cùng bộ dữ liệu theo chế độ được khai báo.
- **Mong đợi:** Hành vi trùng lặp theo đúng chính sách đã công bố; không tự hợp nhất cá nhân chỉ dựa trên tên giống nhau; xung đột được báo và có thể xử lý.

#### TC-601-027 — Tệp xuất phản ánh đúng phạm vi và phiên bản
- **Yêu cầu nguồn:** TFD-501.
- **Thực hiện:** Xuất dữ liệu theo cấu hình đã khai báo; kiểm tra metadata/manifest nếu có.
- **Mong đợi:** Phiên bản định dạng, hồ sơ, phạm vi dữ liệu và các giới hạn hỗ trợ được xác định; không ghi nhãn tương thích với phiên bản chưa được kiểm chứng.

#### TC-601-028 — Tính nhất quán trước và sau chuyển đổi
- **Yêu cầu nguồn:** TFD-001 P-10; TFD-501.
- **Thực hiện:** So sánh các trường và quan hệ trọng yếu trước/sau chuyển đổi.
- **Mong đợi:** Các trường có thể biểu diễn được giữ đúng; sai khác thuộc phạm vi mất mát được liệt kê; không có sai khác ngoài dự kiến mà không có báo cáo.

### Nhóm G — Giao diện, cảnh báo và báo cáo

#### TC-601-029 — Sơ đồ không được coi là nguồn dữ liệu duy nhất
- **Yêu cầu nguồn:** TFD-001 P-07/P-13; TFD-201.
- **Thực hiện:** Thay đổi bố cục sơ đồ, cách sắp xếp hoặc kiểu hiển thị.
- **Mong đợi:** Quan hệ và thứ tự nghiệp vụ không đổi do bố cục; dữ liệu có thể được truy cập độc lập với cách trình bày.

#### TC-601-030 — Cảnh báo dễ phân biệt với kết luận
- **Yêu cầu nguồn:** TFD-001; TFD-103; TFD-301.
- **Thực hiện:** Mở hồ sơ có mâu thuẫn, thiếu chứng cứ hoặc dữ liệu suy đoán.
- **Mong đợi:** Người dùng có thể phân biệt dữ kiện nguồn, nhận định, đánh giá và kết luận; cảnh báo không bị trình bày như một sự thật đã xác minh.

#### TC-601-031 — Báo cáo không làm mất ngữ cảnh
- **Yêu cầu nguồn:** TFD-201; TFD-301; TFD-501.
- **Thực hiện:** Tạo báo cáo có tên biến thể, niên đại chưa chắc chắn và nguồn mâu thuẫn.
- **Mong đợi:** Báo cáo giữ hoặc nêu rõ các giới hạn, nguồn và trạng thái bất định cần thiết; không âm thầm rút gọn thành một dữ kiện chắc chắn.

### Nhóm H — Quản trị kiểm thử và hồi quy

#### TC-601-032 — Truy vết yêu cầu đến bằng chứng
- **Yêu cầu nguồn:** TFD-601 mục 3 và 11.
- **Thực hiện:** Chọn một yêu cầu bắt buộc, tìm ca kiểm thử, lần chạy và bằng chứng.
- **Mong đợi:** Có đường truy vết hai chiều; không có kết quả PASS thiếu bằng chứng.

#### TC-601-033 — Tái lập lần chạy
- **Yêu cầu nguồn:** TFD-001 P-12; TFD-601.
- **Thực hiện:** Chạy lại ca với cùng phiên bản, fixture và cấu hình đã ghi.
- **Mong đợi:** Có thể tái tạo điều kiện thử và so sánh kết quả; khác biệt giữa các lần chạy được ghi nhận và giải thích.

#### TC-601-034 — Ngoại lệ không che khuất lỗi bắt buộc
- **Yêu cầu nguồn:** TFD-601 mục 5, 9 và 10.
- **Thực hiện:** Đề xuất đánh dấu N/A cho ca bắt buộc đang FAIL.
- **Mong đợi:** Quy trình yêu cầu lý do và phê duyệt theo chính sách; không tự chuyển trạng thái; lỗi vẫn hiện trong báo cáo cho đến khi xử lý hợp lệ.

#### TC-601-035 — Hồi quy sau sửa lỗi
- **Yêu cầu nguồn:** TFD-601 mục 10.5.
- **Thực hiện:** Sửa lỗi ở định danh, quan hệ, nguồn hoặc xuất dữ liệu; chạy lại ca lỗi và các ca phụ thuộc.
- **Mong đợi:** Kết quả hồi quy được lưu; lỗi không được đóng chỉ vì ca chính đạt nếu ca liên quan còn FAIL.

## 13. Tiêu chí nghiệm thu tối thiểu

Một phạm vi sản phẩm chỉ được nghiệm thu khi tất cả điều kiện áp dụng sau được đáp ứng:

1. Có hồ sơ phạm vi, phiên bản sản phẩm và phiên bản TFD được viện dẫn.
2. Có ma trận truy vết yêu cầu–ca kiểm thử cho toàn bộ yêu cầu bắt buộc trong phạm vi.
3. Tất cả ca kiểm thử bắt buộc đã chạy; không còn trạng thái NOT RUN, BLOCKED hoặc INCONCLUSIVE chưa được giải quyết trong nhóm bắt buộc.
4. Không còn lỗi S0/Critical mở.
5. Lỗi S1/High đã được khắc phục hoặc có ngoại lệ được phê duyệt nếu chính sách cho phép; không được tự động chấp nhận ngoại lệ cho vi phạm quyền riêng tư hoặc mất dữ liệu cốt lõi.
6. Các ca liên quan đến định danh, kiểu quan hệ, provenance, quyền truy cập và báo cáo mất mát có bằng chứng đủ để rà soát độc lập.
7. Bộ fixture, cấu hình và báo cáo có thể truy xuất và tái sử dụng.
8. Các ngoại lệ và rủi ro còn lại được công khai trong báo cáo nghiệm thu.
9. Người nghiệm thu có thẩm quyền đã ký hoặc ghi nhận quyết định theo quy trình quản trị đã công bố.
10. Có kế hoạch tái kiểm thử cho các thay đổi tiếp theo.

Các điều kiện về số lượng lỗi S2/S3 được phép, tỷ lệ bao phủ và thời gian khắc phục phải được cơ quan quản trị TFD quyết định; bản 0.1 không tự đặt ngưỡng số học chưa có căn cứ.

## 14. Hồ sơ báo cáo nghiệm thu

Báo cáo nghiệm thu tối thiểu gồm:

1. Tóm tắt kết luận và phạm vi.
2. Tên sản phẩm/thành phần, phiên bản, build/commit và môi trường.
3. Tài liệu TFD và phiên bản được áp dụng.
4. Danh sách chức năng trong/ngoài phạm vi.
5. Ma trận truy vết yêu cầu–ca kiểm thử.
6. Thống kê PASS, FAIL, BLOCKED, NOT RUN, N/A và INCONCLUSIVE.
7. Danh sách lỗi theo mức độ, trạng thái và tác động.
8. Danh sách ngoại lệ, người phê duyệt và ngày hết hạn.
9. Bằng chứng kiểm thử quan trọng và vị trí lưu trữ.
10. Kết quả kiểm tra nhập/xuất, mất mát và khôi phục nếu áp dụng.
11. Rủi ro còn lại và biện pháp giảm thiểu.
12. Quyết định nghiệm thu, người ra quyết định và ngày.
13. Kế hoạch tái kiểm thử hoặc điều kiện đánh giá lại.

### 14.1 Mẫu tóm tắt báo cáo

| Chỉ tiêu | Giá trị |
|---|---|
| Phạm vi đánh giá | Điền tên mô-đun/chức năng |
| Phiên bản sản phẩm | Điền phiên bản/build |
| Bộ TFD áp dụng | Điền mã và phiên bản |
| Tổng ca trong phạm vi | Điền số lượng |
| PASS / FAIL | Điền số lượng |
| BLOCKED / NOT RUN / INCONCLUSIVE | Điền số lượng |
| N/A đã được chấp thuận | Điền số lượng và tham chiếu quyết định |
| Lỗi S0/S1 còn mở | Điền mã lỗi; mục tiêu nghiệm thu thông thường là không có lỗi S0 mở |
| Ngoại lệ | Điền mã, chủ sở hữu, thời hạn |
| Kết luận | Đạt / Đạt có ngoại lệ / Không đạt |

## 15. Bằng chứng và lưu giữ

- Bằng chứng phải được gắn mã hoặc định danh ổn định trong báo cáo.
- Bằng chứng phải đủ để người khác kiểm tra kết luận mà không cần dựa vào trí nhớ của người chạy thử.
- Ảnh chụp màn hình, log và tệp xuất phải được che dữ liệu cá nhân không cần thiết.
- Nếu bằng chứng được lưu ngoài hệ thống kiểm thử, báo cáo phải nêu vị trí, quyền truy cập, thời hạn lưu và checksum hoặc phương pháp kiểm tra tính toàn vẹn khi phù hợp.
- Không đưa mật khẩu, token, khóa bí mật hoặc dữ liệu cá nhân nhạy cảm vào báo cáo kiểm thử.
- Thời hạn lưu giữ chính thức phải theo TFD-401 và chính sách vận hành đã phê chuẩn; bản 0.1 không đặt một thời hạn phổ quát.

## 16. Tích hợp kiểm thử vào vòng đời phát triển

### 16.1 Trước khi phát hành

- Chạy kiểm tra tự động về schema, định danh, ràng buộc và hợp đồng API.
- Chạy ca hồi quy cho nghiệp vụ quan hệ, nguồn/chứng cứ và nhập/xuất bị ảnh hưởng.
- Chạy kiểm thử quyền truy cập âm tính cho các thay đổi liên quan bảo mật.
- Kiểm tra báo cáo mất mát khi thay đổi bộ chuyển đổi.
- Lưu kết quả kiểm thử gắn với build được phát hành.

### 16.2 Khi thay đổi mô hình hoặc quy tắc

Mọi thay đổi phải nêu: yêu cầu bị tác động, dữ liệu hiện có bị ảnh hưởng, kế hoạch di trú, tính tương thích ngược, fixture mới/sửa đổi và bộ ca hồi quy. Không được dùng việc thay đổi schema như lý do để bỏ qua bảo toàn dữ liệu hiện hữu.

### 16.3 Khi thay đổi phiên bản TFD

Phải lập bảng thay đổi giữa các phiên bản, xác định yêu cầu mới/bị sửa/bị loại bỏ, ca kiểm thử tương ứng và tác động tới tuyên bố tuân thủ trước đó. Không được coi kết quả của phiên bản TFD cũ là bằng chứng tự động cho phiên bản mới.

## 17. Các điều kiện không được chấp nhận

Một sản phẩm không đạt yêu cầu cốt lõi nếu có một trong các hành vi sau trong phạm vi được kiểm tra:

- Tự tạo quan hệ huyết thống, hôn phối hoặc quan hệ gia đình chỉ dựa trên tên, cách bố trí sơ đồ hoặc phỏng đoán không có căn cứ.
- Biến ngày/niên đại thiếu chính xác thành ngày chính xác mà không có cơ sở và không giữ nguyên bản.
- Ghi đè bản gốc bằng phiên âm, bản dịch hoặc giá trị chuẩn hóa.
- Xóa bất đồng nguồn hoặc nâng nhận định chưa chắc chắn thành kết luận đã xác minh mà không lưu vết.
- Làm mất lịch sử thay đổi quan trọng khi yêu cầu áp dụng đòi hỏi truy nguyên.
- Cho phép truy cập, sửa đổi, công bố hoặc xuất dữ liệu trái quyền.
- Nhập/xuất gây mất mát đáng kể nhưng không có cảnh báo hoặc báo cáo theo yêu cầu áp dụng.
- Báo cáo kiểm thử ghi PASS khi thiếu bằng chứng hoặc không thực hiện đúng fixture.
- Dùng dữ liệu thật nhạy cảm trong fixture hoặc báo cáo không được phép.

## 18. Liên hệ với các tài liệu TFD khác

- **TFD-001** xác định nguyên tắc nền tảng và là nguồn định hướng cho các nhóm kiểm thử toàn vẹn.
- **TFD-101** xác định mô hình logic cần được kiểm tra ở mức dữ liệu và liên kết.
- **TFD-102** xác định yêu cầu về định danh, kiểu quan hệ và quy tắc liên quan.
- **TFD-103** xác định kiểm thử sự kiện, niên đại, nguồn và chứng cứ.
- **TFD-201** xác định các trường hợp gia phả Việt Nam, chi phái, đời thứ, tên và địa danh.
- **TFD-301** xác định vòng đời nguồn, nhận định, chứng cứ, dị bản và mâu thuẫn.
- **TFD-401** xác định yêu cầu bảo mật, phân quyền, riêng tư, quản trị và khôi phục.
- **TFD-501** xác định kiểm thử nhập/xuất, ánh xạ, tương thích và báo cáo mất mát.

Nếu có mâu thuẫn giữa tài liệu, không tự dùng TFD-601 để âm thầm sửa nghĩa của tài liệu nguồn. Ghi nhận vấn đề, xác định chủ sở hữu quyết định và cập nhật ma trận truy vết sau khi quyết định được phê chuẩn.

## 19. Các quyết định còn mở trước TFD-601 v1.0

Các mục sau phải được giải quyết hoặc ghi nhận chính thức là chưa áp dụng trước khi công bố TFD-601 v1.0:

1. Cơ quan hoặc vai trò có quyền phê chuẩn tuyên bố tuân thủ TFD.
2. Có áp dụng mức T0–T4 hay một mô hình mức khác; điều kiện chính thức của từng mức.
3. Danh mục yêu cầu bắt buộc có mã ổn định trong từng tài liệu TFD.
4. Ngưỡng bao phủ yêu cầu và cách tính bao phủ chính thức.
5. Ngưỡng lỗi S1/S2/S3 được phép tại nghiệm thu.
6. Quy trình phê duyệt ngoại lệ, thời hạn và người có thẩm quyền.
7. Danh mục fixture chuẩn, nơi lưu trữ và quy trình phiên bản hóa.
8. Công cụ hoặc định dạng chuẩn cho báo cáo kiểm thử và ma trận truy vết.
9. Chính sách lưu giữ bằng chứng và thời hạn lưu theo phân loại dữ liệu.
10. Phạm vi kiểm thử bảo mật độc lập hoặc đánh giá bên thứ ba nếu cần.
11. Tiêu chí nghiệm thu cho các định dạng GEDCOM/hồ sơ cụ thể được TFD-501 hỗ trợ.
12. Yêu cầu tối thiểu về diễn tập sao lưu/khôi phục và mục tiêu thời gian khôi phục.
13. Quy tắc đánh giá tính khả dụng, hiệu năng và khả năng tiếp cận nếu đưa vào phạm vi TFD.
14. Cơ chế công bố, rà soát và thu hồi tuyên bố tuân thủ khi có thay đổi nghiêm trọng.

Không được tự điền các quyết định này như thể đã được thông qua. Có thể dùng các đề xuất trong bản 0.1 để thử nghiệm nội bộ, nhưng phải gắn nhãn dự thảo.

## 20. Tiêu chí hoàn thành tài liệu TFD-601

Bản TFD-601 có thể được xem xét để nâng lên v1.0 khi:

- Các yêu cầu bắt buộc trong bộ TFD đã được mã hóa hoặc có cách truy vết ổn định.
- Bộ ca kiểm thử có tiêu chí đạt rõ ràng, không mơ hồ và có thể tái hiện.
- Các fixture chuẩn đã được rà soát, phiên bản hóa và xác nhận không chứa dữ liệu thật không được phép.
- Mô hình tuân thủ và quy trình nghiệm thu được phê chuẩn.
- Các ngưỡng lỗi, ngoại lệ, bằng chứng và lưu giữ đã có quyết định quản trị.
- Các ca thử nhập/xuất khớp với hồ sơ định dạng thực sự được hỗ trợ trong TFD-501.
- Các nhóm nghiệp vụ, bảo mật và dữ liệu đã rà soát bộ kiểm thử.
- Đã chạy thử bộ kiểm thử trên ít nhất một triển khai tham chiếu và ghi lại kết quả, lỗi của chính bộ kiểm thử và giới hạn.
- Lịch sử thay đổi và quyết định còn mở được cập nhật.

## Phụ lục A — Mẫu ghi một lần chạy

```yaml
run_id: RUN-YYYYMMDD-NNN
product:
  name: "Tên sản phẩm/thành phần"
  version: "phiên bản hoặc build"
  commit: "mã commit nếu có"
tfd_versions:
  - "TFD-001 v..."
  - "TFD-601 v0.1"
environment:
  type: "test/staging/other"
  config_id: "mã cấu hình"
fixture_set:
  id: "TFD-FIXTURE-SET-..."
  version: "..."
test_case_id: TC-601-001
executor: "vai trò hoặc mã người thực hiện"
executed_at: "ISO-8601"
status: PASS
actual_result: "Mô tả ngắn kết quả quan sát"
evidence:
  - id: EVD-...
    location: "tham chiếu lưu trữ được kiểm soát"
    checksum: "nếu áp dụng"
linked_defects: []
notes: ""
```

Đây là ví dụ cấu trúc minh họa, chưa phải schema máy đọc chính thức. Trường, mã trạng thái và định dạng thời gian cần được chuẩn hóa trước khi dùng làm hợp đồng tích hợp.

## Phụ lục B — Mẫu ma trận truy vết

| Requirement ID | Tài liệu/mục | Bắt buộc? | Test Case ID | Phương pháp | Kết quả | Bằng chứng | Ghi chú |
|---|---|---|---|---|---|---|---|
| Điền mã yêu cầu | Điền mục | Có/Không | TC-601-xxx | Tự động/Thủ công/Kết hợp | PASS/FAIL/... | EVD-... | Sai lệch hoặc ngoại lệ |

Không gộp nhiều yêu cầu độc lập vào một dòng nếu việc đó khiến không thể biết chính xác yêu cầu nào đã được kiểm chứng.

## Phụ lục C — Mẫu ghi nhận sai lệch

- **Deviation ID:** DEV-...
- **Yêu cầu nguồn:** ...
- **Ca kiểm thử/lần chạy:** ...
- **Mô tả sai lệch:** ...
- **Kết quả mong đợi:** ...
- **Kết quả thực tế:** ...
- **Mức độ:** S0/S1/S2/S3
- **Phạm vi ảnh hưởng:** ...
- **Nguyên nhân đã biết/giả thuyết:** ...
- **Biện pháp xử lý:** ...
- **Ngoại lệ có được đề xuất không:** Có/Không
- **Người chịu trách nhiệm và hạn xử lý:** ...
- **Bằng chứng:** ...
- **Kết quả tái kiểm thử:** ...

## Phụ lục D — Danh sách kiểm tra trước nghiệm thu

- [ ] Phạm vi, phiên bản sản phẩm và phiên bản TFD đã được chốt.
- [ ] Ma trận truy vết bao phủ các yêu cầu bắt buộc áp dụng.
- [ ] Fixture và cấu hình đúng phiên bản.
- [ ] Các ca bắt buộc đã chạy và có bằng chứng.
- [ ] Không còn lỗi S0 mở.
- [ ] Lỗi S1 và ngoại lệ được xử lý theo chính sách.
- [ ] Kiểm tra định danh, kiểu quan hệ và dữ liệu chưa chắc chắn đã hoàn tất.
- [ ] Kiểm tra nguồn, chứng cứ, dị bản và lịch sử đã hoàn tất.
- [ ] Kiểm tra quyền riêng tư và truy cập âm tính đã hoàn tất.
- [ ] Kiểm tra nhập/xuất và báo cáo mất mát đã hoàn tất nếu áp dụng.
- [ ] Khôi phục đã được thử nếu nằm trong phạm vi.
- [ ] Rủi ro còn lại và kế hoạch tái kiểm thử đã được ghi nhận.
- [ ] Quyết định nghiệm thu được ghi nhận bởi người có thẩm quyền.

## Phụ lục E — Giới hạn của bản dự thảo

1. TFD-601 v0.1 là bộ khung kiểm thử và bộ ca lõi; chưa phải chương trình chứng nhận chính thức.
2. Mã yêu cầu trong các tài liệu TFD liên quan chưa được chuẩn hóa đồng nhất hoàn toàn; ma trận truy vết cấp yêu cầu cần hoàn thiện trước v1.0.
3. Mức tuân thủ T0–T4 và phân loại lỗi S0–S3 là đề xuất, chưa được phê chuẩn.
4. Ca kiểm thử liên quan GEDCOM phải được ràng buộc với phiên bản và hồ sơ cụ thể được TFD-501 tuyên bố hỗ trợ.
5. Tiêu chí sao lưu, lưu giữ bằng chứng, hiệu năng và khả năng tiếp cận cần được bổ sung nếu được đưa vào phạm vi chính thức.
6. Không được dùng kết quả kiểm thử của một sản phẩm hoặc phiên bản để khẳng định sản phẩm/phiên bản khác tuân thủ.

---

**Kết thúc TFD-601 v0.1 — Dự thảo để rà soát và thử nghiệm.**
