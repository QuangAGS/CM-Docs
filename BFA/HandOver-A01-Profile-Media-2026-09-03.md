# HandOver — A01 /me/profile + Media (Avatar / Proof / Tài liệu khác)

**PATH** : CM-Docs/BFA/HandOver-A01-Profile-Media-2026-09-03  
**DATETIME** : 2026-09-03T16:30:00+07:00  
**VERSION** : 1.0.0  
**REPO CODE** : QuangAGS/cmcodes (`Backend/` + `frontend/`)  
**REPO DOCS** : QuangAGS/CM-Docs  
**SSOT TRƯỚC** : HandOver-Post-OP-A01-2026-08-28 ; HandOver-BFA-222-B3-A01-BL-2026-09-01  
**BFA** : BFA-Post-OP-myClan-v2.2.1-Amendment + Amendment v2.2.2 (BL/CL)  
**Q1** : RP/OP CLOSED. Không mở lại SM.  
**Q2** : Header PATH / DATETIME / VERSION / DESCRIPTION trên file đụng tới.

Thread này đã dài. Thread mới **bắt đầu bằng file này**, không mở lại SM, không sinh code lớn trước khi xác nhận lát.

---

## 0. Prompt mở thread mới (copy)

```
Tiếp myClan.com.vn.
SSOT: HandOver-A01-Profile-Media-2026-09-03.
Repos QuangAGS/cmcodes + CM-Docs.
RP/OP CLOSED. Không mở lại SM.
Đã xong: S0 isolation, Hub v2 /admin/tenants, A01 /me/profile (+ địa chỉ, tiểu sử, thành tích, avatar P0, proof P0, tài liệu khác P0 khung).
Khóa: không inject tenant vào prisma update/findUnique; A01 không sửa users.phone hay gender; place ≠ usage; AVATAR/LOGO singleton; CERTIFICATE/DOCUMENT không singleton.
Mở: (1) tên file UTF-8 khi Save as / download; (2) nén ảnh (không JPEG→PNG); (3) G-media presign PUT dùng chung; (4) member đã mất; (5) file tiểu sử; (6) cây thư mục FE theo Architecture docs.
Đọc HandOver rồi đề xuất lát nhỏ, chưa sinh code lớn.
```

---

## 1. Lộ trình đã định nghĩa (sau BFA 2.2.1 + Amendment)

Không mở lại RP/OP/SM. Làm **Post-OP A01** trên `/me`.

| Đợt / lát | Trạng thái | Ghi chú |
|---|---|---|
| S0 tenant isolation (ALS / prisma.js) | XONG | Mọi query tenant-scoped phải có ALS. Không inject `tenant_id` vào `findUnique` / `update`. |
| Hub v2 `/admin/tenants` | XONG | Ngoài phạm vi thread A01 `/me`. |
| A01 GET/PATCH `/me/profile` | XONG (sống) | Identity, birth, contact, privacy CONTACT/BIRTH_DATE/ACHIEVEMENT. Không sửa `users.phone`, `gender`, `is_alive`. |
| Địa chỉ intl + GET `/api/me/addresses` | XONG khung | Model `addresses` chuẩn hóa; `full_address` unique theo tenant+country; form tách trang. |
| AddressForm + catalog VN 34 tỉnh | XONG hướng đơn catalog | Một catalog 34 tỉnh + xã/phường; `locality` (quận/huyện) để trống; `notes` ghi địa danh cũ. |
| P1 tiểu sử | XONG khung | Dropdown chủ đề; RA = item “Đọc toàn bộ tiểu sử”; voice; chưa file/voice upload theo chủ đề. |
| P1 thành tích | XONG khung | Catalog category/sub_category; CRUD `/me/achievements`; editor + reader. |
| BFA 2.2.2 BL/CL | XONG B3 BL | A01 ghi BL; **CL = NONE**. Không silentIntent, không Zalo/mail/SMS. |
| Audit A01 | XONG smoke manual | PATCH profile + bio + address + achievement đã sinh `audit_logs` cùng `correlation_id` (sau fix). |
| Avatar P0 | XONG prod | 1 hàng `media` AVATAR; crop = `LogoCropModal`; overwrite-in-place; R2 private + presign. |
| Proof thành tích P0 | GẦN XONG | Form tách `/me/profile/achievement/:id/proof`; `purpose=CERTIFICATE`; không singleton. |
| Tài liệu khác P0 khung | MỚI (artifact, cần đẩy repo) | Mục `docs`; `/me/documents`; quota 30MB. |
| G01 PROFILE_CORRECTION | CHƯA | Đề xuất ban đầu sau HandOver 2026-08-28; chưa mở. |

