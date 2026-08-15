# **HANDOVER — Close C6 / Open Next Thread**

| Field | Value |
| ----- | ----- |
| Document ID | HandOver-Close-C6-Next-Thread-2026-08-15 |
| Version | 1.0.0 |
| Date | 2026-08-15 |
| Status | C6 CLOSED — ready for new conversation |
| Repos (SSOT code/docs) | [https://github.com/QuangAGS/cmcodes/tree/main](https://github.com/QuangAGS/cmcodes/tree/main) |
|  | [https://github.com/QuangAGS/CM-Docs/tree/main](https://github.com/QuangAGS/CM-Docs/tree/main) |
| Principles | SSOT \+ **Q1** (bảo toàn) \+ **Q2** (doc format) |
| Language | Technical: VI; security/checklist: EN khi cần |

---

## **1\. Bối cảnh sản phẩm**

* **Gia Phả Số 2026** / domain `myclan.com.vn`  
* Stack: React FE, Node/Express BE, Prisma \+ Supabase, Cloudflare  
* **RP (Register Process) \+ OP-2: CLOSED** — không mở lại trừ regression có log \+ repro  
* Boundary SSOT: `OP-Boundary-Definition-SSOT-2026-08-09`  
* RP Closure: `HandOver-Register-Process-Closure-2026-08-10`  
* **Direction A (đã chọn):** Member `DU_BI` → `CHINH_THUC` / hoàn thiện Base Profile

---

## **2\. Đã hoàn thành (không làm lại)**

### **2.1 Framework & OP core**

| \# | Việc | Status |
| ----- | ----- | ----- |
| SRPF Phase 3 | load+TX, BPL+audit, CED, Communication, apply, MEMBER\_PROMOTE def | DONE |
| **C1** | Register-to-OP-Handoff-Contract v1.0 SSOT | DONE (CM-Docs) |
| **C2** | `openMemberPromoteInstance` (idempotent, DRAFT, C mới) | DONE |
| **C3** | `processUserApproval` DA\_DUYET → open OP (cùng TX) | DONE |
| **C4** | OP DRAFT → SUBMIT (+ BPL \+ notif) | DONE |
| **C5** | START\_REVIEW → APPROVE → `CHINH_THUC` | DONE |
| **C6** | Move OP realization → `modules/onboarding/srpf` | DONE \+ HandOff C6 |

### **2.2 E2E đã chứng minh trên DB**

* **MEMBER\_JOIN:** full path promote \+ warn generation  
* **CLAN\_SETUP:** Register → identity approve (tenant **TAM\_NGUNG**) → OP DRAFT → SUBMIT → REVIEW → APPROVE → `CHINH_THUC`; BP gate (`birth_*`, `generation>=1`) đúng

### **2.3 Tài liệu then chốt (CM-Docs)**

* `Doctrines docs/Onboarding/Register-to-OP-Handoff-Contract-2026-08-13.md`  
* `Doctrines docs/Onboarding/HandOff-C6-OP-SRPF-Move-Correlation-2026-08-15.md` (nếu đã upload; nội dung full đã soạn)  
* SRPF v1.0 Final \+ Architecture Overview (CM-Docs / Frameworks)  
* RP Closure 2026-08-10

---

## **3\. Kiến trúc hiện tại (sau C6)**

### **Shared — engine only**

```

Backend/src/shared/frameworks/srpf/
  engine/, guards/, ledger/, communication/, storage/, registry/, constants/, errors/
  index.js  v0.8.1-C6  — KHÔNG auto-register MEMBER_PROMOTE
```

### **Onboarding — OP realization**

**text**

```
Backend/src/modules/onboarding/srpf/
  index.js                      # barrel
  registerMemberPromote.js      # idempotent register
  definitions/MemberPromote.definition.js
  services/openMemberPromoteInstance.js
```

Bootstrap: require('./srpf').registerMemberPromote() trong onboarding routes (hoặc app).  
Tests: tự gọi registerMemberPromote() trước executeAction.

Auth C3: openMemberPromoteInstance từ modules/onboarding/srpf.

---

## **4\. Contract nghiệp vụ (giữ nguyên)**

| Chủ đề | Quyết định |
| ----- | ----- |
| **RP đóng** | Case RP APPROVED \= terminal; không reopen cho OP |
| **OP** | Instance mới \+ correlation\_id mới |
| **Trigger** | Mỗi create member DU\_BI → open OP DRAFT |
| **Quyền** | A tạo DU\_BI · B mở instance · C USER draft/submit, Admin review/approve |
| **BP hard (APPROVE)** | full\_name, gender, is\_alive, birth\_year, birth\_month, birth\_day |
| **generation** | ≥1 bắt buộc CLAN\_SETUP; JOIN strongly recommended (warn) |
| **Side-effect APPROVE** | members.status \= CHINH\_THUC only — không auto CLAN\_ADMIN, không auto tenant HOAT\_DONG |
| **Notif** | Map MEMBER\_PROMOTE\_\* → enum ONBOARDING\_\* |
| **Audit** | THEM\_MOI|CAP\_NHAT|XOA; changed\_by \= UUID user |

---

## **5\. Correlation control (C) — SSOT vận hành**

| Lớp | Ý nghĩa | Bảng |
| ----- | ----- | ----- |
| C-root | Một process instance | onboarding\_cases.correlation\_id (không đổi theo action) |
| C-action | Một hành động | BPL, notifications, audit\_logs |

**text**

```
C1  Register root (case RP)
C_a USER_APPROVAL (BPL/audit — không phải root case)
C_op OP root (case OP mới)
C_s SUBMIT | C_r START_REVIEW | C_p APPROVE  → chỉ ledger/notif
```

**Cấm:** query case bằng C-action; reuse C1/C\_a làm root OP; UPDATE RP APPROVED → NEEDS\_REVISION.

Ví dụ đã verify (CLAN\_SETUP Đỗ Văn A): C1 b6cf9e31-…, C\_a 9b0ee839-…, C\_op 45ecbe1e-…, C\_s 82d248af-…, C\_r 8700ccf9-…, C\_p fae70533-….

---

## **6\. Test scripts (sau C6)**

**text**

```
src/tests/test-srpf-c6-smoke.js
src/tests/test-srpf-c6-open.js
src/tests/test-srpf-c6-submit-once.js
src/tests/test-srpf-c6-approve.js
```

**Mỗi script tự registerMemberPromote().**

---

## **7\. Nợ kỹ thuật / polish (không chặn đóng C6)**

| Mục | Ưu tiên |
| ----- | ----- |
| Đảm bảo production luôn gọi registerMemberPromote (routes/app) | Trung |
| Sửa fallback require registry path trong definition | Thấp |
| PATH headers Q2 còn ghi shared/ trên file đã move | Thấp |
| open OP không ghi BPL (optional OPEN\_OP later) | Thấp |
| process\_instances model (thay temporary onboarding\_cases) | Dài hạn |
| CED: còn chỗ throw new Error lẻ → srpfError | Thấp |

---

## **8\. Việc không mở lại**

* **RP / OP-2 core (trừ regression có log \+ repro)**  
* **Big-bang refactor RP → member.service trong cùng phase (đã chốt: dần)**  
* **Auto HOAT\_DONG / auto gán CLAN\_ADMIN khi promote**

---

## **9\. Gợi ý next thread (chọn 1\)**

| Ưu tiên | Hướng | Ghi chú |
| ----- | ----- | ----- |
| A | FE/API OP (USER hoàn thiện BP → SUBMIT; Admin review/approve) | Sản phẩm visible |
| B | Polish C6 (wire routes chắc, Q2 headers, CED sạch) | Chất lượng |
| C | Merge cây / MEMBER\_JOIN → MERGED | Phụ thuộc schema \+ sau CHINH\_THUC |
| D | SEC residual (rate limit, alert bot, SYSTEM\_ADMIN harden) | Backlog bảo mật ngoài OP core |
| E | member.service.createDuBiMember cổng chung \+ auto open OP | Dài hạn, một nguồn DU\_BI |

---

## **10\. Quy ước làm việc với AI (nhắc lại)**

1. Q1: Không phá UI/UX/logic/tên/function đang chạy; đọc code hiện tại trước khi sửa.  
2. Q2: Header PATH / DATETIME / VERSION / DESCRIPTION; báo cáo có cấu trúc.  
3. Không sinh code vội — plan \+ xác nhận rồi mới full file / patch.  
4. Ưu tiên Markdown trong chat khi download artifact lỗi.  
5. SSOT docs trên CM-Docs; code trên cmcodes — luôn ưu tiên repo hơn transcript cũ nếu lệch.

---

## **11\. Câu mở đầu gợi ý cho thread mới**

Tiếp HandOver-Close-C6-2026-08-15.  
SSOT \+ Q1/Q2. Repos: QuangAGS/cmcodes \+ CM-Docs.  
C6 CLOSED. OP-A (DU\_BI→CHINH\_THUC) E2E JOIN+CLAN\_SETUP PASS.  
SRPF engine: shared/frameworks/srpf. OP realization: modules/onboarding/srpf.

> Next: \[A|B|C|D|E\] …

---

*End of HandOver-Close-C6-Next-Thread-2026-08-15*

