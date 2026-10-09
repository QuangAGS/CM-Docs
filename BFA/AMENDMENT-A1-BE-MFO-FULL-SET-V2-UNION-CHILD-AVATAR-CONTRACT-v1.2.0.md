# Amendment A-1 to BE MFO Full-Set v2 Contract v1.2.0

- **Amendment version:** A-1.0.0
- **Base contract:** `BE-MFO-FULL-SET-V2-UNION-CHILD-AVATAR-CONTRACT-v1.2.0`
- **Status:** Proposed — required before further Full-Set/FE patching
- **Date:** 2026-10-02
- **Scope:** Target identity, five-lane Standard Tree completeness, request/response invariants, smoke-test protocol, and controller/service boundary.
- **Normative terms:** MUST, MUST NOT, SHOULD, MAY.

---

## 1. Purpose

This amendment clarifies a critical ambiguity discovered during the smoke test:

```text
Selected member M = Nguyễn Thuý Văn
selected canvas depth k = 2
```

The MFO Full-Set endpoint uses two distinct identities that MUST NOT be conflated:

```text
Target M              = member selected by the user and anchored at lane k.
Resolved window root  = furthest ancestor resolved upward from M within k steps.
```

The endpoint request identifies **Target M**, not the resolved root. The response contains both identities with separate, explicit semantics.

This amendment also formalizes that BE builds a complete five-lane Standard Tree read model for the chosen `(M, k)` window. FE fulfils/renders that model from lane `0` through lane `4`; FE MUST NOT rebuild genealogy, choose a different root, infer missing Standard Trees, or transform depths to be relative to the resolved root.

---

## 2. Superseding clarification

Where prior contract wording, code names, legacy route names, UI state names, or implementation behavior conflict with this amendment, this amendment prevails.

In particular, the following equivalence is prohibited:

```text
resolvedRootMemberId != targetMemberId
```

except in the special case where M itself is the furthest resolved root.

The legacy parameter name `originId` MUST NOT cause a caller to send the resolved root as the Full-Set target.

---

## 3. Canonical identity model

### 3.1 Required identities

| Identity | Canonical name | Meaning | Used to call Full-Set? |
|---|---|---|---:|
| User-selected member | `target_member_id` | M selected by the End User | Yes |
| Selected canvas position | `selected_canvas_depth` | Absolute lane for M, integer 0..4 | Yes |
| Resolved window root | `origin.id` / `resolved_root_member_id` | Furthest ancestor found by walking upward from M within selected depth | No |
| Root canvas position | `origin.root_canvas_depth` | Lane of the resolved root | No |
| Declaration-sheet founder | `lot_founder_member_id` | Tờ-khai/lot business identity, outside Full-Set | No |

### 3.2 Mandatory distinction

```text
target_member_id:
- Determines the ancestor walk.
- MUST be the ID in the Full-Set route/path request.
- MUST appear as response.target.member_id.
- MUST be rendered at selected_canvas_depth.

origin.id:
- Is computed by BE after the ancestor walk.
- May equal target_member_id.
- MUST NOT replace target_member_id in an FE request.
- MUST NOT be used as a synonym for M.
```

### 3.3 Example: Nguyễn Thuý Văn at lane 2

```text
Input:
  target_member_id = Nguyễn Thuý Văn
  selected_canvas_depth = 2

Possible resolved path:
  Nguyễn Đình Xích -> Nguyễn Đình Xuân -> Nguyễn Thuý Văn

Response identity:
  target.member_id = Nguyễn Thuý Văn
  target.rendered_canvas_depth = 2
  origin.id = Nguyễn Đình Xích
  origin.root_canvas_depth = 0
```

The endpoint is invalid if it instead returns:

```text
target.member_id = Nguyễn Đình Xích
selected_canvas_depth = 2
```

when the request target was Nguyễn Thuý Văn.

---

## 4. Canonical endpoint

### 4.1 Canonical request

```http
GET /api/mfo/origins/:targetMemberId/full-set?selected_canvas_depth=<0..4>
```

Example:

```http
GET /api/mfo/origins/f1244f7d-3aee-4842-bf6d-e52557680b6d/full-set?selected_canvas_depth=2
```

### 4.2 Compatibility aliases

The following compatibility aliases MAY be accepted temporarily:

```text
Route parameter:
  :originId -> :targetMemberId

Query parameter:
  k -> selected_canvas_depth
```

Compatibility aliases are parsing concerns in the controller only. They MUST NOT survive into the service-layer API as ambiguous variable names.

### 4.3 Controller normalization

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

The controller MUST NOT resolve an ancestor/root and substitute it into `targetMemberId`.

---

## 5. Service API requirement

### 5.1 Required service signature

The Full-Set service MUST use an object argument with canonical names:

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

The following service signature is deprecated and MUST NOT be used for new code:

```js
getFullMfoSet(user, originId, targetMemberId, k, selectedCanvasDepth)
```

It allows accidental use of a root/origin ID where the target M is required.

### 5.2 Target lookup

