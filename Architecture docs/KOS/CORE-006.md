EGAL Knowledge Operating System (KOS)
CORE-006
AI Collaboration Protocol (ACP)

Frozen Version 1.0
Document ID: CORE-006
Document Type: Architectural Document Specification (Level 6)
Status: Draft v1.0
Date: 2026-07-06
Depends on: CORE-000 (Frozen), CORE-001 (Frozen), CORE-002 (Frozen), CORE-003 (Frozen), CORE-004 (Frozen), CORE-005 (Frozen)
Audience: Knowledge Architects, AI Engineers, Knowledge Engineers, Architecture Review Board

This document defines the AI Collaboration Protocol (ACP) as an architectural abstraction governing collaboration between humans and AI over governed Working Contexts. ACP ensures that Human Authority, Identity, Semantic Integrity, Provenance, and Governance are preserved throughout the collaboration lifecycle.

1. Introduction
CORE-006 defines the AI Collaboration Protocol (ACP) for the EGAL Knowledge Operating System. This document establishes ACP as an architectural abstraction — a governed protocol for collaboration between humans and AI over Working Contexts that have been assembled and validated according to CORE-005.
The primary purpose of CORE-006 is to answer the question: How do humans and AI collaborate over governed Working Contexts while preserving Mission, Identity, Meaning, Provenance, and Human Authority? This includes defining the roles of humans and AI, how AI consumes Working Contexts, what outputs AI may produce, how outputs are validated and integrated, how collaboration sessions are governed, and how architectural trust is established.
CORE-006 is the first document in the CORE Series that models the behavior of humans and AI in collaboration, rather than the behavior of knowledge itself. It builds directly on CORE-005 (Context Assembly Specification), which defines how Working Contexts are assembled. CORE-006 defines how those contexts are consumed, reasoned over, and acted upon by humans and AI within a governed collaboration protocol.
CORE-006 does not define prompt engineering, prompt templates, MCP, A2A, chat protocols, REST/gRPC APIs, tool calling, agent frameworks, multi-agent scheduling, model selection, token management, or any specific AI implementation technology. It defines the architectural protocol for governed collaboration. Implementations may realize this protocol using any transport or technology that preserves the architectural semantics and guarantees.
Relationship to CORE-000: CORE-006 directly supports the Mission by defining how humans and AI collaborate over Working Contexts — the execution units of Human–AI collaboration. The Mission is fulfilled when collaboration preserves architectural intent and produces outcomes that can be governed and integrated back into the knowledge system.
Relationship to CORE-001: CORE-006 realizes multiple principles from CORE-001, including P-003 (Context-first), P-012 (Working Context as Collaboration Unit), P-013 (Shared Understanding), P-014 (Deterministic Context), P-015 (Human Authority and AI Assistance), P-017 (Traceability and Provenance), P-020 (Technology Independence and Long-term Evolvability), and P-021 (Progressive Refinement and Compatibility). Additionally, CORE-006 introduces new architectural principles specific to Human–AI collaboration (detailed in Chapter 7).
Relationship to CORE-002: CORE-006 depends on EKIS for Canonical Identity. All references to Knowledge Objects and Working Contexts within collaboration shall use Canonical Identity. Collaboration shall not alter or substitute for Canonical Identity.
Relationship to CORE-003: CORE-006 depends on KOM for the definition of Knowledge Objects. AI shall consume and reason over KOM-compliant Knowledge Objects. Collaboration shall preserve KOM properties (atomicity, semantic completeness, independence) and shall not modify or redefine Knowledge Objects.
Relationship to CORE-004: CORE-006 depends on KGM for the definition of Knowledge Relationships and the Knowledge Graph. AI shall respect KGM relationships and graph integrity. Collaboration shall not alter relationships or the graph structure.
Relationship to CORE-005: CORE-006 depends on CAS for the definition of Working Contexts and Context Contracts. Working Context is the primary collaboration unit. AI shall consume Working Contexts as assembled and governed by CAS. Collaboration shall respect Context Contracts and shall not bypass assembly governance.
CORE-006 is an Architectural Document Specification. It provides the collaboration protocol layer upon which CORE-007 (Knowledge Operating System Architecture) depends for integrating Human–AI collaboration into the overall system architecture.
2. Architectural Context
The transition from Working Context (CORE-005) to Human–AI Collaboration (CORE-006) represents the shift from knowledge behavior to collaboration behavior. CORE-005 defines how Working Contexts are assembled from the Knowledge Graph. CORE-006 defines how humans and AI interact over those contexts within a governed protocol.
In current AI systems, collaboration between humans and AI is often ad-hoc or mediated by chat interfaces, prompt templates, or agent frameworks. These approaches have architectural limitations:
• Context is often implicit or reconstructed from conversation history, losing governance and provenance.
• AI may operate directly on documents, raw data, or unassembled knowledge, bypassing governed Working Contexts.
• Outputs may be integrated without validation, risking contamination of the knowledge base.
• Human authority may be bypassed or diluted by automation.
• Collaboration is not deterministic or auditable at the architectural level.
• There is no clear architectural contract between human and AI regarding what is being collaborated over and what guarantees are provided.
ACP inverts this. Collaboration is governed, explicit, and architecture-first:
• Working Context (assembled and governed per CORE-005) is the primary collaboration unit.
• AI consumes Working Context as an architectural input, not as raw documents or prompts.
• AI outputs are validated and integrated through governed processes, preserving Human Authority.
• Collaboration sessions have lifecycle, governance, and auditability.
• Architectural guarantees (Identity, Provenance, Semantic Integrity, Human Authority) are preserved throughout.
• Collaboration Contract provides explicit architectural commitments between human and AI.
The position of CORE-006 in the architectural stack completes the chain from Mission to actionable collaboration:
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
CORE-006: Human–AI Collaboration (ACP)
          ↓
