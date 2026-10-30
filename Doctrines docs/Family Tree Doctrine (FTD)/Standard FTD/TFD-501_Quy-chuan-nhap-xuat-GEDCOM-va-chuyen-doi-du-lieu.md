# TFD-501 — Quy chuẩn nhập/xuất GEDCOM và chuyển đổi dữ liệu gia phả

**Mã tài liệu:** TFD-501  
**Bộ tiêu chuẩn:** TFD — Family Tree Doctrine  
**Phiên bản:** 0.1  
**Ngày:** 21/10/2026  
**Trạng thái:** Dự thảo đầy đủ để rà soát và thử nghiệm  
**Ngôn ngữ:** Tiếng Việt  
**Tài liệu liên quan:** TFD-001, TFD-101, TFD-102, TFD-103, TFD-201, TFD-301, TFD-401 và TFD-601.

> **Lưu ý:** Tài liệu này quy định yêu cầu chuyển đổi theo TFD, không thay thế đặc tả GEDCOM chính thức. Mỗi triển khai phải nêu phiên bản GEDCOM, hồ sơ mở rộng, mã hóa và giới hạn được hỗ trợ. Các điểm chưa thống nhất được giữ mở tại Mục 21, không tự coi là quy tắc chuẩn cuối cùng.

## Kiểm soát tài liệu

| Thuộc tính | Quy định |
|---|---|
| Chủ sở hữu | Nhóm quản trị TFD được chỉ định |
| Đối tượng áp dụng | Phần mềm gia phả, công cụ chuyển đổi, kho lưu trữ và dịch vụ nhập/xuất |
| Từ quy phạm | MUST/PHẢI, MUST NOT/KHÔNG ĐƯỢC, SHOULD/NÊN, SHOULD NOT/KHÔNG NÊN, MAY/CÓ THỂ |
| Chu kỳ rà soát | Ít nhất hằng năm và sau thay đổi lớn của định dạng |
| Hồ sơ triển khai | Đặc tả bộ chuyển đổi, mapping profile, manifest, báo cáo kiểm tra và ca kiểm thử |

Trong tài liệu này, **nhập** là đọc dữ liệu nguồn vào TFD; **xuất** là chuyển dữ liệu TFD sang định dạng đích; **chuyển đổi** là biến đổi giữa mô hình/định dạng/phiên bản. **Mất thông tin** là dữ liệu, ý nghĩa, độ chắc chắn, liên kết nguồn hoặc khả năng truy nguyên không thể biểu diễn đầy đủ ở đích. **Manifest** là bản kê máy đọc được về lần chuyển đổi. **Mapping profile** là bộ quy tắc ánh xạ được phiên bản hóa.

## 1. Mục đích

TFD-501 nhằm bảo toàn ý nghĩa gia phả khi nhập, xuất và chuyển đổi; giữ định danh và liên kết; phân biệt dữ liệu gốc với giá trị chuẩn hóa; báo cáo trường/quan hệ/metadata không thể chuyển; bảo toàn nguồn, chứng cứ, kết luận và bất định trong giới hạn định dạng; ngăn suy diễn quan hệ; cho phép kiểm tra, lặp lại và truy nguyên; tuân thủ quyền truy cập TFD-401; phát hiện lỗi, trùng lặp, tham chiếu hỏng và xung đột; tránh sửa nguồn gốc ngoài ý muốn.

## 2. Phạm vi

### 2.1 Trong phạm vi

- Nhập/xuất GEDCOM theo phiên bản được công bố; nhập/xuất CSV, JSON hoặc định dạng khác khi có mapping profile.
- Di trú giữa phiên bản mô hình TFD.
- Ánh xạ người, tên, định danh, quan hệ, gia đình, sự kiện, địa điểm, nguồn, citation, assertion, đánh giá chứng cứ, kết luận và media.
- Kiểm tra cấu trúc, mã hóa, tham chiếu, dữ liệu mâu thuẫn và dữ liệu không hỗ trợ.
- Báo cáo mất thông tin, dữ liệu bỏ qua, biến đổi và giá trị suy ra.
- Bảo mật, quyền riêng tư, nhật ký và lưu trữ tệp chuyển đổi.

### 2.2 Ngoài phạm vi

Mô hình dữ liệu (TFD-101), định danh/quan hệ (TFD-102), sự kiện/niên đại/nguồn/chứng cứ (TFD-103), quy tắc gia phả Việt Nam (TFD-201), quy trình nguồn và dị bản (TFD-301), chính sách bảo mật (TFD-401) và kiểm thử toàn bộ (TFD-601) được định nghĩa tại các tài liệu tương ứng.

### 2.3 Tuyên bố hỗ trợ

