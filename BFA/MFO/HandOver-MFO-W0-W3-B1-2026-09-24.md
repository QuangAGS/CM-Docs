**AMENDEMENT**

**Kế hoạch thực hiện chi tiết giai đoạn Workbench MFO (W0–W3) và ranh giới BE (B1)**

**PATH: CM-Docs / HandOver-MFO-W0-W3-B1-2026-09-24.md  ·  VERSION: 1.0.0-AMEND  ·  DATETIME: 2026-09-24T10:20+07:00**

**Tính chất: bổ sung, không thay thế. SSOT gốc vẫn hiệu lực. Phần Gemini/Perplexity chỉ được đưa vào khi đã phản biện và giữ lại.**

# **0\. Phạm vi amendement**

**Tài liệu này sửa và bổ sung ba SSOT đang đóng:**

**•**     **BFA-Branch-Family-Doctrine-v1.3.1.md — cây người trước, Chi sau.**

**•**     **BFA-MFO-Lot-Ops-v1.0.md — vận hành lô 5L, PLAN → plan\_ok → CREATE → RESULT.**

**•**     **HandOver-MFO-L1-L10-2026-09-20.md — BE L1–L10 đã xong; FE wizard còn nợ xưởng.**

**Hiện trạng khôi phục (2026-09-24): repo về đúng bản trước khi Gemini can thiệp. Không dùng hard-delete, không React Flow, không mở lại SM/RP/OP đã đóng.**

# **1\. Tôn chỉ giữ nguyên (không amend)**

**1\.**   **Q1 — bảo toàn máy live. Chi CRUD \+ duyệt giữ nguyên. Không revert tem.**

**2\.**   **Không bảng tạm / shadow. Materialize members \+ marriages sau plan\_ok.**

**3\.**   **A01 — không PATCH gender, is\_alive, users.phone/email. members.phone/email không unique.**

**4\.**   **ALS — không inject tenant vào update/findUnique. Một member ∈ một tenant, tối đa một chi.**

**5\.**   **Dòng k \= vị trí MWL/Founder. Line k bắt buộc ASSIGN đúng founder\_member\_id.**

**6\.**   **USER không POST /api/members. Tạo người chỉ POST /api/mfo/plans/:id/members.**

**7\.**   **Đồ họa 5L \= DOM \+ Tailwind \+ LaneShell \+ FanConnector \+ TreeZoomPane. Bác React Flow / D3 canvas / GoJS.**

# **2\. Phần lấy từ báo cáo Gemini (đã phản biện)**

## **2.1. Giữ — đúng hiện trạng code**

| Mục | Gemini nói | Chốt amendement |
| :---- | :---- | :---- |
| **Gãy luồng sau PLAN** | **navigate('/op') không vào xưởng** | **W0: sang /op/mfo/plans/:id** |
| **mfoApi thiếu cầu** | **Thiếu 6 lệnh workbench** | **W1: bổ sung đúng routes đã có** |
| **MyMfoPlans** | **Không CTA khi plan\_ok** | **W2: nút Vào xưởng** |
| **Payload 5 dòng** | **400 MFO\_LINES\_COUNT nếu lọc EMPTY** | **W0: sanitizeLines() luôn 5 phần tử** |
| **403 POST /members** | **USER bị chặn đúng doctrine** | **W3 chỉ gọi /mfo/plans/:id/members** |
| **IDOR listPlans** | **USER chỉ thấy lô mình** | **Không sửa** |
| **rejectResult** | **NEEDS\_REVISION, giữ người** | **Không purge khi trả sửa** |

## **2.2. Bỏ — lệch doctrine**

