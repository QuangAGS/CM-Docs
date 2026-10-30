# TFD-103 — Quy tắc sự kiện, niên đại và nguồn chứng cứ

**Dự thảo 0.1 | 20-10-2026**

## Kiểm soát tài liệu

| Trường | Giá trị |
|---|---|
| Mã tài liệu | TFD-103 |
| Tên | TFD-103 — Quy tắc sự kiện, niên đại và nguồn chứng cứ |
| Phiên bản | 0.1 — Dự thảo để thảo luận và thử nghiệm |
| Ngày | 20-10-2026 |
| Trạng thái | Dự thảo; chưa phải tiêu chuẩn chính thức |
| Phạm vi | Quy tắc mô hình hóa sự kiện, ngày tháng và khoảng thời gian, nguồn tư liệu, trích dẫn, chứng cứ, độ tin cậy và mâu thuẫn dữ liệu trong hệ thống gia phả. |
| Tài liệu liên quan | TFD-001 (Tổng quan và nguyên tắc quy chuẩn); TFD-101 (Mô hình dữ liệu song song); TFD-102 (Quy tắc định danh và quan hệ). |

## 1. Mục đích và nguyên tắc

### 1.1 Mục đích

Chuẩn hóa cách ghi nhận điều đã xảy ra, thời điểm xảy ra, nơi xảy ra, nguồn nào ghi lại, và lý do một nhận định được chấp nhận hoặc còn nghi vấn.

### 1.2 Nguyên tắc

Tách sự kiện khỏi người tham gia; tách sự kiện khỏi nguồn chứng cứ; không biến suy luận thành sự thật đã xác minh; giữ nguyên văn bản gốc; cho phép nhiều cách diễn giải; bảo toàn lịch sử chỉnh sửa; không ép ngày không rõ thành ngày chính xác.

### 1.3 Mô hình nhiều lớp

Lớp nguồn: tài liệu/hiện vật/nhân chứng. Lớp trích dẫn: vị trí cụ thể trong nguồn. Lớp nhận định: điều được cho là đúng. Lớp sự kiện: mô tả một diễn biến. Lớp hiển thị: cách trình bày cho người đọc.

### 1.4 Không đồng nhất

Một bản ghi trong gia phả có thể mô tả nhiều sự kiện; một sự kiện có thể được ghi trong nhiều nguồn; một nguồn có thể hỗ trợ, phản bác hoặc chỉ nhắc đến một nhận định mà không trực tiếp chứng minh nó.

## 2. Thuật ngữ

### Sự kiện (Event)

Diễn biến có thời điểm hoặc khoảng thời gian, có thể liên quan một hay nhiều người, địa điểm và nhận định.

### Người tham gia (Participant)

Cá nhân hoặc thực thể tham gia sự kiện với một vai trò cụ thể.

### Niên đại (Date/Date range)

Thời điểm, ngày tháng, năm hoặc khoảng thời gian được ghi nhận hoặc suy ra.

### Nguồn (Source)

Tư liệu gốc hoặc nguồn thông tin: gia phả, sắc phong, bia mộ, hộ tịch, giấy khai sinh, sổ nhà thờ họ, thư từ, ảnh, lời kể, cơ sở dữ liệu.

### Trích dẫn (Citation)

Vị trí xác định trong một nguồn, chẳng hạn trang, tờ, mặt bia, dòng, mục, ảnh hoặc mã hồ sơ.

### Nhận định (Assertion)

Mệnh đề có thể đánh giá đúng/sai/chưa rõ, ví dụ một người là con của ai hoặc mất trong năm nào.

### Chứng cứ (Evidence)

Nội dung trong nguồn được dùng để hỗ trợ, phản bác hoặc làm rõ một nhận định.

### Độ chắc chắn (Certainty)

Mức độ tin cậy có căn cứ của nhận định; không phải xác suất thống kê trừ khi phương pháp đã định nghĩa rõ.

### Nguyên văn (Transcription)

Bản chép giữ cách viết trong nguồn, kể cả dị thể hoặc lỗi có ý nghĩa.

