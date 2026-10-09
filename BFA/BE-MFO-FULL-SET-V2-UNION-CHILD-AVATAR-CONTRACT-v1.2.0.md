# BE MFO Full-Set v2 — Union, Child Provenance & Avatar Contract

- **Version:** 1.2.0
- **Status:** Proposed for approval before implementation
- **Date:** 2026-10-02
- **Supersedes:** `BE-MFO-FULL-SET-V2-UNION-CHILD-AVATAR-CONTRACT-v1.1.0`
- **Scope:** MFO genealogy read/write boundary affected by `members.parent_union_id`
- **Audience:** Backend, frontend, database, QA
- **Primary principle:** Database and backend are the source of truth; frontend renders an explicit contract and does not infer family business rules.

---

## Changelog v1.2.0

- Removed `origin.is_founder` from Full-Set. A resolved MFO window root is not necessarily the founder of a declaration sheet (tờ khai)/lot.
- Declaration-sheet founder identity is outside Full-Set and must use explicit tờ-khai fields such as `has_lot_founder` and `lot_founder_member_id`.
- Kept `KHAC` eligible for an explicit parent-union exception, but any mismatching `KHAC` assignment now requires a non-empty `reason_note`.
- Retained `/origins/:targetMemberId` as canonical. `:originId` and `k` are compatibility aliases only during the documented transition window.

---

## 1. Purpose

This document defines the backend/API contract after the database migration that adds:

```text
members.parent_union_id -> marriages.id
```

It provides a Full-Set read model for a fixed five-level MFO canvas, Standard Tree boundaries, multiple marriages, interactive tabs, exact child grouping by union, historical marriages, and batch avatar projection from the `media` metadata table and Cloudflare R2 delivery.

The backend is the source of truth. Frontend code renders explicit data and must not infer genealogy rules from visual position, parent IDs, marriage status, or a guessed active tab.

---

## 2. Scope

### In scope

- `GET /api/mfo/origins/:targetMemberId/full-set?selected_canvas_depth=<0..4>`
- `members.parent_union_id` semantics
- Marriage read policy and owner-specific tab sort order
- `standard_trees`, `marriage_tabs`, and `unassigned_children`
- Avatar URL projection from `media`
- Validation in MFO create/edit paths
- Explicit exception workflow for `CON_NUOI`, `CON_RIENG`, and constrained `KHAC`
- Error contract and integration/contract tests

### Out of scope

- Marriage-table redesign or new `family_units` tables
- React Flow/ELK/Dagre layout implementation
- Full media-upload implementation
- Non-MFO profile APIs
- Declaration-sheet/tờ-khai founder semantics; those belong to declaration-sheet APIs, not Full-Set

---

## 3. Canonical terminology

| Term | Meaning |
|---|---|
| Target member / M | The End User-selected member rendered in the MFO canvas |
| `selected_canvas_depth` | Requested canvas position of M, integer 0 to 4 |
| `rendered_canvas_depth` | Actual canvas position of M; always equals selected depth |
| `resolved_ancestor_steps` | Consecutive valid ancestor steps found upward from M, capped by selected depth |
| `root_canvas_depth` | Furthest resolved ancestor position: `selected_canvas_depth - resolved_ancestor_steps` |
| `members.generation` | Domain/sổ-gia-phả field, independent of any canvas depth |
| Origin/root node | Furthest valid ancestor within the requested MFO window; not a declaration-sheet founder claim |
| Lot founder / người lập tờ | Declaration-sheet business identity only; never inferred from Full-Set root |
| Union | One `marriages` record identified by `marriages.id` |
| Parent union | Union referenced by `members.parent_union_id` |
| Standard Tree / ST | Family cluster owned by one member with partners and child layer |
| Marriage tab | Read projection of one union owned by ST owner |
| Literal union | `spouse_name_literal` union lacking a canonical member endpoint |
| Unassigned child | Direct child not safely groupable into one owner tab |
| Parent-union exception | Explicit, authorized workflow for special-child parentage mismatch |

