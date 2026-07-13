EGAL Knowledge Operating System (KOS)
CORE-001
Core Principles

Frozen Version 1.1 – Minor Architectural Revision
Document ID: CORE-001
Document Type: Constitutional Standard (Level 1)
Status: Draft v1.1
Date: 2026-07-06
Depends on: CORE-000 (Frozen)
Audience: Architecture Board, Knowledge Architects, Standard Authors

This document defines the immutable principles that every future decision of the EGAL Knowledge Operating System must obey. It is the Constitutional Principles layer of the KOS governance hierarchy.

1. Introduction
CORE-001 defines the immutable principles that govern the design, evolution, and operation of the EGAL Knowledge Operating System (KOS). These principles are derived directly from the Mission and Design Objectives established in CORE-000 and serve as the enduring foundation for all subsequent CORE standards, models, specifications, and implementations.
While CORE-000 articulates why the KOS exists, CORE-001 articulates what must never be violated, regardless of changes in technology, implementation approaches, or organizational context. These principles are intended to remain stable over decades, providing a consistent reference against which all KOS-related decisions can be evaluated.
Every principle in this document is normative. Each principle includes a clear statement, rationale, implications, applicability, and guidance on what constitutes a violation. This structure ensures that the principles are actionable for Architecture Board review, standard authors, and implementers, while remaining independent of any specific technology or representation format.
CORE-001 is the second document in the CORE Series and the first that defines binding constraints on future work. All CORE-002 through CORE-007 documents, as well as any implementation or tooling developed under the KOS program, shall demonstrate compliance with these principles.
2. Role of Principles
The KOS governance hierarchy can be understood as a layered structure in which each layer provides increasing specificity while remaining constrained by the layers above it:
Mission (CORE-000)
          ↓
Principles (CORE-001)
          ↓
Standards (CORE-002 to CORE-007)
          ↓
Models and Specifications
          ↓
