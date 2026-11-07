# A01 — Profile Task Shell (DRAFT)

```
PATH       : BFA/A01-Profile-Task-Shell-2026-09-06.md
DATETIME   : 2026-09-06T20:20:00+07:00
VERSION    : 0.1.0-DRAFT
STATUS     : APPROVED 
BFA        : BFA-Post-OP-myClan-v2.2.0 + Amendment 2.2.1 + Amendment 2.2.2 (BL/CL)
             Tài liệu này KHÔNG sửa 2.2.0 / 2.2.1 / 2.2.2.
REPOS      : QuangAGS/cmcodes (BE+FE) + CM-Docs
RP/OP      : CLOSED. Không mở lại SM.
Q1         : Một MemberProfilePage tham số hóa. Back một nhát về Hub.
Q2         : Header PATH / DATETIME / VERSION / DESCRIPTION trên file code khi triển khai.
```

## 1. Mục đích

Khóa **hợp đồng tương tác + tải dữ liệu** của hồ sơ thành viên (sống và đã mất):

- Trang là **tập việc**, không phải một form chứa hết CRUD.
- Màn đầu chỉ **thông tin cơ sở + chọn Mục hồ sơ**.
- Chỉ khi chọn mục: mới gọi form, mới sưu tập dữ liệu, mới CRUD trên đúng mục đó.
- Refresh trang hồ sơ = refresh **mục đang mở** (cộng shell nhẹ), không tải lại mọi mục.

Không đổi phạm vi nghiệp vụ BFA 2.2.0. Không đổi cửa BL/CL 2.2.2 (`MEMBER_PROFILE_PATCH` CL=NONE). Không mở RP/OP/SM.

## 2. Ranh giới

### Làm (khi lát được mở)

- Siết shell / section / lazy load trên `MemberProfilePage` hiện có.
- `?section=` + History `replace`.
- GET/PATCH theo mục (T0 / T1 / T2).

### Không làm trong spec này

- Tách 10 route / 10 page cho 10 mục.
- Đổi `/members/:id/profile` thành slug công khai hoặc bỏ `id` trên URL (P0-1c — tài liệu khác).
- Sửa `users.phone`, `users.email`, `members.gender`, `members.is_alive` qua A01.
- Inject `tenant_id` vào Prisma `update` / `findUnique`.
- Sửa schema `audit_logs`.
- Grant UI, `contact_via_member_id`, TanStack Query như mục tiêu chính.
- Convert Office → PDF lúc upload.

## 3. Một page, hai path

Cùng component: `frontend/src/pages/MemberProfilePage.jsx`.

| Path | Target |
|---|---|
| `/me/profile` | Hồ sơ của actor (SELF). Steward có thể `member_id` query/body theo M12. |
| `/members/:id/profile` | Hồ sơ thành viên `:id` cùng tenant. Giữ số nhiều `members` như code đang chạy. |

`canViewProfile` cho GET. `canEditProfile` cho PATCH/upload. `/me` SELF: `can_edit: true` khi còn sống và đúng member của actor.

Trang con **bước phụ** (giữ, không biến mọi mục thành trang con):

- `/me/profile/address`
- `/me/profile/achievement/:id/proof`
- `/me/profile/document`
- `/me/profile/biography/:topic/file`

Xong bước phụ → về đúng path hồ sơ + đúng `section`. Không chồng history mục.

## 4. URL việc đang làm

```
/me/profile
/me/profile?section=identity
/members/:id/profile
/members/:id/profile?section=death
```

| Quy tắc | Bắt buộc |
|---|---|
| Không `section` | Chỉ shell (T0). Không mount form mục. Không CRUD mục. |
| Có `section` | Mount đúng một panel. GET + mutate chỉ panel đó. |
| Đổi mục | `history.replace` query `section`. **Cấm** `push` mỗi lần đổi mục. |
| Back trình duyệt / nút Về | **Một nhát** rời hồ sơ → Hub (hoặc nơi gọi vào). Không đi ngược 10 mục. |
| F5 khi đang có `section` | Gọi T0 + T1 (và T2 nếu mục có media). Không gọi mục khác. |

`section` hợp lệ (mốc DRAFT; khớp dropdown đang chạy, có thể rút gọn nhãn khi triển khai):

`identity` | `birth` | `death` | `contact` | `address` | `bio` | `bio_read` | `ach` | `ach_read` | `docs` | `privacy`

- `death` luôn có trong dropdown. PATCH `death_*` chỉ khi `members.is_alive === false`. Không nhận `is_alive` trên A01.
- `bio_read` / `ach_read` = đọc; không dirty Lưu.

## 5. Ba tầng dữ liệu

### T0 — Shell (mỗi lần vào path hồ sơ)

Đủ biết **đang xem ai** và **được làm gì**. Một GET.

Gồm tối thiểu:

