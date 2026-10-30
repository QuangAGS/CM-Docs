# **BÁO CÁO PHÂN TÍCH ĐỘ LỆCH VÀ QUY CHUẨN HIỆU CHỈNH DATABASE / BE / FE**

---

**Dự án:** myclan.com.vn — Đối chiếu chuẩn FT-DOCTRINE-SPEC v2.0.2

| Mã báo cáo | MYCLAN-FTD-GAP-REPORT | Phiên bản | 1.2.0-FINAL |
| :---- | :---- | :---- | :---- |
| **Ngày ban hành** | 21/10/2026 | **Trạng thái** | CHÍNH THỨC BAN HÀNH (APPROVED) |
| **Chuẩn đối chiếu** | FT-DOCTRINE-SPEC v2.0.2 (RELEASED) | **Bối cảnh CSDL** | Pre-production (Chưa có dữ liệu thật) |

## **1\. TÓM TẮT ĐIỀU HÀNH (EXECUTIVE SUMMARY)**

---

Hệ thống quản trị gia phả số **myclan.com.vn** đang bước vào giai đoạn hoàn thiện hạ tầng dữ liệu và Engine Cây gia phả (Family Tree Core Engine). Qua đối chiếu với quy chuẩn **FT-DOCTRINE-SPEC v2.0.2 (RELEASED)**, Prisma Schema hiện tại (v2.0.0-ACH-SUBCAT) sở hữu nền tảng quản trị dòng họ khá vững chắc (đã tách biệt members và users, hỗ trợ multi-tenancy tenant\_id, quản lý hôn nhân marriages, tài chính, địa chỉ, mộ phần, truyền thông và quy trình onboarding).  
Tuy nhiên, về mặt **Mô hình Miền Cây Gia Phả (Genealogical Graph Domain Model)**, hệ thống hiện tại tồn tại một độ lệch kiến trúc cốt lõi: **Quan hệ Cha/Mẹ – Con đang bị gộp trực tiếp vào bảng members qua cấu trúc Adjacency List (father\_id, mother\_id) và thuộc tính child\_type**.  
Cấu trúc cũ này dẫn đến 4 hạn chế nghiêm trọng:

1. Không thể quản lý các loại quan hệ con nuôi, con riêng, con đỡ đầu theo từng bối cảnh cha/mẹ cụ thể.  
2. Ép buộc một đứa trẻ phải thuộc về một cuộc hôn nhân (parent\_union\_id), làm vỡ logic khi gặp ca con riêng, con ngoài giá thú hoặc mẹ đơn thân.  
3. Không hỗ trợ lưu giữ các phát biểu mâu tư liệu/tranh chấp lịch sử (Claims) mà buộc phải ghi đè dữ liệu.  
4. Gặp rủi ro tạo chu trình kín (Cycle) trên đồ thị khi nhiều quản trị viên thao tác đồng thời.

**Quyết định Chiến lược:** Vì dự án **chưa có dữ liệu Production**, Hội đồng Kỹ thuật chính thức phê duyệt **PHƯƠNG ÁN A (Re-baseline & Clean Bootstrap)**: Cutover trực tiếp sang Schema đích chuẩn mực có bảng parentages độc lập, xây dựng lại Seeder/Fixtures sạch và cập nhật Backend/Frontend đồng bộ trước khi Go-live, loại bỏ sự phức tạp không cần thiết của cơ chế Dual-write kéo dài.

## **2\. BẢNG TỔNG HỢP GAP (GAP ANALYSIS MATRIX)**

---

