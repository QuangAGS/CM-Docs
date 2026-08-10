# Plan chi tiết OP-2 — Tenant Activate

*(Q1/Q2 tuân thủ tuyệt đối — chưa sinh code)*

---

### 1\. Mục tiêu OP-2

Cho phép CLAN\_ADMIN (hoặc SYSTEM\_ADMIN) chuyển tenant từ TAM\_NGUNG → HOAT\_DONG một lần, sau khi SYSTEM đã duyệt CreateClan.  
Sau khi activate thành công:

* Tenant mở khóa Heavy gate.  
* CLAN\_ADMIN có thể sử dụng đầy đủ chức năng quản trị dòng họ.  
* Đây là bước bắt buộc để CLAN\_SETUP đạt Definition of Done theo OP-Boundary-Definition-SSOT-2026-08-09.

---

### 2\. Invariants bắt buộc (Q1)

1. Không đụng logic Register / processUserApproval / revision / final rejection đã UAT OK.  
2. Chỉ cho phép chuyển đúng một chiều: TAM\_NGUNG → HOAT\_DONG.  
3. Không cho phép activate nếu tenant đang ở CHO\_DUYET, TU\_CHOI, BI\_KHOA, NGUNG\_HAN, HOAT\_DONG.  
4. Correlation chỉ dùng factory tập trung (prisma.correlation.create()).  
5. Mọi thay đổi status phải ghi changed\_by \+ BPL \+ audit.  
6. Không tạo Member mới, không đổi users.status, không đụng onboarding\_cases trong OP-2.  
7. FE chỉ hiện nút/activate khi tenantStatus \=== 'TAM\_NGUNG' và role hợp lệ.

---

### 3\. Authz Matrix

| Actor | Điều kiện được phép activate | Kết quả |
| ----- | ----- | ----- |
| CLAN\_ADMIN | users.status \= DA\_DUYET và tenant\_id trùng với tenant đang activate và tenant hiện TAM\_NGUNG | Được |
| SYSTEM\_ADMIN | Luôn được (full support) | Được |
| Khác (MEMBER, …) | — | 403 |
| Tenant không phải TAM\_NGUNG | — | 409 hoặc 422 |

---

### 4\. Service Design

Vị trí đề xuất (Q1 ưu tiên):

* Tạo function mới trong Backend/src/modules/tenants/ (không nhét vào auth.service.js để tránh phình file Register).  
* Tên đề xuất: activateTenant (hoặc tenant.service.js → activate).

Logic cốt lõi (trong TX):

1. Resolve tenant bằng id.  
2. Kiểm tra authz theo matrix trên.  
3. Kiểm tra tenant.status \=== 'TAM\_NGUNG' (fail-closed).  
4. Update:  
   JavaScript:

```
status: 'HOAT_DONG',
changed_by: actorId
```

5. Ghi BPL \+ audit \+ correlation.  
6. Trả về tenant đã cập nhật (minimal fields).

**Idempotency:**

Nếu gọi lại khi đã HOAT\_DONG → trả 409 TENANT\_ALREADY\_ACTIVE (không silent success).

---

### 5\. TX \+ Side-effects

Bắt buộc trong một transaction:

| Bước | Hành động | Ghi chú |
| ----- | ----- | ----- |
| 1 | Tạo correlation | Factory tập trung |
| 2 | Update tenants.status | Chỉ TAM\_NGUNG → HOAT\_DONG |
| 3 | Ghi Business Process Log | business\_process\_type đề xuất: TENANT\_ACTIVATE (cần xác nhận có enum sẵn không) |
| 4 | Ghi Audit log | Actor \+ before/after status |
| 5 | (Optional) Notification | Có thể hoãn sang phase communication |

***Không làm trong TX này:***

* Đổi users.status  
* Tạo/update Member  
* Đụng onboarding\_cases

---

### 6\. API / Route

Đề xuất:

text

```
POST /api/tenants/:id/activate
```