---

## 2. Khóa / bất biến (thread mới phải giữ)

- RP / OP / SM **CLOSED**.
- Không `findUnique` / `update` inject `tenant_id`. Dùng `findFirst` + `updateMany` + `where.tenant_id` + ALS.
- A01 không sửa `users.phone`, `users.gender`, `members.is_alive` (trừ khi có lát riêng có chủ đích).
- `place ≠ usage`: chỗ địa lý (`addresses`) khác cách dùng (quê / cư trú / nghĩa trang…).
- `AVATAR` / `LOGO` = **singleton** (1 hàng sống / entity). `CERTIFICATE` / `DOCUMENT` / `GALLERY` = **không** singleton.
- `file_url` trên `media` **không** SSOT đọc khi bucket private. SSOT đọc = `storage_key` + presign. `file_url` chỉ khi public base / EXTERNAL.
- Tên file hiển thị SSOT = `media.file_name` (UTF-8 NFC), không suy từ object key.
- BL A01: `correlation.create()` từ `prisma.js`. Nhiều BPL một request: cùng `correlation_id`, khác `attempt_no`. CL = NONE.
- Q1: không phá UI/logic cũ. Q2: header file. Không sinh code lớn trước khi user xác nhận lát.

---

## 3. Model / API đang dùng

### 3.1 `addresses` (schema Đợt 2)

`country_code`, `postal_code`, `admin_area`, `locality`, `sub_locality`, `line1`, `line2`, `full_address`, `notes`, geo.  
Unique `(tenant_id, country_code, full_address)`. GIN trgm trên `full_address`.  
Member: `origin_address_id` (quê), `current_address_id` (cư trú / nơi ở cuối nếu mất).

Quyết định catalog: **một** danh mục 34 tỉnh + xã/phường cho cả quê và cư trú. `locality` trống. Địa danh cũ ghi `notes`.

### 3.2 `achievements`

`category` enum + `sub_category` mã catalog (không tự do tiếng Việt).  
`issued_by` (không còn `organization`).  
`proof_urls` / `status` / `verified_by` **không có trên schema main hiện tại** — proof đi qua `media`.

### 3.3 `media`

Polymorphic: `entity_type` string (`TENANT` | `MEMBER` | `ACHIEVEMENT` | …), `entity_id`, `purpose` enum (`LOGO|AVATAR|DOCUMENT|CERTIFICATE|GALLERY|ONBOARDING|OTHER`), `is_primary`, `storage_key`, `file_url` (fallback), `file_name`, `caption`, soft `deleted_at`.

### 3.4 `/me` routes (profile.routes)

- GET/PATCH `/profile`
- GET `/addresses`
- GET/POST/DELETE `/avatar`
- GET/POST `/achievements`, PATCH/DELETE `/achievements/:id`
- POST `/achievements/:id/proofs`, DELETE `/achievements/:id/proofs/:mediaId`
- GET/POST `/documents`, DELETE `/documents/:mediaId` (artifact — cần đẩy repo)

Actor `/me`: `resolveMemberActor` + `actorFromReq` (bắt `tenantId` từ JWT). Mọi cửa Prisma phải `runWithTenantContext`.

---

## 4. File / version đáng nhớ

