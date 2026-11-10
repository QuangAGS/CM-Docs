# TÀI LIỆU PHỤ LỤC KỸ THUẬT (TECHNICAL AMENDMENT)

## AMEND-01: BỔ SUNG & ĐIỀU CHỈNH ĐẶC TẢ KIẾN TRÚC RP & OP

* **Căn cứ:** `RP-OP-DETAILED-IMPLEMENTATION-V2.1`
* **Mã:** `AMEND-RP-OP-2026-01-V1.1`
* **Ngày:** 09/11/2026

---

## 1. PHÂN ĐỊNH RP&OP VS MFO & STATE MACHINE

### 1.1 Hủy bỏ phụ thuộc MFO

| Mục cũ | Hành động |
|--------|-----------|
| `OPT-3` | **Hủy** |
| `CLAIM-04` | **Hủy** |

RP&OP độc lập với MFO. MFO chạy sau khi OP kết thúc.

### 1.2 State Machine (Cyclic)
Quy trình RP&OP không áp dụng mô hình Single-thread mà triển khai **Cyclic State Machine** có chốt chặn bảo an:

```
                  ┌────────────────────────────────────────┐
                  │          [ returnForRevision ]         │
                  │  (User: CHO_DUYET ──► CHO_DUYET        │
                  │   Case: SUBMITTED ──► NEEDS_REVISION)  │
                  ▼                                        │
           ┌─────────────┐   processUserApproval(TU_CHOI) ┌─────────────┐
           │             │ ─────────────────────────────► │             │
           │  CHO_DUYET  │                                │   TU_CHOI   │
           │             │ ◄───────────────────────────── │             │
           └─────────────┘     reopenRejectedUser         └─────────────┘
                  │         (Case: REJECTED ──► NEW CASE)        │
                  │                                              │ markFinalRejection
                  │ processUserApproval(DA_DUYET)                ▼ (is_final_rejection=true)
                  ▼                                       ┌─────────────┐
           ┌─────────────┐                                │ HARD-LOCKED │
           │  DA_DUYET   │ (Terminal State)               │ (Vĩnh viễn) │
           └─────────────┘                                └─────────────┘
```

| Nguồn | Đích | Hàm | Ghi chú |
|-------|------|-----|---------|
| `CHO_DUYET` | `DA_DUYET` | `processUserApproval` | Terminal |
| `CHO_DUYET` | `TU_CHOI` | `processUserApproval` | Soft rejection |
| `CHO_DUYET` | `CHO_DUYET` | `returnForRevision` | Case → `NEEDS_REVISION` |
| `TU_CHOI` | `CHO_DUYET` | `reopenRejectedUser` | Tạo case mới |
| `TU_CHOI` | `TU_CHOI` | `markFinalRejection` | Hard lock |

### 1.3 So với MFO

| | RP&OP | MFO |
|---|-------|-----|
| Mô hình | Cyclic | Single-thread |
| Terminal | `DA_DUYET` | `APPROVED` |
| Hard-lock | Có | Không |

---

## 2. HAI KỊCH BẢN NGHIỆP VỤ

### 2.1 Clan-joint

| Case | Điều kiện | Hành động khi duyệt |
|------|-----------|---------------------|
| **Case 1: EM** | Có `claimed_member_id` | Gán `users.member_id = EM.id` |
| **Case 2: No EM** | Không có EM | Tạo `members` từ JSON, gán `users.member_id` |

### 2.2 Clan-setup

| Bước | Hành động |
|------|-----------|
| 1 | Tạo `tenants` với `status = CHO_DUYET` |
| 2 | `SYSTEM_ADMIN` duyệt |
| 3 | Tạo Founder Member từ JSON |
| 4 | Kích hoạt tenant, gán `CLAN_ADMIN` |

---

## 3. SCHEMA JSON (SÁT VỚI MEMBERS)

### 3.1 Cấu trúc

```json
{
  "full_name": "string",
  "alias": "string",
  "gender": "NAM | NU | KHAC",
  "birth_year": "number",
  "birth_month": "number",
  "birth_day": "number",
  "birth_place": "string",
  "death_year": "number",
  "is_alive": "boolean",
  "generation": "number",
  "phone": "string",
  "email": "string",
  "member_role": "string",
  "branch_name": "string",
  "father_name": "string",
  "mother_name": "string",
  "grandfather_name": "string",
  "grandmother_name": "string",
  "address": "string",
  "note": "string",
  "claimed_member_id": "string",
  "proof_documents": ["string"],
  "social_profiles": { "facebook": "string", "zalo": "string" }
}
```

### 3.2 Validator (đã sửa)

