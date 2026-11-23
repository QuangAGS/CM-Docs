# IMPLEMENTATION PLAN CHI TIẾT — PHASE 2 FRONTEND (v1.8-FROZEN)

* **Dự án:** New RP&OP — Phase 2 (Frontend)
* **Mã tài liệu:** `IMPL-PLAN-FE-PHASE2-V1.9-ISO29148`
* **Ngày phê chuẩn:** `22/11/2026`
* **Lịch sử sửa đổi:**
  * `v1.9 (22/11/2026)`: Đồng bộ UAT-IMP6 (Giao diện 4 câu hỏi CLAN_SETUP, hiển thị đếm ngược Sandbox 30d/30d, xóa cản trở elder_name, 1-row layout, RulesAgreementCard).
* **Tài liệu tham chiếu:** `AMEND-RP-OP-2026-03-BASELINE (v7.1)`
* **Đồng bộ Backend:** `gia-pha-backend` (`main` @ `64876e3`)
* **Công nghệ đích:** React 18.2, Vite 5.1, JavaScript ESM (`.js` / `.jsx`), Tailwind CSS, `@tanstack/react-query`, hệ thống `elder-doctrine`.
* **Trạng thái:** `FROZEN / APPROVED FOR EXECUTION`

## 0. TRIẾT LÝ UI/UX & KIẾN TRÚC FRONTEND (`[ARCH-01]`, `[ARCH-02]`)

Các nguyên tắc sau bắt buộc tuân thủ 100%, không ngoại lệ, nhằm bảo đảm tính nhất quán trên thiết bị di động và với người cao tuổi:

1. **Mobile-First & Vùng chạm:** Ưu tiên viewport `375px`. Nút bấm tương tác có `min-height: 48px`. Form dài chia tối đa 3 bước.

2. **Elder Support (Hỗ trợ người cao tuổi & Trợ lý Giọng nói):** 
   * Về hiển thị: Font tối thiểu `16px`, ưu tiên `18px`. Contrast WCAG AA ($\ge 4.5:1$).
   * Về âm thanh (Bắt buộc): 
     * (1) Mỗi Form/Page/Nhóm công việc luôn có `AudioHelpButton` ở đầu để cung cấp mô tả tổng quan/hướng dẫn thực hiện (Online help tổng hợp). 
     * (2) Mỗi nội dung/trường nhập liệu chi tiết phải đính kèm `ZoneVoiceButton` (hoặc bọc trong `GuidedFieldWrapper`) để chỉ dẫn/thông báo tại chỗ.

3. **Cấm dùng Tooltip cho nút Disabled:** Trạng thái disabled bắt buộc dùng inline helper text (dòng giải thích trực tiếp bên dưới nút, cỡ chữ $\ge 16px$).

4. **Persistent Messages (Hợp nhất duy nhất):** Mọi thông báo nghiệp vụ (lỗi, thành công, cảnh báo) đi qua DUY NHẤT component `PersistentMessageBanner.jsx` (hỗ trợ render dạng inline hoặc modal tùy ngữ cảnh). Cấm dùng toast tự tắt.

5. **Truy vết X-Correlation-Id Toàn cục (`[ARCH-02]`):** Trên mọi thông báo lỗi từ API, `PersistentMessageBanner.jsx` bắt buộc hiển thị nhãn `"Mã tra cứu: <correlation_id>"`. **Fallback:** Nếu API không trả về header `x-correlation-id`, hiển thị mặc định `"Mã tra cứu: Không có"`.

6. **Blocking Loading Indicator Duy Nhất:** Mọi thao tác async dùng duy nhất component `BlockingLoadingOverlay.jsx`. Không dùng spinner phân mảnh.

7. **Bảo toàn Dữ liệu Form (`[ARCH-01]`):** Áp dụng cho **MỌI form** (bao gồm form User như `JoinClanForm`, `ClaimMemberWizard` và các form Admin). Khi nhận `409 LCK` hoặc `429`, giữ nguyên trạng thái text/input, chỉ tắt loading và hiện nút "Thử lại".

8. **Chống Infinite Loop Turnstile:** Tự động retry khi vượt CAPTCHA chỉ thực hiện tối đa 1 lần/request.

## 1. PHÂN LOẠI TÁC NHÂN & MÔI TRƯỜNG

