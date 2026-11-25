# AMEND-MFO-2026-01-CANVAS-LINK-EXISTING
**Phiên bản:** 5.4 (Final Frozen)  
**Ngày:** 2026-11-24  
**Trạng thái:** CHÍNH THỨC BAN HÀNH (APPROVED FOR IMPLEMENTATION)  
**Mã tài liệu:** AMEND-MFO-2026-01  

**Tài liệu quy chiếu:**
- New RP&OP (đã CLOSED)
- MFO Canvas hiện hành
- TFD-CORE-APPROVAL-1.0.0
- FTDI-PRACTICAL-SPEC-1.0.4-Final
- MYCLAN-FTD-GAP-REPORT-1.2.0-FINAL

---

## MFO-CL-00. Business Context (As-Is & Căn nguyên)

### MFO-CL-00.1 Hiện trạng Canvas MFO
Canvas hiện tại của myclan **bắt buộc phải chọn một người đã có trong sổ họ làm “điểm neo”**, sau đó chỉ hỗ trợ thao tác **đi xuống** (tạo con, tạo vợ/chồng). Không hỗ trợ đi lên, không hỗ trợ tạo cây nhỏ khi chưa biết điểm neo, và không hỗ trợ ghép nhánh đã xây sẵn.

### MFO-CL-00.2 Vấn đề thực tế phát sinh (Nút thắt cổ chai)
Sau quy trình RP&OP mới, member `CHINH_THUC` được tạo và đứng độc lập. Người trẻ thường chỉ biết phạm vi gia đình trực hệ (cha mẹ, ông bà). Họ không biết hoặc không chắc chắn về các thế hệ phía trên. 
**Hệ quả:** Bắt buộc chọn điểm neo khiến EU không dám hoặc không thể sử dụng Canvas. Tính năng MFO gần như vô dụng với new user nếu họ không thuộc dòng tộc có dữ liệu quá hoàn thiện.

---

## MFO-CL-01. Mục đích & Nguyên tắc (To-Be)

Mở rộng Canvas để hỗ trợ hai luồng tiếp cận, tháo gỡ hoàn toàn nút thắt nêu trên, đồng thời tuân thủ tuyệt đối chuẩn FTD/FTDI.

- **Path A (Có điểm neo rõ):** Admin chỉ định hoặc EU chọn đúng điểm neo → Xây xuống.
- **Path B (Chưa biết điểm neo - Cây nhỏ):** EU tạo nút cao nhất “Cần xác định” → Xây cây nhỏ → Gửi trạng thái chờ ghép (`CHO_GHEP`) → Admin dòng họ đánh giá và thực hiện ghép (`MERGE_SMALL_TREE`).

**Nguyên tắc bất biến:**  
- **Không suy diễn chứng cứ (P-02):** Không tự sinh "Khuyết danh mẫu thân" hoặc hôn nhân ảo nếu không có cơ sở.
- **Không xóa bất đồng (P-14):** Khi có mâu thuẫn dữ liệu trong quá trình ghép, hệ thống sinh Claim cạnh tranh, không ghi đè âm thầm.
- **Một người = Một bản ghi (P-01):** Bản ghi `CHINH_THUC` của EU được nhúng trực tiếp vào cây nhỏ, không nhân bản.

---

## MFO-CL-02. Phạm vi (In/Out of Scope)

### Trong phạm vi (In-Scope)
- Hỗ trợ đầy đủ luồng Path A và Path B.
- Chuyển đổi Khảo sát EU thành Chứng cứ (`sources` / `citations`).
- Xử lý Claim mâu thuẫn đối với quan hệ huyết thống (`parentages`).
- Service Mapper phục vụ Dual-Write đồng bộ ngược dữ liệu Legacy.
- Khóa an toàn đồng thời (Advisory Lock) & Cycle Detection.

### Ngoài phạm vi (Out-of-Scope)
- Không hỗ trợ nút "Thêm anh chị em ngang hàng" trực tiếp trên UI (tạo gián tiếp qua nút cha mẹ).
- Không cập nhật tự động các trường nhân thân thuộc Khóa A01.
- **Thiết kế UI/UX để hiển thị và giải quyết các Claim dị bản về nhân thân (tên, ngày tháng) sẽ được xử lý ở Phase sau.**

---

## MFO-CL-10. Cấu trúc và Vòng đời Cây nhỏ (Path B)

