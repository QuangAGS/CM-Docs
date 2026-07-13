EGAL Knowledge Operating System (KOS)
CORE-004
Knowledge Graph Model (KGM) Specification

Frozen Version 1.0
Document ID: CORE-004
Document Type: Foundational Model Specification (Level 4)
Status: Draft v1.0
Date: 2026-07-06
Depends on: CORE-000 (Frozen), CORE-001 (Frozen), CORE-002 (Frozen), CORE-003 (Frozen)
Audience: Knowledge Architects, Knowledge Engineers, AI Engineers, Architecture Review Board

This document defines the Knowledge Graph Model (KGM) as an architectural abstraction. It establishes how Knowledge Objects are related to form a coherent, traversable, and governable knowledge structure that preserves meaning, provenance, and architectural intent for both human and AI consumption.

1. Introduction
CORE-004 defines the Knowledge Graph Model (KGM) Specification for the EGAL Knowledge Operating System. This document establishes the standard conceptual model of the Knowledge Graph as an architectural abstraction — a structure of relationships among Knowledge Objects that enables coherent reasoning, context assembly, and governance while preserving semantic meaning, provenance, and architectural intent.
The primary purpose of CORE-004 is to answer the question: How does knowledge relate to knowledge? This includes defining what a Knowledge Graph is at the architectural level, what kinds of relationships may exist between Knowledge Objects, what properties every relationship must possess, how semantic meaning and provenance are preserved through relationships and traversal, and what constitutes graph integrity.
CORE-004 is the first document in the CORE Series that models relationships rather than entities. It builds directly on CORE-003 (Knowledge Object Model), which defines the nodes of the graph. CORE-004 defines the edges — the semantic, governed, and traceable connections that transform a collection of Knowledge Objects into a Knowledge Graph capable of supporting Human–AI collaboration.
CORE-004 does not define graph databases, RDF, OWL, Property Graph implementations, query languages, or storage mechanisms. It defines the architectural model of knowledge relationships. Implementations may realize this model in any technology (RDF, Property Graph, Hypergraph, Relational Mapping, or future technologies) as long as the architectural semantics are preserved.
Relationship to CORE-000: CORE-004 supports the Mission by enabling the assembly of Working Contexts from Knowledge Objects that are not only identifiable and semantically complete, but also coherently related. The Knowledge Graph provides the structural foundation for deterministic, provenance-preserving context assembly.
Relationship to CORE-001: CORE-004 realizes multiple principles from CORE-001, including P-003 (Context-first), P-004 (Knowledge-over-Representation), P-005 (Identity-over-Location), P-006 (Source-of-Truth), P-007 (Architectural Intent Preservation), P-009 (Semantic Clarity), P-010 (Explicit Relationships), P-011 (Separation of Knowledge and Representation), P-017 (Traceability and Provenance), P-020 (Technology Independence and Long-term Evolvability), and P-024 (Progressive Refinement and Compatibility). Additionally, CORE-004 introduces new architectural principles specific to relationships and graphs (detailed in Chapter 3).
Relationship to CORE-002: CORE-004 depends on EKIS for Canonical Identity. All nodes (Knowledge Objects) and all relationships shall be identified and governed using Canonical Identity. Relationships shall not alter or substitute for Canonical Identity.
Relationship to CORE-003: CORE-004 depends on KOM for the definition of Knowledge Objects. Knowledge Objects are the nodes of the Knowledge Graph. CORE-004 does not modify, extend, or redefine Knowledge Objects; it defines how they are related while preserving their identity, semantics, and provenance as defined in KOM.
CORE-004 is a Foundational Model Specification. It provides the relationship layer upon which CORE-005 (Context Assembly Specification) depends for assembling Working Contexts from coherently related Knowledge Objects, and upon which CORE-006 (AI Collaboration Protocol) depends for enabling AI systems to reason over knowledge structures.
2. Architectural Context
The Knowledge Graph is the structural layer that transforms a collection of independent Knowledge Objects into a coherent, navigable, and governable knowledge system. Without relationships, Knowledge Objects remain isolated units. With relationships, they form a graph in which meaning emerges from both the nodes and the connections between them.
In traditional document-centric or knowledge management systems, relationships between knowledge elements are often implicit — embedded in document structure, hyperlinks, co-occurrence, or human interpretation. Implicit relationships are invisible to systematic processing, difficult to govern, and fragile across changes in representation or technology. They cannot support deterministic context assembly or reliable AI reasoning at scale.
The Knowledge Graph Model inverts this. Relationships are explicit, typed, governed, and traceable. They are first-class architectural elements, not derived artifacts. This explicitness enables:
• Deterministic traversal: The same starting point and traversal rules produce equivalent results.
• Semantic preservation: Meaning is carried by both nodes and relationships, and is preserved across traversal.
• Provenance preservation: The trace chain from any node or relationship back to the Source of Truth remains intact.
• Governance: Relationships have lifecycle, status, and governance rules, just as Knowledge Objects do.
• Context emergence: Working Contexts can emerge from graph traversal rather than from document navigation or manual curation.
The position of CORE-004 in the architectural stack is critical:
CORE-000: Mission (Why KOS exists)
          ↓
