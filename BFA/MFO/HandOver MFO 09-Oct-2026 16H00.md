### **BẢN HANDOVER KỸ THUẬT CHI TIẾT (CONTEXT HANDOVER)**

#### **1\. BỐI CẢNH KIẾN TRÚC & QUY TẮC DỮ LIỆU CHỐT (CORE DOCTRINE)**

* **Single Thread / Single Instance (proposals):** Mỗi tờ trình MFO là **1 bản ghi duy nhất** trong bảng proposals chứa dữ liệu đồ họa & thông tin chi tiết dưới dạng JSONB (payload).  
* **Staging Doctrine (Zero Garbage in Core DB):** Trong toàn bộ hành trình khai báo (dù đi qua nhiều lượt sửa đổi), toàn bộ thông tin nháp (Node, Vợ, Con, Tọa độ X) **chỉ nằm trong proposals.payload**. Dữ liệu chỉ được biến đổi (Mutation) ghi thật vào CSDL chính (members, marriages, genealogy\_trees) **DUY NHẤT KHI ADMIN BẤM DUYỆT TỜ KHAI Ở GATE 2 (APPROVED)**.  
* **Phân biệt Soft-Delete và Terminated State:**  
  * deleted\_at NOT NULL: Chỉ dùng khi EU/User bấm **Xóa Tờ trình** (Soft-Delete bản ghi proposals nháp/bị trả về). Bản ghi bị ẩn khỏi toàn bộ danh sách.  
  * status \= 'REJECTED': Là trạng thái từ chối vĩnh viễn của Admin ở Gate 2\. **deleted\_at BẮT BUỘC PHẢI BẰNG NULL** để lưu vết Bút phê Admin. Tờ khai này vẫn hiện trên Dropdown List của EU với banner cảnh báo Đỏ và bị đóng băng Read-Only 100%.

#### **2\. MA TRẬN STATE MACHINE 2 CỔNG (CHỦ CHỐT)**

##### **CỔNG 1 (GATE 1: MFO\_PLAN \- DUYỆT KHUNG 5L SƠ ĐỒ)**

Admin thẩm định hình hài sơ đồ 5 đời. Chỉ có **2 mức quyết định**:

1. **Phê duyệt (APPROVE):** \$\\text{PENDING} \\xrightarrow{} \\text{APPROVED}\$ $\rightarrow$ Tem payload.plan\_ok \= true, mở xưởng Workbench cho EU kê khai chi tiết.  
2. **Không duyệt / Yêu cầu sửa (RETURN\_FOR\_REVISION):** \$\\text{PENDING} \\xrightarrow{} \\text{NEEDS\\\_REVISION}\$ $\rightarrow$ Lưu bút phê Admin, mở khóa Canvas cho EU chỉnh sửa tọa độ/quan hệ rồi Trình lại.

##### **CỔNG 2 (GATE 2: MFO\_RESULT \- DUYỆT TỜ KHAI NGHIỆM THU CHỐT SỔ THẬT)**

Admin thẩm định thông tin hành chính từng người. Có đủ **3 mức quyết định**:

1. **Duyệt Tờ Khai (APPROVE):** \$\\text{UNDER\\\_REVIEW} \\xrightarrow{} \\text{APPROVED}\$ $\rightarrow$ Tem payload.result\_ok \= true, **kích hoạt Transaction ghi CSDL thật** (Khóa vĩnh viễn không thể đảo ngược).  
2. **Trả về để sửa (RETURN\_FOR\_REVISION):** \$\\text{UNDER\\\_REVIEW} \\xrightarrow{} \\text{NEEDS\\\_REVISION}\$ $\rightarrow$ Lưu bút phê Admin, mở khóa Form Workbench cho EU bổ sung/sửa đổi rồi Trình lại.  
3. **Không duyệt / Bác bỏ (REJECT):** \$\\text{UNDER\\\_REVIEW} \\xrightarrow{} \\text{REJECTED}\$ $\rightarrow$ Lưu bút phê từ chối, deleted\_at \= NULL, **đóng băng vĩnh viễn** (Không thể đảo ngược).

#### **3\. QUYỀN XÓA TỜ TRÌNH CỦA END USER (EU DELETE MATRIX)**

EU được quyền bấm **Xóa Tờ trình** (gọi API DELETE /api/mfo/plans/:id/draft gán deleted\_at \= NOW()) khi proposals.status thuộc các trường hợp:

* status \= 'DRAFT'.  
* status \= 'NEEDS\_REVISION' tại Gate 1 hoặc Gate 2 (Khi Tờ khai/Khung bị Admin trả về sửa, nếu EU thấy lỗi quá nhiều muốn làm lại từ đầu thì có quyền Xóa sạch tờ trình).  
* status \= 'APPROVED' ở Gate 1 nhưng chưa nộp Gate 2 (plan\_ok \= true & result\_submitted \= false).

*Vô hiệu hóa nút Xóa khi:* PENDING, UNDER\_REVIEW (đang nằm trong phòng thẩm định), APPROVED ở Gate 2 (đã chốt sổ thật), hoặc REJECTED (đã bị bác bỏ vĩnh viễn).

#### **4\. TRẠNG THÁI CÁC TỆP MÃ NGUỒN ĐÃ HOÀN THÀNH & TỐI ƯU (FILE INDEX)**

##### **Backend Files (Node.js/Express):**

* backend/src/shared/frameworks/srpf/registry/ProcessDefinitionRegistry.js: Đã cập nhật tự động Bootstrapping 2 tiến trình MFO\_PLAN và MFO\_RESULT.  
* backend/src/modules/mfo/definitions/mfoPlanProcess.definition.js: Ma trận Gate 1 (2 luồng APPROVE / RETURN\_FOR\_REVISION).  
* backend/src/modules/mfo/definitions/mfoResultProcess.definition.js: Ma trận Gate 2 (3 luồng APPROVE / RETURN\_FOR\_REVISION / REJECT). **Đã dọn dẹp loại bỏ hoàn toàn require file mfoMutation.service.js thừa**.  
* backend/src/modules/mfo/mfo.controller.js: Đã chuẩn hóa loại bỏ hoàn toàn lỗi **Double-Execution** (chỉ gọi 1 lần executeAction qua SRPF Executor cho createPlan, rejectPlan, deleteDraft).

##### **Frontend Files (React Flow / Vite):**

* frontend/src/features/mfo/api/mfoApi.js: Cung cấp chuẩn các hàm unwrap Axios (savePlanDraft, getDraftPayload, deleteDraft, rejectPlan, adminApprovePlan, adminReturnPlanForRevision).  
* frontend/src/pages/AdminMfoPlanPage.jsx: Đã đồng bộ giao diện Card 1 (React Flow Graph) & Card 2 (Bút phê từng đời qua mfoDiffEngine.js), tự động đổi cụm nút bấm theo queueTab (Tab PLAN có 2 nút; Tab RESULT có 3 nút).  
* frontend/src/pages/OpMfoPlanPage.jsx: Đã tích hợp nút Trình Khung 5L (handleSubmitPlan), mở 100% Active Form thao tác Node nháp.  
* frontend/src/features/mfo/components/MyMfoPlans.jsx: Xử lý Dropdown Single Thread, hiển thị trạng thái Banner Đỏ cho REJECTED và cung cấp Nút Xóa Soft-Delete.  
* 

