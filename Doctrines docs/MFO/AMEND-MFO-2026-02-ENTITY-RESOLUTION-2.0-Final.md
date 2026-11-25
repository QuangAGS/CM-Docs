# **AMEND-MFO-2026-02-ENTITY-RESOLUTION**

 

**Phiên bản:** 2.0 (Final Release \- Approved for Phase 1\)  
 **Ngày:** 2026-11-25  
 **Trạng thái:** CHÍNH THỨC BAN HÀNH (APPROVED FOR PHASE 1\)  
 **Mã tài liệu:** AMEND-MFO-2026-02

 

**Tài liệu quy chiếu:**

●  	AMEND-MFO-2026-01-CANVAS-LINK-EXISTING (v5.4 Final Frozen)

●  	TFD-CORE-APPROVAL-1.0.0

●  	FTDI-PRACTICAL-SPEC-1.0.4-Final

●  	MYCLAN-FTD-GAP-REPORT-1.2.0-FINAL

##   **Ghi chú:** **1\. Vì sao v2.0 này là Phase 1?**

Phase 1 tập trung vào **“động cơ”** — khả năng hợp nhất an toàn khi đã biết hai bản ghi là một người.

| Lý do | Giải thích |
| ----- | ----- |
| Ưu tiên vận hành sớm | Ngay khi triển khai AMEND-MFO-2026-01, Admin và EU sẽ gặp trường hợp trùng khi duyệt cây nhỏ. Cần công cụ gộp chuẩn xác ngay, không thể chờ hệ thống tìm kiếm tự động. |
| Tách biệt rủi ro | Lớp ghi dữ liệu (transaction, lock, dual-write, cycle detection) khác hoàn toàn với lớp tìm kiếm và chấm điểm. Tách pha giúp kiểm soát rủi ro tốt hơn. |
| Phụ thuộc schema chưa sẵn sàng | Các thực thể sâu như Event độc lập và GenerationAssignment chưa hoàn thiện. Phase 1 chấp nhận giải pháp tạm thời (lưu dị bản vào note/evidence\_links). |
| Phạm vi kiểm soát được | Giới hạn re-wiring ở tầng trực hệ, có Wizard thủ công, có checklist rollback. Đủ an toàn để đưa vào vận hành. |

**2\. Phase 2 là gì?**

Phase 2 giải quyết bài toán **“radar \+ phân xử”** khi quy mô lớn:

| Hạng mục | Phase 1 (v2.0) | Phase 2 |
| ----- | ----- | ----- |
| Phát hiện trùng | Thủ công (Admin/EU tự nhận ra) | Automated Duplicate Scoring Engine (gợi ý tự động khi gõ tên) |
| Phân xử tranh chấp | Chỉ ghi nhận DISPUTED | UI cho Hội đồng đối chiếu citation và cấu hình SelectionPolicy |
| Sự kiện & Đời | Lưu tạm | Chuẩn hóa bảng events và generation\_assignments |
| Gộp nhiều tầng | Xử lý từng cặp | Guided Batch Sub-tree Merge |

### **3\. Khi nào nên làm Phase 2?**

Nên kích hoạt khi hội tụ đủ các điều kiện sau:

1. Kỹ thuật: AMEND-MFO-2026-01 và 2026-02 đã ổn định trên production. Primary Tree chạy trên parentages. Đã có migration cho events và selection\_policies.

2. Quy mô dữ liệu: Có tenant vượt khoảng 300–500 thành viên trải nhiều chi.

3. Tồn đọng tranh chấp: Số lượng parentages ở trạng thái DISPUTED hoặc UNRESOLVED\_CONFLICT bắt đầu tăng, cần giao diện phân xử chính thức.

**4\. Phác thảo cho bắt đầu cho Phase 2:**   
	Tài liệu: AMEND-MFO-2026-03-AUTOMATED-SCORING-V1.1.md

---

#  **Nội dung chính của tài liệu**

 

## **MFO-ER-00. Business Context & Vấn đề**

 

### **MFO-ER-00.1 Bối cảnh phát sinh**