| Mã GAP | Yêu cầu FTD v2.0.2 | Hiện trạng Prisma Schema | Đánh giá / Tác động | Ưu tiên & Giải pháp   |
| :---- | :---- | :---- | :---- | :---- |
| **GAP-01** | **Tách biệt Person & UserAccount** | members và users tách rời; users.member\_id unique. | **ĐẠT** Nền tảng danh tính chuẩn xác. | Giữ nguyên UUID và mối liên kết 1-1. |
| **GAP-02** | **Thực thể Parentage độc lập** | father\_id, mother\_id, child\_type nằm trực tiếp trên members. | **KHÔNG ĐẠT (P0)** Không lưu được vết con nuôi/con đẻ theo từng cha/mẹ. | Tạo bảng parentages quản lý quan hệ 1-1 Cha/Mẹ – Con độc lập. |
| **GAP-03** | **Phân định Union và Parentage** | members.parent\_union\_id trỏ thẳng sang marriages.id. | **LỆCH CẤU TRÚC (P0)** Gắn chặt cha-con vào hôn nhân; gây lỗi khi có con đơn thân. | Chuyển union\_id thành thuộc tính tham chiếu tùy chọn (Optional) trên parentages. |
| **GAP-04** | **Bảo vệ Multi-tenancy Consistency** | Có tenant\_id trên hầu hết các bảng. | **ĐẠT THIẾT KẾ** Cần chặn cross-tenant ở tầng DB. | Áp dụng Composite FK & Unique Constraints trên parentages. |
| **GAP-05** | **Quản lý Claim & Tranh chấp** | Có proposals nhưng chưa có Claim cho đồ thị gia phả. | **THIẾU TRẠNG THÁI (P1)** Lần nhập sau đè mất thông tin cũ. | Thêm review\_status (PROPOSED, ACCEPTED, DISPUTED) trên parentages. |
| **GAP-06** | **Thứ tự con theo Ngữ cảnh (Ordering)** | sibling\_seq nằm cố định trên members. | **HẠN CHẾ (P1)** Không hiển thị thứ tự khác nhau giữa gia đình ruột và nuôi. | Giữ sibling\_seq làm fallback; thêm ChildOrderAssignment khi cần. |
| **GAP-07** | **Đồng thời & Khóa đồ thị (Concurrency)** | Chưa có thiết kế PostgreSQL Advisory Lock ở tầng Service/DB. | **THIẾU BẢO VỆ (P0)** Rủi ro Race Condition tạo ra chu trình kín (Cycle). | Triển khai pg\_advisory\_xact\_lock(tenant\_id) cho Mutation sửa cấu trúc cây. |
| **GAP-08** | **Phân quyền tác động 4 lớp (RBAC)** | users.role, member\_offices, member\_privacy\_rules. | **CẦN TÍNH IMPACT (P0)** Tránh đòi quyền Edit Profile trên 500 con cháu khi tính lại mã. | Tách 4 tập tác động: Direct Write, Derived Recomputation, Authorization, Publication. |

## **3\. KHÁI NIỆM & TRIẾT LÝ KIẾN TRÚC ĐÍCH**

### ---

**3.1. Sự Tách Bằng Ba Lớp (Uncoupling)**

Đồ thị gia phả của myclan.com.vn vận hành dựa trên sự phân định rành rọt giữa 3 lớp:

1. **Person Layer (members):** Biểu diễn cá nhân, tiểu sử, tình trạng sống/mất, ngày sinh/mất. Cá nhân tồn tại độc lập.  
2. **Relationship Layer (parentages & marriages):** Biểu diễn các mối liên kết. parentages quản lý sợi dây huyết thống/nuôi dưỡng hàng dọc (1 Cha/Mẹ đến 1 Con). marriages (Union) quản lý bối cảnh kết đôi/hôn nhân hàng ngang.  
3. **Projection & Layout Layer (RenderNode & RenderEdge):** Dữ liệu hiển thị động trên Canvas. Một Person có thể xuất hiện ở nhiều vị trí (Multiple Occurrences) trên Canvas nhưng trong CSDL chỉ là 1 bản ghi duy nhất.

### **3.2. Mô hình Parentage**

Một bản ghi parentages đại diện cho quan hệ có hướng từ một Cha/Mẹ (parent\_id) tới một Người con (child\_id):

`Parentage = (parent_id, child_id, relationship_type, union_id?, review_status)`

