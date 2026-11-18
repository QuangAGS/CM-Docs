# AMENDMENT TO NEW RP&OP — PHASE 2 (FINAL FROZEN BASELINE)

* **Mã tài liệu:** `AMEND-RP-OP-2026-03-BASELINE`
* **Phiên bản:** `7.0 (FINAL FROZEN APPROVED - ISO 29148 CERTIFIED)`
* **Trạng thái:** `FROZEN / READY FOR IMPLEMENTATION (SPRINT 1 KICKOFF)`
* **Ngày phê chuẩn:** `18/11/2026`
* **Phạm vi:** Bối cảnh nghiệp vụ, Chuẩn hóa Form (RPAP), Lát 0, Concurrency, Multi-Home, Guardian, Ledgers, Logic-tier Rate-limit, Xử lý biên và Ma trận Truy vết.

## 0.0. THUẬT NGỮ & ĐỊNH NGHĨA (GLOSSARY)

| Thuật ngữ / Viết tắt | Định nghĩa & Ý nghĩa trong ngữ cảnh dự án | 
| ----- | ----- | 
| **RP&OP** | *Registration of Persons & Official Records*: Phân hệ Đăng ký và Hồ sơ gia nhập (Onboarding). | 
| **MFO** | *My Family Office*: Phân hệ Quản lý Phả đồ sau khi user đã là thành viên. | 
| **RPAP** | *Registration of Persons Application Form*: Biểu mẫu đăng ký/khai báo thông tin gia nhập. | 
| **SSOT** | *Single Source of Truth*: Bảng `onboarding_cases` là SSOT cho mọi hồ sơ chờ duyệt. | 
| **Zero Ledger Pollution** | Nguyên tắc tuyệt đối không ghi dữ liệu chưa kiểm duyệt vào "Sổ cái". | 
| **Ledger** (Sổ cái) | Bảng dữ liệu cốt lõi, bền vững (VD: `members`, `user_member_links`, `parentages`). | 
| **Multi-Home** | Cơ chế cho phép một User tham gia nhiều dòng họ (Tenant) khác nhau cùng lúc. | 
| **Claim** (Xin nhận) | Gửi yêu cầu xác nhận quyền sở hữu đối với một node (vị trí) đã có trên phả đồ. | 
| **Guardian / Proxy** | *Người khai hộ / giám hộ*: Người tạo hồ sơ và quản lý thay cho một người khác (người già/trẻ em). | 
| **Idempotency** | Đặc tính API: Gọi nhiều lần với cùng tham số chỉ sinh ra side-effect đúng một lần. | 
| **Strict Lock Ordering** | Kỹ thuật khóa DB (Row-level lock) theo một thứ tự một chiều cố định để triệt tiêu Deadlock. | 
| **Transactional Outbox** | Mẫu thiết kế lưu event vào cùng một DB transaction với business data để đảm bảo nhất quán. | 
| **correlation_id** | Mã UUID (VarChar 36) liên kết toàn bộ vòng đời của hồ sơ trên các hệ thống Ledger. | 
| **claim_mode** | Phương thức xin gia nhập: `CREATE_NEW` (tạo mới) hoặc `CLAIM_EXISTING` (nhận chỗ có sẵn). | 
| **reopenable** | Cờ đánh dấu hồ sơ bị từ chối có được phép mở lại (`true`) hay bị khóa vĩnh viễn (`false`). | 

## 0. BỐI CẢNH NGHIỆP VỤ & BÀI TOÁN GIẢI QUYẾT (BUSINESS CONTEXT)

### 0.1. Những nỗi đau của hệ thống cũ (The "Why")

