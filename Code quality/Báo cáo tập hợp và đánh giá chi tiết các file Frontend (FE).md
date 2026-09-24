# **Báo cáo tập hợp và đánh giá chi tiết các file Frontend (FE)** 

Mục đích: phục vụ cho quy trình lập và trình duyệt đề xuất khung 5L (`/api/plans/new` / `MFO_REVIEW`) được cấu trúc theo đúng các yêu cầu nghiệp vụ và tiêu chuẩn kỹ thuật BFA-Branch-Family-Doctrine-v1.3.1.md.

---

## **PHẦN 1: THỐNG KÊ DANH MỤC FILE**

| Mã File | Tên File Đầy Đủ (Gồm cả thư mục) |
| ----- | ----- |
| FE-01 | `src/pages/MfoProposalPage.jsx` |
| FE-02 | `src/features/genealogy/components/MfoPlanForm.jsx` |
| FE-03 | `src/features/genealogy/components/MfoLotProposalModal.jsx` |
| FE-04 | `src/features/genealogy/hooks/useMfoPlan.js` |
| FE-05 | `src/features/genealogy/services/mfoApi.js` |
| FE-06 | `src/features/genealogy/MobileGenealogyTree.jsx` |
| FE-07 | `src/features/genealogy/components/mobile/CustomFamilyNode.jsx` |
| FE-08 | `src/features/genealogy/components/mobile/NodeOperationsMenu.jsx` |
| FE-09 | `src/shared/hooks/useMobileTreeZoom.js` |
| FE-10 | `src/components/ui/BottomSheet.jsx` |

---

## **PHẦN 2: DIỄN GIẢI CHI TIẾT TỪNG FILE**

### **1\. FE-01: `src/pages/MfoProposalPage.jsx`**

#### **1\) Nội dung**

* Chức năng: Màn hình chính đảm nhận route tạo mới và nộp phiếu đề xuất khung 5L (`/plans/new`).  
* Nhiệm vụ: Bao bọc toàn bộ form cấu hình 5 dòng, quản lý trạng thái luồng làm việc của phiếu lô (`DRAFT` $\\rightarrow$ `SUBMITTED`), hiển thị danh sách kiểm tra điều kiện (Pre-flight checklist) và nút trigger gửi yêu cầu phê duyệt sang trạng thái `MFO_REVIEW`.

#### **2\) Sơ đồ / Thuật toán giải quyết**

* Máy trạng thái hữu hạn (FSM) quản lý vòng đời đề xuất:

  $$\\text{UNINITIALIZED} \\xrightarrow{\\text{Load Origin}} \\text{DRAFT} \\xrightarrow{\\text{Validate 5L}} \\text{READY\_TO\_SUBMIT} \\xrightarrow{\\text{POST /api/plans/new}} \\text{MFO\_REVIEW}$$  
* Thuật toán kiểm soát URL & Routing: Áp dụng cơ chế history `replaceState` khi chuyển đổi các bước thiết lập thay vì `pushState`, đảm bảo nút Back trên trình duyệt chỉ tốn 1 lần bấm để thoát về Hub chính theo chuẩn BFA A01 Shell.

#### **3\) Đánh giá chất lượng mã nguồn**

* Đảm bảo tiêu chuẩn mã nguồn: Đạt cấu trúc Feature-Based Architecture.  
* Có lỗi đang tồn tại: Thiếu xử lý khôi phục dữ liệu nháp (Draft Recovery) từ `localStorage` khi người dùng F5 hoặc mất kết nối đột ngột giữa chừng.  
* Có tối ưu? Lý do & Hướng sửa: Cần tách phần danh sách trạng thái phê duyệt (Checklist panel) thành component độc lập và bọc `React.memo` để tránh re-render trang khi dữ liệu form 5L thay đổi liên tục.  
* Tác động tốt/xấu trên mobile:  
  * *Mặt xấu:* Bố cục trang bị quá dài trên màn hình đứng (portrait view) làm trôi mất nút "Gửi phê duyệt".  
  * *Hướng xử lý:* Cố định thanh điều hướng thao tác (Sticky Action Bar) ở đáy màn hình.  
* Các vấn đề khác: Cần đảm bảo kiểm tra `tenant_id` từ Token người dùng trước khi tải dữ liệu khung.

---

### **2\. FE-02: `src/features/genealogy/components/MfoPlanForm.jsx`**

#### **1\) Nội dung**