| File | Version gần nhất (thread) |
|---|---|
| `Backend/src/lib/prisma.js` | S0.1 ALS; `correlation.create()` |
| `Backend/src/modules/profile/profile.service.js` | 1.4.x BFA-222-AUDIT — pick body phẳng + biography + privacy + address |
| `Backend/src/modules/profile/achievements.service.js` | 1.2.1-A01-PROOF-ALS |
| `Backend/src/modules/profile/avatar.service.js` | overwrite-in-place AVATAR |
| `Backend/src/modules/profile/documents.service.js` | 1.0.0-A01-DOCS (artifact) |
| `Backend/src/modules/profile/profile.routes.js` | 1.3.x + documents |
| `Backend/src/modules/interactions/media.service.js` | uploadAndRegister / getByEntity / deleteMedia / getReadUrl |
| `Backend/src/shared/storage/r2.client.js` | 1.1.0 checksum WHEN_REQUIRED + trim key |
| `Backend/src/shared/storage/r2.storage.service.js` | 1.3.0 NFC + Content-Disposition + metadata ASCII |
| `Backend/src/services/bpl.service.js` | 1.1.0 bắt `tx` |
| `Backend/src/services/businessLogSchemas.js` | MEMBER_PROFILE_PATCH, ACHIEVEMENT_UPSERT/DELETE, MEMBER_ADDRESS_LINK |
| `frontend/src/lib/apiClient.js` | 14.1.0 xóa Content-Type khi FormData |
| `frontend/src/pages/MemberProfilePage.jsx` | dropdown mục hồ sơ + avatar crop + docs |
| `frontend/src/pages/AddressFormPage.jsx` | form địa chỉ tách trang |
| `frontend/src/pages/ProofUploadPage.jsx` | form proof tách trang |
| `frontend/src/pages/DocumentUploadPage.jsx` | form tài liệu tách trang (artifact) |
| `frontend/src/features/admin/components/LogoCropModal.jsx` | crop avatar/logo |
| `frontend/src/features/member/components/AchievementSection.jsx` | editor + reader + ProofStrip |
| `frontend/src/features/member/constants/achievementCatalog.js` | category / sub_category; `achievementFromApi` **chưa** copy `proofs` — caller phải spread `proofs` |

Domain prod: `myclan.com.vn`. R2 bucket SSOT env: khớp `R2_BUCKET` (đã từng lệch `myclan-storage` vs `myclan-media`).

---

## 5. Việc đã xong trong thread (chi tiết vận hành)

### Hồ sơ /me
- Dropdown “Mục hồ sơ”: identity, birth, contact, address, bio, bio_read, ach, ach_read, docs, privacy.
- Màn chính: avatar + họ tên + giới tính + DOB + đời.
- Privacy: enum DB chỉ `CONTACT | ACHIEVEMENT | BIRTH_DATE` × `SELF | TENANT`. Chưa có group ADDRESS / BIO / DOCUMENT / AVATAR — **không** bịa enum khi chưa migrate.

### Địa chỉ
- Form tách `/me/profile/address?usage=origin|current&mode=edit|create`.
- Quê: chỉ Sửa khi đã có chỗ. Cư trú: Sửa + Thay đổi/Tạo mới (di trú).
- Member mất: quê giữ; nơi ở hiện tại có thể “chưa rõ” hoặc nghĩa trang — **ghi nợ**, `/me/profile` đang gắn login (thường còn sống).

### Tiểu sử
- Editor theo 1 chủ đề; RA là item dropdown.
- Nợ: file theo chủ đề, voice upload, sửa vs nhập đã có trên form chữ.

### Thành tích
- CRUD + catalog sub_category theo category.
- Proof: `POST /me/achievements/:id/proofs` field `file` + `caption`; `DELETE .../proofs/:mediaId`.
- Form tách `/me/profile/achievement/:id/proof`.
- Nút “Thêm minh chứng” trên **form Thành tựu khi đã có id** và trên **card Đọc toàn bộ**.

### BL / Audit
- PATCH profile ghi `MEMBER_PROFILE_PATCH` (payload member + biography sau khi sửa pick + schema).
- Achievement ghi `ACHIEVEMENT_UPSERT` / `DELETE`.
- Proof dùng lại `ACHIEVEMENT_UPSERT` `op=CREATE` (schema không có `PROOF`; không throw). BPL proof **best-effort** (try/catch) để upload không chết vì ledger.
- Audit đã smoke manual OK cho các mục hồ sơ chính.

### Avatar
- POST `/me/avatar` multipart `file`; LogoCropModal; 1 hàng AVATAR; overwrite-in-place.
- Lỗi đã gặp và xử lý: S0.1 ALS; MEDIA_NO_FILE (FormData Content-Type); P1017 connection; R2 bucket lệch; SignatureDoesNotMatch (checksum SDK + metadata Unicode). Prod avatar: user redeploy + xóa cache → OK.

### R2
- Private bucket. `file_url` không SSOT.
- Client 1.1.0: `requestChecksumCalculation: 'WHEN_REQUIRED'`, trim key.
- Tên file: decode latin1→utf8 + NFC; metadata ASCII; `file_name` DB UTF-8.

