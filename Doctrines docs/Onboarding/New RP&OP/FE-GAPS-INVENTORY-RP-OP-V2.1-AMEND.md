# DANH MỤC FE FILES – NEW RP & OP (V2.1 + AMEND-RP-OP-2026-01-V1.1)

**Dự án:** myclan.com.vn / Gia Phả Số 2026  
**Ngày cập nhật:** 10/11/2026  
**Hướng tổ chức:** Tạo thư mục `features/membership/` (bounded context mới cho multi-link, Claim, Status, Switcher)  
**Căn cứ:**  
- RP-OP-DETAILED-IMPLEMENTATION-V2.1 (Phase 4)  
- AMEND-RP-OP-2026-01-V1.1 (Cyclic State Machine, Schema JSON sát members, tách MFO)  
- Đối soát thực tế repo `QuangAGS/cmcodes` (frontend/src)

**Mục tiêu:** Liệt kê đầy đủ file FE đang có (cần sửa) và file cần tạo mới trong `features/membership/`, kèm hướng xử lý cụ thể.

---

## 0. TÓM TẮT NHANH

| Loại | Số lượng ước tính | Ưu tiên |
|------|-------------------|---------|
| File đang có – cần sửa | 6–8 | P0–P1 |
| File cần tạo mới trong `features/membership/` | 6–7 | P0 |
| Nền tảng sẵn có (Elder, MemberSearch, register-wizard, onboarding) | Tái sử dụng | — |

**Thứ tự đề xuất:**  
1. AuthContext + routing + switch-context  
2. HeaderClanSwitcher (trong membership)  
3. ClaimMemberPage + RegistrationProfileForm (schema AMEND)  
4. MembershipStatusPage + SandboxBanner + Revision UI  
5. Smoke FE

---

## 1. CẤU TRÚC THƯ MỤC MỚI (KHUYẾN NGHỊ)

```
frontend/src/features/membership/
├── api/
│   └── membershipApi.js
├── components/
│   ├── HeaderClanSwitcher.jsx
│   ├── RegistrationProfileForm.jsx
│   └── SandboxModeBanner.jsx
├── constants/
│   └── membershipLabels.js
└── pages/
    ├── ClaimMemberPage.jsx
    └── MembershipStatusPage.jsx
```

- Pages có thể import trực tiếp từ `features/membership/pages/…` trong `App.jsx`, hoặc re-export ở `pages/` nếu muốn giữ style cũ.
- Shell (TenantHeader) và AuthContext sửa tại chỗ, gọi sang membership components/API.

---

## 2. FILE ĐANG CÓ – CẦN SỬA

### 2.1 `frontend/src/context/AuthContext.jsx`
- **Hiện trạng:** Redirect đơn giản theo `member_id`. Không lưu `activeTenantId`, `activeMemberId`, `activeLinkStatus`, `roleInTenant`. Không gọi `switch-context`.
- **Cần sửa:**
  - Lưu full active context từ `/auth/me` hoặc response switch-context.
  - Thêm hàm `switchContext(targetTenantId)` (gọi qua `membershipApi`).
  - Cập nhật `resolvePostLoginRedirect`:
    - Không có activeMemberId → `/membership/claim` hoặc `/op/base-profile`
    - `activeLinkStatus === 'CHO_DUYET'` → `/membership/status`
    - `DRAFT` → hạn chế cây chính
  - Expose `activeContext` cho toàn app.
- **Mức độ:** P0

### 2.2 `frontend/src/App.jsx`
- **Hiện trạng:** Routes OP/MFO đầy đủ. ProtectedRoute dựa trên `user.status`. Không có `/membership/*`.
- **Cần sửa:**
  - Thêm routes:
    - `/membership/claim` → `ClaimMemberPage`
    - `/membership/status` → `MembershipStatusPage`
  - Cập nhật `ProtectedRoute` / `OpProtectedRoute` kiểm tra `activeLinkStatus` (chặn `/tree` khi DRAFT hoặc CHO_DUYET).
  - Mount `SandboxModeBanner` ở layout chính khi cần.
- **Mức độ:** P0

### 2.3 `frontend/src/components/shell/TenantHeader.jsx`
- **Hiện trạng:** Chỉ hiển thị logo + tên 1 tenant.
- **Cần sửa:**
  - Tích hợp `HeaderClanSwitcher` từ `features/membership/components/`.
  - Giữ fallback nếu chưa có multi-link.
