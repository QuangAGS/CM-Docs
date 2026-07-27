# **TÀI LIỆU TÓM TẮT THỰC HIỆN — WAVE 3 (v1.1 — phản biện tích hợp)**

Tenant gate \+ OPD policy

Master Plan v1.2.0 · Q1/Q2 · SSOT: SEC v1.1 · CED v1.1 · OPD v1.2

---

# Bối cảnh

|  |  |
| ----- | ----- |
| Wave trước | W2 DONE (Assert Order, requireActiveTenant, dual-contract) |
| Mục tiêu W3 | Formalize tenant status gate Light/Heavy, pipeline doc, onboarding policy wrappers, members filter có override Admin, CED-4 shared errors |
| Không làm trong W3 | Full lock/token extract (residual W2), rate/turnstile mở rộng (W4), notif worker SKIP LOCKED (W4), delegation (W5) |

---

# Bảng bước thực hiện (đã chỉnh theo phản biện)

| \# | Bước thực hiện | Đầu ra (path / files / codes) | Loại đầu ra | Ghi chú / giải thích |
| ----- | ----- | ----- | ----- | ----- |
| W3.0 | Baseline review as-is | — | Kiểm tra | Xác nhận pipeline W1/W2; requireActiveTenant hiện có; onboarding magic strings; members list filter hiện tại |
| W3.1 | Tạo tenantStatus.middleware.js L3 | src/middlewares/tenantStatus.middleware.js | Tạo mới | Light / Heavy modes. SYSTEM\_ADMIN: bypass chỉ kiểm tra khóa/chờ duyệt tenant; vẫn resolve & gán tenant context nếu có x-tenant-slug / tenant\_id param (không bỏ context). Non-admin: đọc req.user.tenantStatus. next(err) CED dual-contract. Codes: TENANT\_NOT\_ACTIVATED, TENANT\_DISABLED, TENANT\_PENDING\_ACTIVATION (+ optional TENANT\_SUSPENDED). CorrelationId: lỗi bắt buộc mang correlationId (body \+ log) — kế thừa req.correlationId từ W1.0 |
| W3.2 | Wire middleware \+ Onboarding whitelist | auth.routes.js, onboarding.routes.js, optional members | Nâng cấp | Heavy trên admin approve/query nghiệp vụ. Ngoại lệ (Whitelist): CLAN\_ADMIN \+ tenant TAM\_NGUNG được phép route Onboarding kích hoạt/cấu hình dòng họ (HTTP 200\) — không gắn Heavy chặn. USER/GUEST \+ TAM\_NGUNG trên API nghiệp vụ thường → 403 TENANT\_NOT\_ACTIVATED / TENANT\_SUSPENDED. Login/register public: không gắn Heavy |
| W3.3 | Đồng bộ requireActiveTenant | role.middleware.js, auth.middleware.js | Nâng cấp | Option A (khuyến nghị): requireActiveTenant \= alias tenantStatus({ mode: 'heavy' }) \+ giữ export Q1. Phân biệt whitelist onboarding vs heavy auth admin |
| W3.4 | Document pipeline | Doc / Handoff-W3 | Tạo mới | Chuỗi: correlation → slug/tenantContext → verifyToken → checkRole → tenantStatus(Light|Heavy|whitelist) → handler. Ghi rõ route Light / Heavy / Onboarding-exempt |
| W3.5 | Onboarding service → policy wrappers | onboarding.service.js (+ optional policy.service.js skeleton) | Nâng cấp | \_assert\* → policy wrappers; Q1 giữ tên hàm public; status constants từ shared codes |
| W3.6 | Members filter CHINH\_THUC \+ Admin override | member.service.js / list routes | Nâng cấp | Mặc định member\_status \= CHINH\_THUC cho user thường / xem công khai. Admin/Editor: cho phép override qua query (status=DU\_BI, status=ALL, hoặc includePending=true) để không gãy phê duyệt DU\_BI |
| W3.7 | CED-4 shared errors only | onboarding service/controller | Nâng cấp | Chỉ createError / AppError / codes từ shared/errors |
| W3.8 | Smoke \+ Exit W3 | Thunder/curl matrix | Test | Xem bảng Exit bên dưới |
| W3.9 | Handoff-W3 | docs/handoffs/Handoff-W3.md | Tạo mới | Q2: done / residual / next / SHAs / doctrine pins |

---

# Ma trận Tenant gate (chốt phản biện)