* Chức năng: Form tương tác trung tâm để cấu hình khung 5 dòng (5L) từ Dòng 0 (Origin) đến Dòng $k$ (Founder/MWL).  
* Nhiệm vụ: Cho phép người dùng thiết lập 3 loại lệnh cố định trên từng dòng trong mảng `payload.lines[]`:  
  1. `ASSIGN`: Chọn thành viên đã tồn tại.  
  2. `CREATE`: Đánh dấu tạo mới thành viên cùng thế hệ.  
  3. `EMPTY`: Khóa không khởi tạo/gán tại thế hệ này.

#### **2\) Sơ đồ / Thuật toán giải quyết**

* Thuật toán ràng buộc ma trận 5L (Lot Ops Matrix Rules):  
  * *Ràng buộc Dòng $0$:* Bắt buộc là `ASSIGN` với `origin_member_id`.  
  * *Ràng buộc Dòng $k$:* Bắt buộc là `ASSIGN` với `founder_member_id` (MWL).  
  * *Ràng buộc Dòng trung gian ($1 \\dots k-1$):* Nhận 1 trong 3 giá trị `ASSIGN`, `CREATE`, hoặc `EMPTY`.  
* Data Structure:  
  Javascript

```
payload = {
  origin_member_id: "MEM_ORIGIN_ID",
  founder_member_id: "MEM_MWL_ID",
  k: 4,
  lines: [
    { line_index: 0, command: "ASSIGN", member_id: "..." },
    { line_index: 1, command: "CREATE", label: "Tạo dòng 1" },
    { line_index: 2, command: "EMPTY" },
    { line_index: 3, command: "CREATE", label: "Tạo dòng 3" },
    { line_index: 4, command: "ASSIGN", member_id: "..." }
  ]
}
```

#### **3\) Đánh giá chất lượng mã nguồn**

* Đảm bảo tiêu chuẩn mã nguồn: Tuân thủ chuẩn BFA-MFO-Lot-Ops-v1.0.  
* Có lỗi đang tồn tại: Chưa chặn triệt để trường hợp người dùng chọn lệnh `ASSIGN` cho hai dòng khác nhau nhưng lại chọn cùng 1 `member_id` (trùng lặp thành viên trong cùng 1 phiếu lô).  
* Có tối ưu? Lý do & Hướng sửa: Nên chuyển state quản lý `lines` từ `useState` sang `useReducer` để kiểm soát các side-effect va chạm giữa các dòng khi thay đổi khoảng cách $k$.  
* Tác động tốt/xấu trên mobile:  
  * *Mặt tốt:* Thao tác dạng danh sách cuộn dọc phù hợp với luồng vuốt ngón tay.  
  * *Mặt xấu:* Trình chọn thành viên (`ASSIGN` selector) mở dạng Dropdown thông thường bị khuất mép màn hình di động.  
* Các vấn đề khác: Không được phép đưa các trường thông tin không liên quan (như `users.phone` hay `members.gender`) vào form này.

---

### **3\. FE-03: `src/features/genealogy/components/MfoLotProposalModal.jsx`**

#### **1\) Nội dung**

* Chức năng: Cửa sổ Modal bật lên khi người dùng đứng tại sơ đồ gia phả và bấm chọn một nhánh/cặp nút để khởi tạo khung 5L.  
* Nhiệm vụ: Lấy dữ liệu nhanh từ cây (Origin ID, Founder ID) và khởi tạo thông số ban đầu trước khi chuyển sang form chi tiết `MfoProposalPage`.

#### **2\) Sơ đồ / Thuật toán giải quyết**

* Luồng khởi tạo dữ liệu tự động (Context Auto-fill):

  $$\\text{Select Node A (Origin)} \\land \\text{Select Node B (Founder)} \\longrightarrow \\text{Compute Distance } k \\longrightarrow \\text{Pre-fill Modal Payload}$$

#### **3\) Đánh giá chất lượng mã nguồn**

* Đảm bảo tiêu chuẩn mã nguồn: Đảm bảo tính đóng gói component UI.  
* Có lỗi đang tồn tại: Không tự động hủy (cleanup) các subscription event listener khi modal bị đóng đột ngột bằng nút Esc hoặc gõ ngoài vùng backdrop.  
* Có tối ưu? Lý do & Hướng sửa: Sử dụng React Portal (`createPortal`) để render Modal ra ngoài DOM tree chính, tránh bị ảnh hưởng bởi thuộc tính `z-index` hoặc `overflow: hidden` của React Flow Canvas.  
* Tác động tốt/xấu trên mobile:  
  * *Mặt xấu:* Modal chiếm hết diện tích hiển thị làm người dùng mất ngữ cảnh vùng cây vừa chọn bên dưới.  
  * *Hướng xử lý:* Thay thế Modal bằng `BottomSheet` trên môi trường mobile.  
