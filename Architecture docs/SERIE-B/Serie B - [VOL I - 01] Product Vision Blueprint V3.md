VOLUME I: PRODUCT FOUNDATION
[VOL I - 01] PRODUCT VISION BLUEPRINT (REVISED V3)
Trạng thái: Baseline Approved | Phiên bản: V3.0 (Refactored via Peer Reviews)
Hệ thống: Web App Quản lý Dòng họ (Clan Management Platform)
Cấu trúc thực thi: Unified 8-Section Blueprint Contract (Vision-Oriented)
1. PURPOSE (MỤC ĐÍCH & SỨ MỆNH)
Trong bối cảnh xã hội hiện đại đối mặt với xu hướng dịch chuyển toàn cầu (ly hương) và sự đứt gãy kết nối thông tin giữa các thế hệ, Clan Management Platform được xây dựng nhằm thiết lập một hạ tầng số trường tồn cho các dòng tộc Việt Nam. Mục đích cốt lõi của sản phẩm là bảo tồn sinh mệnh dữ liệu gia tộc, số hóa toàn vẹn mối quan hệ huyết thống, và cung cấp một kênh vận hành tộc sự tập trung, minh bạch, giúp kết nối con cháu muôn phương về lại với gốc rễ nguồn cội.
Product Mission (Sứ mệnh sản phẩm): Dữ liệu gia tộc là tài sản tinh thần vô giá cần được số hóa, bảo vệ và lưu giữ trường tồn qua hàng chục, hàng trăm năm.
2. PRIMARY DESIGN QUESTION (CÂU HỎI THIẾT KẾ CỐT LÕI)
"Làm thế nào để kiến trúc một hệ thống quản lý dữ liệu phả hệ vừa đảm bảo tính toàn vẹn luận lý nghiêm ngặt của mô hình đồ thị huyết thống phức tạp qua nhiều thế kỷ, vừa cung cấp giao thức tương tác siêu tối giản, thân thiện cho cả người cao tuổi (Trưởng lão nhập liệu) lẫn người trẻ (Gen Z/Alpha tra cứu)?"
3. SCOPE (TRONG PHẠM VI)
Hệ thống giới hạn và tập trung thực thi các nhóm năng lực nghiệp vụ khái niệm sau:
Biểu diễn và Tương tác Phả hệ: Hiển thị, điều hướng và tương tác trực quan cấu trúc cây phả hệ động đa tầng, đa nhánh theo thời gian thực.
Số hóa Hồ sơ & Tư liệu: Lưu trữ hồ sơ sinh học cá nhân, biên niên sử, hình ảnh, video tư liệu và các bản quét văn bản gia phả cổ.
Điều phối Sự kiện & Lịch Gia tộc: Hệ thống tự động chuyển đổi và đồng bộ lịch Âm - Dương chuyên biệt để nhắc lịch giỗ chạp, quản lý trạng thái chuẩn bị nghi lễ dòng họ.
Minh bạch Tài chính (Ledger): Quản lý thu chi các quỹ dòng họ (Khuyến học, xây dựng, hành chính) trên nguyên tắc ghi chép kế toán minh bạch, chống tẩy xóa.
Giao tiếp Trợ lý ảo (Elder Support): Tích hợp tương tác tự nhiên phục vụ đối tượng người lớn tuổi ít rành công nghệ.
4. OUT OF SCOPE (NGOÀI PHẠM VI)
Để ngăn chặn rủi ro phình to tính năng (Scope Creep) và bảo vệ an toàn thông tin, hệ thống loại trừ tuyệt đối:
Không xây dựng các tính năng tương tác mạng xã hội đại chúng (không có bảng tin công khai ngoài dòng họ, không kết bạn tự do).
Không tích hợp trực tiếp cổng thanh toán trực tuyến hoặc ví điện tử vào nhân hệ thống (quy trình tài chính chỉ dừng ở đối soát bằng chứng chuyển khoản).
Không thương mại hóa dữ liệu dưới mọi hình thức; không đặt quảng cáo hoặc khai thác thông tin cá nhân vì mục đích bên ngoài dòng tộc.
5. RELATED DOCUMENTS (TÀI LIỆU LIÊN QUAN)
Là tài liệu định hướng chiến lược thượng tầng, sản phẩm của tài liệu này thiết lập các ràng buộc logic trực tiếp xuống cấu trúc của các tài liệu kỹ thuật và vận hành phía sau:
Ràng buộc triết lý vận hành tộc vụ sang [VOL I - 02] Business Doctrine Blueprint.
Đẩy các đặc tả trạng thái hệ thống (State Machine, Schema định danh UUID/SHA256) xuống [VOL I - 03] Product Architecture và [VOL III - 11] Data & Storage Specification.
6. BLUEPRINT (BẢN VẼ TẦM NHÌN KHÁI NIỆM)
Sản phẩm vận hành dựa trên dòng dịch chuyển giá trị cốt lõi từ thực thể truyền thống lên không gian lưu trữ trường tồn thông qua 5 trụ cột chiến lược:
Trụ cột giá trị
Nguyên tắc thực thi khái niệm
 
