# ĐẶC TẢ THIẾT KẾ CHI TIẾT: RP & OP v2.5.0

**Dự án:** myclan.com.vn  
**Phiên bản:** 1.2-DETAILED-GAPS  
**Ngày:** 2026-11-06  
**Phạm vi:** Register Process (RP) & Onboarding Process (OP)

---

## 0. Chuẩn hóa khái niệm, Acronym, Terms

| Thuật ngữ | Định nghĩa |
|-----------|------------|
| **RP** | Register Process — Quy trình đăng ký tài khoản |
| **OP** | Onboarding Process — Quy trình gắn user với member và hoàn thiện hồ sơ |
| **MFO** | Member Family Onboarding — Tờ trình dựng gia đình 5 đời |
| **Claim** | Yêu cầu liên kết tài khoản với member đã có trong sổ |
| **Multi-Home** | Một user liên kết với nhiều dòng họ |
| **SSOT** | Single Source of Truth — Nguồn sự thật duy nhất |
| **ALS** | AsyncLocalStorage — Cơ chế cô lập tenant context |
| **BPL** | Business Process Log — Sổ cái nghiệp vụ |
| **CL** | Communication Ledger — Sổ thông báo |
| **G01** | Cổng duyệt của Admin (Clan Council) |
| **Sandbox** | Chế độ quyền hạn hẹp khi link ở trạng thái DRAFT |
| **Dual-Write** | Ghi đồng thời vào cột cũ và bảng mới (parentages) |
| **FTDI** | Family Tree Doctrine Implementation |
| **link_type** | Loại quan hệ: PRIMARY_PATERNAL, MATERNAL, SPOUSE_FAMILY, ... |
| **requester_user_id** | Người nộp tờ trình (không phải Admin duyệt) |
| **actorId** | Người thực hiện hành động (thường là Admin) |

---

## 1. State Machines

### 1.1 users.status

**Thiết kế mới:**

```
CHO_DUYET ──(có link DA_DUYET)──► DA_DUYET
DA_DUYET ──(Admin khóa)──► BI_KHOA
DA_DUYET ──(Admin cấm)──► BI_CAM
BI_KHOA ──(mở khóa)──► DA_DUYET
```

**Gaps với hiện tại:**

| Điểm | Hiện tại (schema) | Thiết kế mới | GAP |
|------|-------------------|--------------|-----|
| Enum | `CHO_DUYET`, `DA_DUYET`, `BI_KHOA`, `BI_CAM`, `TAM_NGUNG`, `TU_CHOI` | Giữ nguyên | Không |
| Logic nâng `DA_DUYET` | Phụ thuộc luồng RP cũ | Chỉ nâng khi có link `DA_DUYET` | **Cần sửa auth.service** |

### 1.2 user_member_links.status

**Thiết kế mới:**

```
DRAFT ──(duyệt MFO)──► DA_DUYET
DRAFT ──(hủy nháp)──► HUY_LIEN_KET
CHO_DUYET ──(duyệt Claim)──► DA_DUYET
CHO_DUYET ──(từ chối)──► TU_CHOI
DA_DUYET ──(hủy)──► HUY_LIEN_KET
```

**Gaps với hiện tại:**

| Điểm | Hiện tại | Thiết kế mới | GAP |
|------|----------|--------------|-----|
| Bảng | **Không có** | `user_member_links` | **P0 — Cần tạo** |
| Enum | Không có | `DRAFT`, `CHO_DUYET`, `DA_DUYET`, `TU_CHOI`, `HUY_LIEN_KET` | **P0** |
| Partial unique | Không có | `unique_active_member_per_tenant` | **P0** |

### 1.3 proposals.status

**Thiết kế mới:**

```
PENDING ──(duyệt)──► APPROVED
PENDING ──(từ chối)──► REJECTED
PENDING ──(yêu cầu bổ sung)──► NEEDS_REVISION
NEEDS_REVISION ──(nộp lại)──► PENDING
PENDING ──(tranh chấp)──► DISPUTED
DISPUTED ──(phán quyết)──► APPROVED / REJECTED
```

**Gaps với hiện tại:**