### Route compatibility

Canonical route:

```text
GET /api/mfo/origins/:targetMemberId/full-set?selected_canvas_depth=3
```

Compatibility aliases may remain temporarily:

```text
:originId -> :targetMemberId
k         -> selected_canvas_depth
```

The route parameter is the target member ID. `response.origin.id` is the resolved MFO-window root and can differ from the target.

---

## 4. Core invariants

### 4.1 Fixed canvas

```text
levels.length === 5
levels[0..4].depth === 0..4
no rendered member depth outside 0..4
```

### 4.2 Canvas depth is not genealogy generation

```text
target.rendered_canvas_depth === target.selected_canvas_depth
origin.root_canvas_depth
  === target.selected_canvas_depth - target.resolved_ancestor_steps
```

Missing ancestors leave upper levels empty; they never pull M upward.

Example:

```text
selected_canvas_depth = 3
resolved_ancestor_steps = 2
root_canvas_depth = 1

level 0: empty
level 1: furthest resolved ancestor
level 2: parent
level 3: M
level 4: child layer
```

Canvas fields are not `members.generation`, not a founder-relative generation, and not a declaration-sheet founder indicator.

### 4.3 Full-Set requires a target

```text
No selected target -> do not call Full-Set
Missing target ID  -> 400 MFO_ORIGIN_REQUIRED
```

Do not represent “no target” with `selected_canvas_depth = null`.

### 4.4 Marriage status does not remove genealogy

Child provenance is durable; `marriages.status` is lifecycle/history metadata. Full-Set includes every non-deleted tenant union, regardless of `DANG_KET_HON`, `GOA`, `LY_HON`, `LY_THAN`, or `KHAC`.

### 4.5 Parent union and sibling boundaries

`parent_union_id` identifies a child’s union provenance. It does not replace `father_id` or `mother_id` and must not be inferred or written by FE.

```text
Same depth != sibling
Same level.nodes[] != sibling
Same marriage_tabs[union].children[] = sibling group
```

Children in a tab are ordered by:

```text
1. sibling_seq ascending, nulls last
2. birth_year ascending, nulls last
3. full_name Vietnamese locale ascending
4. member ID ascending
```

---

## 5. Founder and tờ-khai boundary

`origin.is_founder` is intentionally absent from Full-Set. The resolved root of a five-level window is not necessarily the người lập tờ/founder of the declaration sheet.

Declaration-sheet API owns this metadata:

```ts
type DeclarationSheetContext = {
  declaration_sheet_id: string;
  has_lot_founder: boolean;
  lot_founder_member_id: string | null;
};
```

The following meanings are distinct:

```text
has_lot_founder       = declaration-sheet business metadata
lot_founder_member_id = canonical declaration-sheet founder
origin.id             = root resolved for one MFO window
members.generation    = member-domain generation field
canvas depth          = temporary render coordinate
```

---

## 6. Marriage read and tab order

### 6.1 Read policy

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

Never filter Full-Set unions by marriage status.

### 6.2 Owner-specific sort

```text
ST owner = union.husband_id -> owner_marriage_order = husband_marriage_order
ST owner = union.wife_id    -> owner_marriage_order = wife_marriage_order
```

`marriage_tabs[]` is already backend-sorted. FE preserves response order.

Fallback order:

```text
1. owner_marriage_order ascending, nulls last
2. start_date ascending, nulls last
3. union ID ascending
```

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

---

## 7. Literal spouse policy

A literal union remains visible in `marriage_tabs[]` but cannot be assigned to `members.parent_union_id`.

```text
Canonical parent union requires:
husband_id IS NOT NULL
AND wife_id IS NOT NULL
```

The restriction prevents ambiguous provenance where one side of a purported parent union is merely a text name.

