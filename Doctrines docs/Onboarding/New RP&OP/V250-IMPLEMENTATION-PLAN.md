# KẾ HOẠCH TRIỂN KHAI: V2.5.0-FROZEN → Codebase

**Dự án:** myclan.com.vn  
**Ngày:** 2026-11-06  
**Mục tiêu:** Đưa codebase khớp với đặc tả RP & OP v2.5.0-FROZEN

---

## Tổng quan

| Phase | Nội dung | Rủi ro | Ước lượng |
|-------|----------|--------|-----------|
| **Phase 1** | DDL & Migration | Thấp | 1 ngày |
| **Phase 2** | Auth Context & Sandbox Middleware | Trung bình | 2 ngày |
| **Phase 3** | Claim APIs & MFO Alignment | Cao | 3–4 ngày |

---

## Phase 1: DDL & Migration

### 1.1 Migration SQL

```sql
-- 20261106_v250_user_member_links.sql

BEGIN;

-- 1. Enum cho user_member_links.status
CREATE TYPE user_member_link_status AS ENUM (
  'DRAFT',
  'CHO_DUYET',
  'DA_DUYET',
  'TU_CHOI',
  'HUY_LIEN_KET'
);

-- 2. Enum cho link_type
CREATE TYPE member_link_type AS ENUM (
  'PRIMARY_PATERNAL',
  'MATERNAL',
  'SPOUSE_FAMILY',
  'DESCENDANT_FAMILY',
  'GUARDIAN',
  'OTHER'
);

-- 3. Bảng user_member_links
CREATE TABLE user_member_links (
  id              VARCHAR(36) PRIMARY KEY DEFAULT gen_random_uuid()::text,
  user_id         VARCHAR(36) NOT NULL,
  tenant_id       VARCHAR(36) NOT NULL,
  member_id       VARCHAR(36) NOT NULL,
  link_type       member_link_type NOT NULL DEFAULT 'PRIMARY_PATERNAL',
  status          user_member_link_status NOT NULL DEFAULT 'CHO_DUYET',
  role_in_tenant  VARCHAR(20) NOT NULL DEFAULT 'USER',
  is_default      BOOLEAN NOT NULL DEFAULT false,
  claim_reason    TEXT,
  approved_by     VARCHAR(36),
  approved_at     TIMESTAMPTZ,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  changed_by      VARCHAR(36),
  deleted_at      TIMESTAMPTZ,

  CONSTRAINT fk_uml_user    FOREIGN KEY (user_id)   REFERENCES users(id)   ON DELETE CASCADE,
  CONSTRAINT fk_uml_tenant  FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE,
  CONSTRAINT fk_uml_member  FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE
);

CREATE INDEX idx_uml_user   ON user_member_links(user_id);
CREATE INDEX idx_uml_tenant ON user_member_links(tenant_id);
CREATE INDEX idx_uml_member ON user_member_links(member_id);

-- 4. Partial unique index: 1 member chỉ có 1 user DA_DUYET / tenant
CREATE UNIQUE INDEX unique_active_member_per_tenant
ON user_member_links (tenant_id, member_id)
WHERE status = 'DA_DUYET' AND deleted_at IS NULL;

-- 5. Bổ sung enum proposals.status (nếu chưa có DISPUTED)
ALTER TYPE proposals_status ADD VALUE IF NOT EXISTS 'DISPUTED';

-- 6. Bổ sung ticket_type MEMBER_CLAIM (nếu dùng enum)
-- ALTER TYPE proposal_ticket_type ADD VALUE IF NOT EXISTS 'MEMBER_CLAIM';

COMMIT;
```

### 1.2 Prisma Schema (bổ sung)

Thêm vào `schema.prisma`:

```prisma
model user_member_links {
  id             String   @id @default(dbgenerated("(gen_random_uuid())::text")) @db.VarChar(36)
  user_id        String   @db.VarChar(36)
  tenant_id      String   @db.VarChar(36)
  member_id      String   @db.VarChar(36)
  link_type      member_link_type @default(PRIMARY_PATERNAL)
  status         user_member_link_status @default(CHO_DUYET)
  role_in_tenant String   @default("USER") @db.VarChar(20)
  is_default     Boolean  @default(false)
  claim_reason   String?  @db.Text
  approved_by    String?  @db.VarChar(36)
  approved_at    DateTime? @db.Timestamptz(6)
  created_at     DateTime @default(now()) @db.Timestamptz(6)
  updated_at     DateTime @default(now()) @updatedAt @db.Timestamptz(6)
  changed_by     String?  @db.VarChar(36)
  deleted_at     DateTime? @db.Timestamptz(6)

  user    users    @relation(fields: [user_id], references: [id], onDelete: Cascade)
  tenant  tenants  @relation(fields: [tenant_id], references: [id], onDelete: Cascade)
  member  members  @relation(fields: [member_id], references: [id], onDelete: Cascade)

  @@index([user_id])
  @@index([tenant_id])
  @@index([member_id])
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

### 1.3 Backfill (tùy chọn)

```sql
-- Backfill từ users.member_id hiện có
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
| 2.1 | `auth.service.js` | Sau OTP: giữ `users.status = 'CHO_DUYET'`. Chỉ nâng `DA_DUYET` khi có link `DA_DUYET`. |
| 2.2 | `auth.controller.js` | Thêm `POST /api/auth/switch-context`. |
| 2.3 | `tenantGate.middleware.js` | Nhận diện `DRAFT`: whitelist `/api/mfo/*`, `/api/me/profile`. |
| 2.4 | `prisma.js` (ALS) | Hỗ trợ context từ `switch-context`. |

### 2.2 API switch-context

```javascript
// POST /api/auth/switch-context
// Body: { targetTenantId }
// Logic:
// 1. Tìm user_member_links WHERE user_id AND tenant_id AND status IN ('DA_DUYET', 'DRAFT')
// 2. Nếu không có → 403
// 3. Cấp token mới với activeTenantId, activeMemberId, activeLinkStatus
// 4. Set ALS context
```

### 2.3 Sandbox Middleware

```javascript
// Trong tenantGate
if (linkStatus === 'DRAFT') {
  const allowed = ['/api/mfo', '/api/me/profile'];
  if (!allowed.some(p => req.path.startsWith(p))) {
    return res.status(403).json({ code: 'SANDBOX_RESTRICTED' });
  }
}
```

---

## Phase 3: Claim APIs & MFO Alignment

### 3.1 Thứ tự patch

| Bước | File | Nội dung |
|------|------|----------|
| 3.1 | `membership.service.js` (mới) | `submitClaim`, `approveClaim` với row-level lock. |
| 3.2 | `membership.routes.js` (mới) | `POST /api/membership/claims`, `POST /api/admin/proposals/:id/approve-claim`. |
| 3.3 | `mfo.service.js` | Khi tạo member DU_BI: tạo `user_member_links (DRAFT)`. |
| 3.4 | `mfo.gate2.js` | Khi duyệt MFO: nâng `user_member_links → DA_DUYET`, `users → DA_DUYET`. |
| 3.5 | `onboarding.routes.js` | Deprecate `/merge`, `/branch`. |

### 3.2 Claim Transaction (pseudo)

```javascript
await prisma.$transaction(async (tx) => {
  await tx.$executeRaw`SELECT id FROM members WHERE id = ${targetMemberId} FOR UPDATE`;
  
  const existing = await tx.proposals.findFirst({
    where: { ticket_type: 'MEMBER_CLAIM', target_id: targetMemberId, status: 'PENDING' }
  });
  
  if (existing) {
    await tx.proposals.update({ where: { id: existing.id }, data: { status: 'DISPUTED' } });
    // tạo proposal mới cũng DISPUTED
  } else {
    await tx.proposals.create({ data: { status: 'PENDING', ticket_type: 'MEMBER_CLAIM', ... } });
    await tx.user_member_links.create({ data: { status: 'CHO_DUYET', ... } });
  }
});
```

---

## Thứ tự thực thi

```
Phase 1 (DDL)
  └── Chạy migration → prisma generate → kiểm tra schema

Phase 2 (Auth & Gate)
  └── Patch auth.service → thêm switch-context → patch tenantGate → test Sandbox

Phase 3 (Claim & MFO)
  └── Viết membership service → đấu nối G01 → sửa mfo.gate2 → deprecate legacy routes
```

---

**Lưu ý:** Mỗi phase nên có smoke test riêng trước khi sang phase tiếp theo.
