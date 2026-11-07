# **TÀI LIỆU TỔNG KẾT VÀ NGHỆM THU PHASE 1: SOẠN THẢO VÀ QUẢN LÝ KHUNG NHÁP MFO 5 LỚP**

**MÃ TÀI LIỆU: SUM-EGAL-MFO-2026-PHASE1**

**PHIÊN BẢN: 1.0.0-FINAL-APPROVED**

**NGÀY NGHIỆM THU: 2026-10-07T08:40:00+07:00**

**TRẠNG THÁI: ĐÃ NGHIỆM THU & ĐÓNG BƯỚC (CLOSED)**

**ĐỐI TƯỢNG ÁP DỤNG: Ban Kiến trúc Hệ thống, Đội Backend Core, Đội Frontend, Đội Bảo trì & Kiểm thử**

## **I. TỔNG QUAN VÀ MỤC TIÊU PHASE 1**

**Phase 1 của Quy trình Nghiệp vụ MFO (Master Family Organization) tập trung giải quyết bài toán: Cho phép người dùng (End User) khởi tạo, dàn trang, bổ sung các mối quan hệ phả hệ (Hôn nhân, Con cái, Khuyết danh) trên Canvas đồ thị 5 Đời (0 đến 4\) một cách linh hoạt, an toàn tuyệt đối về mặt dữ liệu trước khi chính thức bấm Trình lên Quản trị viên (ADMIN).**

### **Mục tiêu đã đạt được:**

1. **Trải nghiệm Canvas trực quan (UX): Dựng khung React Flow 5L cách ly, cho phép thêm/hủy con, thêm/hủy cụm hôn phối, gán khuyết danh và căn chỉnh vị trí node mượt mà.**  
2. **Lưu trữ Lớp Đôi (Data Architecture): Bảo toàn \$100\\%\$ cả dữ liệu nghiệp vụ (canvas\_delta, lines) lẫn ảnh chụp trạng thái hiển thị (graph\_snapshot).**  
3. **An toàn Sổ cái & Audit (Compliance): Đảm bảo \$100\\%\$ các tác vụ tạo, sửa, xóa nháp đều đi qua Transaction, ghi Sổ cái BPL Append-Only và Snapshot Audit Log chuẩn Enum tiếng Việt.**  
4. **Kiểm soát Nghiệp vụ Đơn Luồng (Business Integrity): Khóa chống lặp (Active Proposal Lock), chặn User tạo nhiều khung rác trùng lặp khi đang có khung chưa hoàn tất.**

## **II. QUY TRÌNH NGHIỆP VỤ & LUỒNG TRUYỀN DỮ LIỆU (E2E FLOW)**

|  \[Khởi tạo Khung\] ──\> \[Thao tác Canvas & Active Form\] ──\> \[Lưu Nháp Tự Động / Chủ động\]        │                          │                                    │        ▼                          ▼                                    ▼ Nạp getFullMfoSet    Thêm con / Hôn phối / KD             Gửi POST /mfo/plans/draft (Hoặc getDraftPayload)   Cập nhật graph\_snapshot              Lưu DB proposals (DRAFT)        │                          │                                    │        └──────────────────────────┼────────────────────────────────────┘                                   ▼                     \[Màn hình Quản lý MyMfoPlans\]                           ├── Hiển thị Tóm tắt 2 Cột (mfoDiffEngine)                           ├── Cho phép "Xóa tờ đang soạn" (DELETE HTTP)                           └── Chặn "Tạo khung mới" nếu còn In-Flight Proposal  |
| :---- |

## **III. THỂ HIỆN TRÊN BACKEND (BACKEND IMPLEMENTATION)**

### **1\. Mô hình Dữ liệu Lớp Đôi (proposals)**

* **Trạng thái: status \= 'DRAFT'.**  
* **Payload Structure:**  
  * **lines: Mảng 5 ô dòng quy đổi theo mốc M.**  
  * **canvas\_delta: Chứa các danh sách biến đổi xin bổ sung (draft\_children, draft\_spouses, node\_positions\_x).**  
  * **graph\_snapshot: Ảnh chụp React Flow (Nodes, Edges, Viewport) phục vụ khôi phục Canvas \$100\\%\$ không bị biến dạng.**

**Dữ liệu bản nháp MFO lưu trong trường payload (JSONB) của bảng proposals được thiết kế theo mô hình 2 lớp riêng biệt nhưng đồng bộ chặt chẽ với nhau:**

**Plaintext**

