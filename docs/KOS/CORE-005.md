EGAL Knowledge Operating System (KOS)
CORE-005
Context Assembly Specification (CAS)

Frozen Version 1.0
Document ID: CORE-005
Document Type: Architectural Document Specification (Level 5)
Status: Draft v1.0
Date: 2026-07-06
Depends on: CORE-000 (Frozen), CORE-001 (Frozen), CORE-002 (Frozen), CORE-003 (Frozen), CORE-004 (Frozen)
Audience: Knowledge Architects, Knowledge Engineers, AI Engineers, Architecture Review Board

This document defines Context Assembly as an architectural abstraction. It establishes how Working Contexts are assembled from Knowledge Objects and Knowledge Relationships to serve specific tasks while preserving meaning, provenance, integrity, and architectural intent. Context is assembled, not searched.

1. Introduction
CORE-005 defines the Context Assembly Specification (CAS) for the EGAL Knowledge Operating System. This document establishes Context Assembly as an architectural abstraction — a governed process of selecting, ordering, and composing Knowledge Objects and Knowledge Relationships into Working Contexts that serve specific tasks while preserving semantic meaning, provenance, integrity, and architectural intent.
The primary purpose of CORE-005 is to answer the question: How is a Working Context assembled from the Knowledge Graph to serve a specific task for a specific consumer (human or AI) at a specific time? This includes defining what a Working Context is, how it differs from documents and search results, what inputs and outputs are involved, what principles and constraints govern assembly, how boundaries and completeness are determined, and how assembly is governed.
CORE-005 is the first document in the CORE Series that models the behavior of knowledge — specifically, how knowledge is assembled into purposeful, task-oriented contexts. It builds directly on CORE-003 (Knowledge Object Model) and CORE-004 (Knowledge Graph Model), which define the nodes and relationships of the knowledge structure. CORE-005 defines how that structure is traversed, selected, and composed into Working Contexts.
CORE-005 does not define search engines, retrieval algorithms, vector search, embeddings, RAG, LLM prompts, AI agents, or graph traversal implementations. It defines the architectural process of context assembly. Implementations may realize this process using any technology that preserves the architectural semantics.
Relationship to CORE-000: CORE-005 directly supports the Mission by defining how Working Contexts — the execution units of Human–AI collaboration — are assembled from the knowledge system. The Mission is fulfilled when the correct Working Context is assembled for the task at hand.
Relationship to CORE-001: CORE-005 realizes multiple principles from CORE-001, including P-003 (Context-first), P-004 (Knowledge-over-Representation), P-005 (Identity-over-Location), P-006 (Source-of-Truth), P-007 (Architectural Intent Preservation), P-012 (Working Context as Collaboration Unit), P-013 (Shared Understanding), P-014 (Deterministic Context), P-015 (Human Authority and AI Assistance), P-017 (Traceability and Provenance), and P-020 (Technology Independence and Long-term Evolvability). Additionally, CORE-005 introduces new architectural principles specific to context assembly (detailed in Chapter 7).
Relationship to CORE-002: CORE-005 depends on EKIS for Canonical Identity. All Knowledge Objects referenced in a Working Context shall be identified by Canonical Identity. Assembly shall preserve Canonical Identity and shall not substitute or obscure it.
Relationship to CORE-003: CORE-005 depends on KOM for the definition of Knowledge Objects. Working Contexts are assembled from KOM-compliant Knowledge Objects. Assembly shall preserve KOM properties (atomicity, semantic completeness, independence, reusability) and shall not modify or redefine Knowledge Objects.
Relationship to CORE-004: CORE-005 depends on KGM for the definition of Knowledge Relationships and the Knowledge Graph. Working Contexts are assembled by traversing and selecting from the Knowledge Graph. Assembly shall preserve KGM properties (semantic preservation, provenance preservation, graph integrity) and shall not alter relationships or the graph structure.
CORE-005 is an Architectural Document Specification. It provides the assembly layer upon which CORE-006 (AI Collaboration Protocol) depends for enabling AI systems to request and receive Working Contexts, and upon which CORE-007 (Knowledge Operating System Architecture) depends for integrating assembly into the overall system architecture.
2. Architectural Context
The shift from Knowledge Graph to Working Context represents the transition from knowledge structure to knowledge behavior. The Knowledge Graph (CORE-004) defines how Knowledge Objects are related. Context Assembly (CORE-005) defines how those related objects are selected, composed, and delivered as purposeful contexts for specific tasks.
In traditional systems, context for a task is often obtained through search, retrieval, or manual curation. Search returns results ranked by relevance to a query. Retrieval returns documents or fragments matching criteria. Curation assembles content through human effort. These approaches have limitations:
• Search and retrieval operate on documents or indexed fragments, not on governed Knowledge Objects with explicit provenance and relationships.
• Results are often ranked lists or document sets, not coherent, task-oriented contexts.
• Provenance and traceability are often lost or implicit.
• Assembly is not deterministic; the same query may produce different results depending on ranking algorithms, indexing state, or curator judgment.
• Context is entangled with presentation, document structure, and retrieval artifacts.
Context Assembly inverts this. Working Context is assembled from Knowledge Objects and Relationships through a governed process that:
• Operates on Canonical Identity (per EKIS).
• Preserves semantic completeness and atomicity (per KOM).
• Preserves relationships and graph integrity (per KGM).
• Maintains explicit provenance and traceability throughout.
• Produces a coherent, task-oriented context with defined boundaries and completeness criteria.
• Is deterministic given stable inputs and governed assembly rules.
• Two Working Contexts are architecturally equivalent if they preserve the same semantic intent, contractual guarantees, and governed boundaries, regardless of differences in representation or internal ordering.
The position of CORE-005 in the architectural stack is pivotal:
CORE-000: Mission
          ↓
