# Amendment A-1.2 to BE MFO Full-Set v2 Contract v1.2.0

- **Amendment version:** A-1.2.0
- **Supersedes:** `AMENDMENT-A1.1-BE-MFO-FULL-SET-V2-UNION-CHILD-AVATAR-CONTRACT-v1.2.0`
- **Base contract:** `BE-MFO-FULL-SET-V2-UNION-CHILD-AVATAR-CONTRACT-v1.2.0`
- **Status:** Proposed — approve before BE target-identity patching
- **Date:** 2026-10-02
- **Scope:** Target identity, canonical request/service boundary, five-lane Standard Tree invariants, compatibility aliases, observability, and smoke/regression gates.
- **Normative terms:** MUST, MUST NOT, SHOULD, MAY.

---

## 1. Changelog A-1.2

This revision resolves final ambiguity before implementation:

- Defines positional `getFullMfoSet(targetMemberId, selectedCanvasDepth)` only as an optional FE wrapper; BE service has one object-form signature.
- Requires FE to keep the selected target M throughout a selection session and forbids automatic Full-Set refetch using `resolved_root.member_id` or legacy `origin.id`.
- Adds hard invariant that lane 4 cannot expose normal, tab-grouped, or unassigned visible children.
- Requires `is_target` on exactly one clan-member flat node only; partner projections must never carry `is_target`.
- Requires Full-Set Target M to be a clan member in v2. Partner-focus is explicitly out of scope.
- Requires FE lookup of lanes by `level.depth`, not array index.
- Requires `request_context.selected_canvas_depth` to contain the validated normalized value after `selected_canvas_depth ?? k` compatibility precedence.
- Keeps `k` as a mandatory compatibility alias until explicit removal approval.

---

## 2. Purpose

This amendment fixes the identity boundary governing MFO Full-Set requests.

```text
Target M              = member selected by the End User.
Selected canvas depth = absolute lane where Target M must render.
Resolved root         = furthest valid ancestor BE resolves upward from M
                        within selected canvas depth steps.
```

The request identifies Target M. BE resolves the root only after loading Target M. FE must render the returned five-lane projection from lane 0 through lane 4. FE must not substitute the resolved root for Target M, rebuild genealogy, or make canvas depth relative to the resolved root.

This amendment does not replace the Standard Tree algorithm. BE remains responsible for building the complete in-window Standard Tree projection. FE remains responsible only for fulfilling/rendering the projection.

---

## 3. Identity model

### 3.1 Canonical identities

| Identity | Canonical field | Meaning | May call Full-Set? |
|---|---|---|---:|
| Selected member M | `target_member_id` | User-selected clan member | Yes |
| Selected lane | `selected_canvas_depth` | Absolute M lane, integer 0..4 | Yes, as input |
| Resolved root | `resolved_root.member_id` | Furthest ancestor resolved upward from M | No |
| Resolved root lane | `resolved_root.root_canvas_depth` | Absolute lane of resolved root | No |
| Lot founder | `lot_founder_member_id` | Declaration-sheet domain identity, outside Full-Set | No |

### 3.2 Non-interchangeability

This is expected and normal:

```text
resolved_root.member_id != target_member_id
```

The following is prohibited:

```text
- Using one variable for target and resolved root.
- Calling Full-Set with resolved_root.member_id when M is different.
- Replacing target.member_id with resolved_root.member_id in FE state.
- Assuming target and resolved root must always be equal.
```

They may be equal only if M is the furthest valid ancestor resolved in the selected window.

### 3.3 Example

```text
Selected M: Nguyễn Thuý Văn
Target ID:  f1244f7d-3aee-4842-bf6d-e52557680b6d
Lane:       2

Possible resolved path:
Nguyễn Đình Xích -> Nguyễn Đình Xuân -> Nguyễn Thuý Văn

Expected response:
target.member_id                = Nguyễn Thuý Văn
resolved_root.member_id         = Nguyễn Đình Xích
resolved_root.root_canvas_depth = 0
```

If request target is Văn but response `target.member_id` is Xích, that is a BE contract failure.

---

## 4. Canonical request boundary

### 4.1 Canonical endpoint

```http
GET /api/mfo/origins/:targetMemberId/full-set?selected_canvas_depth=<0..4>
```

Example:

```http
GET /api/mfo/origins/f1244f7d-3aee-4842-bf6d-e52557680b6d/full-set?selected_canvas_depth=2
```

### 4.2 Mandatory compatibility aliases

During the compatibility window, the controller MUST accept both:

```text
Route:
:originId -> :targetMemberId

Query:
k -> selected_canvas_depth
```

Depth precedence is mandatory:

```js
const selectedCanvasDepth =
  req.query.selected_canvas_depth ??
  req.query.k;
```

`k` MUST remain supported until the FE migration is complete and its removal is explicitly approved.

### 4.3 Controller normalization

Aliases are controller-only concerns. The service must receive canonical values only.

```js
async function getFullMfoSet(req, res) {
  const targetMemberId =
    req.params.targetMemberId ||
    req.params.originId;

  const selectedCanvasDepth =
    req.query.selected_canvas_depth ??
    req.query.k;

  const data = await mfoService.getFullMfoSet(
    req.user,
    {
      targetMemberId,
      selectedCanvasDepth,
    }
  );

  return res.status(200).json({
    status: 'success',
    data,
  });
}
```

The controller MUST NOT resolve an ancestor/root and substitute that ID for `targetMemberId`.

---

## 5. API signatures

### 5.1 Single BE service signature

The BE service has one and only one canonical signature:

```js
async function getFullMfoSet(
  user,
  {
    targetMemberId,
    selectedCanvasDepth,
  }
) {
  // ...
}
```

The following are prohibited as BE service signatures:

```js
getFullMfoSet(user, originId, targetMemberId, k)
getFullMfoSet(user, targetMemberId, selectedCanvasDepth)
getFullMfoSet(user, originId, k)
```

Service code MUST NOT contain:

```js
const targetId = targetMemberId || originId;
```

### 5.2 Optional FE wrapper

A frontend API wrapper MAY expose a positional helper for ergonomics:

```js
getFullMfoSet(targetMemberId, selectedCanvasDepth)
```

This is a **FE wrapper only**. It is not the BE service signature.

The wrapper MUST:

```text
- Accept the selected Target M only.
- Pass that target ID unchanged into the HTTP path.
- Never accept, derive, or substitute resolvedRootMemberId.
```

Example:

```js
export function getFullMfoSet(
  targetMemberId,
  selectedCanvasDepth
) {
  return apiClient.get(
    `/mfo/origins/${encodeURIComponent(
      targetMemberId
    )}/full-set`,
    {
      params: {
        selected_canvas_depth: selectedCanvasDepth,
      },
    }
  );
}
```

### 5.3 Service target and depth validation

```js
if (!targetMemberId) {
  fail(
    'Thiếu target member ID.',
    400,
    'MFO_ORIGIN_REQUIRED'
  );
}

if (
  selectedCanvasDepth === undefined ||
  selectedCanvasDepth === null ||
  selectedCanvasDepth === ''
) {
  fail(
    'Thiếu selected canvas depth.',
    400,
    'MFO_INVALID_SELECTED_CANVAS_DEPTH'
  );
}

const selectedDepth = Number(selectedCanvasDepth);

if (
  !Number.isInteger(selectedDepth) ||
  selectedDepth < 0 ||
  selectedDepth > 4
) {
  fail(
    'selected_canvas_depth phải là số nguyên từ 0 đến 4.',
    400,
    'MFO_INVALID_SELECTED_CANVAS_DEPTH'
  );
}
```

Silent fallback to lane 0 for missing or malformed depth is prohibited.

---

## 6. Target eligibility

### 6.1 V2 target policy

Full-Set v2 accepts only a clan member as Target M.

```text
targetMember.is_clan !== false
```

If target is an out-clan spouse/partner:

```text
HTTP 422
MFO_TARGET_NOT_CLAN_MEMBER
```

```js
if (targetMember.is_clan === false) {
  fail(
    'Thành viên ngoại tộc không thể là M của khung MFO.',
    422,
    'MFO_TARGET_NOT_CLAN_MEMBER'
  );
}
```

### 6.2 Rationale

In Full-Set v2:

```text
- Main canvas lanes are owned by clan-member Standard Trees.
- Out-clan spouses are partner projections inside an owner ST/tab.
- Target M must have exactly one Standard Tree owner at lane k.
```

A partner-focus mode may be designed later, but it is out of scope and MUST NOT be introduced as an implicit exception.

