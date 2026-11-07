# KẾ HOẠCH TRIỂN KHAI: V2.5.0-FROZEN → Codebase (EXECUTION READY)

**Dự án:** myclan.com.vn  
**Ngày:** 2026-11-06  
**Phiên bản:** 1.3 (đã sửa Actor/Requester, Prisma createMany, composite key)

---

## Tổng quan

| Phase | Nội dung | Rủi ro | Ước lượng |
|-------|----------|--------|-----------|
| **Phase 1** | DDL & Migration | Thấp | 1 ngày |
| **Phase 2** | Auth Context & Sandbox Middleware | Trung bình | 2 ngày |
| **Phase 3** | Claim APIs & MFO Alignment (+ FTDI) | Cao | 3–4 ngày |

---

## Phase 1 & 2

(Giữ nguyên như bản v1.2.)

---

## Phase 3: Claim APIs & MFO Alignment

### 3.1 approveClaim — Side-effects (đã sửa)

```javascript
async function approveClaim(tx, { proposalId, actorId }) {
  const proposal = await tx.proposals.findUnique({ where: { id: proposalId } });
  const targetUserId = proposal.requester_user_id;

  // 0. Khóa dòng member
  await tx.$executeRaw`SELECT id FROM members WHERE id = ${proposal.target_id} FOR UPDATE`;

  const link = await tx.user_member_links.findFirst({
    where: { user_id: targetUserId, member_id: proposal.target_id }
  });

  // 1. Cập nhật link của người nộp
  await tx.user_member_links.update({
    where: { id: link.id },
    data: { status: 'DA_DUYET', approved_by: actorId, approved_at: new Date() }
  });

  // 2. Nâng users.status của người nộp
  await tx.users.updateMany({
    where: { id: targetUserId, status: 'CHO_DUYET' },
    data: { status: 'DA_DUYET' }
  });

  // 3. Nhân bản evidence_links (bóc tách id)
  const existingLinks = await tx.evidence_links.findMany({
    where: { target_type: 'PROPOSAL', target_id: proposalId }
  });
  if (existingLinks.length > 0) {
    const linksToCreate = existingLinks.map(({ id, ...rest }) => ({
      ...rest,
      target_type: 'MEMBER',
      target_id: proposal.target_id,
      created_at: new Date(),
    }));
    await tx.evidence_links.createMany({
      data: linksToCreate,
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

### 3.2 mfo.gate2.js — Dual-Write + nâng đúng người nộp

```javascript
// Dual-Write sang parentages (dùng composite unique key)
for (const child of createdChildren) {
  if (child.father_id) {
    await tx.parentages.upsert({
      where: {
        tenant_id_parent_id_child_id_relationship_type: {
          tenant_id: tenantId,
          parent_id: child.father_id,
          child_id: child.id,
          relationship_type: 'BIOLOGICAL',
        }
      },
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
      where: {
        tenant_id_parent_id_child_id_relationship_type: {
          tenant_id: tenantId,
          parent_id: child.mother_id,
          child_id: child.id,
          relationship_type: 'BIOLOGICAL',
        }
      },
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

// Nâng link và user của người nộp (không phải Admin)
const targetUserId = proposal.requester_user_id;

await tx.user_member_links.updateMany({
  where: { user_id: targetUserId, tenant_id: proposal.tenant_id, status: 'DRAFT' },
  data: { 
    status: 'DA_DUYET', 
    approved_by: actorId, 
    approved_at: new Date() 
  }
});

await tx.users.updateMany({
  where: { id: targetUserId, status: 'CHO_DUYET' },
  data: { status: 'DA_DUYET' }
});
```

---

## Checklist FTDI Alignment

| Thành phần | Hành động bắt buộc |
|------------|-------------------|
| `approveClaim` | Dùng `proposal.requester_user_id`, không dùng `actorId` để nâng user/link. |
| `approveClaim` | Nhân bản `evidence_links` bằng destructure `{ id, ...rest }`. |
| `approveClaim` | Row-level lock ngay đầu hàm. |
| `mfo.gate2.js` | Dual-Write với composite unique key đúng. |
| `mfo.gate2.js` | Nâng `requester_user_id`, không phải `actorId`. |

---

## Thứ tự thực thi

```
Phase 1 → Migration → prisma generate
Phase 2 → Auth → switch-context → tenantGate → test Sandbox
Phase 3 → membership.service → mfo.gate2 (dual-write + đúng requester) → deprecate legacy
```

---

**Trạng thái:** EXECUTION READY.