* Các vấn đề khác: Không có.

---

### **4\. FE-04: `src/features/genealogy/hooks/useMfoPlan.js`**

#### **1\) Nội dung**

* Chức năng: Custom Hook đóng vai trò là "Bộ não" quản lý toàn bộ Logic State và Validation của phiếu đề xuất MFO 5L.  
* Nhiệm vụ: Cung cấp các hàm hành động (`setOrigin`, `setFounder`, `updateLineCommand`, `validatePlan`, `submitPlan`) cho các UI component.

#### **2\) Sơ đồ / Thuật toán giải quyết**

* Thuật toán Validation Ma trận 5L (Validation Pipeline):

```
Input Payload -> Check k valid? -> Check Line 0 == ASSIGN? -> Check Line k == ASSIGN? -> Check Line 1..k-1 valid commands? -> Return { isValid: boolean, errors: [] }
```

#### **3\) Đánh giá chất lượng mã nguồn**

* Đảm bảo tiêu chuẩn mã nguồn: Tốt, phân tách rõ ràng giữa Logic và UI (Clean Architecture).  
* Có lỗi đang tồn tại: Chưa bổ sung thuật toán kiểm tra vòng lặp quan hệ (Cycle Detection) khi người dùng gán ngầm định Founder làm cha/ông của Origin.  
* Có tối ưu? Lý do & Hướng sửa: Dùng `useCallback` cho toàn bộ các hàm trả về để tránh đứt gãy tham chiếu re-render ở `MfoPlanForm`.  
* Tác động tốt/xấu trên mobile: Tốt, hook chạy độc lập ở tầng logic nên không gây ảnh hưởng đến hiệu năng hiển thị.  
* Các vấn đề khác: Tuân thủ tuyệt đối quy tắc `place ≠ usage` khi xử lý thông tin địa chỉ kèm theo phiếu.

---

### **5\. FE-05: `src/features/genealogy/services/mfoApi.js`**

#### **1\) Nội dung**

* Chức năng: Tầng dịch vụ gởi request HTTP/Axios kết nối với các Endpoint Backend MFO.  
* Nhiệm vụ:  
  * `POST /api/mfo/plans` hoặc `/api/plans/new`: Tạo phiếu đề xuất nháp.  
  * `POST /api/mfo/plans/:id/submit`: Chuyển phiếu sang trạng thái chờ duyệt `MFO_REVIEW`.  
  * `GET /api/mfo/plans/:id`: Lấy chi tiết phiếu lô.

#### **2\) Sơ đồ / Thuật toán giải quyết**

* Sơ đồ luồng xử lý Request/Response:

  $$\\text{UI Component} \\xrightarrow{\\text{Payload JSON}} \\text{mfoApi} \\xrightarrow{\\text{Axios Interceptor (Auth Token)}} \\text{BE REST API} \\xrightarrow{\\text{Response / Error Handle}} \\text{UI Toast Feedback}$$

#### **3\) Đánh giá chất lượng mã nguồn**

* Đảm bảo tiêu chuẩn mã nguồn: Đạt chuẩn, có gán Header phiên bản API.  
* Có lỗi đang tồn tại: Thiếu cơ chế Tự động thử lại (Retry Strategy) khi gặp sự cố gián đoạn mạng chập chờn trên môi trường di động.  
* Có tối ưu? Lý do & Hướng sửa: Tích hợp TanStack Query (React Query) để tự động cache kết quả và quản lý trạng thái `isLoading` / `isError` chuẩn hóa.  
* Tác động tốt/xấu trên mobile: Hoàn toàn ổn định.  
* Các vấn đề khác: Không được gửi các trường bị khóa qua API theo đúng ranh giới an toàn A01.

---

### **6\. FE-06: `src/features/genealogy/MobileGenealogyTree.jsx`**

#### **1\) Nội dung**

* Chức năng: Component Container chính bao bọc sơ đồ cây gia phả React Flow tối ưu riêng cho thiết bị di động.  
* Nhiệm vụ: Cho phép người dùng chạm chọn Node, xem BottomSheet thao tác và kích hoạt quy trình lập phiếu lô 5L trực tiếp từ không gian cây.

