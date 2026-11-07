# Amendment A-1.1 to BE MFO Full-Set v2 Contract v1.2.0

- **Amendment version:** A-1.1.0
- **Supersedes:** `AMENDMENT-A1-BE-MFO-FULL-SET-V2-UNION-CHILD-AVATAR-CONTRACT-v1.2.0`
- **Base contract:** `BE-MFO-FULL-SET-V2-UNION-CHILD-AVATAR-CONTRACT-v1.2.0`
- **Status:** Proposed — required before further BE Full-Set or target-handoff patching
- **Date:** 2026-10-02
- **Scope:** Canonical target identity, resolved-root naming, five-lane Standard Tree projection, compatibility aliases, invariant gates, and smoke-test protocol
- **Normative terms:** MUST, MUST NOT, SHOULD, MAY

---

## 1. Changelog A-1.1

This revision corrects implementation-risk ambiguities in A-1.0.0:

- Clarifies that `resolved_root_member_id != target_member_id` is normal; what is prohibited is treating the two identities as interchangeable.
- Makes `resolved_root` canonical response terminology. Legacy `origin` remains a deprecated compatibility alias only.
- Defines exactly one Full-Set service signature: object input with `targetMemberId` and `selectedCanvasDepth`.
- Requires controller support for both `selected_canvas_depth` and legacy `k` throughout the transition window; service code receives only normalized `selectedCanvasDepth`.
- Specifies target assertions against flat member node projections and `is_target`, never against a Standard Tree ID.
- Separates hard structural/identity invariant failures from recoverable incomplete genealogy data.
- Expands acceptance and regression tests beyond Nguyễn Thuý Văn at lane 2.
- Explicitly marks viewport cropping and visual layout as FE concerns, not a reason to alter Full-Set genealogy semantics.

---

## 2. Purpose

This amendment fixes the identity boundary that governs every MFO Full-Set request:

```text
Target M              = member selected by the End User.
Selected canvas depth = absolute lane where Target M is rendered.
Resolved root         = furthest valid ancestor BE resolves upward from M
                        within selected canvas depth steps.
```

The request always identifies Target M. BE resolves the root only after locating Target M. FE must render the resulting five-lane projection from lane `0` through lane `4`; it must not replace Target M with the resolved root, recompute genealogy, or shift depth relative to the root.

This amendment does not replace the Full-Set / Standard Tree algorithm. The existing algorithm is already intended to build a full five-lane projection from the resolved root downward, with Target M preserved at its requested absolute lane. The amendment makes target identity, contract observability, and invariant enforcement unambiguous.

---

## 3. Canonical identity model

### 3.1 Required identities

| Identity | Canonical field | Meaning | May be used as Full-Set request target? |
|---|---|---|---:|
| Selected member M | `target_member_id` | Member selected by the End User | Yes |
| Selected lane | `selected_canvas_depth` | Absolute lane for M, integer 0..4 | Yes, as query/input |
| Resolved window root | `resolved_root.member_id` | Furthest valid ancestor found from M within selected-depth upward traversal | No |
| Root lane | `resolved_root.root_canvas_depth` | Absolute canvas lane of resolved root | No |
| Declaration-sheet founder | `lot_founder_member_id` | Tờ-khai / lot identity; outside Full-Set | No |

### 3.2 Non-interchangeability rule

The following is normal and expected in most non-root selections:

```text
resolved_root_member_id != target_member_id
```

The following is prohibited:

```text
- Treating target_member_id and resolved_root_member_id as the same variable.
- Calling Full-Set with resolved_root_member_id when user selected target_member_id.
- Replacing target.member_id with resolved_root.member_id in FE state.
- Inferring that target and resolved root must always be identical.
```

They are equal only when M is itself the furthest valid ancestor resolved within the selected canvas window.

### 3.3 Example

```text
User selects: Nguyễn Thuý Văn
Target ID:    f1244f7d-3aee-4842-bf6d-e52557680b6d
Lane k:       2

Resolved ancestor path:
Nguyễn Đình Xích -> Nguyễn Đình Xuân -> Nguyễn Thuý Văn

Expected response identity:
target.member_id                    = Nguyễn Thuý Văn
request_context.target_member_id    = Nguyễn Thuý Văn
resolved_root.member_id             = Nguyễn Đình Xích
resolved_root.root_canvas_depth     = 0
```

