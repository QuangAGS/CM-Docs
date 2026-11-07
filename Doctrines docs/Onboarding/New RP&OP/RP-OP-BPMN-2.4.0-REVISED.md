# ĐẶC TẢ KIẾN TRÚC & QUY TRÌNH BPMN 2.0: REGISTER PROCESS (RP) & ONBOARDING PROCESS (OP)

**Dự án:** myclan.com.vn  
**Phiên bản:** 2.4.0-BPMN-MULTIHOME-REVISED  
**Ngày:** 2026-11-06  
**Tiêu chuẩn:** BPMN 2.0, EGAL-SEC Doctrine, FT-DOCTRINE-SPEC v2.2.0

---

## 1. Thay đổi so với bản 2.3.0

| Điểm | Bản cũ | Bản mới |
|------|--------|---------|
| Trạng thái user sau OTP | `DA_DUYET` ngay | `CHO_DUYET` cho đến khi có ít nhất một `user_member_links` được duyệt |
| Thứ tự Claim | Tạo link trước, kiểm tra tranh chấp sau | Kiểm tra tranh chấp trước; link chỉ tạo ở trạng thái `PENDING` |
| Ràng buộc SSOT | Không ghi | Bổ sung partial unique index `unique_active_member_per_tenant` |
| Dữ liệu mâu thuẫn | Không có | Bổ sung luồng Profile Correction sau khi Claim được duyệt |

---

## 2. Ma Trận Phân Làn

| Làn | Đối tượng | Trách nhiệm |
|-----|-----------|-------------|
| Lane 1: End User | Người dùng cuối | OTP, chọn dòng họ, Claim 3 lớp hoặc khai MFO |
| Lane 2: Frontend | Client | Điều hướng, TenantGate |
| Lane 3: Backend | Services | Tạo user, kiểm tra tranh chấp, ghi proposals, evidences |
| Lane 4: Admin | CLAN_ADMIN | Duyệt Claim hoặc duyệt MFO (cổng G01) |
| Lane 5: Database | PostgreSQL | Transaction SSOT, partial unique index |

---

## 3. Bảng Hoạt Động (Đã điều chỉnh)

| Mã | Loại | Tên | Đặc tả |
|----|------|-----|--------|
| EVT_START | Start | Bắt đầu | Khởi động đăng ký |
| ACT_AUTH | Service | Xác thực OTP | Tạo `users` với **status = 'CHO_DUYET'**. Cấp JWT nền tảng (chưa có quyền dòng họ). |
| ACT_SELECT_CLAN | User | Chọn dòng họ & link_type | Chọn tenant và `link_type` (PRIMARY_PATERNAL, MATERNAL, SPOUSE_FAMILY, GUARDIAN, OTHER). |
| GW_BRANCH_TYPE | XOR | Đã có tên trong sổ? | Rẽ nhánh Claim hoặc Mới. |
| ACT_CLAIM_CHECK | Service | Kiểm tra tranh chấp | Trước khi tạo link: nếu member đã có claim PENDING khác → đánh dấu DISPUTED. |
| ACT_CLAIM_SUBMIT | User | Nộp Claim 3 lớp | Chọn member, trả lời trắc nghiệm, cross-check SĐT, gửi bảo lãnh. |
| ACT_RECORD_CLAIM | Service | Lưu Claim | Tạo `proposals (MEMBER_CLAIM)`, `evidences`, và `user_member_links` với **status = 'PENDING'**. |
| GW_DISPUTE | XOR | Trùng Claim? | Nếu có → DISPUTED. |
| ACT_ADMIN_CLAIM_APP | User | Duyệt Claim (G01) | Admin thẩm định 3 lớp. |
| TX_COMMIT_CLAIM | Transaction | Kích hoạt liên kết | `user_member_links.status = 'DA_DUYET'`. **Không tạo member mới.** |
| ACT_PROFILE_CORRECTION | Service | Ghi nhận chênh lệch | Nếu có `declared_diffs`, tạo đề xuất `PROFILE_CORRECTION` (cổng G01 riêng). |
| ACT_NEW_PROFILE | User | Khai cá nhân | Tạo `members (DU_BI)`. |
| ACT_MFO_WORKBENCH | User | Lập MFO 5L | Dựng gia đình, neo Origin. |
| ACT_ADMIN_MFO_APP | User | Duyệt MFO (G01) | Kiểm tra snapshot. |
| TX_COMMIT_MFO | Transaction | Materialization | `members → CHINH_THUC`, sinh `parentages`, kích hoạt `user_member_links`. |
| EVT_END | End | Hoạt động | Truy cập đầy đủ, Clan Switcher. |

---

## 4. Ràng buộc SSOT (Bổ sung)

### 4.1 Partial Unique Index

```sql
CREATE UNIQUE INDEX unique_active_member_per_tenant
ON user_member_links (tenant_id, member_id)
WHERE status = 'DA_DUYET';
```

**Ý nghĩa:** Một member chỉ được liên kết với tối đa một user ở trạng thái `DA_DUYET` trong cùng tenant.

### 4.2 Trạng thái User

- Sau OTP: `users.status = 'CHO_DUYET'`.
- Chỉ chuyển `DA_DUYET` khi có ít nhất một `user_member_links.status = 'DA_DUYET'`.

---

## 5. Luồng Profile Correction (Bổ sung)

Sau khi Claim được duyệt:

1. Hệ thống so sánh dữ liệu EU khai với sổ họ.
2. Nếu có chênh lệch (năm sinh, SĐT, ...), tạo `proposals` loại `PROFILE_CORRECTION`.
3. Admin xem xét riêng (không chặn Claim đã duyệt).
4. Nếu duyệt: cập nhật `members`. Nếu từ chối: giữ nguyên sổ họ, ghi chú.

---

## 6. Tóm tắt Invariants

| Invariant | Mô tả |
|-----------|-------|
| **1-1 Active** | Một member chỉ có một user `DA_DUYET` trong một tenant. |
| **Claim độc lập** | Duyệt ở họ này không tự động có quyền ở họ khác. |
| **SSOT ưu tiên** | Sổ họ giữ nguyên cho đến khi có đề xuất đính chính được duyệt. |
| **Không tạo member khi Claim** | Claim chỉ liên kết, không sinh member mới. |

---

**Kết luận:** Bản 2.4.0 đã điều chỉnh 4 điểm theo review. Có thể dùng làm baseline để triển khai.
