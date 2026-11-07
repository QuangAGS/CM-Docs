# BE MFO Full-Set v2 — Union, Child Provenance & Avatar Contract

- **Version:** 1.0.0
- **Status:** Proposed for approval before implementation
- **Date:** 2026-10-02
- **Scope:** MFO genealogy read/write boundary affected by `members.parent_union_id`
- **Audience:** Backend, frontend, database, QA
- **Primary principle:** Database and backend are the source of truth; frontend renders an explicit contract and does not infer family business rules.

---

## 1. Purpose

This document defines the stable backend/API contract required after the database migration that adds:

```text
members.parent_union_id -> marriages.id
```

The objective is to provide a Full-Set read model that supports:

- Fixed MFO 5-level window (`depth: 0..4`)
- Standard Tree (ST) boundaries
- Multiple marriages / multiple spouses
- Interactive Card / Tabs View
- Exact child grouping by marriage union
- Historical marriages, including divorce and separation
- Avatar projection from the `media` metadata table and Cloudflare R2 delivery
- Mobile-first React Flow rendering without frontend genealogy inference

This is a backend/API contract document. It does not prescribe a particular frontend library implementation.

---

## 2. Scope and non-scope

### In scope

- `GET /api/mfo/origins/:originId/full-set?k=<0..4>` read model
- `members.parent_union_id` semantics
- `marriages` read policy
- `standard_trees`, `marriage_tabs`, and `unassigned_children`
- Avatar URL projection from `media`
- MFO member create/edit validation for `parent_union_id`
- Error codes and integration tests

### Out of scope

- Changing the existing marriage data model
- Adding `family_units` or `family_unit_children`
- Frontend canvas geometry, React Flow implementation, or ELK/Dagre configuration
- Complete media upload implementation
- Global member profile APIs that are not part of MFO Full-Set

---

## 3. Canonical terminology

| Term | Meaning |
|---|---|
| Target member / M | Member selected by the End User and placed at `selected_depth` |
| `k` / `selected_depth` | Absolute MFO canvas depth of M, integer from 0 to 4 |
| Origin / root node | Furthest valid ancestor found within `selected_depth` upward steps; not necessarily at depth 0 |
| Union | One `marriages` record, identified by `marriages.id` |
| Parent union | Marriage union referenced by `members.parent_union_id` |
| Standard Tree (ST) | Family cluster with one owner/member at depth `d`, spouse/partners, and children at `d + 1` |
| Marriage tab | Read-model tab representing one union owned by a member within an ST |
| Unassigned child | Direct child inside an ST whose `parent_union_id` is missing, invalid, or not owned by the ST owner |
| Genealogy parentage | `members.father_id` and `members.mother_id` |
| Marriage lifecycle | `marriages.status`; never determines whether a child exists |

### Compatibility warning

The legacy endpoint parameter is named `:originId`, but it receives the ID of the selected target member M.

```text
GET /mfo/origins/:originId/full-set?k=3
```

In this endpoint:

```text
:req.params.originId = target member ID
response.data.origin.id = actual root ancestor ID
```

Do not assume these values are identical.

---

## 4. Core business invariants

### 4.1 Fixed five-level window

```text
levels.length === 5
levels[0].depth === 0
levels[1].depth === 1
levels[2].depth === 2
levels[3].depth === 3
levels[4].depth === 4
```

No rendered member node may have a depth outside `0..4`.

### 4.2 Target position is absolute

```text
target.actual_depth === target.selected_depth === k
```

Missing ancestors must leave upper levels empty. Missing ancestors must not move M upward.

```text
root_depth = selected_depth - actual_ancestor_steps
```

### 4.3 Parent-child relation is independent of marriage status

A child remains associated with a parent union even if the union is:

```text
DANG_KET_HON
GOA
LY_HON
LY_THAN
KHAC
```

A marriage lifecycle change must not remove a child from genealogy or from a historical marriage tab.

### 4.4 Parent union semantics

```text
members.parent_union_id
```

