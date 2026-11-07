# KẾ HOẠCH TRIỂN KHAI: V2.5.0-FROZEN → Codebase (Bản hiệu chỉnh)

**Dự án:** myclan.com.vn  
**Ngày:** 2026-11-06  
**Phiên bản:** 1.1 (đã hiệu chỉnh theo phản biện)

---

## Tổng quan

| Phase | Nội dung | Rủi ro | Ước lượng |
|-------|----------|--------|-----------|
| **Phase 1** | DDL & Migration | Thấp | 1 ngày |
| **Phase 2** | Auth Context & Sandbox Middleware | Trung bình | 2 ngày |
| **Phase 3** | Claim APIs & MFO Alignment | Cao | 3–4 ngày |

---

## Phase 1: DDL & Migration

### 1.1 Kiểm tra kiểu ID trước khi viết migration

Mở `Backend/prisma/schema.prisma` và xác định kiểu của `users.id`, `tenants.id`, `members.id`:

- Nếu dùng `@db.Uuid` → dùng `UUID` trong SQL.
- Nếu dùng `@db.VarChar(36)` → dùng `VARCHAR(36)`.

### 1.2 Migration SQL (giả định UUID)

```sql
-- 20261106_v250_user_member_links.sql

BEGIN;

CREATE TYPE user_member_link_status AS ENUM (
  'DRAFT', 'CHO_DUYET', 'DA_DUYET', 'TU_CHOI', 'HUY_LIEN_KET'
);

CREATE TYPE member_link_type AS ENUM (
  'PRIMARY_PATERNAL', 'MATERNAL', 'SPOUSE_FAMILY',
  'DESCENDANT_FAMILY', 'GUARDIAN', 'OTHER'
);

CREATE TABLE user_member_links (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL,
  tenant_id       UUID NOT NULL,
  member_id       UUID NOT NULL,
  link_type       member_link_type NOT NULL DEFAULT 'PRIMARY_PATERNAL',
  status          user_member_link_status NOT NULL DEFAULT 'CHO_DUYET',
  role_in_tenant  VARCHAR(20) NOT NULL DEFAULT 'USER',
  is_default      BOOLEAN NOT NULL DEFAULT false,
  claim_reason    TEXT,
  approved_by     UUID,
  approved_at     TIMESTAMPTZ,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  changed_by      UUID,
  deleted_at      TIMESTAMPTZ,

  CONSTRAINT fk_uml_user   FOREIGN KEY (user_id)   REFERENCES users(id)   ON DELETE CASCADE,
  CONSTRAINT fk_uml_tenant FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE,
  CONSTRAINT fk_uml_member FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE
);

CREATE INDEX idx_uml_user   ON user_member_links(user_id);
CREATE INDEX idx_uml_tenant ON user_member_links(tenant_id);
CREATE INDEX idx_uml_member ON user_member_links(member_id);
CREATE INDEX idx_uml_tenant_member ON user_member_links(tenant_id, member_id);

-- Partial unique index (chạy qua raw SQL, không khai báo trong schema.prisma)
CREATE UNIQUE INDEX unique_active_member_per_tenant
ON user_member_links (tenant_id, member_id)
WHERE status = 'DA_DUYET' AND deleted_at IS NULL;

-- Bổ sung enum proposals
ALTER TYPE proposals_status ADD VALUE IF NOT EXISTS 'DISPUTED';

COMMIT;
```

### 1.3 Prisma Schema

```prisma
model user_member_links {
  id             String   @id @default(dbgenerated("gen_random_uuid()")) @db.Uuid
  user_id        String   @db.Uuid
  tenant_id      String   @db.Uuid
  member_id      String   @db.Uuid
  link_type      member_link_type @default(PRIMARY_PATERNAL)
  status         user_member_link_status @default(CHO_DUYET)
  role_in_tenant String   @default("USER") @db.VarChar(20)
  is_default     Boolean  @default(false)
  claim_reason   String?  @db.Text
  approved_by    String?  @db.Uuid
  approved_at    DateTime? @db.Timestamptz(6)
  created_at     DateTime @default(now()) @db.Timestamptz(6)
  updated_at     DateTime @default(now()) @updatedAt @db.Timestamptz(6)
  changed_by     String?  @db.Uuid
  deleted_at     DateTime? @db.Timestamptz(6)

  user    users    @relation(fields: [user_id], references: [id], onDelete: Cascade)
  tenant  tenants  @relation(fields: [tenant_id], references: [id], onDelete: Cascade)
  member  members  @relation(fields: [member_id], references: [id], onDelete: Cascade)

  @@index([user_id])
  @@index([tenant_id])
  @@index([member_id])
  @@index([tenant_id, member_id])
  @@map("user_member_links")
}

enum user_member_link_status {
  DRAFT
  CHO_DUYET
  DA_DUYET
  TU_CHOI
  HUY_LIEN_KET
}

enum member_link_type {
  PRIMARY_PATERNAL
  MATERNAL
  SPOUSE_FAMILY
  DESCENDANT_FAMILY
  GUARDIAN
  OTHER
}
```