Trong gia phả Việt Nam, việc nhiều thành viên ở các chi/nhánh khác nhau cùng nhập liệu dễ dẫn đến tình trạng **một cá nhân thực tế tồn tại dưới 2 bản ghi members độc lập**.  
 Ví dụ: Chị A ở Chi 1 khai "Bà nội Lan", anh B ở Chi 2 khai "Cố bà Lan". Khi xác định hai người này là một, hệ thống cần cơ chế hợp nhất để tránh phân mảnh dữ liệu.

 

### **MFO-ER-00.2 Khác biệt với MERGE\_NODE (AMEND-MFO-2026-01)**

●  	MERGE\_NODE: Gộp **nút gốc** của một cây nháp vào điểm neo.

●  	Entity Resolution: Gộp **hai bản ghi đã có hệ sinh thái riêng** (đã có cha mẹ, vợ/chồng, con cái, sự kiện vệ tinh). Phức tạp và rủi ro cao hơn nhiều.

 

 

 

## **MFO-ER-01. Phân loại 4 Kịch bản Nghiệp vụ**

 

Tuân thủ TFD/FTDI, hệ thống phân loại và xử lý 4 kịch bản như sau:

 

| Mã | Kịch bản | Mô tả thực tế | Cách xử lý trên đồ thị |
| :---- | :---- | :---- | :---- |
| **ER-S1** | **Hôn nhân nội tộc** | Nữ ở Chi 1 là vợ ông nam ở Chi 2\. | Gộp 1 member; giữ cả 2 vai trò. Hiển thị Đa vị trí (Multiple Occurrences). |
| **ER-S2** | **Con đẻ / Con nuôi song song** | Là con đẻ Chi 1, con nuôi Chi 2\. | Gộp 1 member; giữ cả 2 parentages (khác relationship\_type). |
| **ER-S3** | **Trùng lặp thật (True Duplicate)** | Hai nhánh nhập trùng 1 cụ và trùng con cái. | Gộp 1 member; **Khử trùng lặp** (SUPERSEDED) các cạnh giống nhau. |
| **ER-S4** | **Tranh chấp (Disputed)** | Nhánh 1 khai cha A, Nhánh 2 khai cha B. | Gộp 1 member; giữ cả 2 parentages BIOLOGICAL ở trạng thái DISPUTED (P-14). |

   
 

 

 

## **MFO-ER-10. Quy tắc Sống sót (Survivor Selection) & Xử lý Trùng Account**

 

Khi hợp nhất, hệ thống chọn 1 bản ghi làm **X\_target** (sống sót) và đóng băng bản ghi **X\_source**.

 

### **Thứ tự ưu tiên**

1\. **Liên kết tài khoản (users.member\_id):** Bản ghi có tài khoản bắt buộc là X\_target.

○  	Lưu ý 2 tài khoản: Nếu cả hai đều đã gắn users khác nhau \-\> **Chặn gộp tự động**. Báo lỗi yêu cầu Admin chạy công cụ MERGE\_IDENTITY\_ACCOUNT ở phân hệ User trước, sau đó mới quay lại chạy gộp phả hệ.

2\. Bản ghi CHINH\_THUC thắng bản ghi nháp.

3\. Nếu ngang nhau: ưu tiên bản ghi có nhiều citations hoặc created\_at cũ hơn.

 

### **Đóng băng X\_source & Redirect Đệ quy**

●  	Không xóa cứng vật lý. Cập nhật deleted\_at \= NOW() và merged\_into\_id \= X\_target.id.

●  	Mọi API truy vấn vào X\_source (bao gồm API nội bộ, báo cáo, cron job) sẽ redirect hoặc trả thông báo chuyển hướng sang X\_target.

●  	**Lưu ý Implement (Redirect Đệ quy):** Middleware phải hỗ trợ phân giải đệ quy. Nếu A gộp vào B, sau đó B gộp vào C, truy vấn vào A phải resolve thẳng về bản ghi cuối cùng đang sống (C). Để tránh vòng lặp vô hạn do lỗi dữ liệu, giới hạn độ sâu đệ quy tối đa ở **5-10 cấp**.

 

 

 

## **MFO-ER-20. Thuật toán Chuyển hướng Cạnh & Vệ tinh (Edge Re-wiring)**

 