| Tác nhân | Bối cảnh & Hành vi nghiệp vụ | 
| ----- | ----- | 
| **Guest (`UC-01`)** | Tra cứu dòng họ, tìm thành viên. Chịu kiểm soát tần suất IP & Turnstile Fail-Closed. | 
| **EU/EEU (`UC-02`)** | Khởi tạo hồ sơ, Claim thành viên, cam kết nội quy, Multi-Home (Bypass OTP hoàn toàn). | 
| **Beneficiary (`UC-03`)** | Người được khai hộ. Chỉ thao tác xác nhận đồng thuận qua liên kết 1 lần dùng. | 
| **Referrer (`UC-04`)** | Người bảo lãnh. Xác nhận hoặc từ chối hồ sơ xin gia nhập. | 
| **Admin/Steward (`UC-05`)** | Quản trị dòng họ. Kiểm toán nội quy/sự đồng thuận, mở khóa QA, xác minh ngoại tuyến, duyệt hồ sơ. | 

## 2. HỢP ĐỒNG API & MA TRẬN MÃ LỖI (ICD)

### 2.1. Ma trận Xử lý Mã lỗi Tự động & UX Phục hồi

| HTTP | Mã lỗi Backend (`code`) | Căn cứ | Xử lý Giao diện / Phục hồi UX | 
| ----- | ----- | ----- | ----- | 
| **`400`** | `RULES_SNAPSHOT_TOO_LONG` | `[FUNC-11]` | Chặn ở form bằng đếm ký tự $\le 30.000$. Nếu BE trả về, giữ nguyên form, báo lỗi qua Banner. | 
| **`400`** | `REFERRER_COOLDOWN_ACTIVE` | `[FUNC-09]` | Khóa thành viên trong danh sách chọn, hiện text inline: *"Đã từ chối bảo lãnh. Thử lại sau 7 ngày"*. | 
| **`400`** | `REFERRER_DECEASED` | `[FUNC-02]` | Hiện thông báo qua `PersistentMessageBanner` (modal) hồ sơ lùi về `NEEDS_REVISION`. **Gọi lại API (refetch)** làm mới UI. | 
| **`400`** | `INVALID_BENEFICIARY_TOKEN` | `[FUNC-01]` | Hiện màn hình báo mã không hợp lệ hoặc đã dùng. | 
| **`403`** | `TURNSTILE_REQUIRED` / `FAILED` | `[NFR-02]` | Bật widget Turnstile. Hoàn tất CAPTCHA -> **tự động gọi lại API (chỉ 1 lần)** kèm `X-Turnstile-Token`. | 
| **`403`** | `CLAIM_HOPPING_DETECTED` | `[NFR-03]` | Khóa nút gửi `CLAIM_EXISTING`, hiện hướng dẫn tạo hồ sơ mới (`CREATE_NEW`). | 
| **`409`** | `CONCURRENT_TRANSACTION_LOCKED` | `[ARCH-04]` | **(Keep State mọi Form)** Hiện Banner (inline) *"Hồ sơ đang được xử lý"*, kèm nút "Thử lại ngay". Không xóa form. | 
| **`409`** | `ALREADY_LINKED_TO_TENANT` | `[FUNC-06]` | Hiện nút chuyển thẳng vào không gian dòng họ. | 
| **`410`** | `BENEFICIARY_TOKEN_EXPIRED` | `[FUNC-10]` | Hiện trang *"Liên kết đã hết hiệu lực"*, ẩn mọi nút. | 
| **`423`** | `ONBOARDING_QA_LOCKED` | `[FUNC-03]` | Tắt form QA, hiện huy hiệu *"Khóa QA (3 lần sai) - Chờ Ban Quản trị"*. | 
| **`429`** | `*_RATE_LIMITED` | `[NFR-02]` | Tạm khóa ô tìm kiếm, hiện đếm ngược giây chờ. | 

## 3. NGHIỆP VỤ HIỂN THỊ ĐẶC THÙ (SPECIFIC BEHAVIORS)

1. **Hiển thị Ngoại tộc & Khóa sớm Claim (`[ARCH-03]`):** Không lọc `is_clan = false` ở client. Nếu `is_clan = false`, hiển thị nhãn (Con dâu / Con rể). Nếu `is_claimed = true`, vô hiệu hóa khối chọn kèm text inline *"Đã có tài khoản liên kết"*.

