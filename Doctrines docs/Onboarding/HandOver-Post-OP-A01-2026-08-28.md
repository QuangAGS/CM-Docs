# HandOver — Post-OP / A01 / Hub v2

**Ngày:** 2026-08-28  
**Repos:** `QuangAGS/cmcodes` + `QuangAGS/CM-Docs`  
**SSOT process:** BFA Post-OP (v2.2.x) + các HandOver RP/OP đã đóng  
**Trạng thái thread này:** A01 chạy được; địa chỉ có search trong họ; **chưa freeze G01 / hôn nhân / cây**

Không mở lại state machine RP / OP trừ bug production.

---

## 1. Đã đóng

| Lát | Kết quả |
|---|---|
| RP + OP MEMBER_PROMOTE / CLAN_SETUP | E2E PASS trước thread này. OP đóng: MEMBER_JOIN → THANH_VIEN CHINH_THUC; CLAN_SETUP → CLAN_ADMIN + tenant HOAT_DONG |
| S0.1–S0.5 | Isolation Prisma ALS, fail-closed STRICT, unique `users.member_id`, `sysAccess`, unlink null `member_id` |
| Hub v2 P0 | `/admin/tenants` SYS directory, pageKey `admin`, Home `/`, Back `/admin`. Activate hẹp TAM_NGUNG→HOAT_DONG trang cũ. Không card Activate trên hub SYS |
| Đợt 2a | `clan_profiles`, `generation_naming_rules`, `proposals`, `member_privacy_rules` + enum. STRICT + SOFT_DELETE |
| Đợt 2b A01 | `GET/PATCH /api/me/profile`, UI `/me/profile` cards + elder. Gender FIELD_LOCKED. Contact hồ sơ ≠ `users.phone/email` |
| Bootstrap | `initialSetup.js`: audit `changedBy` sau khi có SYSTEM_ADMIN, không dùng UUID tenant |
| Media logo SYS | `runWithTenantContext` + tenant đích = `tenant_id` / `entity_id` khi TENANT |
| Addresses intl | Cột: `country_code`, `postal_code`, `admin_area`, `locality`, `sub_locality`, `line1`, `line2`, `full_address`. Đã DROP ward/district/province/country |
| Address search P1 | `GET /api/me/addresses?q=` + card địa chỉ chọn `address_id` |

## 2. Khóa không được phá (Q1)

- Shell: `TenantHeader`, `AppFooterNav`, `resolveFooterNav`, `resolveTenant`.  
- Footer: hub+list admin Home `/`; trang con `/admin`. `/me/profile` Home `/`, Back `/`.  
- Không reopen REGISTER / MEMBER_PROMOTE / OP approval SM.  
- Prisma: **không** inject `tenant_id` vào `update` / `findUnique` / `delete`. Inject `findMany` / `findFirst` / `updateMany` / `deleteMany`. STRICT thiếu ALS + không `allowUnscoped` → throw S0.1.  
- SYS JWT: `tenantId: null`, `allowUnscoped: true`. Cross-tenant qua `sysAccess` hoặc `runWithTenantContext({ tenantId đích, allowUnscoped })`.  
- A01 không ghi `users.phone/email`, `gender`, `is_alive`, `father_id`/`mother_id`, status/role.  
- Place vs usage: `addresses` = chỗ; quê/đang ở = FK member (không `address_type` trên place).  
- `social_configs` không chứa thủy tổ / gia quy / chữ lót.

## 3. File then chốt (cmcodes)

```
Backend/src/lib/prisma.js          S0 + runWithTenantContext PHẢI export
Backend/src/lib/sysAccess.js
Backend/src/lib/initialSetup.js
Backend/src/modules/profile/profile.service.js
Backend/src/modules/profile/profile.routes.js   GET/PATCH /profile, GET /addresses
Backend/src/app.js                              app.use('/api/me', profileRoutes)
Backend/src/modules/members/member.service.js   updateFullMember → updateMany
Backend/src/modules/interactions/media.service.js
Backend/src/modules/interactions/media.controller.js
Backend/prisma/schema.prisma                    SSOT schema
frontend/src/pages/MemberProfilePage.jsx
frontend/src/features/member/constants/memberProfileMessages.js
frontend/src/pages/AdminTenantDirectoryPage.jsx
frontend/src/pages/OpHubPage.jsx                import resolveFooterNav phải tách dòng
```

Schema SSOT: `Backend/prisma/schema.prisma`. Có bản root `Backend/schema.prisma` — dễ lệch; ưu tiên `prisma/`.