Tuyên bố “hỗ trợ GEDCOM” MUST nêu phiên bản cụ thể, phần mở rộng, mã hóa, xử lý media, giới hạn tệp và cách xử lý phần tử bị bỏ qua. Đuôi `.ged` không đủ để xác nhận tệp hợp lệ hoặc tương thích hoàn toàn.

## 3. Nguyên tắc chuyển đổi

- **IMP-PR-01 — Bảo toàn ý nghĩa:** MUST ưu tiên ý nghĩa dữ liệu hơn hình thức hiển thị.
- **IMP-PR-02 — Không suy diễn:** MUST NOT suy ra huyết thống từ tên, thứ tự hiển thị, vị trí trong cây hoặc quan hệ chưa rõ.
- **IMP-PR-03 — Gốc và chuẩn hóa:** MUST giữ hoặc lưu vết giá trị gốc khi chuẩn hóa có thể làm mất biến thể, chữ viết, lịch, độ chính xác hoặc sắc thái.
- **IMP-PR-04 — Không nâng độ chắc chắn:** dữ liệu ước lượng, khoảng thời gian hoặc tranh luận MUST NOT thành dữ kiện chính xác nếu không có ánh xạ minh bạch đã được duyệt.
- **IMP-PR-05 — Báo cáo mất thông tin:** khi có khả năng mất thông tin, MUST tạo báo cáo/manifest về giới hạn quan trọng.
- **IMP-PR-06 — Nhập có kiểm soát:** MUST cho phép kiểm tra trước khi ghi, xác định xử lý trùng lặp và xem trước thay đổi quan trọng.
- **IMP-PR-07 — Không ghi đè mặc định:** MUST NOT âm thầm ghi đè dữ liệu hiện có; xung đột phải theo chính sách được chọn.
- **IMP-PR-08 — Quyền riêng tư đi theo dữ liệu:** MUST tuân thủ TFD-401; quyền xem không mặc nhiên là quyền xuất.
- **IMP-PR-09 — Có thể lặp lại:** SHOULD cho kết quả ngữ nghĩa tương đương với cùng đầu vào, công cụ, cấu hình và mapping profile.
- **IMP-PR-10 — Truy nguyên:** MUST ghi nhận tệp nguồn, thời điểm, công cụ/phiên bản, mapping profile và biến đổi chính.

## 4. Quy trình nhập

Quy trình nhập MUST có các giai đoạn logic:

1. **Tiếp nhận:** xác định người gửi, quyền, mục đích và phạm vi.
2. **Kiểm tra tệp:** định dạng thực tế, mã hóa, kích thước, tính toàn vẹn và an toàn.
3. **Phân tích cú pháp:** đọc theo phiên bản/định dạng được khai báo.
4. **Kiểm tra cấu trúc:** phát hiện cú pháp sai, mã không hỗ trợ và tham chiếu không hợp lệ.
5. **Ánh xạ:** dùng mapping profile đã phiên bản hóa.
6. **Kiểm tra ngữ nghĩa:** phát hiện quan hệ mâu thuẫn, ngày không rõ, tham chiếu vòng và dữ liệu bất thường.
7. **Đối chiếu:** phát hiện trùng lặp tiềm năng và xung đột với dữ liệu hiện có.
8. **Xem trước:** tổng kết thay đổi, lỗi, cảnh báo và mất thông tin dự kiến.
9. **Phê duyệt:** yêu cầu xác nhận theo quyền và mức rủi ro.
10. **Ghi dữ liệu:** nhập có kiểm soát, giữ liên kết nguồn gốc.
11. **Hậu kiểm:** kiểm tra số lượng, quan hệ và tính toàn vẹn.
12. **Báo cáo:** tạo manifest, lỗi, cảnh báo và thống kê.

Nếu không thể thực hiện một giai đoạn, hệ thống MUST ghi lý do, phạm vi ảnh hưởng và biện pháp bù trừ. Tệp không thể phân tích an toàn MUST bị từ chối hoặc cách ly.

### 4.1 Kiểm tra trước khi nhập

Tối thiểu kiểm tra kích thước/tài nguyên; định dạng thực tế; mã hóa; cấu trúc theo phiên bản; tham chiếu ID; ID trùng; phần tử không hỗ trợ; nội dung có thể gây lỗi parser/tiêu hao tài nguyên; phân loại dữ liệu và quyền nhập; checksum khi phù hợp.

### 4.2 Giao dịch và phục hồi

Hệ thống SHOULD nhập theo lô/giao dịch để tránh trạng thái nửa chừng. Nếu không thể rollback toàn bộ, phải lưu trạng thái từng phần, đối tượng đã tạo/cập nhật, lỗi và phương án phục hồi. Không được báo thành công hoàn toàn khi chỉ một phần dữ liệu được ghi.

## 5. Quy trình xuất

