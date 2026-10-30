# TFD-401 — Quy chuẩn bảo mật, phân quyền và quản trị dữ liệu gia phả

**Mã tài liệu:** TFD-401  
**Tên:** Quy chuẩn bảo mật, phân quyền và quản trị dữ liệu gia phả  
**Bộ tiêu chuẩn:** TFD — Family Tree Doctrine  
**Phiên bản:** 0.1  
**Ngày:** 20/10/2026  
**Trạng thái:** Dự thảo đầy đủ để rà soát và thử nghiệm  
**Ngôn ngữ:** Tiếng Việt  
**Tài liệu liên quan:** TFD-001, TFD-101, TFD-102, TFD-103, TFD-201, TFD-301; TFD-501 và TFD-601 sẽ bổ sung yêu cầu liên quan đến nhập/xuất và kiểm thử tuân thủ.

> **Lưu ý trạng thái:** Đây là dự thảo tiêu chuẩn kỹ thuật và quản trị. Tài liệu không thay thế tư vấn pháp lý, đánh giá tác động xử lý dữ liệu cá nhân hoặc quy chế của từng dòng họ/tổ chức. Các quyết định còn mở ở Mục 22 phải được chốt trước khi tuyên bố phù hợp TFD-401 v1.0.

## Kiểm soát tài liệu

| Thuộc tính | Quy định |
|---|---|
| Chủ sở hữu tiêu chuẩn | Nhóm quản trị TFD được chỉ định |
| Đối tượng áp dụng | Phần mềm gia phả, kho lưu trữ, dịch vụ số hóa và tổ chức quản lý dữ liệu gia phả tuyên bố áp dụng TFD |
| Mức quy phạm | MUST / MUST NOT / SHOULD / SHOULD NOT / MAY |
| Chu kỳ rà soát đề xuất | Ít nhất mỗi năm một lần và sau sự cố nghiêm trọng hoặc thay đổi pháp luật đáng kể |
| Tài liệu triển khai | Chính sách nội bộ, ma trận quyền, quy trình vận hành và hồ sơ kiểm thử của từng hệ thống |

### Quy ước từ ngữ quy phạm

- **MUST / PHẢI:** yêu cầu bắt buộc để tuyên bố phù hợp với điều khoản.
- **MUST NOT / KHÔNG ĐƯỢC:** hành vi bị cấm.
- **SHOULD / NÊN:** thực hành mặc định; nếu không áp dụng phải ghi nhận lý do và biện pháp thay thế.
- **SHOULD NOT / KHÔNG NÊN:** thực hành nên tránh; nếu áp dụng phải giải trình.
- **MAY / CÓ THỂ:** lựa chọn được phép.
- “Hệ thống” bao gồm ứng dụng, API, cơ sở dữ liệu, kho tệp, bản sao lưu, công cụ nhập/xuất và môi trường vận hành.
- “Chủ thể dữ liệu” là người còn sống có thông tin được xử lý. “Người được ủy quyền” là cá nhân được cấp quyền có phạm vi xác định. “Tổ chức quản lý dữ liệu” là dòng họ, hội đồng gia tộc, cơ quan lưu trữ hoặc đơn vị vận hành được giao trách nhiệm quản lý.

## 1. Mục đích

TFD-401 xác định các yêu cầu tối thiểu về bảo mật, phân quyền, quyền riêng tư, quản trị, lưu giữ, chia sẻ và xử lý sự cố đối với dữ liệu gia phả.

Mục tiêu:

1. Bảo vệ thông tin cá nhân, đặc biệt là dữ liệu của người còn sống.
2. Ngăn truy cập, sửa đổi, công bố, xóa hoặc xuất dữ liệu trái phép.
3. Xác định rõ ai được làm gì, trên tập dữ liệu nào, với mục đích nào và trong thời hạn nào.
4. Bảo đảm thao tác quan trọng có thể truy nguyên, nhưng không biến nhật ký thành nơi lưu trữ tràn lan dữ liệu nhạy cảm.
5. Duy trì khả năng phục hồi dữ liệu và tính liên tục của dịch vụ.
6. Giữ sự phân biệt giữa quyền quản lý dữ liệu và quyền quyết định tính đúng sai của kết luận lịch sử.
7. Cho phép chia sẻ nghiên cứu có kiểm soát mà không mặc nhiên công khai toàn bộ hồ sơ gia đình.

TFD-401 áp dụng nguyên tắc giảm thiểu dữ liệu và bảo vệ quyền riêng tư ngay từ thiết kế; không coi dữ liệu gia phả là dữ liệu công khai chỉ vì một phần thông tin đã xuất hiện trong sách hoặc trên Internet.

## 2. Phạm vi

### 2.1 Trong phạm vi

- Tài khoản, xác thực, phiên làm việc và quản lý đặc quyền.
- Phân quyền theo vai trò, phạm vi dòng họ/chi phái/hồ sơ và hành động.
- Dữ liệu người còn sống, người đã mất và dữ liệu về quan hệ gia đình.
- Nguồn, ảnh, bản chụp, bản ghi âm, bản phiên âm, chứng cứ, nhận định và kết luận.
- Chia sẻ, công bố, tải xuống, in, API, sao chép và nhập/xuất dữ liệu.
- Nhật ký bảo mật, lịch sử thay đổi, lưu giữ, sao lưu, phục hồi và hủy dữ liệu.
- Quản trị tổ chức, xử lý yêu cầu của chủ thể dữ liệu và ứng phó sự cố.
- Nhà cung cấp, người xử lý dữ liệu và các tích hợp bên ngoài.

### 2.2 Ngoài phạm vi

TFD-401 không định nghĩa chi tiết:

- Mô hình thực thể và quan hệ tổng thể — TFD-101.
- Mã định danh và ngữ nghĩa quan hệ — TFD-102.
- Mô hình sự kiện, niên đại, nguồn và chứng cứ — TFD-103.
- Quy tắc dòng họ, chi phái, thế hệ và xưng hô — TFD-201.
- Quy trình nghiệp vụ chuyên sâu về nguồn, chứng cứ và dị bản — TFD-301.
- Quy tắc chuyển đổi GEDCOM — TFD-501.
- Bộ kiểm thử toàn bộ TFD — TFD-601.

Các tài liệu trên vẫn phải tuân thủ yêu cầu bảo vệ, phân quyền và truy nguyên tại TFD-401.

## 3. Nguyên tắc nền tảng

### SEC-PR-01 — Quyền riêng tư theo mặc định

Hệ thống MUST đặt hồ sơ mới ở chế độ riêng tư hoặc giới hạn theo phạm vi được phê duyệt. Không được mặc định công khai chỉ vì người tạo đã nhập dữ liệu.

### SEC-PR-02 — Đặc quyền tối thiểu

Tài khoản chỉ được cấp các quyền cần thiết cho nhiệm vụ được giao. Quyền quản trị kỹ thuật không mặc nhiên cho phép quyết định nội dung gia phả hoặc công bố hồ sơ.

### SEC-PR-03 — Phân tách nhiệm vụ

Với thao tác rủi ro cao, hệ thống SHOULD yêu cầu người đề xuất và người phê duyệt khác nhau. Nếu quy mô tổ chức không cho phép, phải áp dụng biện pháp bù trừ như xác thực tăng cường, nhật ký bắt buộc và rà soát sau thao tác.

### SEC-PR-04 — Mục đích xác định

Việc truy cập, sử dụng, chia sẻ và xuất dữ liệu MUST gắn với mục đích hợp lệ, phù hợp chính sách và phạm vi quyền đã cấp.

### SEC-PR-05 — Tách dữ kiện, nhận định và quyền quản trị

Người có quyền quản trị không được tự động coi nhận định của mình là kết luận lịch sử có căn cứ. Quyền sửa dữ liệu, quyền đánh giá chứng cứ và quyền phê duyệt công bố là các quyền riêng biệt khi hệ thống hỗ trợ.

### SEC-PR-06 — Truy nguyên có giới hạn