## 4. Hành vi A01 hiện tại

- Actor: user DA_DUYET + `member_id` + member CHINH_THUC + tenant HOAT_DONG.  
- PATCH tạo/cập nhật `biographies`, `member_privacy_rules`, social zalo/facebook/website.  
- Địa chỉ: `address_id` cùng tenant **hoặc** text → tìm theo `normalizeAddressKey` rồi create.  
- Search list `contains` trên full_address + các cột cấu trúc (chưa trgm query riêng).  
- Unique DB vẫn `(tenant_id, country_code, full_address)` **nguyên văn** — “Xã Kỳ Trinh…” vs “Kỳ Trinh, Kỳ Anh…” vẫn 2 hàng nếu user không chọn list.

## 5. Việc dở / nợ kỹ thuật

1. `normalized_key` trên `addresses` + unique theo khóa — chưa DDL.  
2. Form địa chỉ chuẩn (cascade tỉnh/xã) — chưa. Google Places — chưa, không P1.  
3. G01 `proposals` PROFILE_CORRECTION — bảng có, chưa API/UI. Gender chỉ khóa, chưa đề xuất.  
4. Card hôn nhân / cha mẹ trên profile — chưa (đúng phase: A02 / T02).  
5. `GET /api/tenants` directory đã SYS; getAll cũ baseController không dùng cho list.  
6. P0b suspend tenant — không làm; activate hẹp giữ.  
7. Achievements trên A01 — chưa.  
8. Prisma `update({where:{id}})` còn rải trong onboarding — đã bỏ inject trên `update`; nếu ai bật lại inject sẽ gãy OP submit.  
9. Dev từng wipe DB + migration address mark applied khi DDL rollback — đã chạy SQL tay. Môi trường khác phải kiểm cột `country_code` thật sự tồn tại.  
10. Trùng địa chỉ cũ trên tenant test — gộp tay hoặc sống chung đến khi có normalized_key.

## 6. Lát tiếp theo (thứ tự khuyến nghị)

1. **G01 tối thiểu:** member tạo `PROFILE_CORRECTION` (gender / field allow-list D-05); CLAN_ADMIN hàng đợi + atomic apply.  
2. **Address form cấu trúc** (country + admin/locality/sub + line1; `full_address` generate). Search giữ.  
3. **A02 hôn nhân cùng tenant** — không nhét vào PATCH profile.  
4. Schema P1b/P2 chỉ khi vào phase (marriage model, parent edge, family_clusters). Không rewrite DB toàn bộ lúc trống nữa.

Không làm “schema hết mọi BP” trong một PR.

## 7. Smoke tối thiểu khi sang thread

- Login SYS: `/admin` → Quản trị dòng họ → list/filter → Home `/`.  
- Login member CHINH_THUC: `/me/profile` load + lưu bio + F5 còn data.  
- `PATCH { gender: "NAM" }` → 400 FIELD_LOCKED.  
- `/me/profile` địa chỉ: gõ ≥2 ký tự ra list; chọn không sinh hàng mới.  
- SYS `/admin/tenant/settings?tenant_id=` upload logo không S0.1.  
- OP `/op` mở được (OpHubPage import hợp lệ); Base Profile lưu được (`updateMany`).  
- CLAN_SETUP / MEMBER_JOIN không regress approve.

## 8. Câu mở thread mới (copy)

```
Tiếp myClan.com.vn. SSOT: HandOver-Post-OP-A01-2026-08-28.
Repos QuangAGS/cmcodes + CM-Docs.
RP/OP CLOSED. Không mở lại SM.
Đã xong: S0 isolation, Hub v2 /admin/tenants, A01 /me/profile, addresses intl + GET /api/me/addresses.
Khóa: không inject tenant vào prisma update/findUnique; A01 không sửa users.phone hay gender; place ≠ usage.
Next đề xuất: G01 PROFILE_CORRECTION tối thiểu.
Đọc HandOver rồi đề xuất lát nhỏ, chưa sinh code lớn.
```

## 9. BFA / doctrine liên quan

- HandOver-Close-OP-MEMBER_PROMOTE-2026-08-26  
- HandOver-RP-process-kind-BPL-2026-08-16  
- HandOver-Close-C6-2026-08-15  
- FE-OP-MEMBER_PROMOTE-2026-08-16  
- BFA Post-OP v2.2.x (D-01…D-05, A-01…, proposals lifecycle)

Hết HandOver.