CORE-001: Principles
          ↓
CORE-002: Identity (EKIS)
          ↓
CORE-003: Knowledge Object (KOM)
          ↓
CORE-004: Knowledge Graph (KGM)
          ↓
CORE-005: Working Context (CAS)
          ↓
CORE-006: AI Collaboration Protocol (ACP)
CORE-005 is the first layer that models how knowledge behaves in service of a task. It completes the foundational chain from Mission to actionable context. With CORE-005 in place, CORE-006 can define protocols for humans and AI to request and receive Working Contexts without needing to redefine what context is or how it is assembled.
The distinction between Knowledge Context and Working Context is important. Knowledge Context refers to the broader semantic neighborhood of related Knowledge Objects. Working Context is the governed, assembled subset prepared for a specific task. This distinction prevents conflating 'all relevant knowledge' with 'the knowledge needed for this task.'
3. Working Context Concept
A Working Context is the execution unit of Human–AI collaboration within the EGAL Knowledge Operating System. It is an architectural abstraction representing a coherent, task-oriented, governed collection of Knowledge Objects and Relationships assembled to serve a specific purpose for a specific consumer at a specific time.
Definition
A Working Context is a governed assembly of Knowledge Objects and Knowledge Relationships that:
• Is assembled for a specific task or purpose.
• Has defined boundaries and completeness criteria.
• Preserves Canonical Identity, semantic meaning, and provenance of all constituent Knowledge Objects and Relationships.
• Is representation-independent and technology-independent at the architectural level.
• Is deterministic given stable inputs and governed assembly rules.
• Is auditable and traceable throughout its lifecycle.
Why Working Context is Different from a Document
A document is a representation of knowledge, typically authored for human communication, with structure, narrative, and presentation choices. A Working Context is an assembled collection of Knowledge Objects, independent of any single document or representation. It may draw from multiple documents, decisions, patterns, and other knowledge sources. Its structure is determined by assembly rules, not by document structure. Its purpose is task-oriented, not communication-oriented. A document may contribute to a Working Context, but a Working Context is not a document.
Why Working Context is Different from a Search Result
A search result is a ranked or filtered set of documents or fragments matching a query. A Working Context is an assembled, coherent collection of Knowledge Objects with defined boundaries, completeness criteria, and preserved provenance. Search operates on indexed content; assembly operates on governed Knowledge Objects and Relationships. Search results may be useful inputs to assembly, but they are not Working Contexts. Assembly produces a purposeful context, not a list of results.
Why Working Context is Different from a Prompt
A prompt is an input to an AI model, typically text that instructs or provides context for generation. A Working Context is the architectural output of a governed assembly process, independent of any specific AI model or prompt format. A Working Context may be rendered as a prompt (or as part of a prompt), but it is not a prompt. The assembly process produces a context with architectural guarantees (identity preservation, provenance continuity, semantic integrity); rendering that context as a prompt is an implementation concern.
Knowledge Context vs Working Context
Knowledge Context refers to the broader semantic neighborhood of Knowledge Objects related to a topic, task, or query. It is the set of potentially relevant knowledge. Working Context is the governed, assembled subset of that neighborhood prepared for a specific task. Working Context is purpose-driven, bounded, and complete for its purpose. Knowledge Context is broader and may contain more than is needed for a specific task. The distinction ensures that assembly produces what is sufficient, not everything that is related.
4. Context Assembly Model
Context Assembly is the governed architectural process of selecting, ordering, and composing Knowledge Objects and Knowledge Relationships from the Knowledge Graph into a Working Context that serves a specific task while preserving identity, semantics, provenance, and integrity.
Assembly is a process, not an algorithm. It is defined at the architectural level. Implementations may realize assembly using any technology (graph traversal, rule engines, AI-assisted selection, or future methods) as long as the architectural semantics and guarantees are preserved.
Assembly Inputs
Context Assembly requires the following categories of inputs at the architectural level:
• Knowledge Objects: The candidate Knowledge Objects from which the Working Context will be assembled, identified by Canonical Identity.
• Knowledge Relationships: The relationships connecting candidate Knowledge Objects, providing structure and semantics for traversal and selection.
• Mission: The overarching Mission of the KOS (per CORE-000), providing the ultimate reference for purpose alignment.
• Task: The specific task or purpose for which the Working Context is being assembled. Task definition shall include objectives, constraints, and success criteria at a level sufficient for assembly decisions.
• Constraints: Architectural, governance, or task-specific constraints that limit or shape assembly (e.g., scope limits, governance status requirements, temporal constraints).
• Policies: Governed policies that apply to assembly (e.g., authority requirements, provenance requirements, confidentiality constraints).
• Authority: The authorized consumer (human or AI) and the authority under which assembly is performed. Authority affects governance requirements and access to governed content.
• Context Requirements: Specific requirements for the Working Context, such as completeness criteria, boundary definitions, or representation preferences (at the architectural level).
Assembly Outputs
Context Assembly produces the following outputs at the architectural level:
• Working Context: The assembled collection of Knowledge Objects and Relationships, with defined boundaries and completeness.
• Context Metadata: Metadata describing the Working Context, including task, consumer, assembly timestamp, version, and governance status.
• Assembly Provenance: The complete, auditable record of how the Working Context was assembled, including inputs, decisions, and transformations.
• Context Boundary: The defined semantic boundary of the Working Context, specifying what is included and what is excluded.
• Context Contract (optional but recommended): An architectural commitment specifying what the Working Context guarantees (identity preservation, provenance continuity, semantic integrity, sufficiency for the defined task).
• Context Version Compatibility: A Working Context shall explicitly declare the versions of the Knowledge Objects, Relationships, and governing CORE specifications upon which it depends.