### Diễn giải (Interpretation)

Cách hiểu hoặc chuẩn hóa từ nguyên văn, có người thực hiện và quy tắc kèm theo.

## 3. Mô hình sự kiện

### 3.1 Trường tối thiểu

event_id ổn định; event_type; label/description; date_expression hoặc date range; date_precision; place_id hoặc place_text; status; created_at/updated_at; nguồn gốc tạo bản ghi.

### 3.2 Trường khuyến nghị

Tên sự kiện; mô tả ngắn; ngày bắt đầu/kết thúc theo chuẩn; nguyên văn niên đại; lịch sử lịch pháp; địa điểm; mức độ chắc chắn; người ghi nhận; ghi chú; phiên bản; trạng thái xác minh.

### 3.3 Vai trò người tham gia

Dùng bảng liên kết event_participant, có person_id, event_id, role_code, role_label_original, certainty và citation/assertion liên quan. Không giả định mọi sự kiện chỉ có một người.

### 3.4 Phân loại sự kiện

Các mã gợi ý: BIRTH (sinh), BAPTISM (rửa tội/lễ liên quan), NAMING (đặt tên), ADOPTION (nhận nuôi), MARRIAGE (kết hôn), DIVORCE (ly hôn), DEATH (mất), BURIAL (an táng), EXHUMATION (cải táng/bốc mộ), MIGRATION (di cư/chuyển cư), RESIDENCE (cư trú), EDUCATION (học tập), OCCUPATION (nghề nghiệp/chức vụ), TITLE (phong tước/chức), MILITARY_SERVICE (quân vụ), PROPERTY (tài sản), LEGAL (pháp lý), RELIGIOUS (tôn giáo/tế lễ), GENEALOGICAL_RECORD (lập/sửa gia phả), OTHER (khác). Có thể mở rộng từ điển mã; không thay đổi ý nghĩa mã đã phát hành.

### 3.5 Sự kiện và thuộc tính kéo dài

Một sự kiện thường gắn với diễn biến tại thời điểm/khoảng thời gian. Thuộc tính kéo dài như nghề nghiệp, nơi cư trú hoặc chức vụ có thể được mô hình hóa bằng giai đoạn hiệu lực từ–đến; nếu dùng sự kiện bắt đầu/kết thúc, cần quy định rõ ngữ nghĩa để tránh ghi trùng.

### 3.6 Sự kiện nhiều người

Một lễ cưới có thể có hai người kết hôn và người làm chứng; một lễ giỗ có thể có nhiều người tham dự. Vai trò phải tách khỏi loại sự kiện; không suy ra quan hệ hôn nhân pháp lý chỉ từ sự kiện nghi lễ.

### 3.7 Sự kiện lặp lại

Giỗ hằng năm, tế lễ, ngày kỵ hoặc ngày tưởng niệm là chuỗi lặp hoặc sự kiện riêng từng năm; phân biệt ngày sự kiện lịch sử ban đầu với lịch tưởng niệm.

### 3.8 Sự kiện chưa xác định

Nếu chưa biết loại sự kiện, dùng OTHER hoặc UNKNOWN kèm nguyên văn, không tự gán loại cụ thể dựa trên suy đoán.

## 4. Quy tắc niên đại

### 4.1 Lưu nguyên văn và giá trị chuẩn

Luôn giữ date_original nguyên văn; có thể lưu normalized_start, normalized_end, calendar_system, date_precision, date_qualifier, normalization_method và normalization_note. Không ghi đè nguyên văn khi chuẩn hóa.

### 4.2 Độ chính xác

Mã gợi ý: EXACT_DAY, MONTH, YEAR, DECADE, CENTURY, RANGE, BEFORE, AFTER, ABOUT, CALCULATED, UNKNOWN. Có thể kết hợp độ chính xác với từ chỉ ước lượng; cần định nghĩa rõ nếu cho phép kết hợp.

### 4.3 Ngày chính xác