- **Mức độ:** P0

### 2.4 `frontend/src/components/routes/OpProtectedRoute.jsx`
- **Cần sửa:** Thêm check `activeLinkStatus` (DRAFT chỉ cho phép một số path: `/op/mfo`, `/op/base-profile`, `/membership/*`).
- **Mức độ:** P1

### 2.5 `frontend/src/features/onboarding/components/BaseProfileForm.jsx` (tuỳ chọn)
- **Hiện trạng:** Schema hẹp.
- **Cần sửa / hoặc thay thế:**  
  Ưu tiên dùng `RegistrationProfileForm.jsx` mới trong membership. Có thể giữ BaseProfileForm cho luồng OP cũ hoặc dần migrate.
- **Mức độ:** P2

### 2.6 Các file hỗ trợ (sửa nhẹ)
- `frontend/src/lib/resolveFooterNav.js` – thêm nav item Membership / Status.
- `frontend/src/features/onboarding/constants/opMessages.js` – có thể bổ sung, hoặc chuyển sang `membershipLabels.js`.

---

## 3. FILE CẦN TẠO MỚI (trong `features/membership/`)

### 3.1 `frontend/src/features/membership/components/HeaderClanSwitcher.jsx`
- **Mục đích:** Dropdown multi-clan (FE-SW-01 → 03).
- **Nội dung chính:**
  - Gọi API lấy `user_member_links` (qua `membershipApi`).
  - Hiển thị tên tenant + tag (`PRIMARY_PATERNAL` → “Họ nội”, `MATERNAL` → “Họ ngoại”, `SPOUSE_FAMILY` → “Nhà dâu/rể”…).
  - Sao cho `is_default = true`.
  - On select → `POST /api/auth/switch-context` → cập nhật token + AuthContext + re-fetch.
- **Elder:** Có thể thêm TTS khi đổi dòng họ.
- **Ưu tiên:** P0

### 3.2 `frontend/src/features/membership/pages/ClaimMemberPage.jsx`
- **Mục đích:** Wizard Claim (FE-SCR-03 → 05 + Elder).
- **Cấu trúc 3 bước:**
  1. **Chọn Member:** Tái sử dụng `MemberSearchSheet.jsx` (đã có debounce + TTS).
  2. **Xác thực 3 lớp:**
     - Lớp 1: Câu hỏi gia mật.
     - Lớp 2: Xác thực số điện thoại.
     - Lớp 3: Chọn người bảo lãnh (vouching).
  3. **Xác nhận:** Modal tóm tắt chữ lớn, nút ≥48px, TTS.
- **Form:** Dùng `RegistrationProfileForm` (schema AMEND đầy đủ).
- **API:** Gọi submitClaim / submit registration.
- **Ưu tiên:** P0

### 3.3 `frontend/src/features/membership/pages/MembershipStatusPage.jsx`
- **Mục đích:** Màn theo dõi tiến độ duyệt (khi `activeLinkStatus === 'CHO_DUYET'`).
- **Nội dung:**
  - Hiển thị trạng thái case (SUBMITTED, UNDER_REVIEW, NEEDS_REVISION, REJECTED…).
  - Nếu NEEDS_REVISION → nút “Sửa hồ sơ” → chuyển về form revision.
  - Nếu soft-reject → thông báo + khả năng reopen.
  - Nếu hard-lock → thông báo vĩnh viễn.
- **Ưu tiên:** P0–P1

### 3.4 `frontend/src/features/membership/components/SandboxModeBanner.jsx`
- **Mục đích:** Banner vàng khi `activeLinkStatus === 'DRAFT'`.
- **Text mẫu:** “Bạn đang trong chế độ khởi tạo gia phả 5 đời. Hoàn tất nộp hồ sơ để mở đầy đủ tính năng dòng họ.”
- **Mount:** Layout chính (App hoặc shell).
- **Ưu tiên:** P1

### 3.5 `frontend/src/features/membership/components/RegistrationProfileForm.jsx`
- **Mục đích:** Form dùng chung cho Claim / Create / Revision, khớp đúng `REGISTRATION_SCHEMA` của AMEND.
- **Tính năng:**  
  Zod client-side gần với validator BE, Elder wrappers (FormErrorSpeaker, ZoneVoiceButton, AttentionZone), hỗ trợ `claimed_member_id`, proof_documents, social_profiles, parents names…