Implementation
The Mission layer defines the fundamental purpose. The Principles layer translates that purpose into enduring constraints and guidance. The Standards layer operationalizes the principles into specific requirements for identification, modeling, assembly, and collaboration. Lower layers provide the detailed mechanisms and technologies that realize the standards.
Principles occupy a unique and critical position in this hierarchy. They are more specific than the Mission but more abstract and timeless than any standard or implementation. A principle does not prescribe how to implement context assembly or how to structure a Knowledge Graph. Instead, it establishes what any such implementation must honor — for example, that Working Context is the unit of Human–AI collaboration, or that Knowledge must remain independent of its representation.
This positioning enables several essential outcomes:
• Long-term stability: Principles can remain unchanged even as technologies, tools, and even modeling approaches evolve.
• Traceability: Every standard and implementation decision can be traced upward to the principles it serves and ultimately to the Mission.
• Governance: The Architecture Board can evaluate proposals and designs against a stable, normative reference rather than against shifting preferences or implementation details.
• Coherence: Different workstreams and contributors can make independent decisions while remaining aligned on fundamental constraints.
Without a clear Principles layer, the KOS would risk either remaining at the level of high-level vision (too abstract for practical guidance) or collapsing directly into implementation-specific standards (too brittle for long-term evolution). CORE-001 fills this essential gap.
3. Principle Framework
The principles in CORE-001 are organized into five thematic groups. This grouping provides conceptual clarity and supports traceability, while the principles themselves remain the primary unit of reference.
Foundational Principles establish the highest-level constraints derived directly from the KOS Mission. They address the relationship between the KOS and its purpose, the priority of problem understanding over solution optimization, the centrality of Working Context, and the preservation of architectural intent.
Knowledge Principles address the nature of knowledge within the KOS: its canonical identity, semantic clarity, explicit relationships, and independence from representation.
Human–AI Collaboration Principles define the conditions under which humans and AI systems interact through the KOS, with emphasis on Working Context as the unit of collaboration, shared understanding, determinism, and the preservation of human authority over organizational knowledge.
Governance Principles establish requirements for identity management, traceability, version integrity, and the disciplined process of review and freezing that protects the long-term coherence of the KOS.
Evolution Principles ensure that the KOS can adapt and improve over time without violating its foundational commitments. They emphasize technology independence, long-term evolvability, and backward compatibility as a design consideration.
This framework is not a strict taxonomy. Some principles have implications that cross group boundaries. The Principle Interaction chapter (Chapter 9) addresses how principles relate to one another and how conflicts are resolved.
4. Foundational Principles
P-001 — Mission-first Principle
Statement: Every architectural decision within the KOS shall be justified by its contribution to fulfilling the Mission defined in CORE-000. Decisions that cannot demonstrate such justification shall not be adopted.
Rationale: The Mission is the sole reason for the existence of the KOS. Justification against the Mission ensures that every decision — whether in standards development, governance, or implementation — remains aligned with the fundamental purpose. This principle prevents drift toward locally optimal but globally misaligned solutions.
Implications: Architecture Board reviews, standard proposals, and implementation decisions must explicitly articulate how they serve the Mission. Proposals lacking clear Mission justification shall be rejected or revised.
Applies To: All CORE documents, tooling, processes, and governance decisions within the KOS program.
Violations: Adopting a decision, standard, or mechanism that optimizes for technical convenience, organizational preference, or short-term metrics without demonstrating contribution to the Mission. Allowing implementation concerns to override Mission alignment.
Related Principles: P-002, P-003, P-006
P-002 — Problem-first Principle
Statement: Solution optimization shall never precede explicit problem understanding. Every proposed solution, mechanism, or standard shall be preceded by a clear articulation of the problem it addresses, validated against the Mission and Design Objectives.
Rationale: Premature optimization is a primary source of architectural debt in long-lived systems. Solutions that appear efficient in the short term can become constraints that prevent future evolution or violate foundational principles. Explicit problem understanding is a prerequisite for sound, durable design.
Implications: Standard authors and implementers shall document the problem being addressed and its relationship to the Mission before specifying mechanisms. The Architecture Board shall require problem articulation as part of any review.
Applies To: Development of all CORE standards, models, and implementation proposals.
Violations: Proposing or adopting a technical mechanism, data structure, or protocol without first demonstrating a clear understanding of the problem it solves. Optimizing for secondary concerns (performance, familiarity, tooling) before the primary problem is defined and validated.
Related Principles: P-001, P-003
P-003 — Context-first Principle
Statement: Working Context shall be the primary unit of Human–AI collaboration within the KOS. Both humans and AI systems shall interact with the KOS through assembled Working Contexts as their normal mode of operation, rather than directly with raw documents, unassembled Knowledge Objects, or undifferentiated knowledge stores.
Rationale: The Mission of the KOS is to assemble the correct Working Context. Working Context is the execution unit that enables effective collaboration. This principle ensures that the architecture remains focused on the outcome that serves the Mission, rather than on intermediate artifacts or raw knowledge stores.
Implications: Context Assembly mechanisms, protocols, and interfaces shall be designed around the production, delivery, and consumption of Working Contexts. Standards for Knowledge Objects and the Knowledge Graph shall support, but not replace, the primacy of Working Context as the collaboration unit for both human and AI consumers.
Applies To: CORE-005 (Context Assembly Specification), CORE-006 (AI Collaboration Protocol), and all mechanisms that mediate between knowledge stores and consumers.
Violations: Designing systems in which AI agents or human users are expected to navigate, query, or reason directly over unassembled Knowledge Objects or document collections as their primary interaction mode. Treating the Knowledge Graph itself as the collaboration surface rather than as infrastructure for context assembly.
Related Principles: P-001, P-004, P-012
P-004 — Knowledge-over-Representation Principle
Statement: Knowledge within the KOS shall be independent of any specific representation format. The identity, semantics, and relationships of Knowledge Objects shall persist regardless of whether they are rendered as documents, structured data, graphs, or any other form.
Rationale: Documents, PDFs, HTML pages, and modeling tool outputs are representations. They are valuable for human communication but are not the knowledge itself. Coupling knowledge identity or semantics to a particular representation creates fragility: changes in tooling, format standards, or presentation requirements can break traceability or force costly migrations. Representation independence is essential for long-term evolvability.
Implications: All standards for Knowledge Objects, the Knowledge Graph, and Context Assembly shall define identity and semantics in representation-independent terms. Mechanisms for rendering or serializing knowledge into specific formats shall be treated as views or projections, not as the authoritative form.
Applies To: CORE-003 (Knowledge Object Model), CORE-004 (Knowledge Graph Model), and all serialization, rendering, or export mechanisms.
Violations: Defining Knowledge Object identity in terms of file paths, document identifiers, or format-specific structures. Requiring that knowledge be stored or transmitted in a particular document format as a condition of validity.
Related Principles: P-005, P-006
P-005 — Identity-over-Location Principle
Statement: The canonical identity of a Knowledge Object shall be independent of its physical or logical storage location. Identity shall be stable and portable across changes in repository structure, storage technology, or hosting environment.
Rationale: Storage locations, file paths, database keys, and repository hierarchies are implementation details. They change over time as systems are reorganized, migrated, or scaled. If identity is tied to location, then identity becomes fragile. Stable, location-independent identity enables reliable referencing, deduplication, provenance tracking, and long-term traceability — all essential for a system intended to operate over decades.
Implications: CORE-002 (EKIS) and CORE-003 (KOM) shall define identity mechanisms that do not depend on storage paths, URLs, or repository-internal identifiers. Identity shall be portable and resolvable across different storage realizations.
Applies To: CORE-002, CORE-003, and any mechanism that creates, references, or resolves Knowledge Objects.
Violations: Using file system paths, database primary keys, or repository-specific identifiers as the canonical identity of a Knowledge Object. Designing resolution mechanisms that break when storage is reorganized or migrated.
Related Principles: P-004, P-006
P-006 — Source-of-Truth Principle
Statement: The EGAL Enterprise Architecture repository remains the authoritative Source of Truth. Working Contexts, Knowledge Objects, and derived artifacts derive their authority from explicit traceability to this repository. No artifact within the KOS shall be treated as authoritative in its own right. Working Contexts are assembled, disposable views and shall not be treated as persistent sources of truth.
Rationale: The KOS does not replace or duplicate the existing EGAL Enterprise Architecture repository. It operates upon the knowledge contained within that repository. Preserving the repository as the single Source of Truth ensures organizational accountability, avoids divergence, and maintains the integrity of the architectural knowledge that has been accumulated over time. Working Contexts are assembled views for specific tasks; they are not new sources of truth and should not accumulate independent authority.
Implications: All Knowledge Objects shall maintain explicit, auditable links to their origins in the Source of Truth. Governance processes shall ensure that evolution of knowledge in the repository is reflected in the KOS layer. Context Assembly mechanisms shall treat Working Contexts as ephemeral outputs, not as persistent artifacts with independent authority.
Applies To: All CORE documents and any tooling that creates or manages Knowledge Objects or Working Contexts.
Violations: Treating a Working Context or a snapshot of the Knowledge Graph as an independent source of truth. Allowing Knowledge Objects to exist without traceable linkage to the Source of Truth. Designing governance processes that permit divergence between the repository and the KOS layer.
Related Principles: P-001, P-004, P-005
P-007 — Architectural Intent Preservation Principle
Statement: The KOS shall preserve architectural intent independently of representation, implementation, or technology evolution. Architectural decisions, rationale, constraints, and trade-offs shall remain attributable, queryable, and intact across changes in how knowledge is stored, rendered, or processed.
Rationale: Architectural intent represents organizational decisions that carry long-term consequences. If intent is lost or obscured when representation or technology changes, the KOS fails to serve its purpose as a durable knowledge system. Preservation of intent ensures that future humans and AI systems can understand not only what is known, but why it was decided and what constraints were considered.
Implications: Standards for Knowledge Objects and the Knowledge Graph shall provide mechanisms to capture and maintain architectural intent, rationale, and constraints. Context Assembly shall preserve intent and rationale as part of Working Contexts. Changes in representation or technology shall be evaluated for their impact on the visibility and integrity of architectural intent.
Applies To: CORE-003, CORE-004, CORE-005, and any mechanism that renders or transforms knowledge.
Violations: Allowing architectural rationale or constraints to be lost during serialization, rendering, or context assembly. Designing systems in which intent is only recoverable through human interpretation of documents rather than through structured, queryable mechanisms.
Related Principles: P-001, P-003, P-006, P-017
5. Knowledge Principles
P-008 — Canonical Knowledge Principle
Statement: Each distinct unit of knowledge within the KOS shall have exactly one canonical form as a Knowledge Object. Multiple representations or views may exist, but they shall be derived from and traceable to the canonical form. The canonical form shall be independent of any specific representation.
Rationale: Duplication of knowledge creates inconsistency, increases maintenance burden, and undermines traceability. A single canonical form provides a stable reference point. Derived representations can be generated as needed without creating divergent sources of truth. This principle reinforces representation independence and long-term evolvability.
Implications: CORE-003 shall define mechanisms for establishing and maintaining canonical forms. Processes for creating derived views shall preserve traceability to the canonical object. Governance shall prevent the proliferation of non-canonical, independent representations of the same knowledge.
Applies To: CORE-003, CORE-004, and all mechanisms that generate alternative representations or views of knowledge.
Violations: Maintaining multiple, non-derivable representations of the same knowledge as independent objects. Allowing derived views to diverge from or supersede the canonical form without governance.
Related Principles: P-004, P-005, P-009
P-009 — Semantic Clarity Principle
Statement: Each Knowledge Object shall have a single, unambiguous semantic meaning. Where meaning is context-dependent, the object shall carry explicit qualification or the Knowledge Graph shall provide mechanisms for disambiguation. Implicit or shifting meaning shall not be relied upon for reasoning or assembly.
Rationale: Ambiguity in meaning undermines deterministic reasoning, reliable context assembly, and shared understanding between humans and AI. A Knowledge Object whose meaning shifts depending on interpretation or context cannot serve as a stable building block for long-term collaboration. Semantic clarity is essential for both human governance and AI reasoning.
Implications: CORE-003 shall require explicit semantic definitions for Knowledge Objects. The Knowledge Graph shall provide mechanisms for disambiguation and contextual qualification where needed. Context Assembly shall not rely on implicit human interpretation to resolve meaning.
Applies To: CORE-003 and any mechanism that defines or interprets the meaning of Knowledge Objects.
Violations: Defining Knowledge Objects with meanings that are intentionally left open to multiple interpretations without explicit qualification. Relying on implicit context or human judgment to resolve meaning during context assembly or AI reasoning.
Related Principles: P-008, P-010
P-010 — Explicit Relationships Principle
Statement: Relationships between Knowledge Objects shall be explicit, typed, and governed. The authoritative relationships shall be those declared in the Knowledge Graph. Implicit or inferred relationships may be derived for specific purposes, but they shall be clearly distinguished from explicit, governed relationships.
Rationale: Explicit relationships enable deterministic traversal, provenance tracking, impact analysis, and governance. Implicit relationships — those that exist only in document structure, co-occurrence, or human interpretation — are invisible to systematic processing and cannot be reliably maintained over time. Explicitness is a prerequisite for long-term integrity and AI-native consumption.
Implications: CORE-004 shall define a controlled vocabulary of relationship types and governance rules for their creation and evolution. Mechanisms that infer additional relationships shall clearly distinguish inferred from explicit relationships. Governance shall ensure that explicit relationships are maintained as the authoritative layer.
Applies To: CORE-004 and any tooling that creates, traverses, or reasons over relationships in the Knowledge Graph.
Violations: Relying on document structure, co-occurrence, or other implicit signals as the primary means of establishing relationships. Allowing inferred relationships to be treated as authoritative without explicit declaration and governance.
Related Principles: P-009, P-011
P-011 — Separation of Knowledge and Representation Principle
Statement: The KOS shall maintain a clear separation between the knowledge layer (Knowledge Objects and the Knowledge Graph) and any representation or presentation layer. Changes in representation shall not affect the identity, semantics, or relationships of Knowledge Objects. Knowledge shall be defined and governed independently of how it is rendered or consumed.
Rationale: This principle operationalizes P-004 and provides operational guidance. It ensures that the knowledge layer remains stable even as rendering technologies, document formats, visualization tools, or AI consumption formats evolve. The separation is what enables representation independence to be realized in practice and protects long-term evolvability.
Implications: Standards and implementations shall treat rendering, serialization, and presentation as separate concerns from the definition and governance of Knowledge Objects. Changes to representation mechanisms shall be evaluated for their impact on the stability of the knowledge layer. No representation-specific concern shall influence the canonical definition of knowledge.
Applies To: All CORE documents and any tooling that renders, exports, or presents knowledge from the KOS.
Violations: Allowing representation-specific concerns (layout, formatting, pagination) to influence the definition of Knowledge Object identity or semantics. Treating a particular document format or rendering as the authoritative form of a Knowledge Object.
Related Principles: P-004, P-008
6. Human–AI Collaboration Principles
P-012 — Working Context as Collaboration Unit Principle
Statement: Working Context shall be the primary unit through which humans and AI systems collaborate within the KOS. All protocols, interfaces, and assembly mechanisms shall be designed around the production, delivery, and consumption of Working Contexts. Neither humans nor AI shall be required to work directly with raw documents or unassembled knowledge as their normal mode of interaction.
Rationale: This principle operationalizes P-003. It ensures that the architecture remains focused on the outcome that serves the Mission. By establishing Working Context as the collaboration unit for both humans and AI, the KOS avoids the trap of exposing raw knowledge stores or unassembled objects as the primary interface.
Implications: CORE-005 and CORE-006 shall define interfaces and protocols centered on Working Context requests and responses. Governance processes shall evaluate mechanisms based on their support for Working Context as the collaboration surface for both classes of consumer.
Applies To: CORE-005, CORE-006, and any tooling or interface that mediates collaboration between knowledge and consumers.
Violations: Exposing raw Knowledge Graph queries or unassembled object collections as the primary collaboration interface. Designing AI protocols that bypass context assembly in favor of direct access to knowledge stores. Treating human users differently from AI users with respect to the primacy of Working Context.
Related Principles: P-003, P-013
P-013 — Shared Understanding Principle
Statement: Working Contexts shall be assembled in a manner that supports shared understanding between human and AI participants. The same Working Context shall be interpretable by both classes of consumer, even if presented in different representations. Semantics, provenance, and assembly rationale shall be preserved across representations.
Rationale: Human–AI collaboration requires that both parties operate from a common base of knowledge. If a Working Context is meaningful only to AI or only to humans, it fails to serve the collaborative purpose. Shared understanding does not require identical presentation; it requires that the underlying knowledge and its assembly rationale be accessible and interpretable by both.
Implications: Context Assembly mechanisms shall preserve semantics and provenance in forms that support both human review and AI reasoning. Representations optimized for one class of consumer shall not sacrifice the ability of the other class to understand the assembled context and its rationale.
Applies To: CORE-005 and any mechanism that generates representations of Working Contexts.
Violations: Assembling contexts that are opaque to humans or that strip provenance and rationale in the name of AI efficiency. Generating human-readable views that do not faithfully reflect the knowledge used by AI agents.
Related Principles: P-012, P-014
P-014 — Deterministic Context Principle
Statement: Given the same inputs and the same state of the Knowledge Graph, Context Assembly shall produce equivalent Working Contexts. Assembly shall be reproducible and auditable. Non-deterministic behavior shall not be introduced into context assembly.
Rationale: Determinism is essential for trust, debugging, governance, and long-term reliability. If the same request can produce different contexts on different occasions without governed evolution of the underlying knowledge, then collaboration becomes unpredictable. AI systems in particular require deterministic behavior to reason reliably over time.
Implications: CORE-005 shall define Context Assembly rules that are deterministic given stable inputs. Governance processes shall ensure that changes to assembly behavior are versioned, auditable, and justified. Reproducibility shall be a design constraint, not an afterthought.
Applies To: CORE-005 and any implementation of context assembly.
Violations: Introducing non-deterministic behavior (randomness, implicit ordering, or unversioned rule changes) into context assembly. Allowing equivalent inputs to produce materially different Working Contexts without a governed change to the Knowledge Graph or assembly rules.
Related Principles: P-012, P-015
P-015 — Human Authority and AI Assistance Principle
Statement: Human stakeholders retain ultimate authority over governance, validation, and evolution of the KOS. AI systems may propose, reason, assist, and generate recommendations, but they shall never become the authoritative source of organizational knowledge. No automated process shall have authority to commit changes to Knowledge Objects, relationships, or governance structures without human authorization and audit trail.
Rationale: The KOS exists to augment human and AI capabilities, not to replace human accountability. Architectural knowledge represents organizational intent and carries governance obligations. AI systems can dramatically increase the speed and scope of reasoning, but final authority and responsibility must remain with humans who are accountable to the organization. AI shall never supplant the Source of Truth or the human governance layer.
Implications: All governance processes, review gates, and freeze mechanisms shall require human approval. AI assistance in proposal, analysis, or recommendation generation is encouraged and shall be supported by tooling. However, no automated process shall have authority to commit changes to the Knowledge Graph or governance structures. Audit trails shall clearly distinguish human decisions from AI-generated proposals.
Applies To: All governance processes, CORE-007, and any tooling that supports or automates governance decisions.
Violations: Implementing automated approval or freeze mechanisms that bypass human review. Allowing AI systems to modify Knowledge Objects or relationships without human authorization and audit trail. Treating AI-generated content as authoritative without human validation.
Related Principles: P-006, P-016, P-017
7. Governance Principles
P-016 — Canonical Identity Governance Principle
Statement: The creation, assignment, and management of canonical identities for Knowledge Objects shall be governed by controlled processes. Identity shall not be created or altered outside of governed mechanisms. Identity management shall be auditable and traceable.
Rationale: Canonical identity is the foundation of traceability, deduplication, and long-term stability. Uncontrolled creation or alteration of identities leads to fragmentation, ambiguity, and loss of provenance. Governance ensures that identity assignment follows defined rules and that changes are auditable.
Implications: CORE-002 and CORE-003 shall define identity creation and management processes. Tooling shall enforce governance rules. No ad-hoc or manual identity assignment shall be permitted outside governed channels. Identity changes shall be versioned and justified.
Applies To: CORE-002, CORE-003, and any tooling that creates or manages Knowledge Objects.
Violations: Creating Knowledge Objects with ad-hoc or duplicate identities. Altering canonical identity without following governed processes and creating an audit trail. Allowing identity to be managed outside controlled mechanisms.
Related Principles: P-005, P-017
P-017 — Traceability and Provenance Principle
Statement: Every Knowledge Object, relationship, and Working Context shall maintain explicit, auditable traceability to its origins in the Source of Truth and to the decisions that created or modified it. Provenance shall be preserved through context assembly and representation changes.
Rationale: Traceability is essential for governance, impact analysis, debugging, and long-term accountability. Without it, the KOS cannot support reliable evolution or demonstrate compliance with the Source-of-Truth Principle. Traceability enables humans and AI to understand not only what is known, but why and from where it is known.
Implications: CORE-003 and CORE-004 shall require provenance and traceability metadata. Context Assembly shall preserve traceability to source objects. Governance processes shall maintain records of decisions that affect the Knowledge Graph. Provenance shall survive representation changes and assembly operations.
Applies To: All CORE documents and any tooling that creates, modifies, or assembles knowledge.
Violations: Creating Knowledge Objects or relationships without provenance metadata. Assembling Working Contexts that lose traceability to the underlying Knowledge Objects and their origins. Allowing provenance to be stripped during rendering or serialization.
Related Principles: P-006, P-016
P-018 — Version Integrity and Governance Principle
Statement: Changes to Knowledge Objects, relationships, and governance rules shall be versioned. The history of changes shall be preserved and auditable. Versioning shall support both evolution and rollback where governed processes permit. Review and freeze processes shall govern all changes that affect frozen artifacts.
Rationale: Long-lived systems accumulate changes. Without versioning and governed change processes, it becomes impossible to understand the state of knowledge at a point in time, to audit decisions, or to recover from errors. Version integrity and review-before-freeze discipline support reproducibility of Working Contexts and accountability for governance decisions.
Implications: CORE-003, CORE-004, and governance processes shall define versioning mechanisms and policies. Version history shall be queryable and shall support impact analysis. Frozen artifacts shall not be modified in place; changes shall produce new versions through governed processes. Review-before-freeze shall be enforced for all CORE documents and significant governance changes.
Applies To: All mechanisms that modify the Knowledge Graph or governance structures, and all CORE documents.
Violations: Overwriting Knowledge Objects or relationships without creating a new version. Losing or discarding version history. Making changes that cannot be audited or attributed. Modifying frozen artifacts in place without following the evolution process. Freezing a document or change without Architecture Board review.
Related Principles: P-017, P-019
P-019 — Frozen as Authoritative Reference Principle
Statement: Once frozen, a CORE document or governance artifact shall serve as the authoritative reference. Changes shall be made only through governed evolution processes that produce new versions. Frozen artifacts shall not be modified in place. The frozen version shall remain the stable reference for compliance and traceability.
Rationale: The value of freezing is stability and predictability. If frozen artifacts can be changed informally, the commitment loses meaning. Governed evolution with new versions preserves history while allowing necessary improvement. This principle protects the integrity of the constitutional and standard layers over time.
Implications: Frozen documents shall be clearly marked and versioned. Any change shall result in a new version with clear traceability to the prior version and justification for the change. Tooling and processes shall enforce this discipline. Compliance shall be assessed against the frozen version unless a newer version has been explicitly adopted through governed processes.
Applies To: All frozen CORE documents and governance artifacts.
Violations: Editing a frozen document in place. Treating an unfrozen draft as equivalent to a frozen version. Making informal changes to frozen artifacts without following the evolution process. Allowing compliance to be assessed against non-frozen or superseded versions without justification.
Related Principles: P-018, P-020
8. Evolution Principles
P-020 — Technology Independence and Long-term Evolvability Principle
Statement: The principles, standards, and models of the KOS shall be independent of any specific technology, platform, or vendor. The KOS shall be designed to remain functional, coherent, and aligned with its Mission over decades. Evolution shall be supported through governed processes that preserve backward compatibility and traceability where possible. Technology choices shall be evaluated against their fidelity to the principles and standards, not the reverse.
Rationale: Technology changes. Platforms are deprecated. Vendors evolve or disappear. A system whose principles or standards are tied to a particular technology cannot survive these changes without fundamental redesign. Technology independence and long-term evolvability are mutually reinforcing: independence protects evolvability, and evolvability requirements reinforce the need for independence. Backward compatibility shall be a design consideration, not an afterthought.
Implications: CORE documents shall not embed assumptions about specific databases, graph engines, serialization formats, or AI model architectures. Implementation guidance may discuss technology choices, but the normative content shall remain technology-independent. Evolution decisions shall evaluate impact on existing consumers and traceability. Breaking changes shall be introduced only when necessary and shall be governed, versioned, and communicated with sufficient lead time.
Applies To: All CORE documents, governance processes that manage evolution, and any implementation guidance or tooling selection processes.
Violations: Defining standards or models in terms of specific technology features. Selecting or mandating a technology because it is familiar or currently popular rather than because it best serves the principles. Making changes that unnecessarily break existing implementations or traceability without deliberate, governed justification. Treating backward compatibility as secondary to short-term convenience.
Related Principles: P-001, P-021
P-021 — Progressive Refinement and Compatibility Principle
Statement: The KOS shall support progressive refinement: the ability to improve understanding, correct errors, and add detail over time without invalidating prior work or breaking existing traceability where compatibility can be maintained. Refinement shall be governed and versioned. Where refinement would break compatibility, the change shall be treated as a governed evolution requiring review and justification.
Rationale: Knowledge is not static. Understanding deepens, errors are discovered, and new relationships emerge. A system that cannot accommodate refinement without disruption will either stagnate or require costly rework. Progressive refinement enables the KOS to improve while protecting the stability that long-term collaboration requires. Compatibility shall be preserved where possible; where not possible, change shall be governed.
Implications: Knowledge Object and relationship models shall support versioning and refinement. Governance processes shall distinguish between refinement (compatible improvement) and substantive change (potential breaking). Context Assembly shall be robust to refinement of source objects. Breaking changes shall follow the evolution process defined under P-020.
Applies To: CORE-003, CORE-004, CORE-005, and governance processes.
Violations: Treating refinement as equivalent to breaking change without justification. Requiring consumers to update every time source knowledge is refined when compatibility could have been preserved. Discouraging or preventing the correction of errors because of compatibility concerns without governed evaluation. Introducing breaking changes under the guise of refinement without following the evolution process.
Related Principles: P-020
9. Principle Interaction
Principles do not operate in isolation. They interact, reinforce one another, and occasionally come into tension. This chapter provides guidance on how to navigate these interactions.
The Priority Hierarchy
When principles appear to conflict, the following priority order shall guide resolution:
Mission (P-001)
          ↓