```javascript
const REGISTRATION_SCHEMA = {
  full_name: { type: 'string', required: true, max: 100 },
  alias: { type: 'string', required: false, max: 100 },
  gender: { type: 'string', required: true, enum: ['NAM', 'NU', 'KHAC'] },
  birth_year: { type: 'number', required: false, min: 1800, max: new Date().getFullYear() },
  birth_month: { type: 'number', required: false, min: 1, max: 12 },
  birth_day: { type: 'number', required: false, min: 1, max: 31 },
  birth_place: { type: 'string', required: false, max: 200 },
  death_year: { type: 'number', required: false, min: 1800, max: new Date().getFullYear() },
  is_alive: { type: 'boolean', required: false, default: true },
  generation: { type: 'number', required: false, min: 1, max: 20 },
  phone: { type: 'string', required: false, max: 20 },
  email: { type: 'string', required: false, max: 100 },
  member_role: { type: 'string', required: false, max: 50, default: 'THANH_VIEN' },
  branch_name: { type: 'string', required: false, max: 100 },
  father_name: { type: 'string', required: false, max: 100 },
  mother_name: { type: 'string', required: false, max: 100 },
  grandfather_name: { type: 'string', required: false, max: 100 },
  grandmother_name: { type: 'string', required: false, max: 100 },
  address: { type: 'string', required: false, max: 500 },
  note: { type: 'string', required: false, max: 1000 },
  claimed_member_id: { type: 'string', required: false, max: 36 },
  proof_documents: { type: 'array', required: false },
  social_profiles: { type: 'object', required: false },
};

function validateRegistrationProfile(data = {}) {
  const cleanData = {};

  for (const [key, rule] of Object.entries(REGISTRATION_SCHEMA)) {
    let val = data[key];

    if (val === undefined || val === null || val === '') {
      if (rule.required) {
        const err = new Error(`Trường [${key}] là bắt buộc.`);
        err.status = 400;
        err.code = 'VALIDATION_REQUIRED';
        throw err;
      }
      if (rule.default !== undefined) {
        cleanData[key] = rule.default;
      }
      continue;
    }

    if (rule.type === 'number' && typeof val === 'string' && !isNaN(val)) {
      val = Number(val);
    }

    if (rule.type === 'boolean' && typeof val === 'string') {
      val = val === 'true' || val === '1';
    }

    if (rule.type === 'array') {
      if (!Array.isArray(val)) {
        const err = new Error(`Trường [${key}] phải là mảng.`);
        err.status = 400;
        err.code = 'VALIDATION_TYPE';
        throw err;
      }
      cleanData[key] = val;
      continue;
    }

    if (rule.type === 'object') {
      if (typeof val !== 'object' || Array.isArray(val)) {
        const err = new Error(`Trường [${key}] phải là object.`);
        err.status = 400;
        err.code = 'VALIDATION_TYPE';
        throw err;
      }
      cleanData[key] = val;
      continue;
    }

    if (typeof val !== rule.type) {
      const err = new Error(`Trường [${key}] phải là ${rule.type}.`);
      err.status = 400;
      err.code = 'VALIDATION_TYPE';
      throw err;
    }

    if (rule.type === 'string' && rule.max && val.length > rule.max) {
      const err = new Error(`Trường [${key}] không được vượt quá ${rule.max} ký tự.`);
      err.status = 400;
      err.code = 'VALIDATION_MAX';
      throw err;
    }

    if (rule.type === 'number') {
      if (rule.min !== undefined && val < rule.min) {
        const err = new Error(`Trường [${key}] phải >= ${rule.min}.`);
        err.status = 400;
        err.code = 'VALIDATION_MIN';
        throw err;
      }
      if (rule.max !== undefined && val > rule.max) {
        const err = new Error(`Trường [${key}] phải <= ${rule.max}.`);
        err.status = 400;
        err.code = 'VALIDATION_MAX';
        throw err;
      }
    }

    if (rule.enum && !rule.enum.includes(val)) {
      const err = new Error(`Giá trị [${val}] không hợp lệ cho [${key}].`);
      err.status = 400;
      err.code = 'VALIDATION_ENUM';
      throw err;
    }

    cleanData[key] = val;
  }

  return cleanData;
}

module.exports = { validateRegistrationProfile, REGISTRATION_SCHEMA };
```

---

## 4. SMOKE TEST PHASE 3

| Mã | Mục tiêu | Kỳ vọng |
|----|----------|---------|
| SMOKE-3.1 | `returnForRevision` | `users.status = CHO_DUYET`, `case.status = NEEDS_REVISION` |
| SMOKE-3.2 | `submitRegistrationRevision` | Validate JSON thành công |
| SMOKE-3.3 | `TU_CHOI` → `reopenRejectedUser` | Tạo case mới |
| SMOKE-3.4 | `markFinalRejection` | `is_final_rejection = true` |
| SMOKE-3.5 | `processUserApproval(DA_DUYET)` | Gán member, `user_member_links = DA_DUYET` |

---

**Kết luận:** Bản hiệu chỉnh với validator đúng. Schema sát với `members`.