1. Dòng họ Truyền thống
Tiếp nhận cốt cách văn hóa, tộc ước, và cấu trúc cây gia tộc hiện hữu làm gốc rễ dữ liệu. Mỗi dòng họ trên hệ thống sở hữu một định danh duy nhất và một bộ Tộc ước số được quản trị tập trung bởi Hội đồng Gia tộc.
2. Số hóa Phả hệ & Tư liệu
Chuyển đổi toàn bộ dữ liệu vật lý (sách giấy, ảnh cũ, sớ cổ) thành các thực thể số có cấu trúc luận lý mạch lạc, phân tách rõ ràng đường biên dữ liệu theo mô hình đồ thị hướng không chu trình (DAG).
3. Kết nối Thế hệ
Xóa bỏ ranh giới địa lý. Cung cấp cơ chế tương tác thời gian thực giúp con cháu ly hương, thế hệ trẻ (Gen Z/Alpha) dễ dàng tra cứu gốc gác, vai vế và tương tác với cội nguồn.
4. Vận hành Minh bạch
Thiết lập công cụ ghi nhận tài chính và sự kiện bất biến, loại bỏ hoàn toàn rủi ro sai sót thông tin hoặc thiếu minh bạch trong công tác quản lý tộc sự.
5. Lưu giữ Trường tồn
Đảm bảo tính sống sót của dữ liệu. Cấu trúc đóng gói tệp dữ liệu phải độc lập hoàn toàn với công nghệ giao diện, sẵn sàng cho việc đọc và kế thừa sau nhiều thập kỷ.
7. IMPLEMENTATION NOTES (HƯỚNG DẪN NGUYÊN TẮC)
Nguyên tắc tiếp cận cho người lớn tuổi (Accessibility): Hệ thống phải cung cấp một luồng giao diện đơn giản hóa tối đa, triệt tiêu sự phức tạp của việc gõ phím. Ưu tiên tương tác tự nhiên (giọng nói) và hiển thị thông tin trực quan cô đọng. (Chi tiết kỹ thuật về Voice Agent và UX được đẩy xuống tài liệu [VOL II - 08] AI & Elder Support Domain).
Nguyên tắc bảo toàn dữ liệu dài hạn: Toàn bộ kiến trúc lưu trữ phải hướng tới tính kế thừa tĩnh, dữ liệu phả hệ cốt lõi có khả năng trích xuất ra các định dạng mở, phổ quát để thế hệ tương lai luôn có thể đọc được ngay cả khi hạ tầng đám mây hiện tại thay đổi. (Chi tiết kỹ thuật về phân tầng Cold Storage/WORM được đẩy xuống tài liệu [VOL IV - 12] Deployment & Operations Guide).
8. SUCCESS CRITERIA (TIÊU CHÍ THÀNH CÔNG)
Hệ thống được coi là đạt mục tiêu thiết kế thượng tầng khi thỏa mãn hai chỉ số kiểm định (KPI kiến trúc) sau:
KPI 1 (Năng lực số hóa): Một dòng họ thông thường có thể hoàn thành số hóa, dựng khung cây phả hệ tối thiểu 3 thế hệ liên tục trong vòng 1 ngày làm việc.
KPI 2 (Năng lực tiếp cận): Một thành viên lớn tuổi (trên 70 tuổi) có thể tự tra cứu chính xác tên, mộ phần, hoặc ngày giỗ của một cụ tổ trong lịch sử dòng họ bằng giọng nói mà không cần đến sự hỗ trợ kỹ thuật từ người trẻ.
[KẾT THÚC TÀI LIỆU VOL I - 01 V3. BASELINE APPROVED]