Problem Understanding (P-002)
          ↓
Context as Collaboration Unit (P-003, P-012)
          ↓
Knowledge Integrity and Intent Preservation (P-004 to P-011, P-007)
          ↓
Governance and Evolution (P-016 to P-021)
The Mission takes precedence. If a proposed approach cannot be reconciled with the Mission, it shall not be pursued regardless of other considerations. Problem understanding precedes solution optimization. Context as the collaboration unit takes precedence over optimization of the knowledge layer in isolation. Knowledge integrity and architectural intent preservation take precedence over convenience in governance or evolution. Governance and evolution principles guide how change is managed within the constraints established by higher-priority principles.
Common Interactions and Resolutions
P-003 (Context-first) and P-004 (Knowledge-over-Representation) reinforce each other. Treating Working Context as the primary unit does not violate representation independence; it reinforces it by ensuring that assembly mechanisms, not representation formats, determine how knowledge is delivered to consumers.
P-005 (Identity-over-Location) and P-006 (Source-of-Truth) work together. Stable identity enables reliable traceability to the Source of Truth. Without stable identity, traceability becomes fragile. P-007 (Architectural Intent Preservation) extends this chain by ensuring that intent and rationale remain visible and intact across changes.
P-015 (Human Authority and AI Assistance) and P-014 (Deterministic Context) are complementary. Human authority is exercised through governed, deterministic processes. AI assistance enhances human decision-making without replacing it. AI shall never become the authoritative source of organizational knowledge.
P-020 (Technology Independence and Long-term Evolvability) and P-021 (Progressive Refinement and Compatibility) are mutually reinforcing. Technology independence is a means to achieve long-term evolvability. Progressive refinement supports evolvability while compatibility protects existing investments. Neither principle is served by premature commitment to a particular technology or by uncontrolled breaking changes.
When genuine tension exists — for example, between maximizing determinism (P-014) and supporting progressive refinement (P-021) — the resolution shall favor the higher-priority principle while seeking a design that minimizes violation of the lower-priority principle. Such tensions shall be documented and reviewed by the Architecture Board as part of standard development.
10. Relationship to CORE Standards
The principles defined in this document provide the normative foundation for all subsequent CORE standards. Each CORE document shall demonstrate compliance with the relevant principles. The following table summarizes the primary principles that each subsequent CORE document must address:
CORE Document
Primary Principles to Address
CORE-002 EKIS
P-001, P-005, P-006, P-016, P-017
CORE-003 KOM
P-003, P-004, P-005, P-007, P-008, P-009, P-010, P-011, P-017, P-018
CORE-004 KGM
P-004, P-010, P-011, P-017, P-018
CORE-005 CAS
P-003, P-007, P-012, P-013, P-014, P-017, P-021
CORE-006 ACP
P-012, P-013, P-014, P-015, P-017
CORE-007 Architecture
P-001, P-015, P-016, P-017, P-018, P-019, P-020, P-021