---

## 7. Five-lane Standard Tree projection

### 7.1 Full-Set definition

For selected member M and lane k:

\[
\mathcal{F}_5(M,k) = \{L_0,L_1,L_2,L_3,L_4\}
\]

Each lane contains its metadata, placeholder, and the complete set of in-window Standard Trees:

\[
L_d = \{\text{lane metadata},\; \text{placeholder},\; ST(d)\}
\]

where:

\[
ST(d) = \{\text{Standard Trees whose clan owner is at absolute lane } d\}
\]

`k` is the lane of M only. It is not root-relative generation, not a root identifier, and not a tree-set identifier.

### 7.2 Fixed lane requirements

```text
levels.length === 5
levels contain exactly depths 0, 1, 2, 3, 4
```

Every lane MUST be returned, even when empty.

Existing empty placeholder field shape MUST remain stable in this patch:

```json
{
  "placeholder": {
    "kind": "empty_couple",
    "clan_member": null,
    "spouse": null
  }
}
```

Do not rename or reshape `clan_member` / `spouse` while changing target identity semantics.

### 7.3 Standard Tree requirements

For each in-window clan member at lane d, BE MUST produce exactly one Standard Tree:

```text
tree.depth === d
tree.parent.member.depth === d
```

For each visible child at lane `d < 4`:

```text
child.member.depth === d + 1
```

`members.generation` is domain/sổ metadata only. It MUST NOT determine `node.depth`, root lane, target lane, or Standard Tree lane.

### 7.4 Last-lane hard invariant

For every Standard Tree at lane 4:

```text
tree.children.length === 0
tree.child_count === 0

tree.unassigned_children.length === 0

for every marriage tab:
  tab.children.length === 0
  tab.child_count === 0
```

No ordinary child, tab child, or unassigned child may be exposed from lane 4, because any such child would belong to lane 5 outside the fixed five-lane window.

---

## 8. Canonical response

### 8.1 Required response context

Every Full-Set response MUST include:

```json
{
  "request_context": {
    "target_member_id": "f1244f7d-3aee-4842-bf6d-e52557680b6d",
    "selected_canvas_depth": 2
  },
  "resolved_root": {
    "member_id": "cb6307b4-9b81-47a0-8dda-ae0ba5355c68",
    "root_canvas_depth": 0
  },
  "target": {
    "member_id": "f1244f7d-3aee-4842-bf6d-e52557680b6d",
    "selected_canvas_depth": 2,
    "rendered_canvas_depth": 2,
    "resolved_ancestor_steps": 2
  }
}
```

`request_context.selected_canvas_depth` MUST be the validated normalized value after controller precedence:

```text
selected_canvas_depth ?? k
```

It MUST NOT echo raw, malformed, lower-priority, or unvalidated query text.

### 8.2 Canonical root name

`resolved_root` is canonical:

```text
resolved_root.member_id
resolved_root.root_canvas_depth
```

Legacy `origin` may remain for one announced transition version only:

```json
{
  "origin": {
    "id": "cb6307b4-9b81-47a0-8dda-ae0ba5355c68",
    "root_canvas_depth": 0
  },
  "contract_version": "2.2",
  "deprecated_fields": [
    "origin.id",
    "origin.root_canvas_depth"
  ]
}
```

New code MUST use `resolved_root`; it MUST NOT use `origin.id` as a Full-Set target.

### 8.3 Identity invariants

```text
request_context.target_member_id
=== target.member_id
=== targetMemberId supplied to service
=== member ID used in initial target lookup
```

```text
target.selected_canvas_depth
=== target.rendered_canvas_depth
=== request_context.selected_canvas_depth
```

```text
resolved_root.root_canvas_depth
=== target.selected_canvas_depth - target.resolved_ancestor_steps
```

---

## 9. Hard invariants

### 9.1 Flat member projection vs Standard Tree IDs

Target assertions use flat member projection only:

```text
levels[d].nodes[] / top-level nodes[]
- node.id = member ID
- node.depth = absolute canvas lane
- node.is_target = target marker
```

Standard Tree identifiers are different:

```text
tree.id = ST identifier, e.g. st:<depth>:<member-id>
tree.parent.member.id = owner member ID
```

Do not compare `tree.id` directly with `targetMemberId`.