1. **Khởi tạo & Nhúng:** EU tạo nút "Cần xác định". Hệ thống cho phép nhúng trực tiếp nút `CHINH_THUC` của chính EU vào cây nhỏ.
2. **Quota & Ràng buộc:** Mỗi user chỉ được có tối đa **01 cây nhỏ chưa ghép**. Khi cây nhỏ chuyển sang `DA_GHEP` hoặc `ARCHIVED_GARBAGE`, user được reset quota để tạo cây mới.
3. **Vòng đời State Machine:**
   - `DRAFT` (EU đang soạn, lưu nháp).
   - `CHO_GHEP` (EU gửi yêu cầu ghép).
   - `DA_GHEP` (Admin thực hiện ghép thành công).
   - `ARCHIVED_GARBAGE` (Chỉ tự động chuyển từ `DRAFT` nếu quá 90 ngày không hoạt động).
   - `RETRACT` (Từ `CHO_GHEP` quay lại `DRAFT` do EU rút lệnh gửi).
4. **Quy tắc dọn rác (Garbage Collection):** Khi cây `DRAFT` biến thành `ARCHIVED_GARBAGE`, hệ thống **chỉ gỡ các liên kết cạnh (edges) và xóa nút nháp nội bộ**. Tuyệt đối không xóa/sửa nút `CHINH_THUC` của EU.

---

## MFO-CL-20. Ghép cây nhỏ (MERGE_SMALL_TREE)

Thao tác của Admin, chia làm 2 chế độ xử lý. Cả hai chế độ đều phải gọi **Service Mapper** để đồng bộ `father_id`/`mother_id` cho OP cũ.

### MFO-CL-20A. Chế độ 1 – Hợp nhất nút (MERGE_NODE)
Nút cao nhất của cây nhỏ **là cùng một người** với điểm neo trên cây lớn.
- **Giới hạn đệ quy:** Hệ thống chỉ yêu cầu Admin thực hiện Sub-node Mapping (ánh xạ trùng lặp) đối với **vợ/chồng và con trực hệ** của nút gốc cây nhỏ. Các tầng cháu chắt bên dưới mặc định "Tạo mới" và bám theo cha mẹ chúng.
- **Xử lý Xung đột dữ liệu (Tuân thủ P-14):**
  - **Quan hệ huyết thống:** Nếu mâu thuẫn, tạo bản ghi `parentages` ở trạng thái `DISPUTED`.
  - **Dữ liệu nhân thân (Ngày/Tên):** Nếu mâu thuẫn, tạo Claim dị bản gắn kèm `Citation` (không ghi đè). Chi tiết cấu trúc lưu trữ dị bản nhân thân sẽ tận dụng/mở rộng nhẹ bảng `sources`, `citations` và các bảng assertion hiện có (chi tiết ở DB Design Phase).
  - Các trường trống (`NULL`) trên SSOT được phép điền từ cây nhỏ, **ngoại trừ** Khóa A01 (`gender`, `is_alive`, `phone`, `email`).
- **Rollback:** Không có rollback tự động. Cần UI cảnh báo rõ. Nếu sai, Admin phải xử lý gỡ tay.

### MFO-CL-20B. Chế độ 2 – Gắn nhánh con (ATTACH_CHILD)
Nút cao nhất của cây nhỏ là **con** của điểm neo.
- **Xử lý Đa thê & Khuyết danh:** Admin phải chọn `union_id` (cặp vợ chồng). Nếu điểm neo Nam/Nữ chưa có bản ghi hôn nhân tương ứng, hệ thống ghi `parentages` với **`union_id = NULL`** (tuyệt đối không tự tạo Vợ/Chồng ảo).
- **Rollback (Tách cây):** Hỗ trợ tách tự động nếu chưa có dữ liệu mới phát sinh. Khi rollback, cập nhật `parentages` thành `SUPERSEDED`, hoàn cây nhỏ về `CHO_GHEP`, và Service Mapper clear `father_id`/`mother_id` về `NULL`.

---

## MFO-CL-30. Alignment với FTDI & Bằng chứng

