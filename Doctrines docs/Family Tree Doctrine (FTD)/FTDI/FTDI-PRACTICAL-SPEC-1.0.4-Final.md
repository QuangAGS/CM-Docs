# FTDI-Practical-Spec v1.0.4
## Đặc tả thực chiến — Family Tree Core Engine (myclan.com.vn)

**Mã tài liệu:** FTDI-PRACTICAL-SPEC-1.0.4  
**Ngày:** 2026-10-30  
**Trạng thái:** Thực chiến — Dựa trên TFD Core đã phê chuẩn  
**Nền tảng:**  
- TFD-CORE-APPROVAL-1.0.0  
- MYCLAN-FTD-TFD-ALIGNMENT-REPORT-2.0.0-FINAL  
- FT-DOCTRINE-SPEC 2.1.0-draft  
- Gap Report 1.2.0-FINAL  
- BFA-Branch-Family-Doctrine-v1.3.1 + HandOver RP/OP (CLOSED)

**Đối tượng:** Backend, Frontend, Data, AI coding agents  

> Tài liệu này là bản cô đọng để triển khai. Khi có mâu thuẫn với tài liệu gốc → ưu tiên TFD Core Approval + Alignment Report.  
> **v1.0.4:** Làm rõ 3 điểm kỹ thuật triển khai: composite FK trên `members`, chiến lược Mapper cho OP, và relation của `primary_citation_id`.

---

## 1. Mục tiêu thực chiến

Xây dựng **Family Tree Core Engine** cho myclan.com.vn với các yêu cầu bắt buộc:

1. Một người = một bản ghi `members` (không nhân bản vì nhiều vị trí hiển thị).
2. Quan hệ cha/mẹ–con được quản lý bằng bảng `parentages` độc lập (nguồn sự thật mới).
3. Hỗ trợ Claim / tranh chấp lịch sử (không ghi đè).
4. Primary Tree chỉ lấy quan hệ đã chọn theo **SelectionPolicy** có định danh.
5. Cycle detection **fail-closed** + advisory lock theo tenant.
6. Tách biệt dữ liệu gốc và projection (RenderNode/RenderEdge).
7. Tuân thủ quy tắc Việt Nam (đời, chi/phái, tên, thứ tự) theo TFD-201.
8. Mọi khẳng định quan trọng phải truy nguyên được về Source / Citation (theo TFD-301).
9. Phân biệt rõ Claim / Assertion / EvidenceAssessment / Conclusion / SelectionPolicy.
10. **Không phá vỡ** các luồng Login, Register Process (RP) và Onboarding Process (OP) đã đạt UAT và đóng pha (CLOSED).

**Phương án triển khai:** Progressive Cutover với Backward Compatibility (không Clean Bootstrap tuyệt đối).

---

## 2. Hợp đồng ngữ nghĩa (bắt buộc)

Theo FT-DOCTRINE-SPEC 2.1.0, các khái niệm sau **PHẢI** được phân biệt:

| Khái niệm | Ý nghĩa | Không được nhầm với |
|-----------|---------|---------------------|
| **Source** | Tư liệu / người cung cấp | Phát biểu cụ thể |
| **Citation** | Vị trí cụ thể trong Source | Bản thân nguồn |
| **Claim** | Phát biểu nghiệp vụ/UI có thể truy nguyên | Bằng chứng hoặc kết luận |
| **Assertion** | Mệnh đề có cấu trúc (quan hệ, sự kiện, thuộc tính) | Claim (tương đương nghiệp vụ, khác cấu trúc) |
| **EvidenceAssessment** | Đánh giá chất lượng / hỗ trợ / phản bác của chứng cứ | Trạng thái review |
| **Conclusion** | Kết luận có phạm vi, thời điểm, người chịu trách nhiệm | Giá trị hiển thị |
| **SelectionPolicy** | Quy tắc chọn Claim nào được dùng trong projection | Kết luận lịch sử tuyệt đối |

