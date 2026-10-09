# BE MFO Full-Set v2 — Union, Child Provenance & Avatar Contract

- **Version:** 1.1.0
- **Status:** Proposed for approval before implementation
- **Date:** 2026-10-02
- **Supersedes:** `BE-MFO-FULL-SET-V2-UNION-CHILD-AVATAR-CONTRACT-v1.0.0`
- **Scope:** MFO genealogy read/write boundary affected by `members.parent_union_id`
- **Audience:** Backend, frontend, database, QA
- **Primary principle:** Database and backend are the source of truth; frontend renders an explicit contract and does not infer family business rules.

---

## 1. Purpose

This document defines the backend/API contract required after the database migration that adds:

```text
members.parent_union_id -> marriages.id
```

The objective is to provide a Full-Set read model that supports:

- Fixed MFO five-level canvas window (`depth: 0..4`)
- Standard Tree (ST) boundaries
- Multiple marriages / multiple spouses
- Interactive Card / Tabs View
- Exact child grouping by marriage union
- Historical marriages, including divorce, widowhood, and separation
- Avatar projection from the `media` metadata table and Cloudflare R2 delivery
- Mobile-first React Flow rendering without frontend genealogy inference

This is a backend/API contract document. It does not prescribe a specific frontend library implementation.

---

## 2. Scope and non-scope

### In scope

- `GET /api/mfo/origins/:targetMemberId/full-set?selected_canvas_depth=<0..4>` read model
- `members.parent_union_id` semantics
- `marriages` read and tab ordering policy
- `standard_trees`, `marriage_tabs`, and `unassigned_children`
- Avatar URL projection from `media`
- MFO member create/edit validation for `parent_union_id`
- Explicit exception workflow for `CON_NUOI` and `CON_RIENG`
- Error codes and integration/contract tests

### Out of scope

- Changing the current marriage data model
- Adding `family_units` or `family_unit_children`
- Frontend canvas geometry, React Flow implementation, or ELK/Dagre configuration
- Complete media upload implementation
- Global member profile APIs that are not part of MFO Full-Set
- Founder/tree-context API when no target member has been selected

---

## 3. Canonical terminology

| Term | Meaning |
|---|---|
| Target member / M | Member selected by the End User and rendered in the MFO canvas |
| `selected_canvas_depth` | Requested absolute render position of M in the five-level MFO canvas, integer 0 to 4 |
| `rendered_canvas_depth` | Actual position of M in the returned canvas; must equal `selected_canvas_depth` |
| `resolved_ancestor_steps` | Number of valid consecutive ancestor steps found from M upward, capped by `selected_canvas_depth` |
| `root_canvas_depth` | Canvas position of the furthest resolved ancestor: `selected_canvas_depth - resolved_ancestor_steps` |
| `members.generation` | Domain/sổ-gia-phả generation field; independent of any MFO canvas depth and never used to position nodes |
| Origin / root node | Furthest valid ancestor found within `selected_canvas_depth` upward steps; not necessarily at canvas depth 0 |
| Union | One `marriages` record, identified by `marriages.id` |
| Parent union | Marriage union referenced by `members.parent_union_id` |
| Standard Tree (ST) | Family cluster with one owner/member at depth `d`, partners, and children at `d + 1` |
| ST owner | `standard_trees[].parent.member`; determines which union order field is used for tab sorting |
| Marriage tab | Read-model tab representing one union owned by an ST owner |
| Literal union | Union that uses `spouse_name_literal` and lacks one spouse member endpoint (`husband_id` or `wife_id`) |
| Unassigned child | Direct child inside an ST whose `parent_union_id` is missing, invalid, or not owned by the ST owner |
| Genealogy parentage | `members.father_id` and `members.mother_id` |
| Marriage lifecycle | `marriages.status`; never determines whether a child exists |
| Parent-union exception | Explicit approved workflow allowing permitted special-child attachment when biological parentage does not exactly match a union |

### Naming and compatibility note

The legacy route parameter may currently be named `:originId`, but it receives the selected target member M. It must be renamed in new route/controller code and documentation to `:targetMemberId`.

```text
Legacy route:
GET /mfo/origins/:originId/full-set?k=3

Canonical route/meaning:
GET /api/mfo/origins/:targetMemberId/full-set?selected_canvas_depth=3
```

