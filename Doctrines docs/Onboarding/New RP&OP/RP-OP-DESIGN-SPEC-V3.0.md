# ĐẶC TẢ THIẾT KẾ CHÍNH THỨC: RP & OP

**Mã tài liệu:** RP-OP-DESIGN-SPEC-V3.0  
**Dự án:** myclan.com.vn  
**Phiên bản:** 3.0-OFFICIAL  
**Ngày:** 2026-11-06  
**Trạng thái:** Chính thức

---

## 0. Chuẩn hóa khái niệm

| Mã | Thuật ngữ | Định nghĩa |
|----|-----------|------------|
| T-01 | RP | Register Process |
| T-02 | OP | Onboarding Process |
| T-03 | MFO | Member Family Onboarding (5 đời) |
| T-04 | Claim | Liên kết tài khoản với member đã có |
| T-05 | Multi-Home | Một user nhiều dòng họ |
| T-06 | SSOT | Single Source of Truth |
| T-07 | ALS | AsyncLocalStorage |
| T-08 | BPL | Business Process Log |
| T-09 | CL | Communication Ledger |
| T-10 | G01 | Cổng duyệt Admin |
| T-11 | Sandbox | Quyền hạn hẹp khi link = DRAFT |
| T-12 | Dual-Write | Ghi đồng thời cột cũ và parentages |
| T-13 | FTDI | Family Tree Doctrine Implementation |
| T-14 | requester_user_id | Người nộp tờ trình |
| T-15 | actorId | Người thực hiện (thường là Admin) |

---

## 1. State Machines [SM]

### 1.1 users.status [SM-U]

```
CHO_DUYET ──(có link DA_DUYET)──► DA_DUYET
DA_DUYET ──(Admin khóa)──► BI_KHOA
DA_DUYET ──(Admin cấm)──► BI_CAM
BI_KHOA ──(mở khóa)──► DA_DUYET
```

| Mã | Hiện tại | Thiết kế | GAP | Đánh giá |
|----|----------|----------|-----|----------|
| SM-U-01 | Enum có đủ | Giữ nguyên | Không | **Sử dụng lại** |
| SM-U-02 | Nâng DA_DUYET theo RP cũ | Chỉ nâng khi có link DA_DUYET | Có | **Biến đổi** `auth.service.js` |

### 1.2 user_member_links.status [SM-L]

```
DRAFT ──(duyệt MFO)──► DA_DUYET
DRAFT ──(hủy)──► HUY_LIEN_KET
CHO_DUYET ──(duyệt Claim)──► DA_DUYET
CHO_DUYET ──(từ chối)──► TU_CHOI
DA_DUYET ──(hủy)──► HUY_LIEN_KET
```

| Mã | Hiện tại | Thiết kế | GAP | Đánh giá |
|----|----------|----------|-----|----------|
| SM-L-01 | Không có bảng | Tạo `user_member_links` | P0 | **Thêm vào** |
| SM-L-02 | Không có enum | Thêm enum | P0 | **Thêm vào** |
| SM-L-03 | Không có partial unique | Tạo index | P0 | **Thêm vào** |

### 1.3 proposals.status [SM-P]

```
PENDING ──► APPROVED / REJECTED / NEEDS_REVISION / DISPUTED
NEEDS_REVISION ──► PENDING
DISPUTED ──► APPROVED / REJECTED
```

| Mã | Hiện tại | Thiết kế | GAP | Đánh giá |
|----|----------|----------|-----|----------|
| SM-P-01 | Có NEEDS_REVISION | Giữ | Không | **Sử dụng lại** |
| SM-P-02 | Không có DISPUTED | Thêm | P1 | **Thêm vào** |
| SM-P-03 | Không có MEMBER_CLAIM | Thêm ticket_type | P1 | **Thêm vào** |

### 1.4 members.status [SM-M]

**Đánh giá:** **Sử dụng lại.** Enum đã có `DU_BI`, `CHINH_THUC`.

---

## 2. BPL & Audit [BPL]

