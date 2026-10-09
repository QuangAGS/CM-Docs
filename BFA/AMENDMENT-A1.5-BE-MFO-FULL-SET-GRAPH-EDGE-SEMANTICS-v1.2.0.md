# Amendment A-1.5 to BE MFO Full-Set v2 Contract v1.2.0

- **Amendment version:** A-1.5.0
- **Supersedes:** `AMENDMENT-A1.4-BE-MFO-FULL-SET-GRAPH-EDGE-SEMANTICS-v1.2.0`
- **Base contract:** `BE-MFO-FULL-SET-V2-UNION-CHILD-AVATAR-CONTRACT-v1.2.0`
- **Depends on:** `AMENDMENT-A1.3-BE-MFO-FULL-SET-V2-UNION-CHILD-AVATAR-CONTRACT-v1.2.0`
- **Status:** Proposed — approve before FE graph-edge patching
- **Date:** 2026-10-02
- **Scope:** Marriage-tab existence, unassigned-child edges, active-tab rendering, literal-union limits, tab ordinal, and count display. No change to target identity, lane model, or Standard Tree construction.
- **Normative terms:** MUST, MUST NOT, SHOULD, MAY.

---

## 1. Changelog A-1.5

This revision keeps the A-1.4 topology and adds the clarifications required before the FE patch:

- Only the active tab emits visible union-child edges. Inactive tabs keep their counts and do not require a source handle.
- Unassigned edges stay visible when the active tab changes.
- A literal or unknown-spouse tab is display-only and MUST NOT accept a new child assignment.
- "No partner card" means no implicit spouse face, not the removal of the owner Standard Tree.
- The primary fixture uses a canonical wife member. A literal union is a separate fixture.
- Array position MUST NOT normalize `owner_marriage_order`.

---

## 2. Purpose

This amendment separates two relationships that the canvas must not draw as the same edge:

```text
Unassigned child     = clan child of the Standard Tree owner with no parent union.
Union child          = clan child whose parent_union_id is that marriage record.
```

A missing mother is not a marriage. A declared marriage is not the source of an unassigned child.

---

## 3. Marriage tab existence

A marriage tab MUST exist only when a `marriages` record exists.

```text
One tab = one marriages.id.
No marriages record
→ no marriage tab
→ no spouse or partner projection for an implicit union
→ no blank spouse face
→ no empty-union card
→ no marriage order
```

The owner Standard Tree still exists and MUST render. An unassigned child edge leaves that owner, not a missing spouse card.

`father_id` plus `mother_id = null` plus `parent_union_id = null` MUST NOT create an implicit union such as:

```text
owner + "vợ chưa rõ"
```

That child is an unassigned-child provenance, not a marriage whose partner is unknown.

---

## 4. Literal and unknown-spouse tabs

A partner label is allowed only on a real marriage record whose spouse endpoint is null or literal. The label is the literal name, or "Chưa rõ" when no name exists.

That tab is a display union only:

```text
supports_parent_union_assignment MUST be false.
No new child may be attached to it under v2.
A legacy child row already carrying that union id is returned as degraded
or unassigned according to the existing parent-union policy.
It MUST NOT be drawn as a solid child of the literal tab.
```

---

## 5. Child membership

A child belongs to marriage tab U if and only if:

```text
child.parent_union_id === U.id
```

`father_id`, `mother_id`, gender, the sole visible tab, and the active tab MUST NOT add a child to a tab.

```text
parent_union_id = null
→ child is in unassigned_children[]
→ reason is PARENT_UNION_UNSET, unless a more specific existing reason applies
→ the child is not a child of the active tab
```

---

## 6. Edge topology

BE does not return React Flow handle ids. FE derives anchors from `union_id`, `parent_union_id`, and the unassigned reason.

```text
Union child edge:
  kind = PARENT_UNION_CHILD
  anchor = the marriage tab whose union_id equals parent_union_id
  style = solid

Unassigned child edge:
  kind = UNASSIGNED_CHILD
  anchor = the Standard Tree owner
  style = dashed
  label = "Chưa gắn hôn phối"
```

FE MUST NOT attach an unassigned edge to the active marriage tab, the partner face, or the active tab's child anchor.

One card per Standard Tree remains allowed. When both kinds of child are present, the card MUST expose two distinct anchors:

```text
owner anchor      = unassigned children
active-tab anchor = children of the open marriage tab
```

Left or right placement is presentation. The anchor kind is the contract.

