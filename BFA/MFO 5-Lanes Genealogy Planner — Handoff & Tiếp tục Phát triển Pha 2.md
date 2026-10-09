**TIÊU ĐỀ: MFO 5-Lanes Genealogy Planner — Handoff & Tiếp tục Phát triển Pha 2**

**1\. BỐI CẢNH & TRẠNG THÁI HIỆN TẠI (CONTEXT & HANDOFF):**

* **Dự án**: MFO Genealogy Planner (Management of Family Origins) — Phân hệ "Tạo khung trình 5L" (5-Generational Lanes Canvas, từ Đời 0 đến Đời 4).  
* **Tiến độ**: Đã hoàn thành 100% UAT Pha 1 cho hai file cơ sở: frontend/src/features/genealogy/components/FamilyCoupleNode.jsx (v2.2.1-A15-ANCHOR-SPACE-DRAGGABLE-READY) và frontend/src/pages/OpMfoPlanPage.jsx (v1.4.34-GRAPH-EDGE-CHILD-LOOKUP).

**2\. CÁC QUY CHUẨN KỸ THUẬT & QUY ƯỚC ĐÃ ĐƯỢC THỐNG NHẤT:**

* **Cấu trúc 5 Lanes cố định**: Không dùng Dagre layout tự động. Tọa độ Y khóa cứng $Y=depth\times 310px$. Kéo rê Node (onNodeDragStop) chỉ thay đổi vị trí ngang $X$, chặn tuyệt đối nhảy tầng Đời.  
* **Hợp đồng Handles & Nét vẽ A-1.5**:  
  * Con thuộc Tab Hôn phối active: Nối từ Handle tím/chàm union:\<unionId\>:children (\$78\\%\$), nét liền màu chàm (stroke: '\#6366f1').  
  * Con chưa gắn hôn phối: Nối từ Handle vàng owner:unassigned (\$22\\%\$), nét đứt màu vàng (stroke: '\#f59e0b', strokeDasharray: '4 4').  
* **Micro-Task Edge Mounting**: Dùng setNodes trước, hoãn setEdges sang requestAnimationFrame ở frame kế tiếp để đảm bảo Handle DOM đã mount \$100\\%\$.  
* **Action Form (AF) Portal & Cụm tin Hôn nhân (Phần 1 AF)**:  
  * Mở bằng createPortal đè layer Canvas, chống giật theo transform Viewport.  
  * Tra cứu tên con đời dưới ($depth+1$) trực tiếp bằng cách quét mảng edges trên Canvas (ưu tiên sourceHandle \=== 'owner:unassigned' để lấy chính xác tên con như *Nguyễn Đình Xuân*).  
  * Render đúng 2 trường hợp:  
    * *Trường hợp a (có con / có childFullName)*: Thông tin hôn nhân: Các con đời dưới như: {childFullName} thiếu khai báo cha/mẹ  
    * *Trường hợp b (chưa có con / childFullName \= null)*: Thông tin hôn nhân: Chưa khai báo.  
* **Nhãn nhân sự nháp**: Các Node con / Spouse mới tạo gán hậu tố (Xin tạo) để Avatar tự động trích xuất chuỗi viết tắt **"XT"**.

**3\. BẮT ĐẦU CÔNG VIỆC CHO THREAD MỚI:**

Hãy ghi nhận toàn bộ ngữ cảnh Handoff trên và sẵn sàng tiếp tục công việc tự nhiên mà không làm phá vỡ bất kỳ quy chuẩn / logic nào đã chốt ở Pha 1\.

Bạn đã nắm rõ toàn bộ bối cảnh và quy chuẩn kỹ thuật chưa?