Thao tác quan trọng MUST có thể truy nguyên đến tài khoản hoặc tác nhân hệ thống, thời điểm, hành động và đối tượng. Nhật ký MUST NOT lưu mật khẩu, mã xác thực, khóa bí mật hoặc bản sao đầy đủ của dữ liệu nhạy cảm nếu không thực sự cần thiết.

### SEC-PR-07 — Giữ nguyên bản gốc

Khi bảo vệ dữ liệu nguồn hoặc sửa sai, hệ thống SHOULD giữ nguyên bản gốc và ghi nhận phiên bản/quan hệ giữa các bản. Việc che thông tin để công bố không được phá hủy bản lưu trữ có thẩm quyền.

### SEC-PR-08 — An toàn xuyên suốt vòng đời

Bảo vệ dữ liệu áp dụng cho thu thập, lưu trữ, sử dụng, truyền tải, sao lưu, chia sẻ, lưu trữ dài hạn và hủy dữ liệu.

### SEC-PR-09 — Không suy diễn từ quyền truy cập

Việc một người xem được hồ sơ không có nghĩa họ có quyền sửa, tải xuống, sao chép, chia sẻ hoặc công bố hồ sơ đó.

## 4. Thuật ngữ

| Thuật ngữ | Định nghĩa trong TFD-401 |
|---|---|
| Chủ thể dữ liệu | Người còn sống mà thông tin cá nhân được xử lý |
| Tổ chức quản lý dữ liệu | Tổ chức hoặc nhóm được giao trách nhiệm quản trị bộ dữ liệu |
| Người vận hành | Cá nhân/đơn vị vận hành hệ thống kỹ thuật |
| Chủ sở hữu hồ sơ | Người/tổ chức chịu trách nhiệm nghiệp vụ đối với hồ sơ cụ thể; không nhất thiết là chủ thể dữ liệu |
| Quyền | Hành động được phép thực hiện trên một tài nguyên trong phạm vi xác định |
| Phạm vi | Tập dữ liệu mà quyền áp dụng: hệ thống, dòng họ, chi/phái, hồ sơ hoặc tài nguyên cụ thể |
| Dữ liệu nhạy cảm | Dữ liệu cần bảo vệ tăng cường do tính chất hoặc hậu quả khi bị tiết lộ; phân loại cụ thể do chính sách và pháp luật áp dụng quyết định |
| Dữ liệu hạn chế | Dữ liệu chỉ được truy cập bởi người hoặc nhóm được chỉ định |
| Công bố | Đưa dữ liệu ra ngoài phạm vi người được phép truy cập ban đầu, gồm trang công khai, bản in, liên kết chia sẻ, API và tệp xuất |
| Ẩn danh | Biến đổi khiến không thể nhận diện cá nhân bằng phương tiện hợp lý trong bối cảnh áp dụng |
| Giả danh | Thay định danh trực tiếp bằng mã/nhãn khác nhưng vẫn có thể liên kết trở lại bằng thông tin bổ sung |
| Sự cố bảo mật | Sự kiện gây hoặc có nguy cơ gây truy cập, tiết lộ, mất, thay đổi hay gián đoạn trái phép |
| Quyền khẩn cấp | Quyền tạm thời được sử dụng để xử lý sự cố nghiêm trọng, có giới hạn và hậu kiểm |
| Nhật ký kiểm toán | Bản ghi có kiểm soát về hoạt động liên quan đến an toàn, quyền truy cập và thay đổi quan trọng |

Mọi tuyên bố “đã ẩn danh” MUST được đánh giá theo nguy cơ tái nhận diện. Xóa tên không đủ để chứng minh dữ liệu đã ẩn danh.

## 5. Phân loại dữ liệu

### 5.1 Các mức phân loại đề xuất

| Mức | Tên | Ví dụ | Mặc định truy cập |
|---|---|---|---|
| P0 | Công khai đã duyệt | Hồ sơ lịch sử đã được phê duyệt công bố | Công khai theo phạm vi đã duyệt |
| P1 | Nội bộ | Ghi chú vận hành không nhạy cảm, danh mục công việc | Thành viên được cấp quyền |
| P2 | Hạn chế | Hồ sơ nguồn chưa công bố, liên hệ riêng, ghi chú gia đình | Nhóm được chỉ định |
| P3 | Nhạy cảm cao | Dữ liệu định danh của người còn sống, thông tin có thể gây tổn hại, thông tin xác thực | Người được ủy quyền rõ ràng; kiểm soát tăng cường |

Đây là mô hình phân loại đề xuất cho dự thảo, không phải phân loại pháp lý bắt buộc. Tổ chức có thể đặt tên mức khác nhưng MUST lập bảng ánh xạ tương đương.

### 5.2 Quy tắc phân loại

1. Hệ thống MUST hỗ trợ xác định mức bảo vệ của hồ sơ hoặc tài nguyên.
2. Khi tài nguyên chứa nhiều loại dữ liệu, phải áp dụng mức bảo vệ phù hợp với phần có yêu cầu cao nhất, trừ khi dữ liệu được tách an toàn.
3. Ảnh chụp giấy tờ, hồ sơ y tế, thông tin liên hệ riêng hoặc tài liệu gia đình không được tự động xếp là công khai.
4. Tình trạng đã mất của một người không làm cho mọi thông tin liên quan đến họ trở thành công khai; hồ sơ có thể chứa dữ liệu của người còn sống.
5. Dữ liệu lịch sử đã công khai trong nguồn gốc vẫn phải đánh giá rủi ro khi tổng hợp, liên kết hoặc lập hồ sơ chi tiết mới.
6. Tệp đính kèm, siêu dữ liệu, tên tệp, chú thích và bản xem trước đều thuộc phạm vi phân loại.
7. Mức phân loại MUST được giữ trong bản sao, bản xuất hoặc metadata kiểm soát khi khả thi.

### 5.3 Đánh giá rủi ro

Tổ chức SHOULD xem xét tối thiểu: mức độ nhận diện; độ nhạy cảm; số người bị ảnh hưởng; khả năng gây lừa đảo, quấy rối, tranh chấp hoặc tổn hại danh dự; khả năng tái nhận diện; tính công khai trước đó; và khả năng thu hồi sau khi công bố.

## 6. Vai trò và trách nhiệm

### 6.1 Vai trò khuyến nghị

| Vai trò | Trách nhiệm chính | Không mặc nhiên được phép |
|---|---|---|
| Governance Owner | Phê duyệt chính sách, phạm vi công bố và cơ chế giải quyết tranh chấp | Tự ý bỏ qua căn cứ chứng cứ |
| Data Steward | Quản lý chất lượng, phân loại, metadata, yêu cầu sửa đổi | Công bố dữ liệu nhạy cảm nếu chưa được duyệt |
| Genealogy Editor | Đề xuất/sửa dữ liệu gia phả trong phạm vi được giao | Quản trị tài khoản hoặc tự duyệt thao tác của chính mình khi cần phân tách |
| Evidence Reviewer | Rà soát nguồn, chứng cứ, nhận định và mâu thuẫn | Sửa/xóa nguồn gốc để phù hợp kết luận |
| Privacy/Security Officer | Điều phối quyền riêng tư, an toàn, yêu cầu và sự cố | Sử dụng dữ liệu ngoài mục đích được giao |
| System Administrator | Vận hành tài khoản, cấu hình, hạ tầng và phục hồi | Mặc nhiên có quyền công bố nội dung |
| Read-only Researcher | Đọc dữ liệu được cấp để nghiên cứu | Sửa, tải hàng loạt hoặc chia sẻ lại nếu chưa được phép |
| Public Visitor | Xem nội dung được phê duyệt công khai | Truy cập hồ sơ nội bộ/hạn chế |
| Service Account | Thực hiện tác vụ máy-máy được định nghĩa | Đăng nhập tương tác hoặc có quyền rộng không cần thiết |

Một cá nhân có thể kiêm nhiệm nhiều vai trò trong tổ chức nhỏ, nhưng hệ thống MUST vẫn kiểm soát phạm vi quyền và SHOULD ghi nhận xung đột nhiệm vụ.

### 6.2 Trách nhiệm giải trình