Ngày dương lịch chuẩn có thể lưu theo ISO 8601 dạng YYYY-MM-DD. Nếu chỉ biết tháng/năm thì không tự điền ngày 01 để giả tạo độ chính xác. Có thể dùng trường năm/tháng riêng hoặc cấu trúc niên đại có độ chính xác.

### 4.4 Khoảng thời gian

Lưu cận dưới và cận trên, kèm quy ước biên bao gồm/không bao gồm. Nếu nguồn chỉ nói “từ năm A đến năm B”, mặc định hiển thị theo cách dễ hiểu và giữ nguyên câu nguồn; không tự khẳng định chính xác ngày bắt đầu/kết thúc.

### 4.5 Trước/sau/khoảng

Các cụm “trước năm 1850”, “sau năm 1900”, “khoảng năm 1870” phải giữ qualifier riêng; không đổi thành một ngày cụ thể. Nếu hệ thống cần tính toán, định nghĩa khoảng khả dĩ ở lớp máy và giữ biểu thức ngôn ngữ gốc.

### 4.6 Niên đại theo lịch âm

Lưu nguyên văn, xác định lịch (ví dụ âm lịch Việt Nam), ngày/tháng/năm âm, tháng nhuận nếu có, và kết quả quy đổi dương lịch cùng thuật toán/nguồn quy đổi. Không quy đổi nếu thiếu thông tin cần thiết; không coi ngày âm và ngày dương là cùng một giá trị.

### 4.7 Can chi và niên hiệu

Giữ nguyên niên hiệu, can chi, triều đại hoặc cách gọi thời gian trong nguồn. Chuẩn hóa sang năm dương lịch chỉ khi có cơ sở đối chiếu; lưu quy tắc và độ không chắc chắn của phép đối chiếu.

### 4.8 Thời gian lịch sử và múi giờ

Đối với sự kiện lịch sử địa phương, thường chỉ cần ngày lịch, không gán giờ/múi giờ nếu nguồn không có. Với sự kiện hiện đại có thời điểm, dùng ISO 8601 và múi giờ/offset khi biết.

### 4.9 Ngày suy tính

Ngày suy tính từ tuổi, thứ tự thế hệ, ngày của người thân hoặc sự kiện khác phải được đánh dấu CALCULATED/INFERRED, ghi công thức/căn cứ, người suy tính và nguồn đầu vào. Không trình bày ngang hàng với ngày được ghi trực tiếp mà không có nhãn.

### 4.10 Tuổi và mốc tương đối

Cụm “thọ 73 tuổi”, “mất sau khi sinh con thứ ba”, “năm sau khi đỗ đạt” là dữ kiện tương đối. Không tự suy ra ngày sinh/mất chính xác nếu quy ước tính tuổi, lịch hoặc mốc tham chiếu chưa rõ.

### 4.11 Thiếu hoặc mâu thuẫn

Cho phép ngày chưa rõ, khoảng rộng, hoặc nhiều phương án. Không ép chọn một giá trị chỉ để thỏa mãn giao diện. Mâu thuẫn phải được ghi thành các nhận định cạnh tranh kèm nguồn và lập luận.

### 4.12 Lưu trữ kỹ thuật

Không dùng chuỗi hiển thị làm trường duy nhất. Lưu cấu trúc để truy vấn và nguyên văn để kiểm chứng. Hạn chế kiểu DATE thuần khi dữ liệu có thể chỉ biết năm, khoảng, ngày âm hoặc biểu thức như “trước năm…”.

## 5. Nguồn tư liệu

### 5.1 Định danh nguồn

Mỗi nguồn có source_id ổn định; source_type; title/label; creator/author; date_created hoặc khoảng; repository/owner; call_number/identifier; language/script; physical/digital; access_conditions; rights; provenance; description.

### 5.2 Loại nguồn gợi ý

Gia phả bản chép tay; gia phả in; thần phả; sắc phong; bia mộ; văn bia; giấy khai sinh/kết hôn/khai tử; hộ tịch; địa bạ; sổ đinh; hồ sơ hành chính; thư từ; nhật ký; ảnh; bản đồ; phả hệ truyền khẩu; phỏng vấn; cơ sở dữ liệu thứ cấp.