```
proposals.payload (JSONB)
 ├── 1. LỚP NGHIỆP VỤ & SỔ SÁCH (Business & Ledger Layer)
 │    ├── target_member_id       : UUID thành viên mốc M
 │    ├── selected_canvas_depth  : Đời của mốc M (0 đến 4)
 │    ├── lines                  : Mảng 5 ô dòng quy đổi theo mốc M
 │    └── canvas_delta           : Tập biến đổi nháp phát sinh từ Canvas
 │         ├── draft_children    : Danh sách ô con nháp xin tạo
 │         │    └── [{ id, parent_node_id, depth, label, link }]
 │         ├── draft_spouses     : Danh sách cụm hôn phối nháp xin thêm
 │         │    └── [{ union_id, owner_node_id, partner_name }]
 │         └── node_positions_x  : Bản đồ tọa độ X đã căn chỉnh của các Node
 │
 └── 2. LỚP HIỂN THỊ CANVAS SNAPSHOT (UI Render Snapshot Layer)
      └── graph_snapshot        : Snapshot toàn bộ trạng thái React Flow
           ├── viewport          : Vị trí tọa độ & tỷ lệ phóng to/thu nhỏ { x, y, zoom }
           ├── nodes             : Mảng chứa toàn bộ Node Box (kể cả Node Khuyết danh KD)
           │    └── [{ id, type, position, data: { depth, clanName, tabs, ... } }]
           └── edges             : Mảng chứa toàn bộ đường nối Edge
                └── [{ id, source, target, sourceHandle, style }]
```

### **VAI TRÒ VÀ NGUYÊN TẮC VẬN HÀNH CỦA 2 LỚP**

1. **Lớp Nghiệp vụ & Sổ sách (canvas\_delta, lines):**  
   * **Nhiệm vụ: Chứa dữ liệu logic nguyên bản dùng cho Diffing Engine (mfoDiffEngine.js) và Luồng Phê duyệt ADMIN (Phase 2).**  
   * **Ưu điểm: Nhẹ, giàu ngữ nghĩa nghiệp vụ. ADMIN chỉ cần đọc canvas\_delta là biết chính xác người trình xin thêm bao nhiêu con, bao nhiêu vợ/chồng ở từng đời mà không cần quan tâm đến tọa độ hiển thị.**  
2. **Lớp Hiển thị Canvas Snapshot (graph\_snapshot):**  
   * **Nhiệm vụ: Phục vụ Khôi phục giao diện (Hydration Flow) khi End User quay lại sửa tiếp bản nháp.**  
   * **Ưu điểm: Đảm bảo đồ thị hiển thị lại giống \$100\\%\$ lúc bấm Lưu nháp, bảo toàn chính xác vị trí Node Khuyết danh (KD), tọa độ kéo thả $X$ và góc nhìn Viewport mà không bị tính toán lại làm xô lệch giao diện.**

### **2\. Kiểm soát Khóa Lạc Quan (Optimistic Locking)**

* **Sử dụng trường updated\_at làm mốc kiểm tra. Nếu User mở nháp trên 2 tab/thiết bị khác nhau, thiết bị gửi sau có heldTime \< serverTime sẽ bị chặn với mã lỗi HTTP 409 OPTIMISTIC\_LOCK\_FAILED.**

### **3\. Khóa Đơn Luồng (Single Active Pipeline Guardrail)**

* **Bổ sung hàm helper ensureNoActiveProposal(tx, { tenantId, actorId }).**  
* **Trước khi cho phép tạo nháp mới (saveDraft với isNew), Backend truy vấn kiểm tra xem User có bản ghi proposals nào đang ở các trạng thái \['DRAFT', 'PENDING', 'UNDER\_REVIEW', 'NEEDS\_REVISION'\] hay không.**  
* **Nếu phát hiện có tờ trình đang tiến hành, hệ thống từ chối tạo mới với mã lỗi 409 MFO\_ACTIVE\_PROPOSAL\_EXISTS.**

### **4\. Chuẩn hóa Sổ cái & Audit Log**

* **BPL Log (business\_process\_logs): Ghi nhận hành vi MFO\_DRAFT\_SAVED (khi lưu nháp) và MFO\_DRAFT\_DELETED (khi xóa nháp).**  
* **Audit Log (audit\_logs): Sử dụng helper chuẩn audit.create(tx, ...) với Enum tiếng Việt:**  
  * **THEM\_MOI: Khởi tạo bản nháp lần đầu.**  
  * **CAP\_NHAT: Lưu đè bản nháp hiện tại.**  
  * **XOA: Soft-delete bản nháp (deleted\_at \= now()).**

## **IV. THỂ HIỆN TRÊN FRONTEND (FRONTEND IMPLEMENTATION)**

### **1\. Trang Canvas Soạn thảo (OpMfoPlanPage.jsx)**