It is a contract failure if the request target is Nguyễn Thuý Văn but response `target.member_id` is Nguyễn Đình Xích.

---

## 4. Canonical route and aliases

### 4.1 Canonical request

```http
GET /api/mfo/origins/:targetMemberId/full-set?selected_canvas_depth=<0..4>
```

Example:

```http
GET /api/mfo/origins/f1244f7d-3aee-4842-bf6d-e52557680b6d/full-set?selected_canvas_depth=2
```

### 4.2 Compatibility requirements

During the compatibility window, controller code MUST accept both route/query forms:

```text
Route alias:
:originId -> :targetMemberId

Depth query aliases:
selected_canvas_depth
k
```

Depth precedence is mandatory:

```js
const selectedCanvasDepth =
  req.query.selected_canvas_depth ??
  req.query.k;
```

`k` MUST remain supported until FE has migrated and compatibility removal is explicitly approved. Removing `k` before FE migration is complete risks silent/default lane-0 behavior and is prohibited.

### 4.3 Controller normalization boundary

Aliases are controller concerns only. After normalization, service code MUST receive canonical names only.

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

Controller MUST NOT resolve an ancestor/root and substitute it for `targetMemberId`.

---

## 5. Service boundary

### 5.1 Single required signature

The service has exactly one canonical signature:

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

The following signatures are deprecated and MUST NOT be used in new or amended code:

```js
getFullMfoSet(user, originId, targetMemberId, k, selectedCanvasDepth)
getFullMfoSet(user, originId, k)
getFullMfoSet(user, targetMemberId, selectedCanvasDepth)
```

A thin FE wrapper may expose a positional public API if desired, but it MUST map to canonical target identity and MUST NOT accept resolved-root identity as its input.

### 5.2 Target lookup requirement

The initial lookup MUST use only `targetMemberId`:

```js
if (!targetMemberId) {
  fail(
    'Thiếu target member ID.',
    400,
    'MFO_ORIGIN_REQUIRED'
  );
}

const targetMember = await prisma.members.findUnique({
  where: { id: targetMemberId },
  select: memberSelect,
});
```

The following fallback is prohibited in the service layer:

```js
const targetId = targetMemberId || originId;
```

If compatibility aliases are needed, controller normalization must solve them before invoking the service.

### 5.3 Selected-depth validation

After controller normalization, service receives `selectedCanvasDepth` only.

