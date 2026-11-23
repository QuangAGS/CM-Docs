# AMEND-MFO-2026-01 — Canvas gắn vào người đã có

* PATH: docs/amendments/AMEND-MFO-2026-01-CANVAS-LINK-EXISTING.md
* DATETIME: 2026-11-15T19:54:00+07:00
* VERSION: V3.0
* STATUS: Frozen
* SCOPE: MFO canvas của chính mình, kèm lối khởi tạo sổ cho họ mới

Tài liệu này độc lập. Code ở mục 8 và mục 10 ghép được vào file. Không cần bản khác.

## 1. Mục đích

Mở rộng canvas MFO của chính mình để thành viên `CHINH_THUC` trình gắn vào gia đình đã có, khai người chưa có, và gỡ liên kết gắn nhầm.

Giữ một canvas. Tách hai nhóm. Không tạo trang riêng. Không tạo draft bắt buộc sau New RP&OP.

## 2. Vấn đề

New RP&OP duyệt một lần tạo member `CHINH_THUC` đứng riêng nếu khai 21 trường. Canvas hiện chỉ tạo con và vợ/chồng mới đi xuống. Họ mới chỉ có `CLAN_ADMIN`, không có người khác để chọn.

## 3. Phạm vi

Trong phạm vi:

* Canvas của chính mình.
* Gắn cha/mẹ, gắn vợ/chồng, khai người chưa có phía trên, gỡ liên kết.
* Cùng một tờ trình được vừa gỡ vừa khai cha/mẹ mới.
* Trình nối tổ tiên trực hệ chưa có tài khoản, vẫn qua hai cửa.
* Lối `/admin` khởi tạo sổ, có sửa/gỡ/xóa trước mốc đóng.

Ngoài phạm vi:

* Không chọn anh/em.
* Không tạo trang `/op` riêng.
* Không tạo Draft MFO sau RP&OP.
* Không gắn cha/mẹ lúc duyệt RP.
* Không tự tính lại `generation` của cả nhánh khi đổi cha/mẹ.
* Không đọc cây từ `parentages`.

## 4. Tác vụ

| Nhóm | Tác vụ | Kết quả sau Cửa 2 |
|---|---|---|
| Gắn đã có | Chọn cha/mẹ | Ghi `father_id` / `mother_id`, dual-write `parentages` |
| Gắn đã có | Chọn vợ/chồng | Tạo một `marriage` |
| Gắn đã có | Xin gỡ cha/mẹ | Cột về null, soft-delete cạnh `parentages` gắn nhầm |
| Tạo mới | Thêm con / vợ chồng mới | Member nháp “Xin tạo” |
| Tạo mới | Khai cha/mẹ/cụ tổ chưa có | Member nháp phía trên, gắn mình hoặc node nháp con vào người đó |

Gắn lần đầu (`ATTACH`) khác đổi (`MOVE`). Đổi là chuyển nhánh. Cửa 1 cảnh báo. Không tự sửa `generation` của con cháu.

## 5. Flow

Họ mới chỉ có mình: không chọn người đã có. Khai người chưa có, hoặc dùng `/admin`.

Gỡ và khai lại nằm cùng một tờ trình. Bấm “Xin gỡ cha” thì ngay trên thẻ đó có “Khai cha mới thay thế”.

Nếu vừa gắn hoặc khai vợ/chồng vừa thêm con, từng con nháp chọn cha/mẹ thứ hai từ `link_spouses`, `draft_spouses`, hoặc hôn phối `DANG_KET_HON` đang có.

Cửa 2 chạy lại guard trong transaction rồi mới ghi.

## 6. Payload

`canvas_delta` có đúng sáu mảng. `normalizeCanvasDelta` luôn khởi tạo `[]` khi đọc và khi ghi, và giữ các trường trong từng phần tử: `subject_member_id`, `expected_mode`, `expected_target_member_id`, `resolved_husband_id`, `child_ref_id`, `second_parent.source`, `second_parent.ref_id`, `second_parent.resolved_father_id`.

Ví dụ đủ một phần tử mỗi mảng:

```json
{
  "canvas_delta": {
    "link_parents": [{
      "id": "link-parent-1",
      "subject_member_id": "<uuid>",
      "role": "FATHER",
      "target_member_id": "<uuid>",
      "target_name": "Nguyễn Văn A",
      "expected_mode": "ATTACH"
    }],
    "unlink_parents": [{
      "subject_member_id": "<uuid>",
      "role": "MOTHER",
      "expected_target_member_id": "<uuid-luc-trinh>",
      "reason": "Gắn nhầm"
    }],
    "link_spouses": [{
      "id": "link-spouse-1",
      "subject_member_id": "<uuid>",
      "target_member_id": "<uuid>",
      "target_name": "Nguyễn Thị B",
      "resolved_husband_id": null
    }],
    "draft_parents": [{
      "id": "draft-parent-1",
      "child_ref_id": "<uuid-hoac-draft-parent-khac>",
      "role": "FATHER",
      "full_name": "Nguyễn Văn Cụ",
      "gender": "NAM",
      "birth_year": 1920
    }],
    "draft_children": [{
      "id": "draft-child-1",
      "full_name": "Nguyễn Văn Con",
      "gender": "NAM",
      "second_parent": {
        "source": "DRAFT_SPOUSE",
        "ref_id": "draft-spouse-1",
        "resolved_father_id": null
      }
    }],
    "draft_spouses": [{
      "id": "draft-spouse-1",
      "full_name": "Nguyễn Thị D",
      "gender": null,
      "birth_year": 1990,
      "resolved_husband_id": null
    }]
  }
}
```

Quy tắc:

* `subject_member_id` mặc định là mình. Nếu khác mình, phải là tổ tiên trực hệ trên đồ thị tạm và chưa có `user_member_links` `DA_DUYET`. `members` không có cột `user_id`.
* API cây canvas trả `can_proxy_link: true` cho tổ tiên trực hệ chưa có link `DA_DUYET`. Bấm node đó mở menu “Gắn cha/mẹ cho người này” và “Gắn vợ/chồng cho người này”.
* Mọi UUID đưa vào Prisma phải qua `assertUuid`. Chuỗi lạ trả `422`.
* Id nháp trong cùng tờ không được trùng. `full_name` nháp không được rỗng.
* Mỗi tờ tối đa một `draft_spouses`.
* EU trình khung được để `resolved_husband_id` null. Cửa 1 và Cửa 2 gọi guard với `requireResolvedRoles: true`. Thiếu vai thì không sang Cửa 2.
* Nếu `second_parent.source` là `DRAFT_SPOUSE` hoặc `LINK_SPOUSE` và `resolved_father_id` trống, guard ghi vai kế thừa vào chính object đó.
* `EXISTING_MEMBER` phải đang có `marriage` hiệu lực với mình.

### 6.1 API duyệt Cửa 1

`POST /api/mfo/plans/:id/approve`

```json
{
  "admin_note": "Đồng ý khung",
  "resolved_roles": {
    "link_spouses": { "link-spouse-1": "<uuid-chong>" },
    "draft_spouses": { "draft-spouse-1": "draft-spouse-1" },
    "draft_children": { "draft-child-1": "<uuid-hoac-id-nhap>" }
  }
}
```

Backend chỉ nhận key trong `resolved_roles` nếu key khớp `id` đang có trong `link_spouses`, `draft_spouses`, hoặc `draft_children`. Key lạ bị bỏ. Merge vai vào `canvas_delta` đang lưu, gọi `validateMfoLinks` với `requireResolvedRoles: true`, rồi update `proposal.payload` xuống DB trong cùng transaction. Thiếu vai thì `422`, không đẩy sang Cửa 2.

### 6.2 API chi tiết tờ trình

`GET /api/mfo/plans/:id` gọi `computeGate1Warnings` và trả `warnings`.

## 7. Ràng buộc

Chạy lúc trình (`requireResolvedRoles: false`) và lúc Cửa 1 duyệt, Cửa 2 nghiệm thu (`requireResolvedRoles: true`). Đồ thị tạm = DB + delta. Áp `unlink` trước, rồi `draft_parents`, rồi `link_parents`.

1. Target là `CHINH_THUC`, cùng tenant, chưa xóa.
2. Không chọn chính subject.
3. Mỗi subject tối đa một `FATHER`, một `MOTHER`.
4. Cha không được `NU`. Mẹ không được `NAM`.
5. Không tạo vòng. Không truy vấn DB bằng id nháp.
6. Vợ/chồng không phải tổ tiên hoặc hậu duệ của nhau khi duyệt hai chiều.
7. `expected_mode` và `expected_target_member_id` phải khớp DB lúc Cửa 2.
8. `unlink` mà vai đang null: từ chối.
9. `draft_parents` mà sau unlink vẫn còn cha/mẹ: từ chối.
10. Subject khác mình không được có link `DA_DUYET`.
11. `draft_spouses` tối đa một dòng.
12. Khi `requireResolvedRoles` là true, cả hai khuyết giới tính thì bắt buộc có vai đã chọn hợp lệ, thuộc cặp, không phải Nữ.
13. Sheet không trả SĐT, CCCD.
14. Mọi gỡ và mọi `marriages.create` phải vào `auditQueue`.

Cửa 1 cảnh báo, không chặn cứng: `BRANCH_MOVE`, `UNLINK_HAS_DESCENDANTS`, `SPOUSE_HAS_OTHER_MARRIAGE` chỉ `DANG_KET_HON`, `PARENTS_NOT_MARRIED` tính sau unlink.

## 8. Ghi sổ

Đầu transaction:

1. `collectLockMemberIds(selfMember.id, canvasDelta)`.
2. Khóa `FOR UPDATE`, ép `::uuid`, có `tenant_id`, sort tăng dần.
3. Đọc lại `selfMember`.
4. `validateMfoLinks` với `requireResolvedRoles: true`.
5. `unlink_parents`, kèm audit.
6. Tạo member nháp. Đời cha nháp tính theo đời của chính con, trừ 1.
7. Ghi quan hệ và `marriages`, kèm audit.
8. `upsertParentage`. Cặp đã soft-delete thì khôi phục.

### 8.1 Khóa hàng

```js
const lockIds = collectLockMemberIds(selfMember.id, canvasDelta);
if (lockIds.length) {
  const uuidList = Prisma.join(lockIds.map((id) => Prisma.sql`${id}::uuid`));
  await tx.$queryRaw`
    SELECT id FROM members
    WHERE tenant_id = ${tenantId}::uuid AND id IN (${uuidList})
    ORDER BY id ASC
    FOR UPDATE
  `;
}
const freshSelf = await tx.members.findFirst({
  where: { id: selfMember.id, tenant_id: tenantId, deleted_at: null },
});
if (!freshSelf) fail('Hồ sơ thành viên không còn tồn tại.');
```

### 8.2 Cửa 2

