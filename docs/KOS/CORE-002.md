EGAL Knowledge Operating System (KOS)
CORE-002
Enterprise Knowledge Identification Standard (EKIS)

Frozen Version 1.0
Document ID: CORE-002
Document Type: Foundational Standard (Level 2)
Status: Draft v1.0
Date: 2026-07-06
Depends on: CORE-000 (Frozen), CORE-001 (Frozen)
Audience: Knowledge Architects, Repository Maintainers, Tool Developers, AI Engineers, Architecture Review Board

This document defines the Canonical Identity System for the EGAL Knowledge Operating System. It ensures that Human, AI, Repository, Knowledge Graph, Context Assembly, and Standards all reference the same Identity, independent of file, URL, database, technology, or representation.

1. Purpose
CORE-002 defines the Enterprise Knowledge Identification Standard (EKIS) for the EGAL Knowledge Operating System. EKIS establishes a Canonical Identity System that enables consistent, stable, and technology-independent identification of all knowledge assets across the KOS.
EKIS exists to realize specific principles from CORE-001, particularly P-005 (Identity-over-Location), P-006 (Source-of-Truth), P-017 (Traceability and Provenance), P-004 (Knowledge-over-Representation), and P-007 (Architectural Intent Preservation). It does not create new principles; it operationalizes existing ones into a concrete identification standard.
The primary question EKIS answers is: How is knowledge identified consistently across the entire KOS, such that Human, AI, Repository, Knowledge Graph, Context Assembly, and Standards all reference the same Identity, independent of file, URL, database, technology, or representation?
EKIS is a Foundational Standard. It provides the identification layer upon which CORE-003 (Knowledge Object Model), CORE-004 (Knowledge Graph Model), CORE-005 (Context Assembly Specification), and subsequent documents depend. Without a stable, canonical identification system, traceability, governance, and long-term evolvability cannot be achieved.
Relationship to CORE-000: EKIS supports the Mission by enabling the assembly of Working Contexts from Knowledge Objects that are reliably identifiable and traceable to the Source of Truth, independent of how knowledge is stored or represented.
Relationship to CORE-001: EKIS is a direct realization of the principles listed above. Every normative decision in this document is traceable to one or more principles in CORE-001. No decision in EKIS creates new architectural constraints beyond those established in CORE-001.
2. Architectural Context
Identity is the foundation upon which the entire KOS is built. Without stable, canonical identity, the following capabilities cannot be realized:
• Traceability: Knowledge cannot be reliably linked to its origin in the Source of Truth.
• Governance: Changes cannot be audited, attributed, or rolled back in a controlled manner.
• Context Assembly: Working Contexts cannot be deterministically composed from Knowledge Objects if those objects cannot be uniquely and stably identified.
• Human–AI Collaboration: Both humans and AI require a common reference system to discuss, reason about, and act upon the same knowledge assets.
• Long-term Evolvability: Knowledge must survive changes in storage technology, representation format, and repository organization. Identity that is tied to any of these is inherently fragile.
In traditional document-centric or repository-centric systems, identity is often implicit or derived from physical location (file path, URL, database key). This approach works for short-term, single-technology environments but fails when knowledge must persist across decades, multiple technologies, and both human and AI consumers.
EKIS inverts this relationship. Identity is primary and canonical. Physical location, representation format, and storage technology are secondary and mutable. This inversion is the architectural shift that enables the KOS to fulfill its Mission over long time horizons.
EKIS does not define what knowledge is (that is the role of CORE-003), how knowledge is related (CORE-004), or how contexts are assembled (CORE-005). EKIS defines only how knowledge is identified, such that all other layers can reference it consistently and reliably.
3. Identity Principles
EKIS realizes the following principles from CORE-001. No new principles are created in this document. Every normative requirement below is derived from one or more of these principles.
P-005 — Identity-over-Location Principle (CORE-001)
Realization in EKIS: Canonical Identity shall be independent of physical or logical storage location. Identity shall be stable and portable across changes in repository structure, storage technology, or hosting environment. Physical Path shall be treated as metadata only, never as part of Canonical Identity.
P-006 — Source-of-Truth Principle (CORE-001)
Realization in EKIS: All Canonical Identities shall maintain explicit traceability to the EGAL Enterprise Architecture repository as the Source of Truth. No identity shall be considered authoritative unless it derives from or is reconciled with this repository. Working Contexts are assembled views and shall not accumulate independent identity authority.
P-017 — Traceability and Provenance Principle (CORE-001)
Realization in EKIS: Every Canonical Identity shall carry explicit, auditable provenance linking it to its origin in the Source of Truth and to the decisions that created or modified it. Identity changes shall be versioned and traceable.
P-004 — Knowledge-over-Representation Principle (CORE-001)
Realization in EKIS: Canonical Identity shall be independent of representation format. The same knowledge asset shall retain the same Canonical Identity whether it is rendered as a document, structured data, graph node, or any other form.
P-007 — Architectural Intent Preservation Principle (CORE-001)
Realization in EKIS: Canonical Identity shall preserve the ability to attribute and query architectural intent, rationale, and constraints. Identity mechanisms shall not obscure or lose intent when representation or technology changes.
P-020 — Technology Independence and Long-term Evolvability Principle (CORE-001)
Realization in EKIS: Canonical Identity mechanisms shall be independent of any specific technology, platform, or vendor. Identity shall remain functional and coherent across technological generations.
These mappings establish the normative foundation for EKIS. Any requirement in this document that cannot be traced to one or more of these principles is outside scope and shall be removed or revised.
4. Identity Model
EKIS defines a layered identity model consisting of three primary layers: Canonical Identity, Semantic Identity, and Physical Path. These layers are strictly ordered: Canonical Identity is primary; Semantic Identity provides human-readable and machine-resolvable context; Physical Path is mutable metadata.
Canonical Identity
Canonical Identity is the unique, immutable, technology-independent identifier assigned to a Knowledge Asset. It is the single source of truth for identity within the KOS. Canonical Identity shall satisfy the following invariants:
• Uniqueness: Each Canonical Identity shall identify exactly one Knowledge Asset within the scope of the KOS.
• Immutability: Once assigned, a Canonical Identity shall not change for the lifetime of the Knowledge Asset.
• Stability: Canonical Identity shall persist across changes in representation, storage technology, repository organization, and governance status (except deprecation and archival, which are governed transitions).
• Independence: Canonical Identity shall not embed or depend on file paths, URLs, database keys, repository-internal identifiers, or any technology-specific construct.
• Traceability: Every Canonical Identity shall carry explicit provenance linking it to the Source of Truth and to the decisions that created or modified it.
Identity Components
A Canonical Identity consists of the following components:
• Namespace: A controlled prefix indicating the class of Knowledge Asset (e.g., KO for Knowledge Object, ADR for Architecture Decision Record, PAT for Pattern). Namespaces are governed and versioned.
• Local Identifier: A unique string within the namespace, assigned according to governed rules. Local Identifiers shall be opaque to human interpretation; meaning is carried by Semantic Identity, not by the Local Identifier itself.
• Version (optional for immutable assets): For assets that evolve, a version component may be included. For immutable assets (e.g., frozen decisions), version is not required as part of Canonical Identity.
Identity Invariants
The following invariants shall hold for all Canonical Identities:
• A Canonical Identity shall not be reassigned to a different Knowledge Asset.
• A Knowledge Asset shall have exactly one Canonical Identity at any point in its lifecycle (except during controlled migration, which is governed).
• Canonical Identity shall survive representation changes, storage migration, and repository reorganization.
• Canonical Identity shall not encode or imply physical location, format, or technology.
Identity Independence
Canonical Identity is independent of Semantic Identity and Physical Path. Semantic Identity provides human-readable and queryable context (e.g., mission.statement, knowledge.identity.canonical). Physical Path is a mutable attribute recorded as metadata, never as part of Canonical Identity. This strict separation ensures that identity remains stable while storage and representation evolve.
5. Asset Classification
EKIS defines a high-level classification of Knowledge Assets for the purpose of identity assignment. This classification is not a taxonomy of knowledge content (that is the role of CORE-003). It is a classification of asset types that require distinct identity treatment.
The following classes are recognized for identity purposes:
• Knowledge Asset (generic): Any identifiable unit of organizational knowledge that has value for decision-making, reasoning, or action. This is the superclass for all other classes.
• Knowledge Object: A formalized, stable representation of a Knowledge Asset with canonical identity, explicit semantics, and defined relationships (detailed in CORE-003).
• Architecture Decision Record (ADR): A documented architectural decision, including context, decision, and consequences.
• Pattern: A reusable solution to a recurring problem, documented with context, problem, solution, and consequences.
• Schema: A formal definition of structure or semantics (e.g., data schema, ontology fragment, principle schema).
• Workflow: A defined sequence of activities or processes.
• Context Package: An assembled Working Context or a governed package of knowledge prepared for a specific purpose.
• AI Work Package: A package of knowledge prepared specifically for AI consumption, including prompts, context, and constraints.
• Graph Node: A node in the Knowledge Graph representing a Knowledge Object or other asset.
• Graph Edge: A relationship in the Knowledge Graph connecting two nodes.
Each class shall be assigned a distinct namespace for Canonical Identity. The classification ensures that identity assignment rules can be tailored to the nature of the asset while maintaining overall consistency and governance.
This classification is intentionally high-level. Detailed definitions of each class, including their structure and semantics, are reserved for CORE-003 and subsequent documents. EKIS only requires that each class be distinguishable for identity assignment purposes.
6. Canonical Identifier
The Canonical Identifier is the concrete realization of Canonical Identity. It is the string that uniquely and immutably identifies a Knowledge Asset within the KOS.
Format
A Canonical Identifier shall follow the form:
<Namespace>-<LocalIdentifier>[-<Version>]
Examples (illustrative only; actual assignment rules are governed):
• KO-000123 — Knowledge Object number 000123
• ADR-001 — Architecture Decision Record number 001
• PAT-004 — Pattern number 004
• SCHEMA-007 — Schema number 007
Namespaces are controlled vocabulary. New namespaces shall be proposed, reviewed, and approved through governed processes before use. Local Identifiers shall be opaque; they shall not encode semantic meaning. Meaning is carried exclusively by Semantic Identity.
Uniqueness
Canonical Identifiers shall be unique within the scope of the KOS. Uniqueness shall be enforced by a governed registry or equivalent mechanism. No two Knowledge Assets shall share the same Canonical Identifier at the same time.
Immutability
Once assigned and approved, a Canonical Identifier shall not change. Immutability applies to the Namespace and Local Identifier components. Version components may increment according to governed rules for assets that evolve.
Stability and Lifetime
A Canonical Identifier shall persist for the lifetime of the Knowledge Asset, including across status transitions (Draft → Review → Approved → Frozen → Deprecated → Archived). Deprecation and archival are governed status changes; they do not alter the Canonical Identifier itself.
Resolution
Given a Canonical Identifier, it shall be possible to resolve the corresponding Knowledge Asset (or its current representation) through governed mechanisms. Resolution shall return the asset or a reference to it, along with its current status and provenance. Resolution mechanisms shall be technology-independent in their interface, even if specific implementations are technology-specific.
Governance
Assignment, modification (only in controlled cases such as migration), and deprecation of Canonical Identifiers shall be governed. Governance rules shall include collision detection, approval workflows, audit logging, and migration procedures. No ad-hoc or manual assignment of Canonical Identifiers shall be permitted outside governed channels.
7. Semantic Identity
Semantic Identity provides human-readable and machine-resolvable context for a Knowledge Asset. It is layered on top of Canonical Identity and does not replace it.
Purpose
While Canonical Identity is opaque and immutable, Semantic Identity carries meaning. It enables humans to understand what a Knowledge Asset represents and enables machines to query and navigate knowledge based on semantic categories.
Examples of Semantic Identity (illustrative):
• mission.statement
• knowledge.identity.canonical
• graph.relationship.type
• decision.architectural.context
• pattern.problem.statement
Semantic Identity shall not be used as a substitute for Canonical Identity in references, traceability, or governance. It is supplementary context, not the authoritative identifier.
Semantic Identity shall be independent of physical storage and representation. It describes what the asset means within the KOS, not where it is stored or how it is rendered.
Governance of Semantic Identity (e.g., controlled vocabulary for semantic paths, versioning of semantic categories) is part of EKIS governance but is secondary to Canonical Identity governance.
8. Physical Independence
Physical Path (file path, URL, database key, repository-internal identifier) shall never be part of Canonical Identity. Physical Path is mutable metadata recorded as an attribute of a Knowledge Asset, not as its identity.
The strict ordering is:
Canonical Identity (immutable, primary)
          ↓