**Nguyên tắc:**
- `review_status = ACCEPTED` **không** tự đủ để chọn vào Primary Tree khi có xung đột.
- SelectionPolicy không sửa/xóa Claim, Source, Citation hoặc EvidenceAssessment gốc.
- Không gộp bốn vai trò Claim / EvidenceAssessment / Conclusion / SelectionPolicy vào một status field.

---

## 3. Mô hình lõi

### 3.1 Các lớp

| Lớp | Thực thể | Bảng chính | Ghi chú |
|-----|----------|------------|---------|
| **Person** | Cá nhân | `members` | UUID ổn định |
| **Relationship** | Quan hệ dọc + ngang | `parentages` + `marriages` | Nguồn sự thật quan hệ (mới) |
| **Source & Evidence** | Nguồn, trích dẫn, chứng cứ | `sources`, `citations`, `evidence_links` | Truy nguyên |
| **Projection** | Hiển thị | RenderNode / RenderEdge | Derived |
| **Governance** | Policy, audit | `selection_policies` (khái niệm) | Có version |
| **Legacy (tạm thời)** | Tương thích ngược | `members.father_id`, `members.mother_id`, `members.child_type` | Deprecated, giữ song song giai đoạn chuyển đổi |

### 3.2 Parentage

```text
Parentage = (parent_id, child_id, relationship_type, union_id?, review_status, is_selected_for_lineage)
```

**relationship_type** (core V1): `BIOLOGICAL`, `ADOPTIVE`, `FOSTER`, `STEPCHILD`, `OTHER`.

### 3.3 SelectionPolicy

Mọi projection **PHẢI** gắn với một SelectionPolicy có:

- `policy_id` + `version`
- Scope (clan / lineage / projection cụ thể)
- Tiêu chí ưu tiên và cách xử lý xung đột
- Fallback và lịch sử thay đổi

**Primary Tree rule:**

```text
review_status = ACCEPTED
AND is_selected_for_lineage = true
AND deleted_at IS NULL
AND không có xung đột chưa được policy giải quyết
```

Nếu có nhiều Claim ACCEPTED mâu thuẫn mà policy không xác định duy nhất → trả về `UNRESOLVED_CONFLICT` (không tự chọn theo thời gian cập nhật hoặc thứ tự nhập).

---

## 4. Chiến lược chuyển đổi (Cutover) — Bắt buộc

### 4.1 Nguyên tắc bảo vệ

- **Tôn chỉ Q1:** Không phá vỡ các máy Registration (RP) và Onboarding (OP) đã hoàn thành.
- RP và OP đã **CLOSED**. Việc mở rộng sang `parentages` và `sources` chỉ ở tầng Genealogy Graph Layer.
- Không can thiệp cấu trúc bảng `users` và liên kết `users.member_id`.
- Không drop ngay `members.father_id`, `members.mother_id`, `members.child_type`.

### 4.2 Giai đoạn chuyển đổi

| Giai đoạn | Hành động | Mục tiêu |
|-----------|-----------|----------|
| **G0** | Tạo bảng `parentages`, `sources`, `citations`, `evidence_links` | Không ảnh hưởng luồng cũ |
| **G1** | Script migration: chuyển `father_id`/`mother_id` hiện có → `parentages` (`BIOLOGICAL`, `ACCEPTED`, `is_selected_for_lineage = true`) | Bảo toàn dữ liệu test/smoke |
| **G2** | Dual-write / Mapper: Mọi ghi mới (MFO Gate 2, OP nếu có khai báo cha/mẹ) phải ghi cả legacy + `parentages` | Không gãy test hiện hành |
| **G3** | Đọc Primary Tree từ `parentages` (SelectionPolicy) | Graph Engine hoạt động |
| **G4** (sau) | Đánh dấu deprecated các cột legacy; chỉ xóa khi đã xác nhận không còn consumer | Dọn dẹp |

### 4.3 Khớp nối MFO Gate 2

Khi Admin bấm Duyệt và ghi sổ ở Cửa 2 (`executeGate2DbMutation` trong `mfo.service.js`):