| Mã | Sự kiện | Hiện tại | GAP | Đánh giá | Ghi chú |
|----|---------|----------|-----|----------|---------|
| BPL-01 | MEMBER_CLAIM_SUBMIT | Không có | P1 | **Thêm vào** | |
| BPL-02 | MEMBER_CLAIM_APPROVE | Không có | P1 | **Thêm vào** | Không ghi thêm LINK_ACTIVATED trong cùng TX. |
| BPL-03 | MEMBER_CLAIM_DISPUTE | Không có | P1 | **Thêm vào** | |
| BPL-04 | MEMBER_CLAIM_VOUCH_REQUEST | Không có | P1 | **Thêm vào** | |
| BPL-05 | MFO_PLAN_SUBMIT | Có | Không | **Sử dụng lại** | |
| BPL-06 | MFO_PLAN_APPROVE | Có | Không | **Sử dụng lại** | |
| BPL-07 | LINK_ACTIVATED | Không có | P1 | **Thêm vào** | Chỉ dùng khi kích hoạt độc lập. |

---

## 3. Communication Ledger [CL]

| Mã | Sự kiện | Chế độ | Hiện tại | Đánh giá |
|----|---------|--------|----------|----------|
| CL-01 | MEMBER_CLAIM_SUBMIT | SILENT | Không có | **Thêm vào** |
| CL-02 | MEMBER_CLAIM_VOUCH_REQUEST | DELIVER | Không có | **Thêm vào** |
| CL-03 | MEMBER_CLAIM_APPROVE | DELIVER | Không có | **Thêm vào** |
| CL-04 | MEMBER_CLAIM_DISPUTE | ADMIN_ALERT | Không có | **Thêm vào** |
| CL-05 | MFO_PLAN_SUBMIT | SILENT | Có một phần | **Biến đổi** |
| CL-06 | MFO_PLAN_APPROVE | DELIVER | Có một phần | **Biến đổi** |

---

## 4. Security [SEC]

### 4.1 Gates

| Mã | Gate | Thiết kế | Hiện tại | Đánh giá |
|----|------|----------|----------|----------|
| SEC-01 | SandboxGate (DRAFT) | Whitelist đầy đủ | Không có | **Thêm vào** `tenantGate` |
| SEC-02 | switch-context API | Có | Không có | **Thêm vào** |
| SEC-03 | ALS activeLinkStatus | Có | Chỉ tenantId | **Biến đổi** `prisma.js` |

**SEC-01 — Whitelist bắt buộc:**

| Route | Mục đích |
|-------|----------|
| `/api/mfo/*` | Wizard MFO 5L |
| `/api/me/profile` | Hồ sơ cá nhân |
| `/api/auth/me` | Đồng bộ phiên |
| `/api/tenants` | Danh mục dòng họ |
| `/api/auth/switch-context` | Chuyển đổi dòng họ |

### 4.2 ALS Context [SEC-ALS]

```typescript
interface TenantContext {
  userId: string;
  activeTenantId?: string;
  activeMemberId?: string;
  activeLinkStatus?: 'DRAFT' | 'CHO_DUYET' | 'DA_DUYET';
  allowUnscoped?: boolean;
}
```

---

## 5. Elder Support [ELD]

| Mã | Thành phần | Hiện tại | Đánh giá |
|----|------------|----------|----------|
| ELD-01 | Nút "Nghe hướng dẫn" | Có | **Sử dụng lại** |
| ELD-02 | Ngôn ngữ đơn giản | Có | **Sử dụng lại** |
| ELD-03 | Xác nhận trước khi nộp | Có một phần | **Biến đổi** cho Claim |

---

## 6. Optimization [OPT]

| Mã | Điểm | Thiết kế | Hiện tại | Đánh giá |
|----|------|----------|----------|----------|
| OPT-01 | lock_timeout | SET LOCAL 3s | Chưa có cho Claim | **Thêm vào** |
| OPT-02 | Index user_member_links | Có | Bảng chưa có | **Thêm vào** |
| OPT-03 | Dual-Write parentages | Có | Có một phần | **Biến đổi** `mfo.gate2.js` |
| OPT-04 | createMany evidence | Có | Chưa | **Thêm vào** |

---

## 7. Frontend [FE]

### 7.1 Màn hình & Luồng [FE-SCR]