### 9.2 Required target assertions

```js
function assertFullSetInvariants({
  levels,
  nodes,
  targetMemberId,
  selectedCanvasDepth,
  rootCanvasDepth,
  resolvedAncestorSteps,
}) {
  if (!Array.isArray(levels) || levels.length !== 5) {
    throw new Error('MFO_LEVEL_COUNT_INVALID');
  }

  const levelByDepth = new Map(
    levels.map((level) => [Number(level?.depth), level])
  );

  for (let depth = 0; depth <= 4; depth += 1) {
    const level = levelByDepth.get(depth);

    if (!level) {
      throw new Error('MFO_LEVEL_DEPTH_INVALID');
    }

    for (const tree of level.standard_trees || []) {
      if (tree.depth !== depth) {
        throw new Error('MFO_STANDARD_TREE_DEPTH_INVALID');
      }

      if (tree.parent?.member?.depth !== depth) {
        throw new Error('MFO_STANDARD_TREE_OWNER_DEPTH_INVALID');
      }

      for (const child of tree.children || []) {
        if (depth === 4 || child.member?.depth !== depth + 1) {
          throw new Error('MFO_STANDARD_TREE_CHILD_DEPTH_INVALID');
        }
      }

      for (const tab of tree.marriage_tabs || []) {
        for (const child of tab.children || []) {
          if (depth === 4 || child.member?.depth !== depth + 1) {
            throw new Error('MFO_MARRIAGE_TAB_CHILD_DEPTH_INVALID');
          }
        }
      }

      if (depth === 4) {
        if ((tree.children || []).length > 0) {
          throw new Error('MFO_LAST_LANE_CHILDREN_FORBIDDEN');
        }

        if ((tree.unassigned_children || []).length > 0) {
          throw new Error('MFO_LAST_LANE_UNASSIGNED_CHILDREN_FORBIDDEN');
        }

        if (Number(tree.child_count || 0) !== 0) {
          throw new Error('MFO_LAST_LANE_CHILD_COUNT_INVALID');
        }

        for (const tab of tree.marriage_tabs || []) {
          if ((tab.children || []).length > 0) {
            throw new Error('MFO_LAST_LANE_TAB_CHILDREN_FORBIDDEN');
          }

          if (Number(tab.child_count || 0) !== 0) {
            throw new Error('MFO_LAST_LANE_TAB_CHILD_COUNT_INVALID');
          }
        }
      }
    }
  }

  const targetNodes = (nodes || []).filter(
    (node) => node?.is_target === true
  );

  if (targetNodes.length !== 1) {
    throw new Error('MFO_TARGET_NODE_COUNT_INVALID');
  }

  const targetNode = targetNodes[0];

  if (targetNode.role !== 'clan_member') {
    throw new Error('MFO_TARGET_MUST_BE_CLAN_MEMBER');
  }

  if (targetNode.is_clan === false) {
    throw new Error('MFO_TARGET_MUST_BE_CLAN_MEMBER');
  }

  if (String(targetNode.id) !== String(targetMemberId)) {
    throw new Error('MFO_TARGET_IDENTITY_MISMATCH');
  }

  if (targetNode.depth !== selectedCanvasDepth) {
    throw new Error('MFO_TARGET_DEPTH_NOT_PRESERVED');
  }

  const targetLevel = levelByDepth.get(selectedCanvasDepth);
  const targetTrees = (targetLevel?.standard_trees || []).filter(
    (tree) =>
      String(tree?.parent?.member?.id) ===
      String(targetMemberId)
  );

  if (targetTrees.length !== 1) {
    throw new Error('MFO_TARGET_STANDARD_TREE_COUNT_INVALID');
  }

  if (
    rootCanvasDepth !==
    selectedCanvasDepth - resolvedAncestorSteps
  ) {
    throw new Error('MFO_ROOT_DEPTH_INVARIANT_BROKEN');
  }
}
```

### 9.3 Partner target prohibition

Partner/spouse projections MUST NOT carry `is_target: true`.

```text
partner.role === 'partner'
partner.is_target !== true
```

A spouse must not satisfy the target Standard Tree owner assertion. This protects the v2 clan-member target policy and prevents false 500 errors in out-clan marriage data.

---

## 10. Recoverable data vs failures

### 10.1 Hard failure conditions

