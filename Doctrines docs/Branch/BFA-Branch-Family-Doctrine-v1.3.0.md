# BFA — Học thuyết Cây người / MFO / Chi

```
PATH       : BFA/BFA-Branch-Family-Doctrine-v1.3.0.md
DATETIME   : 2026-09-16T14:45:00+07:00
VERSION    : 2.0.0 UPERSEDED BY BFA-Branch-Family-Doctrine-v1.3.0
STATUS     : ACCEPTED-FOR-PHASE-TREE
THAY        : BFA-Branch-Family-Doctrine-v1.0 (lớp Chi)
              BFA-MFO-Doctrine-v1.2.0 (bản dump hội thoại — không dùng)
SSOT-CÙNG  : BFA-Branch-v1.1.0 · HandOver-M13-Branch-2026-09-11
PHA HIỆN TẠI : Xây Cây người từ MFO / 5L
PHA SAU      : Tổ chức Chi trên cây đã có (không bãi bỏ máy Chi đã live)
KHÓA       : Q1 bảo toàn máy Chi đã live · ALS · EDITOR ≠ users.status
             place ≠ usage · A01 không sửa users.phone/email,
             members.gender, members.is_alive
             Multi-home = nợ · RP/OP/SM CLOSED
             members.phone/email không unique · không sửa schema audit_logs
```

Tài liệu này là bản sạch. Một giọng. Không dán hội thoại.  
Đọc từ trên xuống: thuật ngữ → nền tảng → cửa khai → lớp Chi (pha sau) → vai → trình duyệt → phụ lục máy đã live → lịch sử / nợ.

---

## 0. Thuật ngữ

Cùng một từ, cùng một nghĩa trong toàn bộ pha này.

| Từ | Nghĩa trong tài liệu này |
|---|---|
| **Sổ** | Cơ sở dữ liệu thành viên và quan hệ đã ghi (`members` + cha/mẹ + hôn nhân). «Đứng sổ» = đã có hàng `members`. Không phải sổ giấy, không phải chi. |
| **Cây người** (cây phả hệ) | Đồ thị huyết thống: mỗi nút là một `members`, cạnh là `father_id` / `mother_id` (và hôn nhân nếu có). Đây là **nền**. |
| **MFO** | Một *cửa sổ khai* trực hệ: tối đa 5 dòng đời, neo một Origin. Không phải một chi. Không phải cả cây họ. |
| **5L / Sơ đồ các đời** | Form 5 dòng của một MFO. Cùng khung cho người trình, người làm, người duyệt. |
| **Lô** | Một vòng xin phép → làm → nghiệm thu trên *một* 5L. Có thể lặp. |
| **Origin** | Người được suy tôn là gốc của *cửa sổ đang xét* (Dòng 0). Là `members` đã có. |
| **Founder** | Người được giao tổ chức lô / cây trực hệ đó. Bắt buộc **MWL**. Không mặc định = Origin. |
| **MWL** | Member With Login: `users.member_id` trỏ tới hàng `members`. |
| **UM** | Unknown Member — hàng placeholder do **ADMIN** tạo, có đời, chưa biết tên thật. |
| **Tem** | Quyết định một chiều trên ticket (chi hoặc lô). Không tự đảo. |
| **Chi / Ngành / Nhánh** | Nhãn *tổ chức* vẽ lên cây người khi họ chọn chia phái. Tùy họ, đổi theo thời gian. **Pha sau.** |
| **Trưởng*** | Chức trên sổ: `members.role` / `member_offices` (`TRUONG_HO`, `TRUONG_CHI`, …). |
| **ADMIN IT** | `users.role` = `CLAN_ADMIN` hoặc `SYSTEM_ADMIN` — bấm máy, cấu hình. |
| **EDITOR** | Quyền ghi trên một phạm vi (chi / lô). Không phải `users.status`. |
| **ASSIGN / CREATE / EMPTY** | Ba việc trên một dòng 5L: chọn người có sẵn / được phép tạo mới / để trống. |

«Sổ chi» nếu cần nói riêng: hàng `branches` đã `APPROVED`. Mặc định «sổ» = cây người.

---

## 1. Nền tảng — Cây người trước

### 1.1 Vì sao đổi thứ tự so với v1.0

v1.0 lấy **Chi** làm cửa vào. Khi thi hành, nảy sinh: gà–trứng founder / `branch_id`, USER tạo chi rác, quota đời trên chi trống người, Origin bị nhầm với Founder.

Thực tiễn họ: **không phải dòng họ nào cũng chia Chi**. Họ có Chi thì mỗi đời một kiểu, gộp–tách lại. Chi không đủ ổn định để làm nền dữ liệu.

Huyết thống ổn định hơn. Có **Cây người** rồi, muốn tổ chức phái kiểu gì cũng chọn tập trên cây mà ghép.