2. **Bộ đếm ký tự Nội quy (`[FUNC-11]`):** `RulesAgreementModal.jsx` phải có `<div>{rules.length}/30000</div>` và tích hợp `ZoneVoiceButton` để đọc rõ quy định. Nút submit bị khóa cứng cho đến khi tích checkbox.

3. **Đồng bộ thu hồi quyền Guardian (`[FUNC-07]`):** Chốt phương án **kết hợp**: Ưu tiên *Lazy Catch* (bắt lỗi `403` khi user bấm lưu form và tự chuyển UI sang `read-only`), đồng thời kết hợp `refetchOnWindowFocus` của react-query để tự động cập nhật mảng quyền khi user quay lại tab.

4. **Ẩn liên kết tệp tạm R2 (`[ARCH-05]`):** Tại `OpCaseDetailPage.jsx`, nếu hồ sơ `EXPIRED` hoặc `CANCELLED`, thay thế liên kết tải file bằng chữ *"Tệp minh chứng nháp đã được dọn dẹp"*.

5. **Multi-Home Bypass OTP (`[FUNC-04]`):** Điều kiện kích hoạt: `user.status === 'DA_DUYET'`. Hành vi: Giao diện **ẩn hoàn toàn bước xác thực OTP** (không render UI nhập mã), cho phép user submit yêu cầu gia nhập trực tiếp.

## 4. KẾ HOẠCH SPRINT & FILE TRIỂN KHAI

*(Lưu ý chung: Trong mọi Sprint, bất kỳ màn hình hoặc form mới nào cũng phải import và gắn `AudioHelpButton` ở góc trên, và `ZoneVoiceButton` ở từng trường nhập liệu quan trọng).*

### Sprint FE-1: Hợp đồng, Interceptor & Core Components
* `src/features/onboarding/constants/onboardingPhase2Contracts.js` (Tạo mới)
* `src/features/onboarding/constants/phase2ErrorMap.js` (Tạo mới)
* `src/components/common/PersistentMessageBanner.jsx` (Tạo mới: Hiển thị Correlation ID, xử lý fallback *"Không có"*)
* `src/components/common/BlockingLoadingOverlay.jsx` (Tạo mới: Loading duy nhất)
* `src/shared/hooks/useTurnstileFailClosed.js` (Tạo mới: Xử lý auto-retry an toàn, bắt lỗi fail CAPTCHA)
* `src/lib/apiClient.js` (Sửa đổi: Đọc `response.headers['x-correlation-id']`)

### Sprint FE-2: Tìm kiếm Công khai, Claim & Bypass OTP
* `src/features/register-wizard/components/JoinClanForm.jsx` (Sửa đổi: Gắn Turnstile, khóa `is_claimed`, ẩn UI bước OTP khi `user.status === 'DA_DUYET'`, thêm trợ lý giọng nói)
* `src/features/membership/components/ClaimMemberWizard.jsx` (Sửa đổi: Khóa QA `423`, Cooldown 7d, Ngắt mạch `403`, Keep State, thêm trợ lý giọng nói)
* `src/features/member/components/MemberSearchSheet.jsx` (Sửa đổi: Xử lý `429`)

### Sprint FE-3: Cam kết Nội quy, Đồng thuận Người thụ hưởng
* `src/features/onboarding/components/RulesAgreementModal.jsx` (Tạo mới: Đếm $\le 30.000$, gắn `ZoneVoiceButton`)
* `src/pages/BeneficiaryConsentPage.jsx` (Tạo mới: Xử lý `410 Gone`, gắn `AudioHelpButton`)
* `src/App.jsx` (Sửa đổi: Đăng ký route)
* `src/features/membership/components/HeaderClanSwitcher.jsx` (Sửa đổi: Đồng bộ `is_default`)

### Sprint FE-4: Bàn làm việc Quản trị & Ngoại lệ
* `src/pages/OpCaseDetailPage.jsx` (Sửa đổi: Ẩn tệp R2 khi `EXPIRED`, hiện Checksum Nội quy, gắn giọng nói cho Admin)
* `src/features/admin/components/OpApprovalPanel.jsx` (Sửa đổi: Bắt `400` REFERRER_DECEASED, gọi lại API refetch)
* `src/features/admin/components/ApprovalCenter.jsx` (Sửa đổi: Cảnh báo Khóa QA, Bắt `409 LCK` giữ form state)