```js
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

Silent fallback to lane `0` for a missing or malformed depth is prohibited after this amendment is adopted.

---

## 6. Five-lane Standard Tree projection

### 6.1 Full-Set definition

For selected member M and selected lane `k`, BE builds exactly one five-lane projection:

\[
\mathcal{F}_5(M,k) = \{L_0,L_1,L_2,L_3,L_4\}
\]

Each lane contains lane metadata, an optional empty placeholder, and the complete set of in-window Standard Trees:

\[
L_d = \{\text{lane metadata},\; \text{placeholder},\; ST(d)\}
\]

Where:

\[
ST(d) = \{\text{all Standard Trees whose clan owner is placed at absolute lane } d\}
\]

`k` is only the absolute lane of Target M. It is not a root-relative generation, not an origin index, and not the name of the complete Standard Tree set.

### 6.2 Mandatory lane model

```text
levels.length === 5
levels[0].depth === 0
levels[1].depth === 1
levels[2].depth === 2
levels[3].depth === 3
levels[4].depth === 4
```

Every lane MUST be returned, including empty lanes.

The existing placeholder field shape MUST remain stable during this amendment. In particular, if FE currently renders:

```json
{
  "placeholder": {
    "kind": "empty_couple",
    "clan_member": null,
    "spouse": null
  }
}
```

BE MUST NOT rename `spouse`, `clan_member`, or otherwise reshape placeholder fields in the same patch that changes identity/invariant behavior.

### 6.3 Standard Tree completeness

For every in-window clan member at lane `d`, BE MUST return exactly one Standard Tree in `levels[d].standard_trees`.

```text
standard_tree.depth === d
standard_tree.parent.member.depth === d
```

For every visible child of an ST at lane `d < 4`:

```text
child.member.depth === d + 1
```

For every Standard Tree at lane 4:

```text
children[] = []
marriage_tabs[].children[] = []
```

because any child would belong to lane 5 and therefore lies outside the fixed five-lane window.

### 6.4 Generation exclusion invariant

`members.generation` is domain/sổ metadata. It MUST NOT determine canvas lane, target position, root position, or Standard Tree depth.

The implementation may select/return `generation`, but must preserve:

```text
node.depth is determined by the Full-Set traversal window,
not by member.generation.
```

This requires a dedicated test fixture where `members.generation` differs from canvas depth.

### 6.5 FE fulfilment boundary

FE renders the projection returned by BE from lane 0 through lane 4:

```js
for (let depth = 0; depth <= 4; depth += 1) {
  const level = fullSet.levels[depth];

  if (level.is_empty) {
    renderEmptyLane(level);
  } else {
    renderStandardTrees(level.standard_trees);
  }
}
```

FE MUST NOT:

```text
- Render only descendants of Target M.
- Start rendering from resolved_root.root_canvas_depth.
- Make depth relative to resolved root.
- Infer children into marriage tabs from father_id/mother_id.
- Substitute resolved root for Target M.
- Use members.generation as canvas depth.
```

Viewport cropping, zoom, labels, card spacing, and node layout are FE presentation concerns. They do not change the BE requirement to return complete `levels[0..4]` and all in-window Standard Trees.

---

## 7. Canonical response model

### 7.1 Required response context

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

### 7.2 Canonical resolved-root naming

`resolved_root` is canonical.

```text
resolved_root.member_id
resolved_root.root_canvas_depth
```

`origin` may remain only as a deprecated compatibility alias for one explicitly announced API version/removal window:

```json
{
  "origin": {
    "id": "cb6307b4-9b81-47a0-8dda-ae0ba5355c68",
    "root_canvas_depth": 0
  },
  "contract_version": "2.1",
  "deprecated_fields": [
    "origin.id",
    "origin.root_canvas_depth"
  ]
}
```

New FE code MUST use `resolved_root`; it MUST NOT save `origin.id` as a Full-Set target ID.

### 7.3 Identity invariants

```text
request_context.target_member_id
=== target.member_id
=== targetMemberId passed to the service
=== target member used in initial database lookup
```

```text
target.rendered_canvas_depth
=== target.selected_canvas_depth
=== request_context.selected_canvas_depth
```

```text
resolved_root.root_canvas_depth
=== target.selected_canvas_depth - target.resolved_ancestor_steps
```

---

## 8. Hard invariants and recoverable data

### 8.1 Hard contract invariants

The following are structural/identity failures. They MUST fail Full-Set construction in test/development and MUST emit a server-side invariant error in production:

```text
- levels does not contain exactly five lanes.
- levels[d].depth differs from d.
- target member is absent from flat member node projection.
- number of flat member nodes with is_target === true is not exactly one.
- is_target member ID differs from request target_member_id.
- is_target depth differs from selected_canvas_depth.
- resolved root lane violates the root-depth formula.
- Standard Tree depth differs from its lane.
- Standard Tree owner member depth differs from tree/lane depth.
- Visible child depth differs from parent Standard Tree depth + 1.
- Any visible member node lies outside depth 0..4.
```

### 8.2 Recoverable / degraded genealogy data

The following MUST NOT block the user from receiving a usable Full-Set window:

```text
- Missing/unknown spouse member.
- Literal spouse union.
- Missing avatar.
- parent_union_id = null.
- Legacy/invalid parent_union_id.
- Child that cannot be assigned to a marriage tab.
- Missing branch completeness beyond the visible window.
- Historical marriage status.
```

BE must represent such conditions through normal read-model fields:

```text
avatar_url: null
partner.source: literal
supports_parent_union_assignment: false
unassigned_children[]
reason: PARENT_UNION_UNSET / PARENT_UNION_NOT_FOUND / ...
```

A malformed branch must not turn the entire Full-Set response into a 500 merely because one marriage or one child cannot be fully grouped.

---

## 9. Mandatory assertions

Assertions must distinguish flat member nodes from Standard Tree IDs.

```text
Flat member projection:
- levels[d].nodes[]
- top-level nodes[]
- node.id is a member ID
- node.depth is canvas depth
- node.is_target identifies Target M

