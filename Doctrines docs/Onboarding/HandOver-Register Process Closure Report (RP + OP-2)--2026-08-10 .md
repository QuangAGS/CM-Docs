
# HandOver — Register Process Closure Report (RP + OP-2)

**PATH**       : Doctrines docs/Onboarding/HandOver-Register-Process-Closure-2026-08-10.md  
**DATETIME**   : 2026-08-10T14:15:00+07:00  
**VERSION**    : 1.0.0  
**STATUS**     : **CLOSED** — Register Process (RP) + Tenant Activate (OP-2)  
**SSOT**       : SEC / CED / OPD · OP-Boundary-Definition-SSOT-2026-08-09 · Q1/Q2  

**REPOS:**
- Code: https://github.com/QuangAGS/cmcodes/tree/main/
- Docs: https://github.com/QuangAGS/CM-Docs/tree/main/

**Related (không lặp chi tiết):**
- `HandOver-Register-OP-Package-2026-08-09.md` (baseline RP trước OP-2)
- `OP-Boundary-Definition-SSOT-2026-08-09.md`
- `Handoff-PR-OP-4-R1-R2.md`
- `Handoff-PR-OP-4-Residual-SEC-1.1-2.x.md`

---

## 1. Mục tiêu đóng gói

Báo cáo tổng thể **Register Process (RP)** từ khởi tạo đến thời điểm hiện tại, bao gồm:

1. Phạm vi đã hoàn thành (RP core + residual + OP-2 Tenant Activate).
2. Bản đồ trạng thái cuối cùng (users / cases / tenants).
3. Đánh giá rủi ro bảo mật (Security Residual).
4. Invariants bắt buộc khi mở thread tiếp theo.
5. Việc **không** mở lại trừ regression có log + repro.

---

## 2. Phạm vi đã đóng

### 2.1 Register Process core (UAT OK — không mở lại)

| Wave | Nội dung | Status |
|------|----------|--------|
| PR-OP-1a | Register → Waiting; không JWT full; login CHO_DUYET → 423 | **Closed** |
| PR-OP-1a.1 M1 | post-TX: case SUBMITTED, BPL, audit, notif; MEMBER_JOIN / CLAN_SETUP | **Closed** |
| PR-OP-1b | `processUserApproval`: correlation, Member DU_BI, tenant CHO_DUYET→TAM_NGUNG, authz | **Closed** |
| PR-OP-4 R1 | Return-for-revision; FE note + prefill; revision submit | **Closed** |
| PR-OP-4 R2 | Reopen; final rejection; badge/label; form disable final | **Closed** |
| PR-OP-4 C1/C2 | CreateClan revision parity | **Closed** |
| Residual 1.1 | Login lock theo account (phone↔email) | **Closed** |
| Residual 2.1 | Online uniqueness phone/email fail-closed | **Closed** |
| Residual 2.2 | Revision cập nhật `tenants.description` | **Closed** |
| Residual 2.3 | Email field UI | **Closed** |

### 2.2 OP-2 — Tenant Activate (2026-08-09 → 2026-08-10)

| Hạng mục | Chi tiết | Status |
|----------|----------|--------|
| Schema | `business_process_type.TENANT_ACTIVATE` | **Done** |
| Error codes | `TENANT_ALREADY_ACTIVE`, `TENANT_NOT_ACTIVATABLE` + httpMap 409 | **Done** |
| Service | `tenant.service.js` → `activateTenant` (TX: correlation + status + BPL + audit) | **Done** |
| API | `POST /api/tenants/:id/activate` | **Done** |
| Authz | CLAN_ADMIN (own tenant + DA_DUYET) · SYSTEM_ADMIN (full) | **Done** |
| FE Work Selector | `/admin` — config-driven; SYSTEM_ADMIN list TAM_NGUNG; CLAN_ADMIN theo status | **Done** |
| FE Activate | `/admin/tenant/activate` — trang xác nhận (name + description) | **Done** |
| Post-success | **Bắt buộc logout → re-login** (JWT mới mang HOAT_DONG) | **Done** |
| BPL schema | `BusinessLogSchemas.TENANT_ACTIVATE` | **Done** |

**Smoke đã pass:**
- CLAN_ADMIN: activate → auto logout → login lại → Work Selector hiện Phê duyệt.
- SYSTEM_ADMIN: list chỉ TAM_NGUNG → xác nhận → activate → logout.
- Activate lần 2 → 409 `TENANT_ALREADY_ACTIVE`.

---

## 3. Bản đồ trạng thái cuối (SSOT vận hành)

