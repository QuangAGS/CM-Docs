# HandOver M13 — Branch (Chi họ) + khóa Profile

**PATH**       : CM-Docs / BFA / HandOver-M13-Branch-2026-09-11.md  
**DATETIME**   : 2026-09-11T11:50:00+07:00  
**VERSION**    : 1.0.0  
**STATUS**     : HANDOFF — chuyển thread  
**REPOS**      : QuangAGS/cmcodes (BE+FE) · QuangAGS/CM-Docs  
**SSOT**       : BFA-Branch-v1.1.0.docx · BFA/HandOver-M12-Member-Profile-2026-09-06.md  
**DOMAIN**     : myclan.com.vn  

Q1 bảo toàn. Q2 header file. Không sinh mã lớn trước khi hỏi. RP/OP/SM **CLOSED**.

---

## 1. Bối cảnh thread cũ

Profile member sống/mất (`/me/profile`, `/members/:id/profile`) đã UAT + cải tiến section (chọn việc nào làm việc đó). Địa chỉ = place `addresses` ≠ usage `member_residences`. Phát tích tenant + checkbox quê = phát tích họ. CRUD chi ADMIN mở; parent_id nullable; chặn vòng; `commonService` DEFAULT_ID bọc ở controller.

Đóng thread tại: **Lát 3 Branch BP — enum đã migrate, catalog notify/BPL chưa viết.**

---

## 2. Khóa không được phá

- ALS; không inject `tenant_id` vào Prisma `update` / `findUnique`
- A01: không sửa `users.phone`, `users.email`, `members.gender`, `members.is_alive`
- place ≠ usage; AVATAR/LOGO singleton; CERTIFICATE/DOCUMENT không singleton
- không sửa schema `audit_logs`
- `members.phone` / `members.email` không unique
- EDITOR chi ≠ `users.status` (status = vòng đời tài khoản)
- Không mở lại SM / RP / OP; JoinClan vẫn `temp_*`
- Multi-home (một user nhiều họ) = **nợ kiến trúc**, không làm đợt Branch

---

## 3. Đã xong (có thể coi đóng)

### Profile / địa chỉ
- Hub `?section=` ; ach/bio list ≥1 dòng; contact QR/url; address cards
- `member_residences` + kind: ORIGIN | RESIDENCE | TEMPORARY | LAST | RESTING
- Unique partial `is_current`; RESTING từ graves; LAST = nơi ở cuối (đã mất)
- Search địa chỉ scoped (tạm chấp nhận); geo lưu được; reuse_place không `updateMany` place share
- Xóa lịch sử = soft-delete **residence only**, không xóa `addresses`

### Phát tích / quê
- `tenants.origin_address_id`, `branches.origin_address_id`
- `/admin/tenant/origin` + work item
- Checkbox «Dùng nơi phát tích họ làm quê quán» trên `?section=address`
- `clan_profiles` = lời kể (`origin_summary`), không phải FK chỗ

### Cây chi (tổ chức)
- `parent_id` FK + relation `BranchTree`; không bắt buộc lúc tạo
- `branchCycle.js` chặn self + vòng
- POST chi gốc: **xóa** `parent_id` rỗng — `commonService.create` biến `*_id` falsy thành UUID `0000…`
- FE `/admin/branches` + `AdminProtectedRoute` (không `RequireAuth`)
- Work item «Chi / ngành» — SYSTEM có; CLAN_ADMIN phải có + `when` HOAT_DONG|TAM_NGUNG

### Lát 3 enum (DB + Prisma)
`business_process_type`: BRANCH_DRAFT_CREATE, BRANCH_SUBMIT, BRANCH_APPROVE, BRANCH_REJECT, BRANCH_EDITOR_GRANT, BRANCH_EDITOR_REVOKE, BRANCH_MERGE, BRANCH_MEMBER_ATTACH  

`notification_event`: BRANCH_SUBMITTED, BRANCH_APPROVED, BRANCH_REJECTED, BRANCH_MERGED, BRANCH_EDITOR_ASSIGNED, BRANCH_EDITOR_REVOKED, BRANCH_MEMBER_ATTACHED  

`proposal_ticket_type`: BRANCH_REVIEW  

`branch_status` **không** thêm (đã DRAFT…ARCHIVED).

---

## 4. Đóng về nghiệp vụ (BFA-Branch-v1.1.0)

- Hai cây tách: chi = `parent_id`; người = `father_id`/`mother_id`. Không sinh chi từ sơ đồ người.
- 4 đời = khung hiển thị / định vị login, không CHECK DB.
- Gửi duyệt (máy): `founder_id` + ≥1 cặp cha/mẹ–con cùng `branch_id`.
- Vòng đời một chiều: DRAFT → SUBMITTED → UNDER_REVIEW → APPROVED → MERGED. Tạo DRAFT không cần ADMIN. PROVISIONAL giữ cho OP.
- EDITOR ngữ cảnh = grant `BRANCH_PROFILE` / `member_offices`, không `users.status`.
- Người đầu tạo chi + gắn member đầu = ứng viên EDITOR. USER đã thuộc chi không POST chi mới (lát 6).
- Ghép = `parent_id` + preview offset `generation` — không bịa huyết thống.
- silentIntent: persist-first, `silentEmit` không throw; title/content xưng «bác»; thiếu `NotificationMetadataSchemas` thì Builder fail (BP vẫn sống nếu bọc silent).
- Bảng đúng: `notification_recipients` (không viết nhầm reciepients).

---

## 5. Nợ / chưa làm

| Ưu tiên | Việc |
|---|---|
| Lát 3 tiếp | NotificationMetadataSchemas + EVENT_TEXT + reliabilityPolicy + BusinessLogSchemas whitelist |
| Lát 3 | API SUBMITTED / APPROVE / REJECT + proposal BRANCH_REVIEW + silentEmit sau commit |
| Lát 1 (bỏ lỡ, nên xen hoặc trước emit USER) | founder_id picker + gắn `members.branch_id` |
| Lát 2 | Checklist UI founder + cặp cha–con |
| Lát 4 | Ghép + preview generation |
| Lát 5 | Cắt 4 đời + `users.branch_id` sau APPROVED |
| Lát 6 | Ủy quyền EDITOR; cấm USER tạo chi 2 |
| Nợ profile | Nén WebP; R2 presign; list file canView; grant UI; cây FE |
| Nợ kiến trúc | `user_memberships` (1 user nhiều tenant) |
| FE | Work item branches trên CLAN_ADMIN nếu chưa merge |

---

## 6. File / zip đã đưa trong thread (tham chiếu)

- BFA-Branch-v1.0.0.docx / v1.1.0.docx (silentIntent)
- 20260911_branch_bp_enums.sql
- 20260910_residence_audit_proc.sql
- myclan-BRANCH-CRUD.zip, myclan-BRANCH-NULL-PARENT.zip
- myclan-CLAN-ORIGIN.zip, myclan-WORK-ITEMS-FIX.zip
- branch.controller 2.1.0-CYCLE — xóa `*_id` rỗng lúc create

FE App: lazy `AdminBranchesPage`, `AdminTenantOriginPage`; bọc `AdminProtectedRoute`.

---

## 7. Việc thread mới làm trước

1. Xác nhận `npx prisma generate` + SELECT enum khớp.  
2. Mở **catalog** (schema + EVENT_TEXT + BPL whitelist) — chưa form.  
3. Hoặc Lát 1 founder + `branch_id` nếu muốn chi «có nghĩa» trước khi duyệt.

Không xen marriages / cây đồ họa lớn / multi-home / RP-OP.