Standard Tree projection:
- levels[d].standard_trees[]
- tree.id is an ST identifier, e.g. st:<depth>:<member-id>
- tree.parent.member.id is the owner member ID
```

The target assertion MUST NOT compare `tree.id` directly to `targetMemberId`.

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

  for (let depth = 0; depth <= 4; depth += 1) {
    const level = levels[depth];

    if (!level || level.depth !== depth) {
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
        if (child.member?.depth !== depth + 1) {
          throw new Error('MFO_STANDARD_TREE_CHILD_DEPTH_INVALID');
        }
      }

      for (const tab of tree.marriage_tabs || []) {
        for (const child of tab.children || []) {
          if (child.member?.depth !== depth + 1) {
            throw new Error('MFO_MARRIAGE_TAB_CHILD_DEPTH_INVALID');
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

  if (String(targetNode.id) !== String(targetMemberId)) {
    throw new Error('MFO_TARGET_IDENTITY_MISMATCH');
  }

  if (targetNode.depth !== selectedCanvasDepth) {
    throw new Error('MFO_TARGET_DEPTH_NOT_PRESERVED');
  }

  const targetTrees = (
    levels[selectedCanvasDepth]?.standard_trees || []
  ).filter(
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

---

## 10. Error behavior and observability

### 10.1 Internal invariant failure

Only hard invariant failures from §8.1 may produce:

```text
HTTP 500
MFO_FULL_SET_INVARIANT_BROKEN
```

User-safe response:

```json
{
  "status": "error",
  "code": "MFO_FULL_SET_INVARIANT_BROKEN",
  "message": "Không thể dựng khung gia phả nhất quán. Vui lòng thử lại hoặc liên hệ quản trị viên.",
  "correlation_id": "..."
}
```

### 10.2 Required server-side logging

The server log/trace for this error MUST include only diagnostic identity/window fields required to investigate the contract breach:

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

It SHOULD NOT expose full genealogy branches, spouse history, media URLs, or unrelated member data in an error response.

### 10.3 No 500 for degraded genealogy

Literal unions, missing avatars, unassigned children, incomplete branches, and historical marriage statuses are recoverable data conditions. They MUST return a built window with explicit degraded metadata, not block the screen.

---

## 11. Target handoff rule

### 11.1 View Focus contract

Any picker/View Focus workflow MUST retain selected target and resolved root separately:

```ts
type ViewFocusResult = {
  targetMemberId: string;
  selectedCanvasDepth: 0 | 1 | 2 | 3 | 4;
  resolvedRootMemberId: string | null;
  lines: unknown[];
};
```

### 11.2 Full-Set invocation

```js
getFullMfoSet(
  viewFocusResult.targetMemberId,
  viewFocusResult.selectedCanvasDepth
);
```

The following is prohibited:

```js
getFullMfoSet(
  viewFocusResult.resolvedRootMemberId,
  viewFocusResult.selectedCanvasDepth
);
```

### 11.3 Plan submission boundary

Plan submission may still have workflow-specific origin/root semantics. It is a separate command boundary:

```text
Full-Set read target = selected M.
Plan submission origin = workflow-defined origin, if required by the plan process.
```

The variables MUST remain separate. A submission `originId` must not be reused as a Full-Set target merely because both are member IDs.

---

## 12. Smoke and regression gate

### 12.1 Primary acceptance smoke

```text
Selected M: Nguyễn Thuý Văn
Target member ID: f1244f7d-3aee-4842-bf6d-e52557680b6d
Selected canvas depth: 2
```

Required canonical request:

```http
GET /api/mfo/origins/f1244f7d-3aee-4842-bf6d-e52557680b6d/full-set?selected_canvas_depth=2
```

Legacy-compatible request during transition:

```http
GET /api/mfo/origins/f1244f7d-3aee-4842-bf6d-e52557680b6d/full-set?k=2
```

Required identity assertions:

```text
request_context.target_member_id = target.member_id
                                  = f1244f7d-3aee-4842-bf6d-e52557680b6d