### 5.3 Bản gốc và bản sao

Phân biệt vật mang tin gốc, ảnh chụp, bản sao, bản dịch, bản phiên âm và bản chép lại. Ghi mối liên hệ derives_from/is_copy_of/is_translation_of khi có thể.

### 5.4 Nguồn truyền khẩu

Ghi người cung cấp thông tin (có kiểm soát quyền riêng tư), ngày phỏng vấn, người phỏng vấn, cách thu thập, quan hệ của người kể với sự kiện, và ghi chú liệu người kể chứng kiến trực tiếp hay nghe kể lại.

### 5.5 Bảo quản số

Nếu có tệp số, lưu tên tệp, định dạng, kích thước, ngày tiếp nhận, mã băm (ví dụ SHA-256), vị trí lưu, quyền truy cập và lịch sử chuyển đổi. Không coi mã băm là bằng chứng về tính xác thực lịch sử; nó chỉ giúp kiểm tra tính toàn vẹn tệp.

### 5.6 Quyền và riêng tư

Ghi quyền sở hữu/quyền sử dụng, hạn chế công bố, thông tin cá nhân còn sống, dữ liệu nhạy cảm và căn cứ cho phép truy cập. Chỉ công bố dữ liệu cá nhân theo chính sách và pháp luật áp dụng.

## 6. Trích dẫn và vị trí chứng cứ

### 6.1 Nguyên tắc

Mỗi nhận định quan trọng cần liên kết đến một hoặc nhiều citation cụ thể; trích dẫn phải giúp người khác tìm lại đúng đoạn nguồn.

### 6.2 Thành phần citation

citation_id; source_id; locator_type; locator_value; page/folio/side/line/paragraph/image region hoặc timestamp; quote/transcription; language; transcription_by; access_date; note.

### 6.3 Vị trí trong gia phả cổ

Có thể ghi quyển, tờ, mặt, dòng, mục, tên nhân vật, câu mở đầu hoặc số ảnh. Vì số trang có thể khác nhau giữa bản sao, lưu cả định danh vật mang tin và vị trí tương đối.

### 6.4 Trích dẫn bia mộ

Ghi nghĩa trang/địa điểm, số mộ nếu có, mặt bia, dòng chữ, ngày chụp, người chụp, ảnh tổng thể và ảnh chi tiết; lưu phiên âm và bản dịch riêng.

### 6.5 Trích dẫn số hóa

Dùng URI hoặc định danh ổn định nếu có; ghi ngày truy cập và phiên bản. Không chỉ lưu URL tạm thời nếu có mã hồ sơ lâu dài.

### 6.6 Nguyên văn

Đoạn trích trực tiếp phải phân biệt với diễn giải của người nghiên cứu. Giữ lỗi/chữ dị thể có ý nghĩa; nếu lược bỏ hoặc bổ sung chữ, ghi quy ước biên tập.

## 7. Nhận định, chứng cứ và mức tin cậy

### 7.1 Nhận định nguyên tử

Mỗi assertion nên diễn đạt một mệnh đề có thể kiểm tra, ví dụ “Nguyễn Văn A mất năm 1892” hoặc “Bà B là mẹ sinh học của C”. Tránh gộp nhiều mệnh đề khác loại vào một câu.

### 7.2 Liên kết chứng cứ

Một assertion có thể được hỗ trợ, phản bác, làm rõ hoặc chỉ được nhắc đến bởi citation. Dùng evidence_role rõ ràng: SUPPORTS, CONTRADICTS, CONTEXT, MENTIONS.

### 7.3 Trạng thái

Mã gợi ý: PROPOSED (đề xuất), SUPPORTED (có chứng cứ hỗ trợ), CONFLICTED (có mâu thuẫn), VERIFIED (đã thẩm định theo chính sách dự án), REJECTED (bị bác bỏ), DEPRECATED (không còn dùng nhưng giữ lịch sử). Không dùng VERIFIED nếu chưa định nghĩa quy trình duyệt.

### 7.4 Mức tin cậy