CORE-007: Knowledge Operating System Architecture
CORE-006 is the layer that operationalizes Human–AI collaboration within the governed knowledge system. It ensures that AI participates as a collaborator under Human Authority, working within the bounds of governed Working Contexts, and producing outputs that are validated and integrated through governed processes. This completes the architectural foundation for a Knowledge Operating System in which knowledge is identified, structured, related, assembled, and collaboratively acted upon in a consistent, verifiable, and evolvable manner.
3. Human–AI Collaboration Model
Human–AI Collaboration within EGAL KOS is a governed interaction in which humans and AI work together over Working Contexts to achieve specific tasks, with Human Authority preserved, architectural guarantees maintained, and outcomes integrated through governed validation processes.
Definition of AI Collaboration
AI Collaboration is the governed process by which humans and AI interact over Working Contexts (assembled per CORE-005) to perform tasks, produce outputs, and contribute to the knowledge system, while preserving Human Authority, Identity, Semantic Integrity, Provenance, and Governance throughout the collaboration lifecycle.
Architectural Role of AI within EGAL KOS
AI serves as a collaborator and reasoning assistant within the KOS, not as an autonomous authority or knowledge creator. AI may analyze, summarize, review, plan, translate, generate drafts, and provide reasoning support — but always within the bounds of a governed Working Context and subject to Human Authority for validation and integration. AI augments human capability; it does not replace human accountability or governance.
Role of Human Authority
Human Authority is the ultimate authority over governance, validation, and integration of knowledge within the KOS. AI may propose, reason, and generate outputs, but no AI output shall be integrated into the knowledge base without governed human validation and approval. Human Authority is non-negotiable and shall be preserved in all collaboration protocols, governance processes, and system designs.
Collaboration Unit
The primary unit of collaboration is the Working Context (per CORE-005). A collaboration session is a governed interaction between human(s) and AI over one or more Working Contexts to achieve a defined task. Sessions have lifecycle, governance, and auditability. Multiple sessions may be linked through provenance and governance records.
Key Distinctions
• AI Output vs Knowledge: AI Output is the result of a collaboration session. Knowledge is formed only when that output is validated and integrated into the knowledge system through governed processes. AI does not create knowledge; it contributes candidate outputs that become knowledge only after governed integration.
• Collaboration Contract: A Collaboration Contract defines the architectural commitments for a collaboration session, including roles and responsibilities of human and AI, Working Context(s) to be used, types of outputs permitted, architectural constraints, and validation/integration processes. Collaboration Contract provides explicit guarantees and accountability.
4. Collaboration Roles
Collaboration Roles define the responsibilities and authorities of participants in Human–AI collaboration. Roles are architectural and governed; they are not tied to specific individuals, AI models, or implementations.
Human Roles
• Requester: Initiates a collaboration session by requesting a Working Context for a defined task. Responsible for task definition, constraints, and authority verification.
• Reviewer: Reviews AI outputs for correctness, compliance with architectural constraints, and suitability for the task. May request clarification, revision, or rejection.
• Approver: Authorizes integration of validated AI outputs into the knowledge system. Carries accountability for integration decisions.
• Architect: Defines or reviews architectural constraints, governance rules, and Collaboration Contracts. Ensures alignment with CORE principles and models.
• Owner: Owns a Working Context or collaboration session. Responsible for its lifecycle, governance, and eventual closure or archival.
• Governor: Oversees governance processes, audits collaboration sessions, and ensures compliance with architectural principles and policies.
AI Roles
• Analyzer: Analyzes a Working Context to identify patterns, gaps, inconsistencies, or implications. Produces analysis outputs for human review.
• Summarizer: Produces summaries or syntheses of a Working Context or portions thereof. Summaries shall preserve provenance and shall not alter meaning.
• Reviewer: Reviews existing knowledge or outputs against a Working Context for consistency, completeness, or compliance. Produces review findings for human consideration.
• Planner: Generates plans or proposed sequences of actions based on a Working Context and task. Plans are proposals subject to human validation.
• Translator: Translates or transforms content within a Working Context across representations or formats while preserving meaning and provenance.
• Generator: Generates draft content (e.g., documents, decisions, patterns) based on a Working Context and task. Drafts are candidates for human review and integration.
• Reasoning Assistant: Provides reasoning support, explanations, or inference within the bounds of a Working Context. Outputs are advisory and subject to human validation.
Roles are not mutually exclusive; a participant may assume multiple roles within a session or across sessions. Role definitions are architectural; specific assignments are governed by organizational policy and authority structures.
5. Working Context Consumption
Working Context is the primary input to AI collaboration at the architectural level. AI shall consume Working Contexts as assembled and governed by CORE-005, not as raw documents, unassembled knowledge, or ad-hoc prompts.
Consumption Model
AI consumes a Working Context as a governed, bounded, provenance-preserving collection of Knowledge Objects and Relationships. Consumption shall respect:
• Canonical Identity: All references shall use Canonical Identity. AI shall not substitute or obscure identity.
• Semantic Boundary: AI shall operate within the defined boundary of the Working Context. Reasoning or generation outside the boundary requires explicit justification and may trigger re-assembly.
• Provenance: AI shall preserve and extend provenance. Outputs shall carry traceable links to source Knowledge Objects and the Working Context.
• Context Contract: AI shall respect the guarantees and constraints specified in the Context Contract (per CORE-005).
AI shall not bypass Working Context to operate directly on documents, raw data, or unassembled knowledge stores. Working Context is the architectural interface between the knowledge system and AI collaboration.
Context Fidelity
AI shall maintain Context Fidelity: it shall work within the limits of the Working Context provided and shall not introduce external knowledge, assumptions, or inferences that are not traceable to the provided context or governed sources. Context Fidelity ensures that AI reasoning remains grounded in governed knowledge and that outputs are attributable and auditable.
6. AI Output Model
AI may produce outputs within a collaboration session. Outputs are candidate contributions to the knowledge system; they become knowledge only after governed validation and integration.
Permitted Output Types
AI may produce the following types of outputs within the bounds of a Working Context and Collaboration Contract:
• Analysis: Structured analysis of patterns, gaps, inconsistencies, or implications within the Working Context.
• Recommendation: Proposed courses of action, decisions, or changes, with rationale and traceability to the Working Context.
• Draft: Draft content (e.g., documents, decisions, patterns, processes) for human review and potential integration.
• Transformation: Transformed or translated representations of content within the Working Context, preserving meaning and provenance.
• Question: Clarifying questions or requests for additional context to improve reasoning or completeness.
• Reasoning Trace: Traceable reasoning steps or explanations supporting other outputs.
Output Constraints
AI outputs shall comply with the following architectural constraints:
• No Mutation of Knowledge Objects: AI shall not modify, edit, or delete Knowledge Objects. Outputs may propose new objects or changes, but changes require governed validation and integration.
• No Mutation of Knowledge Graph: AI shall not alter relationships or graph structure. Outputs may propose new relationships, but changes require governed validation and integration.
• No Alteration of Canonical Identity: AI shall not alter, reassign, or obscure Canonical Identity. All references in outputs shall use Canonical Identity.
• Provenance Preservation: All outputs shall carry explicit provenance linking them to the Working Context, source Knowledge Objects, and collaboration session.
• Output Non-Mutation: AI outputs shall not automatically modify the knowledge base. Integration requires governed human validation and approval.
AI outputs are proposals or contributions, not authoritative knowledge. They become part of the knowledge system only through governed integration processes that preserve Human Authority and architectural guarantees.
7. Validation Model
Validation is the governed process by which AI outputs are reviewed, approved, and integrated into the knowledge system. Validation preserves Human Authority and ensures that outputs meet architectural and task requirements before integration.
Validation Flow
AI Output → Human Review → Approval → Knowledge Integration
• Human Review: Human reviewers assess AI outputs for correctness, compliance with architectural constraints, relevance to task, and suitability for integration. Review may be supported by AI-assisted tools but shall not be fully automated for integration decisions.
• Approval: Authorized human approvers authorize integration of validated outputs. Approval carries accountability and shall be recorded in provenance.
• Knowledge Integration: Approved outputs are integrated into the knowledge system through governed processes (e.g., creation of new Knowledge Objects, updates to existing objects, addition of relationships). Integration shall preserve identity, semantics, and provenance.
Explicit Validation
Validation shall be explicit and governed. Automated validation or approval may be used for low-risk or routine cases under governed policies, but integration of AI outputs into the authoritative knowledge base shall require human authorization. Implicit or bypassed validation undermines Human Authority and architectural trust.
Validation shall verify that outputs comply with Output Constraints (Chapter 6) and architectural principles. Non-compliant outputs shall be rejected, revised, or escalated for governance review.
8. Collaboration Lifecycle
Collaboration sessions have a governed lifecycle to ensure accountability, auditability, and proper closure. Lifecycle states and transitions shall be recorded and auditable.
Standard Lifecycle States
• Request: A collaboration session is requested with defined task, Working Context(s), constraints, and authority. Request is logged and may undergo initial validation.
• Assembly: Working Context(s) are assembled or retrieved per CORE-005. Assembly provenance is recorded.
• Delivery: Working Context(s) are delivered to AI (and human participants) with Context Contract. Delivery is logged.
• AI Processing: AI consumes Working Context(s), performs reasoning or generation, and produces outputs. All AI activities are logged with provenance.
• Human Review: Human reviewers assess AI outputs. Review findings and decisions are logged.
• Approval: Authorized approvers authorize integration or other actions. Approval decisions are logged with accountability.
• Knowledge Integration: Approved outputs are integrated into the knowledge system through governed processes. Integration actions are logged with provenance.
• Closure: The collaboration session is closed. Final provenance, audit trail, and any follow-up actions are recorded. Session may be archived.
Lifecycle transitions shall be governed. Each transition shall be recorded with timestamp, actor, justification, and before/after state. Governance rules may differ by task type, authority level, or organizational policy.
9. Governance
Governance of Human–AI Collaboration ensures that collaboration sessions are conducted in accordance with architectural principles, that Human Authority is preserved, and that outcomes are accountable and auditable.
Governance Scope
Governance encompasses:
• Session Initiation: Validation of task, authority, Working Context appropriateness, and compliance with policies.
• Collaboration Conduct: Monitoring of AI activities, human decisions, and adherence to Collaboration Contract and architectural constraints.
• Output Validation and Integration: Governance of review, approval, and integration processes to ensure compliance and accountability.
• Provenance and Audit: Maintenance of complete, queryable audit trails for all collaboration activities.
• Lifecycle Management: Governance of session lifecycle transitions, including closure and archival.
• Policy Enforcement: Enforcement of architectural policies, constraints, and principles throughout collaboration.
Governance Mechanisms
Governance may be implemented through a combination of human oversight, governed automation, and audit processes. Automated governance mechanisms (e.g., policy enforcement, provenance logging) are permitted and encouraged where they preserve Human Authority and architectural guarantees. Fully automated integration of AI outputs into the authoritative knowledge base shall require human authorization per Explicit Validation (Chapter 7).
Governance is essential for maintaining architectural trust and for ensuring that Human–AI collaboration contributes to the knowledge system in a controlled, accountable, and evolvable manner.
10. Relationship to CORE-007
CORE-006 (ACP) provides the collaboration protocol foundation for CORE-007 (Knowledge Operating System Architecture). CORE-007 shall integrate ACP as the layer governing Human–AI collaboration over Working Contexts.
CORE-007 shall:
• Incorporate ACP roles, lifecycle, and governance into the overall system architecture.
• Ensure that architectural views, interfaces, and governance processes are consistent with ACP definitions.
• Evaluate technology choices for collaboration interfaces and governance mechanisms against their ability to preserve ACP architectural semantics and guarantees.
• Define how ACP integrates with other system components (e.g., identity management, governance frameworks, audit systems).
Any future work that references or operates on Human–AI collaboration within the KOS shall do so in a manner consistent with the ACP defined in this document. Extensions or specializations are permitted only if they preserve the architectural properties established here.
11. Summary
CORE-006 defines the AI Collaboration Protocol (ACP) — the architectural protocol governing collaboration between humans and AI over governed Working Contexts assembled per CORE-005.
ACP ensures that Human Authority is preserved, that AI operates within the bounds of governed Working Contexts (Context Fidelity), that outputs are validated and integrated through governed processes, and that architectural guarantees (Identity, Semantic Integrity, Provenance, Governance) are maintained throughout the collaboration lifecycle.
ACP defines Human and AI roles, Working Context consumption, AI output model and constraints, validation model, collaboration lifecycle, trust model, and governance — all at the level of architectural abstraction, independent of specific AI models, prompt engineering, agent frameworks, or transport protocols.
ACP realizes multiple principles from CORE-001 and depends on EKIS (CORE-002), KOM (CORE-003), KGM (CORE-004), and CAS (CORE-005). It introduces new architectural principles specific to Human–AI collaboration, including Human Authority, Context Fidelity, Architectural Trust, Output Non-Mutation, Explicit Validation, and Collaboration Transparency.
With CORE-006 frozen, the KOS has a complete architectural foundation from Mission through knowledge identification, object modeling, graph relationships, context assembly, and governed Human–AI collaboration. CORE-007 can now integrate these layers into a coherent Knowledge Operating System architecture that enables consistent, verifiable, and evolvable collaboration between humans and AI over governed knowledge.