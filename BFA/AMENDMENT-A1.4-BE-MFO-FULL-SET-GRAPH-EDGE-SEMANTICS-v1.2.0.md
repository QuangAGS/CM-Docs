# Amendment A-1.4 to BE MFO Full-Set v2 Contract v1.2.0

- **Amendment version:** A-1.4.0
- **Supersedes:** none. Adds graph-edge semantics on top of A-1.3.0.
- **Base contract:** `BE-MFO-FULL-SET-V2-UNION-CHILD-AVATAR-CONTRACT-v1.2.0`
- **Depends on:** `AMENDMENT-A1.3-BE-MFO-FULL-SET-V2-UNION-CHILD-AVATAR-CONTRACT-v1.2.0`
- **Status:** Proposed — approve before FE graph-edge patching
- **Date:** 2026-10-02
- **Scope:** Marriage-tab existence, unassigned-child edges, tab ordinal, and count display. No change to target identity, lane model, or Standard Tree construction.
- **Normative terms:** MUST, MUST NOT, SHOULD, MAY.

---

## 1. Purpose

This amendment separates two relationships that the canvas must not draw as the same edge:

```text
Unassigned child     = clan child of the Standard Tree owner with no parent union.
Union child          = clan child whose parent_union_id is that marriage record.
```

A missing mother is not a marriage. A declared marriage is not the source of an unassigned child.

---

## 2. Marriage tab existence

A marriage tab MUST exist only when a `marriages` record exists.

```text
One tab = one marriages.id.
No marriages record
→ no tab
→ no partner card
→ no spouse placeholder
→ no marriage order
```

`father_id` plus `mother_id = null` plus `parent_union_id = null` MUST NOT create an implicit union such as:

```text
owner + "vợ chưa rõ"
```

That child is an unassigned-child provenance, not a marriage whose partner is unknown.

A partner placeholder is allowed only on a real marriage record whose spouse endpoint is null or literal. The label is the literal name, or "Chưa rõ" when no name exists. Only children with `parent_union_id` equal to that union id connect to it.

---

## 3. Child membership

A child belongs to marriage tab U if and only if:

```text
child.parent_union_id === U.id
```

`father_id` and `mother_id` MUST NOT add a child to a tab.

```text
parent_union_id = null
→ child is in unassigned_children[]
→ reason is PARENT_UNION_UNSET, unless a more specific existing reason applies
→ the child is not a child of the active tab
```

---

## 4. Edge topology

BE does not return React Flow handle ids. FE derives anchors from the fields below.

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

One card per Standard Tree remains allowed. The card MUST still expose two distinct anchors when both kinds of child are present:

```text
owner anchor      = unassigned children
active-tab anchor = children of the open marriage tab
```

Left or right placement is presentation. The anchor kind is the contract.

---

## 5. Tab ordinal and counts

The tab marker MUST be `owner_marriage_order`.

```text
FE MUST NOT render array index + 1 as the marriage order.
A missing order renders as "?", not as 1.
```

Counts are separate:

```text
tab.child_count        = children whose parent_union_id is that union
unassigned count       = unassigned_children.length
```

FE MUST NOT use the owner's total child count as the active tab count.

For the Xích fixture, the active second marriage shows "1 con" when "Con bà 2" is attached to that union. The owner warning shows "1 con chưa gắn hôn phối" for Nguyễn Đình Xuân. It MUST NOT show "0 con" on that tab together with "2 con chưa gắn hôn phối" when one of those children has `parent_union_id` equal to the second union.

---

## 6. Required fixture

```text
Owner: Nguyễn Đình Xích

Nguyễn Đình Xuân:
  father_id = Xích
  mother_id = null
  parent_union_id = null

Marriage U2:
  a real marriages record
  owner_marriage_order = 2
  partner = Vợ hai ông Xích

Con bà 2:
  parent_union_id = U2
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
        { "member": { "full_name": "Con bà 2", "parent_union_id": "U2" } }
      ]
    }
  ],
  "unassigned_children": [
    {
      "member": { "full_name": "Nguyễn Đình Xuân", "parent_union_id": null },
      "reason": "PARENT_UNION_UNSET"
    }
  ]
}
```

Expected graph:

```text
Xích  - - - - >  Nguyễn Đình Xuân
      dashed, owner anchor

Xích | Vợ hai
      ------->  Con bà 2
      solid, U2 anchor, tab marker 2, child_count 1
```

If "Con bà 2" is still in `unassigned_children`, the register has not attached `parent_union_id`. An FE anchor change MUST NOT draw that child as a solid union child.

---

## 7. Definition of done

```text
- A tab exists only for a marriages record.
- No implicit empty spouse is created from a null mother.
- Unassigned edges leave the owner anchor and never the active tab.
- Union edges leave only the matching marriage tab.
- Tab marker is owner_marriage_order.
- Tab count and unassigned count are independent.
- The Xích fixture matches section 6 when the second child is actually attached to U2.
```