### 3.1 users.status (auth gate)

| Status | Ý nghĩa |
|--------|---------|
| `CHO_DUYET` | Hồ sơ mở / đang revision |
| `DA_DUYET` | Đã duyệt — cổng vào hệ thống |
| `TU_CHOI` | Từ chối (± final) |
| `BI_KHOA` / `BI_CAM` | An ninh — ngoài vòng Register thường |

### 3.2 onboarding_cases

| Status tiêu biểu | Khi nào |
|------------------|---------|
| `SUBMITTED` | Sau register / sau revision |
| `NEEDS_REVISION` | Admin trả về sửa hoặc reopen |
| `APPROVED` / `REJECTED` | Đóng case |

### 3.3 tenants.status (CLAN_SETUP) — **đã cập nhật OP-2**

| Sự kiện | Tenant status |
|---------|----------------|
| CreateClan register | `CHO_DUYET` |
| SYSTEM approve CLAN_ADMIN | `TAM_NGUNG` |
| Reject / final reject | `TU_CHOI` |
| Reopen | `TU_CHOI` → `CHO_DUYET` |
| **OP-2 Activate** | **`TAM_NGUNG` → `HOAT_DONG`** |
| System tenant (SYSTEM_ADMIN) | `NGUNG_HAN` (không activate) |

### 3.4 Definition of Done theo case type (tham chiếu Boundary SSOT)

| Case type | DoD (OP đầy đủ) | RP+OP-2 đã đạt |
|-----------|-----------------|----------------|
| **CLAN_SETUP** | Tenant `HOAT_DONG` + founder role đúng | **Tenant HOAT_DONG: đạt** · Profile/member CHINH_THUC: residual OP |
| **MEMBER_JOIN** | Member `CHINH_THUC` + case `MERGED` | RP đóng ở APPROVED + Member DU_BI · Merge/CHINH_THUC: residual OP |

---

## 4. Kiến trúc FE Admin sau OP-2

| Route | Vai trò |
|-------|---------|
| `/admin` | Work Selector (SYSTEM_ADMIN / CLAN_ADMIN) |
| `/admin/tenant/activate` | Xác nhận kích hoạt (+ `?tenantId=` cho SYSTEM_ADMIN) |
| `/admin/approval` | Phê duyệt thành viên (yêu cầu tenant HOAT_DONG với CLAN_ADMIN) |

**Config mở rộng:**  
`frontend/src/features/admin/constants/adminWorkItems.js`  
→ thêm công việc mới chỉ cần thêm object (`when` theo `tenantStatus`).

**Câu chào:** `phone → email → name`.  
**Đăng xuất:** 2 vị trí (dưới chào + cuối trang).

---

## 5. Security Residual & Risk Assessment

### 5.1 Rủi ro đã kiểm soát trong RP + OP-2

| Rủi ro | Kiểm soát hiện có | Mức còn lại |
|--------|-------------------|-------------|
| Spam Register (bot Clan_join / Clan_setup) | Turnstile + rate limit + honeypot + Approval queue thủ công | **Residual vận hành** |
| CLAN_ADMIN activate tenant người khác | Service: `actor.tenantId === tenantId` + DA_DUYET | Thấp |
| MEMBER gọi activate | `checkRole` + service authz | Thấp |
| Activate khi không TAM_NGUNG | 409 ALREADY_ACTIVE / NOT_ACTIVATABLE | Thấp |
| JWT cũ sau activate | Force logout bắt buộc | Thấp |
| `GET /tenants` lộ cho non-SYSTEM | Route `checkRole(['SYSTEM_ADMIN'])` | Thấp |
| Final reject bị reopen | `is_final_rejection` block | Thấp |
| Self-approve | Authz cấm | Thấp |

### 5.2 Residual cần theo dõi (không chặn đóng gói)

| ID | Residual | Mức | Hướng xử lý đề xuất |
|----|----------|-----|---------------------|
| **SEC-R1** | Bot tạo nhiều hồ sơ CHO_DUYET (chi phí duyệt / DB) | TB | Rate limit chặt hơn theo IP+identifier; alert ngưỡng; **không** mở lại logic Register |
| **SEC-R2** | SYSTEM_ADMIN account hardening (credential, session, 2FA) | Cao (hệ thống) | Backlog bảo mật riêng — ngoài RP |
| **SEC-R3** | Production: Turnstile + rate limit phải bật trên domain thật | TB | Checklist deploy |
| **SEC-R4** | Quan sát số CreateClan/JoinClan theo IP | Thấp–TB | Log/alert — phase observability |
| **SEC-R5** | Activate ≠ Member CHINH_THUC / profile hoàn thiện | TB (nghiệp vụ) | Thuộc OP post-approval — không nhầm vào RP |