| Điểm | Hiện tại (`proposal_status`) | Thiết kế mới | GAP |
|------|------------------------------|--------------|-----|
| Enum | `DRAFT`, `PENDING`, `UNDER_REVIEW`, `NEEDS_REVISION`, `REJECTED`, `APPROVED`, `APPLIED`, `WITHDRAWN`, `FAILED_TO_APPLY` | Thêm `DISPUTED` | **P1 — Cần ALTER TYPE** |
| ticket_type | Có `MFO_REVIEW`, `PROFILE_CORRECTION` | Thêm `MEMBER_CLAIM` | **P1** |

### 1.4 members.status

**Gaps:** Không có. Enum hiện tại đã có `DU_BI`, `CHINH_THUC`.

---

## 2. BPL & Audit

### 2.1 BPL Event Catalog

| Sự kiện thiết kế | Hiện tại (`business_process_type`) | GAP |
|------------------|-------------------------------------|-----|
| `MEMBER_CLAIM_SUBMIT` | Không có | **P1 — Cần thêm enum** |
| `MEMBER_CLAIM_APPROVE` | Không có | **P1** |
| `MEMBER_CLAIM_DISPUTE` | Không có | **P1** |
| `MEMBER_CLAIM_VOUCH_REQUEST` | Không có | **P1** |
| `MFO_PLAN_SUBMIT` | Có | Không |
| `MFO_PLAN_APPROVE` | Có | Không |
| `LINK_ACTIVATED` | Không có | **P1** |

### 2.2 Cấu trúc BPL

**Thiết kế:** Tách `context` và `payload`.

**Hiện tại:** `metadata` là JSON tự do.

**GAP:** Cần chuẩn hóa cấu trúc metadata khi ghi BPL mới.

---

## 3. Communication Ledger (CL)

| Sự kiện | Chế độ thiết kế | Hiện tại | GAP |
|---------|-----------------|----------|-----|
| `MEMBER_CLAIM_SUBMIT` | SILENT | Không có | **P1** |
| `MEMBER_CLAIM_VOUCH_REQUEST` | DELIVER | Không có | **P1** |
| `MEMBER_CLAIM_APPROVE` | DELIVER | Không có | **P1** |
| `MEMBER_CLAIM_DISPUTE` | ADMIN_ALERT | Không có | **P1** |
| `MFO_PLAN_SUBMIT` | SILENT | Có (một phần) | Thấp |
| `MFO_PLAN_APPROVE` | DELIVER | Có (một phần) | Thấp |

---

## 4. Security

### 4.1 Gates

| Gate | Thiết kế | Hiện tại | GAP |
|------|----------|----------|-----|
| SandboxGate (`DRAFT`) | Whitelist MFO + profile | **Không có** | **P0** |
| switch-context API | Có | **Không có** | **P0** |
| ALS với `activeLinkStatus` | Có | Chỉ có `tenantId` | **P1** |

### 4.2 ALS Context

**Thiết kế:**

```typescript
interface TenantContext {
  userId: string;
  activeTenantId?: string;
  activeMemberId?: string;
  activeLinkStatus?: 'DRAFT' | 'CHO_DUYET' | 'DA_DUYET';
  allowUnscoped?: boolean;
}
```

**Hiện tại:** Chỉ inject `tenantId` từ token.

**GAP:** Cần mở rộng ALS và thêm API `switch-context`.

---

## 5. Elder Support

**Gaps:** Thấp. Các thành phần giọng nói đã có trong codebase. Cần đảm bảo các màn hình Claim mới cũng có nút "Nghe".

---

## 6. Optimization

| Điểm | Thiết kế | Hiện tại | GAP |
|------|----------|----------|-----|
| `lock_timeout` | `SET LOCAL lock_timeout = '3s'` | Chưa áp dụng cho Claim | **P1** |
| Index `user_member_links` | Có | Bảng chưa tồn tại | **P0** |
| Dual-Write parentages | Có trong mfo.gate2 | Đã có (một phần) | Thấp |

---

## 7. Tài liệu liên quan

| Tài liệu | Phiên bản |
|----------|-----------|
| BPMN RP & OP | 2.5.0-FROZEN |
| Implementation Plan | v1.3-READY |
| FTDI Spec | v1.0.4+ |

---

**Kết luận:** Bản 1.2 bổ sung Gaps với codebase hiện tại và mục chuẩn hóa thuật ngữ. Các GAP P0 cần được giải quyết trước khi triển khai.