```json
{
  "union_id": "union-literal-001",
  "owner_marriage_order": 2,
  "union_status": "GOA",
  "supports_parent_union_assignment": false,
  "partner": {
    "id": null,
    "full_name": "Bà Trần Thị B",
    "role": "partner",
    "position": "right",
    "source": "literal"
  },
  "children": [],
  "child_count": 0
}
```

A legacy child pointing to a literal union is returned in `unassigned_children`; it is never guessed into a tab.

---

## 8. Database and media assumptions

### 8.1 Parent union

```sql
members.parent_union_id varchar(36) null
  references marriages(id)
  on delete set null;

create index idx_members_parent_union
on members(parent_union_id);
```

### 8.2 Media SSOT

Avatar metadata is stored only in `media`:

```text
entity_type = MEMBER
entity_id   = members.id
purpose     = AVATAR
is_primary  = true
deleted_at  = null
```

Do not add `members.avatar_url` as duplicated storage.

Recommended integrity index:

```sql
CREATE UNIQUE INDEX IF NOT EXISTS uq_media_member_primary_avatar
ON public.media (tenant_id, entity_type, entity_id)
WHERE purpose = 'AVATAR'
  AND is_primary = true
  AND deleted_at IS NULL;
```

---

## 9. Full-Set v2 contract

### 9.1 Target and origin

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
};
```

### 9.2 Node

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

### 9.3 Standard Tree

```ts
type MarriageTab = {
  union_id: string;
  owner_marriage_order: number | null;
  union_status: string | null;
  supports_parent_union_assignment: boolean;
  partner: MfoMemberNode & { source?: 'member' | 'literal' };
  children: Array<{ member: MfoMemberNode; partners: MfoMemberNode[] }>;
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
  parent: { member: MfoMemberNode; partners: MfoMemberNode[] };
  children: Array<{ member: MfoMemberNode; partners: MfoMemberNode[] }>;
  child_count: number;
  marriage_tabs: MarriageTab[];
  unassigned_children: UnassignedChild[];
};
```

`children[]` is compatibility-only. Tabs View uses `marriage_tabs[]` and never regroups children on the client.

### 9.4 Response fragment

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
    "root_canvas_depth": 1
  },
  "standard_trees": [
    {
      "id": "st:2:member-a",
      "depth": 2,
      "marriage_tabs": [
        {
          "union_id": "union-u1",
          "owner_marriage_order": 1,
          "union_status": "LY_HON",
          "supports_parent_union_assignment": true,
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

## 10. Full-Set implementation requirements

Every member select used by `getFullMfoSet` includes:

```js
parent_union_id: true,
```

Query all tenant members/unions once, query avatar rows once, then construct ID maps. No per-node avatar or union request is allowed.

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

`packMember()` returns:

```js
parent_union_id: member?.parent_union_id || null,
avatar_url: resolveMemberAvatarUrl(member, avatarByMemberId),
```

A child belongs to tab U only when:

```text
child.parent_union_id === U.id
```

Unassigned reasons include null, missing/soft-deleted union, union not owned by ST owner, and literal/non-assignable union.

For geometry:

```text
role: clan_member -> position: left
role: partner     -> position: right
```

---

## 11. Avatar delivery policy

Full-Set returns only a render-ready URL:

```json
{ "avatar_url": "/api/media/members/<memberId>/avatar?v=<version>" }
```

Do not return binary, base64, R2 credentials, or `storage_key` as an FE rendering contract.

Supported delivery policies:

| Policy | URL form | Usage |
|---|---|---|
| Private gateway | `/api/media/members/:id/avatar?v=...` | Tenant-private/PII avatar |
| Public custom domain | `https://media.example.com/...` | Explicitly Internet-public avatar |

Default for a multi-tenant genealogy product: private R2 bucket plus authenticated gateway.

---

## 12. Write-path contract

### 12.1 Normal assignment