| Mã | Màn hình | Hiện tại | Thiết kế | GAP | Đánh giá |
|----|----------|----------|----------|-----|----------|
| FE-SCR-01 | Đăng ký / OTP | Có (`AuthPage`) | Giữ | Không | **Sử dụng lại** |
| FE-SCR-02 | Chọn dòng họ | Có một phần | Multi-Home Selector | Có | **Biến đổi** |
| FE-SCR-03 | Claim — Tìm member | Không có | Tái sử dụng `MemberSearchSheet.jsx` | P0 | **Biến đổi** (kế thừa) |
| FE-SCR-04 | Claim — Xác thực 3 lớp | Không có | Form trắc nghiệm + bảo lãnh | P0 | **Thêm vào** |
| FE-SCR-05 | Claim — Theo dõi trạng thái | Không có | Trang chờ duyệt | P1 | **Thêm vào** |
| FE-SCR-06 | MFO Workbench | Có | Giữ | Không | **Sử dụng lại** |
| FE-SCR-07 | Clan Switcher | Không có | Dropdown trên Header | P0 | **Thêm vào** |
| FE-SCR-08 | Sandbox Banner | Không có | Banner "Đang khởi tạo" | P1 | **Thêm vào** |

### 7.2 Redirect & Navigation [FE-NAV]

| Mã | Logic | Hiện tại | Thiết kế | Đánh giá |
|----|-------|----------|----------|----------|
| FE-NAV-01 | Sau login, chưa có member | Vào `/op` | Vào `/op/base-profile` hoặc Claim | **Biến đổi** `AuthContext.jsx` |
| FE-NAV-02 | Sau login, có member | Vào `/op` | Vào `/op` hoặc `/tree` | **Sử dụng lại** |
| FE-NAV-03 | Sandbox (DRAFT) | Không có | Chặn điều hướng ngoài MFO/profile | **Thêm vào** route guard |
| FE-NAV-04 | Claim đang chờ | Không có | Chỉ cho xem trạng thái | **Thêm vào** |

### 7.3 Clan Switcher [FE-SW]

| Mã | Thành phần | Hiện tại | Thiết kế | Đánh giá | Ghi chú triển khai |
|----|------------|----------|----------|----------|-------------------|
| FE-SW-01 | Dropdown dòng họ | Không có | Header, gọi `switch-context` | **Thêm vào** | Cập nhật `localStorage` + state RAM (`activeTenantId`, `activeMemberId`, `activeLinkStatus`) để hydrate lại dữ liệu. |
| FE-SW-02 | Hiển thị link_type | Không có | Label: Họ nội / Họ ngoại / ... | **Thêm vào** | |
| FE-SW-03 | Dòng họ mặc định | Không có | Đánh dấu `is_default` | **Thêm vào** | |

### 7.4 Thông báo [FE-NOTI]

| Mã | Loại | Hiện tại | Thiết kế | Đánh giá |
|----|------|----------|----------|----------|
| FE-NOTI-01 | In-app notification | Có | Hiển thị theo CL | **Biến đổi** |
| FE-NOTI-02 | Banner Sandbox | Không có | "Bạn đang trong chế độ khởi tạo" | **Thêm vào** |
| FE-NOTI-03 | Thông báo Dispute | Không có | Cảnh báo trên chuông Admin | **Thêm vào** |

### 7.5 Elder Support FE [FE-ELD]

| Mã | Thành phần | Hiện tại | Thiết kế | Đánh giá |
|----|------------|----------|----------|----------|
| FE-ELD-01 | Nút "Nghe" trên Claim | Không có | Có trên mọi màn hình Claim | **Thêm vào** |
| FE-ELD-02 | Ngôn ngữ đơn giản | Có | Áp dụng cho Claim | **Biến đổi** |
| FE-ELD-03 | Xác nhận trước khi nộp | Có một phần | Áp dụng cho Claim | **Biến đổi** |

---

## 8. Deprecation Matrix [DEP]

| Mã | Thành phần | Hiện tại | Hành động | Lý do |
|----|------------|----------|-----------|-------|
| DEP-01 | `POST /api/onboarding/cases/:caseId/merge` | Có trong `onboarding.routes.js` | **Bãi bỏ** (410 GONE) | Nối cây chuyển sang MFO 5L + parentages Dual-Write |
| DEP-02 | Logic gắn chi tạm (`onboarding_case_id` trên branches) | Có | **Bãi bỏ** trong luồng Onboarding nhân sự | Không còn tạo chi tạm trong OP |

---

## 9. Tài liệu liên quan

| Tài liệu | Phiên bản |
|----------|-----------|
| BPMN RP & OP | 2.5.0-FROZEN |
| Implementation Plan | v1.3-READY |
| FTDI Spec | v1.0.4+ |

---

**Kết luận:** Bản 3.0 hợp nhất V2.1 và V2.2, bổ sung ghi chú triển khai cho FE-SW-01 (cập nhật token + state) và FE-SCR-03 (kế thừa `MemberSearchSheet.jsx`). Đây là tài liệu chính thức.
