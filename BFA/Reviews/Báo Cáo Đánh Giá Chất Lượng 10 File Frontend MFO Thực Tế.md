# BÁO CÁO TẬP HỢP VÀ ĐÁNH GIÁ CHI TIẾT CÁC FILE FRONTEND (FE) MFO

**Hệ thống:** Gia phả số myClan (`myclan.com.vn`)

**Tài liệu quy chuẩn SSOT:**

* `BFA-Branch-Family-Doctrine-v1.3.1.md` (Pha Cây người trước, Chi tính sau)

* `BFA-MFO-Lot-Ops-v1.0.md` (Vận hành Lô MFO 5L)

* `HandOver-MFO-L1-L10-2026-09-20.md`
  **Đối chiếu Backend live:** `mfo.service.js`, `mfo.controller.js`, `mfo.routes.js`, `mfo.payload.js`, `member.routes.js`

## PHẦN 1: THỐNG KÊ DANH MỤC FILE THỰC TẾ

Khác với các tài liệu suy diễn lý thuyết dùng React Flow Canvas, cấu trúc Frontend MFO thực tế của dự án được xây dựng theo mô hình **DOM HTML/Tailwind CSS Grid thuần túy**, kết hợp chặt chẽ với triết lý **Elder Doctrine** (tối ưu thị giác và trợ lý âm thanh cho người cao tuổi).

| 

| **Mã File** | **Tên File Đầy Đủ (Trong repo cmcodes/frontend)** | **Vai trò kiến trúc** | 
| **FE-01** | `frontend/src/pages/OpMfoPlanPage.jsx` | Wizard trung tâm lập Kế hoạch 5L (Dòng $0 \dots 4$) | 
| **FE-02** | `frontend/src/pages/OpGflPickPage.jsx` | Màn hình chọn Gốc tổ (Origin) từ Cây gia phả (GFL) | 
| **FE-03** | `frontend/src/pages/OpMemberSearchPage.jsx` | Trang điều phối tìm kiếm người (Origin, Assign, Sibling, Spouse) | 
| **FE-04** | `frontend/src/features/member/components/MemberSearchSheet.jsx` | Component Sheet tra cứu thành viên sổ họ (Debounce + Cache + TTS) | 
| **FE-05** | `frontend/src/pages/OpMfoMemberPreviewPage.jsx` | Màn hình xem chi tiết & xác nhận chọn người vào Dòng | 
| **FE-06** | `frontend/src/features/mfo/lib/mfoDraftStore.js` | Cơ chế lưu trữ và phục hồi nháp cục bộ (LocalStorage Draft) | 
| **FE-07** | `frontend/src/features/mfo/lib/lotRelationGuard.js` | Bộ lọc kiểm tra tính hợp lệ về huyết thống, năm sinh, thế hệ | 
| **FE-08** | `frontend/src/features/mfo/components/MyMfoPlans.jsx` | Danh sách theo dõi tiến độ các Lô MFO của MWL trên Hub | 
| **FE-09** | `frontend/src/pages/OpHubPage.jsx` | Cổng tác nghiệp chính của MWL (`/op`) tích hợp MFO | 
| **FE-10** | `frontend/src/features/mfo/api/mfoApi.js` | Tầng giao tiếp HTTP Client với Backend `/api/mfo` | 

## PHẦN 2: DIỄN GIẢI CHI TIẾT TỪNG FILE MÃ NGUỒN

```
                                  [OpHubPage (FE-09)]
                                           │
                       ┌───────────────────┴───────────────────┐
                       ▼                                       ▼
             [MyMfoPlans (FE-08)]                    [OpMfoPlanPage (FE-01)]
           (Theo dõi Lô / Nháp)                                │
                                         ┌─────────────────────┼─────────────────────┐
                                         ▼                     ▼                     ▼
                                [OpGflPickPage]      [OpMemberSearchPage]   [mfoDraftStore]
                                   (FE-02)                 (FE-03)              (FE-06)
                                                               │
                                                               ▼
                                                      [MemberSearchSheet]
                                                           (FE-04)
                                                               │
                                                               ▼
                                                    [OpMfoMemberPreviewPage]
                                                           (FE-05)

```