```js
await validateMfoLinks(tx, {
  tenantId, selfMember: freshSelf, canvasDelta, requireResolvedRoles: true,
});

for (const unlink of canvasDelta.unlink_parents || []) {
  const subjectId = unlink.subject_member_id || freshSelf.id;
  const field = unlink.role === 'MOTHER' ? 'mother_id' : 'father_id';
  const subject = await tx.members.findFirst({
    where: { id: subjectId, tenant_id: tenantId, deleted_at: null },
    select: { father_id: true, mother_id: true },
  });
  const oldParentId = unlink.role === 'MOTHER' ? subject?.mother_id : subject?.father_id;
  await tx.members.updateMany({
    where: { id: subjectId, tenant_id: tenantId, deleted_at: null },
    data: { [field]: null, changed_by: actorId },
  });
  auditQueue.push({
    tableName: 'members', recordId: subjectId, action: 'CAP_NHAT', tenantId, changedBy: actorId,
    correlationId, ticketId: proposal.id,
    oldData: { [field]: oldParentId }, newData: { [field]: null },
    changeReason: unlink.reason || 'Gỡ liên kết',
  });
  if (oldParentId) {
    await tx.parentages.updateMany({
      where: { tenant_id: tenantId, parent_id: oldParentId, child_id: subjectId, deleted_at: null },
      data: { deleted_at: new Date(), is_selected_for_lineage: false, changed_by: actorId },
    });
    auditQueue.push({
      tableName: 'parentages', recordId: `${oldParentId}:${subjectId}`, action: 'XOA', tenantId,
      changedBy: actorId, correlationId, ticketId: proposal.id,
      oldData: { parent_id: oldParentId, child_id: subjectId }, newData: { deleted_at: true },
      changeReason: unlink.reason || 'Gỡ liên kết',
    });
  }
}

const idMap = new Map();
const resolveId = (refId) => idMap.get(refId) || refId;
const draftParentById = new Map((canvasDelta.draft_parents || []).map((d) => [d.id, d]));
const genCache = new Map([[freshSelf.id, freshSelf.generation || null]]);

async function computeDraftParentGen(draftId, depth = 0) {
  if (depth > 20) return null;
  const draft = draftParentById.get(draftId);
  if (!draft) return null;
  const childId = draft.child_ref_id;
  let childGen = null;
  if (draftParentById.has(childId)) childGen = await computeDraftParentGen(childId, depth + 1);
  else if (genCache.has(childId)) childGen = genCache.get(childId);
  else if (UUID_RE.test(childId)) {
    const row = await tx.members.findFirst({
      where: { id: childId, tenant_id: tenantId, deleted_at: null },
      select: { generation: true },
    });
    childGen = row?.generation || null;
    genCache.set(childId, childGen);
  }
  return childGen && childGen > 1 ? childGen - 1 : null;
}

for (const draft of canvasDelta.draft_parents || []) {
  const created = await tx.members.create({
    data: {
      tenant_id: tenantId, full_name: String(draft.full_name).trim(),
      gender: draft.gender || (draft.role === 'FATHER' ? 'NAM' : 'NU'),
      birth_year: draft.birth_year || null, generation: await computeDraftParentGen(draft.id),
      status: 'CHINH_THUC', changed_by: actorId,
    },
  });
  auditQueue.push({
    tableName: 'members', recordId: created.id, action: 'TAO', tenantId, changedBy: actorId,
    correlationId, ticketId: proposal.id, oldData: null,
    newData: { full_name: created.full_name, status: 'CHINH_THUC' }, changeReason: 'Khai cha/mẹ mới',
  });
  idMap.set(draft.id, created.id);
}
for (const draft of canvasDelta.draft_spouses || []) {
  const created = await tx.members.create({
    data: {
      tenant_id: tenantId, full_name: String(draft.full_name).trim(), gender: draft.gender || null,
      birth_year: draft.birth_year || null, generation: freshSelf.generation || null,
      status: 'CHINH_THUC', changed_by: actorId,
    },
  });
  auditQueue.push({
    tableName: 'members', recordId: created.id, action: 'TAO', tenantId, changedBy: actorId,
    correlationId, ticketId: proposal.id, oldData: null,
    newData: { full_name: created.full_name, status: 'CHINH_THUC' }, changeReason: 'Khai vợ/chồng mới',
  });
  idMap.set(draft.id, created.id);
}
const childGen = freshSelf.generation ? freshSelf.generation + 1 : null;
for (const draft of canvasDelta.draft_children || []) {
  const created = await tx.members.create({
    data: {
      tenant_id: tenantId, full_name: String(draft.full_name).trim(), gender: draft.gender || null,
      birth_year: draft.birth_year || null, generation: childGen, status: 'CHINH_THUC', changed_by: actorId,
    },
  });
  auditQueue.push({
    tableName: 'members', recordId: created.id, action: 'TAO', tenantId, changedBy: actorId,
    correlationId, ticketId: proposal.id, oldData: null,
    newData: { full_name: created.full_name, status: 'CHINH_THUC' }, changeReason: 'Khai con mới',
  });
  idMap.set(draft.id, created.id);
}

for (const link of canvasDelta.link_parents || []) {
  const subjectId = link.subject_member_id || freshSelf.id;
  const field = link.role === 'MOTHER' ? 'mother_id' : 'father_id';
  const subject = await tx.members.findFirst({
    where: { id: subjectId, tenant_id: tenantId },
    select: { father_id: true, mother_id: true },
  });
  const oldParentId = link.role === 'MOTHER' ? subject?.mother_id : subject?.father_id;
  if (oldParentId && oldParentId !== link.target_member_id) {
    await tx.parentages.updateMany({
      where: { tenant_id: tenantId, parent_id: oldParentId, child_id: subjectId, deleted_at: null, is_selected_for_lineage: true },
      data: { is_selected_for_lineage: false, changed_by: actorId },
    });
  }
  await tx.members.updateMany({
    where: { id: subjectId, tenant_id: tenantId, deleted_at: null },
    data: { [field]: link.target_member_id, changed_by: actorId },
  });
  await upsertParentage(tx, {
    tenantId, parentId: link.target_member_id, childId: subjectId,
    relationshipType: 'BIOLOGICAL', actorId, correlationId, ticketId: proposal.id, auditQueue,
  });
}
for (const draft of canvasDelta.draft_parents || []) {
  const realParentId = resolveId(draft.id);
  const realChildId = resolveId(draft.child_ref_id);
  const field = draft.role === 'MOTHER' ? 'mother_id' : 'father_id';
  await tx.members.updateMany({
    where: { id: realChildId, tenant_id: tenantId, deleted_at: null },
    data: { [field]: realParentId, changed_by: actorId },
  });
  await upsertParentage(tx, {
    tenantId, parentId: realParentId, childId: realChildId,
    relationshipType: 'BIOLOGICAL', actorId, correlationId, ticketId: proposal.id, auditQueue,
  });
}

const spouseTargetByLinkId = new Map();
for (const link of canvasDelta.link_spouses || []) {
  const subjectId = link.subject_member_id || freshSelf.id;
  const subject = await tx.members.findFirst({ where: { id: subjectId, tenant_id: tenantId }, select: { gender: true } });
  const target = await tx.members.findFirst({ where: { id: link.target_member_id, tenant_id: tenantId }, select: { gender: true } });
  const husbandId = link.resolved_husband_id
    ? resolveId(link.resolved_husband_id)
    : (subject?.gender === 'NU' || target?.gender === 'NAM') ? link.target_member_id : subjectId;
  const wifeId = husbandId === subjectId ? link.target_member_id : subjectId;
  const marriage = await tx.marriages.create({
    data: { tenant_id: tenantId, husband_id: husbandId, wife_id: wifeId, status: 'DANG_KET_HON', changed_by: actorId },
  });
  auditQueue.push({
    tableName: 'marriages', recordId: marriage.id, action: 'TAO', tenantId, changedBy: actorId,
    correlationId, ticketId: proposal.id, oldData: null,
    newData: { husband_id: husbandId, wife_id: wifeId }, changeReason: 'Gắn vợ/chồng',
  });
  spouseTargetByLinkId.set(link.id, link.target_member_id);
}
for (const draft of canvasDelta.draft_spouses || []) {
  const realSpouseId = resolveId(draft.id);
  const husbandId = draft.resolved_husband_id
    ? resolveId(draft.resolved_husband_id)
    : (freshSelf.gender === 'NU' || draft.gender === 'NAM') ? realSpouseId : freshSelf.id;
  const wifeId = husbandId === freshSelf.id ? realSpouseId : freshSelf.id;
  const marriage = await tx.marriages.create({
    data: { tenant_id: tenantId, husband_id: husbandId, wife_id: wifeId, status: 'DANG_KET_HON', changed_by: actorId },
  });
  auditQueue.push({
    tableName: 'marriages', recordId: marriage.id, action: 'TAO', tenantId, changedBy: actorId,
    correlationId, ticketId: proposal.id, oldData: null,
    newData: { husband_id: husbandId, wife_id: wifeId }, changeReason: 'Khai vợ/chồng mới',
  });
}
for (const child of canvasDelta.draft_children || []) {
  const realChildId = resolveId(child.id);
  let fatherId = null;
  let motherId = null;
  if (!child.second_parent) {
    if (freshSelf.gender === 'NU') motherId = freshSelf.id;
    else fatherId = freshSelf.id;
  } else {
    const { source, ref_id, resolved_father_id } = child.second_parent;
    const realSecondId = source === 'LINK_SPOUSE' ? spouseTargetByLinkId.get(ref_id) : resolveId(ref_id);
    const second = await tx.members.findFirst({
      where: { id: realSecondId, tenant_id: tenantId },
      select: { gender: true },
    });
    fatherId = resolved_father_id
      ? resolveId(resolved_father_id)
      : (freshSelf.gender === 'NU' || second?.gender === 'NAM') ? realSecondId : freshSelf.id;
    motherId = fatherId === freshSelf.id ? realSecondId : freshSelf.id;
  }
  await tx.members.updateMany({
    where: { id: realChildId, tenant_id: tenantId, deleted_at: null },
    data: { father_id: fatherId, mother_id: motherId, changed_by: actorId },
  });
  if (fatherId) await upsertParentage(tx, { tenantId, parentId: fatherId, childId: realChildId, relationshipType: 'BIOLOGICAL', actorId, correlationId, ticketId: proposal.id, auditQueue });
  if (motherId) await upsertParentage(tx, { tenantId, parentId: motherId, childId: realChildId, relationshipType: 'BIOLOGICAL', actorId, correlationId, ticketId: proposal.id, auditQueue });
}
```

