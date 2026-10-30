# **BÁO CÁO REVIEW PHẢN BIỆN & KẾ HOẠCH ĐỒNG BỘ KIẾN TRÚC (FTD 2.0.2 vs BỘ TFD)**

---

**Dự án:** myclan.com.vn — Hệ thống Quản trị Gia phả số & Dòng họ

| Mã tài liệu | MYCLAN-FTD-TFD-ALIGNMENT-REPORT | Phiên bản | 2.0.0-FINAL (SYNCHRONIZED) |
| :---- | :---- | :---- | :---- |
| **Ngày ban hành** | 21/10/2026 | **Trạng thái** | ĐẮC TẢ KIẾN TRÚC CHÍNH THỨC BAN HÀNH |
| **Tài liệu đối chiếu** | FT-DOCTRINE-SPEC v2.0.2 & Bộ Chuẩn TFD (TFD-001 \-\> TFD-601) | **Phạm vi Engine** | Family Tree Core Engine, Database & API Contracts |

## **1\. TÓM TẮT KẾT QUẢ REVIEW PHẢN BIỆN**

---

Hội đồng Kiến trúc đã hoàn tất đối chiếu giữa **FT-DOCTRINE-SPEC v2.0.2-draft** (Quy chuẩn Engine Kỹ thuật & Graph Domain) và **Bộ chuẩn TFD-001 \-\> TFD-601** (Quy chuẩn Khoa học Gia phả, Chứng cứ & Tộc ước Việt Nam). Kết luận nhất quán: **Không loại bỏ tài liệu nào, không thay thế bộ này bằng bộ kia. Thực hiện Tích hợp Đồng bộ theo Lớp (Layered Architecture Alignment)**.

**Mô hình Tích hợp Kiến trúc chuẩn:**

* **FT-DOCTRINE-SPEC 2.0.2:** Đóng vai trò Đặc tả Kỹ thuật cho Graph Engine, Algorithm, Concurrency Control, Projection & Impact-based RBAC.  
* **Bộ Chuẩn TFD (001 \-\> 601):\*\* Đóng vai trò Quy chuẩn Nội dung Nghiệp vụ, Khoa học Chứng cứ (Source/Citation/Assertion), Quy tắc Tộc ước Chi phái Việt Nam & Bộ Test Nghiệm thu Tuân thủ.**

## **2\. GIẢI QUYẾT 7 VẤN ĐỀ TRỌNG YẾU (P1 \-\> P7)**

### ---

**P1 — Thống nhất Claim (FT) với Mô hình Chứng cứ (TFD)**

**Quy định Hợp đồng Ngữ nghĩa 5 Lớp giữa hai hệ thống khái niệm:**

* **Source / Citation (TFD) ⇔ Nguồn tư liệu & Vị trí trích dẫn cụ thể.**  
* **Claim / Assertion (FT/TFD) ⇔ Khẳng định dữ liệu cụ thể về cá nhân, sự kiện hoặc quan hệ.**  
* **EvidenceAssessment (TFD) ⇔ Đánh giá độ tin cậy chứng cứ (Lưu qua certainty và note).**  
* **review\_status (FT) ⇔ Vòng đời phê duyệt (PROPOSED, ACCEPTED, DISPUTED, REJECTED, SUPERSEDED).**  
* **Conclusion / SelectionPolicy (TFD/FT) ⇔ Quyết định chọn thông tin nào để vẽ Cây chính.**

### **P2 — Cơ chế SelectionPolicy cho Cây Chính**

**Cây chính (Primary Tree) chỉ lấy bản ghi parentages thỏa mãn: review\_status \= ACCEPTED VÀ is\_selected\_for\_lineage \= TRUE. Nếu có nhiều Assertion mâu thuẫn cùng ở trạng thái ACCEPTED nhưng chưa có SelectionPolicy giải quyết → Engine chuyển nút sang trạng thái UNRESOLVED\_CONFLICT và báo cảnh báo, tuyệt đối không tự ý chọn bản ghi nhập sau cùng.**

### **P3 — Đồng bộ Danh mục Quan hệ (Parentage vs Relationship)**

**Bảng parentages giữ 4 loại cốt lõi cho Engine vẽ cây V1 (BIOLOGICAL, ADOPTIVE, FOSTER, STEPCHILD). Các loại quan hệ mở rộng theo TFD-102 (Pháp lý, Giám hộ, Kế dưỡng, Quan hệ Xã hội) được quản lý qua bảng Catalog ánh xạ phụ relationship\_type\_catalog.**

### **P4 — Tách bạch Branch (RBAC) và Lineage (Tộc ước Việt Nam)**