- Tạo / cập nhật `members` như hiện tại.
- **Bổ sung:** Insert vào `parentages` theo `child_type` đã kê khai ở Staging Sheet.
- Mapping tối thiểu: `child_type` → `relationship_type` (mặc định `BIOLOGICAL` nếu không xác định rõ).
- Ghi `review_status = ACCEPTED`, `is_selected_for_lineage = true` trừ khi có quy tắc khác.

### 4.4 Onboarding Process (OP) — Mapper ở tầng Service

- Giữ nguyên cột `father_id` / `mother_id` trên `members` trong giai đoạn chuyển đổi.
- **Khuyến nghị:** Đồng bộ sang `parentages` bằng **Service Mapper** (hoặc Prisma Middleware / Extension) trong code Node.js, **không** dùng Trigger PostgreSQL.
- Lý do: dễ inject `changed_by`, `review_status = ACCEPTED`, audit log và event BPL mà không ẩn logic trong CSDL.
- Mapper chỉ chạy khi OP ghi vào các cột legacy; không yêu cầu sửa logic cốt lõi của OP đã UAT.

### 4.5 Login và Register Process (RP)

- **Không bị ảnh hưởng.**
- Login chỉ phụ thuộc `users`.
- RP chỉ tạo `users` và `members` ban đầu; không chịu trách nhiệm dựng cây phả hệ.

---

## 5. Source / Citation / Evidence

Hệ thống **PHẢI** hỗ trợ tối thiểu:

- Source (tư liệu)
- Citation (vị trí cụ thể)
- Evidence Link (supports / contradicts / contextual)
- Khả năng truy nguyên từ Parentage / Event về Citation

**Schema tối thiểu:**

```prisma
model sources {
  id          String   @id @default(dbgenerated("(gen_random_uuid())::text")) @db.VarChar(36)
  tenant_id   String   @db.VarChar(36)
  title       String   @db.VarChar(500)
  source_type String   @db.VarChar(50)
  description String?  @db.Text
  created_at  DateTime @default(now())
  created_by  String?  @db.VarChar(36)
  @@map("sources")
}

model citations {
  id          String   @id @default(dbgenerated("(gen_random_uuid())::text")) @db.VarChar(36)
  tenant_id   String   @db.VarChar(36)
  source_id   String   @db.VarChar(36)
  locator     String?  @db.VarChar(500)
  note        String?  @db.Text
  created_at  DateTime @default(now())
  sources     sources  @relation(fields: [source_id], references: [id])
  @@map("citations")
}

model evidence_links {
  id              String   @id @default(dbgenerated("(gen_random_uuid())::text")) @db.VarChar(36)
  tenant_id       String   @db.VarChar(36)
  citation_id     String   @db.VarChar(36)
  target_type     String   @db.VarChar(50)   // parentage, event, name...
  target_id       String   @db.VarChar(36)
  relation_role   String   @db.VarChar(50)   // supports, contradicts, contextual
  note            String?  @db.Text
  citations       citations @relation(fields: [citation_id], references: [id])
  @@map("evidence_links")
}
```

---

## 6. Schema Parentages (target)

### 6.1 Lưu ý kỹ thuật Composite Foreign Key

Để dùng composite foreign key `fields: [tenant_id, parent_id], references: [tenant_id, id]`, bảng `members` **bắt buộc** phải có unique constraint trên cặp `(tenant_id, id)`.

**Hai phương án triển khai (chọn một):**

| Phương án | Cách làm | Ưu điểm | Nhược điểm |
|-----------|----------|---------|------------|
| **A (khuyến nghị nếu có thể)** | Thêm `@@unique([tenant_id, id])` vào model `members` | Composite FK an toàn ở tầng DB | Cần migration thêm unique index |
| **B (tương thích nhanh)** | Chỉ FK đơn: `fields: [parent_id], references: [id]` + validate `tenant_id` ở tầng ứng dụng/query | Không cần thay đổi unique trên `members` hiện tại | Phụ thuộc code để chống cross-tenant |

**Khuyến nghị V1:** Ưu tiên Phương án A nếu migration unique index khả thi. Nếu không, dùng Phương án B kết hợp validation chặt ở Service.