---

## 6. Lỗi đã gặp (để khỏi debug lại)

| Triệu chứng | Nguyên nhân | Cách xử lý đã dùng |
|---|---|---|
| S0.1 Tenant context missing `members.findFirst` trên POST avatar/proofs | Route/service gọi Prisma trước ALS | `runWithTenantContext` + `actorFromReq.tenantId` |
| MEDIA_NO_FILE | Axios đặt Content-Type làm hỏng boundary | `apiClient` xóa Content-Type khi FormData |
| P1017 Server has closed the connection | Pool/Supabase idle | Restart / redeploy |
| R2 GET 404 path bucket lạ | `R2_BUCKET` lệch process đang chạy | Khớp env + restart + upload lại |
| SignatureDoesNotMatch | Checksum SDK v3 và/hoặc metadata Unicode | Checksum WHEN_REQUIRED; metadata ASCII; tên Unicode chỉ ở DB + Content-Disposition |
| BPL payload thiếu member/biography | Schema/pick không nhận nested body | `MEMBER_PROFILE_PATCH` nhận `payload.member` + `biography` |
| Audit null cùng correlation | `writeAudit` không chạy / tx / version cũ | Kiểm `VERSION` + `grep writeAudit`; smoke theo từng mục |
| SyntaxError `ACHIEVEMENT_UPSERT` trong schemas | Schema nằm ngoài object / token `:` | A01 schemas **trong** `BusinessLogSchemas` |
| `correlationId` khai báo 2 lần trong profile.service | Trùng `const` | Một lần `correlation.create()` |

---

## 7. Nợ mở (thread mới)

### P0/P1 ngay
1. **Download UTF-8** — list/UI đúng; Save as vẫn méo. Đã gắn presign `ResponseContentDisposition: attachment; filename=; filename*=UTF-8''`. Nếu vẫn méo (R2/CORS): lát `GET /me/documents/:id/download` và proof tương ứng, stream qua BE (JWT cookie/header).
2. **Nén ảnh** — **không** JPEG→PNG (PNG lossless thường lớn hơn). Muốn nhẹ: **sharp → WebP hoặc JPEG q~75–82**, resize cạnh dài ≤ 1600. Avatar 512 PNG vuông giữ. PDF/Office không convert. Chưa code.
3. Smoke **Tài liệu khác**: route App, quota 30MB, xóa R2, caption bắt buộc.
4. Smoke proof sau thu hẹp MIME (Office trên thành tích phải 400).

### Ghi nợ cũ
- Member đã mất: label quê / nơi ở cuối / nghĩa trang; `/me/profile` đang gắn login.
- File + voice theo chủ đề tiểu sử.
- Cây thư mục FE address/media vs [CM-Docs Architecture docs](https://github.com/QuangAGS/CM-Docs/tree/main/Architecture%20docs).
- G-media: presign PUT browser→R2, CORS bucket, pending/confirm, không lộ key.
- Privacy enum chưa có DOCUMENT / ADDRESS / BIO / AVATAR.
- G01 PROFILE_CORRECTION.
- B4/B5 CL / silentIntent (ngoài A01).
- Hash chain VOL I-03.

---

## 8. Lát nhỏ đề xuất cho thread mới (chọn 1)

**A.** Download UTF-8 chắc: endpoint stream BE + `download` trên FE (ưu tiên nếu presign vẫn méo).  
**B.** Nén ảnh lúc upload (sharp → WebP/JPEG, không PNG), chỉ ảnh, không đụng PDF.  
**C.** Hoàn thiện smoke Tài liệu khác + privacy group nếu cần migrate enum.  
**D.** File tiểu sử (1 chủ đề = n DOCUMENT, caption = mã chủ đề).  
**E.** G-media presign PUT dùng chung (sau khi A ổn).

Không làm A+E cùng lúc.

---

## 9. Quy ước cộng tác (nhắc thread mới)

- Không sinh mã trước khi user xác nhận lát.  
- Q1 bảo toàn. Q2 header file.  
- Báo cáo ngắn: đã xong / khóa / nợ / next 1 lát.  
- Tiếng Việt cho trao đổi sản phẩm; checklist bảo mật có thể English.

**RP/OP CLOSED. Không mở lại SM.**