### 6.1 Active tab rendering

When a Standard Tree card presents tabs, only the active tab owns visible `PARENT_UNION_CHILD` edges. Switching the active tab replaces that visible edge set. This is a rendering policy and does not change membership in `marriage_tabs[]`.

Inactive tabs:

```text
- retain their BE child_count
- do not emit visible child edges
- do not expose or require an active source handle
```

### 6.2 Unassigned visibility

`UNASSIGNED_CHILD` edges are independent of the active tab. They remain visible whenever the unassigned child is inside the current five-lane window.

---

## 7. Tab ordinal and counts

The tab marker MUST be `owner_marriage_order`.

```text
FE MUST NOT render array index + 1 as the marriage order.
A missing order renders as "?", not as 1.
tabs[0].owner_marriage_order MAY equal 2.
Array position MUST NOT mutate or normalize the business ordinal.
Display position and business ordinal are different values.
```

Counts are separate:

```text
tab.child_count        = children whose parent_union_id is that union
unassigned count       = unassigned_children.length
```

FE MUST NOT use the owner's total child count as the active tab count.

For the Xích fixture, the active second marriage shows "1 con" when "Con bà 2" is attached to that union. The owner warning shows "1 con chưa gắn hôn phối" for Nguyễn Đình Xuân. It MUST NOT show "0 con" on that tab together with "2 con chưa gắn hôn phối" when one of those children has `parent_union_id` equal to the second union.

---

## 8. Required fixtures

### 8.1 Primary fixture: canonical wife

```text
Owner: Nguyễn Đình Xích

Nguyễn Đình Xuân:
  father_id = Xích
  mother_id = null
  parent_union_id = null

Marriage U2:
  a real marriages record
  husband_id = Xích
  wife_id = Vợ hai ông Xích
  spouse_name_literal = null
  owner_marriage_order = 2

Con bà 2:
  father_id = Xích
  mother_id = Vợ hai ông Xích
  parent_union_id = U2
  child_type = CON_DE
```

Expected projection:

```json
{
  "marriage_tabs": [
    {
      "union_id": "U2",
      "owner_marriage_order": 2,
      "partner": { "full_name": "Vợ hai ông Xích" },
      "child_count": 1,
      "children": [
        {
          "member": {
            "full_name": "Con bà 2",
            "parent_union_id": "U2"
          }
        }
      ]
    }
  ],
  "unassigned_children": [
    {
      "member": {
        "full_name": "Nguyễn Đình Xuân",
        "parent_union_id": null
      },
      "reason": "PARENT_UNION_UNSET"
    }
  ]
}
```

Expected graph:

```text
Xích  - - - - >  Nguyễn Đình Xuân
      dashed, owner anchor, visible on every tab

Xích | Vợ hai
      ------->  Con bà 2
      solid, U2 anchor, tab marker 2, child_count 1
```

The single visible tab still carries ordinal 2. FE MUST NOT renumber it to 1.

If "Con bà 2" is still in `unassigned_children`, the register has not attached `parent_union_id`. An FE anchor change MUST NOT draw that child as a solid union child.

### 8.2 Separate fixture: literal union

A literal-spouse union is not part of the primary fixture. It MUST render as a display tab only, with `supports_parent_union_assignment = false`, and MUST NOT receive a new solid child edge.

---

## 9. FE patch boundary

After this amendment is approved, the minimum patch is the FE graph layer:

```text
mfoGraphAdapter.js
  unassigned edge uses the owner anchor
  solid edge uses the active union anchor only

FamilyCoupleNode.jsx
  owner source handle and active-union source handle
  tab marker uses owner_marriage_order, or "?" when absent

OpMfoPlanPage.jsx
  no business-state change; existing active-tab state is the base

BE
  no new grouping patch when the fixture payload already places
  Con bà 2 on U2 and Xuân in unassigned_children
```

---

## 10. Definition of done

```text
- A tab exists only for a marriages record.
- No implicit empty spouse is created from a null mother.
- The owner Standard Tree still renders when it has no marriage tab.
- Unassigned edges leave the owner anchor, stay visible across tabs, and never leave the active tab.
- Visible union edges leave only the active matching marriage tab.
- Inactive tabs keep their counts and emit no edges.
- A literal tab is display-only and accepts no new child assignment.
- Tab marker is owner_marriage_order and is not normalized by array position.
- Tab count and unassigned count are independent.
- The canonical Xích fixture matches section 8.1 when the second child is attached to U2.
```