| Actor | Tenant status | Route loại | Kết quả |
| ----- | ----- | ----- | ----- |
| SYSTEM\_ADMIN | bất kỳ | global / tenant-scoped | Bypass status check; vẫn gán context nếu có slug/id |
| CLAN\_ADMIN | TAM\_NGUNG | Onboarding kích hoạt / cấu hình clan | 200 (whitelist) |
| CLAN\_ADMIN | TAM\_NGUNG | Approve / query-reviewable / nghiệp vụ thường | 403 TENANT\_NOT\_ACTIVATED |
| CLAN\_ADMIN | HOAT\_DONG | Admin nghiệp vụ | 200 |
| USER / GUEST | TAM\_NGUNG | Nghiệp vụ thường | 403 |
| Bất kỳ (non-SYS) | BI\_KHOA | Light \+ Heavy | 403 TENANT\_DISABLED |

---

# PR chain W3 (đã bổ sung ý members)

| PR | Nội dung |
| ----- | ----- |
| PR-W3-1 | feat(tenant-status-mw): Light/Heavy \+ SYS\_ADMIN bypass-status-but-keep-context \+ correlationId on errors |
| PR-W3-2 | feat(wire-tenant-status): routes \+ Onboarding whitelist TAM\_NGUNG \+ alias requireActiveTenant |
| PR-W3-3 | refactor(onboarding-policy): wrappers \+ CED-4 |
| PR-W3-4 | fix(members-filter): default CHINH\_THUC \+ Admin override (status / includePending) |
| PR-W3-5 | docs(pipeline \+ Handoff-W3) |

---

# Exit Criteria W3 (bổ sung correlation)

| Case | Kỳ vọng |
| ----- | ----- |
| SYSTEM\_ADMIN \+ slug tenant | Status check bypass; context vẫn gán nếu có slug |
| CLAN\_ADMIN \+ TAM\_NGUNG → Onboarding activate/config | 200 |
| CLAN\_ADMIN \+ TAM\_NGUNG → query/approve | 403 TENANT\_NOT\_ACTIVATED \+ correlationId body |
| CLAN\_ADMIN \+ HOAT\_DONG → query | 200 |
| USER \+ tenant TAM\_NGUNG → nghiệp vụ | 403 |
| Cross-tenant | 403 dual-contract |
| Members list (user thường) | chỉ CHINH\_THUC |
| Members list Admin status=ALL / includePending=true | gồm DU\_BI |
| Mọi lỗi từ tenantStatus middleware | correlationId trên body (+ log qua Global Handler) |
| Login regression W2 | Assert Order không regress |

---

# Rủi ro & giảm thiểu (cập nhật)

| Rủi ro | Giảm thiểu |
| ----- | ----- |
| Heavy chặn Onboarding TAM\_NGUNG | Whitelist route Onboarding activate/config (W3.2) |
| Members filter gãy Admin duyệt DU\_BI | Override param Admin (W3.6) |
| SYSTEM\_ADMIN mất tenant context | Bypass status only, vẫn resolve slug/id (W3.1) |
| Mất correlationId trên gate mới | next(err) \+ err.correlationId \= req.correlationId; Exit bắt buộc (W3.8) |
| Public route bị Heavy | Chỉ mount admin / tenant-scoped documented |

---

# Residual sau W3

* Full lock.service / token.service extract  
* FE audio recovery  
* W4 rate / turnstile / PENDING SKIP LOCKED

#  

# **TÀI LIỆU TÓM TẮT THỰC HIỆN — WAVE 3**

Tenant gate \+ OPD policy  
Master Plan v1.2.0 · Q1/Q2 · SSOT: SEC v1.1 · CED v1.1 · OPD v1.2

# BỐI CẢNH

| Wave trước | W2 DONE (Assert Order inline, `requireActiveTenant`, dual-contract edges) |
| :---- | :---- |
| **Mục tiêu W3** | Chuẩn hóa **tenant status gate** (Light/Heavy), pipeline document, onboarding policy wrappers, members filter `CHINH_THUC`, CED-4 pure shared errors |
| **Không làm trong W3** | Extract full lock/token (residual W2 optional), rate/turnstile mở rộng (W4), notif worker SKIP LOCKED (W4), delegation (W5) |

# Bảng bước thực hiện