Quy trình SHOULD gồm: xác định mục đích/người nhận/phạm vi; kiểm tra quyền trên dữ liệu và media; áp dụng giảm thiểu/che dữ liệu; chọn phiên bản và mapping profile; kiểm tra trường không biểu diễn được; tạo tệp tạm an toàn; kiểm tra cú pháp/tham chiếu/số lượng; tạo báo cáo mất thông tin và manifest; kiểm tra lại quyền công bố; phát hành an toàn và ghi nhận kết quả.

Tệp tạm MUST được bảo vệ và xóa theo chính sách. Tệp công khai MUST chỉ chứa dữ liệu đã duyệt. Hệ thống SHOULD hỗ trợ checksum. Nếu định dạng đích không chứa metadata quyền riêng tư, phải nêu rằng quyền truy cập không đi kèm tệp. Không được gọi bản xuất là bản sao đầy đủ của kho TFD nếu chưa chứng minh độ bao phủ và tính không mất thông tin.

## 6. Hồ sơ GEDCOM được hỗ trợ

Mỗi triển khai MUST công bố phiên bản GEDCOM nhập/xuất, mã hóa, tag chuẩn/phần mở rộng, cách xử lý media/liên kết, giới hạn kích thước/số bản ghi, cùng hành vi lỗi/cảnh báo/phần tử bỏ qua.

Hệ thống SHOULD định nghĩa hồ sơ tương thích có phiên bản, ví dụ `TFD-GEDCOM-PROFILE-0.1` (tên đề xuất, chưa phê duyệt), mô tả phiên bản GEDCOM, tag hỗ trợ, tag mở rộng, ánh xạ ngày/tên/quan hệ/nguồn/media, hành vi với dữ liệu không hỗ trợ, manifest và bộ kiểm thử.

Không được tuyên bố “tương thích đầy đủ” nếu còn phần tử bị bỏ qua, chuyển đổi một chiều hoặc diễn giải khác. Phạm vi tương thích phải được chứng minh bằng kiểm thử.

## 7. Quy tắc ánh xạ dữ liệu

### 7.1 Người và định danh

Mỗi cá nhân nguồn phải ánh xạ tới `Person` hoặc vùng cách ly. ID nguồn MUST được giữ trong metadata ánh xạ. ID TFD tuân theo TFD-102 và MUST NOT thay đổi chỉ vì xuất lại. ID nguồn khác nhau không chứng minh là hai người khác nhau; ID giống nhau giữa hai hệ thống cũng không tự đủ căn cứ hợp nhất. Hợp nhất là quyết định riêng có thể truy nguyên.

### 7.2 Tên và biến thể

SHOULD giữ dạng nguyên bản, ngôn ngữ/chữ viết, thành phần/loại tên nếu nguồn có, dạng chuẩn hóa và quy tắc chuẩn hóa, ghi chú bất định/nguồn gốc. Không loại bỏ chữ Hán/Nôm, dấu, tên húy, tên tự, tên hiệu, tên thánh, tên sau khi mất, biệt danh hoặc biến thể chỉ vì đích thiếu trường. Dùng phần mở rộng, metadata phụ trợ hoặc báo cáo mất thông tin.

### 7.3 Quan hệ và gia đình

Quan hệ phải ánh xạ theo loại và vai trò người tham gia khi nguồn hỗ trợ. Không chuyển quan hệ cha/mẹ không rõ loại thành quan hệ sinh học chắc chắn. Cần phân biệt sinh học, pháp lý, nhận nuôi, nuôi dưỡng, kế dưỡng, giám hộ và xã hội theo TFD-102. Nếu đích hỗ trợ loại hẹp hơn, báo cáo mất thông tin hoặc dùng extension được công bố. Thứ tự con, vị trí sơ đồ và họ tên không đủ để suy ra quan hệ/thứ bậc. Quan hệ vòng/mâu thuẫn phải được báo cáo, không tự xóa cạnh để làm cây hợp lệ.

### 7.4 Dòng phả hệ, chi phái và thế hệ

Định dạng đích có thể không biểu diễn đủ dòng phả hệ, chi/phái, thứ bậc hoặc quy tắc thế hệ riêng của dòng họ. Bộ chuyển đổi MUST giữ thông tin trong extension/manifest khi có thể, nêu trường không ánh xạ được, không suy membership từ huyết thống và không coi số thế hệ hiển thị là định danh phổ quát. Giữ phạm vi và phiên bản quy tắc thế hệ nếu nguồn có.

### 7.5 Sự kiện, ngày và địa điểm

Giữ độ chính xác ngày: năm, tháng-năm, ngày đầy đủ, khoảng thời gian, ước lượng hoặc chưa rõ. Không tự điền ngày/tháng thiếu. Khi đổi lịch/chuẩn hóa địa danh, giữ giá trị gốc, quy tắc và mức chắc chắn. Không đổi ngày âm sang dương nếu thiếu thông tin cần thiết hoặc quy tắc lịch. Giữ địa danh lịch sử, tên cũ và biến thể. Nếu đích chỉ cho một ngày, không thay khoảng thời gian bằng ngày đại diện một cách âm thầm.