Mỗi tổ chức MUST chỉ định đầu mối chịu trách nhiệm đối với:
- phê duyệt chính sách truy cập và công bố;
- xử lý yêu cầu của chủ thể dữ liệu;
- rà soát tài khoản và quyền;
- quản lý sao lưu và khôi phục;
- tiếp nhận và xử lý sự cố;
- quyết định thời hạn lưu giữ và xử lý dữ liệu khi chấm dứt hoạt động.

Nếu chưa chỉ định được một cá nhân riêng cho mỗi trách nhiệm, tổ chức MUST ghi rõ người/nhóm chịu trách nhiệm thay thế.

## 7. Mô hình phân quyền

### 7.1 Kiểm soát kết hợp

Hệ thống SHOULD kết hợp:
- **RBAC** — quyền theo vai trò;
- **phạm vi tài nguyên** — dòng họ, chi/phái, hồ sơ, nguồn hoặc tệp cụ thể;
- **điều kiện** — trạng thái hồ sơ, phân loại, quan hệ với tài nguyên, mục đích, thời hạn hoặc phê duyệt;
- **ngữ cảnh** — mức xác thực, trạng thái tài khoản, rủi ro phiên hoặc yêu cầu khẩn cấp.

Không được chỉ dựa vào tên vai trò chung nếu người dùng thuộc nhiều dòng họ hoặc có quyền ở phạm vi khác nhau.

### 7.2 Các hành động quyền tối thiểu

Hệ thống SHOULD biểu diễn quyền theo các hành động riêng biệt:

- `view_metadata`
- `view_content`
- `create`
- `edit`
- `propose_change`
- `review`
- `approve`
- `publish`
- `unpublish`
- `download`
- `export`
- `share`
- `manage_access`
- `manage_policy`
- `manage_retention`
- `restore`
- `delete_or_tombstone`
- `view_audit`
- `respond_to_subject_request`

Đây là mã gợi ý để chuẩn hóa thiết kế, chưa phải danh mục mã bắt buộc toàn bộ TFD. Triển khai có thể dùng mã khác nếu ánh xạ rõ ràng và kiểm thử được.

### 7.3 Ma trận quyền tham khảo

| Hành động | Visitor | Researcher | Editor | Reviewer | Steward | Admin kỹ thuật | Governance Owner |
|---|---:|---:|---:|---:|---:|---:|---:|
| Xem nội dung công khai | Có | Có | Có | Có | Có | Theo nhiệm vụ | Có |
| Xem hồ sơ hạn chế | Không | Có điều kiện | Có điều kiện | Có điều kiện | Có điều kiện | Không mặc nhiên | Theo chính sách |
| Đề xuất thay đổi | Không | Theo cấp quyền | Có | Có | Có | Không mặc nhiên | Có |
| Duyệt nhận định/chứng cứ | Không | Không mặc nhiên | Không mặc nhiên | Có | Theo phạm vi | Không | Theo quy chế |
| Công bố | Không | Không | Không mặc nhiên | Không mặc nhiên | Theo ủy quyền | Không mặc nhiên | Theo quy chế |
| Quản lý tài khoản | Không | Không | Không | Không | Không mặc nhiên | Có | Theo chính sách |
| Xuất hàng loạt | Không | Theo phê duyệt | Theo phạm vi | Theo nhiệm vụ | Theo phê duyệt | Không mặc nhiên | Phê duyệt theo quy chế |
| Xem nhật ký kiểm toán | Không | Không | Hạn chế | Theo nhiệm vụ | Theo nhiệm vụ | Theo nhiệm vụ | Theo chính sách |

“Có điều kiện” nghĩa là phải kiểm tra phạm vi, phân loại, mục đích và các điều kiện áp dụng; không phải quyền mặc định trên toàn hệ thống.

### 7.4 Quy tắc kiểm tra quyền

1. Mọi yêu cầu đọc/ghi qua UI, API, tác vụ nền và tích hợp MUST được kiểm tra quyền phía máy chủ.
2. Ẩn nút trên giao diện không thay thế kiểm soát truy cập phía máy chủ.
3. Quyền phải được kiểm tra trên từng đối tượng để chống truy cập bằng cách thay ID hoặc URL.
4. Quyền kế thừa từ dòng họ/chi/phái MUST được xác định rõ; không được suy ra từ quan hệ huyết thống hoặc cách xưng hô.
5. Mặc định từ chối khi không có quyền hoặc không thể xác minh quyền.
6. Khi quyền bị thu hồi, phiên và token liên quan SHOULD mất hiệu lực trong thời gian xác định theo chính sách rủi ro.
7. Tác vụ nền phải dùng danh tính dịch vụ riêng, phạm vi tối thiểu và nhật ký có thể truy nguyên.
8. Quyền quản trị không được bỏ qua các kiểm soát bảo mật mà không có cơ chế khẩn cấp được ghi nhận.

## 8. Tài khoản và xác thực

### 8.1 Quản lý vòng đời tài khoản

Hệ thống MUST hỗ trợ quy trình cấp, thay đổi, tạm khóa, thu hồi và chấm dứt quyền truy cập. Tài khoản dùng chung cho nhiều người SHOULD NOT được sử dụng.

- Tài khoản phải gắn với một cá nhân hoặc một tác nhân dịch vụ xác định.
- Quyền phải có người phê duyệt và lý do khi rủi ro phù hợp yêu cầu.
- Tài khoản không hoạt động, tài khoản của người đã rời nhiệm vụ và tài khoản thử nghiệm phải được rà soát, vô hiệu hóa hoặc xóa theo chính sách.
- Tài khoản đặc quyền MUST được kiểm kê riêng.
- Khôi phục tài khoản phải xác minh danh tính theo mức rủi ro; không dùng câu hỏi bảo mật dễ đoán làm yếu tố duy nhất.

### 8.2 Mật khẩu và xác thực nhiều yếu tố

1. Mật khẩu MUST được lưu bằng thuật toán băm mật khẩu chuyên dụng, có salt riêng; không lưu bản rõ hoặc mã hóa có thể đảo ngược để dùng thay băm.
2. Hệ thống MUST giới hạn thử đăng nhập và áp dụng biện pháp chống dò mật khẩu phù hợp.
3. Hệ thống SHOULD hỗ trợ xác thực nhiều yếu tố (MFA), MUST yêu cầu MFA cho tài khoản đặc quyền nếu có khả năng triển khai phù hợp.
4. Mã khôi phục, mã dùng một lần và bí mật xác thực MUST được bảo vệ, không ghi vào log.
5. Cơ chế đặt lại mật khẩu MUST có thời hạn, dùng một lần và không tiết lộ tài khoản có tồn tại hay không nếu điều đó làm tăng rủi ro.
6. Thông báo đăng nhập hoặc thay đổi thông tin bảo mật SHOULD được gửi qua kênh liên hệ đã xác minh khi phù hợp.

### 8.3 Phiên và token

- Token phải có thời hạn và phạm vi rõ ràng.
- Hệ thống MUST có cơ chế thu hồi hoặc vô hiệu hóa phiên khi đăng xuất, đổi thông tin xác thực, khóa tài khoản hoặc phát hiện sự cố.
- Cookie phiên trên web SHOULD dùng thuộc tính bảo mật phù hợp như `HttpOnly`, `Secure` và `SameSite`.
- Không lưu token dài hạn trong nơi có thể bị mã độc phía trình duyệt đọc nếu có phương án an toàn hơn.
- Token API MUST không dùng chung cho nhiều mục đích không liên quan; bí mật phải được xoay vòng khi nghi ngờ lộ lọt.

## 9. Bảo vệ dữ liệu trong lưu trữ và truyền tải

### 9.1 Truyền tải

Dữ liệu xác thực và dữ liệu hạn chế MUST được truyền qua kênh mã hóa phù hợp. Chứng thư và cấu hình TLS phải được quản lý, cập nhật; không bỏ kiểm tra chứng thư trong môi trường sản xuất.

### 9.2 Lưu trữ