* **branches (System Scope): Quản lý Cấu trúc Phân quyền Biên tập (Scope cấp quyền \`BranchEditor\`).**  
* **lineages / lineage\_memberships (TFD-201): Quản lý Danh vị Tộc ước (Chi trưởng, Chi thứ, Thứ bậc truyền thừa gia tộc). Hai khái niệm này có vòng đời độc lập.**

### **P5 — Hợp đồng Dữ liệu Lịch & Ngày tháng (\`GenealogicalDate\`)**

**Mọi sự kiện và ngày tháng tuân thủ TFD-103: Không ép ngày lịch sử thành Unix timestamp; giữ nguyên văn bản gốc (\`original\_text\`); quy đổi Âm \- Dương nhuận phải lưu vết \`conversion\_metadata\` (bao gồm engine version và timezone assumption).**

### **P6 — Tích hợp Concurrency & Topology Tests vào TFD-601**

**Bổ sung Chương 7 vào bộ TFD-601 với 10 ca Fixture bắt buộc (FIX-01 \-\> FIX-10) về Race condition, Advisory Lock, Fail-Closed Timeout, Multiple Occurrences và Cross-tenant Isolation.**

### **P7 — Ban hành Sổ Quyết định Chung (Master Decision Register)**

**Thống nhất quản lý toàn bộ các quyết định D01-D18 (FT) và các mốc TFD trong file DECISION-REGISTER.md dùng chung cho toàn bộ dự án.**

## **3\. BẢNG MAPPING NGỮ NGHĨA MASTER (MASTER MAPPING MATRIX)**

---

                                                              

| Khái niệm FT-DOCTRINE 2.0.2 | Khái niệm Bộ Chuẩn TFD | Model CSDL Target (Prisma) | Quy tắc Vận hành Engine |
| :---- | :---- | :---- | :---- |
| **Person** | **Cá nhân / Nhân khẩu** | **members** | **Định danh UUID không đổi; độc lập với vai trò gia đình.** |
| **Union** | **Bối cảnh Kết đôi / Gia đình** | **marriages** | **Bối cảnh ghép đôi hàng ngang; không mặc định chứng minh hôn nhân pháp lý.** |
| **Parentage** | **Quan hệ Cha/Mẹ \- Con** | **parentages** | **Sợi dây nối dọc 1-1; chứa \`relationship\_type\` & \`union\_id\` tùy chọn.** |
| **Claim / Assertion** | **Khẳng định Tư liệu** | **review\_status trên parentages** | **Lưu vết mâu thuẫn lịch sử (PROPOSED, DISPUTED, ACCEPTED).** |
| **SelectionPolicy** | **Kết luận Sử học (Conclusion)** | **Cấu hình SelectionPolicy** | **Quyết định Assertion nào được chọn để vẽ lên Cây chính.** |
| **Branch (RBAC)** | **Phạm vi Phân quyền Biên tập** | **branches** | **Quản lý quyền BranchEditor; không ép làm cấu trúc Chi phái văn hóa.** |
| **Lineage (Cultural)** | **Chi / Phái / Dòng truyền thừa** | **lineage\_memberships (TFD-201)** | **Quản lý danh vị Tộc ước (Chi trưởng, Chi thứ, Thứ bậc truyền thừa).** |
| **Advisory Lock** | **Khóa An toàn Đồ thị** | **pg\_advisory\_xact\_lock** | **Khóa luồng ghi theo Tenant ID khi có Mutation cấu trúc cây.** |
| **Fail-Closed** | **Bảo vệ Bất biến Đồ thị** | **VALIDATION\_INCOMPLETE** | **TỪ CHỐI COMMIT khi Cycle Check quá giờ hoặc vượt ngân sách duyệt nút.** |

## **4\. TARGET PRISMA SCHEMA REFACTORED (SSOT)**

---

**`// =============================================================================`**  
**`// PARENTAGES MODEL - ĐÃ ĐỒNG BỘ NGHĨA VỚI TFD-101 / TFD-103 / FTD-2.0.2`**  
**`// =============================================================================`**

**`model parentages {`**  
  **`id                String              @id @default(dbgenerated("(gen_random_uuid())::text")) @db.VarChar(36)`**  
  **`tenant_id         String              @db.VarChar(36)`**  
    
  **`parent_id         String              @db.VarChar(36)`**  
  **`child_id          String              @db.VarChar(36)`**  
    
  **`/// Loại quan hệ: BIOLOGICAL (Con đẻ), ADOPTIVE (Con nuôi), FOSTER (Con nuôi dưỡng), STEPCHILD (Con riêng)`**  
  **`relationship_type parentage_type      @default(BIOLOGICAL)`**  
    
  **`/// Bối cảnh kết đôi / gia đình (Tùy chọn - NULL nếu đơn thân hoặc chưa rõ)`**  
  **`union_id          String?             @db.VarChar(36)`**  
    
  **`/// Trạng thái khẳng định (Assertion/Claim Lifecycle)`**  
  **`review_status     claim_review_status @default(ACCEPTED)`**  
    
  **`/// Đánh giá chứng cứ (EvidenceAssessment Certainty: 0.00 -> 1.00)`**  
  **`certainty         Decimal?            @db.Decimal(3, 2)`**  
    
  **`/// Cờ phục vụ SelectionPolicy: Cho biết Assertion này có được chọn vẽ Cây chính không`**  
  **`is_selected_for_lineage Boolean       @default(true)`**  
    
  **`note              String?             @db.VarChar(500)`**  
    
  **`created_at        DateTime?           @default(now()) @db.Timestamptz(6)`**  
  **`updated_at        DateTime?           @default(now()) @updatedAt @db.Timestamptz(6)`**  
  **`changed_by        String?             @db.VarChar(36)`**  
  **`deleted_at        DateTime?           @db.Timestamptz(6)`**

  **`// ---------------------------------------------------------------------------`**  
  **`// COMPOSITE FOREIGN KEYS (CHẶN CROSS-TENANT AT DB LEVEL)`**  
  **`// ---------------------------------------------------------------------------`**  
  **`tenants           tenants             @relation(fields: [tenant_id], references: [id], onDelete: Restrict, map: "fk_parentage_tenant")`**  
  **`parent            members             @relation("ParentageAsParent", fields: [tenant_id, parent_id], references: [tenant_id, id], onDelete: Restrict, map: "fk_parentage_parent_composite")`**  
  **`child             members             @relation("ParentageAsChild", fields: [tenant_id, child_id], references: [tenant_id, id], onDelete: Restrict, map: "fk_parentage_child_composite")`**  
  **`union             marriages?          @relation("UnionToParentages", fields: [union_id], references: [id], onDelete: SetNull, map: "fk_parentage_union")`**  
  **`modifier          users?              @relation("ParentageModifier", fields: [changed_by], references: [id], onDelete: NoAction, map: "fk_parentage_user")`**

  **`// ---------------------------------------------------------------------------`**  
  **`// CONSTRAINTS & INDEXES`**  
  **`// ---------------------------------------------------------------------------`**  
  **`@@unique([tenant_id, parent_id, child_id, relationship_type, review_status], map: "uq_parentage_assertion")`**  
  **`@@index([tenant_id], map: "idx_parentage_tenant")`**  
  **`@@index([parent_id], map: "idx_parentage_parent")`**  
  **`@@index([child_id], map: "idx_parentage_child")`**  
  **`@@index([union_id], map: "idx_parentage_union")`**  
  **`@@index([tenant_id, child_id, review_status, is_selected_for_lineage], map: "idx_parentage_tree_lookup")`**  
  **`@@index([deleted_at], map: "idx_parentage_deleted_at")`**  
  **`@@map("parentages")`**  
**`}`**

**`enum parentage_type {`**  
  **`BIOLOGICAL`**  
  **`ADOPTIVE`**  
  **`FOSTER`**  
  **`STEPCHILD`**  
  **`OTHER`**  
**`}`**

**`enum claim_review_status {`**  
  **`PROPOSED`**  
  **`ACCEPTED`**  
  **`DISPUTED`**  
  **`REJECTED`**  
  **`SUPERSEDED`**  
**`}`**

## **5\. KẾ HOẠCH HÀNH ĐỘNG TRIỂN KHAI (ACTION PLAN)**

1. ---

   **Bước 1: Ban hành file DECISION-REGISTER.md chốt toàn bộ danh mục D01-D18 và TFD Mappings.**  
2. **Bước 2: Áp dụng Prisma Schema Refactored (bổ sung model parentages) trên nhánh feature/ftd-tfd-core-engine.**  
3. **Bước 3: Cập nhật Backend Engine (NestJS/Express) cài đặt PostgreSQL Advisory Lock, Cycle Detection Engine 3 trạng thái và SelectionPolicy.**  
4. **Bước 4: Bổ sung Chương 7 (Topology Safety Tests) vào file TFD-601 và thực thi 10 bài test Fixtures.**  
5. **Bước 5: Tiến hành Cutover dữ liệu Staging/Dev (Phương án A Clean Bootstrap) và chuẩn bị Go-live.**