Có thể dùng HIGH/MEDIUM/LOW/UNKNOWN, nhưng phải kèm tiêu chí và lý do. Không gán điểm số giả chính xác hoặc tự động coi nhiều nguồn sao chép cùng một nguồn là nhiều chứng cứ độc lập.

### 7.5 Đánh giá nguồn

Xem xét tính gần thời điểm sự kiện, người tạo nguồn, mục đích tạo, khả năng tiếp cận trực tiếp, tính độc lập, lịch sử truyền bản, mức đầy đủ, độ rõ chữ và khả năng xác minh chéo.

### 7.6 Không có chứng cứ

Không tìm thấy ghi chép không đồng nghĩa sự kiện không xảy ra. Phải phân biệt NOT_FOUND (chưa tìm thấy) với DISPROVEN (có căn cứ bác bỏ).

### 7.7 Nhiều nguồn cùng chép

Nếu các bản gia phả sau chép từ cùng một bản gốc, ghi quan hệ phụ thuộc; không đếm chúng như các nguồn độc lập.

### 7.8 Người thẩm định

Lưu người đề xuất, người rà soát, ngày, lý do, phương pháp và lịch sử thay đổi. Với kết luận quan trọng, khuyến nghị rà soát độc lập.

### 7.9 Không xóa mâu thuẫn

Khi hai nguồn không thống nhất, giữ cả hai nhận định và giải thích phương án tạm chọn nếu có. Giao diện có thể chọn một giá trị hiển thị chính nhưng phải cho phép xem phương án khác và chứng cứ.

## 8. Đặc thù tư liệu gia phả Việt Nam

### 8.1 Tên và chữ viết

Lưu nguyên văn chữ Hán/Nôm hoặc chữ Quốc ngữ; bản phiên âm, âm đọc, dịch nghĩa và tên chuẩn hóa ở trường riêng. Không thay thế văn bản gốc bằng một bản đọc hiện đại.

### 8.2 Từ chỉ quan hệ/sự kiện

Các từ như húy, tự, hiệu, thụy, sinh, húy nhật, kỵ nhật, táng, cải táng, phụng tự, kế tự, xuất giá, nhập tịch, nhận làm con có thể mang nghĩa phụ thuộc ngữ cảnh. Ghi nguyên văn và diễn giải riêng.

### 8.3 Lịch âm và tháng nhuận

Ghi rõ tháng âm, tháng nhuận nếu có, can chi và niên hiệu. Phép quy đổi phải có căn cứ và ghi chú nếu địa điểm/lịch sử lịch pháp có thể ảnh hưởng.

### 8.4 Ngày giỗ

Phân biệt ngày mất được ghi trong nguồn, ngày giỗ truyền thống, ngày cúng thực tế và ngày quy đổi dương lịch. Không mặc định ngày giỗ là ngày mất nếu nguồn không nói rõ.

### 8.5 Mộ phần

Phân biệt nơi mất, nơi an táng ban đầu, nơi cải táng và nơi mộ hiện nay. Mỗi nơi gắn với sự kiện hoặc giai đoạn riêng, có nguồn xác minh.

### 8.6 Địa danh lịch sử

Lưu địa danh nguyên văn, địa danh chuẩn hóa hiện nay, loại địa danh và giai đoạn hiệu lực nếu biết. Không tự đồng nhất địa danh cổ với đơn vị hành chính hiện tại nếu chưa có đối chiếu.

### 8.7 Thứ bậc và tước hiệu

Ghi nguyên văn danh xưng/chức tước, cách chuẩn hóa và bối cảnh thời đại; tránh chuyển đổi sang hệ thống chức danh hiện đại mà không có giải thích.

## 9. Quy tắc biên tập và giao diện

### 9.1 Hai lớp hiển thị

Cho phép xem “nguyên văn nguồn” và “giá trị chuẩn hóa/diễn giải” song song. Có thể thêm chú giải để người đọc hiểu sự khác biệt.

### 9.2 Nhãn niên đại

