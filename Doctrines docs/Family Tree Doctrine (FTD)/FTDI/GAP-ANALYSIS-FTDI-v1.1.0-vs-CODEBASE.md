# Báo cáo Phân tích Gap chi tiết v1.1.0
## FTDI-Practical-Spec v1.0.4 vs Codebase hiện tại (BE + Schema)

**Dự án:** myclan.com.vn  
**Ngày:** 2026-10-30  
**Phiên bản:** 1.1.0  
**Nguồn đối chiếu:**  
- FTDI-PRACTICAL-SPEC-1.0.4  
- Repo: https://github.com/QuangAGS/cmcodes  
- Schema: `Backend/prisma/schema.prisma`  
- Modules liên quan: `members`, `mfo`  

**Thay đổi so với bản trước:**  
Chốt Phương án B cho GAP-09. Bổ sung bảng mapping `child_type` → `parentage_type`. Làm rõ dual-write trong `executeGate2DbMutation` và điều kiện Advisory Lock.

---

## 1. Tóm tắt điều hành

Codebase hiện tại vẫn dùng **adjacency list** (`father_id` / `mother_id` trên `members`) làm nguồn sự thật quan hệ cha/mẹ–con.  

**Không tồn tại** bảng `parentages`, `sources`, `citations`, `evidence_links`.  

Đây là khoảng cách lớn nhất so với FTDI-Practical-Spec v1.0.4.  

Các luồng RP / OP / Login đã CLOSED không bị ảnh hưởng nếu tuân thủ chiến lược Progressive Cutover.

---

## 2. Bảng Gap tổng hợp (cập nhật)

| Mã GAP | Yêu cầu FTDI v1.0.4 | Hiện trạng (Schema + Code) | Mức độ | Quyết định / Hành động |
|--------|---------------------|----------------------------|--------|------------------------|
| **GAP-01** | Bảng `parentages` độc lập là nguồn sự thật quan hệ | Không có model `parentages`. Quan hệ nằm trên `members.father_id` / `mother_id` | **P0** | Tạo bảng + migration G0/G1 |
| **GAP-02** | `relationship_type` riêng trên từng quan hệ cha–con | Chỉ có `members.child_type` (enum: CON_DE, CON_NUOI, …) gắn vào bản ghi con | **P0** | Dùng bảng mapping dưới đây khi dual-write / G1 |
| **GAP-03** | `union_id` tùy chọn trên Parentage | Có `members.parent_union_id` trỏ tới `marriages` | **P1** | Chuyển thành trường optional trên `parentages` |
| **GAP-04** | `review_status` + `is_selected_for_lineage` trên quan hệ | Không có. Không hỗ trợ Claim / SelectionPolicy | **P0** | Thêm vào bảng `parentages` |
| **GAP-05** | Source / Citation / Evidence | Không có model `sources`, `citations`, `evidence_links` | **P1** | Tạo cấu trúc tối thiểu theo Spec §5 |
| **GAP-06** | Cycle Detection fail-closed + Advisory Lock | Không có trong code hiện tại (chỉ có `branchCycle.js` cho chi) | **P0** | Triển khai theo Spec §9 + điều kiện dưới đây |
| **GAP-07** | Dual-write khi MFO Gate 2 | `mfo.gate2.js` + `mfo.service.js` ghi trực tiếp vào `members` | **P0** | Sửa `executeGate2DbMutation` theo kịch bản §4.3 |
| **GAP-08** | Service Mapper cho OP (không dùng Trigger) | OP ghi trực tiếp `father_id`/`mother_id` | **P1** | Thêm Mapper ở tầng Service (không sửa logic OP cốt lõi) |
| **GAP-09** | Composite FK hoặc unique `(tenant_id, id)` trên `members` | `members` chỉ có `@id id`. Không có `@@unique([tenant_id, id])` | **P1** | **Chốt Phương án B** (FK đơn + validate tenant ở Service) |
| **GAP-10** | Primary Tree đọc từ SelectionPolicy | Tree hiện đọc từ `father_id`/`mother_id` (xem `getMemberTree`) | **P0** | Chuyển sang đọc `parentages` sau G3 |
| **GAP-11** | Event là nguồn sự thật ngày sinh/mất | Ngày nằm rải trên `members` (`birth_day/month/year`, …) | **P2** | Có thể để sau; không blocking V1 |
| **GAP-12** | LineageMembership tách khỏi Branch RBAC | `branches` hiện dùng cho cả cấu trúc và phân quyền | **P2** | Không blocking giai đoạn đầu |

