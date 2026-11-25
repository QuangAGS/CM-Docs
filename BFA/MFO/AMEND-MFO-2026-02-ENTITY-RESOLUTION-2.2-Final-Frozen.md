# AMEND-MFO-2026-02-ENTITY-RESOLUTION

**Phiên bản:** 2.2 (Multi-Source Generation - Hardened Edition)  
**Ngày cập nhật:** 2026-11-25  
**Trạng thái:** CHÍNH THỨC BAN HÀNH (APPROVED FOR PHASE 1)  
**Mã tài liệu:** AMEND-MFO-2026-02  

**Tài liệu quy chiếu:**
- AMEND-MFO-2026-01-CANVAS-LINK-EXISTING (v5.4 Final Frozen)
- PLAN-MFO-2026-IMPLEMENTATION (v2.2)
- TFD-CORE-APPROVAL-1.0.0
- FTDI-PRACTICAL-SPEC-1.0.4-Final

## Ghi chú: Vì sao v2.2 này là Phase 1?
Phase 1 tập trung vào **“động cơ”** — khả năng hợp nhất an toàn, di dời trực hệ và bảo vệ dữ liệu đời đa nguồn.
* **Tách biệt rủi ro:** Gộp thực thể là thay đổi đồ thị nguy hiểm. Có DFS Guard, Advisory Lock, và Transaction ACID.
* **Xử lý Đời Đa nguồn:** Tích hợp di dời an toàn `member_generation_assertions`, xử lý xung đột trùng khóa và cảnh báo mềm cho Datum Offset. Phân xử tranh chấp sâu (Phase 2).

---

## MFO-ER-00. Business Context & Vấn đề

### MFO-ER-00.1 Bối cảnh phát sinh
Một cá nhân thực tế tồn tại dưới 2 bản ghi `members` độc lập do các chi khác nhau nhập liệu. Hệ thống cần hợp nhất để tránh phân mảnh dữ liệu mà không làm mất số đời nguyên bản của từng cuốn phả.

### MFO-ER-00.2 Khác biệt với MERGE_NODE (AMEND-MFO-2026-01)
- `MERGE_NODE`: Gộp nút gốc cây nháp vào điểm neo.
- **Entity Resolution:** Gộp hai bản ghi đã có hệ sinh thái riêng (vợ/chồng, con cái, chứng cứ). Phức tạp và rủi ro cao hơn nhiều.

---

## MFO-ER-01. Phân loại 4 Kịch bản Nghiệp vụ

| Mã | Kịch bản | Mô tả thực tế | Cách xử lý trên đồ thị |
| :--- | :--- | :--- | :--- |
| **ER-S1** | **Hôn nhân nội tộc** | Nữ ở Chi 1 là vợ ông nam ở Chi 2. | Gộp 1 member; giữ 2 vai trò. Hiển thị Đa vị trí. |
| **ER-S2** | **Con đẻ / Con nuôi** | Con đẻ Chi 1, con nuôi Chi 2. | Gộp 1 member; giữ cả 2 `parentages` (khác loại). |
| **ER-S3** | **Trùng lặp thật** | Hai nhánh nhập trùng 1 người và con. | Gộp 1 member; **Deduplicate** (`SUPERSEDED`) các cạnh thừa. |
| **ER-S4** | **Tranh chấp** | Nhánh 1 khai cha A, Nhánh 2 khai cha B. | Gộp 1 member; giữ cả 2 `parentages BIOLOGICAL` ở `DISPUTED`. |

---

## MFO-ER-10. Quy tắc Sống sót & Xử lý Trùng Account

Khi hợp nhất, chọn 1 bản ghi làm **X_target** (sống sót) và đóng băng **X_source**.
1. **Liên kết tài khoản (`users.member_id`):** Bản ghi có tài khoản bắt buộc là `X_target`. Nếu cả 2 đều gắn user khác nhau $\rightarrow$ **Chặn gộp tự động** (Dual-Account Guard).
2. **Đóng băng & Redirect:** `X_source` được gán `deleted_at = NOW()` và `merged_into_id = X_target.id`. Middleware hỗ trợ redirect đệ quy tối đa 10 cấp.

---

## MFO-ER-20. Thuật toán Chuyển hướng Cạnh & Vệ tinh

Giới hạn trong 1 Transaction ACID: Re-wire trực hệ, vệ tinh tự động bám theo.