- Is nullable.
- References `marriages.id`.
- Identifies the union/family provenance used to group the child in MFO Tabs View.
- Does not replace `father_id` or `mother_id`.
- Must not be inferred or written by the frontend.
- Must be validated by backend write paths.

### 4.5 Sibling boundary

Sibling ordering has meaning only within a single parent union/tab/ST child collection.

```text
Same depth != sibling
Same level.nodes[] != sibling
Same marriage_tabs[union].children[] = sibling group
```

Backend orders children by:

```text
1. sibling_seq ascending
2. birth_year ascending
3. full_name Vietnamese locale ascending
```

Frontend must preserve array order and must not re-sort with a different rule.

---

## 5. Marriage read policy

### 5.1 Full-Set must not filter by marriage status

For genealogy/full-set reads, query all non-deleted marriages of the tenant:

```js
const unions = await prisma.marriages.findMany({
  where: {
    tenant_id: targetMember.tenant_id,
    deleted_at: null,
  },
  select: {
    id: true,
    husband_id: true,
    wife_id: true,
    husband_marriage_order: true,
    wife_marriage_order: true,
    status: true,
    start_date: true,
    end_date: true,
    spouse_name_literal: true,
    note: true,
  },
});
```

Do not use this old filter in `getFullMfoSet`:

```js
status: { in: ['DANG_KET_HON', 'GOA'] }
```

### 5.2 Why status is not filtered

```text
Child parentage/provenance = durable genealogy fact
Marriage status             = lifecycle/history fact
```

Example:

```text
Union U1: A | B
status: LY_HON

Child X:
father_id       = A
mother_id       = B
parent_union_id = U1
```

`U1` must remain in Full-Set and Tabs View with badge `LY_HON`; child X must remain under U1.

### 5.3 Operational/current-union policy is separate

Some write screens may choose an eligible subset of unions for new data entry. That operational policy must not affect genealogy reads.

| Use case | Status filter allowed? |
|---|---:|
| Full-Set / genealogy graph | No |
| Tree export / historical view | No |
| Interactive marriage tabs | No |
| Member profile historical marriages | No |
| Default union for new child input | Yes, by explicit workflow policy |
| Duplicate active couple validation | Yes |
| Current spouse summary | Yes |

---

## 6. Database assumptions

### 6.1 Members

The database contains:

```sql
members.parent_union_id varchar(36) null
  references marriages(id)
  on delete set null;
```

An index must exist:

```sql
create index idx_members_parent_union
on members(parent_union_id);
```

### 6.2 Marriages

`marriages.id` is the union identity used for:

```text
- members.parent_union_id
- marriage_tabs[].union_id
- tab React key
- child grouping
- union audit/history
```

### 6.3 Media

Avatar metadata remains SSOT in `media`:

```text
entity_type = MEMBER
entity_id   = members.id
purpose     = AVATAR
is_primary  = true
deleted_at  = null
```

Do not add `members.avatar_url` as a second storage field.

---

## 7. Full-Set v2 response contract

### 7.1 Compatibility policy

The API remains on the existing endpoint during the compatibility window:

```text
GET /api/mfo/origins/:originId/full-set?k=<0..4>
```

Existing fields remain available:

```text
levels
nodes
standard_trees[].parent
standard_trees[].children
standard_trees[].child_count
partners[]
```

New consumers must prefer:

```text
standard_trees[].marriage_tabs
standard_trees[].unassigned_children
member.parent_union_id
member.avatar_url
```

### 7.2 Member node projection

Every packed member or member-backed partner may include:

```ts
type MfoMemberNode = {
  id: string | null;
  full_name: string | null;
  gender: string | null;
  is_clan: boolean;

  father_id: string | null;
  mother_id: string | null;
  parent_union_id: string | null;

  sibling_seq: number | null;
  birth_year: number | null;
  child_type: string | null;

  avatar_url: string | null;

  depth: 0 | 1 | 2 | 3 | 4;
  role: 'clan_member' | 'partner';
  position: 'left' | 'right';

  is_origin?: boolean;
  is_target?: boolean;
};
```