| \# | Bước thực hiện | Đầu ra (path / files / codes) | Loại đầu ra | Ghi chú / giải thích |
| ----- | ----- | ----- | ----- | ----- |
| **W3.0** | Baseline review as-is | — | Kiểm tra | Xác nhận: `requireActiveTenant` (W2), pipeline `correlation → tenant slug → verifyToken → checkRole`; chưa có `tenantStatus.middleware.js` formal L3; onboarding còn magic status strings |
| **W3.1** | Tạo `tenantStatus.middleware.js` L3 | `src/middlewares/tenantStatus.middleware.js` | **Tạo mới** | **Light**: chặn tenant `BI_KHOA` / thiếu context trên route tenant-scoped. **Heavy**: chặn `CHO_DUYET`/`TAM_NGUNG`/`BI_KHOA` cho admin approve/query (thay hoặc bọc `requireActiveTenant`). SYSTEM\_ADMIN bypass. Codes: `TENANT_NOT_ACTIVATED`, `TENANT_DISABLED`, `TENANT_PENDING_ACTIVATION` dual-contract qua `next(err)` |
| **W3.2** | Wire middleware vào routes | `auth.routes.js`, `onboarding.routes.js`, (optional) `member.routes.js` | **Nâng cấp** | Auth admin: `verifyToken → checkRole → tenantStatus({ mode: 'heavy' })`. Onboarding admin heavy tương tự. Member list: light hoặc heavy theo SEC. **Không** gắn heavy lên login/register public |
| **W3.3** | Đồng bộ / deprecate `requireActiveTenant` | `role.middleware.js`, `auth.middleware.js` | **Nâng cấp** | Option A: `requireActiveTenant` \= alias gọi `tenantStatus({ mode: 'heavy' })`. Option B: thay dần caller sang `tenantStatusHeavy`. Q1: giữ export `requireActiveTenant` nếu FE/route đang import |
| **W3.4** | Document pipeline | `docs/` hoặc README middleware / Handoff-W3 | **Tạo mới / Doc** | Chuỗi chuẩn: `correlation → slug/tenantContext → verifyToken → checkRole/account → tenantStatus(Light|Heavy) → handler`. Ghi rõ route nào Light / Heavy |
| **W3.5** | Onboarding service → policy wrappers | `onboarding.service.js` (+ optional `services/policy.service.js` skeleton) | **Nâng cấp** (+ optional tạo mới) | `_assertActorUsable` / tenant checks → gọi `policy.assertAccountUsable` / `assertTenantAccess` (Q1 **giữ tên hàm** public service nếu đã có). Magic strings status → constants từ shared codes hoặc policy |
| **W3.6** | Members default filter `CHINH_THUC` | `member.service.js` / list query liên quan | **Nâng cấp** | SEC L6: list mặc định chỉ member chính thức; không trả nhầm DU\_BI / provisional trừ khi filter explicit |
| **W3.7** | CED-4: onboarding chỉ shared errors | `onboarding.service.js`, `onboarding.controller.js` | **Nâng cấp** | Chỉ `createError` / `AppError` / codes từ `shared/errors`. Không import `auth/core` (đã xóa) hay error factory local |
| **W3.8** | Smoke \+ Exit W3 | Thunder/curl matrix | **Test** | Cross-tenant 403; CLAN\_ADMIN \+ TAM\_NGUNG → 403 `TENANT_NOT_ACTIVATED`; HOAT\_DONG OK; members default filter; dual-contract correlationId |
| **W3.9** | Handoff-W3 | `docs/handoffs/Handoff-W3.md` | **Tạo mới** | Q2: done / residual / next / SHAs / doctrine pins |

### **PR chain gợi ý (W3)**

| PR | Nội dung |
| ----- | ----- |
| **PR-W3-1** | feat(tenant-status-mw): tenantStatus.middleware.js Light/Heavy \+ next(err) |
| **PR-W3-2** | feat(wire-tenant-status): gắn routes auth/onboarding admin; alias requireActiveTenant |
| **PR-W3-3** | refactor(onboarding-policy): wrappers \+ CED-4 shared only |
| **PR-W3-4** | fix(members-filter): default CHINH\_THUC |
| **PR-W3-5** | docs(pipeline \+ Handoff-W3) |

---

### **Exit Criteria W3**

| Case | Kỳ vọng |
| ----- | ----- |
| Cross-tenant access | **403** (code ổn định, dual-contract) |
| CLAN\_ADMIN \+ tenant TAM\_NGUNG → query/approve | **403** TENANT\_NOT\_ACTIVATED |
| CLAN\_ADMIN \+ tenant HOAT\_DONG | **200** |
| SYSTEM\_ADMIN | bypass tenant gate |
| Members list (no filter) | chỉ CHINH\_THUC (hoặc tương đương documented) |
| Onboarding throw | chỉ shared createError / AppError; có correlationId |
| Login regression | W2 Assert Order **không regress** |

---

### **Rủi ro & giảm thiểu**

| Rủi ro | Giảm thiểu |
| ----- | ----- |
| Heavy gate chặn nhầm route public | Chỉ mount trên admin / tenant-scoped; không login/register |
| Đổi behavior requireActiveTenant | Alias hoặc giữ signature; smoke Approval |
| Policy extract quá sớm (W2 residual) | W3 chỉ skeleton/wrapper cần thiết; full lock/token optional backlog |
| Members filter breaking UI | Confirm enum CHINH\_THUC vs status hiện tại schema trước khi filter |

---

### **Residual sau W3 (không thuộc scope)**

* Full lock.service / token.service extract (W2 plan partial)  
* FE audio recovery  
* W4: rate/turnstile mở rộng, PENDING worker SKIP LOCKED

