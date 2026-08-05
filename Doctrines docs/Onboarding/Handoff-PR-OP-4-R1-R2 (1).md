# HandOff — EGAL / OP · PR-OP-4 R1/R2

**DATETIME:** 2026-08-05  
**SSOT:** SEC/CED/OPD + Master Plan v1.2 · **Q1/Q2**  
**Repo:** QuangAGS/cmcodes (Backend + frontend/) · Docs: QuangAGS/CM-Docs  
**STATUS:** **PASS** (smoke OK)

---

## 1. Mục tiêu phase

| Mục tiêu | Kết quả |
|----------|---------|
| **R1 — Lặp chu trình revision** | Admin “Trả về sửa” → case `NEEDS_REVISION` + note; applicant sửa → submit `isRevision` → case `SUBMITTED` lại |
| **R2 — Chấm dứt chu trình** | `TU_CHOI` ± **lần cuối** (`isFinalRejection`); final → chặn reopen |

**SSOT giữ nguyên**

- `users.status` = cổng login / quyền vận hành (Register lifecycle: `CHO_DUYET` | `DA_DUYET` | `TU_CHOI`)
- `onboarding_cases` = workflow OPD (`SUBMITTED` | `NEEDS_REVISION` | `APPROVED` | `REJECTED`)
- Không dùng `TAM_NGUNG` cho onboarding revision

---

## 2. Đã xong (không mở lại trừ regression)

### R1 — Return for revision

| Hạng mục | Chi tiết |
|----------|----------|
| BE API | `POST /api/auth/return-for-revision` |
| Service | `authService.returnForRevision` |
| Hiệu ứng | **Giữ** `users.status = CHO_DUYET`; case open → `NEEDS_REVISION` + `review_note`; BPL `action: RETURN_FOR_REVISION` |
| Authz | No self; CLAN_ADMIN phải `DA_DUYET`; cùng tenant; CreateClan/CLAN_ADMIN target → SYSTEM |
| FE Admin | Option `[BỔ SUNG] Yêu cầu bổ sung hồ sơ` → gọi return-for-revision |
| FE Applicant | Login 423 + `canEdit` chỉ khi `caseStatus === NEEDS_REVISION` + có `reviewNote` |
| Revision form | Prefill `tempSnapshot` + tenant/phone/email; khóa phone/email/tenant; `isRevision: true`; normalize string (`temp_birth_year`…) |
| Smoke | PASS — 200, case `NEEDS_REVISION`, applicant vào revision-notice → Waiting → Result |

### R2 — Final rejection

| Hạng mục | Chi tiết |
|----------|----------|
| Body | `isFinalRejection: true \| false` trên `POST /api/auth/process-approval` khi `newStatus = TU_CHOI` |
| Case metadata | `metadata.is_final_rejection`, `rejected_at`, `rejected_by` (merge prev metadata) |
| BPL | `is_final`, `action: FINAL_REJECT \| REJECT` |
| Reopen | `reopenRejectedUser` đọc case `REJECTED` mới nhất → `is_final_rejection === true` → **403** `FINAL_REJECTION` |
| FE Admin | Checkbox “Từ chối lần cuối” khi select `TU_CHOI` |
| Smoke | PASS — không final → reopen được; final → 403 |

### Ứng viên (applicant) — đã ổn từ PR-OP-3/4

- Login `CHO_DUYET` + `SUBMITTED` (chưa note) → chỉ chờ, **không** màn sửa  
- Login `CHO_DUYET` + `NEEDS_REVISION` + note → revision-notice → RegisterForm revision  
- Submit revision → case `SUBMITTED`; không JWT full  

---

## 3. Bảng chuyển trạng thái (chốt)

| Nguồn user | Action admin | users.status sau | Case sau | Ghi chú |
|------------|--------------|------------------|----------|---------|
| `CHO_DUYET` | Duyệt | `DA_DUYET` | `APPROVED` | Terminal (service thường) |
| `CHO_DUYET` | Từ chối (không final) | `TU_CHOI` | `REJECTED`, `is_final_rejection: false` | Reopen được |
| `CHO_DUYET` | Từ chối **lần cuối** | `TU_CHOI` | `REJECTED`, `is_final_rejection: true` | Reopen **DENIED** |
| `CHO_DUYET` | **Trả về sửa** | **giữ `CHO_DUYET`** | `NEEDS_REVISION` + note | R1 — lặp revision |
| `TU_CHOI` (không final) | Mở lại | `CHO_DUYET` | Case **mới** (NEEDS_REVISION + note) | Bridge / reopenRejectedUser |
| `DA_DUYET` | — | — | — | Không đổi qua form approve |