## 9. Kế hoạch triển khai

Bước 4 chạy song song với bước 2 và 3 ngay sau khi chốt contract mục 6. Bước 5 dựng UI trước, nối API khi bước 2 và 3 đã merge.

| Bước | File | Việc | Xong khi |
|---|---|---|---|
| 1 | `Backend/src/modules/genealogy/parentage.mapper.js` | Khôi phục cạnh soft-delete | Gắn lại không lỗi unique |
| 1 | `Backend/src/modules/mfo/mfo.payload.js` | 6 mảng luôn `[]`. Giữ trường lồng | Tờ cũ không crash |
| 2 | `Backend/src/modules/mfo/mfo.linkGuard.js` | Guard mục 10 | Case mục 11 pass |
| 2 | `Backend/src/modules/mfo/mfo.service.js` | Trình: `requireResolvedRoles: false`. Cửa 1: `true`, rồi lưu `payload` đã merge xuống DB. API cây trả `can_proxy_link: true` cho tổ tiên trực hệ chưa có link `DA_DUYET` | Thiếu vai không sang Cửa 2. Canvas có cờ nối giúp |
| 3 | `Backend/src/modules/mfo/mfo.gate2.js` | Mục 8, `requireResolvedRoles: true` | Không `ReferenceError` |
| 3 | `Backend/src/modules/admin/adminClanInit.service.js` | 4 API mục 12, chặn giới tính và vòng | `403` đúng mốc |
| 4 | `frontend/src/features/mfo/components/LinkExistingSheet.jsx` | Sheet chọn người | Không lộ SĐT, CCCD |
| 4 | `frontend/src/pages/OpMfoPlanPage.jsx` | Hai nhóm. `can_proxy_link` mở menu nối giúp. `ATTACH`/`MOVE` tự điền. Gỡ xong khai thay ngay | Gửi đúng JSON |
| 5 | `frontend/src/pages/AdminMfoPlanPage.jsx` | Bốn khối. Dropdown vai chỉ trên thẻ `link_spouses` và `draft_spouses` khi cả hai khuyết. Con nháp kế thừa, không chọn lại | E2E đủ |
| 5 | `frontend/src/pages/AdminClanInitPage.jsx` | Gọi 4 API mục 12 | Khóa đúng |

`GET /api/members?status=CHINH_THUC&q=` trả `id`, `full_name`, `generation`, `birth_year`, `death_year`, `father_name`, `spouse_name`.

## 10. Guard

Toàn bộ hàm nằm trong một khối. Copy vào `mfo.linkGuard.js`.