### 1.2 Quyết định pha này

1. Xây **Cây người** bằng các lô MFO / 5L.  
2. **Tạm gác** tổ chức Chi: không lấy Chi làm điều kiện để khai người. Không bãi bỏ bảng và máy Chi đã live — chuyển sang pha sau, khi cây đủ chắc.  
3. `members.branch_id` **được null**. Người đứng sổ chưa cần thuộc chi.  
4. Dữ liệu hiện tại chỉ phục vụ smoke (chưa production). Được xóa/sửa fixture. **Không revert** hàng chi đã tem nếu còn dùng để đối chiếu máy — chỉ không lấy chúng làm cửa vào MFO.

### 1.3 Hai lớp vẫn còn — khác vai trò

| | Cây người | Chi |
|---|---|---|
| Là gì | Huyết thống | Nhãn tổ chức (tùy họ) |
| Lưu | `members`, `father_id`, `mother_id` | `branches`, `parent_id` chi, `members.branch_id` |
| Pha | **Hiện tại** | **Sau**, khi cây đã có |
| Bắt buộc? | Có, nếu muốn gia phả | Không — họ không chia phái thì dừng ở cây người |

Một chi (khi có) chứa nhiều hộ. Một MFO không đủ = một chi.

---

## 2. MFO / 5L — cửa xây Cây người

### 2.1 Đơn vị làm việc

Một **lô** = một **5L** neo **một Origin đã có trên sổ**.

Sâu tối đa **5 dòng** mỗi lô. Ô trống được. Không bắt đủ 5.

Muốn sâu thêm hoặc ngang thêm → **lô mới**, Origin phải rõ (cùng Origin = ngang; Origin = người dòng dưới lô trước = sâu tiếp).

### 2.2 Sơ đồ các đời (5L)

| Dòng | Mặc định | Việc |
|---|---|---|
| 0 | Origin | `ASSIGN` — `member_id` có sẵn. USER không UM. |
| 1 | Con Origin | `ASSIGN` / `CREATE` / `EMPTY` |
| 2 | Cháu | như trên |
| 3 | Chắt | như trên |
| 4 | Chút | như trên |

Nếu chỉ biết tôi–con–cháu (cha mẹ mất sớm): Dòng 0 = chính MWL.

Con dâu / rể / nuôi: ghi `child_type` + Note. **Không** đếm bước đời huyết thống.

### 2.3 Chọn, không clone

Người đã có (ông, bố, tôi…) → chọn `member_id`, không `POST` hàng mới.

Chọn Origin → hệ thống **gợi ý** các con đã có trên cây. Người khai tick vào ô. Không tự gắn cả nhánh.

Cùng một người xuất hiện trên nhiều MFO = đúng.  
Cấm: hai UUID cho một người. Trùng tên ≠ trùng người — cảnh báo; ADMIN gộp (nợ).

### 2.4 UM

Chỉ ADMIN tạo (lô 2+ hoặc cây lịch sử cho khỏi rỗng).  
Có `generation`. Không login, không Founder, không Origin lần 1 của USER.  
Biết tên thật → sửa **cùng hàng**.

### 2.5 Ai được tạo người / chi trong pha này

MWL **không** tự do `POST /branches` và **không** tự do `POST /members`.

MWL chỉ:

- soạn 5L (PLAN),  
- sau khi PLAN được phép: `ASSIGN` người trong `reuse_member_ids`, `CREATE` đúng ô đã chỉ định,  
- nộp RESULT.

ADMIN / Trưởng tạo Origin (và UM nếu cần) **trước** khi USER trình lần 1.

Audit: `changed_by` = `users.id`.

---

## 3. Chi — lớp sau (tạm gác, không bãi)

Khi Cây người đủ dùng:

- Chọn một tập người trên cây + Origin chi + Founder.  
- Tạo / dùng hàng `branches`, gắn `members.branch_id`.  
- Tem chi (`APPROVED`) = Ban tổ chức thừa nhận *phái*, không phải thừa nhận một hộ.

Cầu nối đã chốt (giữ trong tài liệu, làm ở pha Chi):

> Cây trực hệ Founder khai **có thể chưa thuộc chi**. Lúc duyệt (pha Chi), ADMIN/Trưởng **gán chi** cho cây đó.

Precond Submit chi hiện tại («cặp cha–con cùng `branch_id`») **lệch** khi MFO không gắn chi.  
**Hướng xử:** nới precond ở lát riêng *trước hoặc trong* pha Chi; **không trộn** vào lát PLAN.  
Pha này: ghi nhận tồn đọng; không sửa máy Submit chi trừ khi mở lát riêng.

