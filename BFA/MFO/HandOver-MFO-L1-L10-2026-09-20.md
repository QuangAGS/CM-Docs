# HandOver — MFO / Cây người (đóng thread dài)

```
PATH       : BFA/HandOver-MFO-L1-L10-2026-09-20.md
DATETIME   : 2026-09-20T08:35:00+07:00
VERSION    : 1.0.0
STATUS     : HANDOFF — thread mới dán §0
SSOT       : BFA-Branch-Family-Doctrine-v1.3.1.md
             BFA-MFO-Lot-Ops-v1.0.md
THAM CHIẾU : BFA-Branch-v1.1.0 · HandOver-M13-Branch-2026-09-11
REPOS      : QuangAGS/cmcodes (main) · QuangAGS/CM-Docs
PHA        : Cây người từ MFO / 5L
```

Q1 bảo toàn máy Chi đã live. Q2 header. Lát nhỏ. Không sinh mã lớn trước khi hỏi.

---

## 0. Dán đầu thread mới

```
Tiếp myClan.com.vn — Cây người / MFO.

SSOT: BFA-Branch-Family-Doctrine-v1.3.1.md
      BFA-MFO-Lot-Ops-v1.0.md
      HandOver-MFO-L1-L10-2026-09-20.md
Repos: QuangAGS/cmcodes (main) + CM-Docs.
RP/OP/SM CLOSED. Không mở lại SM.
Chi live (CRUD + submit/approve/reject) Q1 — tạm gác tổ chức Chi; không revert tem đã có.

Đã xong MFO L1–L9 + EVENT_TEXT:
- Ticket MFO_REVIEW (lô cũ BRANCH_REVIEW+kind=PLAN vẫn đọc)
- PLAN → plan_ok → CREATE/PATCH/spouses/link_founder → RESULT
- Dòng k = ASSIGN MWL; POST members line=k = anh/em
- Trùng sổ: tên+giới+cha/mẹ (+năm nếu cả hai có)
- Ledger MFO_* ; attempt_no SQL sống; emit userId
- EVENT_TEXT + channel/reliability MFO_* (delivery PENDING)
- GET /plans/:id = { ticket, tree } is_clan+marriages

Nợ Cây người (không lát MFO riêng):
- Ẩn nút (members.deleted_at + policy đôi/cạnh/chức) — DELETE lô = thử, chưa chuẩn
- UM
- Chi trên cây đã có
- Form FE 5L

Khóa: ALS; không inject tenant vào update/findUnique
A01 không sửa users.phone/email, members.gender, members.is_alive
EDITOR ≠ users.status · place ≠ usage · không sửa audit_logs
members.phone/email không unique
Một members ∈ một tenant · tối đa một chi
Multi-home = không làm

Q1. Q2. Lát nhỏ. Không sinh mã lớn trước khi hỏi.
Review trực tiếp repos. Việc tiếp: hỏi trước khi mở lát.
```

---

## 1. Việc đã đóng

| Lát | Việc |
|---|---|
| Doctrine | v1.3.1 cây trước Chi; phụ lục Lot-Ops v1.0 |
| L1–L2 | PLAN / approve-reject |
| L3 | USER không POST /members /branches tự do |
| L4.x | GET tree `is_clan` + `marriages` + `sibling_seq` |
| L5–L6 | CREATE trong lô · RESULT |
| L7 | spouses / unions |
| Enum + ledger | 17 nhãn `MFO_*` · BPL + silentEmit |
| L8 | Dòng k ASSIGN founder · `link_founder` · `PATCH /founder` |
| L9 | `PATCH /members/:id` khung người · trùng sổ |
| EVENT_TEXT | 8 câu + channelPolicy + reliabilityPolicy |
| L10 | `DELETE /members/:id` — **thử**, ghi nợ policy nút |

Máy Chi M13 giữ. Profile `/me` `/members/:id` UAT tạm ổn.

---

## 2. Cửa BE đang live (`/api/mfo`)

`POST/GET /plans` · `GET /plans/:id`  
`POST …/approve` · `…/reject`  
`POST …/members` · `PATCH …/members/:memberId` · `PATCH …/founder`  
`POST …/spouses` · `PATCH …/unions/:unionId`  
`POST …/result` · `…/result/approve` · `…/result/reject`  
`GET /tree/:originId`  
`DELETE …/members/:memberId` — chưa coi là SSOT xoá nút

---

## 3. Rule vận hành (rút)

- `k` = bước nội Origin → MWL. Dòng k = ASSIGN MWL.  
- `EMPTY` = cấm cửa đời đó trong lô. `CREATE` = được nhiều người cùng đời.  
- Tem `plan_ok` không niêm phong field.  
- Nối founder không tự xảy ra lúc duyệt RESULT.  
- Đôi = `marriages`, không `father_id` = Origin.  
- Sai người → `PATCH`, không `CREATE` bản 2.

---

## 4. Nợ — một policy Cây người (thread sau)

1. Ẩn nút: `members.deleted_at`; cây/partner lọc sống; đóng `DANG_KET_HON`; không xoá address/quỹ/mộ/thành tích; cấm ẩn Origin lô mở / MWL / login. Cửa lô gọi cùng hàm.  
2. UM: ADMIN tạo; lô chỉ ASSIGN.  
3. Chi trên cây (pha sau).  
4. Form FE 5L.  
5. Gửi kênh thật (`executeImmediately`).  
6. Precond Chi «cặp cùng branch_id» khi MFO là cửa chính.

---

## 5. File máy (cmcodes `main`)

`Backend/src/modules/mfo/mfo.service.js`  
`mfo.controller.js` · `mfo.routes.js` · `mfo.ledger.js` · `mfo.payload.js`  
`notificationOrchestrator.js` (`EVENT_TEXT`)  
`channelPolicy.js` · `reliabilityPolicy.js` · metadata schemas `MFO_*`  
`BusinessLogSchemas` `MFO_*`

---

Hết HandOver. Thread cũ không mở lát mới.