Giới hạn trong 1 Transaction: **chỉ re-wire tự động các quan hệ trực hệ**. Các tầng sâu hơn tự động bám theo.

 

### **MFO-ER-20.1 Ma trận xử lý Cạnh**

 

| Loại quan hệ | Tình huống đối chiếu với X\_target | Hành động Kỹ thuật |
| :---- | :---- | :---- |
| **Vợ/Chồng** | Chưa trùng | Chuyển spouse\_id sang X\_target. |
| **Vợ/Chồng** | Đã trùng người | Gộp 2 marriages; chuyển con về marriage giữ lại. |
| **Con** | Chưa có cha/mẹ tương ứng | Chuyển child\_id sang X\_target (ACCEPTED). |
| **Con** | Đã có cha/mẹ khác loại (VD: Nuôi) | Chuyển child\_id sang X\_target (ACCEPTED). |
| **Con (Sinh học)** | Đã có cha/mẹ BIOLOGICAL **trùng người** | **Deduplicate:** Đánh SUPERSEDED cạnh thừa, dồn citation. (Chặn lỗi Unique Constraint). |
| **Con (Sinh học)** | Đã có cha/mẹ BIOLOGICAL **khác người** | Chuyển child\_id sang X\_target (DISPUTED), cạnh gốc giữ ACCEPTED (bảo vệ Cây chính). |
| **Cha/Mẹ** | Có con trùng (do Admin map) | **Deduplicate:** Đánh SUPERSEDED cạnh thừa. (Service phải check tổ hợp parent\_id, child\_id trước khi update). |
| **Cha/Mẹ** | Các con không trùng | Chuyển parent\_id sang X\_target. |

   
 

### **MFO-ER-20.2 Di dời thực thể Vệ tinh (TFD-101)**

●  	**Tư cách Chi (lineage\_memberships):** Gộp về X\_target (khử trùng cùng chi, giữ song song khác chi).

●  	**Chứng cứ (evidence\_links):** Cập nhật target\_id \= X\_target.id.

●  	**Sự kiện & Tên (EventParticipant, Name):** Chuyển về X\_target. Nếu có sự kiện sinh/mất mâu thuẫn:

○  	Phase 1: Lưu tạm dị bản mâu thuẫn vào trường note của parentages đang xử lý hoặc bảng evidence\_links.

○  	Phase sau: Đổi thành review\_status \= DISPUTED kèm Citation (khi bảng Event hoàn thiện).

 

 

 

## **MFO-ER-30. Mid-Tree Merge & Vòng đời Cây nhỏ**

 

Khi nút trùng nằm ở giữa một cây nhỏ CHO\_GHEP:

1\. **Phần hạ lưu:** Gắn vào X\_target đi vào Cây chính. Bản ghi cây nhỏ cũ chuyển thành DA\_GHEP \-\> Giải phóng Quota 01 cây/user cho EU ban đầu.

2\. **Phần thượng lưu:** Cắt rời và sinh ra một **ID cây nhỏ mới**. Cây nhỏ mới này được gán Ownership cho Admin (Admin-owned draft) chờ thẩm định tiếp.

○  	Quyền sở hữu chéo (Cross-Ownership): Nếu X\_source đang nằm trong cây nháp của một EU khác, quyền sở hữu của EU đó trên cây nhỏ vẫn giữ nguyên, chỉ phần đồ thị bị gộp được điều hướng về Cây chính. Hệ thống ghi một System Log để Admin có cơ sở giải thích nếu EU thắc mắc. (Lưu ý: Có thể bổ sung gửi Notification nhẹ cho EU về sự thay đổi này).

○  	Lưu ý Admin Draft: Admin-owned draft không bị xóa ngầm sau 90 ngày. Việc dọn dẹp hàng loạt sẽ xử lý ở Phase 2\.

 

 

 

## **MFO-ER-40. Safety Guards & Bẫy Kỹ thuật**

 

1\. **Khóa A01 & Giới tính:** Không lấy dữ liệu X\_source đè lên trường gender, is\_alive, phone, email của X\_target.