* **relationship\_type:** BIOLOGICAL (Con đẻ), ADOPTIVE (Con nuôi), FOSTER (Con đỡ đầu/nuôi dưỡng), STEPCHILD (Con riêng).  
* **union\_id (Tùy chọn):** Liên kết tới marriages.id nếu đứa trẻ được sinh ra trong bối cảnh cuộc hôn nhân đó. Nếu là con đơn thân, union\_id \= NULL.

## **4\. QUY CHUẨN REFACTOR PRISMA SCHEMA (TARGET SCHEMA)**

---

`// =============================================================================`  
`// REFACTOR: PARENTAGES MODEL (MÔ HÌNH QUAN HỆ CHA/MẸ - CON CHUẨN FTD v2.0.2)`  
`// =============================================================================`

`model parentages {`  
  `id                String              @id @default(dbgenerated("(gen_random_uuid())::text")) @db.VarChar(36)`  
  `tenant_id         String              @db.VarChar(36)`  
    
  `/// Định danh Cha hoặc Mẹ`  
  `parent_id         String              @db.VarChar(36)`  
    
  `/// Định danh Người con`  
  `child_id          String              @db.VarChar(36)`  
    
  `/// Phân loại quan hệ: CON_DE (BIOLOGICAL), CON_NUOI (ADOPTIVE), CON_NUOI_DUONG (FOSTER), CON_RIENG (STEPCHILD)`  
  `relationship_type parentage_type      @default(BIOLOGICAL)`  
    
  `/// Mỏ neo liên kết tới Bối cảnh Hôn nhân / Chung sống (Tùy chọn - NULL nếu đơn thân/chưa rõ)`  
  `union_id          String?             @db.VarChar(36)`  
    
  `/// Quản lý Claim / Trạng thái phê duyệt & Tranh chấp lịch sử`  
  `review_status     claim_review_status @default(ACCEPTED)`  
    
  `/// Độ tin cậy dữ liệu (0.00 đến 1.00)`  
  `certainty         Decimal?            @default(1.00) @db.Decimal(3, 2)`  
    
  `/// Ghi chú nguồn tư liệu hoặc lý do xác minh`  
  `note              String?             @db.VarChar(500)`  
    
  `created_at        DateTime?           @default(now()) @db.Timestamptz(6)`  
  `updated_at        DateTime?           @default(now()) @updatedAt @db.Timestamptz(6)`  
  `changed_by        String?             @db.VarChar(36)`  
  `deleted_at        DateTime?           @db.Timestamptz(6)`

  `// ---------------------------------------------------------------------------`  
  `// RELATIONS`  
  `// ---------------------------------------------------------------------------`  
  `tenants           tenants             @relation(fields: [tenant_id], references: [id], onDelete: Restrict, map: "fk_parentage_tenant")`  
  `parent            members             @relation("ParentageAsParent", fields: [parent_id], references: [id], onDelete: Restrict, map: "fk_parentage_parent")`  
  `child             members             @relation("ParentageAsChild", fields: [child_id], references: [id], onDelete: Restrict, map: "fk_parentage_child")`  
  `union             marriages?          @relation("UnionToParentages", fields: [union_id], references: [id], onDelete: SetNull, map: "fk_parentage_union")`  
  `modifier          users?              @relation("ParentageModifier", fields: [changed_by], references: [id], onDelete: NoAction, map: "fk_parentage_user")`

  `// ---------------------------------------------------------------------------`  
  `// INDEXES & CONSTRAINTS`  
  `// ---------------------------------------------------------------------------`  
  `@@unique([tenant_id, parent_id, child_id, relationship_type], map: "uq_parentage_link")`  
  `@@index([tenant_id], map: "idx_parentage_tenant")`  
  `@@index([parent_id], map: "idx_parentage_parent")`  
  `@@index([child_id], map: "idx_parentage_child")`  
  `@@index([union_id], map: "idx_parentage_union")`  
  `@@index([tenant_id, child_id, review_status], map: "idx_parentage_child_lookup")`  
  `@@index([deleted_at], map: "idx_parentage_deleted_at")`  
  `@@map("parentages")`  
`}`