1. **Sổ cái bị ô nhiễm:** Đăng ký cũ ghi ngay vào bảng lõi `members`/`users`. Sinh ra vô số "node rác" trên phả đồ khi gặp spam.
2. **Giới hạn Single-Home:** Ép 1 tài khoản chỉ thuộc 1 dòng họ, đi ngược thực tế (Họ Nội, Họ Ngoại, Họ Vợ/Chồng). Cần cơ chế **Multi-Home**.
3. **Rào cản công nghệ:** Cần chức năng **Khai hộ (Proxy)** cho người cao tuổi/trẻ em để số hóa phả đồ, nhưng phải tự động thu hồi quyền khi "chính chủ" quay lại.

### 0.2. Ranh giới Trách nhiệm (RP&OP vs. MFO)

* **RP&OP (Phase 2):** Trả lời **"Người này là ai? Có tư cách vào họ không?"** (xác thực, cấp quyền).
* **MFO (Phase 3):** Trả lời **"Người này ngồi ở đâu trên cây?"**. Việc nối phả đồ (`parentages`) do Admin (MFO) tự làm thủ công.

### 0.3. Ba trụ cột Chống mạo danh (Trust & Safety)

1. **Xác minh nội bộ:** Xin vào họ bắt buộc phải được thành viên trong họ bảo lãnh (Referrer).
2. **Sàng lọc tri thức:** Câu hỏi bảo mật truyền thống. Sai 3 lần $\rightarrow$ Khóa QA.
3. **Xác minh ngoại tuyến:** Lập họ mới phải khai báo SĐT người lớn tuổi ($\ge 60$) để hệ thống gọi điện xác minh, chống chiếm tên dòng họ.

## 1. NGUYÊN TẮC LÁT 0 (ZERO LEDGER POLLUTION)

### `[ARCH-01]` Zero Ledger Pollution (Constraint)
* **Quy tắc:** Cấm tuyệt đối insert dữ liệu vào `members`, `branches`, `parentages`, `marriages`, `tenants`, `clan_profiles`, `user_member_links`, `profile_edit_grants` trước khi trạng thái case đạt `APPROVED`.
* **Whitelist Ghi Trước Duyệt:** `onboarding_cases`, `media` (loại `ONBOARDING_CASE`), `business_process_logs` và Communication Ledger.

### `[ARCH-02]` Hợp Đồng Cách Ly Legacy (Constraint)
* Ngừng ghi và cấm truy vấn nghiệp vụ từ `users.temp_*`, `users.member_id`, `users.tenant_id`. Bắt buộc đọc qua `user_member_links`.

### `[ARCH-03]` Ranh giới MFO & Cấm Lọc `is_clan` (Constraint)
* `ONBOARDING_APPROVE` **cấm tuyệt đối mọi logic tự động tạo/gợi ý `parentages` hoặc `branches`**. Dữ liệu `lineage_anchors` chỉ dùng để hiển thị.
* API Search Claim / Chọn Bảo lãnh **cấm** lọc theo `members.is_clan`. Chỉ lọc theo `tenant_id`, `status = CHINH_THUC`, `deleted_at IS NULL`.

## 2. CẤU TRÚC FORM RPAP & MAPPING

### `[FUNC-01]` Validation Phân Nhóm Dữ Liệu (Functional)
* Khởi tạo họ mới (`CLAN_SETUP`) cấm proxy. Gia nhập nhánh phụ (`FAMILY_BRANCH`) hiển thị "Khai báo thành viên nhánh phụ (chưa gắn cây)".

### `[FUNC-02]` Trạng Thái Người Bảo Lãnh (Functional/Exception)
* `referrer_member_id` bắt buộc kiểm tra `members.is_alive = true` lúc Nộp đơn **VÀ** lúc Approve.
* **Xử lý Ngoại lệ (Lúc Approve):** Nếu người bảo lãnh mất:
  1. Transaction bị chặn và rollback.
  2. Đẩy case về `NEEDS_REVISION` (`revision_reason = 'REFERRER'`). Vô hiệu hóa token referral hiện tại.
  3. Ghi log sự kiện `ONBOARDING_REVISION_REQUEST`.
  4. Gửi notification `ONBOARDING_REVISION_REQUESTED` cho Applicant yêu cầu chọn người khác.