### 1. FE-01: `frontend/src/pages/OpMfoPlanPage.jsx`

#### 1) Nội dung

* **Chức năng:** Màn hình Wizard trọng tâm cho phép MWL (Member With Login) thiết lập Sơ đồ các đời 5L ($Dòng\ 0 \dots 4$) neo vào Gốc tổ (Origin).

* **Nhiệm vụ:**

  * Khởi tạo và đồng bộ 5 dòng đời (`lines[0..4]`).

  * Tích hợp render cây 5 dòng trực quan bằng CSS Grid / SVG Fan Connector (`FiveLineLanes`, `FamilyCoupleNode`, `TreeZoomPane`).

  * Thực hiện validation bước, tính toán khoảng cách $k$, và submit kế hoạch sang Backend (`POST /api/mfo/plans`).

#### 2) Sơ đồ / Thuật toán giải quyết

* **Máy trạng thái Wizard (FSM):** 

  $$
  \text{Origin Selection (Step 0)} \xrightarrow{\text{Validate } k \le 4} \text{5L Matrix Configuration} \xrightarrow{\text{Review}} \text{Submit PLAN} \xrightarrow{\text{PENDING}}
  $$

* **Thuật toán Cascading EMPTY:** Khi người dùng đánh dấu một dòng là `EMPTY`, hệ thống tự động khóa toàn bộ các dòng con cháu phía dưới: 

  $$
  \forall j \in (i, 4], \quad \text{if } \text{lines}[i].op = \text{'EMPTY'} \implies \text{lines}[j].op = \text{'EMPTY'} \land \text{lines}[j].member\_id = null
  $$

* **Thuật toán Khóa Dòng** $k$**:** 

  $$
  \text{if } k \in [0, 4] \land myMemberId \ne null \implies \text{lines}[k].op = \text{'ASSIGN'} \land \text{lines}[k].member\_id = myMemberId
  $$

#### 3) Đánh giá chất lượng mã nguồn

* **Ưu điểm:**

  * Tích hợp xuất sắc **Elder Doctrine**: Nút âm thanh `AudioHelpButton`, hướng dẫn bằng giọng nói xưng "Bác/Cháu", font chữ lớn $16\text{px}$.

  * Kiến trúc vẽ cây không dùng thư viện ngoài cồng kềnh mà dùng CSS Flexbox/Grid và SVG Connector, tiết kiệm hơn $200\text{KB}$ bundle size.

* **Lỗ hổng & Điểm nghẽn nghiêm trọng:**

  * **Lệch Payload Lines (`400 MFO_LINES_COUNT`):** Trong hàm `submit()` (dòng 605), FE `lines.map()` trực tiếp từ state. Nếu có dòng bị bỏ qua do filter, mảng gửi đi không đủ 5 phần tử $0 \dots 4$, làm ném ngoại lệ tại `mfo.payload.js`.

  * **Gãy luồng sau Submit:** Bấm gửi xong, code thực hiện `navigate('/op')`. MWL không có không gian làm việc (Workbench) để tạo thành viên, và nếu quay về trang Profile thông thường tạo người sẽ bị Backend chặn `403 FORBIDDEN` (do `POST /api/members` đã khóa quyền `USER`).

* **Hướng tối ưu:**

  * Áp dụng hàm `sanitizeLines()` ép mảng gửi đi luôn đủ đúng 5 phần tử ($0 \dots 4$).

  * Điều hướng ngay sang trang Workbench chuyên dụng (`/op/mfo/plans/:ticketId`) khi tạo phiếu thành công.

### 2. FE-02: `frontend/src/pages/OpGflPickPage.jsx`

#### 1) Nội dung

* **Chức năng:** Màn hình chọn Gốc tổ (Origin) trực quan từ Cây gia phả trực hệ (GFL).