## 5. MA TRẬN TRUY VẾT HAI CHIỀU (BIDIRECTIONAL TRACEABILITY)

| Baseline REQ | Chức năng FE | Tệp thực thi trên `gia-pha-frontend` | Kịch bản kiểm thử | 
| ----- | ----- | ----- | ----- | 
| `[FUNC-01]` | Đồng thuận thụ hưởng | `BeneficiaryConsentPage.jsx` | `TC-FE-01` | 
| `[FUNC-02]` | Ngoại lệ bảo lãnh chết | `OpApprovalPanel.jsx` | `TC-FE-02` | 
| `[FUNC-03]` | QA Lock 3 lần sai | `ClaimMemberWizard.jsx`, `ApprovalCenter.jsx` | `TC-FE-03` | 
| `[FUNC-04]` | Phân luồng & **Bypass OTP** | `JoinClanForm.jsx` | `TC-FE-04` | 
| `[FUNC-05]` | Dòng họ mặc định | `HeaderClanSwitcher.jsx` | `TC-FE-05` | 
| `[FUNC-06]` | Chặn UPSERT liên kết | `ClaimMemberWizard.jsx` (Lỗi 409) | `TC-FE-06` | 
| `[FUNC-07]` | Thu hồi Guardian | `MembershipStatusPage.jsx` | `TC-FE-07` | 
| `[FUNC-08]` | Ghi log Correlation ID | `apiClient.js`, `PersistentMessageBanner.jsx` | `TC-FE-08` | 
| `[FUNC-09]` | Cooldown bảo lãnh 7d | `ClaimMemberWizard.jsx` | `TC-FE-09` | 
| `[FUNC-10]` | Token hết hạn / 410 | `BeneficiaryConsentPage.jsx` | `TC-FE-10` | 
| `[FUNC-11]` | Nội quy & Checksum | `RulesAgreementModal.jsx`, `OpCaseDetailPage.jsx` | `TC-FE-11` | 
| `[NFR-02]` | Turnstile / Rate Limit | `useTurnstileFailClosed.js` | `TC-FE-12` | 
| `[NFR-03]` | Claim-Hopping 90d | `ClaimMemberWizard.jsx` | `TC-FE-13` | 
| `[ARCH-01]` | **Bảo toàn form 409** | **Tất cả các Forms (User, Admin)** | `TC-FE-14` | 
| `[ARCH-02]` | **X-Correlation-Id** | `apiClient.js`, `PersistentMessageBanner.jsx` | `TC-FE-08` | 
| `[ARCH-03]` | Hiện ngoại tộc / Khóa | `JoinClanForm.jsx` | `TC-FE-15` | 
| `[ARCH-04]` | Khóa trùng (409) | `BlockingLoadingOverlay.jsx`, `ApprovalCenter.jsx` | `TC-FE-14` | 
| `[ARCH-05]` | Ẩn R2 Staging Link | `OpCaseDetailPage.jsx` | `TC-FE-16` | 
| `[ARCH-06]` | 3 khóa Metadata | `onboardingPhase2Contracts.js` | `TC-FE-17` | 
| `[NFR-FE-02]` | **Voice Assist (Elder)** | **Tất cả các màn hình Phase 2** | `TC-FE-18` |
| `[ARCH-06]` | **Sandbox 30d/30d** | `AdminTenantDirectoryPage.jsx` | `TC-FE-19` |