```js
const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

function fail(message) {
  const err = new Error(message);
  err.statusCode = 422;
  err.code = 'MFO_LINK_INVALID';
  throw err;
}
function assertUuid(value, message) {
  if (!value || !UUID_RE.test(value)) fail(message);
}
function assertNonEmptyName(name, label) {
  if (!name || !String(name).trim()) fail(`Thiếu họ tên cho ${label}.`);
}
function assertSpouseRoleResolution({
  personAId, personAGender, personBId, personBGender, resolvedHusbandId, requireResolvedRoles, label,
}) {
  const known = (g) => g === 'NAM' || g === 'NU';
  if (resolvedHusbandId) {
    if (resolvedHusbandId !== personAId && resolvedHusbandId !== personBId) {
      fail(`Vai đã chọn của ${label} không thuộc cặp.`);
    }
    const chosenGender = resolvedHusbandId === personAId ? personAGender : personBGender;
    const otherGender = resolvedHusbandId === personAId ? personBGender : personAGender;
    if (chosenGender === 'NU') fail(`Người Nữ không nhận vai chồng/cha cho ${label}.`);
    if (otherGender === 'NAM') fail(`Người Nam không nhận vai vợ/mẹ cho ${label}.`);
  } else if (requireResolvedRoles && !known(personAGender) && !known(personBGender)) {
    fail(`Cả hai bên chưa rõ giới tính. Cửa 1 phải chọn vai cho ${label}.`);
  }
}

function collectLockMemberIds(selfMemberId, canvasDelta) {
  const parentLinks = canvasDelta.link_parents || [];
  const parentUnlinks = canvasDelta.unlink_parents || [];
  const spouseLinks = canvasDelta.link_spouses || [];
  const draftParents = canvasDelta.draft_parents || [];
  const draftChildren = canvasDelta.draft_children || [];
  const draftParentIds = new Set(draftParents.map((d) => d.id));
  const ids = [
    selfMemberId,
    ...parentLinks.map((l) => l.subject_member_id || selfMemberId),
    ...parentLinks.map((l) => l.target_member_id),
    ...parentUnlinks.map((u) => u.subject_member_id || selfMemberId),
    ...spouseLinks.map((s) => s.subject_member_id || selfMemberId),
    ...spouseLinks.map((s) => s.target_member_id),
    ...draftParents.map((d) => d.child_ref_id).filter((id) => !draftParentIds.has(id)),
    ...draftChildren.filter((c) => c.second_parent?.source === 'EXISTING_MEMBER').map((c) => c.second_parent.ref_id),
  ];
  return [...new Set(ids)].filter((id) => UUID_RE.test(id)).sort();
}

async function collectAndAssertAcyclicAncestors(tx, {
  tenantId, startIds, rootSelfId, draftParentIds, effectiveFather, effectiveMother,
}) {
  const dbCache = new Map();
  const getParents = async (id) => {
    if (draftParentIds.has(id) || effectiveFather.has(id) || effectiveMother.has(id)) {
      return [effectiveFather.get(id), effectiveMother.get(id)].filter(Boolean);
    }
    if (!UUID_RE.test(id)) return [];
    if (!dbCache.has(id)) {
      const row = await tx.members.findFirst({
        where: { id, tenant_id: tenantId, deleted_at: null },
        select: { father_id: true, mother_id: true },
      });
      dbCache.set(id, row ? [row.father_id, row.mother_id].filter(Boolean) : []);
    }
    return dbCache.get(id);
  };
  const state = new Map();
  const dfs = async (nodeId) => {
    const st = state.get(nodeId) || 0;
    if (st === 1) fail('Quan hệ cha/mẹ tạo thành vòng.');
    if (st === 2) return;
    state.set(nodeId, 1);
    for (const parentId of await getParents(nodeId)) await dfs(parentId);
    state.set(nodeId, 2);
  };
  for (const id of startIds) await dfs(id);
  const ancestors = new Set([rootSelfId]);
  const queue = [rootSelfId];
  while (queue.length) {
    const current = queue.shift();
    for (const parentId of await getParents(current)) {
      if (!ancestors.has(parentId)) { ancestors.add(parentId); queue.push(parentId); }
    }
  }
  return ancestors;
}

async function isDirectLineagePair(tx, args) {
  const ofA = await collectAndAssertAcyclicAncestors(tx, { ...args, startIds: [args.memberA], rootSelfId: args.memberA });
  if (ofA.has(args.memberB)) return true;
  const ofB = await collectAndAssertAcyclicAncestors(tx, { ...args, startIds: [args.memberB], rootSelfId: args.memberB });
  return ofB.has(args.memberA);
}

async function validateMfoLinks(tx, { tenantId, selfMember, canvasDelta, requireResolvedRoles = false }) {
  const parentLinks = canvasDelta.link_parents || [];
  const parentUnlinks = canvasDelta.unlink_parents || [];
  const spouseLinks = canvasDelta.link_spouses || [];
  const draftParents = canvasDelta.draft_parents || [];
  const draftChildren = canvasDelta.draft_children || [];
  const draftSpouses = canvasDelta.draft_spouses || [];
  if (draftSpouses.length > 1) fail('Mỗi tờ chỉ khai một vợ/chồng mới.');

  const seenDraftIds = new Set();
  for (const draft of [...draftParents, ...draftSpouses, ...draftChildren]) {
    if (!draft.id || seenDraftIds.has(draft.id)) fail('Mã định danh thành viên nháp bị thiếu hoặc trùng.');
    seenDraftIds.add(draft.id);
  }
  for (const draft of draftParents) assertNonEmptyName(draft.full_name, 'cha/mẹ khai mới');
  for (const draft of draftSpouses) assertNonEmptyName(draft.full_name, 'vợ/chồng khai mới');
  for (const draft of draftChildren) assertNonEmptyName(draft.full_name, 'con khai mới');

  for (const link of parentLinks) {
    if (link.subject_member_id) assertUuid(link.subject_member_id, 'Mã thành viên cần gắn không hợp lệ.');
    assertUuid(link.target_member_id, 'Mã cha/mẹ được chọn không hợp lệ.');
  }
  for (const unlink of parentUnlinks) {
    if (unlink.subject_member_id) assertUuid(unlink.subject_member_id, 'Mã thành viên cần gỡ không hợp lệ.');
    if (unlink.expected_target_member_id) assertUuid(unlink.expected_target_member_id, 'Mã cha/mẹ đối chiếu không hợp lệ.');
  }
  for (const link of spouseLinks) {
    if (link.subject_member_id) assertUuid(link.subject_member_id, 'Mã thành viên cần gắn hôn phối không hợp lệ.');
    assertUuid(link.target_member_id, 'Mã vợ/chồng được chọn không hợp lệ.');
  }
  for (const child of draftChildren) {
    if (child.second_parent?.source === 'EXISTING_MEMBER') {
      assertUuid(child.second_parent.ref_id, 'Mã cha/mẹ thứ hai của con nháp không hợp lệ.');
    }
  }

  const draftParentIds = new Set(draftParents.map((d) => d.id));
  const activeAssignKeys = new Set();
  for (const link of parentLinks) {
    const key = `${link.subject_member_id || selfMember.id}:${link.role}`;
    if (activeAssignKeys.has(key)) fail('Mỗi vai chỉ một người.');
    activeAssignKeys.add(key);
  }
  for (const draft of draftParents) {
    if (!draft.id || !draft.child_ref_id) fail('Thiếu định danh cha/mẹ nháp hoặc người con.');
    if (!draftParentIds.has(draft.child_ref_id)) assertUuid(draft.child_ref_id, 'Tham chiếu người con của cha/mẹ nháp không hợp lệ.');
    if (draft.role === 'FATHER' && draft.gender === 'NU') fail('Cha khai mới không thể là Nữ.');
    if (draft.role === 'MOTHER' && draft.gender === 'NAM') fail('Mẹ khai mới không thể là Nam.');
    const key = `${draft.child_ref_id}:${draft.role}`;
    if (activeAssignKeys.has(key)) fail('Không vừa gắn đã có vừa khai mới cùng một vai.');
    activeAssignKeys.add(key);
  }
  for (const unlink of parentUnlinks) {
    const subjectId = unlink.subject_member_id || selfMember.id;
    if (parentLinks.some((l) => (l.subject_member_id || selfMember.id) === subjectId && l.role === unlink.role)) {
      fail('Không vừa gắn đã có vừa gỡ cùng một vai. Hãy dùng Đổi.');
    }
  }

  const existingChildRefs = draftParents.map((d) => d.child_ref_id).filter((id) => !draftParentIds.has(id));
  const existingSubjectIds = new Set([
    selfMember.id,
    ...parentLinks.map((l) => l.subject_member_id || selfMember.id),
    ...parentUnlinks.map((u) => u.subject_member_id || selfMember.id),
    ...spouseLinks.map((s) => s.subject_member_id || selfMember.id),
    ...existingChildRefs,
  ]);
  const subjects = await tx.members.findMany({
    where: { id: { in: [...existingSubjectIds] }, tenant_id: tenantId, status: 'CHINH_THUC', deleted_at: null },
    select: { id: true, gender: true, father_id: true, mother_id: true },
  });
  const subjectMap = new Map(subjects.map((m) => [m.id, m]));
  const approvedLinks = await tx.user_member_links.findMany({
    where: { member_id: { in: [...existingSubjectIds] }, tenant_id: tenantId, status: 'DA_DUYET', deleted_at: null },
    select: { member_id: true },
  });
  const hasAccount = new Set(approvedLinks.map((l) => l.member_id));
  for (const subjectId of existingSubjectIds) {
    const subject = subjectMap.get(subjectId);
    if (!subject) fail('Người cần cập nhật không còn trên sổ.');
    if (subject.id !== selfMember.id && hasAccount.has(subject.id)) fail('Không sửa người đã có tài khoản.');
  }

  const effectiveFather = new Map(subjects.map((s) => [s.id, s.father_id]));
  const effectiveMother = new Map(subjects.map((s) => [s.id, s.mother_id]));
  for (const unlink of parentUnlinks) {
    const subject = subjectMap.get(unlink.subject_member_id || selfMember.id);
    const current = unlink.role === 'MOTHER' ? subject.mother_id : subject.father_id;
    if (!current) fail('Chưa có cha/mẹ để gỡ.');
    if (unlink.expected_target_member_id && current !== unlink.expected_target_member_id) fail('Cha/mẹ đã đổi. Tải lại canvas.');
    if (unlink.role === 'FATHER') effectiveFather.set(subject.id, null);
    if (unlink.role === 'MOTHER') effectiveMother.set(subject.id, null);
  }
  for (const draft of draftParents) {
    if (!draftParentIds.has(draft.child_ref_id)) {
      const current = draft.role === 'MOTHER' ? effectiveMother.get(draft.child_ref_id) : effectiveFather.get(draft.child_ref_id);
      if (current) fail('Đã có cha/mẹ. Phải gỡ trước khi khai mới.');
    }
    if (draft.role === 'FATHER') effectiveFather.set(draft.child_ref_id, draft.id);
    if (draft.role === 'MOTHER') effectiveMother.set(draft.child_ref_id, draft.id);
  }
  for (const link of parentLinks) {
    const subject = subjectMap.get(link.subject_member_id || selfMember.id);
    if (!link.target_member_id || link.target_member_id === subject.id) fail('Không chọn chính mình.');
    const current = link.role === 'MOTHER' ? subject.mother_id : subject.father_id;
    if (link.expected_mode === 'ATTACH' && current) fail('Đã có cha/mẹ. Tải lại canvas.');
    if (link.expected_mode === 'MOVE' && !current) fail('Chưa có cha/mẹ để đổi.');
    if (current && current === link.target_member_id) fail('Người được chọn đã là cha/mẹ hiện tại.');
    const target = await tx.members.findFirst({
      where: { id: link.target_member_id, tenant_id: tenantId, status: 'CHINH_THUC', deleted_at: null },
      select: { id: true, gender: true },
    });
    if (!target) fail('Người được chọn không còn trên sổ.');
    if (link.role === 'FATHER' && target.gender === 'NU') fail('Cha không thể là Nữ.');
    if (link.role === 'MOTHER' && target.gender === 'NAM') fail('Mẹ không thể là Nam.');
    if (link.role === 'FATHER') effectiveFather.set(subject.id, target.id);
    if (link.role === 'MOTHER') effectiveMother.set(subject.id, target.id);
  }

  const ancestorSet = await collectAndAssertAcyclicAncestors(tx, {
    tenantId, startIds: [...existingSubjectIds, ...draftParentIds], rootSelfId: selfMember.id,
    draftParentIds, effectiveFather, effectiveMother,
  });
  for (const id of [...existingSubjectIds, ...draftParentIds]) {
    if (!ancestorSet.has(id)) fail('Người được nối phải nằm trên tuyến trực hệ của bạn.');
  }

  const seenSpousePairs = new Set();
  const validSelfSpouseLinkMap = new Map();
  const spouseHusbandByLinkId = new Map();
  for (const link of spouseLinks) {
    const subject = subjectMap.get(link.subject_member_id || selfMember.id);
    if (!link.target_member_id || link.target_member_id === subject.id) fail('Không chọn chính mình.');
    const pairKey = [subject.id, link.target_member_id].sort().join(':');
    if (seenSpousePairs.has(pairKey)) fail('Trùng yêu cầu gắn cùng một vợ/chồng.');
    seenSpousePairs.add(pairKey);
    const target = await tx.members.findFirst({
      where: { id: link.target_member_id, tenant_id: tenantId, status: 'CHINH_THUC', deleted_at: null },
      select: { id: true, gender: true, father_id: true, mother_id: true },
    });
    if (!target) fail('Người được chọn không còn trên sổ.');
    if (subject.gender && target.gender && subject.gender === target.gender) fail('Hai bên cùng giới tính đã biết.');
    assertSpouseRoleResolution({
      personAId: subject.id, personAGender: subject.gender, personBId: target.id, personBGender: target.gender,
      resolvedHusbandId: link.resolved_husband_id, requireResolvedRoles, label: 'vợ/chồng xin gắn',
    });
    const direct = await isDirectLineagePair(tx, {
      tenantId, memberA: subject.id, memberB: target.id, draftParentIds, effectiveFather, effectiveMother,
    });
    if (direct) fail('Không gắn vợ/chồng giữa tổ tiên và hậu duệ.');
    const subjectFather = effectiveFather.get(subject.id);
    const subjectMother = effectiveMother.get(subject.id);
    const targetFather = effectiveFather.has(target.id) ? effectiveFather.get(target.id) : target.father_id;
    const targetMother = effectiveMother.has(target.id) ? effectiveMother.get(target.id) : target.mother_id;
    if ((subjectFather && subjectFather === targetFather) || (subjectMother && subjectMother === targetMother)) {
      fail('Không gắn vợ/chồng giữa anh chị em cùng cha hoặc cùng mẹ.');
    }
    const existingMarriage = await tx.marriages.findFirst({
      where: {
        tenant_id: tenantId, deleted_at: null,
        OR: [{ husband_id: subject.id, wife_id: target.id }, { husband_id: target.id, wife_id: subject.id }],
      },
      select: { id: true },
    });
    if (existingMarriage) fail('Hai người đã có hôn phối trên sổ.');
    if (subject.id === selfMember.id) validSelfSpouseLinkMap.set(link.id, target);
    if (link.resolved_husband_id) spouseHusbandByLinkId.set(link.id, link.resolved_husband_id);
  }

  const draftSpouse = draftSpouses[0] || null;
  if (draftSpouse) {
    if (selfMember.gender && draftSpouse.gender && selfMember.gender === draftSpouse.gender) {
      fail('Vợ/chồng khai mới không được cùng giới tính đã biết.');
    }
    assertSpouseRoleResolution({
      personAId: selfMember.id, personAGender: selfMember.gender, personBId: draftSpouse.id, personBGender: draftSpouse.gender,
      resolvedHusbandId: draftSpouse.resolved_husband_id, requireResolvedRoles, label: 'vợ/chồng khai mới',
    });
  }

  for (const child of draftChildren) {
    if (!child.second_parent) continue;
    const { source, ref_id } = child.second_parent;
    let secondGender = null;
    let husbandId = null;
    if (source === 'LINK_SPOUSE') {
      const linked = validSelfSpouseLinkMap.get(ref_id);
      if (!linked) fail('Cha/mẹ thứ hai không khớp vợ/chồng đang xin gắn.');
      secondGender = linked.gender;
      husbandId = spouseHusbandByLinkId.get(ref_id);
    } else if (source === 'DRAFT_SPOUSE') {
      if (!draftSpouse || draftSpouse.id !== ref_id) fail('Cha/mẹ thứ hai không khớp vợ/chồng đang khai mới.');
      secondGender = draftSpouse.gender;
      husbandId = draftSpouse.resolved_husband_id;
    } else if (source === 'EXISTING_MEMBER') {
      const marriage = await tx.marriages.findFirst({
        where: {
          tenant_id: tenantId, deleted_at: null,
          OR: [{ husband_id: selfMember.id, wife_id: ref_id }, { husband_id: ref_id, wife_id: selfMember.id }],
        },
        select: { id: true, husband_id: true },
      });
      if (!marriage) fail('Cha/mẹ thứ hai phải đang có hôn phối với bạn.');
      const spouse = await tx.members.findFirst({
        where: { id: ref_id, tenant_id: tenantId, status: 'CHINH_THUC', deleted_at: null },
        select: { gender: true },
      });
      if (!spouse) fail('Người được chọn không còn trên sổ.');
      secondGender = spouse.gender;
      husbandId = marriage.husband_id;
    } else fail('Nguồn cha/mẹ thứ hai không hợp lệ.');
    let effectiveResolvedFatherId = child.second_parent.resolved_father_id || null;
    if (husbandId) {
      if (effectiveResolvedFatherId && effectiveResolvedFatherId !== husbandId) fail('Vai cha của con không khớp vai chồng.');
      if (!effectiveResolvedFatherId) effectiveResolvedFatherId = husbandId;
    }
    child.second_parent.resolved_father_id = effectiveResolvedFatherId;
    if (selfMember.gender && secondGender && selfMember.gender === secondGender) fail('Cha và mẹ của con nháp không được cùng giới tính.');
    assertSpouseRoleResolution({
      personAId: selfMember.id, personAGender: selfMember.gender, personBId: ref_id, personBGender: secondGender,
      resolvedHusbandId: effectiveResolvedFatherId, requireResolvedRoles, label: 'cha/mẹ của con nháp',
    });
  }
}

async function computeGate1Warnings(tx, { tenantId, selfMember, canvasDelta }) {
  const warnings = [];
  const parentLinks = canvasDelta.link_parents || [];
  const parentUnlinks = canvasDelta.unlink_parents || [];
  const spouseLinks = canvasDelta.link_spouses || [];
  const unlinked = new Set(parentUnlinks.map((u) => `${u.subject_member_id || selfMember.id}:${u.role}`));
  for (const link of parentLinks) {
    if (link.expected_mode === 'MOVE') warnings.push({ code: 'BRANCH_MOVE', subject_member_id: link.subject_member_id || selfMember.id, role: link.role });
  }
  for (const unlink of parentUnlinks) {
    const subjectId = unlink.subject_member_id || selfMember.id;
    const childCount = await tx.members.count({
      where: { tenant_id: tenantId, deleted_at: null, OR: [{ father_id: subjectId }, { mother_id: subjectId }] },
    });
    if (childCount > 0) warnings.push({ code: 'UNLINK_HAS_DESCENDANTS', subject_member_id: subjectId, role: unlink.role, child_count: childCount });
  }
  for (const link of spouseLinks) {
    const other = await tx.marriages.findFirst({
      where: {
        tenant_id: tenantId, deleted_at: null, status: 'DANG_KET_HON',
        OR: [{ husband_id: link.target_member_id }, { wife_id: link.target_member_id }],
      },
      select: { id: true },
    });
    if (other) warnings.push({ code: 'SPOUSE_HAS_OTHER_MARRIAGE', target_member_id: link.target_member_id });
  }
  const subjectIds = new Set([selfMember.id, ...parentLinks.map((l) => l.subject_member_id || selfMember.id)]);
  for (const subjectId of subjectIds) {
    const subject = await tx.members.findFirst({
      where: { id: subjectId, tenant_id: tenantId, deleted_at: null },
      select: { father_id: true, mother_id: true },
    });
    if (!subject) continue;
    const fatherLink = parentLinks.find((l) => (l.subject_member_id || selfMember.id) === subjectId && l.role === 'FATHER');
    const motherLink = parentLinks.find((l) => (l.subject_member_id || selfMember.id) === subjectId && l.role === 'MOTHER');
    const fatherId = fatherLink ? fatherLink.target_member_id : (unlinked.has(`${subjectId}:FATHER`) ? null : subject.father_id);
    const motherId = motherLink ? motherLink.target_member_id : (unlinked.has(`${subjectId}:MOTHER`) ? null : subject.mother_id);
    if (fatherId && motherId && (fatherLink || motherLink)) {
      const married = await tx.marriages.findFirst({
        where: {
          tenant_id: tenantId, deleted_at: null,
          OR: [{ husband_id: fatherId, wife_id: motherId }, { husband_id: motherId, wife_id: fatherId }],
        },
        select: { id: true },
      });
      if (!married) warnings.push({ code: 'PARENTS_NOT_MARRIED', subject_member_id: subjectId, father_id: fatherId, mother_id: motherId });
    }
  }
  return warnings;
}

module.exports = { validateMfoLinks, computeGate1Warnings, collectLockMemberIds };
```