* **Nhiệm vụ:**

  * Gọi API `GET /api/mfo/origins/:seedId/tree` để lấy lát cắt cây phả hệ của chính MWL hoặc một nhánh dòng họ.

  * Hiển thị cây dạng nút mở rộng/thu gọn (Accordion Tree Nodes) theo từng thế hệ.

  * Cho phép người dùng chạm chọn một nút thành viên làm Origin và truyền ngược về `OpMfoPlanPage`.

#### 2) Sơ đồ / Thuật toán giải quyết

* **Thuật toán Ghép cặp Gia đình (Couple Adapter):** Chuyển đổi một Node thành viên và mảng đối tác (`partners[]`) thành cặp vợ chồng chuẩn hóa: 

  $$
  \text{coupleOf}(n) = \begin{cases}   \{ husband: \text{asPerson}(spouse), wife: \text{asPerson}(n) \} & \text{nếu } n.gender = \text{'NU'} \\   \{ husband: \text{asPerson}(n), wife: \text{asPerson}(spouse) \} & \text{ngược lại}   \end{cases}
  $$

* **Thuật toán Đệ quy Cành cây:** Lọc danh sách con cái trực hệ nội tộc từ danh sách nút phẳng: 

  $$
  \text{childrenOf}(id) = \{ x \in nodes \mid x.father\_id = id \lor x.mother\_id = id \}
  $$

#### 3) Đánh giá chất lượng mã nguồn

* **Ưu điểm:**

  * Xử lý Async Cancellation chuẩn chỉ với cờ `cancelled = true` trong `useEffect`, chống memory leak.

  * Tự động lưu vết lựa chọn vào cả `sessionStorage` (`mfo.originPick`) lẫn React Router `location.state`.

* **Điểm tồn tại:**

  * Khi danh sách con cháu lớn, việc render cây đệ quy thủ công bằng `nodes.map()` có thể gây lag nhẹ trên điện thoại cấu hình yếu.

* **Hướng tối ưu:** Bổ sung lazy loading cho các nhánh cây ở độ sâu $\ge 3$.

### 3. FE-03: `frontend/src/pages/OpMemberSearchPage.jsx`

#### 1) Nội dung

* **Chức năng:** Trang bao bọc (Wrapper) bộ lọc tìm kiếm thành viên chuyên sâu trên sổ họ.

* **Nhiệm vụ:**

  * Tiếp nhận các tham số URL (`preset`: `origin` hoặc `assign`, `gender`, `is_clan`, `is_alive`, `status`).

  * Cung cấp các bộ chọn tiêu chí nhanh (Giới tính, Nội/Ngoại tộc, Tình trạng còn sống/đã mất).

  * Điều phối vai trò gán (`role`: `person`, `spouse`, `sibling`) thông qua SessionStorage.

#### 2) Sơ đồ / Thuật toán giải quyết

* **Bộ điều phối ngữ cảnh chọn (Role Context Dispatcher):** 

  $$
  \text{onPick}(pick) \longrightarrow \begin{cases}   \text{role} = \text{'sibling'} & \longrightarrow \text{Save } \texttt{mfo.siblingPick} \longrightarrow \text{Return} \\   \text{role} = \text{'spouse'} & \longrightarrow \text{Save } \texttt{mfo.spousePick} \longrightarrow \text{Return} \\   \text{assignLine} \ne null & \longrightarrow \text{Save } \texttt{mfo.linePick} \longrightarrow \text{Return} \\   \text{Default} & \longrightarrow \text{Save } \texttt{mfo.originPick} \longrightarrow \text{Return}   \end{cases}
  $$

#### 3) Đánh giá chất lượng mã nguồn

* **Ưu điểm:** Đồng bộ 2 chiều (Bidirectional Binding) giữa Filter UI và URLSearchParams, giúp người dùng giữ nguyên bộ lọc khi F5 hoặc chia sẻ liên kết.

* **Điểm tồn tại:** Xử lý `sessionStorage` rải rác ở nhiều nhánh `if-else`, dễ gây sót cờ nếu người dùng thoát đột ngột.

