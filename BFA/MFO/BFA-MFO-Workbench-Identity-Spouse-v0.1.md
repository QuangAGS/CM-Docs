# BFA — Tờ khai theo khung: định danh + vợ/chồng
**VERSION:** 0.1  
**DATETIME:** 2026-09-24T22:15:00+07:00  
**STATUS:** Ghi nợ UI (smoke W3 tạm chấp nhận form gắn sẵn)  
**SSOT:** BFA-MFO-Lot-Ops + HandOver MFO L1–L10 + lát W3

## Phạm vi chữ
- Bước 1: khung dự kiến. Bước 2: tờ khai theo khung đã duyệt.
- Không dùng «xưởng» với End User.

## Smoke W3 (tạm)
Form định danh trên dòng Xin tạo + ô «Thêm vợ hoặc chồng» trên mọi đời đã có người.  
**Không** coi đó là thiết kế đích. Chỉ để smoke CREATE / SPOUSE API.

## Nợ đã thống nhất
1. Gắn form spouse trên mọi thành viên / cả 5 đời là vô lý.
2. Đời gốc đã đủ đôi, đời dưới đã ASSIGN là con trên sổ — không mở tạo spouse mới mặc định.
3. Dòng ASSIGN (đã chọn trên sổ) không mở form spouse trừ khi quy tắc cho phép.
4. Nhiều con với nhiều vợ/chồng khác nhau: quyết định theo quy tắc, không theo «luôn hiện form».

## Thiết kế đích (chưa code)
Hai nút, vị trí do quy tắc — không nhúng form sẵn:

| Nút | Việc |
|---|---|
| Tạo thành viên | Con (hoặc anh/em đời k) — form định danh; `father_id`/`mother_id` từ đời trên hoặc từ đúng một đôi đã chọn |
| Tạo vợ/chồng | Partner của **một** người đang chọn trên tờ |

Form chỉ mở sau khi bấm nút, xong quay tờ.

## Quy tắc mở nút (dự thảo — lát sau chốt bảng đủ)
- **Tạo thành viên:** dòng Xin tạo còn trống `created_ids`; hoặc đời k thêm anh/em. Không tạo Origin.
- **Tạo vợ/chồng:** người đang chọn chưa có đôi đang kết hôn trên sổ **và** khung chưa chỉ spouse; hoặc ADMIN/MWL chủ đích thêm đôi thứ hai (đa hôn) — phải chọn rõ «đôi nào sinh con».
- Không hiện nút spouse trên dòng EMPTY.
- Không hiện nút spouse chỉ vì người đó là Origin / ASSIGN.

## Cha mẹ khi tạo con
Luôn gán từ **một đôi** (chồng|vợ) của đời trên, không suy từ «mọi người trên dòng». Nhiều vợ/chồng → bắt chọn đôi trước khi tạo con.

## A01
CREATE được `gender`. Không PATCH `gender` / `is_alive` / phone / email.