### 7.6 Nguồn, citation, assertion, chứng cứ và kết luận

Trong TFD, `Source`, `SourceRepository`, `Citation`, `Assertion`, `EvidenceAssessment` và `Conclusion` là khái niệm riêng. Nếu đích chỉ hỗ trợ một phần, phải ánh xạ tường minh phần giữ được và phần mất. Không gộp đánh giá chứng cứ/kết luận vào ghi chú mà không báo cáo giới hạn nếu mất cấu trúc. Citation nên giữ trang/dòng/ảnh, thông tin tài liệu và liên kết tới nhận định. Citation tồn tại không có nghĩa nhận định đã được xác minh. Tệp và URL phải tuân thủ quyền sử dụng và TFD-401.

### 7.7 Media

Phân biệt nhúng tệp với liên kết ngoài. Liên kết có thể hết hạn; manifest SHOULD ghi trạng thái kiểm tra nếu có. Khi đóng gói, bảo toàn tên, loại, checksum và liên kết ngữ nghĩa. Không đưa tệp hạn chế vào gói công khai chỉ vì hồ sơ liên kết là công khai. Tệp không chuyển được phải được báo cáo theo nhóm và lý do.

## 8. Mã hóa và ký tự

- MUST xác định hoặc yêu cầu chọn mã hóa khi không thể xác định an toàn.
- Không thay ký tự không giải mã được mà không ghi nhận.
- Unicode SHOULD được dùng khi định dạng hỗ trợ; chuẩn hóa phải tránh sai lệch so sánh.
- Không làm mất nội dung gốc nếu khác biệt có ý nghĩa nguồn.
- Phải kiểm thử dấu tiếng Việt, ký tự bổ sung và Hán/Nôm trên hệ thống đích.
- Nếu đích giới hạn ký tự, tạo báo cáo/trường phụ trợ để giữ giá trị gốc khi được phép.
- Mọi thay ký tự để đáp ứng giới hạn MUST được ghi trong manifest.

## 9. Trùng lặp và xung đột

Hệ thống MAY gợi ý trùng lặp dựa trên nhiều tín hiệu nhưng MUST NOT tự hợp nhất chỉ dựa vào tên, ngày gần nhau, địa điểm, tên cha/mẹ hoặc vị trí/số thế hệ. Gợi ý phải hiển thị căn cứ và độ tin cậy nếu có; trường hợp quan trọng phải được người có thẩm quyền xem xét.

Khi dữ liệu nhập xung đột, hệ thống MUST hỗ trợ chiến lược được công bố: giữ cả hai dưới dạng giá trị/nhận định có nguồn; yêu cầu người dùng chọn; cách ly; bỏ qua trường nhưng ghi nhận; hoặc cập nhật theo quy tắc ưu tiên đã duyệt. Không dùng “bản nhập mới nhất luôn đúng” làm mặc định cho dữ liệu lịch sử.

## 10. Báo cáo mất thông tin

### 10.1 Trường hợp bắt buộc

Báo cáo MUST được tạo khi trường/thực thể không được hỗ trợ; quan hệ bị đổi loại/giảm chính xác; nguồn/citation/chứng cứ/lịch sử bị gộp hoặc bỏ; ngày/lịch/địa danh/tên bị chuẩn hóa có thể mất giá trị gốc; dữ liệu bị loại vì riêng tư; media/liên kết ngoài không đóng gói; extension bị bỏ qua; hoặc không thể chuyển đổi ngược đầy đủ.

Báo cáo SHOULD phân biệt mất mát do định dạng với loại bỏ theo chính sách riêng tư.

### 10.2 Nội dung tối thiểu

Báo cáo MUST nêu mã lần chuyển đổi; định dạng/phiên bản nguồn và đích; mapping profile/công cụ; thời điểm/tác nhân; số bản ghi đọc/tạo/cập nhật/bỏ qua/lỗi; nhóm dữ liệu không ánh xạ; cảnh báo quan hệ/ngày/tên/nguồn/media/quyền riêng tư; mức ảnh hưởng và hành động đề xuất; tham chiếu bản ghi khi có thể và không gây rò rỉ.

### 10.3 Thang mức đề xuất

- **L0 — Không phát hiện mất thông tin trong phạm vi kiểm tra:** không phải bằng chứng tuyệt đối ngoài phạm vi.
- **L1 — Mất trình bày/metadata phụ:** ý nghĩa chính có thể giữ nhưng thiếu một số hình thức/ghi chú.
- **L2 — Mất cấu trúc/ngữ nghĩa một phần:** quan hệ, độ chắc chắn hoặc liên kết nguồn bị giảm.
- **L3 — Mất ngữ nghĩa trọng yếu:** có nguy cơ đổi kết luận, quan hệ, định danh hoặc dữ liệu quan trọng.