- `member.id`, `full_name`, `alias`, `generation`
- `is_alive`; nếu chết: `death_*` đủ để badge + `formatGio`
- URL đọc **một** avatar (không list media)
- `can_view`, `can_edit`
- Danh sách mục **được hiện** (ẩn mục nhóm privacy SELF nếu không `can_edit`)

Không gồm: đủ field mọi mục, list thành tích, list file tiểu sử/tài liệu, hai địa chỉ chi tiết, đủ 7 privacy rules.

### T1 — Payload mục (khi có `section` chỉnh sửa / đọc một nhóm field)

Một GET theo `section` (endpoint riêng hoặc query trên profile). Chỉ field + dirty map của mục đó.

`dirty` theo đúng mục đang mở (M12). Thiếu map → nút kẹt «Chưa có thay đổi» — cấm.

PATCH gầy: chỉ field mục + tối đa **một** `field_group` privacy nếu mục đó đụng privacy. Cấm gửi cả 7 privacy khi Lưu tiểu sử.

### T2 — Media mục

Chỉ khi `section` ∈ { `ach`, `ach_read`, `bio`, `docs` } (và avatar đổi ảnh — hành vi riêng, không list T2 lúc vào shell).

List file / proof / documents theo **canView** khi lát M-view-files mở; spec này không bắt buộc đổi điều kiện list ngay.

## 6. CRUD, refresh, dirty

- Nút lưu = «Lưu mục này».
- Xóa file trong mục = refresh list T2 của mục đó. Không `window.location` reload cả hồ sơ.
- Đổi `section` khi `dirty` → xác nhận bỏ thay đổi.
- Toast / `toastSpeak` / Nghe gắn nội dung panel đang mở.
- Sau Lưu thành công: cập nhật T1 tại chỗ; T0 chỉ khi field shell đổi (họ tên, giỗ, avatar).
- Audit ngoài TX hồ sơ (M12). BL `MEMBER_PROFILE_PATCH` CL=NONE (2.2.2). Không đổi schema audit.

## 7. Điểm vào FE (P0-2 — neo, không redesign)

Spec này không vẽ lại navigation. Khi lát P0-2a:

| Nguồn | Đích |
|---|---|
| Hub / menu tài khoản (DA_DUYET) | `/me/profile` không `section` |
| Danh sách / cây thành viên | `/members/:id/profile` không `section` |
| Admin vital | giữ `/admin/members/:id/vital` — không A01 |

Chốt: P0-2 = gắn chỗ đã có người → page hồ sơ, không = vẽ FE mới cho /me và /members/:id. Spec DRAFT mục 7 có thể ghi «neo mặc định = cây / danh sách; catalog admin không bắt buộc».
Không gắn lại RP/OP.

## 8. An ninh URL (P0-1)

`member_id` trên path **không** coi là lỗ hổng nếu mọi T0/T1/T2 kiểm `canView` / `canEdit`. Spec này **không** ẩn id bằng đổi route.

Bắt buộc: không tin id trên URL; USER khác tenant → 403 hoặc 404 thống nhất; JWT thiếu role/tenant → hydrate từ `users` như M12.

## 9. File then chốt khi triển khai (chưa đụng ở DRAFT)

```
frontend/src/pages/MemberProfilePage.jsx
frontend/src/App.jsx                    — không thêm 10 Route mục
Backend/src/modules/profile/profile.service.js
Backend/src/modules/profile/profile.routes.js
Backend/src/modules/members/profileAccess.service.js
```

Trang con address / proof / document / bio-file: chỉ chỉnh «về đúng section», không đổi nghiệp vụ form.

## 10. Tiêu chí APPROVED bản spec

- [ ] Human Authority duyệt bản này (đổi STATUS → APPROVED, tăng VERSION 1.0.0)
- [ ] File nằm `CM-Docs/BFA/` cạnh HandOver-M12
- [ ] HandOver-M12 trích dẫn file này là SSOT tương tác shell
- [ ] Không sửa PDF/MD BFA 2.2.0 / 2.2.1 / 2.2.2

## 11. Tiêu chí đóng khi *triển khai* (lát sau, có phiếu)

- Vào `/me/profile` không `section`: network không gọi list ach/docs/bio-files.
- Đổi 3 mục liên tiếp: History length không +3; Back về Hub.
- F5 `?section=address`: không tải ach/docs.
- Lưu họ tên: không GET lại 4 tài nguyên.
- USER xem `/members/<id-chết>/profile`: 200, badge + giỗ, không Thêm/Sửa/Lưu trên mục không `can_edit`.
- Q1: dropdown mục, dirty theo mục, ngày giỗ, toastSpeak, ALS — giữ hành vi đã đóng M12.

## 12. Việc cố ý để lát khác

- P0-1a audit IDOR chi tiết theo từng route media
- P0-3a đo waterfall (baseline trước code)
- M-view-files / nén ảnh / presign façade
- Amendment BFA 2.2.3 (chỉ nếu HA muốn đóng băng câu «hồ sơ = tập việc» thành luật sản phẩm)

---

**Kết thúc DRAFT 0.1.0 — A01 Profile Task Shell**