---

## 3. Quyết định kỹ thuật đã chốt

### 3.1 GAP-09 — Phương án B (FK đơn)

**Chốt:** Dùng khóa ngoại đơn trên `parentages`:

```prisma
parent members @relation("ParentageAsParent", fields: [parent_id], references: [id], onDelete: Restrict)
child  members @relation("ParentageAsChild",  fields: [child_id],  references: [id], onDelete: Restrict)
```

**Lý do:**
- Không cần thêm `@@unique([tenant_id, id])` trên bảng `members` (tránh rủi ro lock bảng lớn).
- Ràng buộc cùng tenant (`parent.tenant_id == child.tenant_id == parentage.tenant_id`) được kiểm tra triệt để ở tầng Service / Mutation Guard.

### 3.2 GAP-02 — Bảng mapping `child_type` → `parentage_type`

Áp dụng cho cả script G1 và dual-write G2:

| `members.child_type` | `parentages.relationship_type` | Ghi chú |
|----------------------|--------------------------------|---------|
| `CON_DE`             | `BIOLOGICAL`                   | Con đẻ |
| `CON_NUOI`           | `ADOPTIVE`                     | Con nuôi |
| `CON_DO_DAU`         | `FOSTER`                       | Con đỡ đầu |
| `CON_RIENG`          | `STEPCHILD`                    | Con riêng |
| `KHAC`               | `OTHER`                        | Khác |
| `CON_DAU`            | **Không tạo parentage**        | Quan hệ phối ngẫu (dâu) |
| `CON_RE`             | **Không tạo parentage**        | Quan hệ phối ngẫu (rể) |

### 3.3 GAP-07 — Dual-write trong `executeGate2DbMutation`

Khi Admin bấm “Duyệt và ghi sổ” ở Gate 2, thực hiện **trong cùng một transaction**:

1. **Bước 1 (giữ tương thích):** Tạo/cập nhật `members` như hiện tại (ghi `father_id`, `mother_id`, `child_type`).
2. **Bước 2 (mới):**  
   - Nếu có `father_id` → tạo 1 record `parentages` (cha–con).  
   - Nếu có `mother_id` → tạo 1 record `parentages` (mẹ–con).  
   - Gán: `review_status = 'ACCEPTED'`, `is_selected_for_lineage = true`, `union_id = parent_union_id || null`.  
   - Map `child_type` theo bảng ở §3.2.

### 3.4 GAP-06 — Advisory Lock

Khi gọi `SELECT pg_advisory_xact_lock(...)` **bắt buộc**:

- Nằm trong Database Transaction (`BEGIN ... COMMIT`).
- Có `SET LOCAL lock_timeout = '3s'`.
- Nếu timeout → fail-closed, không treo worker Express.

```sql
BEGIN;
SET LOCAL lock_timeout = '3s';
SELECT pg_advisory_xact_lock(hashtext('topology:' || tenant_id));
-- Validate + ghi dữ liệu + audit
COMMIT;
```

---

## 4. Chi tiết Schema hiện tại (trích yếu)

### 4.1 Model `members` (nguồn sự thật hiện tại)

Các trường genealogy chính:

- `father_id` → quan hệ cha
- `mother_id` → quan hệ mẹ
- `child_type` (enum `members_child_type`: CON_DE, CON_NUOI, CON_RIENG, KHAC, CON_DAU, CON_RE, CON_DO_DAU)
- `sibling_seq`
- `parent_union_id` → trỏ tới `marriages`
- `generation`
- Ngày sinh/mất dạng rời (`birth_day`, `birth_month`, `birth_year`, `is_birth_lunar`, …)