Thang này là đề xuất v0.1 cần chốt trước v1.0. L2/L3 SHOULD yêu cầu xác nhận rõ; L3 MUST có cảnh báo nổi bật và lý do nếu tiếp tục.

## 11. Manifest chuyển đổi

Manifest SHOULD là JSON hoặc định dạng máy đọc được tương đương. Trường đề xuất: `conversion_id`, `operation`, `started_at`, `completed_at`, `actor_id`, `source_format`, `source_version`, `target_format`, `target_version`, `source_checksum`, `converter_name`, `converter_version`, `mapping_profile_id`, `mapping_profile_version`, `records_read`, `records_created`, `records_updated`, `records_skipped`, `records_failed`, `warnings`, `errors`, `loss_report_ref`, `privacy_transformations`, `result_status`, `rollback_or_recovery_ref`.

Đây là danh sách đề xuất, chưa phải schema JSON đóng băng. Manifest MUST NOT chứa token, mật khẩu hoặc nội dung nhạy cảm không cần thiết.

Trạng thái đề xuất: `SUCCESS`, `SUCCESS_WITH_WARNINGS`, `PARTIAL_SUCCESS`, `FAILED`, `CANCELLED`, `ROLLED_BACK`. Danh mục mã phải chốt trước v1.0; “thành công” phải định nghĩa rõ là toàn bộ hay chỉ bước kỹ thuật.

## 12. An toàn nhập/xuất

Tuân thủ TFD-401, tối thiểu phải có xác thực/phân quyền phía máy chủ; giới hạn kích thước, thời gian và tài nguyên parser; chống path traversal; cách ly tệp chưa kiểm tra; chống giả mạo kiểu tệp; giới hạn số bản ghi; bảo vệ tệp tạm và xóa theo chính sách; tránh ghi bí mật/dữ liệu cá nhân tràn lan vào log; kiểm tra quyền trên từng đối tượng/media; kiểm soát URL ngoài; rà soát dữ liệu công bố.

Không thực thi macro, script hoặc nội dung chủ động từ tệp nhập. Parser phải được cập nhật và chạy trong môi trường giới hạn phù hợp rủi ro.

## 13. Phiên bản và khả năng lặp lại

- Mapping profile MUST có mã/phiên bản hoặc định danh tương đương.
- Ghi nhận phiên bản parser, thư viện và cấu hình ảnh hưởng kết quả.
- Mapping thay đổi phải có ghi chú, đánh giá tương thích và ca kiểm thử.
- Nhập lặp SHOULD phát hiện lần trước để tránh nhân bản ngoài ý muốn.
- Khi sinh ID mới, lưu bảng ánh xạ ID nguồn ↔ ID TFD.
- Chạy lại MUST NOT tự xóa/ghi đè kết quả trước.
- So sánh nên dựa vào ngữ nghĩa/liên kết, không chỉ thứ tự dòng/bytes.
- Thay đổi thuật toán khử trùng lặp phải được thử trên bộ dữ liệu chuẩn và ca khó.

## 14. Di trú giữa phiên bản TFD

Phải khai báo phiên bản nguồn/đích; liệt kê thay đổi schema/ngữ nghĩa; xác định dữ liệu chuyển trực tiếp, cần xem xét và không thể ánh xạ; thử trên bản sao; sao lưu và xác định rollback; lưu mapping profile/manifest/hậu kiểm; không xóa trường cũ trước khi xác nhận chuyển an toàn; giữ lịch sử/nguồn gốc quan trọng; xử lý dữ liệu phát sinh khi hệ thống vẫn hoạt động. Di trú không thành công chỉ vì script kết thúc với mã thoát 0.

## 15. Khả năng tương tác và mở rộng

Phần mở rộng SHOULD/MUST theo hồ sơ công bố phải có namespace/quy tắc nhận diện, không giả danh tag chuẩn, mô tả ý nghĩa/cardinality/kiểu dữ liệu/hành vi khi không hiểu/phiên bản. Dữ liệu mở rộng quan trọng SHOULD có biểu diễn dự phòng trong manifest. Không dựa vào extension riêng mà không thông báo khi tuyên bố tương thích. Không dùng ghi chú tự do làm nơi duy nhất cho dữ liệu cấu trúc nếu việc mất khả năng máy đọc là đáng kể.

## 16. Giao diện nhập/xuất