Only these structural/identity conditions may produce an internal Full-Set invariant failure:

```text
- Wrong lane count or lane-depth identity.
- Missing/duplicate/mismatched target marker.
- Target depth mismatch.
- Root-depth formula mismatch.
- Standard Tree owner/visible-child lane mismatch.
- Visible child at lane 4.
```

### 10.2 Recoverable degraded data

The following MUST NOT block a Full-Set response:

```text
- Literal spouse union.
- Missing/unknown spouse.
- Missing avatar.
- Null/legacy/invalid parent_union_id.
- Child unassigned from a marriage tab.
- Historical marriage status.
- Branch incompleteness outside the visible window.
```

BE must expose degraded conditions through normal fields:

```text
avatar_url: null
partner.source: literal
supports_parent_union_assignment: false
unassigned_children[]
reason: PARENT_UNION_UNSET / PARENT_UNION_NOT_FOUND / ...
```

### 10.3 User-safe error behavior

Hard invariant failure only:

```text
HTTP 500
MFO_FULL_SET_INVARIANT_BROKEN
```

```json
{
  "status": "error",
  "code": "MFO_FULL_SET_INVARIANT_BROKEN",
  "message": "Không thể dựng khung gia phả nhất quán. Vui lòng thử lại hoặc liên hệ quản trị viên.",
  "correlation_id": "..."
}
```

Required server log fields:

```text
correlation_id
tenant_id
target_member_id
selected_canvas_depth
returned_target_member_id
target_node_count
target_node_depth
resolved_root_member_id
root_canvas_depth
resolved_ancestor_steps
```

Do not expose full genealogy, spouse history, or media URLs in error responses.

---

## 11. FE handoff and refetch gate

### 11.1 Required View Focus shape

```ts
type ViewFocusResult = {
  targetMemberId: string;
  selectedCanvasDepth: 0 | 1 | 2 | 3 | 4;
  resolvedRootMemberId: string | null;
  lines: unknown[];
};
```

### 11.2 Full-Set call rule

The following positional invocation refers **only to the FE wrapper**, not the BE service:

```js
getFullMfoSet(
  viewFocusResult.targetMemberId,
  viewFocusResult.selectedCanvasDepth
);
```

It MUST NOT be interpreted as a BE service call.

The FE wrapper MUST NOT receive `resolvedRootMemberId` as its first argument.

The following is prohibited:

```js
getFullMfoSet(
  viewFocusResult.resolvedRootMemberId,
  viewFocusResult.selectedCanvasDepth
);
```

### 11.3 No automatic resolved-root refetch

Within one user selection session:

```text
The Full-Set HTTP target MUST remain selected Target M.
```

```text
resolved_root.member_id and legacy origin.id may be stored for display,
diagnostics, or workflow submission context, but MUST NOT become the target
of a later Full-Set request unless the user explicitly selects that member
as a new M.
```

A new Full-Set target is allowed only after an explicit action such as:

```text
SELECT_MEMBER_AS_M
```

FE MUST render the Full-Set `treeData` from the request made with Target M. It MUST NOT refetch the tree using `origin.id` or `resolved_root.member_id`.

### 11.4 FE lane lookup

FE MUST look up lanes by semantic key, not array position:

```js
const levelByDepth = new Map(
  (fullSet.levels || []).map((level) => [
    Number(level.depth),
    level,
  ])
);

for (let depth = 0; depth <= 4; depth += 1) {
  const level = levelByDepth.get(depth);

  if (!level) {
    throw new Error(`Missing MFO lane ${depth}`);
  }

  renderLevel(level);
}
```

BE SHOULD return levels in ascending depth order, but FE MUST NOT rely on array index as identity.

---

## 12. Smoke and regression gate

### 12.1 Primary smoke

```text
Selected M: Nguyễn Thuý Văn
Target ID:  f1244f7d-3aee-4842-bf6d-e52557680b6d
Lane:       2
```

Required request during transition:

```http
GET /api/mfo/origins/f1244f7d-3aee-4842-bf6d-e52557680b6d/full-set?k=2
```

Canonical equivalent:

```http
GET /api/mfo/origins/f1244f7d-3aee-4842-bf6d-e52557680b6d/full-set?selected_canvas_depth=2
```

Required assertions:

```text
request_context.target_member_id = target.member_id
                                  = Nguyễn Thuý Văn ID

target.selected_canvas_depth = 2
target.rendered_canvas_depth = 2

Exactly one flat member node has is_target=true.
That node is a clan member.
That node ID is Nguyễn Thuý Văn ID.
That node depth is 2.
```

### 12.2 Required regressions

| Case | Required result |
|---|---|
| M at `k=0` | Target at lane 0; descendants may fill lanes 1..4 |
| M at `k=2`, two valid ancestors | Resolved root at lane 0; target lane 2 |
| M at `k=2`, broken ancestor chain | Missing upper lanes explicit empty; target remains lane 2 |
| M at `k=4` | Target lane 4; no visible normal/tab/unassigned child below it |
| `generation` differs from canvas lane | Canvas lanes remain traversal/selection based |
| Out-clan spouse | Appears as partner only; never a clan owner/target marker |
| Out-clan member selected as M | 422 `MFO_TARGET_NOT_CLAN_MEMBER` |
| Divorced/widowed/separated union | Historical union and valid children remain in read projection |
| Null `parent_union_id` | Explicit unassigned child; no inferred tab assignment |
| Literal spouse union | Displayable tab, assignment disabled, no 500 |
| Request path contains Xích while current M is Văn | FE/View Focus failure |
| Request path contains Văn but response target is Xích | BE controller/service failure |
| Request/response target are Văn but UI renders Xích | FE state/adapter failure |
| Response contains complete lanes but viewport cuts a lane | FE presentation failure, not BE contract failure |

### 12.3 Ownership gate

| Observation | Owner | Required correction |
|---|---|---|
| Full-Set path uses resolved-root/Xích ID while current selected M is Văn | FE/View Focus | Preserve targetMemberId; stop automatic root refetch |
| Full-Set path uses Văn ID but response target is Xích | BE | Fix controller normalization/service target lookup |
| Response target is Văn but is_target node is missing/not lane 2 | BE | Fix Full-Set construction; hard invariant failure in test/dev |
| Response identity and levels are correct but UI renders Xích | FE | Fix page state/adapter/render source |
| UI viewport cuts lanes but response has complete levels 0..4 | FE | Fix viewport/layout only |

---

## 13. Implementation checklist

### Backend

```text
[ ] Controller accepts selected_canvas_depth and k with required precedence.
[ ] k remains available during migration.
[ ] Service accepts only { targetMemberId, selectedCanvasDepth }.
[ ] Service contains no targetMemberId || originId fallback.
[ ] Initial lookup uses targetMemberId only.
[ ] Target M is rejected when is_clan === false.
[ ] Response contains normalized request_context and resolved_root.
[ ] origin is deprecated alias only.
[ ] Exactly one flat clan-member node has is_target=true.
[ ] Lane-4 children/tab-children/unassigned-children are forbidden.
[ ] Hard assertions run in test/development before return.
[ ] Recoverable data returns degraded projection, not 500.
[ ] Regression suite covers §12.2.
```

### Frontend integration boundary

```text
[ ] FE wrapper receives selected target only.
[ ] Selected target ID is stored separately from resolved root ID.
[ ] No automatic Full-Set refetch uses origin.id/resolved_root.member_id.
[ ] Response request_context.target_member_id equals requested target.
[ ] Response target.member_id equals requested target.
[ ] FE looks up lanes by level.depth.
[ ] FE never uses members.generation as canvas lane.
```

---

## 14. Definition of done

This amendment is complete only when:

```text
- BE service has exactly one object-form canonical input signature.
- Controller alone normalizes :originId/:targetMemberId and k/selected_canvas_depth.
- k remains available throughout approved compatibility transition.
- request_context stores the normalized depth and selected target identity.
- resolved_root is canonical and cannot be silently reused as Full-Set target.
- No Full-Set request uses resolved_root.member_id while a different M remains selected.
- Target M is clan member in v2.
- Exactly one is_target node exists; it is clan member, has requested ID, and is at lane k.
- Every in-window clan member has one Standard Tree at its absolute lane.
- Lane 4 exposes no normal/tab/unassigned children.
- Degraded genealogy data does not block the full window.
- Nguyễn Thuý Văn @ k=2 and all §12.2 regressions pass.
- FE viewport/layout defects are not used to alter BE genealogy semantics.
```
