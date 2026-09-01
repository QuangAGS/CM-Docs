# BFA-Post-OP-myClan — Amendment v2.2.2

**PATH** : CM-Docs/BFA/BFA-Post-OP-myClan-v2.2.2-Amendment  
**DATETIME** : 2026-09-01T15:20:00+07:00  
**STATUS** : DRAFT-2 — bổ sung chế độ CL theo process_type  
**SSOT cha** : BFA-Post-OP-myClan-v2.2.0 + Amendment v2.2.1  
**Phạm vi** : chỉ Business Ledger (BL) và Communication Ledger (CL)  
**Cấm** : mở lại RP / OP / SM đã CLOSED; sửa nội dung 2.2.0 hoặc 2.2.1

---

## 0. Outline (mục đóng)

1. Mục đích và ranh giới  
2. Tuyên bố không đụng 2.2.0 / 2.2.1 / RP / OP  
3. Hai sổ — định nghĩa vận hành  
4. Phân tầng SSOT (docs / Prisma / kernel / orchestrator)  
5. Một cửa BL  
6. Một cửa CL (orchestrator + silentIntent)  
6.1. Ba chế độ CL: NONE / SILENT / DELIVER  
6.2. Vì sao SILENT không tạo delivery kênh ngoài  
7. Danh mục command + đặc tả BL ↔ chế độ CL  
7.1. process_type đã có (RP/OP)  
7.2. process_type A01 (B2)  
8. Lộ trình thực thi B1–B6  
9. Việc cố ý không làm  
10. Tiêu chí đóng amendment  

---

## 1. Mục đích và ranh giới

Amendment này khóa **cách coder ghi sổ** sau Đợt 2 / A01, để không còn nhiều lối vào cùng một bảng.

Không thay product scope 2.2.0. Không thay amendment 2.2.1 (nếu có điều khoản khác). Không thiết kế lại onboarding.

## 2. Tuyên bố Q1

- Không sửa flow Register, OP-2, Tenant Activate, Member Promote đã CLOSED trừ regression có bước tái hiện.  
- Không `DROP` / đổi tên `business_process_logs`.  
- Không tạo bảng `business_ledger` song song trong lát này.  
- Hash chain (`prev_hash`) = nợ VOL I-03, không thuộc 2.2.2.

## 3. Hai sổ — định nghĩa vận hành

| Sổ | Bảng vật lý | Ý nghĩa | Cấm |
|---|---|---|---|
| **BL** | `business_process_logs` | Intent + kết quả **command đổi trạng thái** | Coi `audit_logs` là BL |
| **Audit** | `audit_logs` | Diff record (cũ/mới) | Thay BL |
| **CL** | `notifications` + `notification_recipients` + `notification_deliveries` | Intent / audience / delivery **tin tộc sự** | Gọi persistence từ module lẻ |

`correlation_id` là vết xuyên case → BL → audit → CL. Không dùng `id` hàng thay correlation.

## 4. Phân tầng SSOT

| Tầng | Vai trò | Không phải |
|---|---|---|
| BFA 2.2.2 + VOL I-03 | Luật | Code |
| `schema.prisma` | Cột / enum / append-only | API coder |
| `src/lib/prisma.js` | TX, ALS tenant, helper **private-ish** | Cửa service gọi lung tung |
| `src/services/bpl.service.js` + `ledger.service.js` + `businessLogSchemas.js` | **Cửa BL** | Ba implement độc lập |
| `modules/notifications` orchestrator | **Cửa CL** | `prisma.notification.create` từ profile/onboarding |
| SRPF Writer / Hook | Forward tới hai cửa trên khi engine sống | Persistence thứ ba |

Hai “SSOT CL” (`prisma.js` helper vs orchestrator) **không đối đầu**: orchestrator là cửa nghiệp vụ; helper Prisma chỉ persistence bên trong orchestrator (và job delivery).

## 5. Một cửa BL (bắt buộc)

**Public API duy nhất** (lát B1 chốt tên một hàm, cái kia thành wrapper):

- Input tối thiểu: `correlation_id`, `process_type` ∈ `BusinessLogSchemas`, `actor_id`, `tx`, snapshot `context` + `payload`.  
- Gọi từ trong `prisma.withTransaction`.  
- Thiếu schema `process_type` → reject, không ghi rác.  
- Ghi BL thất bại → **fail command** (cấm `return null` nuốt lỗi).  
- Không `basePrisma` lẻ khi đang có tenant ALS — dùng `tx` của `withTransaction`.

Cấm sau 2.2.2 có hiệu lực trên code mới:

- `tx.business_process_logs.create` trần trong module  
- `_writeBusinessLog` mới  
- `BusinessLedgerWriter` insert thẳng DB  

A01 hiện **được phép** chưa gọi cửa này cho đến B3.

## 6. Một cửa CL — giữ orchestrator

Mọi intent truyền thông đi `orchestrator`. Service nghiệp vụ không `notifications.create` trần.

### 6.1 Ba chế độ CL (bắt buộc ghi trên từng process_type)

Mỗi `process_type` của BL có **đúng một** chế độ CL trong đặc tả. Không mặc định “mọi BL = silentIntent”.