### `[FUNC-03]` Khóa Câu Hỏi Bảo Mật (Functional)
* Nhập sai câu hỏi bảo mật 3 lần liên tiếp $\rightarrow$ Khóa QA (`qa_locked = true`), cấm User submit lại, chuyển Admin duyệt tay.

## 3. STATE MACHINE & STRICT LOCK ORDERING

### `[FUNC-04]` Cửa vào Multi-Home vs Khách (Functional)
* **Khách Mới (`CHO_DUYET`):** Bắt buộc xác thực OTP để rời khỏi trạng thái `DRAFT`.
* **Multi-Home (`DA_DUYET`):** Bỏ qua OTP, sinh case thẳng ở `PENDING_VERIFICATION` hoặc `SUBMITTED`.

### `[ARCH-04]` Thứ Tự Khóa Hàng (Strict Lock Ordering) (Constraint)
Bắt buộc tuân thủ thứ tự khóa một chiều sau trong DB transaction duyệt/nộp đơn (`SET LOCAL lock_timeout = '5s'`):
1. `SELECT ... FROM members WHERE id = target_id FOR UPDATE`.
2. `SELECT ... FROM users WHERE id = applicant_id FOR UPDATE`.
3. `SELECT ... FROM user_member_links WHERE user_id = applicant_id ORDER BY id ASC FOR UPDATE`.
4. `SELECT ... FROM onboarding_cases WHERE ... ORDER BY id ASC FOR UPDATE`.
* Lỗi `55P03` $\rightarrow$ Trả HTTP 409 `CONCURRENT_TRANSACTION_LOCKED`.

### `[FUNC-05]` Hợp Đồng Duyệt & Dọn Staging (Functional)
* **Tính `is_default`:** `COUNT` link default của User (dưới khóa 3). Nếu `= 0` $\rightarrow$ `is_default = true`.
* **Staging Media Cleanup:**
  1. Vật chất hóa file vào `media`, copy R2.
  2. Ghi cờ `PENDING` vào `metadata.staging_cleanup`. Commit DB.
  3. Gọi Job (best-effort) xóa object tạm ở R2. Bắt `NoSuchKey` để đảm bảo idempotent. Nếu Job thất bại, Worker 15 phút sẽ quét bù dựa trên cờ `PENDING`.

## 4. CLAIM DISPUTE & GUARDIAN CONTRACTS

### `[FUNC-06]` Tranh Chấp Claim & Bypass Soft-Delete (Functional/Constraint)
* **Thắng:** UPSERT `user_member_links` theo `(user_id, tenant_id)`. **Bắt buộc dùng Raw SQL** (`$queryRaw`/`$executeRaw`) để bypass middleware soft-delete của Prisma, đảm bảo tái sử dụng đúng dòng đã xóa (tránh lỗi `P2002`).
* **Thua:** Ép case về `REJECTED` (`reopenable = true`), hủy token.

### `[FUNC-07]` Thu Hồi Quyền Giám Hộ - Cascade (Functional)
* Khi EU Claim lại Node $\rightarrow$ Soft-delete **CHỈ** dòng `user_member_links` có `link_type = GUARDIAN` của người khai hộ, chuyển `profile_edit_grants.status = THU_HOI`.
* Bắt buộc chạy đồng bộ (synchronous) trong cùng DB transaction.

## 5. BUSINESS & COMMUNICATION LEDGERS

### `[FUNC-08]` Business Process Logs (Functional)
* Ghi log gắn `correlation_id`.
* Mở khóa QA: Admin chỉ được mở 1 lần/case. Việc đếm `attempt_no` và kiểm tra logic giới hạn **chỉ được gọi sau khi đã khóa case (Lock số 4)** trong transaction.

### `[NFR-01]` Transactional Outbox & Idempotency (Non-Functional)
* Không đẻ bảng Outbox riêng. Ghi thẳng vào `notifications` gắn `correlation_id` cùng transaction.
* Idempotency: `decideReferral` lần 2 (khác `PENDING`) trả HTTP 200, không ghi log.