- Dữ liệu nhạy cảm MUST được bảo vệ bằng kiểm soát truy cập và các biện pháp mã hóa phù hợp với rủi ro.
- Khóa mã hóa MUST được quản lý tách biệt với dữ liệu được bảo vệ và chỉ cấp cho dịch vụ cần thiết.
- Bí mật triển khai MUST không được đưa vào mã nguồn, tệp mẫu công khai hoặc nhật ký.
- Tệp tải lên MUST được kiểm tra loại, kích thước và quyền truy cập; không tin hoàn toàn phần mở rộng tệp hoặc MIME do phía người dùng khai báo.
- Hệ thống SHOULD quét tệp độc hại và cách ly tệp chưa kiểm tra trước khi cho tải xuống hoặc xử lý.
- Tệp gốc có giá trị lưu trữ nên được bảo toàn tính toàn vẹn bằng checksum/hash và metadata nguồn gốc.

### 9.3 Môi trường

1. Môi trường phát triển, thử nghiệm và sản xuất MUST được tách biệt phù hợp.
2. Dữ liệu thật của người còn sống SHOULD NOT được sao chép vào môi trường phát triển/thử nghiệm. Nếu bắt buộc, phải có phê duyệt, giảm thiểu dữ liệu và bảo vệ tương đương.
3. Tài khoản, khóa và dữ liệu mẫu của môi trường thử nghiệm MUST NOT cho phép truy cập môi trường sản xuất.
4. Quyền truy cập cơ sở dữ liệu trực tiếp phải giới hạn, ghi nhận và rà soát.
5. Nhà cung cấp hạ tầng hoặc dịch vụ bên ngoài phải được đánh giá theo loại dữ liệu, vị trí xử lý, quyền truy cập và điều khoản hợp đồng.

## 10. Bảo vệ dữ liệu người còn sống

### 10.1 Mặc định hạn chế

Thông tin nhận diện và thông tin riêng của người còn sống MUST mặc định ở chế độ hạn chế, trừ khi có căn cứ và phê duyệt rõ ràng cho phạm vi khác.

Thông tin cần xem xét gồm nhưng không giới hạn:
- ngày/tháng/năm sinh đầy đủ;
- địa chỉ, số điện thoại, email và thông tin liên hệ;
- giấy tờ định danh, chữ ký, ảnh tài liệu;
- thông tin sức khỏe, tình trạng pháp lý hoặc hoàn cảnh cá nhân;
- quan hệ gia đình có thể gây tổn hại nếu công bố;
- ghi chú riêng, tranh chấp, thông tin chưa được xác minh;
- ảnh hoặc tài liệu có chứa dữ liệu của nhiều người.

### 10.2 Phân biệt người sống và người đã mất

1. Hệ thống SHOULD có trạng thái sống/chưa rõ/đã mất hoặc biểu diễn tương đương, cùng nguồn và mức chắc chắn nếu có.
2. Không được suy ra một người đã mất chỉ vì năm sinh đã xa hoặc không có hoạt động gần đây.
3. Nếu trạng thái sống chưa rõ, áp dụng mức bảo vệ thận trọng hơn cho đến khi có căn cứ phù hợp.
4. Một tài liệu có thông tin của cả người đã mất và người còn sống phải được xem xét theo phần thông tin của người còn sống.
5. Việc công bố một thông tin về người đã mất không tự động cho phép công bố thông tin riêng của thân nhân còn sống.

### 10.3 Trẻ em và người cần bảo vệ tăng cường

Dữ liệu về trẻ em và người dễ bị tổn thương MUST được bảo vệ tăng cường. Hệ thống SHOULD hạn chế công khai ngày sinh đầy đủ, địa chỉ, trường học, thông tin liên hệ và dữ liệu có thể tạo nguy cơ an toàn. Việc chia sẻ phải tuân theo pháp luật áp dụng và chính sách của tổ chức.

### 10.4 Không tự động suy diễn dữ liệu nhạy cảm

Hệ thống MUST NOT tự suy luận hoặc gán thuộc tính nhạy cảm cho cá nhân từ họ tên, quan hệ, địa điểm, hình ảnh hay dữ liệu thống kê nếu không có căn cứ, mục đích và quyền xử lý phù hợp.

## 11. Chia sẻ và công bố

### 11.1 Các phạm vi chia sẻ

Hệ thống SHOULD phân biệt tối thiểu:
- riêng tư cho người nhập hoặc người được chỉ định;
- nội bộ tổ chức/dòng họ;
- chia sẻ có kiểm soát cho nhóm nghiên cứu;
- liên kết chia sẻ giới hạn;
- công khai trên Internet hoặc xuất bản.

Mỗi phạm vi phải mô tả rõ ai có thể xem, tải xuống, sao chép, tìm kiếm hoặc chia sẻ tiếp.

### 11.2 Quy trình công bố

Công bố dữ liệu hạn chế MUST có:
1. mục đích và phạm vi công bố;
2. người đề xuất và người phê duyệt theo chính sách;
3. đánh giá dữ liệu của người còn sống và dữ liệu của bên thứ ba;
4. kiểm tra nguồn, quyền sử dụng tài liệu và các giới hạn liên quan;
5. lựa chọn trường dữ liệu cần thiết, loại bỏ phần không cần thiết;
6. ngày công bố, phiên bản và cơ chế rà soát/gỡ bỏ.

### 11.3 Liên kết chia sẻ

- Liên kết có quyền truy cập MUST có thời hạn hoặc cơ chế thu hồi khi phù hợp với rủi ro.
- Liên kết bí mật không được coi là kiểm soát truy cập duy nhất cho dữ liệu nhạy cảm cao.
- Giao diện phải hiển thị rõ phạm vi quyền trước khi tạo liên kết.
- Tổ chức SHOULD ghi nhận ai tạo liên kết, thời hạn, phạm vi và việc thu hồi.
- Không được mặc định cho phép người nhận chia sẻ tiếp.

### 11.4 Chỉ mục tìm kiếm và bộ nhớ đệm

Khi gỡ bỏ hoặc hạn chế nội dung công khai, hệ thống SHOULD xử lý chỉ mục tìm kiếm, bộ nhớ đệm và bản xem trước do mình kiểm soát. Tổ chức không được cam kết có thể xóa mọi bản sao do bên thứ ba đã thu thập; cần mô tả giới hạn này trong chính sách.

## 12. Xuất dữ liệu, API và tích hợp

1. Quyền xem không mặc nhiên bao gồm quyền xuất hàng loạt.
2. Xuất dữ liệu MUST kiểm tra quyền trên từng tập dữ liệu và tài nguyên đính kèm.
3. Tác vụ xuất có rủi ro cao SHOULD yêu cầu lý do, phê duyệt, giới hạn phạm vi và ghi nhật ký.
4. Tệp xuất MUST giữ metadata về nguồn gốc, trạng thái, mức phân loại hoặc cảnh báo khi định dạng hỗ trợ.
5. Nếu định dạng đích không biểu diễn được quyền, mức bảo vệ, nguồn hoặc lịch sử, hệ thống MUST nêu rõ giới hạn và cảnh báo trước khi xuất.
6. Bản xuất dành cho công bố SHOULD hỗ trợ loại bỏ hoặc giảm chi tiết thông tin của người còn sống.
7. API MUST xác thực và phân quyền trên từng đối tượng; phải giới hạn tốc độ và kích thước truy vấn phù hợp.
8. Khóa API phải có phạm vi, thời hạn, chủ sở hữu và quy trình thu hồi.
9. Tích hợp bên ngoài MUST chỉ nhận trường dữ liệu cần thiết; không gửi toàn bộ hồ sơ chỉ để đáp ứng một tác vụ nhỏ.
10. Lỗi API và thông báo hệ thống MUST NOT làm lộ token, bí mật hoặc dữ liệu cá nhân không cần thiết.
11. TFD-501 cần quy định chi tiết thêm cách thể hiện và báo cáo mất thông tin khi chuyển đổi GEDCOM.

## 13. Nhật ký kiểm toán và lịch sử thay đổi

### 13.1 Sự kiện cần ghi nhận