- **Ưu tiên:** P0–P1

### 3.6 `frontend/src/features/membership/api/membershipApi.js`
- **Mục đích:** Tập trung các call:
  - `switchContext`
  - `getMyLinks`
  - `submitClaim` / `submitRegistration`
  - `submitRevision`
  - `getMembershipStatus`
- **Ưu tiên:** P1

### 3.7 `frontend/src/features/membership/constants/membershipLabels.js`
- Tag link_type, status labels, messages Elder, text banner…
- **Ưu tiên:** P2

---

## 4. NỀN TẢNG SẴN CÓ – TÁI SỬ DỤNG (không di chuyển)

| File / Thư mục | Tình trạng | Cách dùng |
|----------------|------------|-----------|
| `features/member/components/MemberSearchSheet.jsx` | Có TTS + search | Bước 1 của ClaimMemberPage |
| `features/elder-doctrine/**` | Đầy đủ TTS, Zone, FormErrorSpeaker, Guided… | Bắt buộc dùng trong Claim, Status, RegistrationProfileForm |
| `features/register-wizard/components/JoinClanForm.jsx` | Có | Đối chiếu Clan-joint |
| `features/register-wizard/components/CreateClanForm.jsx` | Có | Đối chiếu Clan-setup |
| `features/onboarding/**` | Có | Giữ cho luồng OP cũ; dần migrate nếu cần |

---

## 5. BẢNG TỔNG HỢP HÀNH ĐỘNG

| File | Hành động | Vị trí | Ưu tiên | Ghi chú |
|------|-----------|--------|---------|---------|
| AuthContext.jsx | Sửa | `context/` | P0 | Thêm activeContext + switchContext |
| App.jsx | Sửa | `src/` | P0 | Thêm routes membership + guard |
| TenantHeader.jsx | Sửa | `components/shell/` | P0 | Gắn HeaderClanSwitcher |
| OpProtectedRoute.jsx | Sửa | `components/routes/` | P1 | Check activeLinkStatus |
| HeaderClanSwitcher.jsx | **Tạo mới** | `features/membership/components/` | P0 | Multi-clan + switch-context |
| ClaimMemberPage.jsx | **Tạo mới** | `features/membership/pages/` | P0 | Wizard 3 bước + Elder |
| MembershipStatusPage.jsx | **Tạo mới** | `features/membership/pages/` | P0 | Theo dõi duyệt + revision |
| RegistrationProfileForm.jsx | **Tạo mới** | `features/membership/components/` | P0 | Schema AMEND đầy đủ |
| SandboxModeBanner.jsx | **Tạo mới** | `features/membership/components/` | P1 | Banner DRAFT |
| membershipApi.js | **Tạo mới** | `features/membership/api/` | P1 | Tập trung API |
| membershipLabels.js | **Tạo mới** | `features/membership/constants/` | P2 | Labels + messages |
| BaseProfileForm.jsx | Sửa nhẹ / giữ | `features/onboarding/` | P2 | Có thể dần thay bằng form mới |

---

## 6. GHI CHÚ TRIỂN KHAI

- Giữ nguyên Elder Doctrine và MemberSearchSheet – tái sử dụng tối đa.
- Schema form phải sát `REGISTRATION_SCHEMA` trong AMEND (validator BE đã có v1.2.0).
- Mọi màn hình mới phải có TTS + nút lớn (≥48px) + error speaker.
- Sau khi làm xong P0: chạy Smoke S-4 (login chưa member → đúng màn; switch clan; DRAFT bị chặn; TTS).
- `features/membership/` là bounded context mới, tách biệt với onboarding/MFO theo tinh thần AMEND.

---

**Kết luận:** Tạo `features/membership/` để gom nhóm các thành phần New RP&OP (multi-link, Claim, Status, Switcher, Banner). Sửa tối thiểu các file shell/context/routing hiện có. Nền tảng Elder + MemberSearch tái sử dụng nguyên vẹn.

---

*Tài liệu cập nhật theo hướng tạo `features/membership/`.*  
*QX rules được tuân thủ nghiêm ngặt.*