## 6. PROACTIVE DEFENSE & CLEANUP

### `[NFR-02]` Fail-Safe Rate Limiter (Non-Functional)
* Chạy Lua script nguyên tử (INCR + EXPIRE).
* **Public Search:** Redis down $\rightarrow$ Không Fail-open (100% bắt Turnstile).
* **In-App Search:** Redis down $\rightarrow$ Hạ cấp dùng `LRUCache` in-memory.

### `[NFR-03]` Ngắt mạch Claim Hopping 90 ngày (Constraint)
* HTTP 403 nếu $\ge 2$ case `REJECTED` (`reopenable = false`) trong 90 ngày qua.
* **Bảo vệ Query Planner:** Lệnh đếm trong ORM bắt buộc phải truyền thứ tự cột đúng theo index: `user_id`, `tenant_id`, `claim_mode`, `status`, `reopenable`, `updated_at`.

### `[FUNC-09]` Cooldown 7 ngày Bảo lãnh (Functional)
* Nếu referrer từ chối (`DECLINED`), applicant bị chặn 7 ngày không được nhờ lại referrer đó (kiểm tra qua `metadata.referral_history`).

### `[FUNC-10]` Token Invalidation (Functional)
* Hủy toàn bộ token (OTP, referral, beneficiary) ngay lập tức (chạy đồng bộ) khi State Machine chuyển case sang các trạng thái kết thúc (`APPROVED`, `REJECTED`, `CANCELLED`, `EXPIRED`).

### `[ARCH-06]` Quy chuẩn Namespace JSON (Constraint)
* Mọi cấu trúc JSON động lưu trên case phải đưa vào namespace chuẩn để tránh xung đột key. Cấu trúc yêu cầu:
  * `metadata.staging_cleanup`: `{ cleanup_status: 'PENDING' | 'CLEANED' | 'FAILED', prefix: string }`
  * `metadata.offline_verifications`: `[{ id: string, endorser_name: string, call_status: 'VERIFIED' | 'UNREACHABLE' }]`
* Không lưu phẳng tại root.

## 7. SCHEMA DIFF BỔ SUNG

### `[ARCH-05]` Ràng buộc CSDL (Constraint)
* `grantee_member_id` được `DROP NOT NULL`. `CHECK XOR` giữa `grantee_member_id` và `grantee_user_id`.
* Constraint độ dài `agreed_rules_snapshot` tối đa 30.000 ký tự.

## 8. TIÊU CHÍ NGHIỆM THU (ACCEPTANCE CRITERIA)

* **AC1 (`[ARCH-04]`, `[FUNC-05]`):** Bắn 2 request Approve và 1 request Claim trúng 1 node $\rightarrow$ Không deadlock (409), đếm `is_default` chuẩn xác.
* **AC2 (`[FUNC-07]`):** Mất link `GUARDIAN` $\rightarrow$ Toàn bộ `profile_edit_grants` liên quan bị revoke đồng bộ.
* **AC3 (`[NFR-01]`, `[FUNC-08]`):** Bấm Magic Link lần 2 $\rightarrow$ Trả 200, không ghi đè Ledger, không tăng attempt.
* **AC4 (`[ARCH-06]`):** Bị khóa duyệt `CLAN_SETUP` nếu thiếu cờ `VERIFIED` trong `metadata.offline_verifications`.
* **AC5 (`[NFR-02]`):** Ngắt Redis $\rightarrow$ Public chặn đòi Turnstile; In-App chạy qua LRUCache.
* **AC6 (`[ARCH-01]`, `[ARCH-03]`):** Case đang xử lý tuyệt đối không lọt dữ liệu sang `members`/`branches`.
* **AC7 (`[ARCH-05]`, `[FUNC-06]`):** Insert vi phạm `CHECK XOR` bị chặn ở tầng DB; Soft-delete tái sử dụng slot thành công không văng `P2002`.
* **AC8 (`[FUNC-09]`):** Gửi lại yêu cầu bảo lãnh bị từ chối hôm qua $\rightarrow$ Trả HTTP 400 (Cooldown).
* **AC9 (`[FUNC-10]`):** Tác động vào OTP link của một case đã `REJECTED` $\rightarrow$ Trả HTTP 410 Gone / Invalid.
* **AC10 (`[FUNC-03]`):** Nhập sai câu hỏi bảo mật 3 lần $\rightarrow$ `qa_locked` cập nhật thành `true`, UI chặn submit.
* **AC11 (`[NFR-03]`):** User có 2 case bị REJECTED (reopenable=false) trong 90 ngày $\rightarrow$ API trả lỗi HTTP 403 khi cố tạo case thứ 3.