Tùy năng lực và rủi ro, hệ thống MUST ghi nhận tối thiểu các sự kiện quan trọng:
- đăng nhập thành công/thất bại và thay đổi xác thực đáng kể;
- cấp, đổi, thu hồi vai trò và quyền;
- truy cập hoặc xuất dữ liệu nhạy cảm theo chính sách;
- tạo liên kết chia sẻ, công bố và gỡ công bố;
- thay đổi hoặc xóa/đánh dấu xóa hồ sơ, nguồn, nhận định, kết luận;
- hành động khẩn cấp;
- thao tác sao lưu, phục hồi, thay đổi chính sách bảo mật;
- yêu cầu của chủ thể dữ liệu và kết quả xử lý;
- sự kiện bảo mật và quyết định ứng phó.

Không phải mọi lần đọc mọi trường đều cần ghi log riêng; phạm vi ghi nhận phải cân bằng khả năng kiểm toán, hiệu năng và quyền riêng tư.

### 13.2 Nội dung tối thiểu

Nhật ký nên bao gồm:
- mã sự kiện và thời điểm;
- tác nhân (người dùng hoặc dịch vụ);
- hành động và kết quả;
- tài nguyên/phạm vi liên quan;
- lý do hoặc mã quy trình khi cần;
- mã tương quan để liên kết các sự kiện;
- nguồn truy cập hoặc ngữ cảnh kỹ thuật ở mức cần thiết.

### 13.3 Bảo vệ nhật ký

- Nhật ký MUST được bảo vệ khỏi sửa/xóa trái phép.
- Tài khoản có quyền tạo log SHOULD NOT mặc nhiên có quyền xóa log.
- Thông tin xác thực, nội dung riêng tư đầy đủ và bí mật MUST NOT được ghi vào log.
- Truy cập log phải được giới hạn và có thể kiểm toán.
- Tổ chức SHOULD phát hiện sửa đổi bất thường, mất log hoặc gián đoạn thu thập.
- Thời hạn lưu log phải được xác định, có lý do và phù hợp nghĩa vụ pháp lý.

### 13.4 Phân biệt nhật ký kỹ thuật và lịch sử gia phả

Nhật ký bảo mật ghi lại hành động của hệ thống/người vận hành; lịch sử nghiệp vụ ghi lại thay đổi dữ liệu gia phả; nguồn và chứng cứ ghi lại cơ sở của nhận định. Không được dùng một loại bản ghi thay thế hoàn toàn cho loại khác. TFD-101, TFD-103 và TFD-301 định nghĩa thêm các liên kết nghiệp vụ liên quan.

## 14. Lưu giữ, sửa, xóa và bảo toàn

### 14.1 Chính sách lưu giữ

Tổ chức MUST xác định thời hạn hoặc tiêu chí lưu giữ cho:
- hồ sơ gia phả và các phiên bản;
- dữ liệu cá nhân liên hệ;
- nguồn và tệp gốc;
- nhật ký bảo mật;
- tệp xuất và bản sao tạm;
- tài khoản và dữ liệu vận hành;
- bản sao lưu.

Không được đặt một thời hạn duy nhất cho mọi loại dữ liệu nếu mục đích và nghĩa vụ khác nhau.

### 14.2 Sửa và xóa

1. Sửa dữ liệu MUST tuân theo quyền và quy trình phù hợp; thay đổi có ý nghĩa lịch sử SHOULD có phiên bản hoặc lịch sử.
2. Xóa logic/đánh dấu xóa có thể được ưu tiên khi cần bảo toàn tính toàn vẹn của quan hệ và lịch sử.
3. Hệ thống MUST phân biệt xóa khỏi giao diện, xóa khỏi hệ thống hoạt động, hết hạn khỏi bản sao lưu và hủy không thể khôi phục.
4. Không được dùng “xóa” để âm thầm che giấu bất đồng chứng cứ hoặc thay đổi kết luận mà không để lại lịch sử thích hợp.
5. Yêu cầu xóa dữ liệu cá nhân phải được đánh giá theo quyền áp dụng, nghĩa vụ lưu trữ, quyền của người khác và tính toàn vẹn của hồ sơ.
6. Nếu không thể xóa toàn bộ vì nghĩa vụ lưu trữ hoặc quyền lợi hợp pháp khác, tổ chức MUST ghi rõ lý do, phạm vi giữ lại và biện pháp hạn chế.

### 14.3 Bảo toàn nguồn lịch sử

Việc bảo toàn bản nguồn không đồng nghĩa phải công khai bản nguồn. Có thể giữ bản gốc ở kho hạn chế, còn bản công bố được che thông tin hoặc trích đoạn phù hợp. Khi cần che dữ liệu, phải giữ liên kết nội bộ giữa bản gốc và bản công bố theo quyền cho phép.

### 14.4 Dữ liệu lưu trong bản sao lưu

Chính sách xóa MUST nêu cách xử lý dữ liệu trong bản sao lưu. Nếu không thể loại bỏ ngay khỏi bản sao lưu bất biến, tổ chức SHOULD:
- ngăn phục hồi dữ liệu đã bị xóa trở lại môi trường hoạt động mà không áp dụng lại yêu cầu xóa;
- giới hạn quyền truy cập bản sao lưu;
- đặt thời hạn hết hiệu lực;
- ghi nhận giới hạn và ngày dự kiến hết hạn.

## 15. Sao lưu và khôi phục

1. Tổ chức MUST có chính sách sao lưu dựa trên mức quan trọng và khả năng chịu mất dữ liệu.
2. Sao lưu MUST được bảo vệ với mức phù hợp, gồm kiểm soát quyền và mã hóa khi cần.
3. Bản sao lưu SHOULD được tách biệt khỏi môi trường sản xuất; một bản sao quan trọng SHOULD được bảo vệ trước nguy cơ bị sửa/xóa đồng thời.
4. Lịch sao lưu phải xác định tần suất, thời gian lưu, phạm vi và trách nhiệm giám sát.
5. Hệ thống MUST có quy trình khôi phục được lập thành tài liệu.
6. Khôi phục SHOULD được thử định kỳ; không chỉ xác minh rằng tệp sao lưu tồn tại mà phải kiểm tra khả năng phục hồi và tính toàn vẹn.
7. Mục tiêu RPO (mức mất dữ liệu chấp nhận được) và RTO (thời gian khôi phục mục tiêu) MUST được tổ chức xác định theo mức quan trọng. TFD không đặt một giá trị chung cho mọi hệ thống.
8. Sau khôi phục, phải kiểm tra quyền truy cập, tính nhất quán, lịch sử thay đổi và yêu cầu xóa/hạn chế đã phát sinh sau thời điểm sao lưu.
9. Việc khôi phục dữ liệu không được vô tình khôi phục tài khoản, khóa hoặc quyền đã bị thu hồi.

## 16. Quản lý rủi ro và lỗ hổng

Tổ chức SHOULD duy trì quy trình:
- kiểm kê tài sản và luồng dữ liệu;
- đánh giá nguy cơ đối với dữ liệu người còn sống và nguồn gốc;
- rà soát cấu hình, thư viện và phụ thuộc;
- xử lý bản vá theo mức độ nghiêm trọng;
- kiểm thử phân quyền và lỗ hổng định kỳ;
- quản lý bí mật và xoay vòng khóa;
- đánh giá nhà cung cấp và tích hợp;
- ghi nhận rủi ro tồn dư, người chấp nhận và ngày xem xét lại.

Không được tuyên bố hệ thống “an toàn tuyệt đối”. Mọi ngoại lệ bảo mật cần có phạm vi, lý do, biện pháp bù trừ, người phê duyệt và hạn rà soát.

## 17. Ứng phó sự cố bảo mật

### 17.1 Chu trình