**Không có** `@@unique([tenant_id, id])`.

### 4.2 Model `marriages`

- `husband_id`, `wife_id`
- Có relation `children_from_union` qua `parent_union_id` trên `members`
- Phù hợp làm `union_id` optional trên `parentages`

### 4.3 Các model chưa tồn tại

- `parentages`
- `sources`
- `citations`
- `evidence_links`

---

## 5. Chi tiết Code liên quan

### 5.1 Module MFO

- Path: `Backend/src/modules/mfo/`
- File chính: `mfo.gate2.js`, `mfo.service.js`
- Hàm quan trọng: `executeGate2DbMutation`
- Hiện tại: tạo/cập nhật `members` và gán `father_id`/`mother_id` trực tiếp
- **Cần sửa:** dual-write theo kịch bản §3.3

### 5.2 Module Members

- Path: `Backend/src/modules/members/`
- Có `getMemberTree` (đọc cây từ adjacency list)
- Có `branchCycle.js` (chỉ cho chi, không phải cây gia phả)

### 5.3 Onboarding / RP / Login

- Không bị ảnh hưởng nếu tuân thủ Progressive Cutover.
- OP hiện ghi vào `father_id`/`mother_id` → cần Mapper đồng bộ (không sửa logic OP đã CLOSED).

---

## 6. Khuyến nghị hành động ưu tiên (đã chốt)

### Ưu tiên P0 (làm trước)

1. **G0:** Tạo migration bảng `parentages` + enums (`parentage_type`, `claim_review_status`).  
   → Dùng **Phương án B** (FK đơn).
2. **G1:** Viết script migration chuyển dữ liệu `father_id`/`mother_id` hiện có → `parentages`, áp dụng bảng mapping §3.2.
3. Sửa `executeGate2DbMutation` (MFO Gate 2) để dual-write theo §3.3.
4. Triển khai Cycle Detection fail-closed + Advisory Lock (có `lock_timeout`).
5. Chuyển `getMemberTree` sang đọc từ `parentages` + SelectionPolicy.

### Ưu tiên P1

6. Tạo cấu trúc tối thiểu `sources` / `citations` / `evidence_links`.
7. Thêm Service Mapper cho OP (không dùng Trigger).

### Ưu tiên P2 (sau)

8. Event–GenealogicalDate đầy đủ.
9. Tách LineageMembership khỏi Branch.

---

## 7. Rủi ro và lưu ý

| Rủi ro | Mức | Biện pháp |
|--------|-----|-----------|
| Gãy dữ liệu test/smoke hiện có | Cao | Bắt buộc chạy script G1 trước khi đọc từ `parentages` |
| Gãy OP đã UAT | Trung bình | Giữ cột legacy + Mapper, không sửa logic OP |
| Lỗi migrate vì thiếu unique `(tenant_id, id)` | Thấp | Đã chốt Phương án B — không cần unique composite |
| Race condition tạo cycle | Cao | Phải có Advisory Lock + `lock_timeout` + fail-closed |
| Mapping sai `CON_DAU`/`CON_RE` | Trung bình | Không tạo parentage cho hai giá trị này |

---

## 8. Kết luận

Khoảng cách chính nằm ở **mô hình quan hệ**.  

Codebase hiện tại vẫn là adjacency list thuần túy. FTDI-Practical-Spec v1.0.4 yêu cầu chuyển sang bảng `parentages` độc lập + SelectionPolicy + truy nguyên nguồn.

Các quyết định kỹ thuật trong bản v1.1.0 đã đủ để bắt đầu viết schema G0 và script G1.

**Bước tiếp theo đề xuất:**  
1. Chốt Phương án B (đã làm).  
2. Viết Prisma schema cho `parentages`, `sources`, `citations`, `evidence_links`.  
3. Sinh migration SQL G0.  
4. Viết script SQL G1 backfill `father_id`/`mother_id` → `parentages`.

---

*Báo cáo này dựa trên schema và cấu trúc code tại thời điểm 2026-10-30. Cần đối chiếu lại nếu có thay đổi gần đây trên nhánh main của `cmcodes`.*