Giao diện SHOULD hiển thị định dạng/phiên bản/phạm vi trước khi chạy; phân biệt lỗi, cảnh báo và thông tin; cung cấp báo cáo chi tiết theo quyền; nêu trường bị bỏ/biến đổi; yêu cầu xác nhận khi mất ngữ nghĩa trọng yếu; hỗ trợ hủy an toàn; hiển thị tiến độ và trạng thái từng giai đoạn; không báo thành công chung chung khi có lỗi/mất dữ liệu; cung cấp mã lần chạy; tránh lộ dữ liệu nhạy cảm trong thông báo lỗi.

## 17. Quy tắc kiểm tra

Các quy tắc dưới đây là đề xuất v0.1; ngưỡng và mức bắt buộc cần chốt trong TFD-601.

- **IMP-001:** Định dạng/phiên bản không hỗ trợ phải bị từ chối hoặc cách ly.
- **IMP-002:** Tham chiếu không tồn tại phải được báo cáo; không tự gắn vào bản ghi gần giống.
- **IMP-003:** ID trùng trong phạm vi duy nhất phải bị báo lỗi hoặc xử lý theo quy tắc công bố.
- **IMP-004:** Ký tự không giải mã được phải báo cáo, không âm thầm thay.
- **IMP-005:** Không suy ra huyết thống từ tên/vị trí cây.
- **IMP-006:** Quan hệ không hỗ trợ phải được báo cáo hoặc giữ bằng extension đã khai báo.
- **IMP-007:** Ngày chưa chính xác không được tự chuyển thành ngày đầy đủ.
- **IMP-008:** Giữ giá trị gốc khi chuẩn hóa có thể làm mất nghĩa.
- **IMP-009:** Nguồn/chứng cứ/kết luận bị gộp hoặc bỏ phải có báo cáo mất thông tin.
- **IMP-010:** Quyền xuất được kiểm tra độc lập với quyền xem.
- **IMP-011:** Xung đột không được âm thầm ghi đè dữ liệu hiện có.
- **IMP-012:** Hợp nhất trùng lặp có căn cứ và truy nguyên.
- **IMP-013:** Manifest ghi phiên bản công cụ và mapping profile.
- **IMP-014:** Kết quả một phần phải phân biệt với thành công hoàn toàn.
- **IMP-015:** Tệp công khai không chứa dữ liệu hạn chế ngoài phạm vi duyệt.
- **IMP-016:** Media không chuyển được phải báo cáo.
- **IMP-017:** Tệp nhập chịu kiểm tra an toàn và giới hạn tài nguyên.
- **IMP-018:** Tái chạy không tự nhân bản/ghi đè trái chính sách.
- **IMP-019:** Chuyển lịch/địa danh giữ giá trị gốc và quy tắc đã dùng.
- **IMP-020:** Mất ngữ nghĩa trọng yếu có cảnh báo và xác nhận phù hợp.

## 18. Ca kiểm thử nghiệm thu

| Mã | Tình huống | Kết quả mong đợi |
|---|---|---|
| TC-501-01 | Nhập tệp đúng phiên bản hỗ trợ | Phân tích, xem trước và báo cáo đúng |
| TC-501-02 | Tệp sai cú pháp | Từ chối/cách ly, lỗi định vị được |
| TC-501-03 | Phiên bản không hỗ trợ | Không giả vờ nhập đầy đủ; nêu giới hạn |
| TC-501-04 | ID nguồn trùng | Phát hiện và áp dụng quy tắc đã công bố |
| TC-501-05 | Tham chiếu người không tồn tại | Báo lỗi; không tự nối người khác |
| TC-501-06 | Tên tiếng Việt/Hán-Nôm | Bảo toàn hoặc báo giới hạn chính xác |
| TC-501-07 | Ngày chỉ có năm | Không tự tạo tháng/ngày |
| TC-501-08 | Ngày âm thiếu thông tin | Giữ nguyên/chưa xác định; không đổi tùy tiện |
| TC-501-09 | Quan hệ cha/mẹ không rõ loại | Không tự chuyển thành sinh học chắc chắn |
| TC-501-10 | Nguồn/citation đích không hỗ trợ | Báo mất cấu trúc và tham chiếu |
| TC-501-11 | Dữ liệu dòng phả hệ/chi phái | Giữ qua cấu trúc hỗ trợ hoặc báo trường không ánh xạ |
| TC-501-12 | Media ngoài không truy cập được | Báo trạng thái; không tuyên bố đã đóng gói |
| TC-501-13 | Xuất hồ sơ người sống bị hạn chế | Che/bỏ theo chính sách và ghi nhận |
| TC-501-14 | Người chỉ có quyền xem yêu cầu xuất | Từ chối |
| TC-501-15 | Hai nguồn mâu thuẫn | Giữ xung đột/yêu cầu quyết định; không tự chọn mới nhất |
| TC-501-16 | Nhập cùng tệp lần hai | Phát hiện lần trước hoặc áp dụng chính sách lặp |
| TC-501-17 | Mất loại quan hệ | Cảnh báo và phân loại mức mất thông tin |
| TC-501-18 | Tag mở rộng không hỗ trợ | Báo cáo hoặc cách ly theo cấu hình |
| TC-501-19 | Tệp quá lớn/gây cạn tài nguyên | Giới hạn/dừng an toàn/cách ly |
| TC-501-20 | Di trú giữa phiên bản TFD | Sao lưu, manifest, hậu kiểm và phục hồi |
| TC-501-21 | Xuất bị gián đoạn | Không phát hành tệp chưa hoàn chỉnh như kết quả hoàn tất |
| TC-501-22 | Một phần bản ghi thất bại | Trạng thái một phần và thống kê chính xác |
| TC-501-23 | Mất mức L3 | Cảnh báo nổi bật, xác nhận theo chính sách |
| TC-501-24 | Mapping profile đổi nhưng giữ tên | Phiên bản mới truy nguyên được và có kiểm thử |