In either compatibility form:

```text
Route parameter      = target member ID
response.origin.id   = actual resolved root ancestor ID
```

Do not assume these values are identical.

---

## 4. Core business invariants

### 4.1 Fixed five-level canvas

```text
levels.length === 5
levels[0].depth === 0
levels[1].depth === 1
levels[2].depth === 2
levels[3].depth === 3
levels[4].depth === 4
```

No rendered member node may have a canvas depth outside `0..4`.

### 4.2 Target position is a canvas position

```text
target.rendered_canvas_depth === target.selected_canvas_depth
```

The target must not be pulled upward if one or more ancestors are missing.

```text
root_canvas_depth
  = selected_canvas_depth - resolved_ancestor_steps
```

`rendered_canvas_depth`, `selected_canvas_depth`, and `root_canvas_depth` describe only positions inside the current MFO five-level canvas. They are not equivalent to `members.generation`, an absolute genealogy generation number, or any founder-relative generation number.

Example:

```text
selected_canvas_depth = 3
resolved_ancestor_steps = 2
root_canvas_depth = 1
rendered_canvas_depth = 3
```

Result:

```text
depth 0: empty
depth 1: furthest resolved ancestor
depth 2: parent
depth 3: target M
depth 4: child layer of M
```

### 4.3 Parent-child relation is independent of marriage status

A child remains associated with a parent union even if the union status is:

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
- Identifies the union/family provenance used to group a child in MFO Tabs View.
- Does not replace `father_id` or `mother_id`.
- Must not be inferred or written by frontend code.
- Must be validated by backend write paths.
- Must not reference a literal union under v1.1 policy.

### 4.5 Sibling boundary

Sibling ordering has meaning only within one parent union/tab/ST child collection.

```text
Same depth != sibling
Same level.nodes[] != sibling
Same marriage_tabs[union].children[] = sibling group
```

Backend orders tab children by:

```text
1. sibling_seq ascending, nulls last
2. birth_year ascending, nulls last
3. full_name Vietnamese locale ascending
4. member id ascending as deterministic final fallback
```

Frontend must preserve the returned order and must not apply an independent sort.

### 4.6 Full-Set always requires a target

This endpoint is target-bound:

```text
GET /api/mfo/origins/:targetMemberId/full-set
```

No target is represented by a request without a valid target member ID; it is not represented by `selected_canvas_depth = null`.

```text
No selected target -> do not call this endpoint, or return 400 MFO_ORIGIN_REQUIRED.
```

Tree/founder metadata independent of M must be fetched from a distinct tree-context API when required.

---

## 5. Canvas depth and tree/founder context

### 5.1 Canonical Full-Set input and response fields

```ts
type FullSetRequest = {
  targetMemberId: string;
  selected_canvas_depth: 0 | 1 | 2 | 3 | 4;
};

type FullSetTarget = {
  member_id: string;
  selected_canvas_depth: 0 | 1 | 2 | 3 | 4;
  rendered_canvas_depth: 0 | 1 | 2 | 3 | 4;
  resolved_ancestor_steps: number;
};

type FullSetOrigin = {
  id: string;
  root_canvas_depth: 0 | 1 | 2 | 3 | 4;
  is_founder: boolean | null;
};
```

Required invariant:

```text
target.rendered_canvas_depth === target.selected_canvas_depth
origin.root_canvas_depth
  === target.selected_canvas_depth - target.resolved_ancestor_steps
```

### 5.2 Founder context is a separate concern

Do not overload `k`, `selected_canvas_depth`, `generation`, or target depth to mean whether a founder exists.

When tree-level context is needed, use explicit fields in a separate endpoint or response shell:

```ts
type TreeContext = {
  tree_id: string;
  has_founder: boolean;
  founder_member_id: string | null;
};
```

```text
has_founder       = tree-level business metadata
origin.is_founder = whether resolved Full-Set root is identified as founder
generation        = member domain field
canvas depth      = temporary render coordinate
```

These fields have distinct meanings and must never be substituted for one another.

---

## 6. Marriage read and tab ordering policy

### 6.1 Full-Set must not filter by marriage status

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