Assembly Process
Context Assembly is a governed process with the following characteristics:
• Purpose-driven: Assembly is always for a specific task or purpose. There is no 'general context.'
• Minimal: Assembly includes only what is necessary and sufficient for the task. Redundant or extraneous Knowledge Objects are excluded.
• Deterministic: Given the same inputs and the same governed assembly rules, assembly produces equivalent Working Contexts.
• Traceable: The entire assembly process is auditable, with provenance linking the Working Context back to source Knowledge Objects and assembly decisions.
• Integrity-preserving: Assembly preserves Canonical Identity, semantic meaning, relationships, and provenance of all constituent elements.
• Bounded: Assembly produces a Working Context with defined boundaries. The context is complete for its purpose, not exhaustive of all related knowledge.
Context Assembly does not create new knowledge. It selects, orders, and composes existing Knowledge Objects and Relationships. It does not modify Knowledge Objects or Relationships. It does not alter Canonical Identity or provenance.
5. Assembly Inputs
This chapter elaborates the architectural categories of inputs to Context Assembly. The specific content and format of inputs are implementation concerns; the architectural requirement is that assembly decisions be based on governed, traceable inputs of the following types.
Knowledge Objects and Relationships
The primary inputs are Knowledge Objects and Knowledge Relationships from the Knowledge Graph. These shall be identified by Canonical Identity. Assembly shall operate on KOM-compliant objects and KGM-compliant relationships. The graph provides the structural and semantic substrate for assembly.
Mission and Task
The Mission (CORE-000) provides the ultimate reference for purpose alignment. The specific Task provides the immediate purpose. Task definition shall be sufficient to guide assembly decisions, including objectives, constraints, and success criteria. Task may be expressed in human-readable or machine-interpretable form; the architectural requirement is clarity of purpose, not specific format.
Constraints and Policies
Constraints limit or shape assembly. They may be architectural (e.g., governance status requirements), task-specific (e.g., scope limits), or consumer-specific (e.g., authority level). Policies are governed rules that apply to assembly (e.g., provenance requirements, confidentiality constraints). Constraints and policies shall be explicit and governed.
Authority
Authority identifies the consumer (human or AI) and the authority under which assembly is performed. Authority affects governance requirements, access to governed content, and accountability. Assembly shall record authority as part of provenance.
Context Requirements
Context Requirements specify expectations for the Working Context, such as completeness criteria, boundary definitions, or representation preferences (at the architectural level). Requirements guide assembly decisions and provide criteria for completeness assessment.
Inputs shall be governed and traceable. Assembly decisions based on inputs shall be recorded in Assembly Provenance. Changes to inputs during assembly (e.g., refinement of task definition) shall be versioned and auditable.
6. Assembly Outputs
This chapter elaborates the architectural outputs of Context Assembly. Outputs shall be governed and traceable. They shall preserve the identity, semantics, and provenance of constituent Knowledge Objects and Relationships.
Working Context
The primary output is the Working Context — the assembled collection of Knowledge Objects and Relationships with defined boundaries and completeness. The Working Context is the execution unit delivered to the consumer (human or AI) for the defined task.
Context Metadata
Context Metadata describes the Working Context, including:
• Task and purpose
• Consumer and authority
• Assembly timestamp and version
• Governance status
• Boundary definition
• Completeness assessment
Metadata shall be governed and traceable. It shall not alter the identity or semantics of the Working Context content.
Assembly Provenance
Assembly Provenance is the complete, auditable record of how the Working Context was assembled. It shall include:
• Inputs used (Knowledge Objects, Relationships, Task, Constraints, Policies, Authority)
• Assembly decisions and rationale
• Transformations or ordering applied
• Boundary and completeness determinations
• Governance actions (review, approval, freeze)
Provenance shall be preserved throughout the lifecycle of the Working Context and shall be available for audit and impact analysis.
Context Boundary
Context Boundary defines the semantic scope of the Working Context — what is included and what is excluded. Boundary definition is essential for completeness assessment and for preventing scope creep. Boundary shall be explicit, governed, and traceable.
Context Contract
Context Contract is an architectural commitment specifying what the Working Context guarantees upon delivery to the consumer. A Context Contract shall include at minimum:
• Sufficiency for the defined task
• Preservation of Canonical Identity for all Knowledge Objects
• Preservation of full provenance chain
• No alteration of meaning for any Knowledge Object or Relationship
• Explicit definition of Context Boundary and assumptions in force
Context Contract provides a clear interface between the assembly process and the consumer. It is the architectural commitment that enables trust in Working Contexts delivered to humans or AI. Context Contract is particularly important for CORE-006 (AI Collaboration Protocol), where AI systems require clear guarantees about the contexts they receive.
7. Assembly Principles
Context Assembly is governed by architectural principles that ensure alignment with the Mission and with CORE-001 principles. These principles guide assembly decisions and provide criteria for evaluating assembly outcomes.
Context Sufficiency
A Working Context shall be sufficient for the defined task. Sufficiency means that the context contains what is necessary and adequate for the consumer to perform the task effectively. Sufficiency does not require completeness of all related knowledge. A context is sufficient when it meets the task's objectives and constraints; additional content that does not contribute to task performance is extraneous.
Minimal Assembly
Assembly shall be minimal. Only Knowledge Objects and Relationships necessary and sufficient for the task shall be included. Redundant, tangential, or low-relevance content shall be excluded. Minimal assembly reduces cognitive load for humans, token consumption for AI, and governance burden for the system. It supports clarity and focus.
Semantic Closure
A Working Context shall exhibit semantic closure within its defined boundary. All Knowledge Objects within the context shall form a coherent, interpretable set. The context shall not require external Knowledge Objects (outside the boundary) to be understood or used for the defined task. Semantic closure ensures that the context is self-contained for its purpose.
Purpose-driven Assembly
Assembly shall always be purpose-driven. There is no 'general context' or 'all relevant context.' Every Working Context is assembled for a specific task, with specific objectives, constraints, and success criteria. Purpose provides the criterion for relevance, sufficiency, and boundary definition.
Provenance Continuity
Assembly shall preserve provenance continuity. The full provenance chain of every Knowledge Object and Relationship included in the Working Context shall be maintained and extended through the assembly process. Provenance shall be traceable from the Working Context back to the Source of Truth without gaps or breaks.
Assembly Neutrality
Assembly shall be neutral with respect to implementation. The architectural outcome (the Working Context and its guarantees) shall not depend on the specific algorithm, technology, or traversal strategy used to perform assembly. Different implementations may produce equivalent Working Contexts given the same inputs and governed rules. Implementation details are not part of the architectural definition.
These principles are normative. They shall guide the design of assembly processes, the evaluation of assembly outcomes, and the governance of Working Contexts. Violations of these principles shall be treated as governance failures.
8. Assembly Constraints
Context Assembly operates under architectural constraints that protect the integrity of the knowledge system. These constraints are derived from CORE-001 principles and from the models defined in CORE-002, CORE-003, and CORE-004.
Identity Preservation
Assembly shall not alter, substitute for, or obscure the Canonical Identity of any Knowledge Object. All references within the Working Context shall use Canonical Identity. Assembly shall not create new identities or reassign existing identities.
Meaning Preservation
Assembly shall not alter or redefine the semantic meaning of any Knowledge Object or Relationship. Meaning is carried by the objects and relationships; assembly composes, it does not transform. Semantic integrity shall be preserved.
Provenance Preservation
Assembly shall not break or obscure the provenance chain of any Knowledge Object or Relationship. Provenance shall be preserved and extended through assembly. The Working Context shall carry complete, auditable provenance linking it to source elements and assembly decisions.
No New Knowledge Creation
Assembly shall not create new knowledge. It selects, orders, and composes existing Knowledge Objects and Relationships. It does not synthesize, infer, or generate new content. Any inference or synthesis required for the task is the responsibility of the consumer (human or AI), not of the assembly process.
No Modification of Knowledge Objects or Relationships
Assembly shall not modify Knowledge Objects or Relationships. The objects and relationships included in a Working Context shall be identical to their source definitions (subject to governed versioning). Assembly composes; it does not edit.
Representation Independence
Assembly shall be representation-independent. The Working Context shall be defined independently of how it will be rendered, serialized, or presented. Rendering or serialization is a subsequent step, not part of assembly.
Technology Independence
Assembly shall be technology-independent. The architectural definition of the Working Context and the assembly process shall not depend on specific databases, graph engines, search technologies, or AI implementations. Technology choices are implementation concerns.
These constraints are non-negotiable. They protect the architectural integrity of the KOS and ensure that Working Contexts delivered to consumers are trustworthy, traceable, and aligned with the Mission.
9. Assembly Governance
Context Assembly is a governed process. Working Contexts are not ad-hoc collections; they are governed artifacts with lifecycle, status, and accountability. Governance ensures that assembly is consistent, auditable, and aligned with architectural principles.
Assembly Lifecycle
A Working Context may progress through lifecycle states such as:
• Draft: The Working Context is under assembly or refinement. It may be used for review or testing but is not yet authoritative.
• Reviewed: The Working Context has undergone formal review for compliance with assembly principles, constraints, and governance requirements.
• Approved: The Working Context has passed review and is approved for delivery to the consumer.
• Frozen: The Working Context is frozen as an authoritative reference. Its content, boundary, and contract are immutable. Changes require new version or new assembly through governed processes.
• Deprecated: The Working Context is no longer recommended for use. Existing references should migrate to successor contexts.
• Archived: The Working Context is retained for historical or audit purposes.
Lifecycle transitions shall be governed. Each transition shall be recorded with timestamp, actor, justification, and before/after state.
Assembly Governance Processes
Governance of Context Assembly encompasses:
• Input Validation: Ensuring that inputs (Knowledge Objects, Relationships, Task, Constraints, Policies, Authority) are governed, traceable, and appropriate for the assembly purpose.
• Assembly Review: Formal review of the assembled Working Context for compliance with principles, constraints, and requirements.
• Approval and Authorization: Authorization for the Working Context to be delivered to the consumer, including authority verification.
• Freezing: Designation of a Working Context as an authoritative, immutable reference (per P-019).
• Deprecation and Migration: Governed processes for retiring Working Contexts and migrating references to successor contexts.
• Audit: Logging of all assembly operations with sufficient detail for accountability, impact analysis, and compliance verification.
Assembly Governance is essential for maintaining trust in Working Contexts delivered to humans and AI. It ensures that contexts are not only relevant but also governed, traceable, and aligned with architectural commitments.
10. Relationship to Future CORE
CORE-005 (CAS) provides the assembly foundation for subsequent CORE documents. The following summarizes how future CORE documents shall build upon CAS:
CORE-006 (AI Collaboration Protocol): Shall define protocols for humans and AI to request, receive, and interact with Working Contexts assembled by CAS. Protocols shall support Context Contract as the interface for guarantees. AI systems shall receive Working Contexts with architectural commitments (identity preservation, provenance continuity, semantic integrity, sufficiency for task). CAS provides the assembly; ACP provides the collaboration interface.
CORE-007 (Knowledge Operating System Architecture): Shall integrate CAS as the assembly layer. Architectural views, interfaces, and governance processes shall be consistent with CAS definitions. Technology choices for assembly implementation shall be evaluated against their ability to preserve CAS architectural semantics and guarantees.
Any future work that references or operates on Working Contexts within the KOS shall do so in a manner consistent with the CAS defined in this document. Extensions or specializations are permitted only if they preserve the architectural properties established here.
11. Summary
CORE-005 defines the Context Assembly Specification (CAS) — the architectural specification for assembling Working Contexts from Knowledge Objects and Knowledge Relationships to serve specific tasks while preserving meaning, provenance, integrity, and architectural intent.
A Working Context is an architectural abstraction: a governed, task-oriented, bounded collection of Knowledge Objects and Relationships that is assembled (not searched), sufficient (not exhaustive), deterministic (given stable inputs and governed rules), and traceable throughout. It is the execution unit of Human–AI collaboration.
Context Assembly is a governed architectural process with defined inputs (Knowledge Objects, Relationships, Mission, Task, Constraints, Policies, Authority, Context Requirements), outputs (Working Context, Context Metadata, Assembly Provenance, Context Boundary, Context Contract), principles (Context Sufficiency, Minimal Assembly, Semantic Closure, Purpose-driven Assembly, Provenance Continuity, Assembly Neutrality), and constraints (identity preservation, meaning preservation, provenance preservation, no new knowledge creation, no modification of objects or relationships, representation independence, technology independence).
CAS realizes multiple principles from CORE-001 and depends on EKIS (CORE-002), KOM (CORE-003), and KGM (CORE-004). It introduces new architectural principles specific to context assembly and provides the foundation for CORE-006 (AI Collaboration Protocol) and CORE-007 (Knowledge Operating System Architecture).
With CORE-005 frozen, the KOS has a complete chain from Mission to actionable, governed Working Context. CORE-006 can now define protocols for humans and AI to request and receive contexts with clear architectural guarantees, completing the shift to a Knowledge Operating System capable of delivering the correct context for the correct task to the correct consumer in a consistent, verifiable, and evolvable manner.