## 19. Tiêu chí nghiệm thu

Triển khai tuyên bố phù hợp TFD-501 trong phạm vi đã nêu phải chứng minh: phiên bản định dạng/hồ sơ tương thích được công bố; quy trình nhập/xuất có xem trước và báo cáo; không suy diễn quan hệ/nâng chắc chắn/ghi đè âm thầm; mapping profile có phiên bản; manifest truy nguyên công cụ/cấu hình/kết quả; báo cáo mất thông tin; kiểm soát TFD-401; xử lý lỗi/tham chiếu/trùng lặp/xung đột; kiểm thử ký tự/ngày/quan hệ/nguồn/chứng cứ/media/dòng phả hệ; rollback cho di trú; ca bắt buộc đạt hoặc ngoại lệ được phê duyệt; tài liệu nêu rõ giới hạn tương thích.

## 20. Quan hệ với các tài liệu TFD khác

| Tài liệu | Mối quan hệ |
|---|---|
| TFD-001 | Nguyên tắc bảo toàn, bất định, kiểm thử và tương tác |
| TFD-101 | Mô hình dữ liệu đích và thực thể ánh xạ |
| TFD-102 | Định danh và kiểu quan hệ |
| TFD-103 | Sự kiện, niên đại, nguồn, chứng cứ và kết luận |
| TFD-201 | Dòng phả hệ, chi/phái, thế hệ và quy tắc địa phương |
| TFD-301 | Nguồn, chứng cứ, dị bản và lịch sử nhận định |
| TFD-401 | Quyền truy cập, phân loại, công bố, lưu giữ và nhật ký |
| TFD-601 | Kiểm thử liên tài liệu và chứng minh tuân thủ |

## 21. Các quyết định cần chốt trước TFD-501 v1.0

1. Phiên bản GEDCOM chính thức cho nhập và xuất.
2. Một hay nhiều hồ sơ tương thích.
3. Quy tắc mã hóa, Unicode và dữ liệu lịch sử.
4. Ánh xạ các kiểu quan hệ TFD-102 sang GEDCOM.
5. Biểu diễn dòng phả hệ/chi/phái/thế hệ khi đích không hỗ trợ.
6. Schema manifest JSON chính thức.
7. Thang L0–L3 và điều kiện bắt buộc xác nhận.
8. Danh sách tag/extension và cách xử lý tag lạ.
9. Đóng gói media, URL, checksum và quyền sử dụng.
10. Nhận diện lần nhập trước và khử trùng lặp.
11. Chiến lược mặc định xử lý xung đột.
12. Mã trạng thái tác vụ cuối cùng.
13. Yêu cầu bảo mật tệp tạm, lưu giữ và xóa.
14. Ngưỡng kích thước/thời gian/tài nguyên.
15. Ca kiểm thử bắt buộc/tùy chọn trong TFD-601.
16. Bộ dữ liệu tham chiếu và tiêu chí so sánh ngữ nghĩa.

## Phụ lục A — Ví dụ báo cáo mất thông tin

| Mã | Nguồn | Giới hạn ở đích | Mức minh họa | Hành động |
|---|---|---|---|---|
| LOSS-001 | Ngày chỉ biết năm | Đích bắt buộc ngày đầy đủ | L2 | Không tự tạo ngày; extension hoặc từ chối |
| LOSS-002 | Quan hệ cha nuôi | Đích chỉ có trường cha chung | L3 | Không ánh xạ thành cha sinh học; cần quyết định/extension |
| LOSS-003 | Nhiều tên theo giai đoạn | Đích giữ một tên | L2 | Giữ biến thể trong metadata/manifest |
| LOSS-004 | Assertion có nhiều citation và đánh giá xung đột | Đích chỉ có ghi chú | L3 | Báo cáo; ghi chú không tương đương cấu trúc |
| LOSS-005 | Dòng phả hệ có phạm vi/quy tắc | Không có trường tương đương | L2 | Extension/manifest và cảnh báo |
| LOSS-006 | Số điện thoại người sống | Chính sách không cho xuất | Theo chính sách | Ghi nhận loại bỏ vì riêng tư, không phải lỗi định dạng |