```json
{
  "parent_union_id": "marriage-uuid",
  "parent_union_assignment": { "mode": "NORMAL" }
}
```

### 12.2 Exception assignment

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

Authenticated actor identity is authoritative. FE must not supply `approved_by`.

`createInPlan` and `patchMemberInPlan` validate the final tuple atomically:

```text
father_id
mother_id
parent_union_id
child_type
parent_union_assignment
```

`createSpouse` may fill a null `parent_union_id` only for an exact canonical parent match and allowed normal child type. It never overwrites non-null provenance and never auto-assigns a literal union.

---

## 13. Parent union validation

For non-null `parent_union_id`:

```text
1. Union exists, has same tenant, and is not soft-deleted.
2. Union is canonical: husband_id and wife_id are both present.
3. Child type permits child placement.
4. CON_DE requires exact father/mother match.
5. Special mismatch requires explicit, authorized exception.
```

### 13.1 Ordinary child

```text
CON_DE:
union.husband_id === child.father_id
AND
union.wife_id === child.mother_id
```

Mismatch:

```text
422 MFO_PARENT_UNION_PARENT_MISMATCH
```

### 13.2 Prohibited types

`CON_DAU` and `CON_RE` cannot be parent-union child placements:

```text
422 MFO_PARENT_UNION_NOT_ALLOWED
```

### 13.3 Special exception

`CON_NUOI`, `CON_RIENG`, and `KHAC` allow NORMAL assignment only when parentage exactly matches. For mismatch:

```text
- mode must be EXCEPTION
- reason_code must be from allow-list
- actor must have exception permission
- backend writes immutable audit details
```

Allowed reason codes:

```text
ADOPTED_INTO_UNION
STEPCHILD_ACCEPTED_INTO_UNION
HISTORICAL_RECORD_RECONCILIATION
OTHER_APPROVED
```

`OTHER_APPROVED` requires non-empty `reason_note`.

Additional v1.2 restriction:

```text
For every mismatching KHAC assignment, reason_note is mandatory and non-blank,
regardless of reason_code. KHAC alone never authorizes a parentage mismatch.
```

Reference validation branch:

```js
if (assignment?.mode !== 'EXCEPTION') {
  fail('Cần khai báo ngoại lệ khi gắn quan hệ con không khớp cha/mẹ.', 422,
    'MFO_PARENT_UNION_EXCEPTION_REQUIRED');
}

validateExceptionReason(assignment);

if (childType === 'KHAC' && !String(assignment?.reason_note || '').trim()) {
  fail('Quan hệ KHAC phải có lý do chi tiết khi gắn ngoại lệ.', 422,
    'MFO_PARENT_UNION_EXCEPTION_INVALID');
}

assertActorCanApproveParentUnionException(actor);
```

A historical marriage status never makes an otherwise valid canonical union invalid for parent provenance.

---

## 14. Error contract

| HTTP | Code | Meaning |
|---:|---|---|
| 400 | `MFO_ORIGIN_REQUIRED` | Missing target member ID |
| 400 | `MFO_INVALID_SELECTED_CANVAS_DEPTH` | Depth is not an integer 0 to 4 |
| 400 | `MFO_PARENT_UNION_INVALID` | Parent-union input format invalid |
| 401 | `UNAUTHENTICATED` | Authentication required |
| 403 | `TENANT_MISMATCH` | Cross-tenant target/parent/union/media |
| 403 | `MFO_PARENT_UNION_EXCEPTION_FORBIDDEN` | Actor lacks exception authority |
| 404 | `MFO_ORIGIN_NOT_FOUND` | Target absent or soft-deleted |
| 404 | `MFO_PARENT_UNION_NOT_FOUND` | Union absent or soft-deleted |
| 409 | `MFO_PARENT_UNION_LOCKED` | Change blocked by workflow freeze/approval |
| 422 | `MFO_PARENT_UNION_PARENT_MISMATCH` | Canonical union does not match ordinary child parentage |
| 422 | `MFO_PARENT_UNION_NOT_ALLOWED` | Child type/workflow cannot attach |
| 422 | `MFO_PARENT_UNION_LITERAL_SPOUSE_NOT_ALLOWED` | Literal/non-canonical union cannot be a parent union |
| 422 | `MFO_PARENT_UNION_EXCEPTION_REQUIRED` | Special mismatch lacks explicit exception mode |
| 422 | `MFO_PARENT_UNION_EXCEPTION_INVALID` | Invalid exception mode/code/note, including blank KHAC reason note |
| 500 | `MFO_INTERNAL_ERROR` | Unexpected error |

