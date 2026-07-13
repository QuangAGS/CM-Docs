EGAL Knowledge Operating System (KOS)
CORE-003
Knowledge Object Model (KOM) Specification

Frozen Version 1.0
Document ID: CORE-003
Document Type: Foundational Model Specification (Level 3)
Status: Draft v1.0
Date: 2026-07-06
Depends on: CORE-000 (Frozen), CORE-001 (Frozen), CORE-002 (Frozen)
Audience: Knowledge Architects, Knowledge Engineers, AI Engineers

This document defines the standard model of the Knowledge Object (KO) — the fundamental unit of knowledge in the EGAL Knowledge Operating System. It establishes Knowledge Object as an architectural abstraction, independent of documents, representation formats, and technology implementations.

1. Introduction
CORE-003 defines the Knowledge Object Model (KOM) Specification for the EGAL Knowledge Operating System. This document establishes the standard conceptual model of the Knowledge Object (KO) — the fundamental, atomic unit of knowledge within the KOS.
The primary purpose of CORE-003 is to answer the question: What is a Knowledge Object under an architectural abstraction? This includes its definition, structure, semantics, lifecycle, classification, granularity principles, provenance, and traceability — all at the level of architectural abstraction, not data structure or implementation.
CORE-003 is the first document in the CORE Series that defines knowledge itself, rather than the context for its existence (CORE-000), the principles governing it (CORE-001), or how it is identified (CORE-002). It provides the conceptual foundation upon which CORE-004 (Knowledge Graph Model), CORE-005 (Context Assembly Specification), and CORE-006 (AI Collaboration Protocol) are built.
Relationship to CORE-000: CORE-003 supports the Mission by defining the stable, reusable, and traceable units of knowledge from which Working Contexts can be assembled. Without a clear model of Knowledge Object, the assembly of Working Contexts cannot be deterministic or auditable.
Relationship to CORE-001: CORE-003 realizes multiple principles from CORE-001, including P-003 (Context-first), P-004 (Knowledge-over-Representation), P-005 (Identity-over-Location), P-006 (Source-of-Truth), P-007 (Architectural Intent Preservation), P-008 (Canonical Knowledge), P-009 (Semantic Clarity), P-010 (Explicit Relationships), P-011 (Separation of Knowledge and Representation), P-017 (Traceability and Provenance), and P-024 (Progressive Refinement and Compatibility). Every normative decision in this document is traceable to one or more of these principles.
Relationship to CORE-002: CORE-003 depends on EKIS for Canonical Identity. Every Knowledge Object shall have exactly one Canonical Identity assigned and governed according to EKIS rules. EKIS provides the identification layer; KOM defines the knowledge unit that carries that identity.
CORE-003 does not define how Knowledge Objects are linked to one another (that is the role of CORE-004), nor how they are assembled into Working Contexts (that is the role of CORE-005). It defines only the Knowledge Object itself as an architectural abstraction.
2. Architectural Context
The transition from Document to Knowledge Asset to Knowledge Object represents the most significant architectural shift in the KOS. This shift is not merely a change in storage or format; it is a fundamental reorientation of how knowledge is treated, governed, and consumed.
In traditional document-centric systems, knowledge is embedded within documents. Documents serve as both the container and the primary unit of reference. Knowledge is entangled with presentation, narrative structure, historical context, and authorial intent. While effective for human communication, this entanglement creates several architectural problems:
• Knowledge is not independently addressable or reusable without reference to the containing document.
• Changes in document structure or format can affect the identity or meaning of embedded knowledge.
• Traceability to source is often implicit or lost when documents are transformed or summarized.
• AI systems must parse documents to extract knowledge, introducing ambiguity and non-determinism.
The Knowledge Asset layer (introduced conceptually in CORE-000 and formalized through EKIS in CORE-002) begins to separate knowledge from documents. A Knowledge Asset is an identifiable unit of organizational knowledge that has value, but it may still be represented in multiple forms and may not yet have the formal structure required for systematic assembly and reasoning.
The Knowledge Object layer completes this architectural shift. A Knowledge Object is a formalized, stable, atomic unit of knowledge with:
• Canonical Identity independent of location and representation (per EKIS and P-005).
• Semantic completeness and clarity (per P-009).
• Explicit provenance and traceability to the Source of Truth (per P-017 and P-006).
• Independence from any specific document, format, or technology (per P-004 and P-011).
• Designed for reuse across multiple Working Contexts (per P-010).
This shift enables the KOS to treat knowledge as a first-class architectural citizen — addressable, composable, governable, and evolvable — rather than as content embedded within documents. It is the foundation for deterministic context assembly, AI-native consumption, and long-term preservation of architectural intent.
Without this shift, subsequent layers (Knowledge Graph, Context Assembly, AI Collaboration) would be forced to operate on ambiguous, document-entangled fragments, undermining the Mission of assembling the correct Working Context for Human–AI collaboration.
3. Knowledge Object Concept
A Knowledge Object is the fundamental, atomic unit of knowledge within the EGAL Knowledge Operating System. It is an architectural abstraction representing a discrete, semantically complete, and independently meaningful unit of organizational knowledge that can be identified, governed, reasoned about, and reused across multiple contexts.
Definition
A Knowledge Object is a formalized representation of a Knowledge Asset that satisfies the following properties:
• Atomicity: It represents a single, indivisible unit of meaning at the level of architectural abstraction. It is not a fragment or excerpt; it is a complete semantic unit.
• Semantic Completeness: It carries sufficient semantics to be understood and used independently of the document or context from which it was derived. Its meaning does not require external narrative or implicit context to be interpreted.
• Canonical Identity: It has exactly one Canonical Identity assigned and governed according to EKIS (CORE-002). This identity is immutable, stable, and independent of location and representation.
• Provenance and Traceability: It maintains explicit, auditable links to its origin in the Source of Truth and to the decisions or processes that created or modified it.
• Independence: It is independent of any specific document, representation format, storage technology, or implementation. It exists as an architectural abstraction that can be realized in multiple forms without loss of identity or meaning.
• Reusability: It is designed to be reused across multiple Working Contexts and multiple consumers (human and AI) without modification to its core content or semantics.
• Governability: It has a defined lifecycle, status, and governance rules that apply uniformly regardless of how it is represented or stored.
Atomicity
Atomicity in KOM refers to semantic atomicity at the architectural level, not to physical storage or document structure. A Knowledge Object may be derived from a paragraph, a section, a diagram, a decision, or any other coherent unit of content — provided that the resulting object meets the criteria of semantic completeness and independence. The goal is to create units that can be composed, reasoned about, and governed without requiring the entire containing document.
Semantic Completeness
A Knowledge Object shall be semantically complete. This means that a consumer (human or AI) can understand its meaning, apply it in reasoning, and assess its relevance without needing to consult the original document or external context. Semantic completeness does not imply that the object contains all possible information about a topic; it implies that the object is a coherent, self-contained unit of meaning within its defined scope.
Reusability
Reusability is a core design goal. A Knowledge Object shall be created and governed with the expectation that it will be used in multiple Working Contexts over time. This requires that the object be free of context-specific assumptions, presentation decisions, or transient information that would limit its applicability. Reusability supports efficiency, consistency, and the accumulation of value in the knowledge base.
Independence
Independence from documents, representation, and technology is fundamental. A Knowledge Object shall not be defined in terms of its containing document, its rendering format, or its storage technology. This independence is what enables the KOS to evolve over decades while preserving the integrity and traceability of knowledge. It is a direct realization of P-004 (Knowledge-over-Representation) and P-011 (Separation of Knowledge and Representation).
4. Knowledge Object Model
The Knowledge Object Model defines the logical components that constitute a Knowledge Object. These components are conceptual and architectural; they are not a data schema, JSON structure, or database table definition. Implementations may realize these components in any technology that preserves the architectural semantics.
Canonical Identity
Every Knowledge Object shall have exactly one Canonical Identity, assigned and governed according to EKIS (CORE-002). Canonical Identity is the primary and authoritative identifier. It is immutable, stable, and independent of location and representation. All references to a Knowledge Object within the KOS shall use its Canonical Identity.
Semantic Content
Semantic Content is the core meaning of the Knowledge Object. It shall be expressed in a form that is representation-independent and technology-independent at the architectural level. Semantic Content shall be sufficient to satisfy the requirement of semantic completeness. The specific encoding or serialization of Semantic Content is an implementation concern and is outside the scope of this model.
Type
Every Knowledge Object shall have a Type that indicates its classification within the KOS. Type is governed and versioned. Type influences lifecycle rules, governance requirements, and applicability in context assembly. Classification and Type are defined in Chapter 5.
Provenance
Provenance captures the origin and history of the Knowledge Object. It shall include explicit links to the Source of Truth (per P-006 and P-017), the source document or fragment from which it was derived, the derivation process, and any subsequent modifications. Provenance enables traceability, audit, and accountability. Detailed requirements for Provenance are defined in Chapter 7.
Status
Every Knowledge Object shall have a Status indicating its position in the governed lifecycle. Status values and transitions shall be governed. Status affects visibility, applicability, and governance requirements. Lifecycle and Status are defined in Chapter 6.
Source References
Source References provide explicit links to the originating Source of Truth and any intermediate sources or derivations. They are a component of Provenance and are essential for traceability and audit. Source References shall be resolvable and auditable.
Constraints
Constraints are rules or conditions that apply to the Knowledge Object, such as applicability conditions, validity constraints, or usage restrictions. Constraints are part of the semantic definition and shall be preserved across representation changes. They support correct usage in context assembly and reasoning.
Tags (Conceptual)
Tags are conceptual labels that provide additional categorization or discovery context. Tags are not part of the core semantic definition; they are supplementary metadata for navigation and discovery. Governance of tag vocabularies is outside the scope of this model but shall be consistent with EKIS and KOM principles.
The model components above are logical and architectural. They define what a Knowledge Object is and what information it must carry, independent of how that information is stored, serialized, indexed, or rendered. Implementations shall preserve these components and their semantics; they may add technology-specific mechanisms as long as they do not alter the architectural model.
5. Knowledge Object Classification
Knowledge Objects are classified by Type to support governance, lifecycle management, discovery, and appropriate use in context assembly. Classification is at the conceptual level; it does not prescribe implementation structures.
The following Types are recognized. Each Type carries a distinct meaning and may have tailored governance or lifecycle rules:
• Concept: A fundamental idea, definition, or abstraction that serves as a building block for other knowledge. Concepts are typically stable and reusable across multiple contexts.
• Rule: A statement of what must or must not be done, or a condition that must hold. Rules are normative and often carry governance implications.
• Constraint: A limitation, boundary condition, or requirement that restricts or shapes decisions or designs. Constraints are often derived from rules or principles.
• Decision: A recorded architectural, design, or governance decision, including context, alternatives considered, rationale, and consequences. Decisions are typically immutable once frozen.
• Pattern: A documented, reusable solution to a recurring problem, including context, problem statement, solution, consequences, and known uses. Patterns are designed for reuse and adaptation.
• Process: A defined sequence of activities or steps to achieve a purpose. Processes may be normative or descriptive.
• Workflow: A governed sequence of activities involving multiple actors or systems, often with defined states, transitions, and responsibilities.
• API Contract: A formal specification of an interface, including operations, inputs, outputs, and behavioral expectations. API Contracts are typically stable and versioned.
• Schema: A formal definition of structure, semantics, or constraints (e.g., data schema, ontology fragment, metadata schema). Schemas provide the rules for interpreting other knowledge.
• Glossary: A collection of terms and definitions providing shared vocabulary. Glossary entries support semantic clarity across the KOS.
• Role: A defined set of responsibilities, permissions, or expected behaviors associated with a position or function.
• Requirement: A statement of what is needed or expected, often with traceability to stakeholders or sources. Requirements are typically traceable and versioned.
• Capability: A description of what a system, component, or organization can do, often expressed in terms of functions or outcomes.
• Principle: A normative statement of enduring guidance or constraint, typically derived from or aligned with CORE-001 principles.
• Standard Reference: A reference to an external or internal standard, specification, or authoritative source, including version and applicability context.
Each Type shall be assigned a distinct namespace or type identifier within EKIS for Canonical Identity purposes. Governance rules, lifecycle transitions, and applicability in context assembly may differ by Type. Detailed governance and lifecycle specifications for each Type are outside the scope of this model but shall be consistent with KOM principles.
This classification is intentionally high-level and conceptual. It provides a shared vocabulary for identifying the nature of Knowledge Objects without prescribing implementation structures. Future CORE documents or governed extensions may introduce additional Types, provided they are consistent with the architectural model defined here.
6. Knowledge Object Lifecycle
Every Knowledge Object shall progress through a governed lifecycle. The lifecycle ensures that Knowledge Objects are created, reviewed, approved, frozen, evolved, deprecated, and archived in a controlled, auditable manner consistent with CORE-001 principles (particularly P-018, P-019, P-024) and EKIS governance.
Standard Lifecycle States
• Extracted: The Knowledge Object has been extracted or derived from a Source of Truth. It has a provisional Canonical Identity. Full governance review has not yet occurred. Traceability to source is required.
• Reviewed: The Knowledge Object has undergone formal review for semantic completeness, correctness, compliance with principles, and traceability. Changes require justification and audit trail. It may be referenced by other objects in draft or review status.
• Approved: The Knowledge Object has passed review and is approved for use. It has a stable Canonical Identity. It may be referenced by other approved or frozen objects.
• Frozen: The Knowledge Object is frozen as an authoritative reference (per P-019). Its content and Canonical Identity are immutable. Changes require creation of a new version or new object through governed evolution. Frozen objects serve as stable references for context assembly and reasoning.
• Deprecated: The Knowledge Object is no longer recommended for new use. Its Canonical Identity remains stable. Existing references should migrate to successor objects. Deprecation does not delete or reassign identity. Deprecated objects remain resolvable for historical and audit purposes.
• Archived: The Knowledge Object is retained for historical, audit, or compliance purposes but is no longer active. Its Canonical Identity remains stable. Resolution may return the archived object or a pointer to its successor. Archival is a terminal state; further evolution is not expected.
Lifecycle transitions shall be governed. Each transition shall be recorded with timestamp, actor, justification, and before/after state. Governance rules may differ by Type (e.g., Decision objects may have stricter immutability requirements than Concept objects).
The lifecycle defined here is compatible with but not identical to the EKIS Asset Lifecycle. Knowledge Objects are a specific class of Knowledge Asset; their lifecycle may have additional states or stricter governance requirements. EKIS provides the identification and registry mechanisms; KOM defines the lifecycle semantics for Knowledge Objects.
7. Provenance & Traceability
Provenance and Traceability are essential for governance, accountability, audit, impact analysis, and long-term evolvability. Every Knowledge Object shall maintain explicit, auditable provenance linking it to its origin in the Source of Truth and to the decisions or processes that created or modified it. This is a direct realization of P-017 (Traceability and Provenance) and P-006 (Source-of-Truth).
Source Document
The Source Document is the document or artifact in the EGAL Enterprise Architecture repository from which the Knowledge Object was derived. It shall be identified by its Canonical Identity (per EKIS) or by an equivalent stable reference. Source Document provides the primary link to the Source of Truth.
Source Fragment
The Source Fragment identifies the specific portion of the Source Document (e.g., section, paragraph, diagram, table) from which the Knowledge Object was derived. Source Fragment enables fine-grained traceability and supports impact analysis when the source changes.
Derivation
Derivation captures the process or method by which the Knowledge Object was created from the Source Fragment. This may include extraction rules, summarization criteria, transformation logic, or human authoring decisions. Derivation shall be recorded at a level sufficient for audit and reproducibility.
Review History
Review History records the formal reviews the Knowledge Object has undergone, including reviewers, dates, findings, and decisions. Review History supports accountability and provides evidence of governance compliance.
Trace Chain
The Trace Chain is the complete, auditable chain from a Knowledge Object back to its ultimate Source of Truth, including all intermediate derivations, transformations, and governance decisions. The Trace Chain shall be preserved across representation changes, context assembly, and technology migrations. It enables verification that a Knowledge Object is authoritative and traceable.
Provenance shall be maintained as part of the Knowledge Object and shall be preserved when the object is referenced, assembled into Working Contexts, or rendered in any representation. Loss of provenance or traceability constitutes a violation of P-017 and shall be treated as a governance failure.
8. Granularity Principles
Granularity — the size and scope of a Knowledge Object — is a critical design decision that affects reusability, comprehensibility, governance burden, and effectiveness in context assembly. KOM establishes principles to guide granularity decisions, ensuring that Knowledge Objects are neither too large (losing reusability) nor too small (losing semantic completeness).
Principle of Semantic Atomicity
A Knowledge Object shall be semantically atomic: it shall represent a single, coherent unit of meaning that cannot be further subdivided without loss of semantic completeness. If subdividing an object would produce fragments that are not independently meaningful or usable, the original object is appropriately atomic. Semantic atomicity is judged at the architectural level, not at the level of sentences or paragraphs.
Principle of Reusability
A Knowledge Object shall be sized to maximize reusability across multiple Working Contexts and multiple consumers. Objects that are too large (e.g., an entire document section containing multiple distinct ideas) are difficult to reuse selectively. Objects that are too small (e.g., a single sentence without sufficient context) may lack the semantic completeness required for independent use. The optimal granularity balances these concerns.
Principle of Governance Efficiency
Granularity shall consider governance burden. Very fine-grained objects increase the number of objects to govern, review, and maintain. Very coarse-grained objects may require frequent partial updates, leading to versioning complexity. Granularity should enable efficient governance without sacrificing semantic integrity or reusability.
Principle of Context Assembly Effectiveness
Granularity shall support effective context assembly. Objects that are too large may include irrelevant content when assembled into a Working Context. Objects that are too small may require assembly of many objects to achieve semantic completeness, increasing complexity and reducing determinism. Granularity should enable precise, minimal, and coherent Working Contexts.
Principle of Traceability Preservation
Granularity shall preserve traceability. If an object is derived from a Source Fragment, its granularity should align with the fragment in a way that maintains clear provenance. Overly fine-grained objects may lose traceability to source; overly coarse-grained objects may obscure which parts of the source are relevant.
These principles are guidelines, not rigid rules. Specific granularity decisions shall be justified against these principles and documented as part of the object's provenance or governance record. Future CORE documents (particularly CORE-005) may provide additional guidance on granularity in the context of assembly.
9. Relationship to Future CORE
CORE-003 (KOM) provides the conceptual foundation for subsequent CORE documents that operate on Knowledge Objects. The following summarizes how future CORE documents shall build upon KOM:
CORE-004 (Knowledge Graph Model): Shall treat Knowledge Objects (as defined in KOM) as the nodes of the Knowledge Graph. Relationships shall connect Knowledge Objects identified by Canonical Identity. The graph model shall preserve KOM properties (atomicity, semantic completeness, provenance, independence) for each node. KOM does not define relationships; CORE-004 will define the relationship model and semantics.
CORE-005 (Context Assembly Specification): Shall assemble Working Contexts from Knowledge Objects defined by KOM. Assembly rules, selection criteria, ordering, and provenance preservation shall operate on KOM-compliant objects. Working Contexts may themselves be treated as a form of Knowledge Object (Context Package) for identity and governance purposes, but they are assembled views, not new atomic units.
CORE-006 (AI Collaboration Protocol): Shall enable AI systems to request, receive, and reason over Knowledge Objects and Working Contexts defined by KOM and assembled by CORE-005. Protocols shall reference objects by Canonical Identity and shall preserve KOM properties (semantics, provenance, independence) in AI-facing representations.
CORE-007 (Knowledge Operating System Architecture): Shall integrate KOM as the knowledge unit layer. Architectural views, interfaces, and governance processes shall be consistent with KOM definitions. Technology choices for storage, indexing, and reasoning shall be evaluated against their ability to preserve KOM properties.
Any future work that references or operates on knowledge units within the KOS shall do so in a manner consistent with the KOM defined in this document. Extensions or specializations are permitted only if they preserve the architectural properties established here.
10. Summary
CORE-003 defines the Knowledge Object Model (KOM) Specification — the standard conceptual model of the Knowledge Object, the fundamental unit of knowledge in the EGAL Knowledge Operating System.
A Knowledge Object is an architectural abstraction: a semantically complete, atomic, reusable, independent unit of knowledge with Canonical Identity (per EKIS), explicit provenance and traceability (per P-017), and independence from documents, representation, and technology (per P-004 and P-011). It is designed for governance, reasoning, and reuse across multiple Working Contexts.
KOM defines the logical components of a Knowledge Object (Canonical Identity, Semantic Content, Type, Provenance, Status, Source References, Constraints, Tags), a high-level classification of object types, a governed lifecycle, granularity principles, and provenance requirements — all at the level of architectural abstraction, not data structure or implementation.
KOM realizes multiple principles from CORE-001 and depends on EKIS (CORE-002) for identity. It provides the foundation for CORE-004 (Knowledge Graph Model), CORE-005 (Context Assembly Specification), and CORE-006 (AI Collaboration Protocol). Future work shall preserve KOM properties when referencing or operating on knowledge units within the KOS.
With CORE-003 frozen, the KOS has a stable, well-defined unit of knowledge. Subsequent documents can now address how these units are connected (CORE-004), assembled (CORE-005), and consumed by AI (CORE-006), all grounded in a common architectural model of what knowledge is.