Mức minh họa cần được xác nhận theo thang cuối cùng. Loại bỏ theo chính sách riêng tư phải phân biệt với mất mát do định dạng.

## Phụ lục B — Checklist trước khi nhập

- [ ] Người thực hiện có quyền nhập vào phạm vi đích.
- [ ] Đã xác định nguồn, mục đích và phiên bản định dạng.
- [ ] Đã kiểm tra kích thước, mã hóa và tính toàn vẹn.
- [ ] Đã phân tích cú pháp và kiểm tra tham chiếu.
- [ ] Đã xem phần tử không hỗ trợ.
- [ ] Đã kiểm tra dữ liệu nhạy cảm và quyền sử dụng.
- [ ] Đã chọn mapping profile có phiên bản.
- [ ] Đã xem trước số lượng tạo/cập nhật/bỏ qua/lỗi.
- [ ] Đã xem cảnh báo trùng lặp và xung đột.
- [ ] Đã xác định rollback/phục hồi.
- [ ] Đã duyệt thay đổi rủi ro cao khi cần.
- [ ] Đã xác nhận manifest và báo cáo được lưu.

## Phụ lục C — Checklist trước khi xuất

- [ ] Có quyền xuất riêng biệt.
- [ ] Đã xác định người nhận, mục đích và phạm vi.
- [ ] Đã chọn định dạng, phiên bản và mapping profile.
- [ ] Đã đánh giá dữ liệu người còn sống và media.
- [ ] Đã xem trước trường/quan hệ không biểu diễn được.
- [ ] Đã xem báo cáo mất thông tin và mức độ.
- [ ] Đã xác nhận cảnh báo mất ngữ nghĩa trọng yếu.
- [ ] Đã kiểm tra cú pháp và tham chiếu tệp đích.
- [ ] Đã tạo manifest/checksum khi hỗ trợ.
- [ ] Đã xác định kênh phát hành và thời hạn lưu tệp tạm.
- [ ] Đã ghi nhận kết quả và mã lần chuyển đổi.

## Phụ lục D — Ví dụ manifest JSON

Ví dụ minh họa, không phải schema chuẩn đã đóng băng:

```json
{
  "conversion_id": "example-conv-001",
  "operation": "export",
  "started_at": "2026-10-21T02:00:00Z",
  "completed_at": "2026-10-21T02:00:08Z",
  "actor_id": "authorized-user-reference",
  "source_format": "TFD",
  "source_version": "0.1",
  "target_format": "GEDCOM",
  "target_version": "declared-profile-version",
  "converter_name": "example-converter",
  "converter_version": "0.1",
  "mapping_profile_id": "TFD-GEDCOM-PROFILE-0.1",
  "mapping_profile_version": "0.1",
  "records_read": 120,
  "records_created": 0,
  "records_updated": 0,
  "records_skipped": 4,
  "records_failed": 0,
  "warnings": ["Some lineage metadata requires an extension"],
  "errors": [],
  "privacy_transformations": ["Removed restricted contact fields"],
  "result_status": "SUCCESS_WITH_WARNINGS",
  "loss_report_ref": "loss-report-reference"
}
```

Trong triển khai thực tế, thời gian phải có quy ước múi giờ; tham chiếu phải theo quyền truy cập; không ghi dữ liệu nhạy cảm không cần thiết vào manifest.

## Phụ lục E — Tài liệu tham khảo và giới hạn

Khi chốt v1.0, nhóm quản trị TFD SHOULD đối chiếu đặc tả GEDCOM chính thức của phiên bản được chọn; tài liệu tương thích/phần mở rộng của phần mềm đích; TFD-101/102/103/301 ở phiên bản được duyệt; TFD-401; và bộ kiểm thử TFD-601.

Tài liệu này không khẳng định một phiên bản GEDCOM cụ thể đã được xác minh, không thay thế đặc tả chính thức và không bảo đảm mọi phần mềm bên ngoài đọc được extension của TFD.

---

## Tuyên bố trạng thái dự thảo

TFD-501 v0.1 là bản dự thảo đầy đủ để rà soát, thử nghiệm và đối chiếu với định dạng thực tế. Trước khi ban hành v1.0 cần chốt phiên bản GEDCOM, mapping profile, manifest, thang mất thông tin, xử lý xung đột và bộ kiểm thử. Hoàn tất kỹ thuật không đồng nghĩa dữ liệu đã được chuyển đổi đầy đủ hoặc không mất ý nghĩa.