`enum parentage_type {`  
  `BIOLOGICAL  /// Con đẻ (Sinh học)`  
  `ADOPTIVE    /// Con nuôi (Có công nhận/pháp lý hoặc gia tộc)`  
  `FOSTER      /// Con đỡ đầu / Nuôi dưỡng`  
  `STEPCHILD   /// Con riêng của vợ/chồng`  
  `OTHER       /// Khác`  
`}`

`enum claim_review_status {`  
  `PROPOSED    /// Đề xuất (Chờ duyệt)`  
  `ACCEPTED    /// Đã duyệt (Đang sử dụng trên Cây chính)`  
  `DISPUTED    /// Đang tranh chấp / Mâu thuẫn nguồn tư liệu`  
  `REJECTED    /// Bị từ chối`  
  `SUPERSEDED  /// Đã bị thay thế bởi bản ghi mới hơn`  
`}`

## **5\. GIAO THỨC ĐỒNG THỜI & CONCURRENCY LOCK (SAFETY CONTRACT)**

### ---

**5.1. Quy trình Kiểm tra Chu trình (Cycle Detection \- Fail-Closed)**

Mọi thao tác Mutation làm thay đổi cấu trúc đồ thị (như thêm quan hệ Cha/Mẹ – Con, đổi cha/mẹ Re-parenting, hoặc Merge Person) đều phải thực thi thuật toán phát hiện chu trình kín trên **Đồ thị Ứng viên (Candidate Graph)** trước khi Commit.  
Kết quả kiểm tra phải đạt một trong 3 trạng thái:

1. **ACYCLIC\_CONFIRMED:** Đồ thị tuyệt đối an toàn, không có vòng lặp → **ĐƯỢC PHÉP COMMIT**.  
2. **CYCLE\_DETECTED:** Phát hiện vòng lặp (Ví dụ: A là cha B, B lại là cha của A) → **CHẶN GHI & BÁO LỖI ANCESTRY\_CYCLE**.  
3. **VALIDATION\_INCOMPLETE:** Quá thời gian kiểm tra hoặc vượt quá ngân sách duyệt nút → **FAIL-CLOSED: BẮT BUỘC CHẶN GHI**, trả về lỗi VALIDATION\_TIMEOUT. Tuyệt đối không giả định đồ thị an toàn khi chưa chứng minh xong.

### **5.2. Giao thức Lock ở cấp độ Tenant (PostgreSQL Advisory Lock)**

`-- Giao thức SQL thực thi trong Transaction của Backend (NestJS / Prisma)`  
`BEGIN;`

`-- Lấy Advisory Lock theo Tenant ID (Chỉ khóa luồng Mutation Topology của Clan đó)`  
`SET LOCAL lock_timeout = '3s';`  
`SELECT pg_advisory_xact_lock(hashtext('topology:' || 'TENANT_UUID_HERE'));`

`-- Đọc lại trạng thái phiên bản dữ liệu -> Validate Candidate Graph -> Ghi Data + Audit`  
`COMMIT;`

## **6\. PHÂN QUYỀN TÁC ĐỘNG 4 LỚP (IMPACT-BASED AUTHORIZATION)**

* ---

  **Direct Write Set:** Tập các bản ghi bị sửa đổi trực tiếp (parentages, members). *Yêu cầu quyền BranchEditor trên đúng nút bị sửa.*  
