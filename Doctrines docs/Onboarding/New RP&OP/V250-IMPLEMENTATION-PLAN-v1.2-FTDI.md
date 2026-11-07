# KẾ HOẠCH TRIỂN KHAI: V2.5.0-FROZEN → Codebase (Bản FTDI-Aligned)

**Dự án:** myclan.com.vn  
**Ngày:** 2026-11-06  
**Phiên bản:** 1.2 (bổ sung FTDI alignment)

---

## Tổng quan

| Phase | Nội dung | Rủi ro | Ước lượng |
|-------|----------|--------|-----------|
| **Phase 1** | DDL & Migration | Thấp | 1 ngày |
| **Phase 2** | Auth Context & Sandbox Middleware | Trung bình | 2 ngày |
| **Phase 3** | Claim APIs & MFO Alignment (+ FTDI) | Cao | 3–4 ngày |

---

## Phase 1: DDL & Migration

(Giữ nguyên như bản v1.1 — kiểm tra kiểu UUID, partial unique index qua raw SQL, backfill.)

---

## Phase 2: Auth Context & Sandbox Middleware

(Giữ nguyên như bản v1.1 — whitelist đã bổ sung `/api/auth/me`, `/api/tenants`.)

---

## Phase 3: Claim APIs & MFO Alignment (đã bổ sung FTDI)

### 3.1 Thứ tự patch

| Bước | File | Nội dung |
|------|------|----------|
| 3.1 | `membership.service.js` | `submitClaim` (row-level lock), `approveClaim` (side-effects + FTDI). |
| 3.2 | `membership.routes.js` | Routes Claim. |
| 3.3 | `mfo.service.js` | Tạo `user_member_links (DRAFT)` khi tạo member DU_BI. |
| 3.4 | `mfo.gate2.js` | Dual-Write `parentages` + nâng link/user. |
| 3.5 | `onboarding.routes.js` | Deprecate legacy routes. |

### 3.2 submitClaim — Row-level Lock

```javascript
await prisma.$transaction(async (tx) => {
  await tx.$executeRaw`SELECT id FROM members WHERE id = ${targetMemberId} FOR UPDATE`;
  // ... kiểm tra tranh chấp, tạo proposal, tạo link
});
```

### 3.3 approveClaim — Side-effects (đã hiệu chỉnh)

```javascript
async function approveClaim(tx, { proposalId, actorId }) {
  const proposal = await tx.proposals.findUnique({ where: { id: proposalId } });

  // 0. Khóa dòng member (tránh race với thao tác cây)
  await tx.$executeRaw`SELECT id FROM members WHERE id = ${proposal.target_id} FOR UPDATE`;

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

  // 3. Nhân bản evidence_links sang MEMBER (không đè)
  const existingLinks = await tx.evidence_links.findMany({
    where: { target_type: 'PROPOSAL', target_id: proposalId }
  });
  if (existingLinks.length > 0) {
    await tx.evidence_links.createMany({
      data: existingLinks.map((el) => ({
        ...el,
        id: undefined,
        target_type: 'MEMBER',
        target_id: proposal.target_id,
        created_at: new Date(),
      })),
      skipDuplicates: true,
    });
  }

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

### 3.4 mfo.gate2.js — Dual-Write parentages (bổ sung)

Trong transaction duyệt MFO, sau khi tạo/cập nhật members:

```javascript
// Dual-Write sang parentages (FTDI)
for (const child of createdChildren) {
  if (child.father_id) {
    await tx.parentages.upsert({
      where: { /* unique key */ },
      update: { is_selected_for_lineage: true },
      create: {
        tenant_id: tenantId,
        parent_id: child.father_id,
        child_id: child.id,
        relationship_type: 'BIOLOGICAL',
        review_status: 'ACCEPTED',
        is_selected_for_lineage: true,
        changed_by: actorId,
      }
    });
  }
  if (child.mother_id) {
    await tx.parentages.upsert({
      where: { /* unique key */ },
      update: { is_selected_for_lineage: true },
      create: {
        tenant_id: tenantId,
        parent_id: child.mother_id,
        child_id: child.id,
        relationship_type: 'BIOLOGICAL',
        review_status: 'ACCEPTED',
        is_selected_for_lineage: true,
        changed_by: actorId,
      }
    });
  }
}

// Nâng link và user
await tx.user_member_links.updateMany({
  where: { user_id: actorId, status: 'DRAFT' },
  data: { status: 'DA_DUYET' }
});
await tx.users.updateMany({
  where: { id: actorId, status: 'CHO_DUYET' },
  data: { status: 'DA_DUYET' }
});
```

---

## Checklist FTDI Alignment

| Thành phần V2.5.0 | Điểm chạm FTDI | Hành động bắt buộc |
|-------------------|----------------|-------------------|
| `approveClaim` | `evidence_links` | Nhân bản liên kết `target_type = 'MEMBER'` (không đè). |
| `approveClaim` | `proposals` | Tạo `PROFILE_CORRECTION` nếu có diffs; không tự sửa sổ họ. |
| `approveClaim` | Row lock | `SELECT ... FOR UPDATE` ngay đầu hàm. |
| `mfo.gate2.js` | `parentages` | Dual-Write: sinh `BIOLOGICAL` + `ACCEPTED` + `is_selected_for_lineage = true`. |
| `onboarding.routes.js` | Legacy | Deprecate `mergeBranch`; chuyển nối cây sang MFO 5L. |

---

## Thứ tự thực thi

```
Phase 1 → Kiểm tra kiểu ID → Migration → prisma generate
Phase 2 → Auth → switch-context → tenantGate → test Sandbox
Phase 3 → membership.service (lock + side-effects) → mfo.gate2 (dual-write) → deprecate legacy
```

---

**Lưu ý:** Mỗi phase cần smoke test trước khi sang phase tiếp theo.
