# KẾ HOẠCH TRIỂN KHAI CHI TIẾT: RP & OP

**Mã tài liệu:** RP-OP-DETAILED-IMPLEMENTATION-V1.0  
**Dự án:** myclan.com.vn  
**Phiên bản:** 1.0  
**Ngày:** 2026-11-06  
**Tham chiếu:** RP-OP-DESIGN-SPEC-V3.0

---

## Tổng quan

| Phase | Nội dung | Rủi ro | Checkpoint |
|-------|----------|--------|------------|
| **Phase 1** | DDL & Migration | Thấp | CP-1 |
| **Phase 2** | Auth Context & Sandbox | Trung bình | CP-2 |
| **Phase 3** | Claim APIs & MFO Alignment | Cao | CP-3 |
| **Phase 4** | Frontend | Trung bình | CP-4 |
| **Phase 5** | Deprecation & Cleanup | Thấp | CP-5 |

---

## Phase 1: DDL & Migration

### Bước 1.1: Kiểm tra kiểu ID [SM-L-01]

| Việc | File | Hành động |
|------|------|-----------|
| Xác định kiểu `users.id`, `tenants.id`, `members.id` | `schema.prisma` | Đọc |

**Checkpoint CP-1.1:** Xác nhận dùng `UUID` hay `VARCHAR(36)`.

### Bước 1.2: Tạo migration [SM-L-01, SM-L-02, SM-L-03]

| Việc | File | Hành động |
|------|------|-----------|
| Tạo enum `user_member_link_status` | Migration SQL | **Thêm vào** |
| Tạo enum `member_link_type` | Migration SQL | **Thêm vào** |
| Tạo bảng `user_member_links` | Migration SQL | **Thêm vào** |
| Tạo partial unique index | Migration SQL | **Thêm vào** |
| Thêm `DISPUTED` vào `proposal_status` | Migration SQL | **Thêm vào** |

**Checkpoint CP-1.2:** `npx prisma migrate deploy` thành công.

### Bước 1.3: Cập nhật schema.prisma [SM-L-01]

| Việc | File | Hành động |
|------|------|-----------|
| Thêm model `user_member_links` | `schema.prisma` | **Thêm vào** |
| Thêm enum | `schema.prisma` | **Thêm vào** |

**Checkpoint CP-1.3:** `npx prisma generate` thành công.

### Bước 1.4: Backfill (tùy chọn)

| Việc | Hành động |
|------|-----------|
| Backfill từ `users.member_id` | Chạy SQL |

**Smoke S-1:**

```sql
SELECT COUNT(*) FROM user_member_links;
-- Kỳ vọng: số lượng bằng số users có member_id
```

---

## Phase 2: Auth Context & Sandbox

### Bước 2.1: Điều chỉnh users.status [SM-U-02]

| Việc | File | Hành động |
|------|------|-----------|
| Sau OTP: giữ `CHO_DUYET` | `auth.service.js` | **Biến đổi** |
| Chỉ nâng `DA_DUYET` khi có link `DA_DUYET` | `auth.service.js` | **Biến đổi** |

### Bước 2.2: API switch-context [SEC-02]

| Việc | File | Hành động |
|------|------|-----------|
| Thêm `POST /api/auth/switch-context` | `auth.controller.js` | **Thêm vào** |
| Trả Context Token với `activeTenantId`, `activeMemberId`, `activeLinkStatus` | `auth.service.js` | **Thêm vào** |

### Bước 2.3: SandboxGate [SEC-01]

| Việc | File | Hành động |
|------|------|-----------|
| Nhận diện `DRAFT` | `tenantGate.middleware.js` | **Thêm vào** |
| Whitelist 5 routes | `tenantGate.middleware.js` | **Thêm vào** |

**Whitelist:**

- `/api/mfo/*`
- `/api/me/profile`
- `/api/auth/me`
- `/api/tenants`
- `/api/auth/switch-context`

### Bước 2.4: Mở rộng ALS [SEC-03]

| Việc | File | Hành động |
|------|------|-----------|
| Thêm `activeLinkStatus` vào context | `prisma.js` | **Biến đổi** |

**Checkpoint CP-2:** 

**Smoke S-2:**

1. Đăng ký user mới → `users.status = CHO_DUYET`.
2. Gọi API ngoài whitelist với `DRAFT` → 403 `SANDBOX_RESTRICTED`.
3. Gọi `/api/mfo/*` với `DRAFT` → 200.

---

## Phase 3: Claim APIs & MFO Alignment

### Bước 3.1: submitClaim [BPL-01, OPT-01]

