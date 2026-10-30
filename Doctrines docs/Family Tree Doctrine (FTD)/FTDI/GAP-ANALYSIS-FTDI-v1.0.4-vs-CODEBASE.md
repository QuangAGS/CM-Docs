# Báo cáo Phân tích Gap chi tiết
## FTDI-Practical-Spec v1.0.4 vs Codebase hiện tại (BE + Schema)

**Dự án:** myclan.com.vn  
**Ngày:** 2026-10-30  
**Nguồn đối chiếu:**  
- FTDI-PRACTICAL-SPEC-1.0.4  
- Repo: https://github.com/QuangAGS/cmcodes  
- Schema: `Backend/prisma/schema.prisma`  
- Modules liên quan: `members`, `mfo`  

---

## 1. Tóm tắt điều hành

Codebase hiện tại vẫn dùng **adjacency list** (`father_id` / `mother_id` trên `members`) làm nguồn sự thật quan hệ cha/mẹ–con.  

**Không tồn tại** bảng `parentages`, `sources`, `citations`, `evidence_links`.  

Đây là khoảng cách lớn nhất so với FTDI-Practical-Spec v1.0.4.  

Các luồng RP / OP / Login đã CLOSED không bị ảnh hưởng nếu tuân thủ chiến lược Progressive Cutover đã quy định trong v1.0.4.

---

## 2. Bảng Gap tổng hợp

| Mã GAP | Yêu cầu FTDI v1.0.4 | Hiện trạng (Schema + Code) | Mức độ | Ghi chú / Hành động |
|--------|---------------------|----------------------------|--------|---------------------|
| **GAP-01** | Bảng `parentages` độc lập là nguồn sự thật quan hệ | Không có model `parentages`. Quan hệ nằm trên `members.father_id` / `mother_id` | **P0** | Tạo bảng + migration G0/G1 |
| **GAP-02** | `relationship_type` riêng trên từng quan hệ cha–con | Chỉ có `members.child_type` (enum: CON_DE, CON_NUOI, CON_RIENG, …) gắn vào bản ghi con | **P0** | Map sang `parentage_type` khi dual-write |
| **GAP-03** | `union_id` tùy chọn trên Parentage | Có `members.parent_union_id` trỏ tới `marriages` | **P1** | Chuyển thành trường optional trên `parentages` |
| **GAP-04** | `review_status` + `is_selected_for_lineage` trên quan hệ | Không có. Không hỗ trợ Claim / SelectionPolicy | **P0** | Thêm vào bảng `parentages` |
| **GAP-05** | Source / Citation / Evidence | Không có model `sources`, `citations`, `evidence_links` | **P1** | Tạo cấu trúc tối thiểu theo Spec §5 |
| **GAP-06** | Cycle Detection fail-closed + Advisory Lock | Không có trong code hiện tại (chỉ có `branchCycle.js` cho chi) | **P0** | Triển khai theo Spec §9 |
| **GAP-07** | Dual-write khi MFO Gate 2 | `mfo.gate2.js` + `mfo.service.js` ghi trực tiếp vào `members` | **P0** | Sửa `executeGate2DbMutation` để dual-write |
| **GAP-08** | Service Mapper cho OP (không dùng Trigger) | OP ghi trực tiếp `father_id`/`mother_id` | **P1** | Thêm Mapper ở tầng Service (không sửa logic OP cốt lõi) |
| **GAP-09** | Composite FK hoặc unique `(tenant_id, id)` trên `members` | `members` chỉ có `@id id`. Không có `@@unique([tenant_id, id])` | **P1** | Chọn Phương án A hoặc B theo Spec §6.1 |
| **GAP-10** | Primary Tree đọc từ SelectionPolicy | Tree hiện đọc từ `father_id`/`mother_id` (xem `getMemberTree`) | **P0** | Chuyển sang đọc `parentages` sau G3 |
| **GAP-11** | Event là nguồn sự thật ngày sinh/mất | Ngày nằm rải trên `members` (`birth_day/month/year`, `is_birth_lunar`…) | **P2** | Có thể để sau; không blocking V1 |
| **GAP-12** | LineageMembership tách khỏi Branch RBAC | `branches` hiện dùng cho cả cấu trúc và phân quyền | **P2** | Không blocking giai đoạn đầu |

---

## 3. Chi tiết Schema hiện tại (trích yếu)

### 3.1 Model `members` (nguồn sự thật hiện tại)