Ví dụ: “15 tháng 4 (âm lịch; nguyên văn gia phả)”, “khoảng năm 1870”, “trước năm 1850”, “1840–1845”, “năm 1892 (suy tính)”. Chỉ hiển thị cách ghi này khi phù hợp dữ liệu thực có.

### 9.3 Biểu tượng chứng cứ

Có thể dùng trạng thái trực quan cho đã có nguồn, có mâu thuẫn, chưa xác minh; màu sắc phải đi kèm chữ/biểu tượng để không phụ thuộc riêng vào màu.

### 9.4 Truy nguyên

Người xem cần đi từ sự kiện hoặc dữ kiện cá nhân đến assertion, citation, source và bản số hóa nếu quyền truy cập cho phép.

### 9.5 Không gây hiểu nhầm

Không dùng ngày giả định mặc định, không hiển thị ngày suy tính như ngày chắc chắn, không tự chọn một nguồn chỉ vì nguồn mới hơn nếu chưa đánh giá chất lượng.

## 10. Mô hình dữ liệu khuyến nghị

### 10.1 Bảng event

event_id (UUID/ID ổn định), event_type, label, description, date_original, date_start, date_end, date_precision, date_qualifier, calendar_system, date_normalization_note, place_id, status, created_at, updated_at.

### 10.2 Bảng event_participant

event_id, person_id, role_code, role_original, certainty, assertion_id/citation_id khi cần; khóa duy nhất tùy theo chính sách cho phép một người có nhiều vai trò.

### 10.3 Bảng source

source_id, source_type, title, creator, date_created_original, date_created_start/end, repository, identifier, language, script, format, rights, access_conditions, provenance_note, file_hash.

### 10.4 Bảng citation

citation_id, source_id, locator_type, locator_value, quote_original, transcription, translation, page/folio/line/timestamp, access_date, note.

### 10.5 Bảng assertion

assertion_id, subject_type/id, predicate, object_type/id/value, date scope nếu có, status, confidence, rationale, created_by, reviewed_by, valid_from/to.

### 10.6 Bảng assertion_evidence

assertion_id, citation_id, evidence_role, interpretation, relevance_note, evaluator, evaluated_at.

### 10.7 Quan hệ phụ thuộc nguồn

source_derivation(source_id, related_source_id, relation_type, note) để biểu diễn bản sao, bản dịch, bản chép hoặc nguồn dẫn lại.

### 10.8 Lưu lịch sử

Mọi thay đổi trọng yếu cần audit log: đối tượng, trường, giá trị cũ/mới, người sửa, thời điểm, lý do và phiên bản. Tránh xóa cứng chứng cứ/nhận định đã được dùng trong kết luận.

## 11. Quy tắc kiểm tra và toàn vẹn

### 11.1

event_id, source_id, citation_id, assertion_id phải ổn định và không tái sử dụng.

### 11.2

date_start không lớn hơn date_end khi cả hai là giá trị chuẩn có thể so sánh.

### 11.3

Không bắt buộc date_start/date_end nếu chỉ có nguyên văn chưa thể chuẩn hóa.

### 11.4

Citation phải trỏ đến một source tồn tại; assertion_evidence phải trỏ đến assertion và citation tồn tại.

### 11.5

Nếu date_precision=YEAR thì dữ liệu chuẩn không được giả định có tháng/ngày xác thực; cách lưu vật lý phải tuân thủ schema quy định.

### 11.6

Nếu calendar_system là âm lịch, phải giữ trường lịch gốc; trường dương lịch quy đổi cần metadata về phương pháp.

### 11.7

Nếu status=VERIFIED, cần reviewer hoặc quy trình duyệt được cấu hình.

### 11.8

Confidence không được dùng thay cho evidence_role; một nhận định tin cậy thấp vẫn có thể có chứng cứ cụ thể.

### 11.9

Các nguồn phụ thuộc phải được gắn quan hệ để tránh tính độc lập giả.

### 11.10

Dữ liệu nhạy cảm hoặc quyền truy cập hạn chế phải tuân thủ chính sách phân quyền và ghi nhật ký truy cập khi cần.

## 12. Quy trình xử lý đề xuất