| Mục Gemini | Vì sao bỏ | Thay bằng |
| :---- | :---- | :---- |
| **members/marriages deleteMany** | **Phá audit, FK, Q1** | **soft-delete deleted\_at** |
| **rejectPlan UNDER\_REVIEW \+ xóa sổ** | **Trộn trả sửa và hủy dứt** | **rejectPlan chỉ PENDING; abort riêng** |
| **Purge mọi hôn nhân của member lô** | **Xóa đôi không do lô tạo** | **Chỉ created\_union\_ids \+ spouse do lô tạo** |
| **React Flow \+ Dagre** | **Trái SSOT đồ họa \+ Elder** | **DOM đã có** |
| **TanStack Query / S3 trong lát này** | **Ngoài phạm vi 5L** | **Để sau, không chặn W0–W3** |

# **3\. Mục tiêu giai đoạn này**

**Khép vòng MWL: soạn PLAN 5 dòng → Admin tem plan\_ok → MWL vào xưởng tạo người / đôi / nối founder → nộp RESULT → Admin nghiệm thu. Không đụng Chi, không đụng auth, không đụng A01.**

# **4\. Lát thực hiện**

## **W0 — Khóa payload PLAN và luồng sau submit**

**File: OpMfoPlanPage.jsx. Không đụng lane/zoom.**

**•**     **sanitizeLines(lines): luôn trả đúng 5 phần tử { line:0..4, op, member\_id|null, hint }. EMPTY giữ chỗ. Không nhét spouse vào line.**

**•**     **Body POST /api/mfo/plans: origin\_member\_id, k, mode DEPTH|WIDTH, lines\[5\], note. mode bắt buộc.**

**•**     **Line k: op=ASSIGN, member\_id \= founder (MWL). Không CREATE đời mình.**

**•**     **createPlan thành công → deleteLotDraft → navigate /op/mfo/plans/:ticketId (chưa plan\_ok thì trang chờ tem, không /op).**

**•**     **Smoke: gửi 5 lines; BE không 400 MFO\_LINES\_COUNT / MFO\_MODE / MFO\_K\_MUST\_ASSIGN\_FOUNDER.**

## **W1 — Cầu HTTP workbench**

**File: frontend/src/features/mfo/api/mfoApi.js. Chỉ bọc routes đã live.**

| Hàm FE | HTTP | Ghi chú |
| :---- | :---- | :---- |
| **createMemberInPlan(id, body)** | **POST /plans/:id/members** | **line, full\_name, gender, father/mother, link\_founder?** |
| **patchMemberInPlan(id, mid, body)** | **PATCH /plans/:id/members/:mid** | **Cấm gửi gender/is\_alive/phone/email** |
| **deleteMemberInPlan(id, mid)** | **DELETE /plans/:id/members/:mid** | **Chỉ người do lô tạo** |
| **createSpouseInPlan(id, body)** | **POST /plans/:id/spouses** | **member\_id \+ spouse\_member\_id hoặc full\_name** |
| **linkFounder(id, body)** | **PATCH /plans/:id/founder** | **father\_id | mother\_id** |
| **submitResult(id, body)** | **POST /plans/:id/result** | **note tùy chọn** |

**Không thêm abort cho đến B1. Message lỗi đi qua toMfoUserMessage — không hiện mã kỹ thuật cho elder.**

## **W2 — Cửa vào xưởng trên /op**

**File: MyMfoPlans.jsx (+ OpHubPage không đổi khung).**

**•**     **PENDING: chỉ xem tình trạng \+ voice. Không vào xưởng.**

**•**     **UNDER\_REVIEW \+ plan\_ok và chưa result\_ok: CTA «Vào xưởng kê khai» → /op/mfo/plans/:id.**

**•**     **NEEDS\_REVISION: cùng CTA, nhãn «Sửa theo ý duyệt».**

**•**     **APPROVED / REJECTED: không CTA tạo người. Nháp local xóa khi ticket không còn OPEN.**

## **W3 — Trang xưởng OpMfoWorkbenchPage**

**File mới dưới pages/, route /op/mfo/plans/:id. Tái sử dụng FamilyCoupleNode \+ FiveLineLanes \+ TreeZoomPane. Không React Flow.**