CORE-001: Principles (What must never be violated)
          ↓
CORE-002: Identity (How knowledge is identified — EKIS)
          ↓
CORE-003: Knowledge Object (What knowledge is — KOM)
          ↓
CORE-004: Knowledge Relationships (How knowledge relates — KGM)
          ↓
CORE-005: Working Context (How knowledge is assembled for use — CAS)
CORE-004 is the first layer that models the connections between knowledge units. It completes the foundational triad of Identity (CORE-002), Object (CORE-003), and Relationship (CORE-004). With these three layers in place, CORE-005 can focus on the assembly problem — selecting, ordering, and composing related Knowledge Objects into Working Contexts — without needing to redefine what knowledge is or how it is connected.
CORE-004 also introduces the concept of Knowledge Neighborhood: a Knowledge Object does not exist in isolation; it exists within a semantic neighborhood of related objects. This concept is foundational for Context Assembly (CORE-005), as Working Contexts are assembled by traversing and selecting from neighborhoods rather than by searching documents or raw knowledge stores.
3. Knowledge Graph Concept
A Knowledge Graph is an architectural abstraction representing a coherent, traversable, and governable structure of relationships among Knowledge Objects. It is not a database, not a data structure, and not a visualization. It is a model of how knowledge relates to knowledge, designed to support deterministic reasoning, context assembly, and long-term governance for both human and AI consumers.
Definition
A Knowledge Graph is a directed, typed, governed graph in which:
• Nodes are Knowledge Objects as defined by KOM (CORE-003), each with exactly one Canonical Identity per EKIS (CORE-002).
• Edges are explicit, typed, governed relationships between Knowledge Objects, each with defined semantics, properties, and traceability.
• The graph as a whole preserves semantic meaning, provenance, and architectural intent across nodes and relationships.
• Traversal of the graph produces results that are deterministic given stable inputs and governed traversal rules.
• The graph supports the emergence of Working Contexts through governed selection and composition of related Knowledge Objects.
Architectural Role of the Knowledge Graph
The Knowledge Graph serves several architectural roles within the KOS:
• Structural coherence: It transforms a collection of independent Knowledge Objects into a connected system in which meaning emerges from both nodes and relationships.
• Semantic navigation: It enables traversal based on semantic relationships rather than document structure or physical location.
• Provenance preservation: It maintains the trace chain from any node or relationship back to the Source of Truth, even across multiple hops.
• Governance surface: It provides a governed structure for managing relationships, their lifecycle, and their integrity.
• Context foundation: It provides the structural foundation from which Working Contexts can be assembled through governed traversal and selection (CORE-005).
• AI reasoning substrate: It provides a coherent, traversable, and semantically rich structure over which AI systems can reason without requiring document parsing or implicit context reconstruction.
The Knowledge Graph is representation-independent and technology-independent. It can be realized in multiple forms (RDF, Property Graph, Hypergraph, Relational Mapping, or future technologies) without altering its architectural semantics. The model defined in this document is the normative reference; implementations shall preserve its semantics.
Knowledge Neighborhood
A Knowledge Object does not exist in isolation. It exists within a Knowledge Neighborhood — the set of Knowledge Objects directly or indirectly related to it through governed relationships. The neighborhood provides context, enables discovery, and supports the emergence of Working Contexts that are coherent and relevant to a given task or query.
The concept of Knowledge Neighborhood is foundational for CORE-005 (Context Assembly). Working Contexts are not assembled by searching documents or raw knowledge stores; they are assembled by traversing and selecting from the neighborhoods of relevant Knowledge Objects. This shifts the assembly problem from document navigation to graph traversal, enabling determinism, provenance preservation, and AI-native operation.
4. Relationship Model
Relationships are first-class architectural elements in the Knowledge Graph. They are not derived from document structure, co-occurrence, or implicit interpretation. They are explicit, typed, governed, and traceable connections between Knowledge Objects.
Definition of Relationship
A Relationship is an explicit, directed, typed, governed connection between two Knowledge Objects (or between a Knowledge Object and another entity governed by the KOS) that carries semantic meaning, preserves provenance, and is subject to lifecycle and governance rules.
Relationships are not edges in a graph database sense. They are architectural abstractions with defined semantics, properties, and governance. The distinction is critical: a graph database edge is an implementation artifact; a KGM Relationship is an architectural construct that may be realized as one or more edges in a specific implementation, but whose semantics are defined independently of any implementation.
Relationship Invariants
Every Relationship shall satisfy the following invariants:
• Explicitness: The relationship shall be explicitly declared and governed. Implicit or inferred relationships may exist for specific purposes, but they shall be clearly distinguished from governed, authoritative relationships.
• Directionality: Relationships are directed. The direction carries semantic meaning (e.g., 'Depends On' is not the same as 'Is Depended On'). Bidirectional semantics shall be modeled as two directed relationships or as a single relationship with explicit symmetry declaration.
• Typed Semantics: Every relationship shall have a defined Type that carries specific meaning. Relationship Types are governed and versioned.
• Identity Preservation: A relationship shall not alter the Canonical Identity of the Knowledge Objects it connects. Identity is governed by EKIS; relationships operate on identities, they do not redefine them.
• Meaning Preservation: A relationship shall not redefine or alter the semantic meaning of the Knowledge Objects it connects. Meaning is carried by the objects (per KOM) and by the relationship type; the existence of a relationship does not change object semantics.
• Provenance Preservation: A relationship shall preserve and extend the trace chain. The relationship itself shall have provenance, and traversal across the relationship shall not break the provenance of the connected objects.
• Representation Independence: A relationship shall be independent of representation format. The same relationship shall hold regardless of how the connected objects or the relationship itself is rendered or stored.
• Technology Independence: A relationship shall be independent of storage technology, graph implementation, or query language. The architectural semantics of the relationship shall be preserved across implementations.
Relationship Properties
Every Relationship shall possess the following properties at the architectural level:
• Type: The governed classification of the relationship (e.g., Depends On, Implements, Constrains, Refines, Supersedes, Derived From, References, Contradicts, Supports, Equivalent To, Requires, Specializes, Generalizes).
• Direction: The directed nature of the connection, from source to target.
• Cardinality (conceptual): The conceptual cardinality of the relationship (e.g., one-to-one, one-to-many, many-to-many) at the architectural level. Implementation-specific cardinality constraints are outside this model.
• Stability: The expected stability of the relationship over time (e.g., stable, evolving, transient).
• Validity: Conditions under which the relationship is considered valid (e.g., temporal validity, conditional validity).
• Strength (optional): A conceptual indication of the strength or significance of the relationship, if applicable to the relationship type.
• Transitivity (if applicable): Whether the relationship type is transitive, and under what conditions transitivity holds.
• Symmetry (if applicable): Whether the relationship type is symmetric, and how symmetry is declared or modeled.
• Traceability: Explicit provenance linking the relationship to its origin, governance decisions, and connected objects' provenance.
• Governance: Lifecycle status, approval status, and governance rules applicable to the relationship.
These properties are architectural and conceptual. They define what a relationship is and what information it must carry. Implementations may realize these properties in any technology that preserves the architectural semantics.
5. Relationship Types
Relationship Types define the semantic categories of connections between Knowledge Objects. CORE-004 defines a core set of relationship types at the architectural level. This set is not exhaustive; it provides a foundational vocabulary. Additional types may be introduced through governed extension, provided they are consistent with the architectural model and principles defined in this document and in CORE-001.
Core Relationship Types
• Depends On: The source Knowledge Object depends on the target for its validity, completeness, or correct interpretation. The target is a prerequisite or foundational element for the source.
• Implements: The source Knowledge Object implements or realizes the target. Typically used for relationships between concrete solutions and abstract specifications, patterns, or principles.
• Constrains: The source Knowledge Object imposes a constraint on the target. The target is limited, shaped, or restricted by the source.
• Refines: The source Knowledge Object refines or provides more detail about the target. The source is a more precise or elaborated version of the target.
• Supersedes: The source Knowledge Object supersedes or replaces the target. The target is deprecated or obsolete in favor of the source.
• Derived From: The source Knowledge Object is derived from the target. The source originates from or is transformed from the target, with explicit derivation process recorded in provenance.
• References: The source Knowledge Object refers to or cites the target. The reference is relevant but does not imply dependency, derivation, or semantic equivalence.
• Contradicts: The source Knowledge Object contradicts or conflicts with the target. The two objects cannot both be valid under the same conditions or assumptions.
• Supports: The source Knowledge Object supports or provides evidence for the target. The source strengthens or corroborates the target without being a prerequisite.
• Equivalent To: The source Knowledge Object is semantically equivalent to the target. They represent the same meaning, possibly in different contexts or representations.
• Requires: The source Knowledge Object requires the target for its validity or applicability. The target is a necessary condition or component.
• Specializes: The source Knowledge Object is a specialization of the target. The source is a more specific case or subtype of the target.
• Generalizes: The source Knowledge Object is a generalization of the target. The source abstracts or encompasses the target.
These relationship types are defined at the architectural level. They carry semantic meaning independent of any implementation. Governance rules, lifecycle, and applicability in context assembly may differ by relationship type. Detailed governance specifications for each type are outside the scope of this model but shall be consistent with KGM principles.
Extension of Relationship Types
Additional relationship types may be proposed and governed. Any extension shall:
• Be consistent with the architectural model and invariants defined in this document.
• Preserve semantic meaning, provenance, and identity of connected Knowledge Objects.
• Be representation-independent and technology-independent.
• Be traceable to principles in CORE-001 and to the Mission in CORE-000.
Relationship type extensions shall be reviewed and approved through governed processes before use in the Knowledge Graph.
6. Relationship Semantics
Relationship Semantics define how meaning is carried and preserved by relationships. A relationship is not merely a link; it is a carrier of meaning that affects how the connected Knowledge Objects are interpreted together.
Semantic Preservation
A relationship shall preserve the semantic meaning of the Knowledge Objects it connects. The existence of a relationship shall not redefine, alter, or obscure the meaning of either object. Meaning is carried by the objects (per KOM) and by the relationship type; the connection itself is a semantic assertion, not a semantic transformation.
Semantic Composition
When traversing relationships, the composed meaning of a path shall be determinable from the meanings of the nodes and the semantics of the relationships traversed. Traversal shall not introduce ambiguity or require external context to interpret the composed meaning. This is essential for deterministic context assembly and AI reasoning.
Semantic Neighborhood
The Semantic Neighborhood of a Knowledge Object is the set of Knowledge Objects reachable through governed relationships, along with the relationships themselves. The neighborhood provides context for interpretation, enables discovery, and supports the emergence of Working Contexts that are coherent and relevant. Neighborhood boundaries may be defined by relationship type, depth, governance status, or other governed criteria.
Semantic Integrity
The Knowledge Graph as a whole shall maintain semantic integrity: the meanings of nodes and relationships shall be consistent and non-contradictory within governed bounds. Contradictions (modeled explicitly via Contradicts relationships) are permitted and shall be traceable; implicit or undetected contradictions undermine graph integrity and shall be prevented through governance.
Relationship Explicitness
Every semantic relationship that is authoritative within the KOS shall be explicitly represented in the Knowledge Graph. Implicit relationships (e.g., derived from document structure, co-occurrence, or statistical inference) may be computed or inferred for specific purposes, but they shall be clearly distinguished from governed, authoritative relationships. Only explicit, governed relationships shall be used for deterministic traversal, context assembly, and governance decisions.
7. Graph Integrity
Graph Integrity ensures that the Knowledge Graph remains a reliable, coherent, and trustworthy structure over time. Integrity encompasses consistency, non-ambiguity, identity preservation, semantic preservation, provenance preservation, and governance compliance.
Consistency
The Knowledge Graph shall be consistent: there shall be no conflicting or contradictory assertions that are not explicitly modeled and governed. Contradictions shall be represented explicitly (via Contradicts relationships) and shall be traceable to their sources. Implicit contradictions shall be detected and resolved through governed processes.
Non-ambiguity
The Knowledge Graph shall be non-ambiguous: traversal and interpretation shall produce determinate results given stable inputs and governed rules. Ambiguity introduced by implicit relationships, unclear semantics, or missing provenance shall be prevented through governance.
Identity Preservation
The Knowledge Graph shall preserve the Canonical Identity of all Knowledge Objects. No relationship or traversal shall alter, substitute for, or obscure Canonical Identity. Identity is governed by EKIS; the graph operates on identities, it does not redefine them.
Semantic Preservation
The Knowledge Graph shall preserve semantic meaning across relationships and traversal. The meaning of a Knowledge Object shall not change because of its connections. Composed meaning along a path shall be determinable from node meanings and relationship semantics.
Provenance Preservation
The Knowledge Graph shall preserve provenance across relationships and traversal. The trace chain from any node or relationship back to the Source of Truth shall remain intact. Relationships shall carry their own provenance and shall extend, not break, the provenance of connected objects.
Governance Compliance
The Knowledge Graph shall comply with governance rules: all nodes and relationships shall have governed lifecycle status, all changes shall be versioned and auditable, and all operations shall respect the principles defined in CORE-001 and the models defined in CORE-002 and CORE-003.
Graph Integrity is a governance concern as well as an architectural one. Governance processes shall monitor, detect, and resolve integrity violations. Integrity violations shall be treated as governance failures and shall trigger review and remediation.
8. Relationship Lifecycle & Governance
Relationships, like Knowledge Objects, have a governed lifecycle. They are created, reviewed, approved, frozen, deprecated, and archived through controlled processes. Relationship governance ensures that connections between Knowledge Objects are explicit, justified, auditable, and aligned with architectural principles.
Relationship Lifecycle States
• Proposed: The relationship has been proposed but has not yet undergone formal review. It may be used in draft contexts but is not yet authoritative.
• Reviewed: The relationship has undergone formal review for semantic correctness, compliance with principles, and traceability. Changes require justification and audit trail.
• Approved: The relationship has passed review and is approved for use. It may be used in context assembly and reasoning.
• Frozen: The relationship is frozen as an authoritative reference. Its semantics, properties, and connections are immutable. Changes require creation of a new relationship or new version through governed evolution.
• Deprecated: The relationship is no longer recommended for new use. Existing references should migrate to successor relationships. Deprecation does not delete or reassign identity. Deprecated relationships remain resolvable for historical and audit purposes.
• Archived: The relationship is retained for historical or audit purposes but is no longer active. Resolution may return the archived relationship or a pointer to its successor.
Lifecycle transitions shall be governed. Each transition shall be recorded with timestamp, actor, justification, and before/after state. Governance rules may differ by relationship type.
Relationship Governance
Relationship governance encompasses:
• Creation: Governed processes for proposing and justifying new relationships, including validation against relationship invariants and semantic rules.
• Review: Formal review for semantic correctness, compliance with principles, and traceability. Review may be human-led, AI-assisted, or automated where governed rules permit.
• Approval: Authorization for a relationship to become active and usable in context assembly and reasoning.
• Freezing: Designation of a relationship as an authoritative, immutable reference (per P-019).
• Deprecation and Migration: Governed processes for retiring relationships and migrating references to successor relationships.
• Audit: Logging of all relationship operations with sufficient detail for accountability, impact analysis, and compliance verification.
Relationship governance is essential for maintaining Graph Integrity and for ensuring that the Knowledge Graph remains a trustworthy substrate for Human–AI collaboration over time.
9. Relationship to Future CORE
CORE-004 (KGM) provides the relationship foundation for subsequent CORE documents. The following summarizes how future CORE documents shall build upon KGM:
CORE-005 (Context Assembly Specification): Shall assemble Working Contexts by traversing and selecting from the Knowledge Graph defined by KGM. Assembly rules shall operate on KGM relationships, preserving semantics, provenance, and graph integrity. Working Contexts shall emerge from graph traversal and governed selection, not from document navigation. The concept of Knowledge Neighborhood (introduced in KGM) shall be foundational for context assembly strategies.
CORE-006 (AI Collaboration Protocol): Shall enable AI systems to request, receive, and reason over Knowledge Graphs and subgraphs defined by KGM. Protocols shall support traversal, neighborhood queries, and relationship-aware reasoning. AI systems shall receive graph structures that preserve KGM semantics, provenance, and integrity.
CORE-007 (Knowledge Operating System Architecture): Shall integrate KGM as the relationship layer. Architectural views, interfaces, and governance processes shall be consistent with KGM definitions. Technology choices for graph storage, traversal, and reasoning shall be evaluated against their ability to preserve KGM architectural semantics.
Any future work that references or operates on relationships between knowledge units within the KOS shall do so in a manner consistent with the KGM defined in this document. Extensions or specializations are permitted only if they preserve the architectural properties established here.
10. Summary
CORE-004 defines the Knowledge Graph Model (KGM) Specification — the standard conceptual model of the Knowledge Graph as an architectural abstraction representing how Knowledge Objects relate to one another.
A Knowledge Graph is a directed, typed, governed graph in which nodes are Knowledge Objects (per KOM), edges are explicit, typed, governed relationships with defined semantics and properties, and the graph as a whole preserves semantic meaning, provenance, and architectural intent. The graph supports deterministic traversal, context emergence, and long-term governance for both human and AI consumers.
KGM defines the relationship model, core relationship types, relationship semantics, graph integrity requirements, knowledge neighborhood concept, and relationship lifecycle and governance — all at the level of architectural abstraction, not implementation or technology.
KGM realizes multiple principles from CORE-001 and depends on EKIS (CORE-002) for identity and KOM (CORE-003) for node definition. It introduces new architectural principles specific to relationships and graphs, including Relationship Preservation, Graph Neutrality, Context Emergence, Relationship Explicitness, and Traversal Independence.
With CORE-004 frozen, the KOS has a complete foundational triad: Identity (CORE-002), Object (CORE-003), and Relationship (CORE-004). CORE-005 can now focus on the assembly of Working Contexts from coherently related Knowledge Objects, and CORE-006 can enable AI systems to reason over knowledge structures, all grounded in a common architectural model.
CORE-004 completes the shift from document-centric knowledge management to a Knowledge Operating System in which knowledge is identified, structured, related, and assembled in a governed, traceable, and evolvable manner.