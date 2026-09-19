# BFA — Vận hành lô MFO (phụ lục máy đã live)

```
PATH       : BFA/BFA-MFO-Lot-Ops-v1.0.md
DATETIME   : 2026-09-19T17:20:00+07:00
VERSION    : 1.0.0
STATUS     : WORKING — bổ sung doctrine, không thay thế
SSOT GỐC   : BFA/BFA-Branch-Family-Doctrine-v1.3.1.md
THAM CHIẾU : BFA-Branch-v1.1.0 · HandOver-M13-Branch-2026-09-11
PHA        : Cây người từ MFO / 5L (máy L1–L9 đã smoke)
KHÔNG      : viết lại 5L · không mở lại RP/OP/SM · không đổi khoá A01/ALS
```

Tài liệu này ghi **cửa đang chạy**.  
Doctrine v1.3.1 giữ nguyên thuật ngữ, 5L, `k`, tem, một tenant / tối đa một chi.  
Chỗ lệch với v1.3.1 vì đã thi hành: ghi ở §9. Không dán hội thoại.

---

## 0. Hai khung

| Khung | Trả lời | Chỗ máy |
|---|---|---|
| **Khung lô** (5L đã tem) | Được làm gì, dòng nào, ai làm | `payload.lines[]`, `plan_ok`, `k` |
| **Khung một người** | Một lần `CREATE`/`PATCH` đủ chất chưa | `POST`/`PATCH /api/mfo/plans/:id/members` |

5L không chứa năm sinh, `sibling_seq`, hôn nhân. Những ô đó thuộc khung người hoặc cửa `spouses`.

---

## 1. Ticket và trạng thái

| | Giá trị |
|---|---|
| `ticket_type` lô mới | `MFO_REVIEW` |
| Lô smoke cũ | `BRANCH_REVIEW` + `target_table=members` + `payload.kind=PLAN` — vẫn đọc / list |
| `target_table` | `members` |
| `target_id` | Origin (`origin_member_id`) |

Chuỗi:

`PENDING` → (Admin) `UNDER_REVIEW` + `plan_ok` → làm việc → nộp RESULT → `APPROVED` + `applied_at`  
Từ chối PLAN: `REJECTED`. Trả RESULT: `NEEDS_REVISION` (`plan_ok` giữ).

`plan_ok` = tem «được làm theo phiếu».  
`result_ok` + `APPROVED` = nghiệm thu kết quả.  
**Tem không niêm phong field:** sau `APPROVED` vẫn `PATCH` người của lô, `PATCH …/founder`, `POST …/spouses`. Không `CREATE` đời mới ngoài phiếu — đời mới = lô mới.

Một Founder + một Origin: tối đa **một lô OPEN** (`DRAFT|PENDING|UNDER_REVIEW|NEEDS_REVISION`).

---

## 2. Ba lệnh trên 5L

| `op` | Nghĩa | Sổ đã có người đời đó? |
|---|---|---|
| **ASSIGN** | Chọn người đã có (`member_id` bắt buộc) | Thường là đúng người đó |
| **CREATE** | Được phép tạo **một hoặc nhiều** người cùng đời | Có thể đã có anh/em |
| **EMPTY** | Lô này **cấm** ASSIGN và CREATE đời đó | Có hay không đều được; cây vẫn hiện người sẵn |

`EMPTY` ≠ «sổ trống».  
`CREATE` ≠ bắt buộc tạo ngay.

### 2.1 Dòng `k` = MWL

`k` = số bước nội tộc (`is_clan !== false`) từ Origin tới Founder (MWL). Partner không tính vào `k`.

Khi `k ≥ 1` và đã biết `founder_member_id`:

- Dòng `k` **bắt buộc** `ASSIGN` đúng MWL.  
- `CREATE` Dòng `k` lúc `POST /plans` → `422 MFO_K_MUST_ASSIGN_FOUNDER`.  
- Sau `plan_ok`: `POST …/members` `"line": k` được — sinh **anh/em** MWL, không đè MWL.