### 5.3 Smoke bảo mật tối thiểu (đã/cần xác nhận production)

- [x] CLAN_ADMIN không activate tenant khác → 403  
- [x] Activate lần 2 → 409  
- [x] Sau activate bắt buộc re-login; JWT mới `HOAT_DONG`  
- [x] Work Selector SYSTEM_ADMIN chỉ thấy TAM_NGUNG  
- [ ] Production: Turnstile + register rate limit bật (checklist deploy)  
- [ ] Production: SYSTEM_ADMIN credential không dùng default init (checklist deploy)  

---

## 6. Path / symbol SSOT code (tham chiếu nhanh)

### Backend

| Symbol | Path |
|--------|------|
| Register / Approval / Revision | `Backend/src/modules/auth/auth.service.js` |
| Auth routes | `Backend/src/modules/auth/auth.routes.js` |
| **activateTenant** | `Backend/src/modules/tenants/tenant.service.js` |
| Tenant routes + activate | `Backend/src/modules/tenants/tenant.routes.js` |
| Tenant error codes | `Backend/src/shared/errors/codes/tenant.codes.js` |
| httpMap | `Backend/src/shared/errors/httpMap.js` |
| BPL schema TENANT_ACTIVATE | `Backend/src/services/businessLogSchemas.js` |
| tenantStatus middleware | `Backend/src/middlewares/tenantStatus.middleware.js` |

### Frontend

| Symbol | Path |
|--------|------|
| Work Selector | `frontend/src/pages/AdminWorkSelectorPage.jsx` |
| Activate confirm | `frontend/src/pages/AdminTenantActivatePage.jsx` |
| Work items config | `frontend/src/features/admin/constants/adminWorkItems.js` |
| Auth redirect | `frontend/src/context/AuthContext.jsx` |
| App routes | `frontend/src/App.jsx` |
| Approval | `frontend/src/pages/AdminUserApprovalPage.jsx` |

---

## 7. Invariants Q1/Q2 (bắt buộc thread sau)

1. **Q1:** Không phá flow Register / Approval / Revision / Activate đã UAT.
2. **Q2:** Header PATH / DATETIME / VERSION / DESCRIPTION trên mọi file mới.
3. **Không gen bulk code** khi chưa confirm plan.
4. **Correlation** chỉ qua `prisma.correlation.create()`.
5. **DA_DUYET** không flip thường; final reject không reopen qua service thường.
6. **Tenant Activate** chỉ `TAM_NGUNG` → `HOAT_DONG`; sau success bắt buộc re-login.
7. **Không gộp** Tenant Activate vào `PROFILE_COMPLETED` (Boundary SSOT).
8. **Không mở lại** RP / OP-1a→1b→4 / residual 1.1/2.x trừ regression có log + repro.

---

## 8. Việc còn lại (ngoài RP — thuộc OP tiếp theo)

| ID | Hạng mục | Phase gợi ý |
|----|----------|-------------|
| OP-3+ | Member `DU_BI` → `CHINH_THUC` / hoàn thiện profile | Post-approval completion |
| OP-3+ | Merge cây (MEMBER_JOIN → MERGED) | Post-approval completion |
| — | State machine FE case-centric | Sau ổn định HOAT_DONG |
| — | Communication doctrine đầy đủ | Phase communication |
| SEC-R2 | SYSTEM_ADMIN 2FA / credential policy | Security backlog |
| SEC-R1 | Bot register observability + tighter rate limit | Security / ops residual |

---

## 9. Kết luận đóng gói

| Gói | Kết luận |
|-----|----------|
| **Register Process (RP)** | **CLOSED** — UAT OK, không mở lại trừ regression |
| **OP-2 Tenant Activate** | **CLOSED** — authz + FE + force re-login đã smoke |
| **Security** | Không có lỗ hổng chiếm quyền đã biết trong phạm vi RP+OP-2; residual bot spam và SYSTEM_ADMIN hardening ghi nhận theo dõi, **không** chặn đóng gói |
| **OP tiếp theo** | Bắt đầu từ điểm kết thúc RP+OP-2 theo `OP-Boundary-Definition-SSOT-2026-08-09.md` |

**Ngày đóng gói:** 2026-08-10  

**Người thực hiện / xác nhận:** QuangAGS · thread OP-2 + RP closure  

---

*Hết báo cáo.*
> Written with [StackEdit](https://stackedit.io/).
