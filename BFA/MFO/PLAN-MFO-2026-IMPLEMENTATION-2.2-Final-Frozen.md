# PLAN-MFO-2026-IMPLEMENTATION

**Phiên bản:** 2.2 (Multi-Source Generation - Gap Closed Edition)

**Ngày cập nhật:** 2026-11-25

**Trạng thái:** CHÍNH THỨC BAN HÀNH (APPROVED FOR EXECUTION)

**Mã tài liệu:** PLAN-MFO-2026

**Tài liệu quy chiếu:**

* AMEND-MFO-2026-01-CANVAS-LINK-EXISTING (v5.4 Final Frozen)

* AMEND-MFO-2026-02-ENTITY-RESOLUTION (v2.2)

* AMEND-MFO-2026-03-AUTOMATED-SCORING (v2.1)

* FTDI-PRACTICAL-SPEC-1.0.4-Final

* schema.prisma (Current Baseline)

* SSOT Codebase Audit Report (BE & FE)

## PLAN-00. Tổng quan & Phạm vi

Kế hoạch v2.2 định hướng triển khai ba tài liệu nâng cấp lõi hệ thống Gia phả, khắc phục các khoảng trống (Gaps) hiện hữu trong mã nguồn và tích hợp **Kiến trúc Quản lý Đời đa nguồn (Multi-Source Generation)** với các ranh giới an toàn tuyệt đối.

| Mã | Tài liệu | Phase | Mục tiêu chính | 
| ----- | ----- | ----- | ----- | 
| **MFO-01** | AMEND-MFO-2026-01 | Phase 1 | Canvas Path A/B, cây nhỏ, Dual-Write ngầm, Ghi nhận Nguồn người dùng. | 
| **MFO-02** | AMEND-MFO-2026-02 | Phase 1 | Entity Resolution (gộp trùng xuyên nhánh, di dời & bảo toàn Assertions). | 
| **MFO-03** | AMEND-MFO-2026-03 | Phase 2 | Automated Duplicate Scoring Engine, Tầng 3 Dynamic Projection. | 

**Nguyên tắc triển khai cốt lõi:**

1. **Phân pha rõ ràng:** Phase 1 tập trung Tầng 1 (Canonical SSOT) + Tầng 2 (Source Assertions cơ bản). Tầng 3 (Dynamic Projection) được dời sang Phase 2.

2. **Dual-Write chạy ngầm:** Đồng bộ từ `members` sang `parentages` âm thầm, không ảnh hưởng OP/RP cũ.

3. **Bảo toàn dữ liệu nguồn:** Tuyệt đối không xóa/ghi đè khẳng định đời (`assertions`) của các phả liệu nguyên bản.

## PLAN-10. Kiến trúc Schema & Giải pháp Gaps

### PLAN-10.1 Schema Gaps đã xác nhận và Giải pháp (Prisma Compliant)

Qua rà soát `schema.prisma` và giới hạn của ORM, dưới đây là các cấu trúc cần bổ sung:

| Mã Gap | Đối tượng | Mô tả Khoảng trống & Giải pháp | Phase | 
| ----- | ----- | ----- | ----- | 
| **GAP-DB-01** | `members` | Giữ `generation Int?`. Thêm `merged_into_id String? @db.VarChar(36)`. | 1 | 
| **GAP-DB-02** | `small_trees` | Quản lý cây nháp MFO (`id`, `tenant_id`, `owner_user_id`, `root_member_id`, `status`...). | 1 | 
| **GAP-DB-03** | `parentages` | Thêm `metadata Json? @default("{}")` để lưu `relative_level` theo từng cạnh. | 1 | 
| **GAP-DB-04** | `member_generation_assertions` | Thêm bảng Tầng 2. **Lưu ý Prisma:** Để tránh lỗi với giá trị `NULL` trong Unique Constraint, trường `citation_id` bắt buộc là `String` (gán giá trị `"SYS_CIT::DEFAULT"` nếu không có trích dẫn cụ thể). **Chỉ mục:** `@@unique([tenant_id, member_id, source_id, citation_id])`. | 1 | 
| **GAP-DB-05** | `sources` | Thêm cột `root_generation_offset Int @default(0)`. | 1 | 