### 6.2 Schema đề xuất

```prisma
model parentages {
  id                     String              @id @default(dbgenerated("(gen_random_uuid())::text")) @db.VarChar(36)
  tenant_id              String              @db.VarChar(36)

  parent_id              String              @db.VarChar(36)
  child_id               String              @db.VarChar(36)

  relationship_type      parentage_type      @default(BIOLOGICAL)
  union_id               String?             @db.VarChar(36)

  review_status          claim_review_status @default(ACCEPTED)
  certainty              Decimal?            @db.Decimal(3, 2)
  is_selected_for_lineage Boolean            @default(true)
  note                   String?             @db.VarChar(500)
  primary_citation_id    String?             @db.VarChar(36)

  created_at             DateTime?           @default(now()) @db.Timestamptz(6)
  updated_at             DateTime?           @default(now()) @updatedAt @db.Timestamptz(6)
  changed_by             String?             @db.VarChar(36)
  deleted_at             DateTime?           @db.Timestamptz(6)

  tenants                tenants             @relation(fields: [tenant_id], references: [id], onDelete: Restrict)
  parent                 members             @relation("ParentageAsParent", fields: [tenant_id, parent_id], references: [tenant_id, id], onDelete: Restrict)
  child                  members             @relation("ParentageAsChild", fields: [tenant_id, child_id], references: [tenant_id, id], onDelete: Restrict)
  union                  marriages?          @relation(fields: [union_id], references: [id], onDelete: SetNull)
  modifier               users?              @relation(fields: [changed_by], references: [id], onDelete: NoAction)
  primaryCitation        citations?          @relation(fields: [primary_citation_id], references: [id], onDelete: SetNull)

  @@unique([tenant_id, parent_id, child_id, relationship_type, review_status], map: "uq_parentage_assertion")
  @@index([tenant_id, child_id, review_status, is_selected_for_lineage], map: "idx_parentage_tree_lookup")
  @@index([parent_id])
  @@index([child_id])
  @@index([union_id])
  @@index([primary_citation_id])
  @@index([deleted_at])
  @@map("parentages")
}

enum parentage_type {
  BIOLOGICAL
  ADOPTIVE
  FOSTER
  STEPCHILD
  OTHER
}

enum claim_review_status {
  PROPOSED
  ACCEPTED
  DISPUTED
  REJECTED
  SUPERSEDED
}
```

**Ghi chú:** Relation `primaryCitation` giúp Prisma hỗ trợ `include` / `join` khi truy vấn phả hệ kèm nguồn. `onDelete: SetNull` để không mất Parentage khi Citation bị xóa.

---

## 7. Event và GenealogicalDate

- Event là thực thể riêng. `birth_event_ref` / `death_event_ref` trên Person (nếu có) chỉ là shortcut, **không** được lưu ngày độc lập.
- GenealogicalDate giữ precision, qualifier, original_text và conversion_metadata.
- Không ép ngày lịch sử thành timestamp.
- Không điền `01/01` khi chỉ biết năm.

---

## 8. Branch, Lineage và Access Scope

| Khái niệm | Ý nghĩa | Không đồng nghĩa với |
|-----------|---------|----------------------|
| **Branch** | Phạm vi biên tập / hiển thị (RBAC) | Chi phái văn hóa |
| **Lineage** | Phạm vi phả hệ / truyền thừa | Branch |
| **LineageMembership** | Tư cách thành viên có căn cứ, thời gian, review | Quan hệ cha–con |
| **Access Scope** | Quyết định bảo mật | Membership |

Thay đổi topology **không** tự cấp quyền. Membership không tự chứng minh quan hệ sinh học.

---

## 9. Safety Contract

### 9.1 Cycle Detection (Fail-Closed)

| Kết quả | Hành động |
|---------|-----------|
| `ACYCLIC_CONFIRMED` | Được commit |
| `CYCLE_DETECTED` | Chặn + lỗi `ANCESTRY_CYCLE` |
| `VALIDATION_INCOMPLETE` | **Fail-closed** — chặn commit |