### 7.3 Standard tree extension

```ts
type MarriageTab = {
  union_id: string;
  marriage_order: number | null;
  union_status: string | null;

  partner: MfoMemberNode;

  children: Array<{
    member: MfoMemberNode;
    partners: MfoMemberNode[];
  }>;

  child_count: number;
};

type UnassignedChild = {
  member: MfoMemberNode;
  partners: MfoMemberNode[];
  reason:
    | 'PARENT_UNION_UNSET'
    | 'PARENT_UNION_NOT_OWNED_BY_ST'
    | 'PARENT_UNION_NOT_FOUND';
};

type StandardTree = {
  id: string;
  depth: number;
  kind: 'standard_tree';

  parent: {
    member: MfoMemberNode;
    partners: MfoMemberNode[];
  };

  // Compatibility only; do not use as Tabs View source.
  children: Array<{
    member: MfoMemberNode;
    partners: MfoMemberNode[];
  }>;
  child_count: number;

  // Canonical Tabs View source.
  marriage_tabs: MarriageTab[];
  unassigned_children: UnassignedChild[];
};
```

### 7.4 Example payload fragment

```json
{
  "id": "st:2:member-a",
  "depth": 2,
  "parent": {
    "member": {
      "id": "member-a",
      "full_name": "Nguyễn Văn A",
      "avatar_url": "/api/media/members/member-a/avatar?v=abc"
    },
    "partners": []
  },
  "marriage_tabs": [
    {
      "union_id": "union-u1",
      "marriage_order": 1,
      "union_status": "LY_HON",
      "partner": {
        "id": "member-b",
        "full_name": "Bà B",
        "role": "partner",
        "position": "right"
      },
      "children": [
        {
          "member": {
            "id": "child-x",
            "parent_union_id": "union-u1",
            "sibling_seq": 1
          },
          "partners": []
        }
      ],
      "child_count": 1
    }
  ],
  "unassigned_children": []
}
```

---

## 8. Full-Set backend implementation requirements

### 8.1 Member select fields

Every member select used by `getFullMfoSet` must include:

```js
parent_union_id: true,
```

This applies to both:

```text
targetMember query
all members query
```

### 8.2 Pack member

`packMember()` must expose:

```js
parent_union_id: member?.parent_union_id || null,
avatar_url: resolveMemberAvatarUrl(member, avatarByMemberId),
```

### 8.3 Union map

Build an ID map from all non-deleted unions:

```js
const unionById = new Map(
  unions.map((union) => [union.id, union])
);
```

### 8.4 Marriage tabs

For an ST owner, get owner unions in owner-specific marriage order. For each union:

```text
Tab U owns child C when:
C.parent_union_id === U.id
```

Do not infer membership from `father_id` and `mother_id` at frontend.

### 8.5 Unassigned children

A direct child of the ST owner is unassigned if:

```text
- parent_union_id is null
- parent_union_id does not exist in active non-deleted tenant unions
- parent_union_id belongs to a union not owned by the ST owner
```

Return such children explicitly under `unassigned_children`. Never place them into the first tab or active tab by default.

### 8.6 Partner geometry

In Full-Set response:

```text
role: 'clan_member' -> position: 'left'
role: 'partner'     -> position: 'right'
```

`is_clan` is a data classification/badge. It must not move a partner to the left side.

---

## 9. Avatar/media projection

### 9.1 Payload rule

Return a render-ready URL only:

```json
{
  "avatar_url": "/api/media/members/<memberId>/avatar?v=<version>"
}
```

Do not return:

```text
- base64 image content
- raw R2 object bytes
- raw R2 credentials
- storage_key to frontend as a rendering contract
```

### 9.2 Batch query requirement

Full-Set must query avatar rows in batch, never N+1 per tree node.