This mapping is not exhaustive. Every CORE document shall consider all principles for relevance. A principle that is not listed as primary for a given document may still impose constraints or provide guidance. Compliance with CORE-001 is a prerequisite for Architecture Board acceptance of any subsequent CORE document.
11. Summary
CORE-001 defines the immutable principles that every decision within the EGAL Knowledge Operating System must obey. These principles translate the Mission established in CORE-000 into enduring constraints that guide standards development, governance, and implementation across decades.
The twenty-one principles are organized into Foundational, Knowledge, Human–AI Collaboration, Governance, and Evolution groups. Each principle includes a normative statement, rationale, implications, applicability, violation guidance, and related principles. This structure ensures that the principles are actionable for review and traceable to the Mission.
The principles establish Working Context as the execution unit of Human–AI collaboration for both humans and AI, Knowledge as independent of representation, identity as stable and location-independent, the existing repository as the Source of Truth (with Working Contexts treated as disposable views), architectural intent as preserved across evolution, human authority as ultimate (with AI never becoming the authoritative source of organizational knowledge), and long-term evolvability as a design imperative supported by technology independence and governed change.
Subsequent CORE documents shall demonstrate compliance with these principles. The Architecture Board shall use this document as the primary reference for evaluating alignment, resolving conflicts, and ensuring that the KOS remains true to its Mission over time. Working Context as the execution unit and the preservation of architectural intent are the principles most directly traceable to the Mission and most likely to be cited throughout the CORE Series.