### 9.2 Advisory Lock

```sql
BEGIN;
SET LOCAL lock_timeout = '3s';
SELECT pg_advisory_xact_lock(hashtext('topology:' || tenant_id));
-- Validate candidate graph + ghi dữ liệu + audit
COMMIT;
```

### 9.3 Các bất biến khác

- Không self-parent.
- Không cross-tenant.
- Backend quyết định cuối cùng.
- Không commit khi thiếu quyền hoặc version conflict.
- Không can thiệp các trường nhân thân nhạy cảm (gender, is_alive, phone, email) qua API phả hệ mới (khóa A01).

---

## 10. Acceptance Criteria tối thiểu (V1)

- [ ] Tạo được Parentage với 4 loại quan hệ chính.
- [ ] Primary Tree chỉ hiển thị theo SelectionPolicy (ACCEPTED + selected + không xung đột chưa giải).
- [ ] Cycle detection chặn được self-parent và vòng lặp.
- [ ] Validation incomplete → không commit.
- [ ] Advisory lock hoạt động theo tenant.
- [ ] Script migration chuyển được dữ liệu `father_id`/`mother_id` hiện có sang `parentages`.
- [ ] MFO Gate 2 ghi được cả legacy + `parentages`.
- [ ] OP ghi vào `father_id`/`mother_id` vẫn đồng bộ được sang `parentages` qua Service Mapper.
- [ ] Login / RP / OP đã UAT không bị gãy.
- [ ] Hỗ trợ union_id = NULL.
- [ ] Audit log ghi before/after cho mutation cấu trúc.
- [ ] Có thể tạo Source + Citation và liên kết với Parentage.
- [ ] Parentage quan trọng có thể truy nguyên về Citation (hoặc ghi rõ “chưa có nguồn”).
- [ ] Hai Claim ACCEPTED mâu thuẫn không tự được chọn theo thứ tự nhập/cập nhật.
- [ ] Event date là nguồn sự thật duy nhất (không có hai bản ngày độc lập).
- [ ] Composite FK (hoặc phương án tương đương) được xử lý đúng, không lỗi migrate.
- [ ] Relation `primaryCitation` hoạt động với `include`.

---

## 11. Out of Scope (V1)

- Engine lịch âm dương đầy đủ.
- GEDCOM import/export hoàn chỉnh.
- Drop ngay các cột legacy (`father_id`, `mother_id`, `child_type`).
- Tự động suy diễn quan hệ từ tên/giới/vị trí.
- Evidence Assessment đầy đủ theo TFD-301 (chỉ có cấu trúc tối thiểu).
- Fast path concurrency ngoài clan lock (chỉ nghiên cứu).
- Sửa logic cốt lõi của RP / OP đã CLOSED.
- Trigger PostgreSQL cho dual-write (ưu tiên Service Mapper).

---

## 12. Kế hoạch triển khai ngắn

1. Tạo migration thêm `parentages`, `sources`, `citations`, `evidence_links` + enums (G0).  
   → Xử lý unique constraint trên `members` theo Phương án A hoặc B (Mục 6.1).
2. Viết và chạy script migration dữ liệu test/smoke hiện có → `parentages` (G1).
3. Cập nhật MFO Gate 2 (`executeGate2DbMutation`) để dual-write (G2).
4. Thêm **Service Mapper** (hoặc Prisma Middleware) đồng bộ cho OP.
5. Cập nhật service Graph Engine: cycle check + advisory lock + SelectionPolicy.
6. Chạy bộ test topology + test truy nguyên nguồn + test SelectionPolicy xung đột + regression test RP/OP/Login.
7. Cutover trên feature branch → staging → production (giữ legacy columns).

---

**Tài liệu này có hiệu lực thực chiến ngay.**  
Mọi thay đổi cần tạo phiên bản mới và cập nhật Decision Register.

---

*Dựa trên TFD-CORE-APPROVAL-1.0.0.  
Phiên bản 1.0.4 làm rõ các điểm kỹ thuật triển khai composite FK, Service Mapper và relation Citation.*