## 9. MA TRẬN TRUY VẾT YÊU CẦU (TRACEABILITY MATRIX)

| Mã ID | Phân loại | Mục liên quan (Bài toán) | Tiêu chí Nghiệm thu (AC) | 
| ----- | ----- | ----- | ----- | 
| `[ARCH-01]` | Constraint | 0.1.1 (Tránh Ledger Pollution) | AC6 | 
| `[ARCH-02]` | Constraint | 0.1.1 (Cô lập Legacy) | AC6 | 
| `[ARCH-03]` | Constraint | 0.2 (Ranh giới MFO) | AC6 | 
| `[ARCH-04]` | Constraint | 0.1.2 (Concurrency / Multi-Home) | AC1 | 
| `[ARCH-05]` | Constraint | 0.1.3 (Ràng buộc Schema) | AC7 | 
| `[ARCH-06]` | Constraint | 0.3.2 (Cấu trúc dữ liệu chuẩn) | AC4 | 
| `[FUNC-01]` | Functional | 0.1.3 (Logic form UI) | AC4 (Gián tiếp) | 
| `[FUNC-02]` | Functional | 0.3.1 (Niềm tin Referrer) | AC3 (Gián tiếp) | 
| `[FUNC-03]` | Functional | 0.3.1 (Câu hỏi bảo mật) | AC10 | 
| `[FUNC-04]` | Functional | 0.1.2 (Multi-home bypass) | AC1 | 
| `[FUNC-05]` | Functional | 0.1.2, 0.3.2 (Approve Contract) | AC1, AC4 | 
| `[FUNC-06]` | Functional | 0.1.2 (Tranh chấp / Raw SQL UPSERT) | AC7 | 
| `[FUNC-07]` | Functional | 0.1.3 (Thu hồi Guardian) | AC2 | 
| `[FUNC-08]` | Functional | 0.1.1 (Business Logs sau khóa) | AC3 | 
| `[FUNC-09]` | Functional | 0.3.1 (Cooldown bảo lãnh) | AC8 | 
| `[FUNC-10]` | Functional | 0.1.1 (Dọn dẹp token đồng bộ) | AC9 | 
| `[NFR-01]` | NFR | 0.1.1 (Outbox / Idempotency) | AC3 | 
| `[NFR-02]` | NFR | 0.1.1 (Fail-Safe Rate Limit) | AC5 | 
| `[NFR-03]` | NFR | 0.1.1 (Claim Hopping / Index order) | AC11 | 

## 10. THỨ TỰ ROLLOUT KỸ THUẬT (4 BƯỚC)

1. **Bước 1 (DB Foundations):** Schema Migrations (`ARCH-05`, `ARCH-06`).
2. **Bước 2 (Defense & Logic):** Strict Lock Ordering (`ARCH-04`, `FUNC-06`), Rate Limiter (`NFR-02`).
3. **Bước 3 (Async & Workers):** Staging Cleanup Idempotent Worker, Transactional Outbox.
4. **Bước 4 (API & UI Exposure):** Mở UI Multi-Home, Claim Form, Admin Review.