## 11. Nghiệm thu

* Cửa 1 quên chọn vai khi cả hai khuyết giới tính thì `422`, không sang Cửa 2.
* `resolved_husband_id` không thuộc cặp hoặc trỏ người Nữ thì bị chặn.
* EU trình khung vẫn được để vai null.
* Cửa 2 không `ReferenceError`.
* Id nháp trùng hoặc tên rỗng trả `422`.
* Gỡ và tạo hôn phối có audit.
* Node tổ tiên chưa có tài khoản có `can_proxy_link: true`.
* `/admin` không tạo cha là Nữ, không tạo vòng.

## 12. Khởi tạo sổ trong /admin

File backend `Backend/src/modules/admin/adminClanInit.service.js`. File frontend `frontend/src/pages/AdminClanInitPage.jsx`. Chỉ CLAN_ADMIN của đúng họ. Cả bốn API trả `403` khi có từ 2 `user_member_links` `DA_DUYET`.

| Method | Path | Body |
|---|---|---|
| POST | `/api/admin/clan-init/members` | `{ full_name, gender, birth_year, generation, father_id?, mother_id?, spouse_id?, husband_id? }` |
| PATCH | `/api/admin/clan-init/members/:id` | `{ full_name?, gender?, birth_year?, father_id?, mother_id?, generation? }` |
| POST | `/api/admin/clan-init/members/:id/unlink` | `{ type: "FATHER" \| "MOTHER" \| "MARRIAGE", marriage_id?: "<uuid>" }` |
| DELETE | `/api/admin/clan-init/members/:id` | Không body. `422` nếu còn con hoặc còn hôn phối |

POST và PATCH kiểm tra cha không phải Nữ, mẹ không phải Nam, không tạo vòng. Nếu có `spouse_id` mà cả hai khuyết giới tính, dùng `husband_id`. Không có thì người đang tạo là chồng. Ghi `CHINH_THUC`, dual-write `parentages`, có audit. PATCH nhận thêm `father_id`, `mother_id`, `generation` để nối node đã tạo, không bắt xóa rồi tạo lại.

Sau mốc đóng, lối này khóa. Mọi việc đi MFO.

## 13. Đã chốt

* Người Nữ không nhận vai chồng. Người Nam không nhận vai vợ.
* Đổi sang chính cha/mẹ đang gắn bị từ chối.
* Cửa 1 chỉ nhận key vai khớp id đang có, lưu payload đã merge xuống DB.
* Tạo member nháp có audit.
* PATCH khởi tạo sổ được nối cha/mẹ sau khi đã tạo node.
* API cây trả `can_proxy_link`.
* Không mở sửa node bất kỳ.