#### **2\) Sơ đồ / Thuật toán giải quyết**

* Sơ đồ Tương tác Touch-to-Focus:

  $$\\text{Touch Node} \\longrightarrow \\text{Calculate Node X,Y} \\longrightarrow \\text{Trigger useMobileTreeZoom} \\longrightarrow \\text{Smooth Camera Pan/Zoom} \\longrightarrow \\text{Open BottomSheet}$$

#### **3\) Đánh giá chất lượng mã nguồn**

* Đảm bảo tiêu chuẩn mã nguồn: Chuẩn xác theo cấu trúc cây tương tác di động.  
* Có lỗi đang tồn tại: Khi cây quá lớn (trên 200 nodes), thao tác cuộn/phóng to trên thiết bị di động tầm trung bị sụt giảm FPS (khung hình/giây).  
* Có tối ưu? Lý do & Hướng sửa: Áp dụng kỹ thuật Virtualization (Chỉ render các nút trong viewport hiện tại) của React Flow.  
* Tác động tốt/xấu trên mobile:  
  * *Mặt tốt:* Trải nghiệm mượt mà, loại bỏ hoàn toàn Hover/Context Menu kiểu PC.  
  * *Mặt xấu:* Tốn dung lượng bộ nhớ (RAM) nếu không giải phóng tài nguyên cây khi unmount.  
* Các vấn đề khác: Phải phối hợp chặt chẽ với Hook `useMobileTreeZoom`.

---

### **7\. FE-07: `src/features/genealogy/components/mobile/CustomFamilyNode.jsx`**

#### **1\) Nội dung**

* Chức năng: Custom Node biểu diễn cặp Vợ/Chồng hoặc cá nhân trên đồ thị React Flow.  
* Nhiệm vụ: Hiển thị thông tin tóm tắt và tiếp nhận sự kiện chạm (`onTouchStart` / `onClick`) để chọn làm Origin hoặc Founder cho phiếu 5L.

#### **2\) Sơ đồ / Thuật toán giải quyết**

* Thuật toán Render Trạng thái Vùng chọn (Selection Highlight Algorithm):  
  * Nếu Node ID \== `origin_member_id` $\\rightarrow$ Render viền màu Xanh (Origin Anchor).  
  * Nếu Node ID \== `founder_member_id` $\\rightarrow$ Render viền màu Cam (Founder Anchor).  
  * Khác $\\rightarrow$ Render viền chuẩn.

#### **3\) Đánh giá chất lượng mã nguồn**

* Đảm bảo tiêu chuẩn mã nguồn: Tốt, tuân thủ quy định component nhỏ gọn.  
* Có lỗi đang tồn tại: Nút tương tác chạm trên Node đôi khi bị đè bởi đường nối (Edges) của React Flow làm sự kiện bấm bị mất.  
* Có tối ưu? Lý do & Hướng sửa: Thêm thuộc tính CSS `pointer-events: none` cho các đường đè và tăng `z-index` cho vùng chứa nút bấm.  
* Tác động tốt/xấu trên mobile:  
  * *Mặt tốt:* Vùng cảm ứng (Touch Target) của Node đạt kích thước an toàn $\\ge 48\\text{px}$.  
* Các vấn đề khác: Không chứa dữ liệu nhạy cảm chưa qua phê duyệt.

---

### **8\. FE-08: `src/features/genealogy/components/mobile/NodeOperationsMenu.jsx`**

#### **1\) Nội dung**

* Chức năng: Menu danh sách 7 thao tác di động (`Ope1` – `Ope7`) nằm bên trong Bottom Sheet.  
* Nhiệm vụ: Chứa các nút kích hoạt tính năng, trong đó có thao tác lập phiếu lô MFO từ Node đang chọn.

#### **2\) Sơ đồ / Thuật toán giải quyết**

* Sơ đồ Phân nhánh Thao tác (Operation Dispatcher):

```
Click Ope -> Switch(Ope_Type)
              case Ope1: Xem chi tiết -> GET /api/v1/members/:id
              case Ope5: Lập khung 5L -> Open MfoLotProposalModal
              case Ope7: Xóa nút -> Open Confirm Dialog
```

#### **3\) Đánh giá chất lượng mã nguồn**