### PLAN-10.2 Kiến trúc Đời đa nguồn (3-Layer Generation Model) - Phase 1 Scope

* **Tầng 1 — Canonical SSOT (`members.generation`):** Đời chuẩn thức trên tuyến huyết thống chính. Job tính đời (Generation Recomputation) **chỉ** can thiệp vào tầng này và tọa độ hiển thị (`relative_level`).

* **Tầng 2 — Source Assertions (`member_generation_assertions`):** Lưu giữ đời nguyên bản theo sách phả. Các bản ghi này mang tính lịch sử (immutable), Job tính đời tuyệt đối **không** tạo mới hoặc cập nhật dữ liệu ở bảng này.

* **Cơ chế Datum Offset & Cảnh báo mềm:**

  * Công thức: $\text{Calibrated\_Gen} = \text{claimed\_generation} + \text{root\_generation\_offset}$

  * Trong Phase 1, hệ thống **không tự động gắn `DISPUTED`**.

  * **Phạm vi hiển thị cảnh báo:** Cảnh báo mềm (`SOFT_WARNING`) **chỉ hiển thị trên giao diện UI Wizard Entity Resolution** của Admin. Không hiển thị cảnh báo này ra ngoài Hồ sơ thành viên (Profile) của User để tránh gây nhiễu.

### PLAN-10.3 Logic Vận hành Chi tiết (Đã vá lỗ hổng)

1. **G1 Backfill & Nguồn `LEGACY_BASELINE`:**

   * Khởi tạo 1 nguồn hệ thống `LEGACY_BASELINE` cho mỗi tenant. Nạp `members.generation` hiện có vào Assertions với `citation_id = "SYS_CIT::DEFAULT"`.

2. **Entity Resolution & Xử lý Trùng `source_id`:**

   * Khi gộp `X_source` vào `X_target`, toàn bộ Assertions di dời sang `X_target`.

   * **Rule tránh vi phạm Unique:** Nếu `X_target` và `X_source` có cùng `source_id` nhưng khác `claimed_generation` và đang cùng dùng chung `citation_id`, Backend tự động cập nhật bản ghi của `X_source` thành `citation_id = "SYS_CIT::CONFLICT_MERGE::<source_assertion_id>"` trước khi chuyển sang `X_target`. Điều này bảo toàn cả 2 dị bản hợp lệ.

3. **Path B (Cây nhỏ) & Nguồn `USER_CONTRIBUTION`:**

   * Khi Admin bấm duyệt ghép một cây nhỏ (`MERGE_SMALL_TREE`), **Hệ thống** tự động tạo ra một nguồn `USER_CONTRIBUTION` dành riêng cho lần ghép đó.

   * `citation_id` của các Assertions sinh ra từ luồng này sẽ được gán gắn kết với `small_tree_id`. Việc này đảm bảo tính truy vết (Audit Trail) rõ ràng: 1 lần ghép cây = 1 nguồn khai báo.

4. **Generation Recomputation (Tối ưu nhánh):**

   * BFS chỉ lan xuống hạ lưu theo cạnh `ACCEPTED` vừa tác động. Tính lại `parentages.metadata.relative_level`.

   * Bảo đảm các cạnh `ACCEPTED` khác của thành viên (nếu có Multiple Occurrences ở nhánh khác) **không bị ảnh hưởng**.

## PLAN-20. Kế hoạch triển khai Phase 1

### WP-01: Foundation (Migration & Backfill)

* **WP01-T01:** Thêm `merged_into_id` (`members`), `metadata` (`parentages`).