`payload.k` = người trình khai. `tree.mwl.k` = máy đếm lúc GET. Lệch = khai tay / cạnh cha mẹ chưa nối.

---

## 3. Cửa sau tem (`plan_ok`)

Base: `/api/mfo/plans/:id`

| Cửa | Việc |
|---|---|
| `POST /members` | Tạo người trên ô `CREATE`, hoặc anh/em ô Dòng `k` |
| `PATCH /members/:memberId` | Sửa người **của lô** (`created_member_ids`, spouse lô, founder) |
| `PATCH /founder` | Gán `father_id` / `mother_id` cho MWL |
| `POST /members` + `link_founder` | Tạo cha/mẹ rồi ghi luôn lên founder (`link_as`: `FATHER` \| `MOTHER`) |
| `POST /spouses` | Tạo/gắn vợ chồng + hàng `marriages` |
| `PATCH /unions/:unionId` | Sửa trạng thái / ghi chú hôn nhân |
| `POST /result` | Nộp nghiệm thu |
| `POST /result/approve` \| `/reject` | Admin đóng / trả sửa |

`GET /plans` — USER thấy lô mình; ADMIN cả tenant (`?mine=1`, `?origin_id=`, `?status=`).  
`GET /plans/:id` — `{ ticket, tree }` (`rule: is_clan+marriages`).

Vợ/chồng **không** chiếm một dòng 5L. Không `father_id` = Origin cho người ngoại.

---

## 4. Khung một người (tạo / sửa trong lô)

### 4.1 Bắt buộc — thiếu → `422`

1. `line` ∈ 1…4, khớp lệnh phiếu.  
2. `full_name` (trim).  
3. `gender` lúc **tạo** (`NAM` \| `NU` \| `KHAC`).  
4. Nội (`is_clan !== false`): ≥ 1 trong `father_id` \| `mother_id`  
   (Dòng `k` bỏ trống → copy từ founder những ô đang trống).

### 4.2 Trùng — `409 MFO_MEMBER_DUP`

So **cả sổ tenant** (`deleted_at` null), không chỉ `created_member_ids`, không đọc BPL.

Khớp *cùng lúc*:

- `full_name` (đúng chuỗi sau trim)  
- `gender`  
- `father_id` và `mother_id` (`null` ≡ `null`)  
- `birth_year`: chỉ khi **cả hai** có năm **và khác nhau** thì *không* trùng. Một bên không năm → vẫn trùng nếu ba nhóm trên khớp.

Không so: `is_clan`, `child_type`, `note`, `sibling_seq`, `branch_id`.

Sửa (`PATCH`) dùng cùng quy tắc, loại trừ chính `memberId`.

### 4.3 Nên gửi

`child_type` (mặc định `CON_DE`), `sibling_seq` khi đã có anh/em, `birth_*`, `note`.

### 4.4 Cấm A01 trên `PATCH`

Không sửa `gender`, `is_alive`, `phone` / `phone_number`, `email`.

Sai chính tả / sai cha mẹ → `PATCH`. Không `CREATE` bản 2.

---

## 5. Nối Founder và nửa dòng họ

Tem RESULT **không** tự gán `father_id` / `mother_id` cho MWL.

Thứ tự đúng khi `k ≥ 1`:

1. Tạo (hoặc ASSIGN) đời `k-1`.  
2. `link_founder` / `PATCH /founder`.  
3. Tạo anh/em Dòng `k` — ô cha/mẹ bỏ trống thì copy từ founder.  
4. Gửi một ô (ví dụ chỉ `mother_id`) → máy **giữ** ô đó, chỉ copy ô còn trống (cùng mẹ khác cha).

Cây GET chỉ đi cạnh nội + `marriages`. Founder `father_id`/`mother_id` null → **không** hiện trên cây dù đứng trên ticket.