Hệ thống/tổ chức SHOULD duy trì chu trình:
1. **Phát hiện và tiếp nhận:** nhận cảnh báo, báo cáo và dấu hiệu bất thường.
2. **Phân loại:** xác định loại dữ liệu, phạm vi, mức độ và nguy cơ tiếp diễn.
3. **Khoanh vùng:** hạn chế quyền, thu hồi token, tạm dừng chia sẻ hoặc cách ly hệ thống khi phù hợp.
4. **Bảo toàn bằng chứng:** lưu log, mốc thời gian và bản ghi liên quan; tránh làm mất chứng cứ.
5. **Khắc phục:** xử lý nguyên nhân, vá lỗ hổng, đổi bí mật và khôi phục dịch vụ.
6. **Thông báo:** đánh giá nghĩa vụ thông báo theo pháp luật và chính sách; không trì hoãn khi có nghĩa vụ bắt buộc.
7. **Khôi phục:** xác minh dữ liệu, quyền và tính toàn vẹn.
8. **Rút kinh nghiệm:** lập báo cáo, hành động phòng ngừa, chủ sở hữu và thời hạn.

### 17.2 Nội dung đánh giá

Tối thiểu xem xét:
- dữ liệu và cá nhân có thể bị ảnh hưởng;
- loại hành động: đọc, sao chép, sửa, xóa hoặc gián đoạn;
- thời gian bắt đầu/kết thúc ước tính;
- tài khoản, hệ thống, nhà cung cấp liên quan;
- dữ liệu có được mã hóa hay không và khả năng sử dụng của bên không được phép;
- hành động khoanh vùng, bằng chứng và quyết định thông báo;
- rủi ro tái diễn và biện pháp khắc phục.

### 17.3 Trách nhiệm

Tổ chức MUST chỉ định đầu mối điều phối sự cố. Thời hạn thông báo cụ thể phải được xác định theo pháp luật áp dụng và kế hoạch ứng phó; tài liệu này không tự đặt một thời hạn pháp lý chung. Mọi quyết định không thông báo khi có nghi vấn ảnh hưởng dữ liệu cá nhân phải có căn cứ và người chịu trách nhiệm ghi nhận.

## 18. Yêu cầu và quyền của chủ thể dữ liệu

Tổ chức MUST có một kênh tiếp nhận yêu cầu liên quan đến dữ liệu cá nhân, ví dụ yêu cầu truy cập, sửa, hạn chế, phản đối hoặc xóa khi quyền đó được pháp luật áp dụng quy định.

Quy trình SHOULD bao gồm:
1. tiếp nhận và cấp mã yêu cầu;
2. xác minh danh tính ở mức tương xứng, tránh thu thập thêm dữ liệu không cần thiết;
3. xác định dữ liệu, nguồn, hệ thống và bên xử lý liên quan;
4. đánh giá quyền của người yêu cầu và quyền/lợi ích của người khác;
5. xác định nghĩa vụ lưu trữ hoặc bảo toàn chứng cứ;
6. phê duyệt và thực hiện hành động phù hợp;
7. ghi nhận kết quả, giới hạn và lý do;
8. phản hồi theo thời hạn luật định hoặc chính sách được công bố;
9. xử lý khiếu nại hoặc yêu cầu xem xét lại.

Không được hứa đáp ứng một yêu cầu trước khi đánh giá quyền, nghĩa vụ và tính khả thi. Việc sửa thông tin nhận dạng sai không nhất thiết đồng nghĩa xóa toàn bộ nguồn gốc lịch sử; cần tách phần thông tin hiển thị, lịch sử và bản nguồn theo quy định.

## 19. Quản trị dữ liệu và giải quyết tranh chấp

### 19.1 Chính sách và người chịu trách nhiệm

Mỗi tổ chức áp dụng TFD-401 MUST có chính sách bằng văn bản bao gồm:
- mục đích và phạm vi xử lý;
- phân loại dữ liệu;
- vai trò và cơ chế phê duyệt;
- quyền truy cập, chia sẻ và công bố;
- lưu giữ, sao lưu, phục hồi và hủy;
- tiếp nhận yêu cầu của chủ thể dữ liệu;
- ứng phó sự cố;
- rà soát và kiểm tra tuân thủ.

### 19.2 Tranh chấp nội dung gia phả

Quyền quản trị kỹ thuật không tự quyết định tranh chấp về huyết thống, dòng phả hệ, danh xưng, tính xác thực hoặc kết luận lịch sử. Tranh chấp nội dung phải xử lý theo quy trình chuyên môn tương ứng TFD-201, TFD-301 và quy chế được phê duyệt.

Khi có yêu cầu che hoặc gỡ nội dung vì nguy cơ an toàn hoặc quyền riêng tư, tổ chức có thể áp dụng biện pháp tạm thời, có thời hạn và ghi nhận lý do, trong khi xem xét nội dung. Biện pháp tạm thời không được trình bày như kết luận lịch sử cuối cùng.

### 19.3 Quản lý thay đổi chính sách

Thay đổi chính sách phải có:
- phiên bản và ngày hiệu lực;
- nội dung thay đổi và lý do;
- người phê duyệt;
- đánh giá tác động đến quyền đã cấp, dữ liệu đã công bố và tích hợp;
- kế hoạch thông báo và chuyển đổi;
- phương án quay lui khi thay đổi gây sự cố.

## 20. Nhà cung cấp và bên xử lý dữ liệu

Trước khi sử dụng dịch vụ lưu trữ, OCR, AI, phân tích, gửi email, sao lưu hoặc chia sẻ tệp, tổ chức SHOULD đánh giá:
- loại dữ liệu được gửi;
- mục đích xử lý và việc dùng dữ liệu để huấn luyện hoặc mục đích thứ cấp;
- nơi lưu trữ và xử lý;
- nhân sự và nhà thầu phụ có thể truy cập;
- mã hóa, kiểm soát truy cập và nhật ký;
- thời hạn lưu và quy trình xóa;
- thông báo và hỗ trợ khi có sự cố;
- khả năng xuất dữ liệu và chấm dứt dịch vụ;
- điều khoản hợp đồng, chuyển dữ liệu xuyên biên giới và nghĩa vụ pháp lý áp dụng.

Không được gửi dữ liệu nhạy cảm đến dịch vụ bên ngoài chỉ vì dịch vụ có tính năng phù hợp. Phải có căn cứ xử lý, quyền phê duyệt và cấu hình tối thiểu cần thiết. Khi sử dụng AI để OCR, phiên âm, dịch hoặc gợi ý quan hệ, đầu ra phải được xem là kết quả cần kiểm tra, không phải bằng chứng xác nhận tự động; xem TFD-301.

## 21. Kiểm tra tuân thủ và tiêu chí nghiệm thu

Một triển khai tuyên bố phù hợp TFD-401 SHOULD chứng minh được:
- ma trận vai trò/quyền và quy trình cấp/thu hồi;
- phân loại dữ liệu cùng cấu hình mặc định riêng tư;
- kiểm tra quyền ở máy chủ và chống truy cập ngang đối tượng;
- kiểm soát xác thực, phiên và tài khoản đặc quyền;
- bảo vệ dữ liệu lưu trữ/truyền tải và quản lý bí mật;
- quy trình công bố, xuất và chia sẻ;
- nhật ký bảo mật được bảo vệ;
- chính sách lưu giữ, xóa, sao lưu và khôi phục;
- kênh yêu cầu của chủ thể dữ liệu;
- quy trình ứng phó sự cố;
- đánh giá nhà cung cấp/tích hợp;
- kết quả kiểm thử và các ngoại lệ đã được chấp nhận.

### 21.1 Quy tắc kiểm tra đề xuất

