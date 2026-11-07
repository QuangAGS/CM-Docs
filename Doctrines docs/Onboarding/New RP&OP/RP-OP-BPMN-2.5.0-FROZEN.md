# ĐẶC TẢ KIẾN TRÚC & QUY TRÌNH BPMN 2.0: RP & OP

**Dự án:** myclan.com.vn  
**Phiên bản:** 2.5.0-BPMN-MULTIHOME-FROZEN 
**Ngày:** 2026-11-06  
**Trạng thái:** Phê duyệt 

---

## 1. Thay đổi so với bản 2.4.0

| Điểm | Bản 2.4.0 | Bản 2.5.0 |
|------|-----------|-----------|
| Enum trạng thái | Lẫn lộn PENDING / CHO_DUYET | Tách rõ: `proposals` dùng tiếng Anh, `user_member_links` dùng tiếng Việt |
| Nhánh B (Mới) | `users.status = CHO_DUYET` chặn MFO | Bổ sung trạng thái `DRAFT` cho `user_member_links` (Sandbox) |
| Kiểm tra tranh chấp | Đặt trước khi nộp | Đưa vào transaction sau khi EU chọn member, kèm row-level lock |

---

## 2. Chuẩn hóa Enum

| Bảng | Trường | Giá trị |
|------|--------|---------|
| `proposals` | `status` | `PENDING` \| `APPROVED` \| `REJECTED` \| `DISPUTED` \| `NEEDS_REVISION` |
| `user_member_links` | `status` | `CHO_DUYET` \| `DA_DUYET` \| `TU_CHOI` \| `HUY_LIEN_KET` \| **`DRAFT`** |
| `users` | `status` | `CHO_DUYET` \| `DA_DUYET` |

**Partial Unique Index:**

```sql
CREATE UNIQUE INDEX unique_active_member_per_tenant
ON user_member_links (tenant_id, member_id)
WHERE status = 'DA_DUYET';
```

---

## 3. Cơ chế Sandbox cho Nhánh B (New Member)

Khi EU chọn "Chưa có tên trong sổ":

1. Tạo `members` với `status = 'DU_BI'`.
2. Tạo `user_member_links` với `status = 'DRAFT'`, `role_in_tenant = 'USER'`.
3. `users.status` giữ `CHO_DUYET`.
4. **Quyền hạn hẹp:** Chỉ được gọi:
   - `/api/mfo/*` (tạo và nộp tờ trình)
   - `/api/me/profile` (cập nhật hồ sơ cá nhân)
5. Các API khác (cây chính thức, quỹ, sự kiện) bị chặn cho đến khi MFO được duyệt.
6. Khi Admin duyệt MFO (G01):
   - `members.status = 'CHINH_THUC'`
   - `user_member_links.status = 'DA_DUYET'`
   - `users.status = 'DA_DUYET'`

---

## 4. Luồng Claim (Đã hiệu chỉnh)

1. **ACT_CLAIM_SUBMIT:** EU chọn member trên cây và nộp xác thực 3 lớp.
2. **ACT_RECORD_CLAIM (Transaction):**
   - `SELECT ... FOR UPDATE` trên `members` (row-level lock).
   - Kiểm tra đã có `proposals` loại `MEMBER_CLAIM` với `status = 'PENDING'` cho `target_member_id` chưa.
   - **Nếu chưa:** Tạo `proposals (PENDING)`, tạo `user_member_links (CHO_DUYET)`.
   - **Nếu đã có:** Đánh dấu cả hai proposal sang `DISPUTED`, gửi cảnh báo Admin.
3. **ACT_ADMIN_CLAIM_APP:** Admin thẩm định.
4. **TX_COMMIT_CLAIM:**
   - `user_member_links.status = 'DA_DUYET'`
   - `users.status = 'DA_DUYET'` (nếu chưa)
   - Nếu có `declared_diffs`: tạo `proposals (PROFILE_CORRECTION)`

---

## 5. Invariants

| Invariant | Mô tả |
|-----------|-------|
| **1-1 Active** | Một member chỉ có một `user_member_links` với `status = 'DA_DUYET'` trong một tenant. |
| **Sandbox** | `DRAFT` chỉ cho phép truy cập MFO và profile. |
| **Claim độc lập** | Duyệt ở họ này không tự động có quyền ở họ khác. |
| **SSOT ưu tiên** | Sổ họ giữ nguyên cho đến khi Profile Correction được duyệt. |
| **Không tạo member khi Claim** | Claim chỉ liên kết, không sinh member mới. |

---

## 6. Tóm tắt trạng thái theo nhánh

| Nhánh | users.status | user_member_links.status | Quyền |
|-------|--------------|---------------------------|-------|
| Sau OTP (chưa chọn họ) | `CHO_DUYET` | — | Chỉ xác thực |
| Claim đang chờ | `CHO_DUYET` | `CHO_DUYET` | Chờ Admin |
| Claim đã duyệt | `DA_DUYET` | `DA_DUYET` | Đầy đủ |
| Nhánh B (Sandbox) | `CHO_DUYET` | `DRAFT` | Chỉ MFO + profile |
| Nhánh B đã duyệt MFO | `DA_DUYET` | `DA_DUYET` | Đầy đủ |

---

**Kết luận:** Bản 2.5.0 đã hiệu chỉnh 3 điểm theo phản biện. Có thể phê duyệt làm FROZEN SSOT.