---

## 6. Ledger

Enum tách khỏi Chi. Không xoá `BRANCH_*`.

| Cửa | `business_process_type` | `notification_event` |
|---|---|---|
| `POST /plans` | `MFO_PLAN_SUBMIT` | `MFO_PLAN_SUBMITTED` |
| Duyệt / trả PLAN | `MFO_PLAN_APPROVE` / `MFO_PLAN_REJECT` | `…ED` |
| Nộp / duyệt / trả RESULT | `MFO_RESULT_*` | `…ED` |
| Tạo người | `MFO_MEMBER_CREATE` | `MFO_MEMBER_CREATED` |
| Gắn đôi | `MFO_SPOUSE_ATTACH` | `MFO_SPOUSE_ATTACHED` |

Cùng `correlation_id` ticket: `attempt_no` tăng (SQL sống — bảng BPL **không** có `deleted_at`; không `findFirst` qua ALS).  
`silentEmit`: `userId` = actor hoặc `requester_user_id`. `executeImmediately: false`. Lỗi emit **không** phá cửa nghiệp vụ.

Phân biệt Chi / MFO khi đọc sổ cũ: `proposals.target_table` + `payload.kind`, không chỉ `process_type`.

---

## 7. Mẫu phiếu `k = 2` (Origin → đời 1 → MWL)

MWL đã có. Đời 1 chưa có.

```json
{
  "origin_member_id": "<Origin>",
  "k": 2,
  "note": "…",
  "lines": [
    { "line": 0, "op": "ASSIGN", "member_id": "<Origin>", "hint": "Origin" },
    { "line": 1, "op": "CREATE", "hint": "cha hoặc mẹ đời 1" },
    { "line": 2, "op": "ASSIGN", "member_id": "<MWL>", "hint": "Founder" },
    { "line": 3, "op": "EMPTY" },
    { "line": 4, "op": "EMPTY" }
  ]
}
```

`POST /api/mfo/plans`  
Admin: `POST …/approve` `{ "granted_generation": <đời tuyệt đối Origin> }`  
Rồi `POST …/members` Dòng 1 (`link_founder`) → Dòng 2 (em) → `spouses` nếu cần → `POST …/result`.

Không gửi `lines` → máy điền Dòng 0 ASSIGN Origin, 1–4 `EMPTY` → không tạo được người.

---

## 8. Máy Chi (không đụng)

CRUD `/admin/branches`, cây Chi, `POST /branches/:id/submit|approve|reject` giữ Q1.  
USER không `POST /api/members` / `POST /api/branches` tự do (Lát 3).  
`members.branch_id` được null trong pha cây người.

---

## 9. Lệch đã chấp nhận so với v1.3.1

| v1.3.1 | Máy L1–L9 |
|---|---|
| Lô / ticket nói chung `BRANCH_REVIEW` | Lô mới `MFO_REVIEW` |
| Ledger tái dụng `BRANCH_*` | Enum `MFO_*` (17 nhãn) |
| Tem APPROVED một chiều trên chi | Tem lô không niêm phong field người / đôi |
| 5L là đủ để khai | Thêm khung người + `PATCH` + `link_founder` + anh/em Dòng `k` |
| Hôn nhân là SSOT đôi | Cửa `spouses` trong lô; cây `is_clan+marriages` |

Không coi phụ lục này thay § thuật ngữ / § nền tảng v1.3.1.

---

## 10. Nợ

- EVENT_TEXT / whitelist kênh cho 8 event `MFO_*` (intent đã ghi, chưa gửi).  
- Xoá mềm bản `CREATE` thừa (Admin `deleted_at` tay).  
- Multi-home / share member giữa tenant — đã khóa: không làm.  
- Precond Chi «cặp cùng `branch_id`» khi MFO là cửa chính — pha sau.  
- `UM` do ADMIN — chưa cửa MFO.

---

Hết phụ lục v1.0.0.