```js
const avatarRows = await prisma.media.findMany({
  where: {
    tenant_id: targetMember.tenant_id,
    entity_type: 'MEMBER',
    entity_id: { in: all.map((member) => member.id) },
    purpose: 'AVATAR',
    is_primary: true,
    deleted_at: null,
  },
  select: {
    entity_id: true,
    file_url: true,
    storage_key: true,
    checksum: true,
    mime_type: true,
    width: true,
    height: true,
    updated_at: true,
  },
});
```

### 9.3 Delivery policy

The project must choose one media delivery policy before implementation:

| Policy | Payload URL | Use when |
|---|---|---|
| Private gateway | `/api/media/members/:id/avatar?v=...` | Avatar is tenant-private/PII |
| Public custom domain | `https://media.example.com/...` | Avatar may be Internet-public by policy |

Default recommendation for multi-tenant genealogy:

```text
Private R2 bucket + authenticated media gateway.
```

### 9.4 Media integrity recommendation

Consider a partial unique index if policy allows only one primary avatar per member:

```sql
CREATE UNIQUE INDEX IF NOT EXISTS uq_media_member_primary_avatar
ON public.media (tenant_id, entity_type, entity_id)
WHERE purpose = 'AVATAR'
  AND is_primary = true
  AND deleted_at IS NULL;
```

---

## 10. Write-path contract

### 10.1 createInPlan

Child creation may accept:

```json
{
  "parent_union_id": "marriage-uuid"
}
```

Backend must validate the final tuple:

```text
father_id
mother_id
parent_union_id
child_type
```

and write `parent_union_id` atomically with the member record.

### 10.2 patchMemberInPlan

If any of these fields changes:

```text
father_id
mother_id
parent_union_id
child_type
```

the service must validate the final combined state in one transaction. It must not validate fields independently and leave an inconsistent tuple.

### 10.3 createSpouse

When a marriage is created, backend may fill `parent_union_id` only for a child that:

```text
- currently has parent_union_id = null
- has parent IDs exactly matching the new union
- is not an ambiguous special-case child
```

Existing non-null `parent_union_id` must never be overwritten automatically.

---

## 11. Parent union validation

### 11.1 Minimum validation

For a non-null `parent_union_id`:

```text
1. Union exists.
2. Union belongs to same tenant as member.
3. Union is not soft-deleted.
4. Child type policy permits attachment.
5. For ordinary child, union matches father/mother.
```

### 11.2 Ordinary child exact-match rule

For `CON_DE`:

```text
union.husband_id === child.father_id
AND
union.wife_id === child.mother_id
```

### 11.3 Special child policy

The following types may be allowed with explicit workflow/audit policy when exact biological match is not available:

```text
CON_NUOI
CON_RIENG
KHAC
```

`CON_DAU` and `CON_RE` are affinal/spouse roles. They must not be automatically attached as a child of a parent union merely because they appear beside a clan member.

### 11.4 Suggested helper

```js
async function resolveParentUnion({
  tenantId,
  parentUnionId,
  fatherId,
  motherId,
  childType,
}) {
  if (!parentUnionId) {
    return null;
  }

  const union = await prisma.marriages.findFirst({
    where: {
      id: parentUnionId,
      tenant_id: tenantId,
      deleted_at: null,
    },
    select: {
      id: true,
      husband_id: true,
      wife_id: true,
      status: true,
    },
  });

  if (!union) {
    fail(
      'Không tìm thấy hôn phối cha/mẹ hợp lệ.',
      404,
      'MFO_PARENT_UNION_NOT_FOUND'
    );
  }

  const exactParentMatch =
    String(union.husband_id || '') ===
      String(fatherId || '') &&
    String(union.wife_id || '') ===
      String(motherId || '');

  const specialChild = [
    'CON_NUOI',
    'CON_RIENG',
    'KHAC',
  ].includes(String(childType || ''));

  if (!exactParentMatch && !specialChild) {
    fail(
      'Hôn phối không khớp cha/mẹ của thành viên.',
      422,
      'MFO_PARENT_UNION_PARENT_MISMATCH'
    );
  }

  return union;
}
```

No filter by marriage status is allowed in this helper. A historical union may be a valid parent union.

---

## 12. Error contract