- **SEC-001:** Không có quyền được cấp thì truy cập phải bị từ chối.
- **SEC-002:** Thay ID tài nguyên không cho phép xem hồ sơ ngoài phạm vi.
- **SEC-003:** Quyền xem không tự động cho phép sửa, tải xuống hoặc xuất.
- **SEC-004:** Hồ sơ mới có dữ liệu người còn sống phải ở mức hạn chế mặc định.
- **SEC-005:** Công bố dữ liệu hạn chế phải có phê duyệt và nhật ký.
- **SEC-006:** Thu hồi quyền phải vô hiệu hóa quyền truy cập liên quan theo chính sách.
- **SEC-007:** Nhật ký không chứa mật khẩu, token hoặc bí mật.
- **SEC-008:** Tài khoản đặc quyền được kiểm kê và bảo vệ tăng cường.
- **SEC-009:** Xuất dữ liệu phải áp dụng kiểm soát quyền và cảnh báo mất thông tin.
- **SEC-010:** Tệp tải lên không được tin cậy chỉ dựa vào tên/loại do người dùng khai báo.
- **SEC-011:** Dữ liệu thử nghiệm không làm lộ dữ liệu thật ngoài quy trình được duyệt.
- **SEC-012:** Sao lưu có thể phục hồi và được bảo vệ khỏi truy cập trái phép.
- **SEC-013:** Khôi phục không làm sống lại quyền hoặc dữ liệu đã bị thu hồi/xóa mà không xử lý lại.
- **SEC-014:** Yêu cầu của chủ thể dữ liệu có mã theo dõi, kết quả và lý do.
- **SEC-015:** Sự cố có hồ sơ phân loại, khoanh vùng, khắc phục và rút kinh nghiệm.
- **SEC-016:** Quyền quản trị không cho phép âm thầm sửa lịch sử hoặc chứng cứ.
- **SEC-017:** Liên kết chia sẻ có phạm vi và cơ chế hết hạn/thu hồi phù hợp.
- **SEC-018:** Dữ liệu gửi cho bên thứ ba bị giới hạn theo mục đích.
- **SEC-019:** Thay đổi chính sách quyền có phiên bản, người phê duyệt và ngày hiệu lực.
- **SEC-020:** Các ngoại lệ bảo mật có người chấp nhận, biện pháp bù trừ và ngày rà soát.

### 21.2 Ca kiểm thử nghiệm thu

| Mã | Tình huống | Kết quả mong đợi |
|---|---|---|
| TC-401-01 | Khách chưa đăng nhập truy cập hồ sơ hạn chế | Bị từ chối; không tiết lộ nội dung |
| TC-401-02 | Người dùng thay ID hồ sơ trong API | Bị từ chối nếu hồ sơ ngoài phạm vi |
| TC-401-03 | Researcher có quyền xem nhưng không có quyền xuất | Không thể xuất qua UI hoặc API |
| TC-401-04 | Hồ sơ mới chứa ngày sinh và liên hệ người còn sống | Mặc định hạn chế |
| TC-401-05 | Editor tự công bố hồ sơ khi không có quyền publish | Bị từ chối và ghi nhận theo chính sách |
| TC-401-06 | Admin kỹ thuật mở hồ sơ nội dung không thuộc nhiệm vụ | Không được cấp quyền nội dung chỉ từ vai trò kỹ thuật |
| TC-401-07 | Thu hồi quyền người dùng đang có phiên hoạt động | Quyền bị vô hiệu hóa trong giới hạn chính sách |
| TC-401-08 | Tìm mật khẩu/token trong log | Không có bí mật xác thực bị ghi |
| TC-401-09 | Tải tệp có phần mở rộng giả mạo | Tệp được kiểm tra/cách ly hoặc từ chối |
| TC-401-10 | Tạo liên kết chia sẻ dữ liệu hạn chế | Có phạm vi, thời hạn hoặc cơ chế thu hồi và nhật ký |
| TC-401-11 | Xuất GEDCOM không hỗ trợ một số metadata bảo vệ | Có cảnh báo/manifest theo thiết kế TFD-501 |
| TC-401-12 | Khôi phục bản sao lưu sau khi quyền đã bị thu hồi | Quyền bị thu hồi không được khôi phục ngoài ý muốn |
| TC-401-13 | Người dùng yêu cầu sửa dữ liệu cá nhân | Yêu cầu được theo dõi, đánh giá và phản hồi theo quy trình |
| TC-401-14 | Nghi ngờ lộ dữ liệu từ nhà cung cấp | Có quy trình tiếp nhận, đánh giá, khoanh vùng và quyết định thông báo |
| TC-401-15 | Quản trị viên sửa một kết luận đã được ghi nhận | Có lịch sử và dấu vết phù hợp; không xóa âm thầm |
| TC-401-16 | Tài khoản dịch vụ gọi API vượt phạm vi | Bị từ chối và ghi nhận |
| TC-401-17 | Dữ liệu người đã mất có liên hệ riêng của thân nhân còn sống | Phần dữ liệu liên quan người còn sống vẫn được hạn chế |
| TC-401-18 | Xóa dữ liệu khỏi hệ thống hoạt động nhưng còn trong backup | Áp dụng chính sách hết hạn và ngăn phục hồi không kiểm soát |
| TC-401-19 | Thay đổi ma trận quyền trong sản xuất | Có phê duyệt, phiên bản và khả năng truy nguyên |
| TC-401-20 | Thực hiện quyền khẩn cấp | Có lý do, phạm vi, thời hạn và hậu kiểm |

### 21.3 Tiêu chí đạt

Một ca kiểm thử được coi là đạt khi kết quả thực tế đáp ứng kết quả mong đợi, có bằng chứng kiểm thử và không dựa vào thao tác thủ công không được ghi nhận. Các trường hợp không áp dụng phải có lý do. Mọi lỗi nghiêm trọng liên quan truy cập trái phép, công bố sai phạm vi hoặc mất khả năng truy nguyên phải được xử lý trước khi tuyên bố phù hợp.

## 22. Các quyết định cần chốt trước TFD-401 v1.0

Các điểm sau được giữ mở, không tự động coi là quyết định đã được phê duyệt:

1. **Chủ thể quản trị:** ai là Governance Owner trong mô hình một dòng họ, nhiều chi phái hoặc nền tảng đa tổ chức?
2. **Phân loại chuẩn:** có chốt bốn mức P0–P3 hay dùng một hệ phân loại khác?
3. **Vai trò chuẩn:** danh mục vai trò nào là lõi bắt buộc; vai trò nào là tùy chọn?
4. **Ma trận quyền:** hành động nào cần phê duyệt hai người; trường hợp nào cho phép kiêm nhiệm?
5. **Dữ liệu người còn sống:** chính sách mặc định cụ thể cho ngày sinh, ảnh, quan hệ và thông tin liên hệ?
6. **Trạng thái sống:** dùng các giá trị nào, ai được thay đổi và cần chứng cứ gì?
7. **Căn cứ công bố:** mô hình phê duyệt, đồng ý, ủy quyền và xử lý rút lại quyền công bố?
8. **Thời hạn lưu giữ:** thời hạn cụ thể theo từng loại hồ sơ, nhật ký và bản xuất?
9. **Nhật ký:** danh mục sự kiện bắt buộc, thời hạn lưu và ai được đọc?
10. **Xuất dữ liệu:** có bắt buộc manifest bảo mật và báo cáo mất thông tin cho mọi định dạng?
11. **Sao lưu:** giá trị RPO/RTO tối thiểu cho các cấp hệ thống nào?
12. **Quyền khẩn cấp:** điều kiện kích hoạt, thời hạn, người phê duyệt/hậu kiểm?
13. **Yêu cầu của chủ thể dữ liệu:** đầu mối, quy trình xác minh và thời hạn phản hồi theo từng khu vực pháp lý?
14. **Nhà cung cấp:** yêu cầu tối thiểu về vị trí dữ liệu, nhà thầu phụ và dùng dữ liệu để huấn luyện?
15. **Tuân thủ pháp luật:** ai chịu trách nhiệm đánh giá nghĩa vụ pháp lý hiện hành tại nơi vận hành?
16. **Kiểm thử:** SEC-001…SEC-020 và TC-401-01…TC-401-20 là bắt buộc toàn bộ hay chia mức cơ bản/nâng cao?

## 23. Quan hệ với các tài liệu TFD khác