Do not use the following filter in `getFullMfoSet`:

```js
status: { in: ['DANG_KET_HON', 'GOA'] }
```

### 6.2 Why status is not filtered

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

`U1` remains in Full-Set and Tabs View with `union_status: LY_HON`; child X remains under U1.

### 6.3 Owner-specific tab sort order

A marriage tab is sorted by the marriage order of the ST owner, not by a fixed husband-side field.

```text
If ST owner ID === union.husband_id:
  owner_marriage_order = union.husband_marriage_order

If ST owner ID === union.wife_id:
  owner_marriage_order = union.wife_marriage_order
```

Backend returns the resolved field:

```ts
type MarriageTab = {
  union_id: string;
  owner_marriage_order: number | null;
  union_status: string | null;
  // remaining fields
};
```

Frontend must sort neither by `husband_marriage_order` nor by `wife_marriage_order`; it must preserve the backend `marriage_tabs[]` order.

When owner order is null, backend applies this deterministic fallback:

```text
1. owner_marriage_order ascending, nulls last
2. start_date ascending, nulls last
3. union id ascending
```

Reference helper:

```js
function getOwnerMarriageOrder(union, ownerId) {
  if (String(union.husband_id || '') === String(ownerId || '')) {
    return union.husband_marriage_order ?? null;
  }

  if (String(union.wife_id || '') === String(ownerId || '')) {
    return union.wife_marriage_order ?? null;
  }

  return null;
}
```

### 6.4 Operational/current-union policy is separate

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

## 7. Literal spouse policy

### 7.1 Policy decision

A literal union is displayable but cannot be used as `members.parent_union_id` in v1.1.

A literal union is one where:

```text
spouse_name_literal is present
AND one union endpoint is not a canonical member ID
```

`parent_union_id` requires a canonical two-member union:

```text
husband_id IS NOT NULL
AND wife_id IS NOT NULL
```

### 7.2 Reasoning

A literal spouse does not provide enough canonical identity to enforce exact matching between:

```text
members.father_id
members.mother_id
marriages.husband_id
marriages.wife_id
```

Allowing “one side matches and the other is literal text” would make child provenance ambiguous, especially when one owner has several historical literal unions. The purpose of `parent_union_id` is to remove, not introduce, this ambiguity.

### 7.3 Full-Set representation

Literal unions remain visible in `marriage_tabs[]`:

```json
{
  "union_id": "union-literal-001",
  "owner_marriage_order": 2,
  "union_status": "GOA",
  "partner": {
    "id": null,
    "full_name": "Bà Trần Thị B",
    "role": "partner",
    "position": "right",
    "source": "literal"
  },
  "children": [],
  "child_count": 0,
  "supports_parent_union_assignment": false
}
```

Frontend may hide or disable child-assignment UI for this tab. Backend remains the final enforcement layer.

### 7.4 Future canonicalization

If a literal spouse must become eligible as a parent-union endpoint later, create or match a canonical member record, link the union to that member ID, preserve audit information, and run a dedicated migration/workflow. Do not bypass the v1.1 rule with a text-name exception.

---

## 8. Database assumptions

### 8.1 Members

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

### 8.2 Marriages

`marriages.id` is the union identity used for:

```text
- members.parent_union_id
- marriage_tabs[].union_id
- tab React key
- child grouping
- union audit/history
```

### 8.3 Media

Avatar metadata remains the source of truth in `media`:

```text
entity_type = MEMBER
entity_id   = members.id
purpose     = AVATAR
is_primary  = true
deleted_at  = null
```

Do not add `members.avatar_url` as a second storage field.

---

## 9. Full-Set v2 response contract

### 9.1 Compatibility policy

The API may remain on the existing endpoint during the compatibility window:

```text
GET /api/mfo/origins/:targetMemberId/full-set?selected_canvas_depth=<0..4>
```

For legacy callers only, the following aliases may be accepted temporarily:

```text
:originId                 -> :targetMemberId
k                          -> selected_canvas_depth
```

Responses must use only canonical field names in newly added sections.

Existing legacy fields remain available during the compatibility window:

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

### 9.2 Target and origin projection