| HTTP | Code | Meaning |
|---:|---|---|
| 400 | `MFO_ORIGIN_REQUIRED` | Target member ID missing |
| 400 | `MFO_INVALID_SELECTED_DEPTH` | `k` is not an integer from 0 to 4 |
| 400 | `MFO_PARENT_UNION_INVALID` | Parent union input format/policy invalid |
| 401 | `UNAUTHENTICATED` | Authentication required |
| 403 | `TENANT_MISMATCH` | Target, parent, union, or media belongs to another tenant |
| 404 | `MFO_ORIGIN_NOT_FOUND` | Target member not found or soft-deleted |
| 404 | `MFO_PARENT_UNION_NOT_FOUND` | Parent union not found or soft-deleted |
| 422 | `MFO_PARENT_UNION_PARENT_MISMATCH` | Union does not match ordinary child parentage |
| 422 | `MFO_PARENT_UNION_NOT_ALLOWED` | Child type/workflow policy disallows attachment |
| 409 | `MFO_PARENT_UNION_LOCKED` | Change denied after workflow freeze/approval |
| 500 | `MFO_INTERNAL_ERROR` | Unexpected backend error |

---

## 13. Test matrix

### 13.1 Read model

| Case | Expected result |
|---|---|
| M at depth 0 | Target stays at 0 |
| M at depth 3 with two ancestors | Root depth 1, level 0 empty, target depth 3 |
| Active union with child | Child appears in matching marriage tab |
| Divorced union with child | Historical tab remains; child remains assigned |
| Widowed union with child | Tab remains; child remains assigned |
| Separated union with child | Tab remains; child remains assigned |
| Multiple spouse, child per union | Each tab includes only its own `parent_union_id` children |
| Child union null | Child returned in `unassigned_children` |
| Child union not owned by ST | Child returned in `unassigned_children` with reason |
| Literal spouse union | Tab renders partner literal safely |
| Partner with member avatar | `avatar_url` returned |
| No avatar | `avatar_url: null` |

### 13.2 Write validation

| Case | Expected result |
|---|---|
| CON_DE with exact union-parent match | Accept |
| CON_DE with mismatch | 422 `MFO_PARENT_UNION_PARENT_MISMATCH` |
| CON_NUOI with approved exception policy | Accept with audit/reason |
| Cross-tenant union | Reject with tenant error |
| Soft-deleted union | 404 parent union not found |
| Change after approved/frozen state | 409 locked |
| New spouse union fills null child union only | No overwrite of non-null provenance |

### 13.3 Performance

| Case | Expected result |
|---|---|
| Full-Set with 50 members | Constant number of member/marriage/media queries, no avatar N+1 |
| Multiple avatars corruptly primary | Deterministic newest row or database uniqueness policy |
| Concurrent requests | Read-only full-set, no shared mutable state |

---

## 14. Implementation order

```text
1. Run prisma validate/generate after the completed parent_union_id migration.
2. Patch getFullMfoSet selects and packMember:
   - parent_union_id
   - all non-deleted marriages, no status filter
   - batch avatar media projection.
3. Add marriage_tabs and unassigned_children read projection.
4. Patch createInPlan and patchMemberInPlan validation/write paths.
5. Patch createSpouse only for safe null-to-known parent_union assignment.
6. Add integration tests and JSON fixtures.
7. Review actual Full-Set v2 payload.
8. Patch frontend adapter and React Flow Tabs View.
9. Deprecate frontend child-to-union inference.
```

---

## 15. Definition of done

The backend/API work is complete only when:

- Full-Set contains all non-deleted marriage statuses.
- Every child exposes `parent_union_id`.
- `marriage_tabs[].children` is grouped only by explicit `parent_union_id`.
- Unresolved children are explicit, never guessed.
- Avatar URLs are batch-projected from `media` without exposing R2 implementation details.
- All write paths validate parent union tenant, deletion, and parentage policy.
- Integration tests cover historical marriages, multiple unions, null union provenance, and media/avatar behavior.
- Frontend can render tabs and edges without any genealogy inference.
