# ĐẶC TẢ THIẾT KẾ: RP & OP v2.5.0

**Dự án:** myclan.com.vn  
**Phiên bản:** 1.0-DESIGN-FRAMEWORK  
**Ngày:** 2026-11-06  
**Phạm vi:** Register Process (RP) & Onboarding Process (OP) — Multi-Home + Claim

---

## 1. State Machines

### 1.1 users.status

```
CHO_DUYET ──(có link DA_DUYET)──► DA_DUYET
```

### 1.2 user_member_links.status

```
DRAFT ──(duyệt MFO)──► DA_DUYET
CHO_DUYET ──(duyệt Claim)──► DA_DUYET
CHO_DUYET ──(từ chối)──► TU_CHOI
DA_DUYET ──(hủy)──► HUY_LIEN_KET
```

### 1.3 proposals.status

```
PENDING ──(duyệt)──► APPROVED
PENDING ──(từ chối)──► REJECTED
PENDING ──(tranh chấp)──► DISPUTED
DISPUTED ──(phán quyết)──► APPROVED / REJECTED
```

### 1.4 members.status

```
DU_BI ──(duyệt MFO)──► CHINH_THUC
```

---

## 2. BPL & Audit

### 2.1 BPL Event Catalog

| Sự kiện | Thời điểm | Payload tối thiểu |
|---------|-----------|-------------------|
| `CLAIM_SUBMITTED` | Sau khi tạo proposal | `proposal_id`, `target_member_id`, `user_id` |
| `CLAIM_APPROVED` | Sau TX_COMMIT_CLAIM | `proposal_id`, `actor_id`, `member_id` |
| `CLAIM_DISPUTED` | Khi phát hiện trùng | `proposal_ids[]`, `member_id` |
| `MFO_SUBMITTED` | Nộp tờ trình 5L | `proposal_id`, `user_id` |
| `MFO_APPROVED` | Sau duyệt G01 | `proposal_id`, `actor_id`, `member_ids[]` |
| `LINK_ACTIVATED` | Khi link → DA_DUYET | `user_id`, `member_id`, `tenant_id` |

### 2.2 Audit Rules

| Đối tượng | Ghi khi | Lưu trữ |
|-----------|---------|---------|
| `user_member_links` | Mọi thay đổi status | `audit_logs` |
| `proposals` | Mọi chuyển trạng thái | `audit_logs` + BPL |
| `members` | Tạo / nâng status | `audit_logs` |

**Correlation:** Mọi bản ghi BPL và audit phải có `correlation_id` chung trong một transaction.

---

## 3. Communication Ledger (CL)

### 3.1 Các kênh

| Kênh | Mục đích | Thời điểm |
|------|----------|-----------|
| In-app notification | Thông báo trạng thái Claim / MFO | Ngay sau sự kiện |
| Bảo lãnh (Vouching) | Yêu cầu người thân xác nhận | Khi Claim ở lớp 3 |
| Admin alert | Tranh chấp | Khi DISPUTED |

### 3.2 Payload thông báo

```json
{
  "type": "CLAIM_STATUS",
  "proposal_id": "...",
  "status": "PENDING | APPROVED | DISPUTED",
  "message": "..."
}
```

---

## 4. Security

### 4.1 Gates

| Gate | Điều kiện | Hành động |
|------|-----------|-----------|
| AccountGate | `users.status = CHO_DUYET` | Chặn API ngoài whitelist |
| TenantGate | Không có link hợp lệ | 403 |
| SandboxGate | `link.status = DRAFT` | Chỉ cho `/api/mfo/*`, `/api/me/profile`, `/api/auth/me`, `/api/tenants` |

### 4.2 ALS Context

- Platform Token: chỉ có `userId`.
- Context Token (sau switch): có `activeTenantId`, `activeMemberId`, `activeLinkStatus`.
- Mọi query Prisma phải đi qua ALS.

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
| Xác nhận | Có hộp thoại xác nhận trước khi nộp Claim / MFO |

---

## 6. Optimization

| Điểm | Biện pháp |
|------|-----------|
| Lock timeout | `SET LOCAL lock_timeout = '3s'` trong transaction có advisory lock |
| Cache | `hubFlight` 8s cho bundle hồ sơ |
| Index | Partial unique + index trên `user_member_links(user_id, tenant_id)` |
| Batch | `createMany` cho evidence_links và parentages |
| N+1 | Dùng `include` hoặc `Promise.all` khi load profile |

---

## 7. Tài liệu liên quan

| Tài liệu | Phiên bản |
|----------|-----------|
| BPMN RP & OP | 2.5.0-FROZEN |
| Implementation Plan | v1.3-READY |
| FTDI Spec | v1.0.4+ |

---

**Kết luận:** Khung này là baseline cho tài liệu thiết kế chi tiết. Mỗi mục có thể mở rộng thành đặc tả riêng khi cần.