**•**     **GET /plans/:id → { ticket, tree }. Chỉ ENABLE tạo khi plan\_ok và status UNDER\_REVIEW | NEEDS\_REVISION.**

**•**     **Nút Thêm người chỉ line op=CREATE hoặc WIDTH anh/em trên line k. Body đi MFO members, không /api/members.**

**•**     **Thêm vợ/chồng → POST spouses. Nối cha/mẹ founder → PATCH founder hoặc create \+ link\_founder.**

**•**     **Nộp nghiệm thu → POST result. Sau đó khóa sửa đến khi Admin trả NEEDS\_REVISION.**

**•**     **PENDING: màn chờ «Đã gửi, chờ Ban quản trị đóng dấu». Không form tạo người.**

## **B1 — Abort \+ purge mềm (sau W3)**

**Chỉ khi W3 đứng. Không merge bản Gemini.**

**•**     **POST /api/mfo/plans/:id/abort — MWL chủ lô hoặc Admin.**

**•**     **Cho phép: PENDING, hoặc UNDER\_REVIEW chưa result\_ok.**

**•**     **Transaction: deleted\_at members trong created\_member\_ids \+ created\_spouse\_ids; marriages created\_union\_ids (ưu tiên soft; nếu schema marriages chưa có deleted\_at thì đánh status hủy \+ note, không xóa dòng sổ khác lô).**

**•**     **Gỡ father\_id/mother\_id của Founder nếu trỏ ID vừa ẩn.**

**•**     **rejectPlan giữ cho PENDING (chưa materialize) → REJECTED, plan\_ok false. Không hard delete.**

# **5\. Hợp đồng API (không đổi so với routes live)**

**Nguồn: mfo.routes.js bản L5. FE W1 bám đúng bảng này. Admin approve/reject plan \+ result đã có — FE xưởng USER không gọi approve.**

# **6\. Tiêu chí xong từng lát**

| Lát | Xong khi | Cấm |
| :---- | :---- | :---- |
| **W0** | **POST plan 5 lines \+ vào URL ticket** | **Sửa đồ họa; về /op** |
| **W1** | **6 hàm compile, body đúng A01** | **Endpoint mới** |
| **W2** | **CTA đúng trạng thái trên /op** | **Sửa Profile / Chi** |
| **W3** | **Tạo 1 người CREATE \+ nộp result không 403** | **POST /api/members** |
| **B1** | **Abort PENDING không để member ma** | **deleteMany** |

# **7\. E2E tối thiểu (sau W3)**

**8\.**   **MWL chọn Origin sổ Họ, đặt k, line k ASSIGN chính mình, gửi PLAN.**

**9\.**   **Admin approve \+ granted\_generation. Ticket UNDER\_REVIEW, plan\_ok.**

**10\.**       **MWL thấy CTA xưởng. Tạo người line CREATE, gắn spouse, nộp RESULT.**

**11\.**       **Admin result/approve → APPROVED. Cây GET /plans/:id thấy người mới. Không gọi /api/members.**

# **8\. Nợ cố ý để sau (không trong giai đoạn này)**

**Ẩn nút theo members.deleted\_at \+ policy đôi/cạnh/chức. UM Admin. Chi trên cây. Multi-home. Abort UI elder. Semantic zoom 2 mức. GFL lazy khi cây sâu.**

# **9\. Cách làm việc**

**Q1/Q2. Lát nhỏ. Không sinh mã lớn trước khi hỏi. Xuất .zip, không dán full source. W0+W1 cùng một nhịp nếu được xác nhận; W2/W3/B1 lần lượt.**

**Tài liệu này là amendement. Nếu mâu thuẫn với Doctrine v1.3.1 hoặc Lot-Ops v1.0 về A01 / tenant / không bảng tạm / không canvas — thắng thuộc SSOT gốc.**