* **Derived Recomputation Set:** Tập các dữ liệu dẫn xuất bị tính toán lại (Mã tạm d'Aboville, vị trí Y-axis layout của 500 con cháu phía dưới). *KHÔNG YÊU CẦU người dùng phải có quyền Edit Profile trên 500 con cháu này.*  
* **Authorization Impact Set:** Thao tác làm thay đổi phạm vi phân quyền của người khác. *Yêu cầu quyền ClanAdmin hoặc chuyển sang luồng Phê duyệt (Proposal).*  
* **Publication Impact Set:** Thao tác làm thay đổi Sách gia phả hoặc Mã định danh đã công bố chính thức. *Yêu cầu quyền Xuất bản Phả ký.*

## **7\. CHIẾN LƯỢC CHUYỂN ĐỔI PRE-PRODUCTION (PHƯƠNG ÁN A)**

* ---

  **Không triển khai Dual-write:** Bỏ qua việc viết code hỗ trợ ghi song song vào cả cột cũ (father\_id/mother\_id) và bảng mới (parentages).  
* **Cutover Trực tiếp trên Feature Branch:** Thực hiện refactor Schema, cập nhật DTO/Service của Backend và UI của Frontend đồng bộ trên một nhánh phát triển.  
* **Xóa bỏ Legacy Fields:** Xóa bỏ hoàn toàn các cột father\_id, mother\_id, child\_type trên bảng members trong bản Schema chính thức phát hành Go-live.  
* **Tái tạo Seed Data (Clean Fixtures):** Tạo mới bộ Seeder mẫu đạt chuẩn FTD v2.0.2 để phục vụ kiểm thử Integration & E2E.

## **8\. LỘ TRÌNH TRIỂN KHAI CHUYỂN ĐỔI (ROADMAP R0 \- R7)**

---

**R0 (Inventory & Scope)** → **R1 (Physical Design)** → **R2 (Prisma Migration & Seed)** → **R3 (Backend Core Engine)** → **R4 (Backend Projection & Frontend Canvas)** → **R5 (Verification & QA)** → **R6 (Security & Performance Gate)** → **R7 (Go-Live Release)**.

## **9\. BỘ FIXTURES KIỂM THỬ NGHIỆM THU (TEST FIXTURES)**

1. ---

   **FIX-01 (Con nuôi & Con đẻ song song):** Một cá nhân vừa là con đẻ của cặp A-B, vừa là con nuôi của Ông C. Hệ thống phải vẽ đúng 2 tuyến quan hệ phân biệt trên Canvas.  
2. **FIX-02 (Con riêng của Vợ/Chồng \- Stepchild):\*\* Mẹ B đưa con riêng C vào cuộc hôn nhân với D. Hệ thống không được tự động gán D là cha sinh học của C.**  
3. **FIX-03 (Chống Vòng Lặp Đồng Thời \- Concurrency Race): Admin 1 nối A làm cha B; cùng lúc Admin 2 nối B làm cha A. Advisory Lock phải bắt buộc 1 giao dịch chờ và giao dịch sau bị từ chối với lỗi ANCESTRY\_CYCLE.**  
4. **FIX-04 (Mẹ đơn thân / Chưa rõ cha): Tạo thành công bản ghi parentages giữa Mẹ và Con với union\_id \= NULL mà không bị ép tạo cuộc hôn nhân giả.**  
5. **FIX-05 (Tranh chấp Gia phả \- Claim Dispute): Tạo 2 bản ghi parentages mâu thuẫn cho cùng 1 đứa trẻ. Cây chính chỉ hiển thị bản ghi ACCEPTED, Chế độ nghiên cứu hiển thị cả hai.**  
6. **FIX-06 (Phần quyền Tác động \- Derived Scope): Editor của Chi 2 thực hiện chuyển nhánh con. Mã tạm d'Aboville của 200 con cháu phía dưới bị tính lại thành công mà không báo lỗi thiếu quyền Edit Profile trên 200 con cháu đó.**  
7. **FIX-07 (Multi-tenant Isolation): Gửi Request nối Cha (Clan 1\) với Con (Clan 2). Hệ thống phải chặn ngay ở tầng Database với lỗi CROSS\_TENANT\_REFERENCE.**  
8. **FIX-08 (Nhiều điểm xuất hiện \- Multiple Occurrences): Hôn nhân cận huyết khiến 1 người xuất hiện ở 2 vị trí trên Canvas. Click chọn Vị trí 1 chỉ highlight Vị trí 2, không tự động pan màn hình gây mất ngữ cảnh.**  
9. **FIX-09 (Giỗ Lịch Âm & Tháng Nhuận): Người mất vào ngày 10/04 Âm lịch nhuận. Vào năm không có tháng 4 nhuận, hệ thống tự động nhắc giỗ vào ngày 10/04 Âm lịch thường theo đúng quy tắc regular\_month.**  
10. **FIX-10 (Fail-Closed Timeout): Giả lập đồ thị siêu lớn khiến việc Cycle Check quá 3 giây. Hệ thống trả về VALIDATION\_INCOMPLETE và chặn đứng thao tác ghi.**

## **10\. PHỤ LỤC: GIẢI THÍCH THUẬT NGỮ & TỪ VIẾT TẮT (GLOSSARY & ACRONYMS)**

---

                                                                                  

| Thuật ngữ / Viết tắt | Tên tiếng Anh đầy đủ | Giải thích Ý nghĩa Nghiệp vụ & Kỹ thuật |
| :---- | :---- | :---- |
| **FTD** | **Family Tree Doctrine** | **Bộ Quy chuẩn Triết lý & Quy tắc Nghiệp vụ Quản lý Cây Gia Phả số do myclan.com.vn ban hành.** |
| **Person** | **Individual Person Entity** | **Thực thể biểu diễn một cá nhân độc lập trong CSDL (Bảng members), chưa bao gồm thông tin quan hệ gia đình.** |
| **Union** | **Marriage / Coupling Context** | **Thực thể biểu diễn bối cảnh hôn nhân, kết đôi hoặc chung sống giữa các cá nhân (Bảng marriages).** |
| **Parentage** | **Parent-Child Directed Link** | **Thực thể biểu diễn mối quan hệ 1-1 có hướng từ một Cha hoặc Mẹ tới một Người con (Bảng parentages).** |
| **Claim** | **Genealogical Assertion** | **Một phát biểu/khẳng định dữ liệu gia phả có kèm nguồn tư liệu, có thể ở trạng thái Chờ duyệt, Đã chấp nhận hoặc Tranh chấp.** |
| **Occurrence** | **Canvas Visual Node Instance** | **Một lần xuất hiện của cá nhân trên giao diện Canvas. Một Person có thể có nhiều Occurrences nếu có hôn nhân cận huyết.** |
| **DAG** | **Directed Acyclic Graph** | **Đồ thị Hướng không Chu trình. Mô hình toán học bắt buộc của cây gia phả (không cho phép con lại là tổ tiên của chính mình).** |
| **Advisory Lock** | **PostgreSQL Application Lock** | **Cơ chế khóa chuyên biệt ở tầng phiên làm việc của PostgreSQL, dùng để khóa luồng ghi theo Tenant ID nhằm chống Race Condition.** |
| **Fail-Closed** | **Fail-Closed Security Principle** | **Nguyên tắc an toàn: Khi hệ thống gặp sự cố hoặc kiểm tra chưa hoàn tất (Timeout), mặc định TỪ CHỐI THAO TÁC GHI.** |
| **RBAC** | **Role-Based Access Control** | **Hệ thống quản lý phân quyền người dùng dựa trên Vai trò (SystemAdmin, ClanAdmin, BranchEditor, Member).** |
| **SSOT** | **Single Source of Truth** | **Nguồn sự thật duy nhất. Trong dự án, file Prisma Schema được coi là SSOT cho toàn bộ cấu trúc CSDL.** |
| **GEDCOM** | **Genealogical Data Communication** | **Chuẩn quốc tế về trao đổi dữ liệu gia phả (Phiên bản 5.5.1 và 7.0).** |
| **d'Aboville** | **d'Aboville System** | **Hệ thống quy chuẩn đánh mã vị trí gia phả (Ví dụ: 1.2.1 là con trưởng của con thứ hai của Thủy tổ).** |
| **Re-parenting** | **Branch / Node Re-parenting** | **Thao tác chuyển một thành viên hoặc một nhánh con cháu từ Cha/Mẹ này sang Cha/Mẹ khác.** |
| **Cutover** | **System Cutover** | **Thao tác chuyển đổi toàn bộ hệ thống từ cấu trúc cũ sang cấu trúc mới trong một thời điểm duy nhất.** |