---

## 15. Test matrix

| Case | Expected result |
|---|---|
| Target depth 3, two ancestors found | Root depth 1, level 0 empty, target remains depth 3 |
| `members.generation` differs from canvas depth | Canvas remains based only on selected depth |
| Full-Set root is not lot founder | No `origin.is_founder` field is returned |
| No target | 400 `MFO_ORIGIN_REQUIRED` |
| Divorced/widowed/separated union with child | Historical tab and child retained |
| Male ST owner | Sort by `husband_marriage_order` |
| Female ST owner | Sort by `wife_marriage_order` |
| Missing owner order | Stable `start_date`, then union ID fallback |
| Child union null | `unassigned_children`: `PARENT_UNION_UNSET` |
| Child union not owned by ST | Explicit unassigned reason |
| Literal union | Rendered, assignment unsupported |
| Legacy child points to literal union | Unassigned; no guessed tab placement |
| CON_DE exact match | Accept NORMAL assignment |
| CON_DE mismatch | 422 parent mismatch |
| CON_NUOI/CON_RIENG mismatch without exception | 422 exception required |
| CON_NUOI mismatch with valid exception | Accept and audit |
| KHAC mismatch with blank reason note | 422 exception invalid |
| KHAC mismatch with explicit exception and non-blank note | Accept and audit |
| CON_DAU/CON_RE with parent union | 422 not allowed |
| Cross-tenant or soft-deleted union | Reject |
| 50-member Full-Set | Batch member/union/media queries; no avatar N+1 |
| No avatar | `avatar_url: null` |

---

## 16. Implementation order

```text
1. Run prisma validate/generate after parent_union_id migration.
2. Document selected_canvas_depth; preserve k only as temporary alias.
3. Patch getFullMfoSet selects, all-status union read, and batch avatar projection.
4. Implement owner-side tab sort and return owner_marriage_order.
5. Implement literal display-only union behavior.
6. Return marriage_tabs and unassigned_children.
7. Patch createInPlan and patchMemberInPlan validation:
   CON_DAU/CON_RE rejection; explicit audited exceptions; mandatory KHAC note.
8. Patch createSpouse for safe null-to-known canonical assignment only.
9. Add integration/contract fixtures and tests.
10. Patch FE adapter and tabs renderer.
11. Remove FE genealogy inference after compatibility window.
```

---

## 17. Definition of done

- Full-Set includes all non-deleted marriage statuses.
- Every child exposes `parent_union_id`.
- Canvas depth, domain generation, and declaration-sheet founder concepts are separate.
- Full-Set does not return `origin.is_founder`.
- Tabs are sorted by ST-owner-side marriage order.
- Tab children are grouped only by explicit parent union.
- Literal unions are visible but never valid parent union provenance.
- Invalid/unresolved children are explicit and never guessed.
- `CON_DAU` and `CON_RE` are rejected with `422 MFO_PARENT_UNION_NOT_ALLOWED`.
- Mismatching `CON_NUOI`, `CON_RIENG`, and `KHAC` need explicit authorized exceptions and audit; `KHAC` additionally requires non-empty reason note.
- Avatar URLs are batch-projected from `media` without exposing R2 internals.
- Tests cover all contract scenarios above.
- FE can render MFO without inferring genealogy rules.
