# ĐẶC TẢ THIẾT KẾ CHI TIẾT: RP & OP v2.5.0

**Dự án:** myclan.com.vn  
**Phiên bản:** 1.1-DETAILED  
**Ngày:** 2026-11-06  
**Phạm vi:** Register Process (RP) & Onboarding Process (OP)

---

## 1. State Machines

### 1.1 users.status

```
CHO_DUYET ──(có link DA_DUYET)──► DA_DUYET
DA_DUYET ──(Admin khóa)──► BI_KHOA
DA_DUYET ──(Admin cấm)──► BI_CAM
BI_KHOA ──(mở khóa)──► DA_DUYET
```

### 1.2 user_member_links.status

```
DRAFT ──(duyệt MFO)──► DA_DUYET
DRAFT ──(hủy nháp)──► HUY_LIEN_KET
CHO_DUYET ──(duyệt Claim)──► DA_DUYET
CHO_DUYET ──(từ chối)──► TU_CHOI
DA_DUYET ──(hủy)──► HUY_LIEN_KET
```

**Quy tắc:** Link `TU_CHOI` giữ nguyên để lưu vết. Claim mới tạo bản ghi link mới.

### 1.3 proposals.status

```
PENDING ──(duyệt)──► APPROVED
PENDING ──(từ chối)──► REJECTED
PENDING ──(yêu cầu bổ sung)──► NEEDS_REVISION
NEEDS_REVISION ──(nộp lại)──► PENDING
PENDING ──(tranh chấp)──► DISPUTED
DISPUTED ──(phán quyết)──► APPROVED / REJECTED
```

### 1.4 members.status

```
DU_BI ──(duyệt MFO)──► CHINH_THUC
```

---

## 2. BPL & Audit

### 2.1 BPL Event Catalog (khớp enum hiện có)

| Sự kiện | Thời điểm | Chế độ CL |
|---------|-----------|-----------|
| `MEMBER_CLAIM_SUBMIT` | Sau khi tạo proposal | SILENT |
| `MEMBER_CLAIM_APPROVE` | Sau TX_COMMIT_CLAIM | DELIVER |
| `MEMBER_CLAIM_DISPUTE` | Khi phát hiện trùng | ADMIN_ALERT |
| `MEMBER_CLAIM_VOUCH_REQUEST` | Yêu cầu bảo lãnh | DELIVER |
| `MFO_PLAN_SUBMIT` | Nộp tờ trình 5L | SILENT |
| `MFO_PLAN_APPROVE` | Sau duyệt G01 | DELIVER |
| `LINK_ACTIVATED` | Khi link → DA_DUYET | SILENT |

### 2.2 Cấu trúc BPL

```typescript
interface BPLEntry {
  context: {
    actor_id: string;
    actor_type: 'USER' | 'ADMIN' | 'SYSTEM';
    correlation_id: string;
    tenant_id: string;
  };
  payload: {
    event: string;
    proposal_id?: string;
    member_id?: string;
    user_id?: string;
    // whitelist fields only
  };
}
```

### 2.3 Audit Rules

| Đối tượng | Ghi khi | Lưu trữ |
|-----------|---------|---------|
| `user_member_links` | Mọi thay đổi status | `audit_logs` |
| `proposals` | Mọi chuyển trạng thái | `audit_logs` + BPL |
| `members` | Tạo / nâng status | `audit_logs` |

**Correlation:** Mọi bản ghi trong cùng transaction dùng chung `correlation_id`.

---

## 3. Communication Ledger (CL)

| Sự kiện | Chế độ | Hành động |
|---------|--------|-----------|
| `MEMBER_CLAIM_SUBMIT` | SILENT | Ghi `notifications` nội bộ cho Admin |
| `MEMBER_CLAIM_VOUCH_REQUEST` | DELIVER | In-app + Zalo ZNS / SMS tới người thân |
| `MEMBER_CLAIM_APPROVE` | DELIVER | In-app + Zalo/Email chúc mừng |
| `MEMBER_CLAIM_DISPUTE` | ADMIN_ALERT | Cờ cảnh báo trên chuông Admin |
| `MFO_PLAN_SUBMIT` | SILENT | Ghi nội bộ |
| `MFO_PLAN_APPROVE` | DELIVER | In-app + Zalo/Email |

---

## 4. Security

### 4.1 Gates

| Gate | Điều kiện | Hành động |
|------|-----------|-----------|
| AccountGate | `users.status = CHO_DUYET` | Chặn API ngoài whitelist |
| TenantGate | Không có link hợp lệ | 403 |
| SandboxGate | `link.status = DRAFT` | Chỉ cho `/api/mfo/*`, `/api/me/profile`, `/api/auth/me`, `/api/tenants` |

### 4.2 ALS Context

```typescript
interface TenantContext {
  userId: string;
  activeTenantId?: string;
  activeMemberId?: string;
  activeLinkStatus?: 'DRAFT' | 'CHO_DUYET' | 'DA_DUYET';
  allowUnscoped?: boolean;
}
```

**Khi `activeLinkStatus === 'DRAFT'`:** Prisma middleware chỉ cho phép:
- Insert `members` với `status = 'DU_BI'`.
- Đọc các nút public để chọn Origin trên cây MFO.

### 4.3 Invariants

| Invariant | Thực thi |
|-----------|----------|
| 1-1 Active | Partial unique index |
| Claim độc lập | Không tự động có quyền ở họ khác |
| Không tạo member khi Claim | Kiểm tra trong service |

---

## 5. Elder Support

| Thành phần | Yêu cầu |
|------------|---------|
| Giọng nói | Mọi màn hình chính có nút "Nghe hướng dẫn" |
| Ngôn ngữ | Đơn giản, tránh thuật ngữ kỹ thuật |
| Điều hướng | Tối đa 2 bước để hoàn thành một hành động |
| Xác nhận | Hộp thoại xác nhận trước khi nộp Claim / MFO |

---

## 6. Optimization

### 6.1 Lock Timeout

```javascript
await tx.$executeRawUnsafe(`SET LOCAL lock_timeout = '3s'`);
```

### 6.2 Index bổ sung

```prisma
@@index([user_id, is_default, deleted_at])
@@index([tenant_id, member_id, status])
```

### 6.3 Cache

- `hubFlight` 8s cho bundle hồ sơ.
- Không cache dữ liệu Claim đang chờ.

### 6.4 Batch

- `createMany` cho `evidence_links` và `parentages`.
- Tránh N+1 bằng `include` hoặc `Promise.all`.

---

## 7. Tài liệu liên quan

| Tài liệu | Phiên bản |
|----------|-----------|
| BPMN RP & OP | 2.5.0-FROZEN |
| Implementation Plan | v1.3-READY |
| FTDI Spec | v1.0.4+ |

---

**Kết luận:** Bản 1.1 đã bổ sung các nhánh trạng thái, chuẩn hóa BPL, map CL, định nghĩa ALS, và cú pháp optimization. Có thể dùng làm đặc tả thiết kế chi tiết.