### MFO-ER-20.1 Ma trận xử lý Cạnh
* **Vợ/Chồng trùng:** Gộp 2 `marriages`, chuyển con về marriage giữ lại.
* **Con trùng cha/mẹ `BIOLOGICAL`:** Đánh `SUPERSEDED` cạnh thừa, thực hiện chèn mới và update trong **cùng 1 Transaction** chống lỗi Unique Constraint.

### MFO-ER-20.2 Di dời Vệ tinh & Kiến trúc Đời Đa nguồn
* **Chứng cứ & Tên:** Chuyển về `X_target`.
* **Di dời `member_generation_assertions`:**
  * Toàn bộ Assertions của `X_source` được chuyển sang `X_target` trong cùng Transaction.
  * **Trùng `source_id` (khác `citation_id`):** Giữ cả hai bản ghi để bảo toàn dị bản, không tự động gắn `DISPUTED` trong Phase 1.
  * **Trùng cả `source_id` và `citation_id` nhưng khác `claimed_generation`:** Backend tự động đổi `citation_id` của bản ghi thuộc `X_source` sang `SYS_CIT::CONFLICT_MERGE::<source_assertion_id>` (đồng thời ghi nhận `citation_id` gốc vào audit/note dị bản) trước khi cập nhật `member_id = X_target.id`, giữ cả hai bản ghi và tránh lỗi vi phạm Unique Constraint.
* **Cảnh báo mềm (Soft-Warning):** Đối chiếu $\text{Calibrated\_Gen} = \text{claimed\_generation} + \text{root\_generation\_offset}$. Lệch mốc chỉ bắn cảnh báo mềm (`SOFT_WARNING`) trên UI Wizard của Admin.

---

## MFO-ER-30. Mid-Tree Merge & Vòng đời Cây nhỏ

Khi nút trùng nằm ở giữa một cây nhỏ `CHO_GHEP`:
1. **Hạ lưu:** Gắn vào `X_target`. Cây nhỏ thành `DA_GHEP`.
2. **Thượng lưu (Mid-tree Split):** Cắt rời, sinh ID cây nhỏ mới do Admin sở hữu (`is_admin_owned = true`). Đặt lại `relative_level = 1` ở gốc.

---

## MFO-ER-40. Safety Guards & Bẫy Kỹ thuật

1. **Khóa A01:** Guard `GENDER_MISMATCH` chặn gộp khác giới tính.
2. **Khóa Đồng thời:** `pg_advisory_xact_lock` theo tenant + timeout 3s.
3. **Cycle Detection (Fail-Closed):** Dry-Run (Preview) và Commit-Time. Quét mọi cạnh `ACCEPTED` (không lọc `is_selected_for_lineage`). Bắn `CYCLE_DETECTED`.
4. **Dual-Write G2:** Re-wire đi qua Service Mapper bảo vệ OP cũ.

---

## MFO-ER-50. UI Wizard & Hướng dẫn Rollback

### UI Wizard
Wizard so sánh 2 cột, hỗ trợ ánh xạ thủ công và Preview (Dry-run). Hiển thị cảnh báo mềm (`SOFT_WARNING`) khi phát hiện lệch mốc theo `root_generation_offset`. Frontend tự động tính đời hiển thị từ `parentages.metadata.relative_level`, ẩn các cạnh `DISPUTED`.

### Rollback (Thủ công)
Admin thực hiện gỡ tay theo trình tự:
1. Khôi phục `X_source`: `deleted_at = NULL`, `merged_into_id = NULL`.
2. Tra cứu ChangeLog của transaction gộp nhầm để lấy danh sách ID `parentages`/`marriages` bị chuyển hướng và phục hồi trạng thái `SUPERSEDED`.
3. **Phục hồi `member_generation_assertions`:** Chuyển các bản ghi assertions đã di dời/đổi tên từ `X_target` trả lại `member_id = X_source.id`, gỡ tiền tố `SYS_CIT::CONFLICT_MERGE::` và khôi phục `citation_id` gốc theo audit log.
4. **Gọi Service Mapper** đồng bộ lại `father_id`/`mother_id` cho OP cũ và trigger Job `GenerationRecomputation` sau rollback.

**Chữ ký duyệt Freeze Phase 1:** [Tech Lead / Product Owner]  
**Ngày hiệu lực:** 2026-11-25