| Việc | File | Hành động |
|------|------|-----------|
| Tạo `membership.service.js` | Mới | **Thêm vào** |
| Row-level lock `SELECT ... FOR UPDATE` | `membership.service.js` | **Thêm vào** |
| `SET LOCAL lock_timeout = '3s'` | `membership.service.js` | **Thêm vào** |
| Kiểm tra tranh chấp | `membership.service.js` | **Thêm vào** |
| Tạo `proposals (MEMBER_CLAIM)` | `membership.service.js` | **Thêm vào** |
| Tạo `user_member_links (CHO_DUYET)` | `membership.service.js` | **Thêm vào** |
| Ghi BPL `MEMBER_CLAIM_SUBMIT` | `membership.service.js` | **Thêm vào** |

### Bước 3.2: approveClaim [BPL-02, OPT-04]

| Việc | File | Hành động |
|------|------|-----------|
| Row-level lock | `membership.service.js` | **Thêm vào** |
| Nâng link của `requester_user_id` | `membership.service.js` | **Thêm vào** |
| Nâng `users.status` | `membership.service.js` | **Thêm vào** |
| Nhân bản `evidence_links` (destructure) | `membership.service.js` | **Thêm vào** |
| Tạo `PROFILE_CORRECTION` nếu có diffs | `membership.service.js` | **Thêm vào** |
| Ghi BPL `MEMBER_CLAIM_APPROVE` (không ghi LINK_ACTIVATED) | `membership.service.js` | **Thêm vào** |

### Bước 3.3: Dual-Write trong mfo.gate2.js [OPT-03]

| Việc | File | Hành động |
|------|------|-----------|
| Upsert `parentages` với composite key | `mfo.gate2.js` | **Biến đổi** |
| Nâng link của `requester_user_id` (không phải actorId) | `mfo.gate2.js` | **Biến đổi** |
| Nâng `users.status` của requester | `mfo.gate2.js` | **Biến đổi** |

**Checkpoint CP-3:**

**Smoke S-3:**

1. Submit Claim → `proposals.status = PENDING`, `user_member_links.status = CHO_DUYET`.
2. Approve Claim → `user_member_links.status = DA_DUYET`, `users.status = DA_DUYET`.
3. Duyệt MFO → `parentages` có bản ghi `BIOLOGICAL` + `ACCEPTED`.

---

## Phase 4: Frontend

### Bước 4.1: Redirect sau login [FE-NAV-01]

| Việc | File | Hành động |
|------|------|-----------|
| User chưa có member → `/op/base-profile` | `AuthContext.jsx` | **Biến đổi** |

### Bước 4.2: Clan Switcher [FE-SW-01]

| Việc | File | Hành động |
|------|------|-----------|
| Dropdown trên Header | Component mới | **Thêm vào** |
| Gọi `switch-context` | `AuthContext.jsx` | **Thêm vào** |
| Cập nhật `localStorage` + state RAM | `AuthContext.jsx` | **Thêm vào** |

### Bước 4.3: Màn hình Claim [FE-SCR-03, FE-SCR-04]

| Việc | File | Hành động |
|------|------|-----------|
| Tái sử dụng `MemberSearchSheet.jsx` | `features/member/components/` | **Biến đổi** (kế thừa) |
| Form xác thực 3 lớp | Component mới | **Thêm vào** |
| Trang theo dõi trạng thái | Component mới | **Thêm vào** |

### Bước 4.4: Sandbox Banner [FE-SCR-08]

| Việc | File | Hành động |
|------|------|-----------|
| Banner "Đang khởi tạo" | Component mới | **Thêm vào** |

**Checkpoint CP-4:**

**Smoke S-4:**

1. Login user chưa có member → vào `/op/base-profile`.
2. Switch clan → dữ liệu hydrate lại.
3. Màn hình Claim tìm được member.

---

## Phase 5: Deprecation & Cleanup

### Bước 5.1: Bãi bỏ mergeBranch [DEP-01]

| Việc | File | Hành động |
|------|------|-----------|
| Trả 410 GONE | `onboarding.routes.js` | **Bãi bỏ** |

### Bước 5.2: Bãi bỏ logic chi tạm [DEP-02]

| Việc | File | Hành động |
|------|------|-----------|
| Không tạo chi tạm trong OP | `onboarding.service.js` | **Bãi bỏ** |

**Checkpoint CP-5:**

**Smoke S-5:**

1. Gọi `/api/onboarding/cases/:id/merge` → 410.

---

## Thứ tự thực thi

```
Phase 1 → CP-1 → Smoke S-1
Phase 2 → CP-2 → Smoke S-2
Phase 3 → CP-3 → Smoke S-3
Phase 4 → CP-4 → Smoke S-4
Phase 5 → CP-5 → Smoke S-5
```

---

**Kết luận:** Tài liệu này là kế hoạch triển khai chi tiết. Mỗi bước có mã quy chiếu từ Design Spec V3.0.