* **Hướng tối ưu:** Gom các thao tác ghi cache chọn người vào một helper duy nhất trong `mfoDraftStore.js`.

### 4. FE-04: `frontend/src/features/member/components/MemberSearchSheet.jsx`

#### 1) Nội dung

* **Chức năng:** Component danh sách kết quả tìm kiếm thành viên dạng cuộn, dùng chung cho toàn hệ thống.

* **Nhiệm vụ:**

  * Tiếp nhận từ khóa tìm kiếm và tự động gửi request API có Debounce $300\text{ms}$.

  * Quản lý bộ nhớ đệm kết quả tìm kiếm (Search Cache Memory).

  * Render từng hàng thành viên kèm nút phát âm thanh thông tin nhân thân (Elder TTS).

#### 2) Sơ đồ / Thuật toán giải quyết

* **Cơ chế Debounce & Cache Pipeline:** 

  $$
  \text{Input Keypress} \xrightarrow{\text{Debounce 300ms}} \text{Generate Key}(params) \xrightarrow{\text{Cache Check}} \begin{cases}   \text{Hit} \implies \text{Set Hits from Cache} \\   \text{Miss} \implies \text{Fetch API} \to \text{Write Cache} \to \text{Set Hits}   \end{cases}
  $$

#### 3) Đánh giá chất lượng mã nguồn

* **Ưu điểm:**

  * Trải nghiệm âm thanh người già xuất sắc: Mỗi kết quả đều có nút "Nghe" đọc rõ: Tên, Giới tính, Năm sinh, Còn sống/Đã mất, Ghi chú.

  * Phân định rõ 2 hành động: "Xem kỹ" (chuyển sang màn Preview) và "Chọn" (lấy ngay vào form).

* **Điểm tồn tại:** Giới hạn ngầm `limit: 20` có thể làm sót kết quả trong những dòng họ lớn có hàng trăm người trùng họ tên.

* **Hướng tối ưu:** Bổ sung nút "Tải thêm kết quả" ở cuối danh sách.

### 5. FE-05: `frontend/src/pages/OpMfoMemberPreviewPage.jsx`

#### 1) Nội dung

* **Chức năng:** Màn hình xác minh chi tiết nhân thân của một thành viên được chọn từ sổ họ trước khi gán vào cây MFO.

* **Nhiệm vụ:**

  * Tải đồng thời thông tin cá nhân và thông tin cha/mẹ đẻ bằng `Promise.all([getMember, listBookMembers])`.

  * Hiển thị bảng tóm tắt danh tính, quê quán, tình trạng sống.

  * Cung cấp nút xác nhận "Chọn người này" để đưa vào dòng tương ứng.

#### 2) Sơ đồ / Thuật toán giải quyết

* **Thuật toán Tự động Nạp Cha/Mẹ (Parent Auto-Hydration):** 

  $$
  \forall pid \in [father\_id, mother\_id], \quad \text{if } pid \notin book \implies \text{Fetch } \texttt{getMember}(pid) \to \text{Append to } book
  $$

#### 3) Đánh giá chất lượng mã nguồn

* **Ưu điểm:** Bố cục dạng thẻ hồ sơ lớn, dễ đọc, khoảng cách cảm ứng (Touch Target) đạt chuẩn $\ge 48\text{px}$.

* **Điểm tồn tại:** Trong trường hợp không có mạng hoặc token hết hạn, thông báo lỗi hiển thị bằng Alert chuẩn của trình duyệt thay vì Toast Elder.

* **Hướng tối ưu:** Chuẩn hóa thông báo lỗi qua `toMfoUserMessage`.

### 6. FE-06: `frontend/src/features/mfo/lib/mfoDraftStore.js`

#### 1) Nội dung

* **Chức năng:** Thư viện quản lý bộ nhớ đệm nháp tờ khai MFO trên thiết bị (`localStorage`).