## 6. KỊCH BẢN KIỂM CHỨNG (ACCEPTANCE CRITERIA)

 1. **TC-FE-01 (Beneficiary 410):** *Given* hồ sơ đã `APPROVED`, *When* người thụ hưởng mở link consent, *Then* trang hiện "Liên kết hết hiệu lực" và ẩn mọi nút bấm.
 2. **TC-FE-02 (Referrer Deceased 400):** *Given* Admin bấm Duyệt, API báo `400 REFERRER_DECEASED`, *When* thông báo trả về, *Then* UI hiện `PersistentMessageBanner` (dạng modal) "Hồ sơ lùi về NEEDS_REVISION", và **gọi lại API (refetch qua react-query)** để cập nhật UI, không reload toàn trang.
 3. **TC-FE-03 (QA Locked 423):** *Given* User nhập sai QA 3 lần, *When* nhận `423 ONBOARDING_QA_LOCKED`, *Then* form trả lời tắt, hiện huy hiệu "Chờ duyệt thủ công".
 4. **TC-FE-04 (Multi-Home Bypass OTP):** *Given* User có `user.status === 'DA_DUYET'` chọn Gia nhập họ có sẵn, *When* ấn tạo hồ sơ, *Then* UI **ẩn hoàn toàn bước xác thực số điện thoại OTP** và cho submit trực tiếp.
 5. **TC-FE-07 (Guardian Read-Only):** *Given* User giám hộ đang mở cây, *When* quyền bị thu hồi, *Then* nếu bấm lưu -> dính `Lazy Catch 403` UI tự chuyển `read-only`; hoặc nếu user chuyển tab quay lại -> `refetchOnWindowFocus` cập nhật mảng quyền và chuyển `read-only`.
 6. **TC-FE-08 (Correlation-Id Trace & Fallback):**
    * *Scenario 1:* *Given* lỗi API có header, *Then* `PersistentMessageBanner` hiện `"Mã tra cứu: <correlation_id>"`.
    * *Scenario 2:* *Given* lỗi API KHÔNG có header, *Then* `PersistentMessageBanner` hiện `"Mã tra cứu: Không có"`.
 7. **TC-FE-09 (Cooldown 7d 400):** *Given* User chọn người bảo lãnh bị cooldown, *Then* nút chọn bị `disabled`, có chữ *inline helper text* "Thử lại sau 7 ngày" ngay bên dưới. Không dùng tooltip.
 8. **TC-FE-11 (Rules** $\le 30.000$**):** *Given* User dán $30.001$ ký tự vào popup, *Then* bộ đếm báo đỏ, nút Submit khóa cứng.
 9. **TC-FE-12 (Turnstile Auto-Retry & Fail):**
    * *Scenario 1 (Success):* *Given* BE tắt Redis, *When* User tìm kiếm, *Then* Turnstile hiện ra. Sau khi tick xanh, request **tự động gọi lại API tối đa 1 lần**.
    * *Scenario 2 (Fail):* *Given* xác thực Turnstile thất bại, *Then* hiển thị lỗi qua `PersistentMessageBanner`, widget Turnstile tự động reset, và KHÔNG auto-retry API.
10. **TC-FE-13 (Claim Hopping 403):** *Given* User bị từ chối 2 lần trong 90 ngày, *When* gửi `CLAIM_EXISTING`, *Then* hiện thông báo chặn qua Banner và gợi ý tạo `CREATE_NEW`.
11. **TC-FE-14 (Keep State 409):** *Given* User/Admin đang điền Form (ở bất kỳ màn hình nào) và bấm Submit, *When* nhận `409 LCK`, *Then* `BlockingLoadingOverlay` biến mất, **form vẫn giữ nguyên text vừa nhập**, hiện Banner báo lỗi kèm nút "Thử lại".
12. **TC-FE-15 (Con rể/Con dâu Claim):** *Given* API `claim-search` trả về người `is_clan=false` và `is_claimed=true`, *Then* hiện nhãn "Con dâu" và text inline "Đã có tài khoản", nút chọn bị khóa cứng.
13. **TC-FE-16 (Hide R2 Links):** *Given* hồ sơ `EXPIRED`, *When* Admin mở chi tiết, *Then* nút tải File bị ẩn đi, thay bằng text "Tệp nháp đã bị xóa".
14. **TC-FE-18 (Voice Assist - Elder Doctrine):** *Given* User ở bất kỳ form/page nào của Phase 2, *When* bấm vào `AudioHelpButton` ở header hoặc `ZoneVoiceButton` ở trường nhập liệu, *Then* hệ thống phát âm thanh hướng dẫn chính xác thông qua `TtsContext` mà không ảnh hưởng tới state của form.
15. **TC-FE-19 (Sandbox Lifecycle UAT-IMP6):** *Given* Admin vào danh bạ dòng họ, *When* lọc Sandbox, *Then* hiển thị rõ huy hiệu "Đang dựng cây (Sandbox)", số ngày còn lại (hoặc số ngày chờ dọn dẹp `TAM_NGUNG`).