| Tài liệu | Mối quan hệ |
|---|---|
| TFD-001 | Nguyên tắc chung, quyền riêng tư, khả năng truy nguyên và kiểm thử |
| TFD-101 | Thực thể, quan hệ, lịch sử và liên kết dữ liệu |
| TFD-102 | Định danh và loại quan hệ; quyền không được suy ra chỉ từ quan hệ gia đình |
| TFD-103 | Sự kiện, nguồn, chứng cứ, nhận định, kết luận và tính bất định |
| TFD-201 | Quy tắc dòng họ/chi phái/thế hệ; không thay thế phân quyền kỹ thuật |
| TFD-301 | Quy trình nguồn, chứng cứ, dị bản; TFD-401 quy định ai được truy cập và thao tác |
| TFD-501 | Nhập/xuất, GEDCOM, cảnh báo mất metadata và kiểm soát dữ liệu xuất |
| TFD-601 | Bộ kiểm thử tổng hợp và tiêu chí nghiệm thu toàn bộ TFD |

## Phụ lục A — Ví dụ áp dụng

### A.1 Hồ sơ người còn sống trong cây gia phả công khai

**Tình huống:** Một cây gia phả đã được công bố có tên, năm sinh và quan hệ của nhiều thế hệ; người biên tập bổ sung số điện thoại và địa chỉ hiện tại của một thành viên còn sống.

**Cách xử lý theo dự thảo:**
1. Phân loại thông tin liên hệ ở mức hạn chế.
2. Không đưa thông tin liên hệ vào bản công khai chỉ vì cây gia phả đang công khai.
3. Tách trường riêng tư khỏi bản hiển thị công khai nếu kiến trúc cho phép.
4. Ghi nhận người đề xuất và phê duyệt nếu cần công bố ngoại lệ.
5. Kiểm tra bản xuất, API và bộ nhớ đệm để tránh rò rỉ ngoài giao diện chính.

### A.2 Tranh chấp về quan hệ cha-con

**Tình huống:** Hai nguồn đưa ra thông tin không thống nhất về quan hệ cha-con.

**Cách xử lý theo dự thảo:**
1. Không xóa nguồn bất đồng để làm cho cây hiển thị thống nhất.
2. Bảo vệ nguồn và nhận định theo TFD-301.
3. Chỉ người được phân quyền mới có thể sửa hoặc duyệt kết luận.
4. Nếu có nguy cơ xâm phạm quyền riêng tư, có thể hạn chế công bố trong khi vẫn bảo toàn bản lưu trữ.
5. Nhật ký phải cho phép truy nguyên thay đổi kết luận và phạm vi công bố.

### A.3 Nhà nghiên cứu yêu cầu xuất dữ liệu

**Tình huống:** Nhà nghiên cứu được phép đọc một dòng họ muốn xuất toàn bộ dữ liệu để phân tích.

**Cách xử lý theo dự thảo:**
1. Kiểm tra quyền xuất riêng biệt với quyền xem.
2. Xác định mục đích, phạm vi và trường dữ liệu cần thiết.
3. Loại bỏ hoặc giảm chi tiết dữ liệu người còn sống khi phù hợp.
4. Nêu các trường/quan hệ/metadata không thể biểu diễn trong định dạng đích.
5. Ghi nhận phê duyệt, tác nhân, thời điểm, phạm vi và kết quả xuất.

### A.4 Yêu cầu xóa thông tin liên hệ

**Tình huống:** Một người yêu cầu gỡ số điện thoại của họ khỏi hồ sơ gia phả.

**Cách xử lý theo dự thảo:**
1. Xác minh người yêu cầu ở mức tương xứng.
2. Xác định các bản ghi và bản xuất do tổ chức kiểm soát có chứa thông tin.
3. Đánh giá căn cứ xử lý và nghĩa vụ lưu giữ.
4. Gỡ hoặc hạn chế trường liên hệ theo kết quả đánh giá; không tự động xóa toàn bộ hồ sơ gia phả.
5. Ghi nhận kết quả, phạm vi đã xử lý và các bản sao lưu còn trong thời hạn hết hiệu lực.

## Phụ lục B — Hồ sơ tối thiểu cần có để vận hành

Một tổ chức triển khai TFD-401 SHOULD duy trì các hồ sơ sau:

- Chính sách bảo mật và quyền riêng tư.
- Danh mục tài sản dữ liệu và luồng dữ liệu.
- Bảng phân loại dữ liệu và ánh xạ biện pháp bảo vệ.
- Ma trận vai trò/quyền và danh sách người được cấp quyền.
- Hồ sơ phê duyệt công bố, xuất dữ liệu và quyền khẩn cấp.
- Danh mục nhà cung cấp/tích hợp và đánh giá rủi ro.
- Chính sách lưu giữ, sao lưu, phục hồi và hủy.
- Kế hoạch ứng phó sự cố và sổ ghi nhận sự cố.
- Nhật ký yêu cầu của chủ thể dữ liệu.
- Kết quả kiểm thử bảo mật, ngoại lệ và kế hoạch khắc phục.

## Phụ lục C — Mẫu ghi nhận ngoại lệ bảo mật

| Trường | Nội dung cần ghi |
|---|---|
| Mã ngoại lệ | Mã duy nhất |
| Yêu cầu liên quan | Điều khoản SEC/TC bị ảnh hưởng |
| Phạm vi | Hệ thống, dữ liệu, vai trò và môi trường |
| Lý do | Vì sao không thể đáp ứng yêu cầu chuẩn |
| Rủi ro | Nguy cơ và hậu quả dự kiến |
| Biện pháp bù trừ | Kiểm soát thay thế |
| Người chấp nhận | Người có thẩm quyền theo chính sách |
| Ngày bắt đầu/hết hạn | Thời gian ngoại lệ được phép |
| Kế hoạch khắc phục | Công việc, người phụ trách, hạn hoàn thành |
| Rà soát | Kết quả rà soát và quyết định gia hạn/đóng |

## Phụ lục D — Mẫu sổ theo dõi sự cố

| Trường | Nội dung cần ghi |
|---|---|
| Mã sự cố | Mã duy nhất |
| Thời điểm phát hiện | Ngày/giờ và múi giờ |
| Người tiếp nhận | Cá nhân/nhóm |
| Loại sự cố | Truy cập, tiết lộ, sửa đổi, mất dữ liệu, gián đoạn hoặc khác |
| Dữ liệu/phạm vi ảnh hưởng | Phân loại, hệ thống và nhóm cá nhân |
| Mức độ | Theo thang đánh giá nội bộ |
| Hành động tức thời | Khoanh vùng, thu hồi quyền, bảo toàn log |
| Thông báo | Nghĩa vụ, quyết định, thời điểm và người phê duyệt |
| Khắc phục | Nguyên nhân, biện pháp, chủ sở hữu và thời hạn |
| Kết thúc | Điều kiện đóng, kiểm tra sau khôi phục |
| Bài học | Thay đổi cần thực hiện để ngăn tái diễn |

## Phụ lục E — Tài liệu tham khảo và giới hạn

Khi hoàn thiện v1.0, nhóm quản trị TFD SHOULD đối chiếu phiên bản hiện hành của:
- quy định pháp luật về bảo vệ dữ liệu cá nhân và an ninh mạng tại khu vực vận hành;
- tiêu chuẩn quản lý an toàn thông tin và hướng dẫn kiểm soát truy cập;
- hướng dẫn thực hành về xác thực, quản lý phiên, ghi nhật ký, sao lưu và ứng phó sự cố;
- điều khoản của nhà cung cấp hạ tầng và dịch vụ xử lý dữ liệu đang sử dụng.

Danh mục này chỉ xác định nhóm nguồn cần rà soát, không khẳng định rằng dự thảo đã đáp ứng mọi nghĩa vụ pháp luật hoặc được chứng nhận theo bất kỳ tiêu chuẩn bên ngoài nào. Các trích dẫn pháp lý và phiên bản tiêu chuẩn cụ thể phải được kiểm chứng trước khi ban hành chính thức.

---

## Tuyên bố trạng thái dự thảo

TFD-401 v0.1 là bản dự thảo đầy đủ để rà soát, thử nghiệm và đối chiếu với kiến trúc thực tế. Mọi mã quyền, phân loại, thời hạn lưu giữ và ma trận vai trò trong tài liệu cần được xác nhận trong quá trình chốt v1.0. Không được diễn giải sự hiện diện của một yêu cầu trong bản dự thảo là bằng chứng rằng một hệ thống cụ thể đã thực hiện hoặc đạt yêu cầu đó.