* **Cách ly Hydration: Phân tách rõ ràng giữa việc tải Khung nguyên thủy (getFullMfoSet) và Tải bản nháp (getDraftPayload) qua Query Param ?draft=\<id\>.**  
* **Active Form Portal (AF):**  
  * **Form thao tác điều hướng Node treo độc lập.**  
  * **Phân biệt chính xác giữa Đường màu xanh nét liền (union:\*) \- con đã khai báo đủ cha/mẹ và Đường màu vàng nét đứt (owner:unassigned) \- con chưa khai báo cụm hôn nhân, giúp AF đưa ra thông báo trạng thái chính xác \$100\\%\$.**  
* **Đồng bộ URL Real-time: Ngay khi bấm "Lưu nháp" thành công lần đầu, URL tự động chuyển sang /op/mfo/plans/new?draft=\<ticketId\> mà không làm reload trang.**

### **2\. Component Quản lý & Tóm tắt (MyMfoPlans.jsx)**

* **Dropdown Danh sách: Đặt tên Option theo chuẩn \<DateTime\>-Khung đang soạn/chờ duyệt/...**  
* **Bố cục Tóm tắt 2 Cột UX:**  
  * **Cột 1: Label Đời (Font nghiêng Italic w-28).**  
  * **Cột 2: Nội dung biến đổi gộp theo từng Node Box (Sử dụng Engine diffDraftAgainstInit).**  
* **UI Guardrail Single Active Pipeline:**  
  * **Khóa Option "Tạo khung dự kiến" trong Dropdown khi phát hiện có tờ trình In-Flight.**  
  * **Hiển thị Banner Warning màu vàng hướng dẫn người dùng tiếp tục hoàn thiện hoặc xóa tờ cũ.**  
* **Xóa nháp chuẩn HTTP: Nút "Xóa tờ đang soạn" phát request HTTP DELETE /api/mfo/plans/:id/draft, đảm bảo xóa sạch dữ liệu trên Database và BPL/Audit Log trước khi dọn dẹp State/Cache ở Client.**

## **V. CÁC ĐIỂM CỐT TỬ CẦN LƯU Ý KHI CHUYỂN PHÓNG SANG PHASE 2 (TRÌNH & DUYỆT)**

**Đội ngũ phát triển Phase 2 (Trình & Phê duyệt Khung 5L) cần lưu ý các khớp nối kỹ thuật sau:**

1. **Chuyển đổi Trạng thái Tờ trình (DRAFT $\rightarrow$ PENDING):**  
   * **Khi User bấm nút "Trình Khung 5L", không tạo bản ghi mới mà gọi API createPlan truyền kèm ticket\_id của bản nháp.**  
   * **Backend sẽ chuyển trạng thái của chính bản ghi proposals đó từ DRAFT thành PENDING, cập nhật BPL Log MFO\_PLAN\_SUBMITTED.**  
2. **Tái sử dụng Diffing Engine cho ADMIN:**  
   * **Màn hình duyệt của ADMIN (OpMfoReviewPage.jsx) cần import trực tiếp hàm diffDraftAgainstInit(payload) từ mfoDiffEngine.js.**  
   * **ADMIN sẽ nhìn thấy chính xác \$100\\%\$ bảng Tóm tắt biến đổi 2 Cột giống như người dùng đã nhìn thấy ở Phase 1\.**  
3. **Cơ chế Khóa Chỉnh sửa khi đã Trình:**  
   * **Khi trạng thái chuyển sang PENDING, Backend sẽ từ chối mọi yêu cầu saveDraft hoặc deleteDraft từ phía User ngoại trừ khi ADMIN trả về trạng thái NEEDS\_REVISION.**  
4. **Tính Toàn vẹn của Graph Snapshot:**  
   * **Khi ADMIN mở xem tờ trình, toàn bộ cây phả hệ 5L sẽ được dựng lại chính xác từ graph\_snapshot mà không sợ bị ảnh hưởng nếu các thành viên gốc trong Sổ họ bị người khác sửa đổi trong thời gian chờ duyệt.**

## **VI. XÁC NHẬN NGHỆM THU PHASE 1**

**Tất cả các tiêu chí kỹ thuật, kiểm thử Smoke Test, bao phủ Audit Log và trải nghiệm UI/UX của Phase 1 đã hoàn tất thành công \$100\\%\$.**

**ĐỊA ĐIỂM BÀN GIAO: Hệ thống Core EGAL Backend & Frontend Client.**

**SẴN SÀNG CHUYỂN TẬP: Hệ thống sẵn sàng bước sang Phase 2: Triển khai Luồng Trình Khung & Giao diện Phê duyệt ADMIN.**