Các trường genealogy chính:

- `father_id` → quan hệ cha
- `mother_id` → quan hệ mẹ
- `child_type` (enum `members_child_type`: CON_DE, CON_NUOI, CON_RIENG, KHAC, CON_DAU, CON_RE, CON_DO_DAU)
- `sibling_seq`
- `parent_union_id` → trỏ tới `marriages`
- `generation`
- Ngày sinh/mất dạng rời (`birth_day`, `birth_month`, `birth_year`, `is_birth_lunar`, …)

**Không có** `@@unique([tenant_id, id])`.

### 3.2 Model `marriages`

- `husband_id`, `wife_id`
- Có relation `children_from_union` qua `parent_union_id` trên `members`
- Phù hợp làm `union_id` optional trên `parentages`

### 3.3 Các model chưa tồn tại

- `parentages`
- `sources`
- `citations`
- `evidence_links`

---

## 4. Chi tiết Code liên quan

### 4.1 Module MFO

- Path: `Backend/src/modules/mfo/`
- File chính: `mfo.gate2.js`, `mfo.service.js`
- Hàm quan trọng: `executeGate2DbMutation` (ghi sổ từ Staging Sheet)
- Hiện tại: tạo/cập nhật `members` và gán `father_id`/`mother_id` trực tiếp
- **Cần sửa:** dual-write sang `parentages` theo Spec §4.3

### 4.2 Module Members

- Path: `Backend/src/modules/members/`
- Có `getMemberTree` (đọc cây từ adjacency list)
- Có `branchCycle.js` (chỉ cho chi, không phải cây gia phả)

### 4.3 Onboarding / RP / Login

- Không bị ảnh hưởng nếu tuân thủ Progressive Cutover (Spec §4).
- OP hiện ghi vào `father_id`/`mother_id` → cần Mapper đồng bộ (không sửa logic OP đã CLOSED).

---

## 5. Khuyến nghị hành động ưu tiên

### Ưu tiên P0 (làm trước)

1. **G0:** Tạo migration bảng `parentages` + enums (`parentage_type`, `claim_review_status`).
2. **G1:** Viết script migration chuyển dữ liệu `father_id`/`mother_id` hiện có → `parentages` (BIOLOGICAL, ACCEPTED, selected).
3. Sửa `executeGate2DbMutation` (MFO Gate 2) để dual-write.
4. Triển khai Cycle Detection fail-closed + Advisory Lock trong service Graph.
5. Chuyển `getMemberTree` sang đọc từ `parentages` + SelectionPolicy.

### Ưu tiên P1

6. Tạo cấu trúc tối thiểu `sources` / `citations` / `evidence_links`.
7. Thêm Service Mapper cho OP (không dùng Trigger).
8. Quyết định Phương án A hoặc B cho composite FK (Spec §6.1).

### Ưu tiên P2 (sau)

9. Event–GenealogicalDate đầy đủ.
10. Tách LineageMembership khỏi Branch.

---

## 6. Rủi ro và lưu ý

| Rủi ro | Mức | Biện pháp |
|--------|-----|-----------|
| Gãy dữ liệu test/smoke hiện có | Cao | Bắt buộc chạy script G1 trước khi đọc từ `parentages` |
| Gãy OP đã UAT | Trung bình | Giữ cột legacy + Mapper, không sửa logic OP |
| Lỗi migrate vì thiếu unique `(tenant_id, id)` | Trung bình | Chọn Phương án B nếu chưa muốn thêm unique ngay |
| Race condition tạo cycle | Cao | Phải có Advisory Lock + fail-closed trước khi go-live Graph |

---

## 7. Kết luận

Khoảng cách chính nằm ở **mô hình quan hệ**.  

Codebase hiện tại vẫn là adjacency list thuần túy. FTDI-Practical-Spec v1.0.4 yêu cầu chuyển sang bảng `parentages` độc lập + SelectionPolicy + truy nguyên nguồn.

Chiến lược Progressive Cutover + Dual-write trong v1.0.4 là phù hợp và an toàn với các luồng đã CLOSED.

**Bước tiếp theo đề xuất:**  
Tạo migration G0 + script G1, sau đó sửa `executeGate2DbMutation` để dual-write.

---

*Báo cáo này dựa trên schema và cấu trúc code tại thời điểm 2026-10-30. Cần đối chiếu lại nếu có thay đổi gần đây trên nhánh main của `cmcodes`.*