The initial member lookup MUST use only `targetMemberId`:

```js
const targetMember = await prisma.members.findUnique({
  where: { id: targetMemberId },
  select: memberSelect,
});
```

BE MUST reject missing target input before querying:

```js
if (!targetMemberId) {
  fail(
    'Thiếu target member ID.',
    400,
    'MFO_ORIGIN_REQUIRED'
  );
}
```

The legacy error code may remain for compatibility, but all messages, variables, logs, and new contract fields MUST use `target member` terminology.

---

## 6. Five-lane Standard Tree model

### 6.1 Full-Set definition

For selected member M at selected canvas depth `k`, BE constructs:

\[
\mathcal{F}_5(M,k) = \{L_0,L_1,L_2,L_3,L_4\}
\]

where each lane is:

\[
L_d = \{\text{lane metadata}, \text{placeholder}, ST(d)\}
\]

and:

\[
ST(d) = \{\text{all Standard Trees whose owner/member is placed at lane } d\}
\]

`k` is the absolute lane of M. It is not a set of Standard Trees and it is not a root-relative generation.

### 6.2 Required lane completeness

BE MUST return exactly five lanes:

```text
levels.length === 5
levels[0].depth === 0
levels[1].depth === 1
levels[2].depth === 2
levels[3].depth === 3
levels[4].depth === 4
```

Each lane MUST be returned even if it is empty:

```json
{
  "depth": 0,
  "is_empty": true,
  "placeholder": {
    "kind": "empty_couple",
    "clan_member": null,
    "spouse": null
  },
  "member_ids": [],
  "nodes": [],
  "standard_trees": []
}
```

### 6.3 Standard Tree completeness in-window

For every clan member reachable in the `(M, k)` window and placed at lane `d`, BE MUST produce exactly one Standard Tree in `levels[d].standard_trees`.

```text
standard_tree.depth === d
standard_tree.parent.member.depth === d
```

For a Standard Tree at lane `d < 4`:

```text
visible children must be the reachable child members at lane d + 1.
```

For a Standard Tree at lane `4`:

```text
children[] = []
marriage_tabs[].children[] = []
```

because a visible child would occupy lane `5`, outside the fixed five-lane canvas.

### 6.4 Parent/child lane invariant

For every visible child in the response:

```text
child.member.depth === standard_tree.depth + 1
```

No child node may be returned with depth outside `0..4`.

### 6.5 FE responsibility

FE MUST fulfil/render the complete BE projection from lane 0:

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
- Start rendering from target M only.
- Start rendering from origin.root_canvas_depth only.
- Recompute lane depth relative to origin.
- Rebuild child grouping with father_id/mother_id.
- Replace target M with origin.id.
- Use members.generation as canvas depth.
```

---

## 7. Required response context

### 7.1 Production response fields

Every Full-Set response MUST include these fields:

```json
{
  "request_context": {
    "target_member_id": "string",
    "selected_canvas_depth": 2
  },
  "origin": {
    "id": "string",
    "root_canvas_depth": 0
  },
  "target": {
    "member_id": "string",
    "selected_canvas_depth": 2,
    "rendered_canvas_depth": 2,
    "resolved_ancestor_steps": 2
  }
}
```

### 7.2 Response identity invariant

```text
request_context.target_member_id
=== target.member_id
=== target_member_id used in the initial database lookup
```

```text
target.rendered_canvas_depth
=== target.selected_canvas_depth
=== request_context.selected_canvas_depth
```

```text
origin.root_canvas_depth
=== target.selected_canvas_depth - target.resolved_ancestor_steps
```

### 7.3 Optional development diagnostics

In non-production or explicit diagnostics mode, BE SHOULD return:

```json
{
  "window_summary": {
    "standard_tree_count_by_depth": {
      "0": 1,
      "1": 1,
      "2": 1,
      "3": 3,
      "4": 4
    },
    "target_standard_tree_id": "st:2:member-id"
  }
}
```

This diagnostic is intended for smoke tests and should not be used by FE as a genealogy source.

---

## 8. Mandatory server assertions

Before returning the Full-Set response, BE MUST validate the following invariants. In test/development, violations MUST throw. In production, violations MUST be logged with correlation ID and returned as an internal-contract failure.

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

  const targetNode = (nodes || []).find(
    (node) => String(node?.id) === String(targetMemberId)
  );

  if (!targetNode) {
    throw new Error('MFO_TARGET_NOT_IN_WINDOW');
  }

  if (targetNode.depth !== selectedCanvasDepth) {
    throw new Error('MFO_TARGET_DEPTH_NOT_PRESERVED');
  }

  if (
    rootCanvasDepth !==
    selectedCanvasDepth - resolvedAncestorSteps
  ) {
    throw new Error('MFO_ROOT_DEPTH_INVARIANT_BROKEN');
  }
}
```

### 8.1 Error mapping