- **Khởi tạo Chứng cứ:** Dữ liệu Onboarding Survey của EU (lưu ở cột JSON trước đó) khi ghép thành công sẽ được hệ thống tự động sinh `sources` và `citations`, gán vào `primary_citation_id` của các `parentages` mới.
- **Thừa kế LineageMembership:** Khi ghép cây nhỏ vào điểm neo, các nút thuộc cây nhỏ tự động thừa kế Chi/Phái (Lineage) của điểm neo thông qua trigger chạy ngầm tạo bản ghi `lineage_memberships`. Dữ liệu khảo sát của EU chỉ là hint, Điểm neo mới là sự thật quyết định.

---

## MFO-CL-40. Pre-MFO & Onboarding Gate

- **Hard Gate:** Mọi API tạo/truy cập MFO Canvas đều bị chặn (lỗi 403) nếu EU chưa hoàn thành Onboarding Checklist (1 lần duy nhất).
- **Checklist gồm:** Xem cây chung + Trả lời 4 câu hỏi khảo sát (Chi phái, Có thấy tổ tiên không, Đề xuất neo, Thông tin thêm). Dữ liệu này được ghim vào payload tạo cây.
- Trả lời xong $ightarrow$ Mở Canvas ngay lập tức. Không khóa chờ 7-14 ngày.

---

## MFO-CL-50. Đặc tả kỹ thuật Cốt lõi (FTDI Compliant)

### 50.1. Schema & Locking (Tuân thủ FTDI §9.2)
- Sử dụng chuẩn tên bảng: `members`, `marriages`, `parentages`.
- **Khóa Đồng thời:** Cấm dùng `FOR UPDATE`. Bắt buộc sử dụng Lock cấp độ Transaction của PostgreSQL: 
  `SELECT pg_advisory_xact_lock(hashtext('topology:' || tenant_id))` kết hợp `lock_timeout = '3s'`.

### 50.2. Dual-Write Giai đoạn G2 (Tuân thủ FTDI §4)
- Mọi action thay đổi cấu trúc (`MERGE_SMALL_TREE`, `ATTACH`, `UNLINK`, Rollback) bắt buộc phải đi qua **Service Mapper** ở Backend để ghi đồng bộ ngược lại các trường Legacy (`members.father_id`, `members.mother_id`, `members.child_type`).
- Khi UNLINK, Mapper phải reset trường legacy tương ứng về `NULL`.

### 50.3. Cycle Detection & Fail-Closed
Kiểm tra chu trình (DFS) trước khi commit. Hỗ trợ 3 trạng thái:
1. `ACYCLIC_CONFIRMED`: Cho phép ghi.
2. `CYCLE_DETECTED`: Chặn, bắn lỗi. Bắt buộc test case: "EU nhúng chính mình, sau đó Admin ghép tổ tiên của EU thành hậu duệ của EU".
3. **`VALIDATION_INCOMPLETE`**: Đồ thị quá lớn vượt ngân sách 3s $ightarrow$ **Fail-closed** (Chặn ghi). Phải xuất log chuyên biệt (dedicated log) cho trường hợp này để DevOps phân tích.

### 50.4. Bẫy Unique Constraint Deduplication
Trước khi thực thi update DB trong quá trình `MERGE_NODE`, Backend phải chủ động deduplicate để tránh lỗi văng `uq_parentage_assertion` trên `(tenant_id, parent_id, child_id, relationship_type, review_status)`. UI nên hiển thị cảnh báo phụ nếu còn vợ/chồng chưa được map rõ ràng.

### 50.5. Đời thứ & Chạy nền (Generation Recomputation)
- **Bảo lưu tương đối:** Khi điểm neo có `generation = NULL`, cây nhỏ lưu `relative_level` tại `members.metadata`. Việc thiết kế mô hình chuẩn `GenerationAssignment` là follow-up phase.
- **Event Listener (Job chạy ngầm):** Khi điểm neo có thay đổi hệ generation hợp lệ, trigger job chạy nền tính lại đời và mã `d'Aboville` cho toàn nhánh.
- **Phân quyền chạy nền:** Job chạy thuộc diện Derived Recomputation $ightarrow$ Không cần kiểm tra quyền `Edit Profile` trên hàng trăm nút con cháu.
- **Safety Cơ chế Retry:** Job chạy ngầm cần có cơ chế retry tự động (ví dụ: exponential backoff) trước khi bắn thông báo thất bại (notification) cuối cùng cho Admin, không được làm treo giao dịch chính.

---
**Chữ ký duyệt Freeze:** [Tech Lead / Product Owner]  
**Ngày hiệu lực:** 2026-11-24  