```ts
type MfoTarget = {
  member_id: string;
  selected_canvas_depth: 0 | 1 | 2 | 3 | 4;
  rendered_canvas_depth: 0 | 1 | 2 | 3 | 4;
  resolved_ancestor_steps: number;
};

type MfoOrigin = {
  id: string;
  root_canvas_depth: 0 | 1 | 2 | 3 | 4;
  is_founder: boolean | null;
};
```

### 9.3 Member node projection

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

### 9.4 Standard tree extension

```ts
type MarriageTab = {
  union_id: string;
  owner_marriage_order: number | null;
  union_status: string | null;
  supports_parent_union_assignment: boolean;

  partner: MfoMemberNode & {
    source?: 'member' | 'literal';
  };

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
    | 'PARENT_UNION_NOT_FOUND'
    | 'PARENT_UNION_LITERAL_NOT_ASSIGNABLE';
};

type StandardTree = {
  id: string;
  depth: number;
  kind: 'standard_tree';

  parent: {
    member: MfoMemberNode;
    partners: MfoMemberNode[];
  };

  // Compatibility only; never use as Tabs View grouping source.
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

### 9.5 Example payload fragment

```json
{
  "target": {
    "member_id": "member-a",
    "selected_canvas_depth": 2,
    "rendered_canvas_depth": 2,
    "resolved_ancestor_steps": 1
  },
  "origin": {
    "id": "member-parent-a",
    "root_canvas_depth": 1,
    "is_founder": false
  },
  "standard_trees": [
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
          "owner_marriage_order": 1,
          "union_status": "LY_HON",
          "supports_parent_union_assignment": true,
          "partner": {
            "id": "member-b",
            "full_name": "Bà B",
            "role": "partner",
            "position": "right",
            "source": "member"
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
  ]
}
```

---

## 10. Full-Set backend implementation requirements

### 10.1 Member select fields

Every member select used by `getFullMfoSet` must include:

```js
parent_union_id: true,
```

This applies to both:

```text
targetMember query
all members query
```

### 10.2 Pack member

`packMember()` must expose:

```js
parent_union_id: member?.parent_union_id || null,
avatar_url: resolveMemberAvatarUrl(member, avatarByMemberId),
```

### 10.3 Union map

Build an ID map from all non-deleted tenant unions:

```js
const unionById = new Map(
  unions.map((union) => [union.id, union])
);
```

### 10.4 Ownership and marriage tabs

For an ST owner, get all unions where the owner is `husband_id` or `wife_id`; include literal unions for display.

For each canonical union:

```text
Tab U owns child C when:
C.parent_union_id === U.id
```

Do not infer tab ownership from `father_id` and `mother_id` in frontend code.

Sort tabs by `owner_marriage_order` resolved from the ST owner side as defined in §6.3.

### 10.5 Unassigned children

A direct child of an ST owner is unassigned if:

```text
- parent_union_id is null
- parent_union_id does not exist in active non-deleted tenant unions
- parent_union_id belongs to a union not owned by the ST owner
- parent_union_id references a literal/non-assignable union (legacy/corrupt data)
```

Return such children explicitly under `unassigned_children`. Never place them into the first tab, active tab, or a guessed matching tab by default.

### 10.6 Partner geometry

In Full-Set response:

```text
role: 'clan_member' -> position: 'left'
role: 'partner'     -> position: 'right'
```

`is_clan` is a classification/badge; it must not move a partner to the left side.

---

## 11. Avatar/media projection

### 11.1 Payload rule

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
- storage_key as a frontend rendering contract
```

### 11.2 Batch query requirement

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

### 11.3 Delivery policy

The project must choose one media delivery policy before implementation:

| Policy | Payload URL | Use when |
|---|---|---|
| Private gateway | `/api/media/members/:id/avatar?v=...` | Avatar is tenant-private/PII |
| Public custom domain | `https://media.example.com/...` | Avatar may be Internet-public by policy |

Default recommendation for multi-tenant genealogy:

```text
Private R2 bucket + authenticated media gateway.
```

### 11.4 Media integrity recommendation

If policy permits only one primary avatar per member, add:

```sql
CREATE UNIQUE INDEX IF NOT EXISTS uq_media_member_primary_avatar
ON public.media (tenant_id, entity_type, entity_id)
WHERE purpose = 'AVATAR'
  AND is_primary = true
  AND deleted_at IS NULL;
```

---

## 12. Write-path contract

### 12.1 createInPlan

Child creation may accept:

```json
{
  "parent_union_id": "marriage-uuid",
  "parent_union_assignment": {
    "mode": "NORMAL"
  }
}
```

For a permitted mismatch exception, the request must explicitly declare exception intent:

```json
{
  "child_type": "CON_NUOI",
  "parent_union_id": "marriage-uuid",
  "parent_union_assignment": {
    "mode": "EXCEPTION",
    "reason_code": "ADOPTED_INTO_UNION",
    "reason_note": "Được nhận nuôi trong thời kỳ hôn phối"
  }
}
```

The authenticated backend actor is the authority for `approved_by`; the client must not supply an approver identity.

Backend validates the final tuple atomically:

```text
father_id
mother_id
parent_union_id
child_type
parent_union_assignment
```

### 12.2 patchMemberInPlan

If any of these fields changes:

```text
father_id
mother_id
parent_union_id
child_type
parent_union_assignment
```

the service validates the final combined state in one transaction. It must not validate fields independently and leave an inconsistent tuple.

### 12.3 createSpouse

When a marriage is created, backend may fill `parent_union_id` only for a child that:

```text
- currently has parent_union_id = null
- has canonical parent IDs exactly matching the new union
- has child_type allowed for normal assignment
- is not an ambiguous special-case child
```

Existing non-null `parent_union_id` must never be overwritten automatically.

No automatic assignment is permitted to a literal union.

---

## 13. Parent union validation

### 13.1 Minimum validation

For a non-null `parent_union_id`:

```text
1. Union exists.
2. Union belongs to the same tenant as member.
3. Union is not soft-deleted.
4. Union is canonical; it has both husband_id and wife_id.
5. Child type policy permits attachment.
6. For ordinary child, union exactly matches father/mother.
7. For special-child mismatch, an explicit authorized exception is present.
```

### 13.2 Ordinary child exact-match rule

For `CON_DE`:

```text
union.husband_id === child.father_id
AND
union.wife_id === child.mother_id
```

A mismatch returns:

```text
422 MFO_PARENT_UNION_PARENT_MISMATCH
```

### 13.3 Prohibited relation types

`CON_DAU` and `CON_RE` are affinal/spouse roles. They must never be attached to a parent union as a child placement.

```text
422 MFO_PARENT_UNION_NOT_ALLOWED
```

### 13.4 Special-child exception policy

`CON_NUOI`, `CON_RIENG`, and `KHAC` may be assigned to a canonical union under the following rules:

```text
Exact parent match:
- NORMAL assignment is allowed.

Parent mismatch:
- EXCEPTION assignment is mandatory.
- parent_union_assignment.mode must equal EXCEPTION.
- reason_code must belong to the approved allow-list.
- authenticated actor must hold the required permission.
- backend writes an audit record with actor, timestamp, prior state, final state, reason code, and reason note.
```

The backend must not treat a special child type alone as blanket authorization for a mismatching union.

Suggested reason codes:

```text
ADOPTED_INTO_UNION
STEPCHILD_ACCEPTED_INTO_UNION
HISTORICAL_RECORD_RECONCILIATION
OTHER_APPROVED
```

`OTHER_APPROVED` requires a non-empty `reason_note`.

### 13.5 Reference validation logic

```js
async function resolveParentUnion({
  tenantId,
  parentUnionId,
  fatherId,
  motherId,
  childType,
  assignment,
  actor,
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
      spouse_name_literal: true,
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

  const isCanonicalUnion = Boolean(
    union.husband_id && union.wife_id
  );

  if (!isCanonicalUnion) {
    fail(
      'Hôn phối có phối ngẫu dạng văn bản không thể dùng làm nguồn gốc cha/mẹ.',
      422,
      'MFO_PARENT_UNION_LITERAL_SPOUSE_NOT_ALLOWED'
    );
  }

  const forbiddenChildType = [
    'CON_DAU',
    'CON_RE',
  ].includes(String(childType || ''));

  if (forbiddenChildType) {
    fail(
      'Loại quan hệ này không được gắn vào hôn phối với vai trò con.',
      422,
      'MFO_PARENT_UNION_NOT_ALLOWED'
    );
  }

  const exactParentMatch =
    String(union.husband_id) === String(fatherId || '') &&
    String(union.wife_id) === String(motherId || '');

  if (exactParentMatch) {
    return union;
  }

  const exceptionChildType = [
    'CON_NUOI',
    'CON_RIENG',
    'KHAC',
  ].includes(String(childType || ''));

  if (!exceptionChildType) {
    fail(
      'Hôn phối không khớp cha/mẹ của thành viên.',
      422,
      'MFO_PARENT_UNION_PARENT_MISMATCH'
    );
  }

  if (assignment?.mode !== 'EXCEPTION') {
    fail(
      'Cần khai báo ngoại lệ khi gắn quan hệ con không khớp cha/mẹ.',
      422,
      'MFO_PARENT_UNION_EXCEPTION_REQUIRED'
    );
  }

  validateExceptionReason(assignment);
  assertActorCanApproveParentUnionException(actor);

  return union;
}
```

No filter by marriage status is allowed in this helper. A historical canonical union can be a valid parent union.

---

## 14. Error contract

| HTTP | Code | Meaning |
|---:|---|---|
| 400 | `MFO_ORIGIN_REQUIRED` | Target member ID missing |
| 400 | `MFO_INVALID_SELECTED_CANVAS_DEPTH` | Depth is not an integer from 0 to 4 |
| 400 | `MFO_PARENT_UNION_INVALID` | Parent union input format invalid |
| 401 | `UNAUTHENTICATED` | Authentication required |
| 403 | `TENANT_MISMATCH` | Target, parent, union, or media belongs to another tenant |
| 403 | `MFO_PARENT_UNION_EXCEPTION_FORBIDDEN` | Actor cannot approve/submit the requested exception workflow |
| 404 | `MFO_ORIGIN_NOT_FOUND` | Target member not found or soft-deleted |
| 404 | `MFO_PARENT_UNION_NOT_FOUND` | Parent union not found or soft-deleted |
| 409 | `MFO_PARENT_UNION_LOCKED` | Change denied after workflow freeze/approval |
| 422 | `MFO_PARENT_UNION_PARENT_MISMATCH` | Canonical union does not match ordinary child parentage |
| 422 | `MFO_PARENT_UNION_NOT_ALLOWED` | Child type/workflow cannot attach to a parent union |
| 422 | `MFO_PARENT_UNION_LITERAL_SPOUSE_NOT_ALLOWED` | A literal/non-canonical union cannot be a parent union |
| 422 | `MFO_PARENT_UNION_EXCEPTION_REQUIRED` | Special-child mismatch lacks explicit exception workflow |
| 422 | `MFO_PARENT_UNION_EXCEPTION_INVALID` | Exception reason/mode/note is invalid |
| 500 | `MFO_INTERNAL_ERROR` | Unexpected backend error |

---

## 15. Test matrix

### 15.1 Canvas and read model

| Case | Expected result |
|---|---|
| M at selected depth 0 | Target rendered at 0 |
| M at selected depth 3 with two resolved ancestors | Root canvas depth 1; level 0 empty; target remains at 3 |
| `members.generation` differs from selected depth | Layout still follows canvas depth only |
| Request without target | 400 `MFO_ORIGIN_REQUIRED` |
| Active union with child | Child appears in matching marriage tab |
| Divorced union with child | Historical tab remains; child remains assigned |
| Widowed union with child | Tab remains; child remains assigned |
| Separated union with child | Tab remains; child remains assigned |
| Multiple spouse, child per union | Each tab includes only matching `parent_union_id` children |
| Male ST owner | Tabs ordered by `husband_marriage_order` |
| Female ST owner | Tabs ordered by `wife_marriage_order` |
| Missing marriage order | Stable fallback `start_date`, then union ID |
| Child union null | Child returned in `unassigned_children` with `PARENT_UNION_UNSET` |
| Child union not owned by ST | Child returned in `unassigned_children` with owner mismatch reason |
| Literal spouse union | Tab renders safely with `supports_parent_union_assignment: false` |
| Legacy child points to literal union | Child is unassigned with literal-not-assignable reason |
| Partner with member avatar | `avatar_url` returned |
| No avatar | `avatar_url: null` |

### 15.2 Write validation

| Case | Expected result |
|---|---|
| CON_DE with exact canonical union-parent match | Accept NORMAL assignment |
| CON_DE with parent mismatch | 422 `MFO_PARENT_UNION_PARENT_MISMATCH` |
| CON_NUOI with exact match | Accept NORMAL assignment |
| CON_NUOI mismatch without exception | 422 `MFO_PARENT_UNION_EXCEPTION_REQUIRED` |
| CON_NUOI mismatch with approved exception and reason | Accept and create audit record |
| CON_RIENG mismatch without exception | 422 `MFO_PARENT_UNION_EXCEPTION_REQUIRED` |
| CON_RE with parent union | 422 `MFO_PARENT_UNION_NOT_ALLOWED` |
| CON_DAU with parent union | 422 `MFO_PARENT_UNION_NOT_ALLOWED` |
| Literal union as parent union | 422 `MFO_PARENT_UNION_LITERAL_SPOUSE_NOT_ALLOWED` |
| Cross-tenant union | Reject with tenant error |
| Soft-deleted union | 404 parent union not found |
| Change after approved/frozen state | 409 locked |
| New spouse union fills null child union only | No overwrite of non-null provenance |
| Auto-assignment candidate is literal union | Do not assign |

### 15.3 Performance and data integrity

| Case | Expected result |
|---|---|
| Full-Set with 50 members | Constant number of member/marriage/media queries; no avatar N+1 |
| Multiple corrupt primary avatars | Deterministic newest row or unique-index enforcement |
| Concurrent Full-Set requests | Read-only; no shared mutable state |
| Child with unknown legacy `parent_union_id` | Explicit unassigned child; no guessed reassignment |

---

## 16. Implementation order

```text
1. Run prisma validate/generate after the completed parent_union_id migration.
2. Rename/document canonical Full-Set query parameter:
   - selected_canvas_depth
   - retain k alias only during compatibility window.
3. Patch getFullMfoSet selects and packMember:
   - parent_union_id
   - all non-deleted marriages, no status filter
   - batch avatar media projection.
4. Implement owner-side union ordering and return owner_marriage_order.
5. Implement literal-union display-only behavior and assignment rejection.
6. Add marriage_tabs and unassigned_children read projection.
7. Patch createInPlan and patchMemberInPlan:
   - final-state tuple validation
   - CON_DAU/CON_RE rejection
   - explicit exception workflow/audit for CON_NUOI, CON_RIENG, KHAC.
8. Patch createSpouse only for safe canonical null-to-known parent_union assignment.
9. Add integration tests, contract tests, and JSON fixtures.
10. Review actual Full-Set v2 payload with BE/FE/QA.
11. Patch frontend adapter and React Flow Tabs View.
12. Remove/deprecate frontend child-to-union inference after compatibility window.
```

---

## 17. Definition of done

The backend/API work is complete only when:

- Full-Set contains all non-deleted marriage statuses.
- Every child exposes `parent_union_id`.
- Canvas positions are clearly separate from `members.generation` and founder/tree metadata.
- `marriage_tabs[]` are sorted with the correct owner-side marriage order.
- `marriage_tabs[].children` is grouped only by explicit `parent_union_id`.
- Literal unions are visible but cannot be used as parent-union provenance.
- Unresolved or invalid children are explicit, never guessed.
- `CON_DAU` and `CON_RE` parent-union assignments consistently return `422 MFO_PARENT_UNION_NOT_ALLOWED`.
- Mismatching `CON_NUOI`, `CON_RIENG`, and `KHAC` assignments require explicit authorized exception workflow and audit records.
- Avatar URLs are batch-projected from `media` without exposing R2 implementation details.
- All write paths validate tenant, deletion state, canonical union endpoints, parentage, child type, exception permissions, and workflow locks.
- Integration and contract tests cover historical marriages, multiple unions, owner-side sorting, null/invalid union provenance, literal spouse behavior, special-child exceptions, canvas-depth semantics, and media/avatar behavior.
- Frontend can render tabs, nodes, and edges without genealogy inference.