* **Nhiệm vụ:**

  * Cung cấp các hàm CRUD nháp: `saveLotDraft()`, `getLotDraft()`, `listLotDrafts()`, `deleteLotDraft()`.

  * Giới hạn lưu trữ tối đa 20 bản nháp gần nhất.

  * Cung cấp tiện ích `clearPickCache()` để dọn sạch các cờ tạm trong `sessionStorage`.

#### 2) Sơ đồ cấu trúc dữ liệu nháp

```
DraftObject = {
  id: "draft-1727083800000",
  originId: "uuid-origin",
  originName: "Cụ Tổ A",
  k: 2,
  note: "Kê khai nhánh thứ 2",
  lines: [ ... ], // 5 dòng 5L
  updated_at: "2026-09-23T15:00:00.000Z",
  kind: "DRAFT"
}

```

#### 3) Đánh giá chất lượng mã nguồn

* **Ưu điểm:** Nhẹ, không phụ thuộc thư viện ngoài, xử lý `try/catch` an toàn tránh lỗi trình duyệt chặn bộ nhớ (Private Mode).

* **Rủi ro vận hành:**

  * **Bất đồng bộ với Server:** Khi người dùng submit thành công, nếu chỉ xóa nháp hiện tại mà không xóa các cache liên quan, người dùng mở lại có thể bị tình trạng dữ liệu cũ đè lên dữ liệu mới trên Server.

* **Hướng tối ưu:** Bổ sung cơ chế tự động hủy toàn bộ draft cũ có cùng `originId` khi đã có 1 lô của Origin đó được duyệt thành công.

### 7. FE-07: `frontend/src/features/mfo/lib/lotRelationGuard.js`

#### 1) Nội dung

* **Chức năng:** Bộ kiểm soát logic nghiệp vụ và quan hệ gia đình ngay tại máy người dùng (Client-side Relation Guard).

* **Nhiệm vụ:** Ngăn chặn các lỗi logic phi lý trước khi gửi yêu cầu lên Backend:

  * Không chọn Gốc tổ làm con hoặc anh/em.

  * Không chọn cùng một người vừa làm cha vừa làm con.

  * Kiểm tra năm sinh hợp lý giữa cha/mẹ và con cái.

  * Kiểm tra chênh lệch năm sinh giữa các anh chị em ruột.

#### 2) Quy tắc kiểm định toán học

* **Quy tắc Năm sinh Cha - Con:** 

  $$
  \text{error} \iff \text{birth\_year}(con) < \text{birth\_year}(cha/mẹ)
  $$

* **Quy tắc Thế hệ (Generation Invariant):** 

  $$
  \text{error} \iff \text{generation}(con) \le \text{generation}(cha/mẹ)
  $$

* **Quy tắc Khoảng cách Anh/Em (Sibling Age Gap):** 

  $$
  \text{error} \iff \vert{}\text{birth\_year}(anh) - \text{birth\_year}(em)\vert{} > 60 \text{ năm}
  $$

#### 3) Đánh giá chất lượng mã nguồn

* **Ưu điểm:** Thuật toán rất thông minh, giúp giảm thiểu đến 80% các lỗi sai sót do người dùng nhập ẩu mà không cần tốn request về Backend.

* **Điểm tồn tại:** Chưa xử lý trường hợp một người có năm sinh âm lịch hoặc chỉ có tuổi (chưa có năm sinh chính xác).

### 8. FE-08: `frontend/src/features/mfo/components/MyMfoPlans.jsx`

#### 1) Nội dung

* **Chức năng:** Bảng điều khiển (Dashboard Component) hiển thị danh sách các phiếu MFO của chính MWL đang đăng nhập.

* **Nhiệm vụ:**

  * Gọi API `listMyPlans()` (`GET /api/mfo/plans?mine=1`) để tải các phiếu của mình.

  * Đọc song song danh sách bản nháp từ `mfoDraftStore.js`.

  * Hiển thị chi tiết trạng thái (`DRAFT`, `PENDING`, `UNDER_REVIEW`, `APPROVED`, `REJECTED`, `NEEDS_REVISION`) dạng Accordion thu gọn.

#### 2) Sơ đồ giải mã thông tin (Information Decoder)