### Bước 1 — Tiếp nhận

Đăng ký nguồn và vật mang tin; ghi xuất xứ, quyền, định dạng và tình trạng.

### Bước 2 — Số hóa/phiên âm

Tạo ảnh hoặc bản số hóa; phiên âm nguyên văn; ghi người thực hiện và quy ước.

### Bước 3 — Tạo citation

Định vị chính xác đoạn, trang, tờ, dòng hoặc vùng ảnh liên quan.

### Bước 4 — Tạo assertion

Tách từng mệnh đề; gắn citation hỗ trợ/phản bác; nêu rõ suy luận.

### Bước 5 — Mô hình hóa event

Tạo sự kiện và người tham gia; liên kết các assertion và nguồn.

### Bước 6 — Chuẩn hóa niên đại

Chuẩn hóa khi đủ căn cứ; giữ nguyên văn, lịch gốc, độ chính xác và ghi chú.

### Bước 7 — Rà soát

Kiểm tra mâu thuẫn, phụ thuộc nguồn, độ tin cậy, quyền riêng tư và toàn vẹn dữ liệu.

### Bước 8 — Công bố

Hiển thị giá trị chuẩn hóa cùng nhãn chắc chắn; cung cấp đường truy nguyên tới nguồn theo quyền truy cập.

## 13. Ví dụ minh họa

### 13.1 Ngày mất ghi theo âm lịch

Nguyên văn: “giỗ ngày 15 tháng 4”. Không tự suy ra năm mất hoặc tự chuyển sang dương lịch nếu chưa xác định năm và lịch. Lưu ngày giỗ truyền thống riêng với ngày mất nếu hai khái niệm chưa được chứng minh là trùng nhau.

### 13.2 Năm mất ước lượng

Nguồn ghi “ước mất vào khoảng năm 1870”. Lưu date_original đúng nguyên văn; qualifier=ABOUT; precision=YEAR hoặc khoảng khả dĩ theo chính sách; không đặt ngày 1870-01-01.

### 13.3 Hai nguồn mâu thuẫn

Gia phả A ghi sinh năm 1820, bia mộ ghi năm 1823. Tạo hai assertion riêng, mỗi assertion liên kết citation tương ứng; đánh dấu CONFLICTED và ghi cách đánh giá chất lượng nguồn.

### 13.4 Sự kiện cải táng

Tạo event BURIAL cho nơi an táng đầu tiên và event EXHUMATION/REBURIAl cho lần cải táng, mỗi sự kiện có ngày, địa điểm và nguồn riêng. Không ghi đè địa điểm mộ ban đầu bằng địa điểm mộ sau cải táng.

### 13.5 Suy tính từ tuổi thọ

Nếu bia ghi mất năm 1890, thọ 70 tuổi, năm sinh có thể là khoảng 1819–1821 tùy cách tính tuổi và ngày sinh. Ghi đây là suy luận, nêu giả định; không coi một năm duy nhất là chắc chắn.

### 13.6 Bản gia phả chép lại

Bản năm 1950 chép từ bản cũ không còn. Ghi bản 1950 là nguồn trực tiếp đang có; đánh dấu nguồn gốc được khai báo là bản cũ; không coi bản cũ là nguồn đã kiểm tra trực tiếp nếu chưa tìm thấy.

## 14. Bộ kiểm thử nghiệm thu

### TC-01

Tạo sự kiện có ngày chính xác và một citation; hệ thống hiển thị đúng ngày và nguồn.

### TC-02

Tạo dữ liệu chỉ biết năm; giao diện không tự hiện ngày 01/01.

### TC-03

Tạo ngày âm lịch chưa quy đổi; vẫn lưu và hiển thị được nguyên văn.

### TC-04

Lưu niên đại “khoảng năm 1870”; hệ thống không làm mất qualifier ABOUT.

### TC-05

Hai assertion mâu thuẫn được giữ đồng thời và trạng thái mâu thuẫn hiển thị rõ.

### TC-06

Citation không có source hợp lệ bị từ chối.

### TC-07