○  	Guard GENDER\_MISMATCH: Chặn gộp nếu giới tính trái ngược (MALE vs FEMALE). Cho phép Admin override thủ công (override\_unknown\_gender: true) trên UI Wizard nếu một bên là UNKNOWN.

2\. **Khóa Đồng thời:** Bắt buộc dùng SELECT pg\_advisory\_xact\_lock(hashtext('topology:' \|\| tenant\_id)) \+ lock\_timeout \= '3s'.

3\. **Cycle Detection (Fail-Closed 2 lớp):**

○  	**Dry-Run:** Chạy DFS lúc Preview UI \-\> Disable nút Confirm nếu có vòng lặp.

○  	**Commit-Time:** Chạy DFS trong Transaction. Bắn lỗi CYCLE\_DETECTED hoặc VALIDATION\_INCOMPLETE (kèm log riêng biệt cho DevOps).

4\. **Dual-Write (Cutover G2):** Mọi thao tác đổi cha/mẹ phải gọi Service Mapper để cập nhật father\_id/mother\_id nhằm bảo vệ luồng OP cũ. Tuyệt đối không dùng Trigger Database cho việc này.

 

 

 

## **MFO-ER-50. Đặc tả UI Wizard & JSON Payload**

 

### **50.1 Luồng UI Wizard (Chỉ ClanAdmin)**

1\. **So sánh 2 cột** (Thôngত্তি, vợ chồng, con cái).

2\. **Ánh xạ thủ công:** Chọn vợ/chồng/con bị trùng để deduplicate.

3\. **Preview & Xác nhận:** Hệ thống chạy Dry-run DFS và hiển thị trước cây.

 

### **50.2 Tính Đời hiển thị & Xử lý Tranh chấp (Frontend Projection)**

●  	**Đời hiển thị:** Khi một người render ở nhiều vị trí, Frontend tự động tính đời hiển thị bằng Đời của node cha/mẹ tại nhánh đó \+ 1. Không ghi đè đời gốc (BIOLOGICAL) trong CSDL.

●  	**Che dấu Tranh chấp:** Frontend chỉ render tọa độ Canvas (Multiple Occurrences) dựa trên các cạnh có review\_status \= ACCEPTED \+ is\_selected\_for\_lineage \= true. Tuyệt đối ẩn các cạnh DISPUTED đối với người dùng phổ thông.

 

### **50.3 JSON Payload (RESOLVE\_DUPLICATE\_ENTITY)**

     	  
 	{	  
       "action": "RESOLVE\_DUPLICATE\_ENTITY",	  
       "target\_member\_id": "uuid-1",	  
       "source\_member\_id": "uuid-2",	  
       "override\_unknown\_gender": true,	  
       "spouse\_mappings": \[{"source\_marriage\_id": "uuid", "target\_marriage\_id": "uuid"}\],	  
       "child\_mappings": \[{"source\_parentage\_id": "uuid", "target\_parentage\_id": "uuid"}\],	  
       "upper\_tree\_action": "SPLIT\_TO\_ADMIN\_DRAFT"	  
 	}	  
      	

 

 

 

## **MFO-ER-60. Hướng dẫn Rollback & Xử lý sau gộp**

 

1\. **Job tính lại Đời (Post-merge trigger):** Ngay sau khi gộp thành công, hệ thống phải tự động kích hoạt background job tính lại đời cho các nhánh bị ảnh hưởng để đảm bảo dữ liệu hiển thị cập nhật tức thời.

2\. **Rollback thủ công (Không có 1-click):** Nếu gộp nhầm, Admin thực hiện 4 bước:

○  	Sửa DB/Admin Tool: deleted\_at \= NULL, merged\_into\_id \= NULL cho X\_source.

○  	Tra cứu ChangeLog của transaction gộp nhầm để lấy danh sách ID parentages/marriages bị chuyển hướng.

○  	Điều chỉnh lại parent\_id, child\_id, spouse\_id về lại X\_source.

○  	**Gọi Service Mapper** để đồng bộ lại father\_id/mother\_id cho OP cũ.

 

 

**Chữ ký duyệt Freeze Phase 1:** \[Tech Lead / Product Owner\]  
 **Ngày hiệu lực:** 2026-11-25

