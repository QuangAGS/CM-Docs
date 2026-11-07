PATH       : docs/BFA/BFA-MFO-Doctrine-v1.3.0.md
DATETIME   : 2026-10-02T10:05:00+07:00
VERSION    : 1.3.0
STATUS     : AMENDMENT — chờ Founder đóng băng
SSOT-CÙNG  : BFA-Branch-Family-Doctrine-v1.3.x · BFA-MFO-Doctrine-v1.2.0
KHÓA       : Q1 bảo toàn · ALS · EDITOR ≠ users.status · place ≠ usage
             A01 không sửa users.phone/email, members.gender, members.is_alive
             members.phone/email không unique
             Một members ∈ một tenant · tối đa một chi
             Multi-home = không làm
             RP/OP/SM CLOSED
             Không inject tenant vào update/findUnique
             Không sửa audit_logs

Tài liệu này sửa học thuyết lô MFO (cửa sổ 5 đời). Không mở lại module Chi.
Chi vẫn là đơn vị tổ chức. MFO vẫn là cửa sổ huyết thống, không phải Chi.

# 0. Vì sao v1.3.0

v1.2.0 chốt: Founder = MWL; lô 5 dòng; PLAN rồi RESULT; MWL không tự do tạo branch/member.
Ba điểm vận hành đã lệch bản đó và được đóng ở đây:

1. Khai hộ, người lập vẫn là MWL

founder_user_id / founder_member_id = MWL đang login (đã có users.member_id).
ADMIN không phải MWL không lập tờ, trừ kê hộ kỹ thuật đã có (SYSTEM_ADMIN).
Người được khai không bắt buộc nằm trên 5L. k chỉ có khi MWL tự gán mình vào một đời.
Bỏ MFO_K_MUST_ASSIGN_FOUNDER khi k null.

2. Không bắt chọn Đời gốc trước

Vào RF là 5 đời rỗng. Chọn bất kỳ ô nào (ASSIGN / CREATE / UB) rồi BE dựng cửa sổ quanh người đó.
Origin của tờ = người đời 0 sau khi cửa sổ đã dựng, không phải bước wizard.
Trình khi đời 0 có anchor (ASSIGN hoặc UB) và không lỗ giữa đời đã khai.

3. Nhiều chồng / nhiều vợ

Một nội tộc, nhiều tab; mỗi tab = một marriages.id.
Con thuộc tab khi parent_union_id trùng hôn phối đó. Null = không gắn tab (một cha/mẹ, UB, con riêng).
FE không suy father_id + mother_id → tab.
Thứ anh em là trong tab, không phải toàn sổ.

Ghi chú: parent_union_id là cầu R0, không thay child_type và không thay family_units khi cần nhiều ngữ cảnh (nhận nuôi, display).

# 1. Hai đơn vị — giữ nguyên

| | Gia đình / hộ trong lô | Chi |
| --- | --- | --- |
| Là | Cửa sổ huyết thống ≤ 5 đời | Đơn vị tổ chức họ |
| Neo | Người được chọn trên khung (có thể không phải MWL) | Tổ chi, Admin tem |
| Lưu | members + father_id/mother_id + marriages | branches + branch_id |
| Ai lập | MWL (kể cả khai hộ) | Admin / grant Founder chi |

Một chi chứa nhiều lô. Một lô không sinh một chi.
MWL không POST branch và không tạo member ngoài khung PLAN đã duyệt.

# 2. Ba vai trên lô — không gộp

## 2.1 Người lập tờ (founder)

- `founder_user_id` = user đang login.
- `founder_member_id` = `users.member_id` của user đó.
- Bắt buộc là MWL. Không có `member_id` thì không lập tờ.
- SYSTEM_ADMIN được kê hộ kỹ thuật (đã có trên service). CLAN_ADMIN không phải MWL không lập tờ hộ.
- Founder là người chịu tờ, không bắt buộc xuất hiện trên 5 đời.

Lý do: uỷ quyền khai hộ vẫn phải là người trong họ đã bind sổ. Tài khoản rời không đứng tên tờ.

## 2.2 Người trên khung

ASSIGN / CREATE / UB trên các ô. Không cần trùng founder.
`k` chỉ có khi founder tự gán mình vào một đời (0..4). `k` null = khai hộ, founder không nằm trên khung.

Khi `k` có giá trị: dòng đó phải ASSIGN đúng `founder_member_id`. Cấm CREATE bản sao mình.
Khi `k` null: không chạy `MFO_K_MUST_ASSIGN_FOUNDER`.

## 2.3 Origin của tờ

Origin = anchor đời 0 sau khi cửa sổ đã dựng, không phải bước wizard đầu tiên.
Có thể là cụ, ông, bà, cha mẹ, chính MWL, hoặc người được khai hộ — miễn đã có trên sổ hoặc là UB do Admin tạo lúc duyệt.

# 3. Khung 5 đời (RF)

## 3.1 Vào việc

«Tạo khung dự kiến» mở ngay 5 đời rỗng. Không màn «Chọn đời gốc».
Mỗi nút là một hộ: nội tộc trái, ngoại tộc phải. Không đảo theo giới NAM/NU.

Tooltip trên ô: Không xác định (UB) · Chọn từ sổ (ASSIGN) · Tạo người · Tạo con · Tạo anh/chị/em · Xóa hộ khỏi khung.
Xóa hộ = gỡ khỏi tờ, không xóa sổ.

## 3.2 Cửa sổ quanh người được chọn