* Middleware: verifyToken \+ authz check (CLAN\_ADMIN hoặc SYSTEM\_ADMIN)  
* Không dùng tenantStatusHeavy trên chính route này (vì đang ở TAM\_NGUNG)  
* Response thành công: 200 \+ tenant object (id, name, status, …)  
* Lỗi chuẩn CED (dual-contract)

***Vị trí file:***

Mở rộng Backend/src/modules/tenants/tenant.routes.js (hiện chỉ có CRUD cơ bản).

---

### 7\. Error Codes (CED)

Tái sử dụng tối đa từ tenant.codes.js hiện có:

| Tình huống | Code đề xuất | HTTP |
| ----- | ----- | ----- |
| Tenant không tồn tại | TENANT\_NOT\_FOUND | 404 |
| Không đúng quyền | CROSS\_TENANT\_DENIED / FORBIDDEN | 403 |
| Tenant không ở TAM\_NGUNG | TENANT\_NOT\_ACTIVATABLE (mới) hoặc TENANT\_ALREADY\_ACTIVE | 409 |
| Đã HOAT\_DONG | TENANT\_ALREADY\_ACTIVE (mới) | 409 |

Cần xác nhận có thêm 1–2 code mới hay map vào code hiện có.

---

### 8\. FE Gate

Điều kiện hiện nút / cho phép gọi activate:

* user.role \=== 'CLAN\_ADMIN' (hoặc SYSTEM\_ADMIN)  
* user.tenantStatus \=== 'TAM\_NGUNG'  
* user.status \=== 'DA\_DUYET'

***Vị trí đề xuất:***

* Sau login, nếu tenantStatus \=== 'TAM\_NGUNG' → redirect hoặc hiện banner/page “Kích hoạt dòng họ”.  
* Không chặn login (đã cho phép từ trước).  
* Sau activate thành công → force refresh token / re-login nhẹ để JWT mang tenantStatus \= HOAT\_DONG.  
* Không sửa logic RegisterForm / WaitingPage / ApprovalForm.

---

### 9\. Smoke Checklist tối thiểu

| \# | Kịch bản | Kỳ vọng |
| ----- | ----- | ----- |
| 1 | CreateClan → SYSTEM approve → tenant \= TAM\_NGUNG | Đúng như hiện tại |
| 2 | CLAN\_ADMIN login khi tenant TAM\_NGUNG | Login thành công, JWT có tenantStatus: "TAM\_NGUNG" |
| 3 | CLAN\_ADMIN gọi POST /tenants/:id/activate | 200, status → HOAT\_DONG |
| 4 | Gọi activate lần 2 | 409 Already Active |
| 5 | MEMBER thường gọi activate | 403 |
| 6 | SYSTEM\_ADMIN activate bất kỳ tenant TAM\_NGUNG | 200 |
| 7 | Sau activate, Heavy route (ví dụ duyệt member) | Không còn bị chặn bởi TAM\_NGUNG |
| 8 | Regression: JoinClan \+ approve vẫn hoạt động bình thường | Không bị ảnh hưởng |

---

### 10\. Out of Scope (OP-2)

* Tự động activate khi approve (giữ thủ công).  
* Đổi Member DU\_BI → CHINH\_THUC.  
* Merge cây.  
* Notification đầy đủ.  
* FE redesign lớn.  
* Thay đổi middleware Heavy hiện tại.

---

### 11\. Câu hỏi cần bạn xác nhận trước khi viết code

1. Vị trí service: Tạo tenant.service.js mới hay thêm method vào file nào hiện có?  
2. BPL type: Có sẵn TENANT\_ACTIVATE trong enum business\_process\_type không? Nếu chưa, có cho phép thêm không?  
3. Error code mới: Đồng ý thêm TENANT\_ALREADY\_ACTIVE \+ TENANT\_NOT\_ACTIVATABLE không?  
4. FE: Chỉ cần banner \+ nút Activate đơn giản, hay cần page riêng “Hoàn tất kích hoạt dòng họ”?  
5. Token refresh: Sau activate có bắt buộc client re-login / refresh JWT ngay không?

