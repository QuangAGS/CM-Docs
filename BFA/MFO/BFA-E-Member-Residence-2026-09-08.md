# DRAFT E — Lịch sử chỗ ở / di cư
VERSION: 0.1.0-DRAFT
DATETIME: 2026-09-08T10:35:00+07:00
STATUS: CHỜ DUYỆT — không migration cho đến khi chốt

## Mục tiêu
Ghi các lần ở (di cư) theo thời gian. Không phá A01 hiện tại:
- `members.origin_address_id` = quê (place)
- `members.current_address_id` = nơi ở hiện tại / cuối
- `graves` = an táng
- `addresses` = place (tái sử dụng), không chứa «ai ở lúc nào»

`place ≠ usage` giữ nguyên.

## Model đề xuất `member_residences`

| Cột | Kiểu | Ghi chú |
|---|---|---|
| id | varchar(36) PK | uuid |
| tenant_id | varchar(36) | RLS/tenant |
| member_id | varchar(36) | FK members |
| address_id | varchar(36) | FK addresses (place) |
| kind | enum/text | ORIGIN / RESIDENCE / TEMPORARY / LAST |
| from_year, from_month, from_day | int? | |
| to_year, to_month, to_day | int? | null = đang ở |
| is_lunar | boolean | mặc định false |
| is_current | boolean | tối đa 1 dòng true / member |
| note | varchar(255) | |
| created_at, updated_at, changed_by, deleted_at | | soft delete |

Index: (tenant_id, member_id), (member_id, is_current) WHERE deleted_at IS NULL.

## Đồng bộ A01 (không bỏ cột cũ)
- Ghi dòng `is_current=true` → cập nhật `members.current_address_id = address_id`
- Quê: vẫn `origin_address_id`; có thể có 1 residence kind=ORIGIN trỏ cùng place (không bắt buộc)
- Member đã mất: `is_current` = nơi ở cuối; grave riêng
- Không inject tenant vào findUnique/update

## API (lát sau khi schema)
- GET `/me/residences` list gầy (không proof)
- POST / PATCH / DELETE một dòng
- PATCH profile address hiện tại vẫn sửa `current_address` như A01

## UI Task Shell
Mục mới `?section=residence` (không nhét timeline vào form origin/current hiện tại).
List theo năm → Sửa / Xóa / Thêm lần ở. Cùng một Back Hub.

## Không làm trong E
- Sửa `audit_logs` schema
- Đổi `is_alive` / gender / users.phone
- Nén ảnh / R2

## Thứ tự
1. Duyệt DRAFT (file này)
2. Migration + Prisma
3. Service + route
4. FE section