Máy Chi đã live (phụ lục §8) **bảo tồn** cho pha sau: cột Origin, quota, REVIEW API, Lát 1 gắn, FK `ON DELETE NO ACTION`.

Smoke đã tem: không bắt buộc xóa; không lấy làm cửa MFO.

---

## 4. Vai — bốn lớp

| Vai | Là gì | Login |
|---|---|---|
| Origin | Gốc cửa sổ / tổ được suy tôn | Không bắt |
| Founder | Người tổ chức lô / cây trực hệ | **Bắt MWL** |
| Trưởng* / EDITOR | Chức sổ hoặc quyền ghi được giao | MWL nếu duyệt nội dung |
| `users.role` | Cửa JWT | Tài khoản |

`members.role` = chức **hiện tại**. Lịch sử chức: `member_offices` (đã có) hoặc bảng kiểu `member_residences` — không nhét vào `audit_logs`.

Duyệt đúng sai 5L: Trưởng họ / Trưởng chi (ủy quyền theo chi nếu đã chỉ định trên `member_offices.branch_id`).  
Chưa chỉ định Trưởng* → `CLAN_ADMIN` quyết hết.  
ADMIN IT bấm máy khi Trưởng nhờ. V1: một người vừa Trưởng vừa `CLAN_ADMIN` được; tự duyệt = tự chịu, ghi Note.

`users.role` có `EDITOR` — **không** đồng nhất EDITOR chi / lô. Không đụng `users.status`.

---

## 5. Hai lần trình trên 5L (lặp được)

Cùng một 5L cho trình / làm / duyệt.

### 5.1 PLAN — xin phép

Bắt buộc trên ticket:

- Origin = `member_id` đã có.  
- Đời tuyệt đối của Origin **kê lúc trình**, **chốt lúc phê**.  
- Chi: *đề xuất được, không bắt* trong pha Cây người. Nếu có đề xuất: chốt lúc phê (pha Chi dùng).  
- Năm ô: `ASSIGN | CREATE | EMPTY` + `member_id?` + hint.  
- `reuse_member_ids[]`.  
- Founder = MWL được giao.  
- `mode`: `DEPTH` | `WIDTH` + `anchor_member_id` khi không phải lô đầu.

Chưa phê PLAN → không `CREATE` / không ATTACH ngoài khung.

### 5.2 RESULT — nghiệm thu

Đối chiếu đúng 5L đã duyệt. Lệch ô → không tem, Note ô nào sai.  
Đúng → tem lô. Người mới đứng **Cây người**.

Serialize: một ticket mở / một cặp **Founder + phạm vi** (pha này: Founder + Origin cửa sổ). Chưa nghiệm thu thì không mở lô mới cùng Founder+Origin.

### 5.3 Trạng thái lô (trên ticket, không thêm `branch_status`)

```
5L_DRAFT → 5L_SUBMITTED (PLAN)
        → 5L_PLAN_OK
        → 5L_RESULT
        → 5L_APPROVED | 5L_REJECTED
5L_REJECTED / WITHDRAWN → được mở 5L mới
```

V1: `proposals.ticket_type = BRANCH_REVIEW` + `payload.kind = PLAN | RESULT`  
(tên type có chữ BRANCH — nợ đổi tên khi tách enum; không thêm `branch_status`).

---

## 6. Quota — hai số, không trộn

| Số | Nghĩa | Pha |
|---|---|---|
| Trần **lô** | Sâu ≤ 5 dòng trên một 5L | Hiện tại |
| `branches.max_generation_span` | Trần sâu **chi** sau khi tem chi | Pha sau |

Cột chi **giữ**. Không xóa. Không bắt MFO tuân cột chi khi `branch_id` null.

Đếm đời trên cây: bước `father_id` / `mother_id` từ Origin cửa sổ. Không tin `members.generation` rỗng. Đời Origin tuyệt đối do Trưởng/Admin chốt lúc phê PLAN.

---

## 7. Khóa (mọi pha)

- ALS: không nhét `tenant_id` vào `findUnique` / `update`.  
- A01: không sửa `users.phone`, `users.email`, `members.gender`, `members.is_alive` qua cửa này.  
- EDITOR ≠ `users.status`.  
- `place ≠ usage` (`member_residences`).  
- Không sửa schema `audit_logs`.  
- `members.phone` / `email` không unique.  
- Multi-home (một người hai họ) = nợ. Không share member giữa tenant.  
- RP / OP / SM không mở lại.

Q1 pha này: không phá route Chi đã live. Tắt cửa USER tạo chi/member tự do = **siết quyền**, không xóa endpoint Admin.

---

## 8. Phụ lục — máy Chi đã live (bảo tồn pha sau)

Không dùng làm cửa vào MFO. Không revert.