* **WP01-T02:** Thêm bảng `small_trees`, `member_generation_assertions` (với `citation_id` default là `"SYS_CIT::DEFAULT"`).

* **WP01-T03:** Thêm `sources.root_generation_offset`.

* **WP01-T04:** Script G1 Backfill: Tạo nguồn `LEGACY_BASELINE`, migrate `generation` $\rightarrow$ Assertions.

### WP-02: Core Safety & Dual-Write

* **WP02-T01:** `ServiceMapper` Dual-Write chạy ngầm bảo vệ OP.

* **WP02-T02:** Middleware Advisory Lock & Cycle Detector (DFS Fail-closed).

* **WP02-T03:** Worker `GenerationRecomputation` (Chỉ cập nhật SSOT/Edge, không đụng Assertions).

### WP-03: Canvas UX (Path A & B)

* **WP03-T01:** API Tạo cây nhỏ (gán `created_by_member_id` nội bộ).

* **WP03-T02:** `MERGE_SMALL_TREE` API (Hệ thống tự sinh nguồn `USER_CONTRIBUTION` dùng `small_tree_id` làm citation).

### WP-04: Entity Resolution

* **WP04-T01:** UI Wizard (Hiển thị Soft-Warning nếu lệch Offset).

* **WP04-T02:** Re-wiring trực hệ. Di dời assertions (Tự sinh `SYS_CIT::CONFLICT_MERGE::<source_assertion_id>` nếu trùng citation/source).

* **WP04-T03:** Mid-tree Anchor Split & Account Guard.

### WP-05: Read Cutover G3

* **WP05-T01:** Cờ Kill-Switch `cutover_g3_<tenant_id>` (Fallback về `father_id` nếu cần).

* **WP05-T02:** Đọc cây từ `parentages`, Frontend tính đời hiển thị động.

## PLAN-30. Kế hoạch Phase 2 (Scoring & Tầng 3)

* **WP06-T01:** Search Index (Elasticsearch).

* **WP06-T02:** Automated Scoring Engine (Trục A, B, C, D & Multi-source Offset).

* **WP06-T03:** Negative Feedback Loop (`duplicate_rejections`).

* **WP06-T04:** **Tầng 3 Dynamic Projection Mode:** Chuyển đổi góc nhìn Canvas theo từng nguồn phả liệu trực tiếp trên UI.

## PLAN-40. Acceptance Criteria & QA Gates (Phase 1)

| Mã Test | Kịch bản Kiểm thử cốt lõi | Chốt chặn (Gate) | 
| ----- | ----- | ----- | 
| **QA-01** | Gộp Entity có Assertions trùng `source_id` + trùng `citation_id`. | Hệ thống tự đổi `citation_id` của bản ghi source thành `SYS_CIT::CONFLICT_MERGE::<source_assertion_id>`, không văng Unique Error. | 
| **QA-02** | Ghép 2 cây nhỏ liên tiếp từ cùng 1 User. | Hệ thống tạo 2 nguồn `USER_CONTRIBUTION` riêng biệt, citation map đúng 2 ID cây. | 
| **QA-03** | Generation Recompute trên Multiple Occurrences. | Nhánh bị tác động update `relative_level`, nhánh song song khác giữ nguyên tọa độ. Assertions giữ nguyên. | 
| **QA-04** | G1 Backfill có conflict. | Lưu log `CRON`, sinh `LEGACY_BASELINE`, giữ `parentages` mới. | 
| **QA-05** | Query `X_source` bị gộp. | Redirect đệ quy về `X_target`. | 
| **QA-06** | Bật / Tắt Kill-Switch G3. | Fallback mượt mà giữa G2 (Legacy) và G3 (Graph). | 
| **QA-07** | Cảnh báo mềm Offset. | Chỉ xuất hiện trên Admin Wizard, không có lỗi chặn (Hard block). | 

**Chữ ký:** [Tech Lead / Product Owner]

**Trạng thái:** APPROVED FOR EXECUTION (v2.2)