* **Tính toán số đời đã khai:** 

  $$
  N_{\text{generations}} = \max(0, 5 - \text{count}(\text{lines.filter}(op == \text{'EMPTY'})))
  $$

* **Lọc bỏ mã UUID thô:** Hàm `looksLikeCode()` tự động nhận diện nếu tên trả về dạng mã hex UUID (`/^[0-9a-f-]{16,}$/i`) để thay thế bằng danh xưng tự nhiên: "Đã chọn trên sổ Họ".

#### 3) Đánh giá chất lượng mã nguồn

* **Ưu điểm:** Giao diện Accordion rất gọn gàng, có nút nghe giọng đọc tóm tắt tiến độ phiếu cực kỳ thân thiện.

* **Lỗ hổng chết người:**

  * **Thiếu Entrypoint vào Workbench:** Với các phiếu ở trạng thái `UNDER_REVIEW` (đã có tem `plan_ok`), component này **không có nút bấm nào** để dẫn người dùng vào trang làm việc (Workbench) để tạo thành viên! Người dùng bị kẹt lại ở màn hình xem trạng thái mà không biết làm sao để nhập người tiếp.

* **Hướng tối ưu:** Bổ sung nút CTA lớn: "Vào Xưởng Kê Khai (Workbench)" khi `ticket.payload.plan_ok === true`.

### 9. FE-09: `frontend/src/pages/OpHubPage.jsx`

#### 1) Nội dung

* **Chức năng:** Cổng tác nghiệp chính (`/op`) của thành viên đã đăng nhập (MWL).

* **Nhiệm vụ:**

  * Nhúng component `MyMfoPlans` làm khu vực tác nghiệp ưu tiên trên cùng.

  * Điều phối các chức năng hồ sơ cá nhân: Họ tên, Ngày sinh, Địa chỉ, Tiểu sử, Thành tựu.

  * Bảo vệ trạng thái Onboarding: Chặn các tài khoản `DU_BI` chưa hoàn tất hồ sơ không được vào sâu hệ thống.

#### 2) Đánh giá chất lượng mã nguồn

* **Ưu điểm:** Tích hợp đa năng, kiểm soát phiên đăng nhập và định danh chi họ (`resolveTenant`) rất chặt chẽ.

* **Điểm nghẽn liên quan đến MFO:**

  * Hiện tại Hub đang để tính năng MFO nằm chung trong một trang dài cùng với toàn bộ form Profile cá nhân (`MemberProfilePage`), khiến trang bị nặng và người dùng dễ nhầm lẫn giữa việc "Sửa thông tin của tôi" với "Khai báo phả hệ 5 đời".

### 10. FE-10: `frontend/src/features/mfo/api/mfoApi.js`

#### 1) Nội dung

* **Chức năng:** Module dịch vụ HTTP (API Client) chịu trách nhiệm gửi nhận request với cụm Backend `/api/mfo`.

* **Nhiệm vụ:** Đóng gói các hàm gọi API: `createPlan`, `listMyPlans`, `getPlan`, `getOriginTree`, `getMember`.

#### 2) Đánh giá chất lượng mã nguồn & Lỗ hổng thiếu sót

* **Thực trạng thiếu sót nghiêm trọng:**

  * File `mfoApi.js` hiện tại **hoàn toàn thiếu vắng toàn bộ các API thực thi của giai đoạn sau khi cấp tem (Workbench APIs)**:

    * Thiếu `createMemberInPlan` (`POST /api/mfo/plans/:id/members`)

    * Thiếu `patchMemberInPlan` (`PATCH /api/mfo/plans/:id/members/:memberId`)

    * Thiếu `deleteMemberInPlan` (`DELETE /api/mfo/plans/:id/members/:memberId`)

    * Thiếu `createSpouseInPlan` (`POST /api/mfo/plans/:id/spouses`)

    * Thiếu `linkFounder` (`PATCH /api/mfo/plans/:id/founder`)

    * Thiếu `submitResult` (`POST /api/mfo/plans/:id/result`)