* Đảm bảo tiêu chuẩn mã nguồn: Rất tốt, chia tách rõ ràng các button.  
* Có lỗi đang tồn tại: Chưa thực hiện Disable (vô hiệu hóa) các nút thao tác mà tài khoản hiện tại không có quyền thực hiện.  
* Có tối ưu? Lý do & Hướng sửa: Bổ sung prop `userPermissions` để ẩn/hiện hoặc vô hiệu hóa nút bấm động.  
* Tác động tốt/xấu trên mobile:  
  * *Mặt tốt:* Tất cả 7 nút đều đạt chuẩn chiều cao tối thiểu $48\\text{px}$, chống bấm nhầm ngón tay tuyệt đối.  
* Các vấn đề khác: Kết nối với thư viện `sonner` để phát thông báo Toast phản hồi tức thì.

---

### **9\. FE-09: `src/shared/hooks/useMobileTreeZoom.js`**

#### **1\) Nội dung**

* Chức năng: Custom Hook điều khiển hiệu ứng di chuyển camera (Pan) và phóng to (Focus & Context Zoom) tự động trên sơ đồ cây React Flow.  
* Nhiệm vụ: Tự động đưa vị trí gia đình/Node được chọn vào chính giữa màn hình điện thoại khi mở menu thao tác.

#### **2\) Sơ đồ / Thuật toán giải quyết**

* Công thức tính tọa độ Camera Zoom:

  $$\\begin{aligned}

  X\_{\\text{target}} &= X\_{\\text{node}} \- \\frac{\\text{ViewportWidth}}{2 \\cdot \\text{ZoomLevel}} \\

  Y\_{\\text{target}} &= Y\_{\\text{node}} \- \\frac{\\text{ViewportHeight}}{3 \\cdot \\text{ZoomLevel}} \\quad (\\text{Dành không gian phía dưới cho BottomSheet})

  \\end{aligned}$$  
* Sử dụng hàm `setCenter(X_{target}, Y_{target}, { zoom: 1.2, duration: 800 })` của React Flow.

#### **3\) Đánh giá chất lượng mã nguồn**

* Đảm bảo tiêu chuẩn mã nguồn: Mã nguồn tính toán toán học chuẩn xác, mượt mà.  
* Có lỗi đang tồn tại: Khi thiết bị quay ngang (Landscape Mode), độ dời Y ($Y\_{\\text{target}}$) tính theo hằng số bị lệch làm Node bị trượt khỏi tầm nhìn.  
* Có tối ưu? Lý do & Hướng sửa: Đưa kích thước thực tế của `BottomSheet` vào công thức tính toán tọa độ $Y$ động thay vì dùng số nguyên cố định.  
* Tác động tốt/xấu trên mobile:  
  * *Mặt tốt:* Trải nghiệm người dùng cực kỳ thông minh, tránh việc bị lạc trên sơ đồ lớn.  
* Các vấn đề khác: Không có.

---

### **10\. FE-10: `src/components/ui/BottomSheet.jsx`**

#### **1\) Nội dung**

* Chức năng: Component UI Bottom Sheet dùng chung cho toàn bộ giao diện di động.  
* Nhiệm vụ: Trượt mượt từ dưới màn hình lên khi kích hoạt, bao bọc danh sách thao tác hoặc form nhập liệu nhanh.

#### **2\) Sơ đồ / Thuật toán giải quyết**

* Sơ đồ Xử lý Khóa Cuộn trang (Scroll Lock Algorithm):

  $$\\text{BottomSheet Open} \\longrightarrow \\text{Set } \\texttt{document.body.style.overflow \= 'hidden'} \\longrightarrow \\text{Block background scroll}$$

  $$\\text{BottomSheet Close} \\longrightarrow \\text{Reset } \\texttt{document.body.style.overflow \= 'unset'}$$

#### **3\) Đánh giá chất lượng mã nguồn**

* Đảm bảo tiêu chuẩn mã nguồn: Tối ưu tốt, sử dụng CSS Transition cho hiệu năng mượt mà.  
* Có lỗi đang tồn tại: Thiếu sự kiện vuốt xuống (Swipe down to dismiss) bằng ngón tay.  
* Có tối ưu? Lý do & Hướng sửa: Bổ sung Framer Motion hoặc xử lý sự kiện `onTouchMove` để hỗ trợ cử chỉ vuốt đóng mượt mà hơn.  
* Tác động tốt/xấu trên mobile:  
  * *Mặt tốt:* Thay thế hoàn toàn giao diện Hover/Context Menu của PC, đạt chuẩn UX di động hiện đại.  
* Các vấn đề khác: Có sẵn backdrop làm mờ nền giúp tăng độ tập trung thị giác.