**Lưu ý:** Partial unique index không khai báo trong schema.prisma. Chạy qua migration SQL.

### 1.4 Backfill

```sql
INSERT INTO user_member_links (user_id, tenant_id, member_id, link_type, status, is_default)
SELECT u.id, u.tenant_id, u.member_id, 'PRIMARY_PATERNAL', 'DA_DUYET', true
FROM users u
WHERE u.member_id IS NOT NULL AND u.deleted_at IS NULL
ON CONFLICT DO NOTHING;
```

---

## Phase 2: Auth Context & Sandbox Middleware

### 2.1 Thứ tự patch

| Bước | File | Nội dung |
|------|------|----------|
| 2.1 | `auth.service.js` | Sau OTP: giữ `CHO_DUYET`. Chỉ nâng `DA_DUYET` khi có link `DA_DUYET`. |
| 2.2 | `auth.controller.js` | Thêm `POST /api/auth/switch-context`. |
| 2.3 | `tenantGate.middleware.js` | Sandbox cho `DRAFT`. |
| 2.4 | `prisma.js` | Hỗ trợ ALS từ switch-context. |

### 2.2 Sandbox Whitelist (đã bổ sung)

```javascript
if (linkStatus === 'DRAFT') {
  const allowed = [
    '/api/mfo',
    '/api/me/profile',
    '/api/auth/me',
    '/api/tenants',
  ];
  if (!allowed.some(p => req.path.startsWith(p))) {
    return res.status(403).json({
      success: false,
      code: 'SANDBOX_RESTRICTED',
      message: 'Tài khoản đang trong chế độ khởi tạo phả hệ. Chỉ được sử dụng MFO và cập nhật hồ sơ.',
    });
  }
}
```

---

## Phase 3: Claim APIs & MFO Alignment

### 3.1 Thứ tự patch

| Bước | File | Nội dung |
|------|------|----------|
| 3.1 | `membership.service.js` | `submitClaim` (row-level lock), `approveClaim` (side-effects). |
| 3.2 | `membership.routes.js` | Routes Claim. |
| 3.3 | `mfo.service.js` | Tạo `user_member_links (DRAFT)` khi tạo member DU_BI. |
| 3.4 | `mfo.gate2.js` | Nâng link và user khi duyệt MFO. |
| 3.5 | `onboarding.routes.js` | Deprecate legacy routes. |

### 3.2 approveClaim — Side-effects bắt buộc

```javascript
async function approveClaim(tx, { proposalId, actorId }) {
  const proposal = await tx.proposals.findUnique({ where: { id: proposalId } });
  const link = await tx.user_member_links.findFirst({
    where: { user_id: proposal.requester_user_id, member_id: proposal.target_id }
  });

  // 1. Cập nhật link
  await tx.user_member_links.update({
    where: { id: link.id },
    data: { status: 'DA_DUYET', approved_by: actorId, approved_at: new Date() }
  });

  // 2. Nâng users.status nếu chưa
  await tx.users.updateMany({
    where: { id: proposal.requester_user_id, status: 'CHO_DUYET' },
    data: { status: 'DA_DUYET' }
  });

  // 3. Gắn evidence_links sang MEMBER
  await tx.evidence_links.updateMany({
    where: { target_type: 'PROPOSAL', target_id: proposalId },
    data: { target_type: 'MEMBER', target_id: proposal.target_id }
  });

  // 4. Profile Correction nếu có diffs
  const diffs = proposal.payload?.declared_diffs;
  if (diffs && Object.keys(diffs).length > 0) {
    await tx.proposals.create({
      data: {
        ticket_type: 'PROFILE_CORRECTION',
        status: 'PENDING',
        target_id: proposal.target_id,
        payload: { diffs },
        requester_user_id: actorId,
        tenant_id: proposal.tenant_id,
      }
    });
  }

  // 5. Đóng proposal gốc
  await tx.proposals.update({
    where: { id: proposalId },
    data: { status: 'APPROVED' }
  });
}
```

---

## Thứ tự thực thi

```
Phase 1 → Kiểm tra kiểu ID → Chạy migration → prisma generate
Phase 2 → Patch auth → switch-context → tenantGate (whitelist) → test Sandbox
Phase 3 → membership.service → approveClaim side-effects → mfo.gate2 → deprecate legacy
```

---

**Lưu ý:** Mỗi phase cần smoke test trước khi sang phase tiếp theo.