target.selected_canvas_depth = 2
target.rendered_canvas_depth = 2

Exactly one flat member node has is_target = true.
That node ID is Nguyễn Thuý Văn's ID.
That node depth is 2.
```

### 12.2 Required regression matrix

| Case | Required result |
|---|---|
| Target M at `k=0` | Target is the sole `is_target` node at lane 0; descendants may fill lanes 1..4 |
| Target M at `k=2`, two valid ancestors | Resolved root at lane 0; target at lane 2 |
| Target M at `k=2`, ancestor chain breaks | Top missing lanes explicit empty; target remains lane 2 |
| Target M at `k=4` | Target at lane 4; no visible descendants below lane 4 |
| `members.generation` differs from canvas lane | Canvas depth still follows traversal/selected depth only |
| Out-clan spouse | Partner appears within owner ST/tab, never as a clan-owner lane node only because of marriage |
| Historical divorced/widowed/separated union | Union and children remain present under normal read policy |
| Child with null `parent_union_id` | Explicit `unassigned_children`, no FE/BE inference into a tab |
| Literal spouse union | Displayable tab; `supports_parent_union_assignment=false`; no Full-Set 500 |
| Request path uses Xích ID when UI selected Văn | FE/View Focus integration failure |
| Request path uses Văn ID, response target is Xích | BE controller/service failure |
| Request and response both target Văn, UI renders Xích | FE adapter/state rendering failure |

### 12.3 Ownership gate

| Observation | Owner | Required correction |
|---|---|---|
| Request path contains resolved-root/Xích ID instead of selected Văn ID | FE/View Focus | Preserve selected target ID separately; send it to Full-Set |
| Request path contains Văn ID but response target is Xích | BE | Correct controller normalization/service initial target lookup |
| Response target is Văn but target node is absent/not depth 2 | BE | Correct Full-Set traversal/Standard Tree construction; invariant must fail in test/dev |
| Response identity and levels are correct but rendered node is Xích | FE | Correct page state, adapter, or rendering source |
| UI viewport cuts lanes while payload contains complete lanes 0..4 | FE | Fix presentation/viewport only; do not change BE genealogy contract |

---

## 13. Implementation checklist

### Backend

```text
[ ] Controller accepts selected_canvas_depth and k; selected_canvas_depth takes precedence.
[ ] Service accepts only object input { targetMemberId, selectedCanvasDepth }.
[ ] Service has no targetMemberId || originId fallback.
[ ] Initial target lookup uses targetMemberId only.
[ ] Response returns request_context and canonical resolved_root.
[ ] origin remains compatibility alias only and is listed as deprecated.
[ ] Flat member nodes include exactly one is_target=true node.
[ ] assertFullSetInvariants runs before response in test/development.
[ ] Production emits correlation-bound diagnostics for hard invariant breach.
[ ] Recoverable genealogy imperfections return degraded data, not 500.
[ ] Regression suite includes all §12.2 cases.
```

### Frontend integration boundary

```text
[ ] Preserve targetMemberId separately from resolvedRootMemberId.
[ ] Call Full-Set with selected target only.
[ ] Assert response request_context.target_member_id and target.member_id equal requested target.
[ ] Fulfil levels[0..4] in absolute lane order.
[ ] Never transform canvas depth relative to resolved root.
[ ] Never use members.generation as canvas lane.
```

---

## 14. Definition of done

This amendment is complete only when:

```text
- A selected target never becomes the resolved root by variable reuse or fallback.
- k remains supported during the migration window.
- Full-Set service has one unambiguous canonical input contract.
- Canonical response distinguishes request_context, target, and resolved_root.
- Exactly one flat member node is_target=true and it is the requested target at lane k.
- Full-Set returns lanes 0..4 and all reachable in-window Standard Trees.
- Incomplete genealogy data degrades gracefully rather than blocking the window.
- Nguyễn Thuý Văn @ lane 2, k=0, k=4, ancestor gap, out-clan spouse, literal union, and unassigned-child regressions pass.
- FE rendering problems are not misdiagnosed as BE contract failures when BE response identity and five-lane projection are correct.
```