Semantic Identity (context, queryable)
          ↓
Physical Path (mutable metadata, implementation detail)
This ordering shall never be inverted. No mechanism shall derive Canonical Identity from Physical Path. No reference within the KOS shall use Physical Path as a substitute for Canonical Identity.
Physical Path may change due to repository reorganization, storage migration, technology upgrade, or representation change. Such changes shall be recorded as metadata updates, not as identity changes. All references using Canonical Identity shall continue to resolve correctly after such changes.
Physical Independence is a direct realization of P-005 (Identity-over-Location) and P-020 (Technology Independence and Long-term Evolvability). It is essential for the KOS to survive technological change without breaking traceability or requiring mass updates to references.
9. Identity Lifecycle
Every Knowledge Asset with a Canonical Identity shall progress through a governed lifecycle. The lifecycle status shall be recorded as metadata associated with the Canonical Identity. Status changes shall be versioned and auditable.
Standard Lifecycle States
• Draft: The asset is under development. Identity may be provisional. Traceability to Source of Truth is required but full governance review may not yet have occurred.
• Review: The asset is under formal review. Identity is stable. Changes require justification and audit trail.
• Approved: The asset has passed review. Identity is stable. It may be referenced by other assets.
• Frozen: The asset is frozen as an authoritative reference (per P-019). Identity is immutable. Changes require new version or new asset through governed evolution.
• Deprecated: The asset is no longer recommended for use. Identity remains stable. References should migrate to successor assets. Deprecation does not delete or reassign identity.
• Archived: The asset is retained for historical or audit purposes but is no longer active. Identity remains stable. Resolution may return the archived asset or a pointer to its successor.
Version and Revision
For assets that evolve, version increments shall be governed. Version is part of the identity model for evolving assets but does not alter the base Canonical Identity of the asset lineage. Revision (minor changes that do not warrant version increment) shall be recorded as metadata, not as identity change.
Identity itself does not change across lifecycle states. Only status metadata and (for evolving assets) version components change. This ensures that references using Canonical Identity remain valid throughout the asset's life.
10. Governance
EKIS governance ensures that Canonical Identity assignment, resolution, and evolution are controlled, auditable, and aligned with CORE-001 principles.
Registry
A governed registry (or equivalent mechanism) shall maintain the authoritative mapping between Canonical Identities and Knowledge Assets. The registry shall enforce uniqueness, prevent collisions, record provenance, and support resolution. Registry implementation may be technology-specific, but the interface and governance rules shall be technology-independent.
Resolution
Resolution mechanisms shall accept a Canonical Identity and return the corresponding asset (or current representation) along with status, provenance, and applicable metadata. Resolution shall be deterministic given stable inputs. Multiple resolution implementations may exist for different consumers (human, AI, tooling), but all shall return consistent results for the same Canonical Identity.
Uniqueness and Collision
Uniqueness shall be enforced at the point of identity assignment. Collision detection and resolution procedures shall be defined and governed. In the event of collision, the registry shall reject the assignment and require resolution through governed processes. No ad-hoc collision resolution shall be permitted.
Deprecation and Migration
Deprecation of a Canonical Identity shall follow governed procedures. Migration from a deprecated identity to a successor shall be recorded and auditable. References using the deprecated identity should be updated through governed processes. The deprecated identity shall remain resolvable for historical and audit purposes.
Audit
All identity operations (assignment, status change, deprecation, migration, resolution) shall be logged with timestamp, actor, justification, and before/after state. Audit logs shall be queryable and retained for the lifetime of the KOS plus a governed retention period.
11. Compliance
A component, tool, standard, or implementation may claim EKIS Compliance if and only if it satisfies all of the following:
• All references to Knowledge Assets use Canonical Identity as the primary and authoritative identifier.
• Physical Path, URL, database key, or any technology-specific identifier is never used as a substitute for Canonical Identity in references, traceability, or governance.
• Canonical Identity assignment, resolution, and status changes follow the governance rules defined in this document.
• Provenance and traceability to the Source of Truth are maintained for all Canonical Identities.
• Identity mechanisms are independent of representation format; the same Knowledge Asset retains the same Canonical Identity across representation changes.
• Lifecycle status is recorded and transitions are governed and auditable.
• The component does not create, assign, or modify Canonical Identities outside governed mechanisms.
Compliance shall be verifiable through audit of references, registry operations, and traceability chains. Non-compliance shall be grounds for Architecture Board rejection of any proposal or implementation that claims to operate within the KOS.
12. Relationship to Future CORE
EKIS provides the identification foundation for all subsequent CORE documents. The following summarizes how future CORE documents shall use EKIS:
CORE-003 (Knowledge Object Model): Shall use Canonical Identity as the primary identifier for Knowledge Objects. All references, relationships, and provenance within the model shall be expressed using Canonical Identity. Physical storage or representation concerns shall be treated as implementation details, not as part of the model.
CORE-004 (Knowledge Graph Model): Shall use Canonical Identity to identify nodes and to express relationships. The graph shall be traversable and queryable by Canonical Identity. Physical storage of the graph shall be independent of identity.
CORE-005 (Context Assembly Specification): Shall reference Knowledge Objects by Canonical Identity when assembling Working Contexts. Assembly rules and provenance shall be expressed in terms of Canonical Identity. Working Contexts themselves may have Canonical Identity (as Context Packages), but they shall be treated as assembled views, not as new sources of truth.
CORE-006 (AI Collaboration Protocol): Shall use Canonical Identity in requests and responses. AI systems shall reference Knowledge Assets and Working Contexts by Canonical Identity. Protocols shall not assume or require knowledge of physical storage or representation.
CORE-007 (Knowledge Operating System Architecture): Shall integrate EKIS as the identification layer. All architectural views, interfaces, and governance processes shall be consistent with EKIS rules. Technology choices for registry, resolution, and storage shall be evaluated against EKIS compliance.
Any future CORE document that references Knowledge Assets shall do so using Canonical Identity. Any mechanism that bypasses or substitutes for Canonical Identity is non-compliant with EKIS and, by extension, with the principles it realizes.
13. Summary
CORE-002 (EKIS) defines the Canonical Identity System for the EGAL Knowledge Operating System. It ensures that all components — Human, AI, Repository, Knowledge Graph, Context Assembly, and Standards — reference the same Identity, independent of file, URL, database, technology, or representation.
EKIS realizes P-005 (Identity-over-Location), P-006 (Source-of-Truth), P-017 (Traceability and Provenance), P-004 (Knowledge-over-Representation), P-007 (Architectural Intent Preservation), and P-020 (Technology Independence and Long-term Evolvability) from CORE-001. Every normative decision in this document is traceable to one or more of these principles.
The identity model consists of Canonical Identity (immutable, primary), Semantic Identity (context, queryable), and Physical Path (mutable metadata). Physical Path shall never be part of Canonical Identity. This strict separation enables long-term stability and evolvability.
EKIS defines Canonical Identifier format, lifecycle states, governance rules, resolution mechanisms, and compliance criteria. It provides the identification foundation upon which CORE-003 through CORE-007 and all KOS implementations depend.
Future CORE documents shall use Canonical Identity as the primary reference mechanism. EKIS compliance is a prerequisite for any component claiming to operate within the KOS.