---

## 4. Path / file chính

**Backend**

- `src/modules/auth/auth.service.js` — `processUserApproval`, `returnForRevision`, `reopenRejectedUser`, login `CHO_DUYET` + `canEdit` / `tempSnapshot`
- `src/modules/auth/auth.controller.js` — `processApproval`, `returnForRevision`, `reopenRejectedUser`
- `src/modules/auth/auth.routes.js` — `POST /return-for-revision`

**Frontend**

- `src/pages/AuthPage.jsx` — revision-notice, `handleLoginSubmit` canEdit, register revision payload
- `src/context/AuthContext.jsx` — normalize `canEdit`, `reviewNote`, `tempSnapshot`
- `src/features/register-wizard/components/RegisterForm.jsx` — skip intent khi revision; `childInitialData`
- `src/features/register-wizard/components/JoinClanForm.jsx` — lock identity, normalize draft, skip uniqueness check khi revision
- `src/features/admin/components/UserApprovalForm.jsx` — options theo status; RETURN_FOR_REVISION; checkbox final
- `src/pages/AdminUserApprovalPage.jsx` — nhánh API return-for-revision / process-approval + `isFinalRejection`

---

## 5. Smoke checklist (đã PASS)

1. Đăng ký mới → `CHO_DUYET` + `SUBMITTED` → login chỉ chờ  
2. Admin **Trả về sửa** + note → login → revision-notice → sửa (≥0 field sau normalize) → Waiting → Result 200 → case `SUBMITTED`  
3. Lặp R1 thêm 1 vòng (optional)  
4. Admin **Duyệt** → `DA_DUYET` + login 200  
5. Admin **Từ chối** không final → reopen → 200  
6. Admin **Từ chối lần cuối** → reopen → **403** `FINAL_REJECTION`  

---

## 6. Không làm / đã hoãn (residual)

| Hạng mục | Ghi chú |
|----------|---------|
| Redesign Register case-centric toàn cục | Tiếp tục patch có biên giới |
| Notif một cửa (orchestrator / enum / template) | Fail-open hiện tại OK; unify sau |
| Edge: double action sau `DA_DUYET` / case lệch | Phần lớn DENIED; harden khi cần |
| Ẩn nút “Mở lại” trên Admin khi final | UX optional |
| Job SUBMITTED → UNDER_REVIEW | Hoãn |
| `TAM_NGUNG` cho revision | **Đã bác bỏ** (thuộc business vận hành) |
| OP-2 Clan activate / OP-3 state machine FE | Chưa nhảy cho đến khi phase onboarding chốt |

---

## 7. Quyết định kiến trúc đã chốt

1. **Revision ≠ đổi status user** — chỉ case `NEEDS_REVISION` + note.  
2. **Bút phê bắt buộc** mọi lần admin đổi quyết định (approve / reject / return / reopen).  
3. **`canEdit`** = `caseStatus === 'NEEDS_REVISION' && reviewNote` (không gắn mọi `CHO_DUYET`).  
4. **Final reject** lưu trên `onboarding_cases.metadata.is_final_rejection` (+ BPL audit).  
5. **Q1:** không phá login/register/approve đã PASS; endpoint R1 tách riêng.

---

## 8. Next (optional)

1. Handoff này → commit / CM-Docs  
2. (Optional) Admin UI: ẩn reopen khi final  
3. (Optional) Residual notif unify  
4. Chỉ mở **OP-2** khi product yêu cầu activate clan / tenant lifecycle tiếp  

---

**Ký hiệu:** PR-OP-4 R1/R2 · **PASS** · 2026-08-05  
**Q2:** PATH/DATETIME/VERSION trên từng file đã patch trong session; file này là HandOff tổng hợp phase.