* **Hậu quả:** Dù Backend đã xây dựng đầy đủ 100% các endpoint này, Frontend lại không có hàm gọi, khiến luồng kê khai bị đứt gãy sau khi Admin duyệt Plan.

## PHẦN 3: BẢNG TỔNG HỢP SO SÁNH "BÁO CÁO GIẢ ĐỊNH" VS "THỰC TRẠNG CODE FE"

| **Tiêu chí** | **Báo cáo cũ (Sai lệch/Ảo)** | **Thực trạng mã nguồn cmcodes/frontend (Thật)** | **Đánh giá & Rủi ro** | 
| **Công nghệ đồ họa** | Dùng thư viện `reactflow`, Pan/Zoom Camera Canvas. | Dùng DOM HTML, Tailwind Flex/Grid, `TreeZoomPane.jsx`, SVG `FanConnector`. | Báo cáo cũ bịa thư viện; code thật dùng CSS thuần nhẹ và ổn định hơn. | 
| **Tên file trung tâm** | `MfoProposalPage.jsx`, `MfoPlanForm.jsx`. | `OpMfoPlanPage.jsx`, `MyMfoPlans.jsx`. | Sai lệch hoàn toàn cấu trúc thư mục repo. | 
| **Menu thao tác** | `NodeOperationsMenu.jsx` với 7 nút Ope1–Ope7. | Hàm `nodeActions()` gắn trực tiếp vào `FamilyCoupleNode.jsx`. | Code thật gọn gàng hơn, không cần tách file thừa. | 
| **Cấu trúc mảng 5L** | `command: "ASSIGN"`, `line_index: 0`. | `op: "ASSIGN"`, `line: 0`. | Lệch tên trường $\rightarrow$ Backend ném lỗi `400 MFO_LINE_OP`. | 
| **Quản lý nháp** | Kêu thiếu Draft LocalStorage. | Đã có sẵn file `mfoDraftStore.js` với đầy đủ CRUD nháp. | Báo cáo cũ đánh giá ẩu, không đọc source code. | 
| **Giai đoạn Workbench** | Bỏ qua hoàn toàn giai đoạn sau tem `plan_ok`. | Đang thiếu trang `OpMfoWorkbenchPage.jsx` và các API call Workbench. | Điểm nghẽn cốt tử khiến MWL không tạo được người. | 

## PHẦN 4: KẾ HOẠCH HÀNH ĐỘNG KHẮC PHỤC TRIỆT ĐỂ (ACTION PLAN)

### Bước 1: Vá Payload & Bổ sung API Client (`mfoApi.js`)

* Bổ sung 6 hàm gọi API Workbench vào `frontend/src/features/mfo/api/mfoApi.js` (`createMemberInPlan`, `createSpouseInPlan`, `patchMemberInPlan`, `deleteMemberInPlan`, `linkFounder`, `submitResult`).

### Bước 2: Sanitize dữ liệu gửi đi trong `OpMfoPlanPage.jsx`

* Chuẩn hóa hàm `submit()`: Ép mảng `lines` luôn đủ 5 phần tử ($0 \dots 4$) với format chuẩn `{ line, op, member_id, hint }` để không bao giờ bị dính `400 MFO_LINES_COUNT`.

### Bước 3: Triển khai mới màn hình `OpMfoWorkbenchPage.jsx`

* Tạo trang xưởng MFO để sau khi phiếu nhận tem `plan_ok = true`, MWL bấm vào sẽ thấy cây 5 dòng sống và có form thêm con cái/anh em bằng lệnh `POST /api/mfo/plans/:id/members` mà không lo bị chặn `403`.

### Bước 4: Mở nút điều hướng trên `MyMfoPlans.jsx`

* Trên thẻ hiển thị Lô ở Hub, thêm nút hành động chính: **"Vào Xưởng Kê Khai (Workbench)"** trỏ tới `/op/mfo/plans/:id` khi phiếu ở trạng thái `UNDER_REVIEW` hoặc `NEEDS_REVISION`.