| Condition | HTTP | Code |
|---|---:|---|
| Target missing | 400 | `MFO_ORIGIN_REQUIRED` |
| Target absent/soft-deleted | 404 | `MFO_ORIGIN_NOT_FOUND` |
| Target cross-tenant | 403 | `TENANT_MISMATCH` |
| Invalid selected depth | 400 | `MFO_INVALID_SELECTED_CANVAS_DEPTH` |
| Internal Full-Set invariant failure | 500 | `MFO_FULL_SET_INVARIANT_BROKEN` |

`MFO_FULL_SET_INVARIANT_BROKEN` MUST contain a correlation ID in logging/observability. Do not expose internal member graph details in public error text.

---

## 9. Target identity handoff

### 9.1 View Focus result

Any View Focus, picker, or page workflow may resolve a root for its own display/submission metadata, but it MUST preserve the selected member ID separately:

```ts
type ViewFocusResult = {
  targetMemberId: string;
  selectedCanvasDepth: 0 | 1 | 2 | 3 | 4;

  // May be different from targetMemberId.
  resolvedRootMemberId: string | null;

  lines: unknown[];
};
```

### 9.2 Full-Set call rule

```js
getFullMfoSet(
  viewFocusResult.targetMemberId,
  viewFocusResult.selectedCanvasDepth
);
```

Never call:

```js
getFullMfoSet(
  viewFocusResult.resolvedRootMemberId,
  viewFocusResult.selectedCanvasDepth
);
```

### 9.3 Submission rule

Plan submission and Full-Set read have separate identity requirements.

```text
Full-Set read target   = selected M.
Plan submission origin = workflow-defined origin, if the workflow still requires it.
```

The two IDs MUST use separate variables. No variable named `originId` may be reused as the Full-Set target merely because it is convenient for the submission workflow.

---

## 10. Smoke-test protocol

### 10.1 Required smoke case

```text
Selected M: Nguyễn Thuý Văn
Target member ID: f1244f7d-3aee-4842-bf6d-e52557680b6d
Selected canvas depth: 2
```

### 10.2 Required HTTP request

```http
GET /api/mfo/origins/f1244f7d-3aee-4842-bf6d-e52557680b6d/full-set?selected_canvas_depth=2
```

Legacy-compatible request is acceptable only during migration:

```http
GET /api/mfo/origins/f1244f7d-3aee-4842-bf6d-e52557680b6d/full-set?k=2
```

### 10.3 Required response assertions

```text
request_context.target_member_id
  = f1244f7d-3aee-4842-bf6d-e52557680b6d

target.member_id
  = f1244f7d-3aee-4842-bf6d-e52557680b6d

target.rendered_canvas_depth
  = 2

target.selected_canvas_depth
  = 2

nodes where is_target === true
  = exactly one node
  = Nguyễn Thuý Văn
  = depth 2
```

### 10.4 Required structural assertions

```text
levels.length = 5
levels[d].depth = d for d = 0..4

For each standard tree in levels[d]:
  tree.depth = d
  tree.parent.member.depth = d

For each visible child in tree/tabs at d < 4:
  child.member.depth = d + 1
```

### 10.5 Failure interpretation

| Observation | Owner | Required action |
|---|---|---|
| Request path contains Xích ID, not Văn ID | FE/View Focus | Fix target identity handoff |
| Request path contains Văn ID but `target.member_id` is Xích | BE | Fix controller/service target lookup |
| Request and response target are Văn but `is_target` node is not Văn at depth 2 | BE | Fix Full-Set construction/invariant failure |
| Request/response target are Văn and BE tree is correct, UI is Xích | FE | Fix state/adapter rendering |

---

## 11. Implementation checklist

### Backend

```text
[ ] Rename Full-Set service input to targetMemberId/selectCanvasDepth object.
[ ] Normalize legacy aliases only in controller.
[ ] Use targetMemberId for the initial DB lookup.
[ ] Return request_context.target_member_id and selected_canvas_depth.
[ ] Run assertFullSetInvariants before response.
[ ] Add test fixture: Nguyễn Thuý Văn @ lane 2.
[ ] Add controller integration test for both canonical and legacy aliases.
[ ] Log correlation ID for invariant violations.
```

### Frontend integration boundary

```text
[ ] Keep selected target ID separate from resolved root ID.
[ ] Call Full-Set with selected target ID only.
[ ] Assert response target.member_id equals requested target ID.
[ ] Render levels[0..4] in absolute lane order.
[ ] Do not transform depths relative to origin/root.
```

---

## 12. Definition of done

This amendment is satisfied only when a smoke selection of Nguyễn Thuý Văn at lane 2 yields:

```text
- Request target ID = Nguyễn Thuý Văn ID.
- Response target ID = Nguyễn Thuý Văn ID.
- Exactly one is_target node = Nguyễn Thuý Văn.
- is_target node depth = 2.
- Full-Set includes exactly lanes 0..4.
- Every reachable in-window clan member has exactly one Standard Tree at its assigned absolute lane.
- FE receives a complete lane-0-to-lane-4 projection and does not reconstruct genealogy.
- Resolved root identity is never substituted for target identity.
```