ASSIGN một người M thì BE dựng lại RF quanh M (`getFullMfoSet`):

- M đứng đúng đời k đã chọn (0..4).
- Đời trên = tổ tiên trong cửa sổ. Đời dưới = hậu duệ trong cửa sổ.
- Hết 5 đời thì cắt. Không kéo cả cây họ.
- Re-ASSIGN Origin hoặc M thì dựng lại RF. Không giữ người của gốc cũ.

## 3.3 Liên tục

Không lỗ giữa đời 0 và đời cuối đã khai.
Không bắt đủ 5 đời nếu không biết. Đời chưa đăng ký = trống; sau khi khung được duyệt thì không hiện đời không đăng ký.
UB = chỗ trống có nhãn. Chưa thành member cho đến khi Admin tạo.

## 3.4 Trình khung

Được trình khi:

- Đời 0 có anchor (ASSIGN sổ hoặc UB).
- Không EMPTY xen giữa hai đời đã có người.
- Mỗi hộ đã khai có trực hệ trái (ASSIGN | CREATE | UB).
- CREATE chưa ghi `members` trước khi khung được duyệt.

# 4. Nhiều chồng / nhiều vợ

## 4.1 Tab

Một nội tộc, nhiều tab. Mỗi tab = một `marriages.id` (một hôn phối).
Đổi tab thì đổi tập con của hộ đó. Không gộp con mọi đời vợ/chồng thành một hàng anh em.

## 4.2 parent_union_id — cầu R0, không phải SSOT lâu dài

`members.parent_union_id` nullable, trỏ `marriages.id`, ON DELETE SET NULL.

Chỉ gán khi con thuộc đúng một hôn phối ACTIVE của cặp cha–mẹ đó.
Để null khi: một cha hoặc một mẹ, UB, con riêng, nhận nuôi, hai hôn phối cùng cặp không phân được.

Không dùng cột này thay `members.child_type`.
Không dùng cột này thay `father_id` / `mother_id`.
Không suy trên FE: cấm `father_id + mother_id → marriages.id`.

Full-Set trả `marriage_tabs[]` và gán con rõ (`parent_union_id` hoặc null). FE chỉ vẽ.

`family_units` + `family_unit_children` là phase sau, khi một người cần nhiều ngữ cảnh (nhận nuôi, display) mà một union không đủ. Lúc đó `parent_union_id` thành dẫn xuất, không phải truth thứ hai.

## 4.3 Thứ anh em

Trong một tab / một hộ, thứ nhỏ đứng trái (dòng trưởng ngầm định ở cực trái).
Thứ là của hộ đang chọn, không phải `sibling_seq` toàn sổ nếu hai nguồn lệch — R0 dùng thứ BE đã sort trong Full-Set.

# 5. Hai lần trình

1. Khung dự kiến (PLAN): ý định 5 đời, ASSIGN/CREATE/UB/EMPTY. Chưa tạo member CREATE.
2. Duyệt khung: Admin chốt đời tuyệt đối Origin (`granted_generation`) và chi nếu có. Một chiều.
3. Tờ khai (RESULT): chỉ điền đời đã đăng ký trên khung đã duyệt. Tạo member / spouse trong khung. Gán `parent_union_id` khi tạo con của một hôn phối đã biết.
4. Duyệt tờ: Admin đối chiếu từng người. Không đảo tem đã đóng.

PLAN bị trả: sửa khung rồi trình lại.
RESULT bị trả: giữ tờ đã khai để sửa. Không tự huỷ người CREATE. Huỷ tờ là việc riêng, có lời xác nhận.

# 6. BE sẵn cho FE

`getFullMfoSet` là nguồn vẽ. FE không đo DOM để nối, không suy cha–con, không suy tab.

Canvas: React Flow + Dagre. Dagre chỉ tính X. Y khóa theo depth BE (0..4).
Nội trái, ngoại phải. Ô hôn phối chưa có = nét đứt «Tạo».
Đời rỗng trên RF tạo khung vẫn hiện. Sau duyệt khung, đời không đăng ký không hiện.

# 7. Khóa giữ

- A01: không sửa `users.phone` / `users.email`, `members.gender`, `members.is_alive` từ lô.
- EDITOR ≠ `users.status`. place ≠ usage.
- Không sửa `audit_logs`.
- Một member một tenant, tối đa một chi.
- Multi-home không làm.
- Chi live (CRUD + submit/approve/reject) không revert.
- UM chỉ Admin, lúc duyệt hoặc lát riêng. USER không tạo UM ở lần lập khung.

# 8. Lệch code tại 2026-10-02 (nợ, không coi là đã xong)

- `createPlan` vẫn `MFO_K_MUST_ASSIGN_FOUNDER` khi `k >= 1` — đúng nếu tự khai; phải bỏ khi `k` null.
- `OpMfoPlanPage` vẫn bắt `k` không null lúc trình.
- `normalizeCoupleForLegacyNode` vẫn đưa NAM sang trái.
- `getFullMfoSet` chưa đọc `parent_union_id`, chưa trả `marriage_tabs[]`.
- Tabs hôn phối trên card chưa có.

# 9. Câu đóng

Người lập tờ là MWL, kể cả khai hộ. MWL không bắt buộc đứng trên 5 đời.
Khung mở đủ 5 đời rỗng. Origin là anchor sau khi chọn, không phải bước đầu.
Nhiều vợ/chồng là nhiều tab. Con thuộc tab bằng `parent_union_id`, không bằng suy đoán FE.
Chi vẫn do Admin tem. Lô không sinh chi.