| Mã | Ý | Ghi bảng | Adapter Zalo/mail/SMS |
|---|---|---|---|
| **NONE** | Command không phải tin tộc | Không hàng CL | Không |
| **SILENT** | Có intent truyền thông / mốc quy trình cần nằm trên sổ CL, **chưa** phát kênh | `notifications` (+ recipient nội bộ nếu cần) | **Không** `notification_deliveries` kênh ngoài |
| **DELIVER** | Tin phải tới người | Đủ 3 bảng | Có, qua orchestrator + adapter |

`silentIntent` = triển khai chế độ **SILENT**, không phải tên thứ tư.

### 6.2 Vì sao SILENT không tạo delivery kênh ngoài

Không phải cấm Zalo/mail của sản phẩm. Là **định nghĩa chế độ**:

- Phát kênh = **DELIVER** (có lịch, retry, chứng cứ gửi, máy Delivered/Read).  
- SILENT = đóng băng “hệ thống đã ghi nhận / sẽ nói khi đến bước phát” — không sinh chứng cứ gửi giả.  
- Một BL **không** tự suy ra Zalo. Muốn user nhận tin: đổi đặc tả process_type sang DELIVER (hoặc command thứ hai “gửi thông báo”), không nhét adapter vào `writeBpl`.

Hiểu “mỗi BL đều có silentIntent” theo nghĩa **mỗi BL có một ô chế độ CL** (kể cả ô NONE). Không hiểu là **mỗi BL phải insert một hàng notifications**.

Hai sổ chồng 1-1 (mọi BL → một silent CL) biến CL thành bản sao BL — trái VOL I-03 (CL = vòng đời tin, không phải shadow log).

## 7. Danh mục command + đặc tả BL ↔ CL

Cột CL là chế độ 6.1. Thiếu ô = không được code.

### 7.1 process_type đã có (RP/OP) — không đổi hành vi CLOSED

| process_type | BL | CL | Ghi chú |
|---|---|---|---|
| USER_REGISTER | Có | NONE | Auth; không tin tộc |
| USER_APPROVAL | Có | SILENT hoặc DELIVER theo bước hiện tại orchestrator | Không viết lại |
| USER_REJECTION / USER_LOCK / UNLOCK / UNBAN | Có | SILENT hoặc DELIVER như code hiện hữu | |
| PASSWORD_RESET_REQUESTED | Có | NONE hoặc SILENT nội bộ | Không spam kênh |
| CLAN_CREATE / CLAN_JOIN | Có | SILENT hoặc DELIVER như hiện hữu | |
| TENANT_ACTIVATE | Có | SILENT hoặc DELIVER như hiện hữu | |
| ONBOARDING_CASE_CREATE | Có | NONE hoặc SILENT | SAVE_DRAFT không sinh correlation (SRPF) |
| ONBOARDING_DRAFT_SAVE | Có nếu đã có correlation | NONE | |
| ONBOARDING_PROFILE_COMPLETE / BRANCH_* / SUBMIT / REVIEW / REJECT | Có | SILENT (mốc QT) hoặc DELIVER khi gửi user | Giữ CLOSED |
| MEMBER_ADD / MEMBER_REMOVE | Có | NONE trừ khi có thông báo tộc riêng | |

Chi tiết payload: `businessLogSchemas.js` — 2.2.2 không chép whitelist field.

### 7.2 process_type A01 — thêm ở B2

| process_type | BL | CL | Lý do CL |
|---|---|---|---|
| MEMBER_PROFILE_PATCH | Có (B3) | **NONE** | Tự sửa hồ sơ; không phải tin tộc |
| ACHIEVEMENT_UPSERT | Có (B3) | **NONE** | |
| ACHIEVEMENT_DELETE | Có (B3) | **NONE** | |
| MEMBER_ADDRESS_LINK | Có (B3, nếu tách command) | **NONE** | |

Muốn “dòng họ thấy thành tích mới” = **command khác** (duyệt / công bố) chế độ DELIVER — không đổi UPSERT thành silent.

GET / search: không BL, không CL.

## 8. Lộ trình

| Bước | Việc | Mở SM? |
|---|---|---|
| **B0** | Amendment này — DRAFT → APPROVED | Không |
| **B1** | Gộp cửa BL; wrapper; cấm nuốt lỗi trên **code mới / chỗ đụng** | Không đụng RP/OP |
| **B2** | Schema `MEMBER_PROFILE_PATCH`, `ACHIEVEMENT_UPSERT`, `ACHIEVEMENT_DELETE` | Không |
| **B3** | A01 gọi `withTransaction` + cửa BL | Lát A01 hẹp |
| **B4** | Khóa comment/kernel: orchestrator = cửa CL | Không |
| **B5** | `silentIntent` chỉ nơi danh mục mục 6–7 | Không nhét A01 |
| **B6** | Nợ: hash chain, bảng đổi tên, media thành tích, duyệt status | Ngoài 2.2.2 |

## 9. Việc cố ý không làm

- Event sourcing đầy đủ / Outbox CloudEvents production  
- `proof_urls` trên `achievements`  
- Sửa `App.jsx` để mount Express  
- Đổi catalog địa chỉ / thành tích đã đóng P1  

## 10. Tiêu chí đóng amendment

- [ ] Human Authority phê duyệt bản này  
- [ ] File nằm `CM-Docs/BFA/` cạnh 2.2.0 và 2.2.1-Amendment  
- [ ] HandOver P1 A01 trích dẫn 2.2.2 khi mở B1  

**Kết thúc DRAFT v2.2.2**