```
DRAFT | PROVISIONAL ──submit──► SUBMITTED ──approve──► APPROVED
         ▲                         │
         └── reject ──► REJECTED ──┘ submit lại (ticket mới; cũ WITHDRAWN)
APPROVED: không submit / approve / reject (409). PUT field vẫn được.
```

Precond Submit chi (hiện tại): `founder_id` + ≥1 cặp cùng `branch_id`.  
Lát 1: `PATCH /founder` (có ghi `branch_id`) · `/origin` (không đổi `branch_id` người Origin) · `/members` ATTACH/DETACH (DETACH khóa khi đã xét / đã tem).

FK `origin_member_id`: `ON DELETE NO ACTION`.

---

## 9. Lịch sử thi hành — đã đạt / còn nợ / vì sao

### 9.1 Đã đạt (giữ)

| Hạng | Vì sao giữ |
|---|---|
| Tách Chi ≠ hộ (v1.0) | Đúng; chỉ **đổi thứ tự**: cây trước, chi sau |
| Origin ≠ Founder ≠ EDITOR ≠ JWT | Một cột không gánh hai nghĩa |
| Cột `origin_member_id`, `max_generation_span` + FK neo người | Pha Chi và neo MFO đều cần Origin |
| SUBMIT / APPROVE / REJECT chi + ticket mới + tem ≠ niêm field | Máy tổ chức pha sau |
| Lát 1 gắn founder / origin / member | Gắn nhãn chi khi có phái |
| Catalog BPL / silentIntent `BRANCH_*` | Quan sát lô và chi |
| APPROVED chi không đảo | Chống sửa tem miệng |
| Chọn không clone | Chống dư UUID |

Smoke 15/09 (chi Xuyến, N=4, Origin + Founder): chứng minh máy Chi chạy. Không phải mẫu bắt MFO phải có chi.

### 9.2 Còn nợ — pha Cây người (làm)

1. Bản sạch này lên `CM-Docs` (thay dump v1.2.0).  
2. Ticket `PLAN | RESULT` + payload 5 ô.  
3. Cửa PLAN / phê PLAN (chốt đời Origin).  
4. Khóa ATTACH / CREATE trong khung PLAN.  
5. RESULT đối chiếu tay V1.  
6. Picker Origin + con Origin (FE) + VoiceHelp 5L.  
7. Siết MWL: cấm `POST /branches` và `POST /members` ngoài khung.  
8. Founder = MWL (`users.member_id` bắt buộc).

### 9.3 Còn nợ — pha Chi (sau cây)

- Nới precond Submit chi khi người chưa có `branch_id`.  
- Gán chi cho cây trực hệ lúc duyệt.  
- Map `member_offices` / `members.role` Trưởng* → duyệt theo chi.  
- Ủy quyền Trưởng họ → Trưởng chi.  
- Trần `max_generation_span` lúc gắn người vào chi.  
- MERGED + offset đời.  
- Grant EDITOR chi.  
- Đổi tên `BRANCH_REVIEW` khi tách lô khỏi tem chi.

### 9.4 Nợ cũ không thuộc hai pha trên

4 đời login (bind user ↔ member) · multi-home · unique UM · lịch sử chức nếu `member_offices` chưa đủ dùng · form duyệt Chi.

### 9.5 Vì sao v1.0 chưa đủ

v1.0 đúng *tách lớp* nhưng lấy Chi làm cửa vào. Họ không chia phái thì cửa đó thừa; họ có phái thì phái đổi theo đời. Thi hành M13 lộ ra MFO/5L mới là đơn vị khai vừa tầm Admin đọc nổi. v1.3 ghi lại thứ tự đó.

---

## 10. Một trang — câu đóng

Cây người là nền. MFO 5L là cửa xây nền. Chi là cách họ *có thể* sắp nền đó — làm sau, không làm trước.

Origin là người đã đứng sổ. Founder là MWL được giao một lô. Sơ đồ 5 dòng là chỉ dẫn, là việc làm, là thước duyệt.

Nháp thì rẻ. Tem lô thì một chiều. Chưa nghiệm thu thì chưa lô mới.  
Không clone người. Không bịa UM phía USER. Không lấy Chi làm điều kiện tồn tại một hộ.

---

## 11. Lát code (pha Cây người)

Hỏi trước khi sinh mã. Một lát một việc.

1. Đưa file này vào `CM-Docs/BFA/`, đánh dấu dump v1.2.0 là superseded.  
2. Ticket PLAN/RESULT (payload 5L) — chưa form FE.  
3. Cửa PLAN + phê PLAN.  
4. Siết POST chi/member của USER.  
5. Khóa làm việc trong khung.  
6. RESULT.  
7. Picker FE.

Không làm cùng PR: unique UM + bảng role history + nới Submit chi + MERGED.