Một nguồn có nhiều citation; mỗi citation định vị riêng.

### TC-08

Bản sao/bản dịch được liên kết nguồn gốc và không tính mặc định là nguồn độc lập.

### TC-09

Ngày suy tính được phân biệt với ngày ghi trực tiếp.

### TC-10

Thay đổi giá trị chuẩn hóa không xóa nguyên văn hay lịch sử chỉnh sửa.

### TC-11

Sự kiện cải táng không ghi đè sự kiện an táng ban đầu.

### TC-12

Nguồn bị hạn chế quyền truy cập không lộ tệp cho người không có quyền.

### TC-13

Trạng thái VERIFIED không thể đặt nếu thiếu thông tin duyệt theo chính sách.

### TC-14

Tệp số hóa có hash; thay đổi nội dung tệp làm thay đổi hash.

### TC-15

Người dùng có thể lần từ dữ kiện đang xem đến nguồn và vị trí chứng cứ.

## 15. Tiêu chí hoàn thành

### Nội dung

Định nghĩa rõ event, date, source, citation, assertion và evidence; phân biệt nguyên văn/chuẩn hóa; xử lý niên đại không đầy đủ, lịch âm, suy luận và mâu thuẫn.

### Dữ liệu

Có định danh ổn định; liên kết nguồn/chứng cứ; hỗ trợ nhiều người tham gia và nhiều nguồn; giữ lịch sử.

### Giao diện

Thể hiện độ chính xác và trạng thái chứng cứ; không tạo cảm giác chắc chắn giả; hỗ trợ truy nguyên.

### Quản trị

Có quy trình rà soát, quyền truy cập, nhật ký thay đổi và tiêu chí VERIFIED.

### Kiểm thử

Các ca kiểm thử TC-01 đến TC-15 được chạy và có kết quả ghi nhận trước khi phát hành.

## 16. Giới hạn và quyết định cần chốt

### 16.1

Các mã event, certainty và evidence_role trong tài liệu là đề xuất khởi đầu; cần được thống nhất với TFD-001/101/102 và bộ mã dùng chung.

### 16.2

Không có một mô hình ngày tháng duy nhất phù hợp mọi lịch sử gia phả. Cần chọn schema hỗ trợ ngày chính xác, năm, khoảng, qualifier và lịch phi Gregorian.

### 16.3

Việc quy đổi âm-dương lịch cần quy trình có thể tái lập và kiểm chứng; không nên tự xây dựng quy tắc chuyển đổi rút gọn cho dữ liệu lịch sử.

### 16.4

Mức tin cậy là đánh giá biên tập, không phải xác suất khách quan trừ khi có mô hình định lượng được kiểm định.

### 16.5

Cần xác định chính sách công bố thông tin người còn sống, quyền truy cập tài liệu gia đình và quy trình sửa sai.

## 17. Tài liệu tham khảo định hướng

### GEDCOM

FamilySearch GEDCOM — định dạng trao đổi dữ liệu phả hệ. Dùng làm tài liệu tham khảo cho cấu trúc sự kiện, nguồn và trích dẫn; kiểm tra phiên bản cụ thể trước khi ánh xạ.

### ISO 8601

ISO 8601 — biểu diễn ngày và thời gian; phù hợp cho giá trị chuẩn khi độ chính xác và lịch đã xác định, không thay thế mô hình niên đại chưa đầy đủ.

### W3C PROV

W3C PROV — mô hình hóa xuất xứ/provenance của dữ liệu và hoạt động tạo ra dữ liệu.

### Unicode

Unicode Standard — mã hóa ký tự, cần thiết khi lưu chữ Quốc ngữ, chữ Hán và các ký tự liên quan; lưu ý Unicode không tự giải quyết vấn đề dị thể chữ Hán/Nôm.

### Nguyên tắc sử dụng

Các tài liệu trên là điểm tham khảo, không đồng nghĩa TFD tuân thủ đầy đủ một tiêu chuẩn bên ngoài. Trước khi công bố TFD chính thức, cần rà soát phiên bản và điều khoản áp dụng.
