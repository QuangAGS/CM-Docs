# EGAL ARCHITECTURE BIBLE

## (01\_EGAL\_Architecture\_Bible.md)

# 

# PART I

\*\*Project:\*\* EGAL (Elder Guidance & Accessibility Layer)  

\*\*Host System:\*\* Genealogy Platform (React \+ Vite)  

\*\*Document Type:\*\* Architecture Bible / Retrospective Chronicle  

\*\*Status:\*\* EGAL-6.5 UAT PASS  

\*\*Audience:\*\* Future maintainers, architects, UX engineers, accessibility engineers, onboarding contributors  

\*\*Purpose:\*\* Preserve architectural intent, explain historical pivots, document design decisions, and prevent regression-by-refactor.

\---

\# PART I — EXECUTIVE SUMMARY

\---

\#\# 1.1 What Is EGAL?

\*\*EGAL (Elder Guidance & Accessibility Layer)\*\* is an accessibility-oriented orchestration layer designed specifically for \*\*elderly users\*\* interacting with a genealogy platform.

The project began as a UX enhancement effort but evolved into a \*\*behavioral guidance architecture\*\*, whose primary objective is:

\> To reduce cognitive overload and navigation uncertainty for elderly users while preserving the integrity of existing business flows.

Unlike conventional accessibility systems that primarily focus on visual scaling, contrast, or ARIA semantics, EGAL addresses a deeper issue:

\> \*\*Cognitive navigation confidence.\*\*

The target problem was not simply:

\> “Can elderly users see the interface?”

but rather:

\> “Can elderly users confidently understand what is happening, what to do next, and recover safely from mistakes?”

This distinction fundamentally shaped the architecture.

EGAL therefore became:

\> \*\*An orchestration layer for attention, guidance, validation safety, navigation predictability, and confidence preservation.\*\*

\---

\#\# 1.2 Original Problem Statement

Before EGAL, the genealogy platform already functioned correctly from a business perspective.

Authentication worked.

Forms worked.

Clan creation worked.

Clan joining worked.

Validation existed.

Navigation existed.

Technically speaking:

\> The system was operational.

However, repeated real-world UAT revealed an uncomfortable truth:

\> Functional correctness did not imply usability for elderly users.

Multiple recurring patterns emerged.

\#\#\# Problem A — Loss of Attention Focus

Users frequently failed to notice important messages.

For example:

\- validation errors appeared outside attention focus

\- success states lacked emotional closure

\- transitions happened before comprehension

In younger users this caused inconvenience.

In elderly users it caused:

\- hesitation

\- confusion

\- abandonment anxiety

\- repeated retries

The issue was not technical failure.

The issue was:

\> \*\*attention placement failure.\*\*

\---

\#\#\# Problem B — Fear of Irreversible Mistakes

Elderly users exhibited unusually high caution when interacting with family genealogy operations.

Examples:

\- creating a clan

\- joining a clan

\- registration steps

\- identity submission

Users hesitated because they felt:

\> “If I press next, maybe I cannot go back.”

Traditional UX assumes confidence.

Elderly UX cannot.

This led to a major realization:

\> Elderly interfaces require \*\*psychological reversibility\*\*.

Meaning:

\> Users must feel safe to proceed.

Even if the actual business process is unchanged.

\---

\#\#\# Problem C — Hidden State Confusion

Users frequently became disoriented during multistep flows.

Example:

A user edited information.

Then moved forward.

Then returned.

Unexpected values appeared.

Or values remained unexpectedly.

Or validation behaved differently.

Technically:

The application state was still correct.

Psychologically:

The user perceived inconsistency.

This distinction became critical.

EGAL architecture later formalized a key principle:

\> \*\*Draft values are not runtime truth.\*\*

and:

\> \*\*Perceived consistency matters as much as actual consistency.\*\*

\---

\#\#\# Problem D — Navigation Uncertainty

Users frequently asked implicit questions:

\- “Am I still on the right path?”

\- “Did I do something wrong?”

\- “What happens if I continue?”

\- “Can I still edit?”

\- “Where did my data go?”

Traditional SPA navigation produced anxiety because transitions felt abrupt.

This later became one of the largest architecture drivers of EGAL.

\---

\#\# 1.3 Core Architectural Goal

The purpose of EGAL was never:

\> Replace the application.

Nor:

\> Rewrite the UI.

Nor:

\> Introduce a new business flow.

Instead:

The architecture pursued a strict constraint:

\> \*\*Improve confidence without breaking working business logic.\*\*

This became the foundational non-negotiable principle.

\#\#\# Principle Q1

\> Do not break working business flow.

The team repeatedly rejected elegant refactors if they introduced risk.

This had a major consequence:

EGAL became:

\> \*\*a layered architecture\*\*

rather than:

\> \*\*a replacement architecture\*\*

Meaning:

The genealogy system remained authoritative.

EGAL wrapped around it.

This distinction explains nearly every later architecture decision.

\---

\#\# 1.4 Why EGAL Became an Architectural Project

Initially, the effort appeared to be a collection of UX improvements.

Examples:

\- better messaging

\- attention centering

\- sound feedback

\- guided buttons

\- better transitions

However, repeated UAT uncovered a deeper reality:

Small UX fixes repeatedly exposed structural problems.

Example pattern:

Problem appears  

→ quick patch applied  

→ new UAT reveals hidden coupling  

→ deeper architectural issue discovered

This repeated many times.

Eventually the project crossed an invisible boundary.

The system was no longer:

\> “Improving UI”

It became:

\> \*\*Building an accessibility orchestration architecture.\*\*

The shift happened because elderly guidance requirements touched:

\- navigation lifecycle

\- runtime state

\- validation timing

\- attention management

\- transition ownership

\- form authority

\- review semantics

\- recovery behavior

These concerns spanned multiple layers.

Simple component-level fixes no longer worked.

The architecture had to evolve.

\---

\#\# 1.5 The Foundational Philosophy

Throughout EGAL development, a consistent philosophy emerged.

\#\#\# Rule 1 — Preserve What Already Works

Business correctness was treated as sacred.

The platform already had:

\- working auth

\- working registration

\- working clan creation

\- working clan joining

Therefore:

Architecture changes had to preserve:

\- flow semantics

\- business ownership

\- existing API assumptions

This philosophy prevented:

\> regression-by-refactor

which later became one of the most important lessons of the project.

\---

\#\#\# Rule 2 — Elderly UX Is Different UX

EGAL rejected the assumption that:

\> “Accessibility is mostly styling.”

Instead, UAT demonstrated:

Elderly accessibility is fundamentally:

\> \*\*decision support UX\*\*

not visual UX alone.

Users required:

\- reassurance

\- reviewability

\- guidance

\- safe progression

\- predictable recovery

\- attention assistance

This led to a paradigm shift:

The interface should not merely respond.

It should:

\> \*\*guide.\*\*

\---

\#\#\# Rule 3 — Confidence Is a System Requirement

Traditional systems optimize for:

\- speed

\- efficiency

\- minimal clicks

EGAL introduced another metric:

\> \*\*confidence preservation\*\*

Meaning:

A slower interaction can be better if:

the user feels safe.

For example:

A review step before submission adds friction.

But for elderly users:

It reduces anxiety.

Therefore:

The architecture optimized for:

\> trust over speed.

\---

\#\#\# Rule 4 — UAT Is the Real Architect

Perhaps the single biggest philosophical lesson:

\> UAT repeatedly disproved theoretical assumptions.

Many “clean” solutions failed real elderly behavior.

Examples included:

\- automatic transitions

\- hidden validations

\- optimistic navigation

\- invisible state assumptions

The project therefore evolved a new rule:

\> Architecture decisions must survive elderly UAT.

Not developer intuition.

This UAT-first principle became central to EGAL.

\---

\#\# 1.6 High-Level Evolution Timeline

The evolution of EGAL can be summarized as follows.

\#\#\# Phase 1 — UX Enhancement

Goal:

Improve elderly usability.

Changes:

\- messaging

\- attention improvements

\- result visibility

Limitation:

Still component-centric.

No orchestration model.

\---

\#\#\# Phase 2 — Guided Interaction

Goal:

Reduce confusion during navigation.

Changes:

\- guided progression

\- ElderAssist

\- TTS support

Limitation:

Still lacked lifecycle authority.

\---

\#\#\# Phase 3 — Attention Architecture

Goal:

Recover user focus.

Changes:

\- AttentionZone

\- attentionOrchestrator

\- progression guidance

\- attention recovery

Limitation:

Navigation inconsistencies remained.

\---

\#\#\# Phase 4 — Lifecycle Safety

Goal:

Eliminate navigation-state confusion.

Changes:

\- navigation lifecycle service

\- validation gate

\- runtime invalidation

\- WaitingPage re-architecture

Result:

System-level consistency emerged.

This marked:

\> \*\*EGAL becoming a mature architecture.\*\*

\---

\#\# 1.7 What EGAL Ultimately Became

By EGAL-6.5, the system had evolved into:

\> \*\*A confidence-preserving orchestration layer for elderly users.\*\*

Its responsibilities include:

\#\#\# Attention Guidance

Helping users notice critical information.

\---

\#\#\# Safe Progression

Preventing invalid transitions.

\---

\#\#\# Review Semantics

Allowing safe inspection before commitment.

\---

\#\#\# Navigation Recovery

Reducing fear after editing or backtracking.

\---

\#\#\# Lifecycle Consistency

Preventing stale state confusion.

\---

\#\#\# Cognitive Reassurance

Helping users feel:

\> “I understand what is happening.”

This outcome was significantly more ambitious than originally planned.

But it emerged naturally through repeated UAT.

\---

\#\# 1.8 Executive Summary Conclusion

EGAL succeeded because it stopped treating elderly accessibility as:

\> a UI decoration problem.

Instead, it treated accessibility as:

\> an orchestration problem.

The core architectural insight of the project became:

\> Elderly users do not merely need larger interfaces.

They need:

\> \*\*predictable, confidence-preserving interaction systems.\*\*

Everything that followed in EGAL architecture emerged from this realization.

\---

\# END OF PART I

# PART II — ORIGINAL VISION VS ACTUAL EVOLUTION

\---

\#\# 2.1 Introduction

EGAL was not built according to a fully predetermined master plan.

Unlike traditional enterprise architecture projects, where a target architecture is designed upfront and implemented incrementally, EGAL evolved through a sequence of:

\> hypothesis → UAT → failure → redesign → stabilization

This distinction is important.

Future maintainers should understand:

\> The final architecture is not the result of theoretical perfection.

It is the result of repeated contact with reality.

In particular:

\> elderly-user reality.

Many architectural decisions that later appeared obvious were initially absent.

Some assumptions turned out to be incorrect.

Others proved incomplete.

And several seemingly minor UX problems revealed deep architectural flaws.

This section documents:

\> what EGAL originally intended to become versus what it ultimately evolved into.

The goal is not historical nostalgia.

The goal is:

\> architectural preservation.

Because future contributors may otherwise unintentionally undo decisions whose rationale is invisible in the final codebase.

\---

\# 2.2 The Original Vision

At the beginning of the initiative, EGAL was envisioned as:

\> a lightweight elderly-assistance UX layer.

The expectation was modest.

The believed scope included:

\#\#\# Better guidance messages

Examples:

\- clearer instructions

\- friendlier validation wording

\- more visible feedback

\---

\#\#\# Better visual focus

Examples:

\- scrolling to important messages

\- centering result panels

\- reducing hidden content

\---

\#\#\# Better interaction comfort

Examples:

\- guided buttons

\- voice assistance

\- elder-friendly pacing

\---

\#\#\# Minor navigation improvements

Examples:

\- smoother transitions

\- reduced confusion

\- simpler step progression

\---

The assumption was:

\> Existing architecture was fundamentally sufficient.

Meaning:

Business flow correctness already existed.

Therefore:

Only surface-level UX improvements would be necessary.

In retrospect:

This assumption proved incomplete.

Not wrong.

But incomplete.

\---

\#\# 2.3 What Was Initially Underestimated

Several critical dimensions of elderly interaction behavior were underestimated.

These later became major architectural drivers.

\---

\#\#\# Underestimated Factor 1 — Cognitive Anxiety

The team initially assumed:

\> confusion was mainly informational.

Meaning:

Users simply needed better instructions.

UAT showed otherwise.

The actual issue was often:

\> emotional uncertainty.

Examples observed:

Users hesitated before pressing buttons.

Users repeatedly reviewed fields.

Users feared committing incorrect information.

Users avoided progression even when valid.

This revealed an important truth:

\> Elderly hesitation is often not lack of understanding.

It is:

\> lack of confidence.

This distinction changed everything.

Because information alone does not solve confidence problems.

Architecture must.

\---

\#\#\# Underestimated Factor 2 — State Predictability

Initially, runtime state behavior was treated as a technical concern.

Developers assumed:

If React state is technically correct:

then UX is correct.

UAT disproved this repeatedly.

Examples:

A form restored values unexpectedly.

A validation behaved differently after navigation.

Users returned to a step and lost confidence.

Even when data integrity was preserved.

The issue became clear:

\> perceived predictability matters more than implementation correctness.

This realization later drove:

\- lifecycle management

\- runtime invalidation

\- review semantics

\---

\#\#\# Underestimated Factor 3 — Navigation Ownership

At first, child forms retained significant navigation authority.

The assumption:

Local components know best.

Example mentality:

Form validates itself.

Form navigates itself.

Form decides progression.

This worked technically.

But produced inconsistencies.

Different forms behaved differently.

Transitions felt unpredictable.

Recovery paths varied.

Eventually a major principle emerged:

\#\#\# Q4 — AuthPage is orchestration root

Meaning:

Navigation authority must be centralized.

Not fragmented.

This became one of the most important pivots in EGAL.

\---

\#\#\# Underestimated Factor 4 — Review Before Commitment

Initially, WaitingPage behaved like:

\> a transitional holding page.

Essentially:

A loading intermediary.

Not a meaningful UX surface.

UAT revealed a severe mismatch.

Elderly users treated that moment differently.

They naturally expected:

\> a final chance to verify.

They wanted reassurance.

They wanted editability.

They wanted psychological confirmation.

This caused a major conceptual change.

WaitingPage evolved from:

\> passive transition state

to:

\> TRUE REVIEW PAGE

This later became:

\#\#\# Q6 — WaitingPage is TRUE REVIEW PAGE

A foundational architecture rule.

\---

\#\# 2.4 The Evolution Pattern

EGAL did not evolve linearly.

Instead:

The architecture followed a recurring pattern.

\#\#\# Pattern

Problem appears in UAT  

↓  

Quick patch attempted  

↓  

Patch solves symptom only  

↓  

New hidden problem emerges  

↓  

Deeper system issue discovered  

↓  

Architecture pivot happens

This pattern repeated continuously.

Understanding this pattern is essential.

Because many EGAL design decisions only make sense in context of the problems they replaced.

Without historical context:

Future developers may mistake them for unnecessary complexity.

They are not.

They are:

\> preserved battle scars.

\---

\#\# 2.5 EGAL-6.1 — The “Attention Problem” Era

\#\#\# Original assumption

Users miss messages because:

\> placement is slightly inconvenient.

Initial solution:

Small UI fixes.

Examples:

\- move messages higher

\- improve visibility

\- better spacing

\---

\#\#\# What UAT showed

The problem was much larger.

Elderly users did not merely overlook messages.

They:

\> lost attention context.

Examples:

Validation appeared outside visible focus.

Result feedback was physically below attention center.

Success states lacked closure.

Users became uncertain whether actions succeeded.

\---

\#\#\# Architectural response

EGAL-6.1 introduced:

\#\#\#\# WaitingPage message instead of alert

Why?

Alerts were disruptive.

Transient.

And psychologically abrupt.

WaitingPage messaging created:

\> contextual continuity.

\---

\#\#\#\# ResultPage attention centering

Why?

Because elderly users visually anchor around screen center.

Important information outside focus was frequently missed.

\---

\#\#\#\# Guided attention improvements

Why?

Because passive interfaces assume initiative.

EGAL began experimenting with:

\> guided attention behavior.

\---

\#\#\# Key lesson

The problem was not:

\> “visibility”

The problem was:

\> \*\*attention orchestration\*\*

This became the first signal that EGAL would become architectural.

Not cosmetic.

\---

\#\# 2.6 EGAL-6.2 — The “Guided Confidence” Era

\#\#\# Original assumption

Users simply needed help discovering actions.

The initial belief:

A helper button and voice support would be enough.

\---

\#\#\# Implementation

EGAL-6.2 introduced:

\- Single Elder Assistance Mode

\- ElderAssistButton

\- TTS Provider integration

\- guided assistance

\---

\#\#\# What UAT showed

Voice guidance helped.

But:

\> guidance without consistency still produced anxiety.

Users still hesitated.

Because knowing what to do next was not enough.

They still worried:

\- “Can I safely continue?”

\- “Will I lose data?”

\- “Can I go back?”

\---

\#\#\# Architectural insight

Confidence requires more than explanation.

It requires:

\> predictable system behavior.

This realization later drove lifecycle architecture.

\---

\#\# 2.7 EGAL-6.3 — The “Attention Recovery” Era

\#\#\# Original assumption

Guidance alone would prevent confusion.

Reality:

Users still lost context.

Especially after interruptions.

Examples:

\- switching focus

\- temporary distraction

\- revisiting steps

\- waiting states

\---

\#\#\# Architectural response

EGAL introduced:

\#\#\#\# AttentionZone

Purpose:

Create explicit focus regions.

\---

\#\#\#\# attentionOrchestrator

Purpose:

Coordinate attention instead of scattering logic.

This was an early orchestration pattern.

A precursor to lifecycle orchestration.

\---

\#\#\#\# guidedProgressionService

Purpose:

Guide transitions.

Not merely permit them.

\---

\#\#\#\# lastAttentionMessage recovery

Purpose:

Restore lost continuity.

This proved surprisingly important.

Elderly users benefited significantly from:

\> remembered context.

\---

\#\#\# Key insight

Attention is not a one-time event.

It is:

\> a recoverable state.

This was one of the earliest major architecture-level discoveries.

\---

\#\# 2.8 EGAL-6.4 — The “Flow Integrity” Era

\#\#\# Original assumption

Guidance services could be attached incrementally.

Reality:

Form-specific inconsistencies became visible.

Examples:

Different forms behaved differently.

JoinClanForm felt safer.

CreateClanForm behaved differently.

Navigation semantics drifted.

\---

\#\#\# Architectural response

Guided progression became integrated into:

\- JoinClanForm

\- CreateClanForm

\- WaitingPage

This marked a subtle but important transition:

EGAL stopped being:

\> optional enhancement

and started becoming:

\> flow-integrated infrastructure.

\---

\#\#\# Emerging concern

However:

Lifecycle inconsistencies remained unresolved.

Examples:

User edits after WaitingPage.

Unexpected step return behavior.

Validation mismatch.

Runtime state confusion.

These issues became increasingly visible.

Leading directly to EGAL-6.5.

\---

\#\# 2.9 EGAL-6.5 — The “Lifecycle Safety” Revolution

EGAL-6.5 was arguably:

\> the most important architecture shift in the project.

It fundamentally changed system maturity.

\---

\#\#\# Trigger

Repeated UAT failures exposed:

\> stale validation

and:

\> lifecycle inconsistency.

Examples:

User edits data.

Returns from WaitingPage.

Unexpected state persists.

Validation behaves incorrectly.

User confidence drops.

\---

\#\#\# The critical realization

The issue was not UI.

Nor messaging.

Nor guidance.

The issue was:

\> lifecycle correctness.

The system needed authoritative state transitions.

Not ad hoc ones.

\---

\#\#\# Architecture introduced

\#\#\#\# navigationLifecycle.service.js

Purpose:

Formalize navigation behavior.

\---

\#\#\#\# validationGate.service.js

Purpose:

Prevent invalid transitions.

Before navigation.

Not after.

This later became:

\#\#\# Q7 — Validation must be authoritative before transition

\---

\#\#\#\# runtimeInvalidation.service.js

Purpose:

Prevent stale runtime state.

This solved one of the hardest UX problems:

\> hidden inconsistency.

\---

\#\#\#\# WaitingPage TRUE REVIEW PAGE

Purpose:

Provide confidence-preserving review.

Not loading.

Not delay.

Not temporary UI.

But:

\> meaningful review semantics.

\---

\#\#\# Major conceptual shift

The architecture formally separated:

\> draft state

from:

\> runtime state

leading to:

\#\#\# Q8 — Draft values ≠ runtime state

This became one of the deepest architectural principles of EGAL.

\---

\#\# 2.10 Final Evolution Outcome

The original EGAL vision was:

\> Elder assistance.

The actual EGAL outcome became:

\> Confidence-preserving orchestration architecture.

This distinction matters.

Because future work should not regress EGAL into:

\> “just UX improvements.”

That would undo the central lessons of the project.

EGAL now represents:

\- navigation orchestration

\- lifecycle safety

\- validation authority

\- review semantics

\- confidence preservation

\- guided progression

\- elderly cognitive support

Its evolution was not accidental.

It was:

\> UAT-forced architecture maturation.

\---

\# END OF PART II

# PART III — MAJOR ARCHITECTURE PIVOTS

\---

\#\# 3.1 Introduction

The history of EGAL can be understood as a sequence of:

\> architectural pivots forced by UAT reality.

These pivots were not cosmetic improvements.

Nor were they engineering preferences.

Each pivot emerged because:

\> an earlier mental model stopped matching elderly-user behavior.

In several cases, architecture had to abandon assumptions that were technically reasonable but psychologically incorrect.

This section documents the largest pivots.

Future maintainers should treat them as:

\> protected architectural knowledge.

Because many of these decisions may initially appear unnecessary when viewed only through the final codebase.

Without historical understanding, contributors may unintentionally reintroduce problems that EGAL already solved.

\---

\# 3.2 Pivot \#1  

\# From “Accessibility Styling” → “Confidence Architecture”

\---

\#\# Original Model

At the beginning, accessibility was implicitly framed as:

\> a usability enhancement problem.

The mental model was conventional:

Improve readability.

Improve visibility.

Improve instructions.

Improve feedback.

In practical terms:

The expected solution space looked like:

\- larger text

\- clearer messages

\- more visible buttons

\- simplified interactions

\- audio guidance

This was reasonable.

But incomplete.

\---

\#\# UAT Contradiction

Real elderly-user behavior revealed something unexpected.

Users were not failing because they could not see.

They were failing because:

\> they lacked confidence in what was happening.

Observed patterns included:

\#\#\# Hesitation before progression

Even when actions were valid.

\---

\#\#\# Repeated reviews

Users repeatedly rechecked information.

Even after completion.

\---

\#\#\# Fear of commitment

Users avoided pressing buttons because:

\> “What if this is irreversible?”

\---

\#\#\# Anxiety after navigation

Users felt uncertain after transitions.

Even when technically correct.

\---

The issue became clear:

\> Accessibility was not primarily visual.

It was psychological.

\---

\#\# Architectural Shift

EGAL changed its framing.

From:

\> accessibility support

to:

\> confidence preservation

This pivot fundamentally changed priorities.

The system stopped optimizing only for:

\- efficiency

\- reduced clicks

\- visual simplicity

And started optimizing for:

\- reassurance

\- predictability

\- safe progression

\- recoverability

\---

\#\# Lasting Rule

This pivot later crystallized into a persistent design principle:

\> \*\*Confidence is a system requirement.\*\*

Not a UX bonus.

This principle still governs all later EGAL decisions.

\---

\# 3.3 Pivot \#2  

\# From “Component Autonomy” → “Orchestration Authority”

\---

\#\# Original Model

Initially:

Forms largely controlled themselves.

Each form typically handled:

\- validation

\- navigation

\- transitions

\- state interpretation

The assumption:

\> local ownership is simpler.

Technically:

This reduced coupling.

And felt natural in React architecture.

\---

\#\# UAT Contradiction

Behavior inconsistency emerged quickly.

Observed symptoms:

\#\#\# Different forms behaved differently

JoinClanForm behaved one way.

CreateClanForm behaved another.

RegisterForm behaved differently again.

\---

\#\#\# Navigation semantics drifted

Users experienced inconsistent expectations.

Examples:

Back behavior varied.

Edit behavior varied.

Recovery behavior varied.

\---

\#\#\# Elderly confidence degraded

Predictability matters more than flexibility.

Especially for elderly users.

The problem became:

\> fragmented authority creates cognitive inconsistency.

\---

\#\# Architectural Shift

EGAL centralized orchestration.

This produced one of the most important principles:

\#\#\# Q4 — AuthPage Is Orchestration Root

Meaning:

Child forms may render.

Child forms may validate locally.

But:

\> navigation authority belongs to orchestration.

Not components.

\---

\#\# Why This Matters

This solved:

\#\#\# inconsistent transitions

because navigation logic became centralized.

\---

\#\#\# behavioral drift

because flows now shared orchestration semantics.

\---

\#\#\# fragile coupling

because child forms stopped making lifecycle assumptions.

\---

\#\# Long-Term Implication

Future contributors should resist:

\> reintroducing navigation autonomy into child forms.

Doing so will almost certainly recreate:

\- inconsistent recovery

\- transition drift

\- elder confusion

This is considered:

\> architectural regression.

\---

\# 3.4 Pivot \#3  

\# From “Waiting State” → “TRUE REVIEW PAGE”

\---

\#\# Original Model

WaitingPage originally behaved like:

\> a temporary transition surface.

Essentially:

A loading intermediary.

A passive screen.

A transport state.

Its purpose was assumed to be:

\> wait before completion.

\---

\#\# UAT Contradiction

Real users treated WaitingPage differently.

Unexpected behavior emerged.

Users naturally paused.

Reviewed information.

Looked for confirmation.

Expected edit opportunities.

Asked implicit questions:

\- “Is this correct?”

\- “Can I still fix something?”

\- “Should I continue?”

This revealed a mismatch.

The UI thought:

\> transition

Users thought:

\> verification.

\---

\#\# Architectural Shift

WaitingPage was fundamentally redefined.

It became:

\> \*\*TRUE REVIEW PAGE\*\*

This represented a major semantic change.

WaitingPage was no longer:

\- passive

\- decorative

\- transitional

Instead:

It became:

\> psychologically safe verification space.

\---

\#\# Resulting Rule

\#\#\# Q6 — WaitingPage Is TRUE REVIEW PAGE

Meaning:

The page exists to support:

\#\#\# confidence

\---

\#\#\# verification

\---

\#\#\# editability

\---

\#\#\# safe progression

\---

\#\# Consequence

Multiple architectural behaviors changed.

\#\#\# Edit became first-class

Not fallback.

\---

\#\#\# Navigation semantics changed

Return-to-edit became meaningful.

\---

\#\#\# Lifecycle safety became necessary

Because review required runtime correctness.

\---

\#\# Long-Term Implication

Future refactors must never downgrade WaitingPage into:

\> a spinner page.

That would directly violate:

\> elderly confidence architecture.

\---

\# 3.5 Pivot \#4  

\# From “Validation After Action” → “Validation Authority Before Transition”

\---

\#\# Original Model

Initially:

Validation frequently behaved reactively.

Example pattern:

User progresses  

↓  

Transition occurs  

↓  

Validation appears

This pattern is common in modern SPAs.

Technically:

Nothing was wrong.

\---

\#\# UAT Contradiction

Elderly users reacted poorly.

Observed behavior:

Users became confused when:

A page transition occurred.

Then an error appeared.

This created emotional uncertainty.

Users interpreted it as:

\> “Something unexpected happened.”

Or worse:

\> “Maybe I broke something.”

\---

\#\# Architectural Shift

Validation moved earlier.

Meaning:

\> validation must happen before transition.

Not after.

This produced:

\#\#\# validationGate.service.js

Its role:

Create authoritative transition rules.

\---

\#\# Resulting Rule

\#\#\# Q7 — Validation Must Be Authoritative Before Transition

This principle became foundational.

Transitions should feel:

\> deserved

not surprising.

\---

\#\# Long-Term Benefit

This dramatically improved:

\- trust

\- confidence

\- predictability

Especially for elderly users.

\---

\# 3.6 Pivot \#5  

\# From “React State Correctness” → “Lifecycle Correctness”

\---

\#\# Original Model

Early assumptions followed common frontend thinking:

\> if state is technically correct, UX is correct.

This assumption works in many systems.

But failed repeatedly in EGAL.

\---

\#\# UAT Contradiction

Hidden inconsistency emerged.

Example:

User edits data.

Returns from review.

Unexpected values remain.

Or validation behaves unexpectedly.

Technically:

React state still worked.

Psychologically:

Users lost trust.

\---

\#\# Architectural Insight

A profound realization emerged:

\> technical correctness ≠ cognitive correctness

Meaning:

Users care about:

\> perceived consistency.

Not implementation details.

\---

\#\# Architectural Shift

EGAL introduced:

\#\#\# navigationLifecycle.service.js

To formalize transition semantics.

\---

\#\#\# runtimeInvalidation.service.js

To prevent stale runtime state.

\---

\#\#\# lifecycle-safe flows

To ensure predictable recovery.

\---

\#\# Resulting Principle

\#\#\# Q8 — Draft Values ≠ Runtime State

This became one of the deepest EGAL rules.

Why?

Because stale draft state created:

\> false continuity.

Which elderly users perceived as inconsistency.

\---

\#\# Long-Term Implication

Future contributors should avoid:

\> assuming local component state is authoritative.

Lifecycle correctness is now:

\> system-level responsibility.

\---

\# 3.7 Pivot \#6  

\# From “Attention Placement” → “Attention Orchestration”

\---

\#\# Original Model

Originally:

Attention was treated visually.

Example solutions:

\- move messages higher

\- scroll screen

\- reposition UI

\---

\#\# UAT Contradiction

Attention loss persisted.

Users still:

\- missed messages

\- forgot context

\- became disoriented

Especially after interruptions.

\---

\#\# Architectural Shift

Attention became orchestrated.

Introducing:

\#\#\# AttentionZone

Explicit focus region.

\---

\#\#\# attentionOrchestrator

Coordinated focus behavior.

\---

\#\#\# guidedProgressionService

Managed guided movement.

\---

\#\#\# lastAttentionMessage recovery

Restored continuity.

\---

\#\# Architectural Insight

Attention is:

\> recoverable state.

Not merely layout.

This became one of EGAL’s most unique discoveries.

\---

\# 3.8 Pivot \#7  

\# From “Feature Additions” → “Layered Architecture”

\---

\#\# Original Model

Initially:

EGAL was expected to be:

\> a set of enhancements.

Meaning:

Individual features added incrementally.

\---

\#\# UAT Contradiction

Feature accumulation produced coupling.

Problems began crossing boundaries:

\- navigation

\- lifecycle

\- validation

\- review

\- attention

Simple patches no longer worked.

\---

\#\# Architectural Shift

EGAL matured into:

\> \*\*layered architecture\*\*

\#\#\# Guidance Layer

Voice and guidance.

\---

\#\#\# Attention Layer

Attention orchestration.

\---

\#\#\# Validation Layer

Transition safety.

\---

\#\#\# Lifecycle Layer

State predictability.

\---

\#\#\# Review Layer

WaitingPage semantics.

\---

\#\#\# Orchestration Layer

AuthPage authority.

\---

\#\# Why This Was Necessary

Layering prevented:

\> chaotic coupling.

And preserved:

\#\#\# business flow integrity

while enabling:

\#\#\# accessibility evolution

without regressions.

\---

\# 3.9 Architecture Pivot Summary

EGAL ultimately transformed:

| Original Assumption | Final Architecture |

|---|---|

| Accessibility styling | Confidence architecture |

| Component autonomy | Orchestration authority |

| Waiting screen | TRUE REVIEW PAGE |

| Reactive validation | Authoritative pre-transition validation |

| React correctness | Lifecycle correctness |

| Visual attention | Attention orchestration |

| Feature additions | Layered architecture |

\---

\#\# 3.10 PART III Conclusion

The major lesson of EGAL architecture is simple:

\> elderly UX problems are rarely solved at the component level.

They usually emerge from:

\> interaction systems.

EGAL matured because it repeatedly accepted an uncomfortable truth:

\> technically correct systems can still feel unsafe.

And for elderly users:

Feeling unsafe often means:

\> abandonment.

The architecture therefore evolved toward one overriding objective:

\> \*\*preserving confidence without breaking business correctness.\*\*

Every major pivot in EGAL ultimately served that goal.

\---

## \# END OF PART III

# PART IV — SPRINT CHRONICLE (EGAL-6.1 → EGAL-6.5)

\---

\#\# 4.1 Introduction

This section documents the historical progression of EGAL through the major sprint series:

\> EGAL-6.1 → EGAL-6.5

Unlike a conventional changelog, this is:

\> an architectural chronicle.

Meaning:

The purpose is not merely to list features.

The purpose is to explain:

\#\#\# why changes happened

\#\#\# what UAT exposed

\#\#\# what assumptions failed

\#\#\# why architecture evolved

\#\#\# what future maintainers must preserve

This distinction matters.

Because many EGAL decisions only make sense when viewed through:

\> the problems they replaced.

A contributor reading only the final implementation may mistakenly conclude:

\> “This seems overengineered.”

In reality:

Most of EGAL complexity emerged from:

\> repeated elderly-user failure patterns.

Therefore:

Every sprint below should be interpreted as:

\> architecture under pressure from reality.

\---

\# 4.2 EGAL-6.1  

\# The Attention Recovery Sprint

\---

\#\# Sprint Objective

The initial goal of EGAL-6.1 was relatively modest:

\> improve elderly awareness of system feedback.

At this stage, the system already worked functionally.

Authentication succeeded.

Form submission succeeded.

Validation existed.

Business flow integrity already existed.

The perceived problem was:

\> elderly users were missing important information.

The working assumption was:

\> message visibility is insufficient.

Therefore:

The sprint initially focused on:

\> feedback presentation.

\---

\#\# Major Symptoms Observed in UAT

UAT uncovered several recurring patterns.

\---

\#\#\# Symptom A — Users missed critical messages

Validation messages appeared.

But users often failed to notice them.

Especially when:

\- positioned below fold

\- outside visual focus

\- hidden by scroll position

This created confusion.

Users interpreted missing feedback as:

\> system uncertainty.

Not:

\> user oversight.

This distinction mattered psychologically.

\---

\#\#\# Symptom B — Success lacked closure

After successful actions:

Users frequently hesitated.

Observed behavior included:

\- waiting unnecessarily

\- re-clicking buttons

\- asking whether completion occurred

\- uncertainty after transition

The system technically succeeded.

But psychologically:

\> the action felt incomplete.

\---

\#\#\# Symptom C — Attention drift

Elderly users naturally focused around:

\> screen center.

Important messaging outside that zone frequently failed.

This was especially problematic on:

\- mobile screens

\- vertically long forms

\- transition pages

\---

\#\# Initial Hypothesis

The team initially believed:

\> small UX adjustments would solve the problem.

Expected solution space:

\- reposition messages

\- improve spacing

\- add visual emphasis

\- reduce clutter

This proved insufficient.

\---

\#\# Major Implementation Changes

\#\#\# WaitingPage Message Instead of Alert

One of the first meaningful pivots emerged here.

Traditional alerts created several problems:

\#\#\#\# abrupt interruption

Alerts felt aggressive.

\---

\#\#\#\# cognitive discontinuity

Users lost context.

\---

\#\#\#\# emotional discomfort

Elderly users perceived alerts as:

\> warnings

even when informational.

\---

\#\#\# Why WaitingPage Messaging Was Introduced

The architecture experimented with:

\> contextual feedback.

Instead of interrupting flow.

The idea:

Keep users inside:

\> narrative continuity.

Meaning:

The system should feel like:

\> guidance

not interruption.

This was one of the earliest seeds of:

\> confidence architecture.

Although not yet formally recognized.

\---

\#\#\# ResultPage Attention Centering

This became another important discovery.

UAT consistently showed:

Elderly users focus visually around:

\> center attention zone.

Meaning:

Messages placed elsewhere had lower recognition probability.

The solution:

\> force important outcomes into central attention.

This significantly improved:

\- recognition

\- completion confidence

\- emotional closure

\---

\#\#\# Guided Attention Improvements

EGAL-6.1 also began experimenting with:

\> guided attention behavior.

The underlying realization:

Traditional interfaces assume:

\> user initiative.

Elderly UX often cannot.

Instead:

The interface must gently guide attention.

This idea would later evolve into:

\- AttentionZone

\- attentionOrchestrator

\- guided progression

\---

\#\# UAT Outcome

\#\#\# What improved

Users recognized outcomes better.

Validation visibility improved.

Success recognition improved.

Confusion decreased.

\---

\#\#\# What still failed

Users still experienced:

\> navigation uncertainty.

And:

\> confidence hesitation.

Meaning:

Visibility alone was not enough.

\---

\#\# Architecture Lesson

EGAL-6.1 introduced the first major discovery:

\> attention problems are orchestration problems.

Not styling problems.

This lesson fundamentally changed the direction of EGAL.

\---

\# 4.3 EGAL-6.2  

\# The Guided Confidence Sprint

\---

\#\# Sprint Objective

Following EGAL-6.1:

The next assumption was:

\> users simply need more help understanding actions.

Therefore:

EGAL-6.2 focused on:

\> guided assistance.

The sprint goal became:

\> reduce confusion through proactive support.

\---

\#\# Primary Design Hypothesis

The team believed:

If elderly users receive:

\- clearer instructions

\- audible guidance

\- interaction assistance

Then:

confidence problems would largely disappear.

This assumption appeared reasonable.

But proved only partially true.

\---

\#\# Major Implementation Changes

\#\#\# Single Elder Assistance Mode

A dedicated assistance experience was introduced.

Purpose:

Reduce interface complexity.

Create:

\> calmer interaction flow.

The philosophy:

Avoid overwhelming users.

Especially during:

\- authentication

\- registration

\- clan joining

\- clan creation

\---

\#\#\# ElderAssistButton

This introduced:

\> explicit help invocation.

Rather than forcing users to guess.

Why?

Because elderly users often hesitate to experiment.

A visible helper mechanism created:

\> psychological permission to continue.

This was subtle.

But important.

\---

\#\#\# TTS Provider Integration (V24.2.0)

Voice guidance represented a major step.

The assumption:

Audio reinforcement could reduce:

\- confusion

\- missed messages

\- hesitation

This significantly helped.

Especially in:

\- validation awareness

\- instruction comprehension

\- step progression

\---

\#\#\# AuthPage/HomePage Guidance Patch

Guided assistance was integrated into orchestration surfaces.

Why?

Because entry points strongly influence:

\> confidence trajectory.

A confusing start creates:

\> downstream anxiety.

This became a recurring EGAL lesson.

\---

\#\# UAT Findings

Voice guidance helped substantially.

But UAT revealed a deeper issue.

Users still hesitated.

Even after understanding instructions.

This exposed something unexpected:

\> comprehension ≠ confidence

Users understood.

But still feared progression.

Observed hesitation included:

\#\#\# fear of irreversible action

\---

\#\#\# fear of losing entered data

\---

\#\#\# uncertainty about returning

\---

\#\#\# distrust of transitions

\---

This became a major realization.

\---

\#\# Architecture Lesson

The problem was no longer:

\> explanation.

The problem became:

\> behavioral predictability.

Meaning:

Users needed to trust:

\> what the system would do next.

This insight directly set up:

EGAL-6.3 and beyond.

\---

\# 4.4 EGAL-6.3  

\# The Attention Orchestration Sprint

\---

\#\# Sprint Objective

By EGAL-6.2:

The system could guide users.

But:

Guidance still failed after interruptions.

The sprint goal became:

\> restore and preserve attention continuity.

This marked a major maturity step.

Because attention was no longer treated as:

\> visual placement.

It became:

\> behavioral state.

\---

\#\# Problems Observed in UAT

Users frequently lost context after:

\- pause

\- distraction

\- revisiting flow

\- waiting states

\- message interruption

This produced:

\#\#\# confusion

\---

\#\#\# restart behavior

\---

\#\#\# forgotten instructions

\---

\#\#\# emotional hesitation

\---

The challenge became:

\> how to preserve continuity.

\---

\#\# Major Implementation Changes

\#\#\# AttentionZone

Introduced explicit attention anchors.

Purpose:

Help users know:

\> where to focus.

This reduced:

\> wandering attention.

\---

\#\#\# attentionOrchestrator

One of the first real orchestration services.

Purpose:

Coordinate attention centrally.

Instead of:

scattered component logic.

This marked a major architecture maturation moment.

\---

\#\#\# guidedProgressionService

Progression became:

\> guided

not merely available.

Meaning:

The system increasingly behaved like:

\> a guide

rather than:

\> a passive form renderer.

This distinction would later become central to EGAL identity.

\---

\#\#\# lastAttentionMessage Recovery

An unexpectedly powerful feature.

Why?

Because elderly users benefit strongly from:

\> restored context.

Instead of requiring memory recall.

This significantly reduced:

\> disorientation after interruption.

\---

\#\# UAT Findings

Attention continuity improved dramatically.

Users resumed tasks more confidently.

Recovery behavior improved.

However:

A new category of issues emerged.

\---

\#\# New Problem Discovered

Users returning from edit flows experienced:

\> inconsistent runtime behavior.

Example:

Edit → Return → Unexpected progression state.

This created:

\> trust degradation.

The problem had shifted.

Again.

\---

\#\# Architecture Lesson

Attention continuity alone was insufficient.

The system now needed:

\> lifecycle consistency.

This realization directly triggered:

EGAL-6.4 → EGAL-6.5 evolution.

\---

\# 4.5 EGAL-6.4  

\# The Guided Flow Integrity Sprint

\---

\#\# Sprint Objective

EGAL-6.4 focused on:

\> guided progression integration into real flows.

Specifically:

\- JoinClanForm

\- CreateClanForm

\- WaitingPage

The objective:

Create:

\> consistent guided experiences.

Across forms.

\---

\#\# Problem Observed

Prior behavior remained fragmented.

Different forms:

behaved differently.

This produced:

\#\#\# expectation mismatch

\---

\#\#\# confidence erosion

\---

\#\#\# navigation confusion

\---

Especially when:

moving between forms.

\---

\#\# Major Implementation Changes

\#\#\# JoinClanForm Guided Progression

Integrated guided flow.

Goal:

Reduce uncertainty during clan joining.

\---

\#\#\# CreateClanForm Guided Progression

Same philosophy.

But exposed deeper issues.

Because creation flows are:

\> psychologically riskier.

Users feared:

\> making mistakes.

More than joining.

\---

\#\#\# WaitingPage Integration

WaitingPage became more meaningful.

Although not yet fully evolved into:

TRUE REVIEW PAGE.

The seeds emerged here.

Users naturally paused to review.

\---

\#\# UAT Findings

Guided progression helped.

But severe lifecycle problems remained.

Examples:

\#\#\# stale validation

\---

\#\#\# return inconsistency

\---

\#\#\# edit state mismatch

\---

\#\#\# hidden runtime assumptions

\---

This became:

\> the biggest architecture blocker so far.

\---

\#\# Architecture Lesson

Component-level fixes had reached their limit.

The problem had become:

\> systemic.

Meaning:

Architecture had to mature.

Not patch.

\---

\# 4.6 EGAL-6.5  

\# The Lifecycle Safety Sprint

\---

\#\# Sprint Objective

EGAL-6.5 became:

\> the stabilization revolution.

Its mission:

Eliminate lifecycle inconsistency.

Restore trust.

Preserve confidence.

This sprint fundamentally changed EGAL maturity.

\---

\#\# Primary UAT Failures

Repeated failures exposed:

\#\#\# stale validation

Users edited data.

But validation persisted incorrectly.

\---

\#\#\# broken edit return

WaitingPage → Edit created confusion.

\---

\#\#\# runtime inconsistency

Unexpected behavior appeared.

Even though data was technically valid.

\---

\#\#\# navigation unpredictability

Users no longer trusted progression.

This became critical.

Because:

\> trust loss \= abandonment risk.

\---

\#\# Major Architecture Changes

\#\#\# navigationLifecycle.service.js

Formalized lifecycle behavior.

Navigation became:

\> structured.

Not emergent.

\---

\#\#\# validationGate.service.js

Validation became:

\> authoritative before transition.

This later formalized:

\#\#\# Q7

\---

\#\#\# runtimeInvalidation.service.js

One of the deepest fixes.

Purpose:

Prevent stale runtime behavior.

This solved many hidden trust issues.

\---

\#\#\# WaitingPage TRUE REVIEW PAGE

The single biggest semantic shift.

WaitingPage stopped being:

\> passive transport

and became:

\> confidence-preserving verification space.

This formalized:

\#\#\# Q6

\---

\#\#\# Lifecycle-safe JoinClanForm

\---

\#\#\# Lifecycle-safe CreateClanForm

\---

\#\#\# AuthPage lifecycle orchestration

Formalizing:

\#\#\# Q4 — AuthPage is orchestration root

\---

\#\# UAT Outcome

\#\#\# JoinClanForm

PASS

\- stale validation fixed

\- WaitingPage → Edit fixed

\- redundant navigation removed

\---

\#\#\# CreateClanForm

PASS

\- lifecycle-safe

\- attention reset fixed

\- edit confidence restored

\---

\#\#\# RegisterForm

PASS

\- integration validated

\- lifecycleContext pass-through confirmed

\- semantics preserved

\---

\#\# Sprint Outcome

EGAL-6.5 marked:

\> transition from enhancement system

to:

\> mature orchestration architecture.

\---

\#\# 4.7 Sprint Chronicle Conclusion

The journey from:

EGAL-6.1 → EGAL-6.5

revealed a repeating truth:

\> every solved UX problem uncovered a deeper architecture problem.

The system evolved through:

\#\#\# attention

→ guidance

→ orchestration

→ flow integrity

→ lifecycle safety

By EGAL-6.5:

EGAL had matured into:

\> a confidence-preserving architecture for elderly interaction systems.

And importantly:

without breaking:

\> existing business correctness.

This achievement remains one of the defining characteristics of EGAL.

\---

## \# END OF PART IV

# PART V — UAT-DRIVEN DISCOVERIES

\---

\#\# 5.1 Introduction

One of the most important truths about EGAL is this:

\> EGAL was not architected from theory.

It was architected from:

\> repeated UAT confrontation with reality.

This distinction matters.

Many systems are designed based on:

\- engineering intuition

\- UX best practices

\- frontend conventions

\- developer assumptions

EGAL repeatedly discovered that:

\> elderly-user reality violated many conventional assumptions.

Some of the most important architectural decisions emerged not because they were elegant.

But because:

\> UAT forced them.

This section documents the major discoveries extracted from repeated elderly-user observation.

These discoveries should be treated as:

\> preserved architectural knowledge.

Because future contributors who ignore them may accidentally recreate previously solved failures.

\---

\# 5.2 Discovery \#1  

\# Elderly Users Fear Uncertainty More Than Complexity

\---

\#\# Original Assumption

Early thinking assumed:

\> complexity is the biggest barrier.

Meaning:

If the interface becomes simpler:

then elderly usability improves.

This assumption drove initial ideas such as:

\- fewer steps

\- simplified layouts

\- minimal controls

\- reduced choices

\---

\#\# What UAT Revealed

Reality proved more nuanced.

Users were often capable of handling complexity.

Provided:

\> they understood what was happening.

The larger problem was:

\> uncertainty.

Observed behaviors included:

\#\#\# hesitation before buttons

Even after instructions.

\---

\#\#\# repeated checking

Even after validation success.

\---

\#\#\# reluctance to continue

Even when the next step was obvious.

\---

\#\#\# emotional caution

Especially around family data.

\---

The issue was not:

\> “This is too complicated.”

The issue was:

\> “I am afraid I might do something wrong.”

This distinction fundamentally changed EGAL priorities.

\---

\#\# Architectural Consequence

The system shifted toward:

\> confidence preservation.

Meaning:

Better reassurance.

Safer progression.

Predictable recovery.

Review opportunities.

Psychological reversibility.

This discovery ultimately influenced:

\- WaitingPage redesign

\- lifecycle safety

\- guided progression

\- validation authority

\---

\#\# Long-Term Principle

Future contributors should remember:

\> reducing complexity alone is insufficient.

Confidence matters more.

\---

\# 5.3 Discovery \#2  

\# Understanding ≠ Confidence

\---

\#\# Original Assumption

The team initially believed:

If users understand instructions:

then confusion disappears.

This assumption drove:

\- clearer text

\- audio guidance

\- TTS integration

\- ElderAssist

\---

\#\# What UAT Revealed

Users often understood perfectly.

Yet still hesitated.

Observed behavior:

A user correctly understood:

what to do.

But still avoided proceeding.

Why?

Because understanding does not answer:

\> “Will this still be safe?”

Or:

\> “Can I recover?”

\---

\#\# Example Pattern

User fills information correctly.

User pauses.

Reads again.

Waits.

Sometimes abandons.

Not because:

they do not understand.

But because:

\> they do not trust the transition.

\---

\#\# Architectural Consequence

EGAL learned:

\> guidance alone is insufficient.

The system must also provide:

\#\#\# predictability

\---

\#\#\# reassurance

\---

\#\#\# recoverability

\---

\#\#\# visible safety

\---

This discovery directly contributed to:

\- TRUE REVIEW PAGE

\- lifecycle-safe navigation

\- validation-before-transition

\---

\#\# Long-Term Principle

Never assume:

\> instruction clarity solves confidence problems.

It does not.

\---

\# 5.4 Discovery \#3  

\# Elderly Users Need Psychological Reversibility

\---

\#\# Original Assumption

Traditional UX assumes:

Users feel comfortable proceeding.

Because:

\> back buttons exist.

Meaning:

Reversibility is technically available.

\---

\#\# What UAT Revealed

Elderly users often do not think technically.

They think emotionally.

The concern becomes:

\> “What if I cannot undo this?”

Even when undo technically exists.

Observed behavior:

Users delayed progression.

Repeated reviews.

Avoided commitment.

Especially during:

\- clan creation

\- registration

\- family data submission

\---

\#\# Architectural Insight

The system must create:

\> felt reversibility

Not merely:

\> technical reversibility.

Meaning:

Users must psychologically feel safe.

\---

\#\# Architectural Consequence

WaitingPage evolved.

Edit became first-class.

Review semantics strengthened.

Navigation behavior became safer.

This directly produced:

\#\#\# Q6 — WaitingPage Is TRUE REVIEW PAGE

\---

\#\# Long-Term Principle

Reversibility must be:

\> emotionally visible.

Not merely technically implemented.

\---

\# 5.5 Discovery \#4  

\# Attention Is a State, Not a Position

\---

\#\# Original Assumption

Initially:

Attention problems were interpreted visually.

Meaning:

Move content higher.

Center messages.

Improve visibility.

\---

\#\# What UAT Revealed

Problems persisted.

Even after positioning improved.

Users still:

\- forgot instructions

\- lost context

\- missed meaning

\- resumed incorrectly after interruption

The issue became:

\> attention continuity.

Not placement.

\---

\#\# Example Pattern

User receives instruction.

Gets interrupted.

Returns later.

No longer remembers context.

The interface assumed:

memory continuity.

Reality:

Memory continuity failed.

\---

\#\# Architectural Consequence

Attention became orchestrated.

Introducing:

\- AttentionZone

\- attentionOrchestrator

\- guided progression

\- lastAttentionMessage recovery

This was a major conceptual shift.

Attention became:

\> recoverable state.

\---

\#\# Long-Term Principle

Future systems should not treat attention as:

\> UI layout.

It is:

\> behavioral continuity.

\---

\# 5.6 Discovery \#5  

\# Elderly Users Interpret Unexpected Behavior as Failure

\---

\#\# Original Assumption

Modern frontend systems tolerate:

minor behavioral inconsistency.

Developers often assume:

If technically correct:

then acceptable.

\---

\#\# What UAT Revealed

Unexpected behavior produced disproportionate distrust.

Examples:

Unexpected return state.

Unexpected validation result.

Unexpected transition.

Unexpected retained data.

Even when technically valid.

Users interpreted this as:

\> system malfunction.

Not:

\> normal behavior.

\---

\#\# Example

Edit → Return

Unexpected progression state appears.

Developer view:

\> still valid.

User view:

\> something broke.

This gap became critical.

\---

\#\# Architectural Consequence

Lifecycle correctness became essential.

Leading to:

\- navigationLifecycle.service.js

\- runtimeInvalidation.service.js

\- lifecycle-safe forms

This discovery became one of EGAL’s deepest lessons.

\---

\#\# Long-Term Principle

For elderly UX:

\> predictability matters more than technical elegance.

\---

\# 5.7 Discovery \#6  

\# Validation After Transition Feels Punitive

\---

\#\# Original Assumption

Validation after progression is common UX.

User proceeds.

System checks.

Errors appear.

Technically acceptable.

\---

\#\# What UAT Revealed

Elderly users interpreted this poorly.

Observed reactions:

Confusion.

Hesitation.

Anxiety.

Users felt:

\> “Something unexpected happened.”

Or worse:

\> “Maybe I made a serious mistake.”

The emotional interpretation mattered.

\---

\#\# Architectural Consequence

Validation moved earlier.

Meaning:

\> validation before transition.

This directly created:

\#\#\# validationGate.service.js

And formalized:

\#\#\# Q7

\---

\#\# Long-Term Principle

Validation should feel:

\> protective

not punitive.

\---

\# 5.8 Discovery \#7  

\# Users Trust Review More Than Submission

\---

\#\# Original Assumption

Waiting states are temporary.

Users want speed.

Fast completion preferred.

\---

\#\# What UAT Revealed

Elderly users naturally paused.

Reviewed.

Double checked.

Looked for reassurance.

Review moments created:

\> confidence.

Submission moments created:

\> anxiety.

This was unexpected.

\---

\#\# Architectural Consequence

WaitingPage fundamentally changed semantics.

From:

\> transport state

to:

\> trust-building space

This became one of the most important EGAL pivots.

\---

\#\# Long-Term Principle

Review is not friction.

For elderly users:

\> review is reassurance.

\---

\# 5.9 Discovery \#8  

\# Consistency Across Forms Matters More Than Local Optimization

\---

\#\# Original Assumption

Each form could optimize independently.

JoinClanForm logic.

CreateClanForm logic.

RegisterForm logic.

Component autonomy seemed beneficial.

\---

\#\# What UAT Revealed

Behavior inconsistency confused users.

Examples:

Different back behavior.

Different edit behavior.

Different progression semantics.

Users do not think in components.

They think:

\> “How does this system behave?”

Inconsistency damaged trust.

\---

\#\# Architectural Consequence

Navigation centralized.

Leading to:

\#\#\# Q4 — AuthPage Is Orchestration Root

Consistency became prioritized over local optimization.

\---

\#\# Long-Term Principle

System-level predictability beats component-level cleverness.

\---

\# 5.10 Discovery \#9  

\# Business Correctness Alone Is Not Success

\---

\#\# Original Assumption

If business flow succeeds:

UX is acceptable.

This is common engineering thinking.

\---

\#\# What UAT Revealed

Technically successful flows still failed emotionally.

Examples:

Submission succeeded.

User still unsure.

Validation correct.

User still confused.

Navigation valid.

User still distrustful.

This created a major realization:

\> functional correctness ≠ experiential correctness

\---

\#\# Architectural Consequence

EGAL evolved from:

\> enhancement layer

to:

\> confidence architecture

\---

\#\# Long-Term Principle

Success criteria must include:

\#\#\# emotional clarity

\---

\#\#\# confidence

\---

\#\#\# predictability

\---

\#\#\# recovery confidence

Not merely:

\> successful API outcomes.

\---

\# 5.11 Discovery \#10  

\# UAT Is the Real Architect

\---

\#\# Original Assumption

Architecture could be planned upfront.

Reality disagreed.

Repeatedly.

Many elegant ideas failed.

Many unexpected behaviors succeeded.

The strongest decisions emerged from:

\> observation.

Not intuition.

\---

\#\# Architectural Consequence

EGAL adopted:

\> UAT-first architecture

Meaning:

A solution is not accepted because:

\> developers like it.

It survives because:

\> elderly users succeed with it.

\---

\#\# Long-Term Principle

When theory and UAT disagree:

\> UAT wins.

Always.

\---

\# 5.12 UAT Discovery Summary

The following table summarizes the major discoveries.

| Discovery | Architectural Impact |

|---|---|

| Uncertainty hurts more than complexity | Confidence architecture |

| Understanding ≠ confidence | Guided reassurance |

| Psychological reversibility matters | TRUE REVIEW PAGE |

| Attention is recoverable state | Attention orchestration |

| Unexpected behavior feels like failure | Lifecycle safety |

| Validation after transition feels punitive | Validation authority |

| Review builds trust | WaitingPage redesign |

| Consistency beats local optimization | AuthPage orchestration |

| Business correctness is insufficient | Confidence metrics |

| UAT beats intuition | UAT-first architecture |

\---

\#\# 5.13 PART V Conclusion

Perhaps the single biggest lesson of EGAL is this:

\> elderly interaction problems are often psychological before technical.

Users rarely abandoned because:

\> the system literally failed.

They abandoned because:

\> the interaction felt unsafe.

EGAL matured because it repeatedly chose:

\> confidence over elegance

\> predictability over cleverness

\> reassurance over speed

And ultimately:

\> reality over theory.

These discoveries remain among the most valuable long-term assets of the project.

\---

## \# END OF PART V

# PART VI — DESIGN DOCTRINES  

(Q1/Q2 \+ ARCHITECTURAL PRINCIPLES)

\---

\#\# 6.1 Introduction

By EGAL-6.5, repeated UAT had revealed a critical reality:

\> architectural success depended on disciplined consistency.

Without shared rules:

Small “harmless” improvements frequently caused:

\- behavioral drift

\- lifecycle regressions

\- confidence erosion

\- navigation inconsistency

Many failed approaches were technically reasonable.

But psychologically damaging.

Therefore:

EGAL formalized a doctrine system.

These doctrines are not:

\> suggestions.

They are:

\> preserved architectural constraints.

Their purpose is to protect:

\#\#\# confidence preservation

\#\#\# business integrity

\#\#\# elderly predictability

\#\#\# long-term maintainability

Future contributors should treat these doctrines as:

\> constitutional architecture.

Violating them may not immediately break the system.

But will likely reintroduce:

\> elderly confusion patterns already solved by EGAL.

\---

\# 6.2 Doctrine Philosophy

EGAL design doctrine follows a fundamental belief:

\> technically correct systems can still fail elderly users.

Therefore:

Architecture decisions are evaluated through four lenses:

\#\#\# Business Correctness

Does the flow still work?

\---

\#\#\# Confidence Preservation

Does the interaction feel safe?

\---

\#\#\# Predictability

Can users anticipate behavior?

\---

\#\#\# Recoverability

Can users confidently recover mistakes?

\---

A change that improves engineering elegance but damages these criteria:

\> is considered regression.

\---

\# 6.3 Q1 Doctrine  

\# Do Not Break Working Business Flow

\---

\#\# Statement

\> \*\*Q1 — Do not break business flow/UI that already works.\*\*

\---

\#\# Why This Exists

The genealogy system was already:

\> functionally correct.

Before EGAL.

Examples:

\- authentication worked

\- registration worked

\- clan joining worked

\- clan creation worked

The problem was:

\> elderly interaction confidence.

Not business correctness.

Therefore:

EGAL architecture intentionally avoided:

\> replacement architecture.

Instead:

It adopted:

\> layered enhancement.

\---

\#\# Architectural Meaning

EGAL must:

\> wrap

not:

\> replace

existing business flow.

Accessibility should enhance.

Not rewrite.

\---

\#\# Allowed Behavior

\#\#\# Add orchestration

✓

\---

\#\#\# Add guidance

✓

\---

\#\#\# Improve review semantics

✓

\---

\#\#\# Improve recovery behavior

✓

\---

\#\#\# Add lifecycle safety

✓

\---

\#\# Forbidden Behavior

\#\#\# Rewriting stable flow without necessity

✗

\---

\#\#\# Refactoring proven logic “for cleanliness”

✗

\---

\#\#\# Replacing business semantics

✗

\---

\#\#\# Breaking user expectation continuity

✗

\---

\#\# Anti-Pattern Example

Bad:

\> “We can simplify by rebuilding RegisterForm flow.”

Even if elegant.

Because:

it risks regression.

Preferred:

\> patch anchor-level.

Preserve semantics.

Improve confidence.

\---

\#\# Long-Term Rule

Future contributors should ask:

\> “Can we preserve the existing business behavior?”

before:

\> “Can we redesign this?”

\---

\# 6.4 Q2 Doctrine  

\# Preserve Existing UX/UI Unless Explicitly Modified

\---

\#\# Statement

\> \*\*Q2 — Preserve UX/UI unless intentionally changed.\*\*

\---

\#\# Why This Exists

UAT revealed:

Elderly users rely heavily on:

\> habit formation.

Even small changes create confusion.

Unexpected layout shifts reduce confidence.

Examples:

\- button moved

\- message relocated

\- step behavior changed

\- interaction timing changed

Even improvements can feel disruptive.

\---

\#\# Architectural Meaning

Consistency itself is:

\> an accessibility feature.

\---

\#\# Allowed Behavior

\#\#\# Intentional improvements

✓

\---

\#\#\# Guided enhancement

✓

\---

\#\#\# Explicitly approved changes

✓

\---

\#\# Forbidden Behavior

\#\#\# Incidental UI drift

✗

\---

\#\#\# “Small cleanup” altering user habit

✗

\---

\#\#\# Unnecessary visual redesign

✗

\---

\#\# Anti-Pattern Example

Bad:

\> “This button looks better here.”

If:

user expectation breaks.

Preferred:

\> preserve habit.

Improve behavior behind the scenes.

\---

\#\# Long-Term Rule

EGAL values:

\> familiarity over novelty.

\---

\# 6.5 Q3 Doctrine  

\# Prefer Anchor-Level Patch Over Large Refactor

\---

\#\# Statement

\> \*\*Q3 — Prefer anchor-level patching. Avoid unnecessary refactor.\*\*

\---

\#\# Why This Exists

EGAL repeatedly discovered:

Large refactors created:

\> invisible regressions.

Even when intentions were good.

Small lifecycle assumptions broke.

Behavior drift emerged.

\---

\#\# Architectural Meaning

Prefer:

\> targeted fixes.

Not:

\> sweeping rewrites.

Especially in:

\- authentication

\- registration

\- clan flows

\- navigation orchestration

\---

\#\# Allowed Behavior

\#\#\# Small contained patch

✓

\---

\#\#\# Local lifecycle fix

✓

\---

\#\#\# Surgical improvement

✓

\---

\#\# Forbidden Behavior

\#\#\# “Clean rewrite”

✗

\---

\#\#\# Refactor for aesthetics only

✗

\---

\#\#\# Cross-cutting redesign without evidence

✗

\---

\#\# Long-Term Rule

EGAL prefers:

\> proven stability

over:

\> theoretical cleanliness.

\---

\# 6.6 Q4 Doctrine  

\# AuthPage Is Orchestration Root

\---

\#\# Statement

\> \*\*Q4 — AuthPage owns orchestration authority.\*\*

\---

\#\# Why This Exists

UAT exposed severe inconsistency when:

forms controlled themselves.

Examples:

JoinClanForm behaved differently.

CreateClanForm behaved differently.

Navigation semantics drifted.

\---

\#\# Architectural Meaning

Child forms may:

\#\#\# render

✓

\---

\#\#\# validate locally

✓

\---

\#\#\# expose state

✓

\---

But:

\#\#\# navigation authority

belongs to:

\> AuthPage

\---

\#\# Why Centralization Matters

Prevents:

\#\#\# inconsistent recovery

\---

\#\#\# transition drift

\---

\#\#\# fragmented lifecycle assumptions

\---

\#\#\# behavioral unpredictability

\---

\#\# Forbidden Behavior

\#\#\# Child forms deciding navigation

✗

\---

\#\#\# Local transition authority

✗

\---

\#\#\# Self-owned progression logic

✗

\---

\#\# Long-Term Rule

If navigation changes:

Ask:

\> “Does AuthPage still remain authoritative?”

If no:

\> reconsider architecture.

\---

\# 6.7 Q5 Doctrine  

\# Child Forms Do Not Own Navigation Authority

\---

\#\# Statement

\> \*\*Q5 — Child forms may inform navigation, not control it.\*\*

\---

\#\# Why This Exists

Closely related to Q4.

UAT proved:

local navigation creates:

\> inconsistent system behavior.

\---

\#\# Architectural Meaning

Child forms should:

\#\#\# emit intent

Example:

\> “ready to continue”

Not:

\> force navigation.

\---

\#\# Good Pattern

Child:

\`\`\`js

onContinue(payload)

\`\`\`

Parent decides:

\`\`\`js

navigate(...)

\`\`\`

\---

\#\# Bad Pattern

Child:

\`\`\`js

navigate("/next")

\`\`\`

This bypasses orchestration.

\---

\#\# Long-Term Rule

Child forms are:

\> participants.

Not orchestrators.

\---

\# 6.8 Q6 Doctrine  

\# WaitingPage Is TRUE REVIEW PAGE

\---

\#\# Statement

\> \*\*Q6 — WaitingPage exists for review, not waiting.\*\*

\---

\#\# Why This Exists

One of the strongest UAT discoveries.

Users naturally treated WaitingPage as:

\> verification space.

Not transition space.

\---

\#\# Architectural Meaning

WaitingPage supports:

\#\#\# reassurance

\---

\#\#\# verification

\---

\#\#\# editability

\---

\#\#\# safe progression

\---

It is:

\> psychologically meaningful.

\---

\#\# Forbidden Interpretation

WaitingPage is NOT:

\#\#\# spinner

✗

\---

\#\#\# transport state

✗

\---

\#\#\# temporary filler

✗

\---

\#\# Required Behaviors

\#\#\# Edit available

✓

\---

\#\#\# Review clarity

✓

\---

\#\#\# Lifecycle-safe return

✓

\---

\#\#\# Confidence preservation

✓

\---

\#\# Long-Term Rule

Never downgrade WaitingPage semantics.

Doing so violates:

\> core EGAL philosophy.

\---

\# 6.9 Q7 Doctrine  

\# Validation Must Be Authoritative Before Transition

\---

\#\# Statement

\> \*\*Q7 — Validation occurs before navigation.\*\*

\---

\#\# Why This Exists

UAT repeatedly showed:

post-transition validation felt:

\> punitive.

Unexpected.

Unsafe.

\---

\#\# Architectural Meaning

Transitions must feel:

\> deserved.

Never surprising.

\---

\#\# Required Pattern

Validate:

\`\`\`txt

BEFORE

\`\`\`

navigation.

Not:

\`\`\`txt

AFTER

\`\`\`

navigation.

\---

\#\# Architectural Component

\#\#\# validationGate.service.js

Acts as:

\> transition authority.

\---

\#\# Forbidden Behavior

\#\#\# optimistic transition

✗

\---

\#\#\# post-navigation validation

✗

\---

\#\#\# delayed invalidation

✗

\---

\#\# Long-Term Rule

Users should never feel:

\> “Why did the screen suddenly reject me?”

\---

\# 6.10 Q8 Doctrine  

\# Draft Values ≠ Runtime State

\---

\#\# Statement

\> \*\*Q8 — Draft values are not authoritative runtime truth.\*\*

\---

\#\# Why This Exists

One of the deepest EGAL discoveries.

Stale runtime behavior repeatedly caused:

\> trust collapse.

Even when React state was technically valid.

\---

\#\# Architectural Meaning

Draft:

\> editable memory

Runtime:

\> authoritative behavior state

These are:

\> different responsibilities.

\---

\#\# Architectural Components

\#\#\# navigationLifecycle.service.js

\---

\#\#\# runtimeInvalidation.service.js

\---

\#\#\# lifecycle-safe forms

\---

\#\# Forbidden Assumption

Bad:

\> “React state still exists, therefore UX is correct.”

This repeatedly failed UAT.

\---

\#\# Long-Term Rule

Always ask:

\> “Is runtime state still valid?”

Not merely:

\> “Does state exist?”

\---

\# 6.11 Supporting Architecture Principles

Beyond Q1–Q8, several supporting principles emerged.

\---

\#\# Principle A  

\# Confidence Over Speed

Faster is not always better.

If slower interaction increases:

\> confidence

Then:

slower wins.

\---

\#\# Principle B  

\# Predictability Over Cleverness

Elegant surprises are dangerous.

Especially for elderly users.

Prefer:

\> boring consistency.

\---

\#\# Principle C  

\# Review Is Not Friction

Review improves:

\> trust.

WaitingPage exists because of this.

\---

\#\# Principle D  

\# Consistency Beats Local Optimization

System-level predictability matters more than:

\> isolated component cleverness.

\---

\#\# Principle E  

\# UAT Overrides Theory

When theory conflicts with observed behavior:

\> UAT wins.

Always.

\---

\# 6.12 Regression Warning Checklist

Future contributors should stop immediately if a change causes:

\#\#\# navigation inconsistency

\---

\#\#\# broken edit return

\---

\#\#\# unexpected state persistence

\---

\#\#\# changed user habit

\---

\#\#\# reduced reviewability

\---

\#\#\# post-transition validation

\---

\#\#\# child navigation authority

\---

\#\#\# hidden lifecycle coupling

\---

If any appear:

\> architecture regression is likely occurring.

\---

\# 6.13 Design Doctrine Summary

EGAL doctrine exists to preserve:

| Goal | Protection |

|---|---|

| Business safety | Q1 |

| Familiarity | Q2 |

| Stability | Q3 |

| Central orchestration | Q4 |

| Navigation consistency | Q5 |

| Review confidence | Q6 |

| Predictable validation | Q7 |

| Lifecycle safety | Q8 |

\---

\#\# 6.14 PART VI Conclusion

EGAL design doctrine exists because:

\> elderly confidence is fragile.

Small inconsistencies can create:

\> abandonment.

Therefore:

EGAL intentionally protects:

\#\#\# predictability

\#\#\# reassurance

\#\#\# recoverability

\#\#\# confidence

These doctrines are not bureaucracy.

They are:

\> preserved survival knowledge.

Built through repeated UAT failures.

Future contributors should preserve them carefully.

\---

## \# END OF PART VI

# PART VII — CURRENT TECHNICAL ARCHITECTURE

\---

\#\# 7.1 Introduction

By EGAL-6.5, the system had evolved from:

\> accessibility enhancement

into:

\> layered orchestration architecture.

This section documents:

\> the current authoritative technical architecture.

Its purpose is to establish:

\#\#\# clear ownership boundaries

\#\#\# lifecycle responsibilities

\#\#\# orchestration rules

\#\#\# service responsibilities

\#\#\# interaction contracts

\#\#\# regression prevention

This document reflects:

\> \*\*EGAL-6.5 PASS UAT state\*\*

Future contributors should treat this as:

\> the technical source of truth.

\---

\# 7.2 High-Level Architecture Overview

At a high level:

EGAL follows a:

\> layered orchestration architecture.

The genealogy application remains:

\> business-authoritative.

EGAL acts as:

\> confidence-preserving orchestration layer.

Meaning:

EGAL enhances.

It does not replace.

This aligns directly with:

\#\#\# Q1 — Preserve working business flow

\---

\#\# High-Level System Map

\`\`\`txt

┌─────────────────────────────────────────────┐

│               USER INTERACTION              │

│         (elderly-first experience)          │

└─────────────────────────────────────────────┘

                       ↓

┌─────────────────────────────────────────────┐

│             ATTENTION LAYER                 │

│                                             │

│ AttentionZone                               │

│ attentionOrchestrator                       │

│ lastAttentionMessage recovery               │

└─────────────────────────────────────────────┘

                       ↓

┌─────────────────────────────────────────────┐

│              GUIDANCE LAYER                 │

│                                             │

│ ElderAssistButton                           │

│ guidedProgressionService                    │

│ TTS Provider                                │

└─────────────────────────────────────────────┘

                       ↓

┌─────────────────────────────────────────────┐

│            ORCHESTRATION LAYER              │

│                                             │

│ AuthPage                                    │

│ lifecycleContext                            │

│ navigation ownership                        │

└─────────────────────────────────────────────┘

                       ↓

┌─────────────────────────────────────────────┐

│              VALIDATION LAYER               │

│                                             │

│ validationGate.service.js                   │

│ authoritative transition checks             │

└─────────────────────────────────────────────┘

                       ↓

┌─────────────────────────────────────────────┐

│              LIFECYCLE LAYER                │

│                                             │

│ navigationLifecycle.service.js              │

│ runtimeInvalidation.service.js              │

│ lifecycle-safe runtime                      │

└─────────────────────────────────────────────┘

                       ↓

┌─────────────────────────────────────────────┐

│              BUSINESS FLOWS                 │

│                                             │

│ RegisterForm                                │

│ JoinClanForm                                │

│ CreateClanForm                              │

│ Existing backend logic                      │

└─────────────────────────────────────────────┘

\`\`\`

\---

\#\# Architecture Philosophy

The system intentionally separates:

\#\#\# business correctness

from:

\#\#\# confidence orchestration

This separation prevents:

\> regression-by-accessibility

Meaning:

Accessibility improvements cannot accidentally rewrite:

\> business semantics.

\---

\# 7.3 Architecture Layer Responsibilities

EGAL architecture is intentionally layered.

Each layer owns:

\> specific responsibilities.

And should not leak authority.

\---

\# 7.4 Attention Layer

\---

\#\# Purpose

The attention layer manages:

\> user focus continuity.

This layer exists because:

elderly users frequently lose context.

Especially after:

\- interruptions

\- waiting

\- multi-step progression

\- scrolling

\---

\#\# Core Components

\#\#\# AttentionZone

Purpose:

Define:

\> focus anchors.

Responsibilities:

\- establish attention target

\- reduce visual wandering

\- improve message recognition

\---

\#\#\# attentionOrchestrator

Purpose:

Coordinate:

\> attention behavior centrally.

Responsibilities:

\- restore focus

\- synchronize guidance

\- preserve continuity

This prevents:

\> scattered component attention logic.

\---

\#\#\# lastAttentionMessage Recovery

Purpose:

Restore:

\> previous meaningful context.

Responsibilities:

\- interruption recovery

\- continuity preservation

\- cognitive reassurance

\---

\#\# Ownership Rule

Attention layer:

\#\#\# may guide focus

✓

But:

\#\#\# may not control navigation

✗

This boundary is important.

\---

\# 7.5 Guidance Layer

\---

\#\# Purpose

The guidance layer supports:

\> elderly interaction confidence.

This layer exists to reduce:

\- hesitation

\- confusion

\- uncertainty

\---

\#\# Core Components

\#\#\# ElderAssistButton

Purpose:

Provide:

\> explicit assistance entry point.

Responsibilities:

\- accessible help trigger

\- guidance reassurance

\---

\#\#\# guidedProgressionService

Purpose:

Guide transitions.

Not merely expose them.

Responsibilities:

\- progression assistance

\- step continuity

\- contextual support

\---

\#\#\# TTS Provider (V24.2.0)

Purpose:

Audio reinforcement.

Responsibilities:

\- validation reinforcement

\- instruction guidance

\- feedback support

\---

\#\# Ownership Rule

Guidance layer:

\#\#\# may suggest

✓

But:

\#\#\# may not own navigation

✗

Navigation remains:

\> orchestration authority.

\---

\# 7.6 Orchestration Layer

\---

\#\# Purpose

The orchestration layer manages:

\> system-level behavior consistency.

This is the most important EGAL layer.

\---

\#\# Core Authority

\#\#\# AuthPage

AuthPage acts as:

\> orchestration root.

Formalized in:

\#\#\# Q4

\---

\#\# Responsibilities

AuthPage owns:

\#\#\# navigation authority

\---

\#\#\# lifecycleContext propagation

\---

\#\#\# transition orchestration

\---

\#\#\# flow consistency

\---

\#\#\# parent-level coordination

\---

AuthPage intentionally centralizes behavior.

To avoid:

\> fragmented navigation logic.

\---

\#\# lifecycleContext

Purpose:

Provide:

\> cross-flow continuity.

Responsibilities:

\- state transfer

\- edit recovery

\- transition context

This became especially important in:

\- RegisterForm

\- CreateClanForm

\- JoinClanForm

\---

\#\# Ownership Rule

AuthPage owns:

\#\#\# when transition occurs

\#\#\# where transition occurs

\#\#\# how transition occurs

Child forms do not.

\---

\#\# Forbidden Behavior

Child component calling:

\`\`\`js

navigate(...)

\`\`\`

directly.

This violates:

\#\#\# Q4 \+ Q5

\---

\# 7.7 Validation Layer

\---

\#\# Purpose

Validation layer protects:

\> transition confidence.

Meaning:

Transitions must feel:

\> deserved.

Never surprising.

\---

\#\# Core Component

\#\#\# validationGate.service.js

Purpose:

Centralized transition validation.

Responsibilities:

\#\#\# authoritative validation

\---

\#\#\# pre-transition checking

\---

\#\#\# invalid progression blocking

\---

\#\#\# consistency enforcement

\---

\#\# Validation Flow

Correct flow:

\`\`\`txt

User Action

      ↓

Validation Gate

      ↓

Pass?

 ├─ YES → Transition

 └─ NO  → Stay \+ Guidance

\`\`\`

Incorrect flow:

\`\`\`txt

User Action

      ↓

Transition

      ↓

Validation Error

\`\`\`

This violates:

\#\#\# Q7

\---

\#\# Ownership Rule

Validation layer:

\#\#\# approves transition

✓

But:

\#\#\# does not navigate

✗

\---

\# 7.8 Lifecycle Layer

\---

\#\# Purpose

Lifecycle layer manages:

\> runtime predictability.

This is one of EGAL’s deepest architectural responsibilities.

Because UAT repeatedly showed:

\> technically correct state can still feel broken.

\---

\#\# Core Components

\#\#\# navigationLifecycle.service.js

Purpose:

Formalize:

\> navigation semantics.

Responsibilities:

\- edit return safety

\- transition structure

\- flow consistency

\---

\#\#\# runtimeInvalidation.service.js

Purpose:

Prevent:

\> stale runtime behavior.

Responsibilities:

\- invalidate stale assumptions

\- prevent hidden state leakage

\- maintain trust consistency

\---

\#\# Lifecycle Principle

Formalized in:

\#\#\# Q8

\> Draft values ≠ runtime state

\---

\#\# Lifecycle-Safe Runtime

Applied to:

\#\#\# RegisterForm

\---

\#\#\# JoinClanForm

\---

\#\#\# CreateClanForm

\---

These forms now preserve:

\> predictable recovery.

\---

\#\# Ownership Rule

Lifecycle layer:

\#\#\# manages runtime truth

✓

But:

\#\#\# should not contain UI logic

✗

\---

\# 7.9 Business Flow Layer

\---

\#\# Purpose

Business flow layer preserves:

\> existing application correctness.

EGAL intentionally avoids rewriting this layer.

In alignment with:

\#\#\# Q1

\---

\#\# Current Major Flows

\#\#\# RegisterForm

Responsibilities:

\- user registration

\- clan creation integration

\- clan joining integration

Lifecycle-safe after:

EGAL-6.5

\---

\#\#\# JoinClanForm

Responsibilities:

\- clan joining

\- review support

\- edit recovery

Lifecycle-safe after:

EGAL-6.5

\---

\#\#\# CreateClanForm

Responsibilities:

\- clan creation

\- confidence-preserving progression

\- edit safety

Lifecycle-safe after:

EGAL-6.5

\---

\#\#\# WaitingPage

Responsibilities:

\- review

\- edit

\- reassurance

\- transition confidence

Authoritative meaning:

\#\#\# TRUE REVIEW PAGE

Not loading screen.

\---

\# 7.10 Current Ownership Model

One of the most important architecture concepts.

Ownership is intentionally separated.

\---

\#\# Ownership Table

| Concern | Owner |

|---|---|

| Navigation authority | AuthPage |

| Local rendering | Child forms |

| Validation approval | validationGate |

| Runtime validity | lifecycle layer |

| Attention continuity | attention layer |

| Guidance | guidance layer |

| Review semantics | WaitingPage |

| Business logic | Existing forms/backend |

\---

\#\# Why This Matters

Without ownership separation:

behavior drift occurs.

This was repeatedly proven by UAT.

\---

\# 7.11 Current Interaction Flow

\---

\#\# Register / Join / Create Flow

\`\`\`txt

User Input

      ↓

Child Form

(local validation)

      ↓

validationGate.service

(authoritative check)

      ↓

AuthPage

(orchestration decision)

      ↓

WaitingPage

(TRUE REVIEW PAGE)

      ↓

User confirms

      ↓

Business Submission

      ↓

ResultPage

(attention centered)

\`\`\`

\---

\#\# Edit Return Flow

\`\`\`txt

WaitingPage

      ↓

Edit

      ↓

AuthPage lifecycleContext

      ↓

Child Form Restore

      ↓

runtimeInvalidation

      ↓

Safe Runtime State

\`\`\`

This flow fixed:

\> stale validation issues.

\---

\# 7.12 Architecture Boundaries

Future contributors must preserve these boundaries.

\---

\#\# Child Forms MUST NOT

\#\#\# own navigation

✗

\---

\#\#\# own lifecycle truth

✗

\---

\#\#\# bypass validationGate

✗

\---

\#\#\# manipulate orchestration directly

✗

\---

\#\# AuthPage MUST NOT

\#\#\# contain local form logic

✗

\---

\#\#\# bypass lifecycle safety

✗

\---

\#\# WaitingPage MUST NOT

\#\#\# become loading-only screen

✗

\---

\#\#\# remove editability

✗

\---

\# 7.13 Current UAT Status (EGAL-6.5)

\---

\#\# JoinClanForm

PASS

\#\#\# stale validation fixed

✓

\#\#\# edit return fixed

✓

\#\#\# navigation simplified

✓

\---

\#\# CreateClanForm

PASS

\#\#\# lifecycle-safe

✓

\#\#\# force return attention fixed

✓

\#\#\# review semantics stable

✓

\---

\#\# RegisterForm

PASS

\#\#\# integration safe

✓

\#\#\# lifecycleContext pass-through

✓

\#\#\# semantics preserved

✓

\---

\# 7.14 Technical Architecture Summary

By EGAL-6.5:

The system architecture now consists of:

\#\#\# Attention orchestration

\---

\#\#\# Guided assistance

\---

\#\#\# Centralized navigation

\---

\#\#\# Authoritative validation

\---

\#\#\# Lifecycle safety

\---

\#\#\# Review semantics

\---

\#\#\# Business flow preservation

All working together to support:

\> confidence-preserving elderly interaction.

\---

\#\# 7.15 PART VII Conclusion

The most important insight of EGAL technical architecture is this:

\> accessibility cannot remain component-local.

Because confidence problems emerge:

\> systemically.

EGAL therefore evolved into:

\> layered orchestration architecture

where:

\#\#\# business correctness remains preserved

while:

\#\#\# elderly confidence becomes protected.

This architecture should be treated as:

\> authoritative until contradicted by future UAT.

\---

## \# END OF PART VII

# PART VIII — REMAINING TECHNICAL DEBT

\---

\#\# 8.1 Introduction

By EGAL-6.5:

The architecture achieved:

\> \*\*UAT stability\*\*

for the major elderly interaction flows.

Specifically:

\- RegisterForm

\- JoinClanForm

\- CreateClanForm

\- WaitingPage integration

\- lifecycle-safe progression

\- authoritative validation

\- confidence-preserving navigation

However:

It would be incorrect to describe EGAL as:

\> “finished.”

A more accurate description is:

\> \*\*architecturally stable, intentionally unfinished.\*\*

This distinction matters.

Because:

EGAL-6.5 solved:

\> the highest-risk confidence failures.

But several categories of technical debt remain.

Some debts are:

\> intentionally accepted.

Others represent:

\> future architectural risk.

This section documents:

\#\#\# what debt remains

\#\#\# why it exists

\#\#\# risk level

\#\#\# recommended mitigation

\#\#\# what must not be broken

Future contributors should interpret this section as:

\> engineering truth.

Not failure.

Technical debt exists because:

\> preserving stability sometimes mattered more than architectural purity.

Especially under:

\#\#\# Q1 — Preserve working business flow

and:

\#\#\# Q3 — Prefer anchor-level patching

\---

\# 8.2 Technical Debt Classification Model

For clarity:

EGAL debt is categorized into:

| Category | Meaning |

|---|---|

| Accepted Debt | Intentionally tolerated |

| Architectural Debt | Structural weakness |

| Lifecycle Debt | Runtime consistency risk |

| UX Debt | Confidence/interaction weakness |

| Maintainability Debt | Developer complexity |

| Dangerous Debt | High regression potential |

\---

\# 8.3 Debt \#1  

\# AuthPage Becoming Too Powerful

\---

\#\# Type

\> Architectural Debt

\---

\#\# Severity

\> Medium

\---

\#\# Risk

\> Long-term maintainability risk

\---

\#\# Problem

Because of:

\#\#\# Q4 — AuthPage Is Orchestration Root

AuthPage increasingly became:

\> orchestration-heavy.

Responsibilities expanded to include:

\- lifecycleContext propagation

\- navigation authority

\- progression decisions

\- child coordination

\- review transitions

This was necessary.

But introduces risk.

Over time:

AuthPage may become:

\> orchestration monolith.

\---

\#\# Why Debt Was Accepted

At EGAL-6.5:

Centralization was safer than fragmentation.

Because fragmented navigation repeatedly failed UAT.

Meaning:

\> centralization was the correct tradeoff.

\---

\#\# Current Risk

Future contributors may accidentally place:

\#\#\# business logic

inside AuthPage.

This would be architectural leakage.

\---

\#\# Recommended Mitigation

Eventually consider:

\> orchestration composition

Possible future direction:

\`\`\`txt

AuthPage

 ├─ navigation controller

 ├─ lifecycle coordinator

 ├─ review coordinator

 └─ guidance coordinator

\`\`\`

But:

\> not before stability proof.

\---

\#\# Regression Warning

Do NOT refactor prematurely.

Premature decomposition risks:

\> behavioral drift.

\---

\# 8.4 Debt \#2  

\# Lifecycle Complexity Is Still High

\---

\#\# Type

\> Lifecycle Debt

\---

\#\# Severity

\> Medium–High

\---

\#\# Problem

Lifecycle safety improved significantly.

But remains:

\> mentally complex.

Especially around:

\#\#\# WaitingPage → Edit → Return

Flow interactions.

Hidden assumptions still exist.

Examples:

\- restore timing

\- invalidation timing

\- runtime reset semantics

\- edit recovery ordering

These currently work.

But are fragile.

\---

\#\# Why Debt Exists

Because:

lifecycle architecture emerged incrementally.

Not upfront.

Meaning:

some flows still carry:

\> historical coupling.

\---

\#\# Why It Was Accepted

EGAL prioritized:

\#\#\# UAT stability

over:

\#\#\# perfect lifecycle abstraction

Correctly.

\---

\#\# Current Risk

Future refactors may accidentally break:

\#\#\# stale validation prevention

or:

\#\#\# edit return safety

without obvious compile errors.

\---

\#\# Recommended Mitigation

Future possibility:

Dedicated:

\`\`\`txt

LifecycleCoordinator

\`\`\`

But only after:

\> EGAL-6.x closure stability.

\---

\#\# Regression Warning

Never modify lifecycle ordering casually.

Even small changes may create:

\> invisible trust regression.

\---

\# 8.5 Debt \#3  

\# WaitingPage Still Contains Transitional Legacy Assumptions

\---

\#\# Type

\> UX \+ Architectural Debt

\---

\#\# Severity

\> Medium

\---

\#\# Problem

WaitingPage evolved dramatically.

From:

\> transport state

to:

\> TRUE REVIEW PAGE

However:

some historical assumptions still remain.

Examples:

Certain logic may still implicitly treat WaitingPage as:

\> temporary intermediary.

Not:

\> authoritative review surface.

\---

\#\# Why Debt Exists

Because semantic evolution happened:

\> mid-project.

Not from day one.

\---

\#\# Why It Was Accepted

Rewriting WaitingPage completely would risk:

\> regression in stable flow.

Thus:

anchor-level evolution was chosen.

In accordance with:

\#\#\# Q3

\---

\#\# Current Risk

Future developers may accidentally regress WaitingPage into:

\#\#\# loading screen

\#\#\# transition placeholder

\#\#\# spinner surface

This would directly violate:

\#\#\# Q6

\---

\#\# Recommended Mitigation

Eventually:

perform semantic cleanup.

Clarify:

\`\`\`txt

Review responsibilities

Edit responsibilities

Submission boundaries

\`\`\`

\---

\#\# Regression Warning

Do NOT remove:

\#\#\# editability

\#\#\# review semantics

\#\#\# reassurance behaviors

\---

\# 8.6 Debt \#4  

\# Cross-Form Consistency Is Not Yet Fully Unified

\---

\#\# Type

\> UX Debt

\---

\#\# Severity

\> Medium

\---

\#\# Problem

Major flows now behave consistently.

But not perfectly.

Subtle inconsistencies still exist between:

\- RegisterForm

\- JoinClanForm

\- CreateClanForm

Examples may include:

\#\#\# progression wording

\---

\#\#\# micro-interactions

\---

\#\#\# timing differences

\---

\#\#\# recovery nuance

\---

Most are minor.

But matter for elderly predictability.

\---

\#\# Why Debt Exists

Because forms evolved:

\> at different sprint phases.

Each inherited historical behavior.

\---

\#\# Why It Was Accepted

Current consistency reached:

\> UAT acceptable level.

Higher unification would risk:

\> destabilization.

\---

\#\# Recommended Mitigation

Target:

\#\#\# EGAL-6.6 UX Polish

Not earlier.

\---

\# 8.7 Debt \#5  

\# Attention Orchestration Is Still Partially Implicit

\---

\#\# Type

\> Architectural Debt

\---

\#\# Severity

\> Medium

\---

\#\# Problem

Attention orchestration exists.

But not fully formalized.

Some attention logic still remains:

\> component-local.

Meaning:

AttentionZone and attentionOrchestrator are not yet fully authoritative.

\---

\#\# Why Debt Exists

Because attention architecture evolved organically.

Instead of:

\> planned system.

\---

\#\# Current Risk

Inconsistent attention behavior may reappear.

Especially after new feature additions.

\---

\#\# Recommended Mitigation

Future possibility:

Formal:

\`\`\`txt

AttentionCoordinator

\`\`\`

Pattern.

But:

only if UAT justifies.

Avoid architecture inflation.

\---

\# 8.8 Debt \#6  

\# Guidance Layer Lacks Central Policy Model

\---

\#\# Type

\> Maintainability Debt

\---

\#\# Severity

\> Medium

\---

\#\# Problem

Guidance currently exists.

But lacks:

\> unified policy system.

Examples:

When should TTS trigger?

How much guidance is too much?

How should interruption recovery behave?

Some behavior remains:

\> heuristic.

\---

\#\# Why Debt Exists

Guidance matured reactively through UAT.

Not from centralized rules.

\---

\#\# Current Risk

Feature additions may create:

\#\#\# over-guidance

or:

\#\#\# under-guidance

Both damage confidence.

\---

\#\# Recommended Mitigation

Possible future:

\`\`\`txt

GuidancePolicy.service.js

\`\`\`

But only if complexity justifies.

\---

\# 8.9 Debt \#7  

\# UAT Knowledge Is Human Memory Dependent

\---

\#\# Type

\> Dangerous Debt

\---

\#\# Severity

\> High

\---

\#\# Problem

Many important architectural decisions currently live in:

\> human context.

Not code.

Meaning:

Future contributors may ask:

\> “Why is this weird?”

And accidentally remove critical behavior.

\---

\#\# Why Debt Exists

Because:

rapid iterative UAT happened faster than documentation.

\---

\#\# Why It Is Dangerous

Invisible rationale causes:

\> regression-by-cleanup

This is one of the highest-risk debts.

\---

\#\# Mitigation

This Architecture Bible exists specifically to reduce this debt.

It is:

\> intentional knowledge preservation.

\---

\# 8.10 Debt \#8  

\# Testing Is Still UAT-Centric

\---

\#\# Type

\> Maintainability Debt

\---

\#\# Severity

\> Medium–High

\---

\#\# Problem

EGAL currently relies heavily on:

\> manual UAT.

Especially elderly-user observation.

Automated confidence testing does not exist.

Meaning:

Behavior regressions remain possible.

\---

\#\# Why Debt Exists

Confidence behaviors are difficult to automate.

Especially:

\- hesitation

\- trust

\- perceived safety

\- navigation confidence

\---

\#\# Current Risk

Invisible regressions.

Especially during:

\#\#\# “minor refactor”

\---

\#\# Recommended Mitigation

Eventually create:

\#\#\# behavioral regression checklist

and:

\#\#\# scenario-based confidence tests

\---

\# 8.11 Debt \#9  

\# Over-Optimization Temptation

\---

\#\# Type

\> Dangerous Debt

\---

\#\# Severity

\> High

\---

\#\# Problem

As architecture stabilizes:

future contributors may feel tempted to:

\> simplify aggressively.

Examples:

“Remove unnecessary state.”

“Centralize everything.”

“Refactor for cleanliness.”

“Reduce complexity.”

This is dangerous.

Because much complexity exists for:

\> elderly confidence reasons.

Not engineering elegance.

\---

\#\# Regression Risk

High.

Especially around:

\#\#\# lifecycle safety

\---

\#\#\# WaitingPage semantics

\---

\#\#\# navigation authority

\---

\#\# Recommended Mitigation

Always ask:

\> “What UAT failure did this originally solve?”

Before simplifying.

\---

\# 8.12 Technical Debt Priority Matrix

| Debt | Severity | Priority |

|---|---:|---:|

| AuthPage growth | Medium | Medium |

| Lifecycle complexity | Medium–High | High |

| WaitingPage legacy assumptions | Medium | Medium |

| Cross-form consistency | Medium | Medium |

| Attention orchestration implicitness | Medium | Low |

| Guidance policy absence | Medium | Low |

| UAT knowledge dependency | High | Critical |

| Manual UAT dependency | Medium–High | High |

| Over-optimization temptation | High | Critical |

\---

\# 8.13 Accepted Debt Summary

The following debts are:

\> intentionally accepted.

Because fixing them prematurely risks:

\> destabilization.

Accepted:

\#\#\# partial lifecycle complexity

\---

\#\#\# orchestration centralization

\---

\#\#\# WaitingPage historical coupling

\---

\#\#\# mild UX inconsistency

\---

This is:

\> strategic debt.

Not negligence.

\---

\# 8.14 PART VIII Conclusion

EGAL-6.5 should be understood as:

\> stable but unfinished.

The system solved:

\> major confidence failures.

But still contains:

\> deliberate tradeoffs.

This is normal.

Especially for UAT-driven architecture.

The most important lesson is:

\> do not mistake remaining complexity for accidental design.

Much of it exists because:

\> elderly confidence is fragile.

Future improvements should prioritize:

\#\#\# stability

before:

\#\#\# elegance.

And always preserve:

\> confidence-preserving behavior.

\---

## \# END OF PART VIII

# PART IX — LESSONS LEARNED

\---

\#\# 9.1 Introduction

After EGAL-6.5 achieved:

\> stable UAT acceptance

the most important question became:

\> \*\*What did EGAL actually teach us?\*\*

This section attempts to extract:

\> durable knowledge.

Not implementation details.

Not sprint history.

Not technical inventory.

Those were covered elsewhere.

Instead:

This section documents:

\> hard-earned truths.

Truths that repeatedly emerged through:

\- failure

\- correction

\- UAT contradiction

\- architectural pivots

\- unexpected user behavior

Some lessons were anticipated.

Many were not.

Several directly contradicted conventional frontend wisdom.

Future contributors should read this section as:

\> accumulated engineering experience.

Not doctrine.

But:

\> lessons paid for through repeated mistakes.

\---

\# 9.2 Lesson \#1  

\# Elderly UX Is Fundamentally Different UX

\---

\#\# Original Assumption

At first:

the team implicitly assumed:

\> elderly UX \= standard UX \+ accessibility.

Meaning:

larger targets.

Clearer messages.

Voice support.

Better visibility.

\---

\#\# What EGAL Learned

This assumption proved incomplete.

Elderly UX is fundamentally different because:

\> cognitive confidence behaves differently.

Younger users tolerate:

\#\#\# uncertainty

\---

\#\#\# experimentation

\---

\#\#\# temporary confusion

\---

\#\#\# hidden assumptions

\---

Elderly users often do not.

Observed pattern:

Younger users ask:

\> “What happens if I click this?”

Elderly users ask:

\> “What if something goes wrong?”

This changes architecture priorities completely.

\---

\#\# Lasting Truth

Elderly-first systems should optimize for:

\> confidence

before:

\> efficiency.

\---

\# 9.3 Lesson \#2  

\# Business Correctness Is Necessary but Insufficient

\---

\#\# Original Assumption

If:

business flow succeeds

Then:

UX is acceptable.

This assumption is common.

And often valid.

\---

\#\# What EGAL Learned

Repeatedly:

flows succeeded technically.

Yet users still felt confused.

Examples:

Submission succeeded.

User uncertain.

Validation worked.

User still anxious.

Navigation valid.

User distrustful.

Meaning:

\> technically correct systems can still feel broken.

This became one of EGAL’s deepest lessons.

\---

\#\# Lasting Truth

Success metrics must include:

\#\#\# confidence

\---

\#\#\# predictability

\---

\#\#\# emotional clarity

\---

Not merely:

\> API success.

\---

\# 9.4 Lesson \#3  

\# Accessibility Is Not Primarily Visual

\---

\#\# Original Assumption

Accessibility initially focused on:

\- visibility

\- readability

\- positioning

\- audio support

\---

\#\# What EGAL Learned

These helped.

But were insufficient.

The larger issue was:

\> interaction confidence.

Meaning:

Users struggled not because:

\> they could not see.

But because:

\> they did not trust what would happen next.

This realization changed EGAL direction.

Accessibility became:

\> orchestration architecture.

\---

\#\# Lasting Truth

Accessibility must include:

\#\#\# behavioral predictability

\---

\#\#\# recoverability

\---

\#\#\# reassurance

\---

\#\#\# confidence preservation

\---

\# 9.5 Lesson \#4  

\# UAT Invalidates Elegant Assumptions

\---

\#\# Original Assumption

Some architecture ideas seemed elegant.

Examples:

automatic transitions

minimal review

optimistic navigation

simplified validation timing

component autonomy

\---

\#\# What EGAL Learned

Many elegant solutions failed real elderly behavior.

Unexpectedly.

Repeatedly.

Meanwhile:

Several “less elegant” solutions succeeded.

Example:

WaitingPage as TRUE REVIEW PAGE.

From engineering perspective:

Not minimal.

From elderly perspective:

Essential.

\---

\#\# Lasting Truth

Elegance is not success.

UAT success is success.

\---

\# 9.6 Lesson \#5  

\# Predictability Beats Cleverness

\---

\#\# Observation

Many UX systems reward:

\> surprise delight.

EGAL learned:

This often backfires.

Especially for elderly users.

Unexpected behavior—even positive behavior—can feel unsafe.

Examples:

Unexpected redirect.

Unexpected validation.

Unexpected state restoration.

Unexpected UI movement.

\---

\#\# What Worked Better

Consistency.

Repetition.

Familiarity.

Stable behavior.

Predictable progression.

“Boring” interactions often performed better.

\---

\#\# Lasting Truth

Prefer:

\> reliable and familiar

over:

\> clever and dynamic

\---

\# 9.7 Lesson \#6  

\# Review Is Not Friction

\---

\#\# Original Assumption

Modern systems optimize:

\> reduce steps.

Meaning:

Fewer interruptions.

Faster completion.

\---

\#\# What EGAL Learned

Elderly users naturally paused.

Reviewed.

Confirmed.

Re-read.

Review moments increased:

\> trust.

This completely changed WaitingPage philosophy.

Review became:

\> confidence infrastructure.

Not friction.

\---

\#\# Lasting Truth

For elderly systems:

\> review often improves completion.

Not reduces it.

\---

\# 9.8 Lesson \#7  

\# Validation Timing Changes Emotion

\---

\#\# Observation

Validation technically worked in many configurations.

But emotional response changed dramatically.

Validation after transition created:

\> anxiety.

Validation before transition created:

\> reassurance.

This difference surprised the team.

The logic was identical.

But emotional interpretation changed.

\---

\#\# Lasting Truth

Timing matters.

Sometimes:

\> more than logic.

\---

\# 9.9 Lesson \#8  

\# Architecture Emerges From Repeated Failure

\---

\#\# Original Assumption

Architecture could be designed upfront.

Reality disagreed.

Repeatedly.

Many major EGAL decisions emerged only after:

\> failure cycles.

Pattern:

Hypothesis  

↓  

UAT  

↓  

Failure  

↓  

Correction  

↓  

Architecture pivot

This happened continuously.

\---

\#\# What Worked

Accepting:

\> incremental maturity.

Instead of:

\> forcing premature architecture.

\---

\#\# Lasting Truth

Sometimes:

\> architecture is discovered.

Not designed.

\---

\# 9.10 Lesson \#9  

\# Small UX Problems Often Hide Structural Problems

\---

\#\# Observation

Many issues initially appeared:

\> cosmetic.

Example:

User missed message.

Seemed like:

positioning issue.

Actually became:

\> attention orchestration issue.

Another example:

Edit return confusion.

Seemed like:

state bug.

Actually became:

\> lifecycle architecture issue.

Repeated pattern:

Small symptom.

Deep cause.

\---

\#\# Lasting Truth

Do not dismiss recurring UX friction.

Repeated friction usually signals:

\> architectural mismatch.

\---

\# 9.11 Lesson \#10  

\# Centralized Orchestration Reduced Chaos

\---

\#\# Observation

Component autonomy initially felt natural.

Especially in React.

Reality:

Behavior drift emerged.

Different forms behaved differently.

Confidence suffered.

Centralization improved:

\#\#\# consistency

\---

\#\#\# predictability

\---

\#\#\# recoverability

\---

\#\#\# trust

\---

\#\# Lasting Truth

In elderly systems:

\> orchestration consistency matters more than local autonomy.

\---

\# 9.12 Lesson \#11  

\# Psychological Reversibility Matters

\---

\#\# Observation

Technical reversibility already existed.

Yet users still hesitated.

Why?

Because reversibility was:

\> invisible emotionally.

The system learned:

Users need to feel:

\> safe to proceed.

Not merely:

\> technically able to recover.

\---

\#\# What Worked

Review.

Edit.

Predictable return.

Safe wording.

\---

\#\# Lasting Truth

Recovery must feel:

\> psychologically available.

\---

\# 9.13 Lesson \#12  

\# Lifecycle Correctness Is Deeper Than State Correctness

\---

\#\# Observation

React state often remained valid.

Yet users still experienced:

\> distrust.

The issue:

Hidden lifecycle assumptions.

Unexpected runtime behavior.

This produced one of EGAL’s deepest discoveries:

\> technical correctness ≠ experiential correctness

\---

\#\# Lasting Truth

Always ask:

\> “Will the user perceive this as consistent?”

Not merely:

\> “Does state technically exist?”

\---

\# 9.14 Lesson \#13  

\# Documentation Is Architecture Protection

\---

\#\# Observation

Many EGAL decisions lived only in:

\> human memory.

This became dangerous.

Because future cleanup may accidentally remove:

\> critical confidence behaviors.

This Architecture Bible exists partly to solve:

\> institutional memory loss.

\---

\#\# Lasting Truth

Undocumented rationale eventually becomes:

\> regression risk.

\---

\# 9.15 Lesson \#14  

\# Stability Sometimes Matters More Than Purity

\---

\#\# Observation

Several tempting refactors were avoided.

Not because impossible.

But because:

\> stability mattered more.

Especially under:

\#\#\# Q1

and:

\#\#\# Q3

This restraint prevented many regressions.

\---

\#\# Lasting Truth

Sometimes:

\> “good enough and stable”

is better than:

\> “perfect but risky.”

\---

\# 9.16 Lesson \#15  

\# Confidence Is Fragile

\---

\#\# Observation

Confidence was surprisingly easy to lose.

Tiny inconsistencies caused:

\- hesitation

\- distrust

\- abandonment risk

Examples:

Unexpected button behavior.

Unexpected navigation.

Unexpected state.

Confidence required:

\> consistency.

Repeatedly.

\---

\#\# Lasting Truth

Confidence takes time to build.

Seconds to lose.

Protect it carefully.

\---

\# 9.17 What We Would Do Differently

If rebuilding EGAL from day one:

The team would likely:

\#\#\# define orchestration earlier

\---

\#\#\# formalize lifecycle semantics earlier

\---

\#\#\# recognize WaitingPage sooner

\---

\#\#\# centralize navigation sooner

\---

\#\#\# document UAT findings continuously

\---

\#\#\# establish doctrine earlier

\---

However:

Some discoveries likely required:

\> real failure experience.

Meaning:

not all lessons were avoidable.

\---

\# 9.18 What Unexpectedly Worked

Several surprising successes emerged.

\#\#\# TRUE REVIEW PAGE

Unexpectedly powerful.

\---

\#\#\# TTS reinforcement

More effective than expected.

\---

\#\#\# Attention recovery

Highly valuable.

\---

\#\#\# lifecycle-safe edit return

Large confidence improvement.

\---

\#\#\# centralized orchestration

Reduced hidden inconsistency.

\---

\# 9.19 What Repeatedly Failed

Common failure patterns included:

\#\#\# optimistic assumptions

\---

\#\#\# post-transition validation

\---

\#\#\# hidden lifecycle coupling

\---

\#\#\# component autonomy

\---

\#\#\# invisible recovery

\---

\#\#\# premature cleanup

\---

\# 9.20 Lessons Summary

| Lesson | Core Truth |

|---|---|

| Elderly UX differs fundamentally | Confidence \> simplicity |

| Business correctness insufficient | Experience matters |

| Accessibility not visual only | Predictability matters |

| Elegant assumptions fail | UAT wins |

| Predictability beats cleverness | Familiarity helps |

| Review is valuable | Confidence increases |

| Timing changes emotion | Validation timing matters |

| Architecture emerges | Failure teaches |

| Small UX issues hide structure | Investigate deeply |

| Orchestration matters | Consistency wins |

| Psychological reversibility | Safety must feel real |

| Lifecycle \> state | Runtime matters |

| Documentation protects | Memory fades |

| Stability beats purity | Avoid risky rewrites |

| Confidence fragile | Protect trust |

\---

\#\# 9.21 PART IX Conclusion

Perhaps the deepest lesson of EGAL is this:

\> elderly users do not merely need usable systems.

They need:

\> trustworthy systems.

The difference is profound.

Usable systems help users finish tasks.

Trustworthy systems help users:

\> feel safe finishing tasks.

EGAL ultimately succeeded because it learned to optimize for:

\> confidence

rather than merely:

\> correctness.

This lesson should remain central to every future evolution of the project.

\---

## \# END OF PART IX

# PART X — FORWARD ROADMAP

## 

## \---

## 

## \#\# 10.1 Introduction

## 

## By EGAL-6.5:

## 

## The project achieved:

## 

## \> \*\*architectural stability\*\*

## 

## for the most critical elderly interaction flows.

## 

## Major accomplishments included:

## 

## \#\#\# lifecycle-safe navigation

## 

## \---

## 

## \#\#\# authoritative validation

## 

## \---

## 

## \#\#\# centralized orchestration

## 

## \---

## 

## \#\#\# TRUE REVIEW PAGE semantics

## 

## \---

## 

## \#\#\# guided progression

## 

## \---

## 

## \#\#\# confidence-preserving interaction

## 

## \---

## 

## Most importantly:

## 

## \> major UAT blockers were resolved.

## 

## However:

## 

## Stability does not automatically mean:

## 

## \> completion.

## 

## The next question becomes:

## 

## \> \*\*What should happen next?\*\*

## 

## This roadmap exists to answer:

## 

## \#\#\# what should evolve

## 

## \#\#\# what should stabilize

## 

## \#\#\# what should not be touched

## 

## \#\#\# when to stop evolving

## 

## The roadmap intentionally avoids:

## 

## \> feature wishlist thinking.

## 

## Instead:

## 

## It follows:

## 

## \> architecture maturity thinking.

## 

## Meaning:

## 

## The next steps exist to:

## 

## \> protect and consolidate what already works.

## 

## Not endlessly expand complexity.

## 

## \---

## 

## \# 10.2 Roadmap Philosophy

## 

## EGAL future development should follow one principle:

## 

## \> stabilize before innovating.

## 

## Because:

## 

## elderly confidence systems are:

## 

## \> fragile.

## 

## Small regressions create disproportionate trust loss.

## 

## Therefore:

## 

## Future evolution should prioritize:

## 

## \#\#\# confidence preservation

## 

## before:

## 

## \#\#\# architectural ambition

## 

## \---

## 

## \#\# Roadmap Priority Order

## 

## \`\`\`txt

## STABILITY

##     ↓

## HARDENING

##     ↓

## UX CONSISTENCY

##     ↓

## CLOSEOUT

##     ↓

## OPTIONAL FUTURE EVOLUTION

## \`\`\`

## 

## This order matters.

## 

## Skipping steps introduces risk.

## 

## \---

## 

## \# 10.3 Phase 1  

## \# Immediate Next Step  

## \# EGAL-6.5.5 Hardening UAT

## 

## \---

## 

## \#\# Purpose

## 

## After major architecture stabilization:

## 

## The first responsibility becomes:

## 

## \> prove reliability.

## 

## Not add features.

## 

## This phase exists to answer:

## 

## \> “Did we actually solve the problems?”

## 

## Across:

## 

## \#\#\# real-world elderly behavior

## 

## \---

## 

## \#\#\# edge cases

## 

## \---

## 

## \#\#\# lifecycle recovery

## 

## \---

## 

## \#\#\# regression scenarios

## 

## \---

## 

## \#\# Why This Phase Exists

## 

## EGAL-6.5 introduced:

## 

## significant architectural change.

## 

## Especially:

## 

## \#\#\# lifecycle safety

## 

## \#\#\# runtime invalidation

## 

## \#\#\# WaitingPage semantics

## 

## \#\#\# orchestration authority

## 

## Large changes require:

## 

## \> hardening.

## 

## Before expansion.

## 

## \---

## 

## \#\# Primary Objective

## 

## Validate:

## 

## \> architectural reliability.

## 

## Not functionality alone.

## 

## \---

## 

## \#\# Focus Areas

## 

## \#\#\# WaitingPage → Edit return reliability

## 

## \---

## 

## \#\#\# lifecycle consistency

## 

## \---

## 

## \#\#\# stale validation regression

## 

## \---

## 

## \#\#\# runtime invalidation correctness

## 

## \---

## 

## \#\#\# confidence preservation

## 

## \---

## 

## \#\#\# attention continuity

## 

## \---

## 

## \#\#\# elderly hesitation behavior

## 

## \---

## 

## \#\# Deliverable

## 

## \#\#\# 02\_EGAL\_6.5.5\_Hardening\_UAT.md

## 

## Purpose:

## 

## Formalize:

## 

## \- test matrix

## \- edge scenarios

## \- regression checklist

## \- UAT observations

## \- remaining blockers

## 

## \---

## 

## \#\# Success Criteria

## 

## Proceed only if:

## 

## \#\#\# no major lifecycle regressions

## 

## ✓

## 

## \---

## 

## \#\#\# elderly confidence remains stable

## 

## ✓

## 

## \---

## 

## \#\#\# edit-return behavior reliable

## 

## ✓

## 

## \---

## 

## \#\#\# stale validation eliminated

## 

## ✓

## 

## \---

## 

## \#\# Failure Condition

## 

## Do NOT proceed to 6.6 if:

## 

## \> lifecycle instability remains.

## 

## Stability comes first.

## 

## \---

## 

## \# 10.4 Phase 2  

## \# EGAL-6.6 UX Polish

## 

## \---

## 

## \#\# Purpose

## 

## Only after:

## 

## \> lifecycle trust stabilizes

## 

## should UX refinement begin.

## 

## This phase is:

## 

## \> polish.

## 

## Not architecture rewrite.

## 

## \---

## 

## \#\# Why This Phase Exists

## 

## Current EGAL state is:

## 

## \> stable but uneven.

## 

## Minor inconsistencies remain.

## 

## Especially around:

## 

## \#\#\# wording

## 

## \---

## 

## \#\#\# micro-interactions

## 

## \---

## 

## \#\#\# pacing

## 

## \---

## 

## \#\#\# attention timing

## 

## \---

## 

## \#\#\# cross-form consistency

## 

## \---

## 

## \#\# Objective

## 

## Improve:

## 

## \> perceived smoothness.

## 

## Without changing:

## 

## \> architecture.

## 

## This distinction is critical.

## 

## \---

## 

## \#\# Recommended Scope

## 

## \#\#\# micro-copy consistency

## 

## Example:

## 

## review language

## 

## guidance tone

## 

## confirmation wording

## 

## \---

## 

## \#\#\# interaction pacing

## 

## Prevent:

## 

## too abrupt

## 

## too delayed

## 

## too noisy

## 

## \---

## 

## \#\#\# visual confidence cues

## 

## Improve reassurance.

## 

## Without clutter.

## 

## \---

## 

## \#\#\# cross-form consistency

## 

## RegisterForm

## 

## JoinClanForm

## 

## CreateClanForm

## 

## Should increasingly feel:

## 

## \> unified.

## 

## \---

## 

## \#\#\# guidance tuning

## 

## Prevent:

## 

## over-guidance.

## 

## Under-guidance.

## 

## \---

## 

## \#\# Deliverable

## 

## \#\#\# 03\_EGAL\_6.6\_UX\_Polish.md

## 

## \---

## 

## \#\# Explicit Non-Goals

## 

## Do NOT:

## 

## \#\#\# rewrite architecture

## 

## ✗

## 

## \---

## 

## \#\#\# redesign navigation

## 

## ✗

## 

## \---

## 

## \#\#\# replace lifecycle system

## 

## ✗

## 

## \---

## 

## \#\#\# rebuild WaitingPage

## 

## ✗

## 

## \---

## 

## \#\# Success Criteria

## 

## Users feel:

## 

## \> calmer.

## 

## \> more confident.

## 

## \> more consistent experience.

## 

## Without:

## 

## major behavioral change.

## 

## \---

## 

## \# 10.5 Phase 3  

## \# EGAL-6.x Project Closeout

## 

## \---

## 

## \#\# Purpose

## 

## At some point:

## 

## \> evolution must stop.

## 

## This phase exists to:

## 

## \> intentionally stabilize.

## 

## Not endlessly iterate.

## 

## \---

## 

## \#\# Why This Phase Exists

## 

## Many projects fail because:

## 

## they never exit:

## 

## \> improvement mode.

## 

## EGAL risks:

## 

## \> architecture inflation.

## 

## Meaning:

## 

## adding complexity beyond value.

## 

## This is dangerous.

## 

## Especially in elderly systems.

## 

## \---

## 

## \#\# Objective

## 

## Formally declare:

## 

## \> architecture stable.

## 

## Freeze:

## 

## major semantics.

## 

## Establish:

## 

## long-term maintenance rules.

## 

## \---

## 

## \#\# Deliverable

## 

## \#\#\# 04\_EGAL\_6.x\_Project\_Closeout.md

## 

## Including:

## 

## \#\#\# architecture freeze rationale

## 

## \---

## 

## \#\#\# preserved doctrines

## 

## \---

## 

## \#\#\# known limitations

## 

## \---

## 

## \#\#\# support boundaries

## 

## \---

## 

## \#\#\# regression checklist

## 

## \---

## 

## \#\#\# maintenance guidance

## 

## \---

## 

## \#\# Success Criteria

## 

## Team can confidently say:

## 

## \> EGAL is production-stable.

## 

## \---

## 

## \# 10.6 Optional Future Evolution (Post-Closeout)

## 

## Only consider these:

## 

## \> after closeout.

## 

## And only if:

## 

## \> UAT justifies.

## 

## Never because:

## 

## \> architecture curiosity.

## 

## \---

## 

## \# 10.7 Optional Evolution A  

## \# Lifecycle Coordinator

## 

## \---

## 

## \#\# Motivation

## 

## Current lifecycle complexity remains high.

## 

## Potential future abstraction:

## 

## \`\`\`txt

## LifecycleCoordinator

## \`\`\`

## 

## Could centralize:

## 

## \- restore semantics

## \- invalidation timing

## \- transition safety

## 

## \---

## 

## \#\# Risk

## 

## Premature abstraction may break:

## 

## \> proven behavior.

## 

## \---

## 

## \#\# Recommendation

## 

## Postpone until:

## 

## \> repeated maintenance pain exists.

## 

## \---

## 

## \# 10.8 Optional Evolution B  

## \# Guidance Policy System

## 

## \---

## 

## \#\# Motivation

## 

## Guidance behavior still partly heuristic.

## 

## Possible:

## 

## \`\`\`txt

## GuidancePolicy.service.js

## \`\`\`

## 

## Could formalize:

## 

## \#\#\# when TTS speaks

## 

## \---

## 

## \#\#\# interruption recovery

## 

## \---

## 

## \#\#\# guidance pacing

## 

## \---

## 

## \#\#\# confidence escalation

## 

## \---

## 

## \#\# Risk

## 

## Overengineering.

## 

## \---

## 

## \#\# Recommendation

## 

## Only if:

## 

## behavior inconsistency emerges.

## 

## \---

## 

## \# 10.9 Optional Evolution C  

## \# Attention Coordinator

## 

## \---

## 

## \#\# Motivation

## 

## Attention orchestration still partially implicit.

## 

## Potential:

## 

## \`\`\`txt

## AttentionCoordinator

## \`\`\`

## 

## Could formalize:

## 

## \#\#\# attention restoration

## 

## \---

## 

## \#\#\# focus priority

## 

## \---

## 

## \#\#\# interruption recovery

## 

## \---

## 

## \#\# Risk

## 

## Complexity inflation.

## 

## \---

## 

## \#\# Recommendation

## 

## Low priority.

## 

## Only if UAT demands.

## 

## \---

## 

## \# 10.10 Optional Evolution D  

## \# Behavioral Regression Testing

## 

## \---

## 

## \#\# Motivation

## 

## Current testing remains:

## 

## \> UAT-heavy.

## 

## Future possibility:

## 

## scenario-based confidence testing.

## 

## Examples:

## 

## \#\#\# edit return confidence

## 

## \---

## 

## \#\#\# interruption recovery

## 

## \---

## 

## \#\#\# hesitation scenarios

## 

## \---

## 

## \#\#\# lifecycle predictability

## 

## \---

## 

## \#\# Recommendation

## 

## High long-term value.

## 

## But:

## 

## not immediate priority.

## 

## \---

## 

## \# 10.11 Dangerous Roadmap Paths

## 

## Several paths are strongly discouraged.

## 

## \---

## 

## \#\# Path A  

## \# Premature Refactor

## 

## Danger:

## 

## Breaking stable behavior.

## 

## Examples:

## 

## “Clean architecture rewrite”

## 

## “State simplification”

## 

## “Modernization refactor”

## 

## Risk:

## 

## \> regression-by-cleanup

## 

## \---

## 

## \#\# Path B  

## \# Removing WaitingPage Semantics

## 

## Danger:

## 

## Destroying:

## 

## \> psychological safety.

## 

## Violates:

## 

## \#\#\# Q6

## 

## \---

## 

## \#\# Path C  

## \# Reintroducing Child Navigation Authority

## 

## Danger:

## 

## Behavior drift.

## 

## Violates:

## 

## \#\#\# Q4 \+ Q5

## 

## \---

## 

## \#\# Path D  

## \# Optimizing for Speed Over Confidence

## 

## Danger:

## 

## Elderly abandonment risk.

## 

## Examples:

## 

## Removing review.

## 

## Reducing reassurance.

## 

## Skipping guidance.

## 

## \---

## 

## \#\# Path E  

## \# Architecture Inflation

## 

## Danger:

## 

## Complexity without value.

## 

## Symptoms:

## 

## New services without UAT justification.

## 

## Abstracting too early.

## 

## Engineering for elegance.

## 

## \---

## 

## \# 10.12 Maturity Model

## 

## EGAL maturity can be viewed as:

## 

## \`\`\`txt

## 6.1  Attention Recovery

## 6.2  Guided Confidence

## 6.3  Attention Orchestration

## 6.4  Guided Flow Integrity

## 6.5  Lifecycle Safety

## 6.5.5 Hardening

## 6.6  UX Polish

## 6.x  Closeout

## \`\`\`

## 

## After closeout:

## 

## Status should become:

## 

## \`\`\`txt

## MAINTENANCE MODE

## \`\`\`

## 

## Not:

## 

## \`\`\`txt

## ENDLESS EXPANSION MODE

## \`\`\`

## 

## \---

## 

## \# 10.13 Stop Conditions  

## \# When NOT to Continue Evolving

## 

## Future evolution should stop when:

## 

## \#\#\# elderly confidence stable

## 

## ✓

## 

## \---

## 

## \#\#\# no major UAT blockers

## 

## ✓

## 

## \---

## 

## \#\#\# lifecycle predictable

## 

## ✓

## 

## \---

## 

## \#\#\# review semantics trusted

## 

## ✓

## 

## \---

## 

## \#\#\# regressions rare

## 

## ✓

## 

## \---

## 

## At this point:

## 

## prefer:

## 

## \> maintenance

## 

## over:

## 

## \> innovation.

## 

## \---

## 

## \#\# Important Principle

## 

## Past a certain maturity point:

## 

## more change becomes:

## 

## \> negative value.

## 

## Especially in elderly-first systems.

## 

## Because:

## 

## habit consistency becomes more important than novelty.

## 

## \---

## 

## \# 10.14 Recommended Immediate Execution Order

## 

## Recommended sequence:

## 

## \#\#\# Step 1

## 

## Complete:

## 

## \#\#\# 02\_EGAL\_6.5.5\_Hardening\_UAT.md

## 

## \---

## 

## \#\#\# Step 2

## 

## Complete:

## 

## \#\#\# 03\_EGAL\_6.6\_UX\_Polish.md

## 

## \---

## 

## \#\#\# Step 3

## 

## Complete:

## 

## \#\#\# 04\_EGAL\_6.x\_Project\_Closeout.md

## 

## \---

## 

## \#\#\# Step 4

## 

## Freeze major architecture.

## 

## \---

## 

## \#\#\# Step 5

## 

## Maintenance \+ UAT-driven improvements only.

## 

## \---

## 

## \# 10.15 PART X Conclusion

## 

## EGAL’s future should not be defined by:

## 

## \> endless improvement.

## 

## It should be defined by:

## 

## \> protected maturity.

## 

## The project succeeded because it learned:

## 

## \> confidence is fragile.

## 

## Future evolution should therefore remain:

## 

## \#\#\# careful

## 

## \#\#\# evidence-driven

## 

## \#\#\# UAT-grounded

## 

## \#\#\# stability-first

## 

## The final goal is not:

## 

## \> infinite optimization.

## 

## The final goal is:

## 

## \> trustworthy elderly interaction.

## 

## And by EGAL-6.5:

## 

## that goal is already within reach.

## 

## \---

## 

## \# END OF PART X

# APPENDIX — TIMELINE & KEY COMPONENTS

\---

\#\# A.1 Purpose of This Appendix

This appendix exists to provide:

\> \*\*high-speed operational understanding of EGAL\*\*

for:

\- future maintainers

\- onboarding contributors

\- new architecture reviewers

\- UAT participants

\- project continuation threads

Instead of reading the entire Architecture Bible first, a contributor may use this appendix to quickly understand:

\#\#\# what exists

\#\#\# why it exists

\#\#\# when it appeared

\#\#\# what problem it solved

\#\#\# what must not be broken

This appendix intentionally emphasizes:

\> architecture chronology \+ component purpose

over implementation detail.

\---

\# A.2 EGAL Historical Timeline

The following timeline summarizes:

\> how EGAL evolved.

\---

\#\# Phase 0 — Pre-EGAL State

\#\#\# Status

Business flow operational.

\---

\#\#\# Existing Capabilities

✓ Authentication

✓ Registration

✓ Clan creation

✓ Clan joining

✓ Backend integration

\---

\#\#\# Missing Capabilities

✗ Elder confidence support

✗ Guided interaction

✗ Attention recovery

✗ Lifecycle safety

✗ Review semantics

\---

\#\#\# Main Problem

System was:

\> technically functional

But not:

\> elderly-confidence safe.

\---

\# A.3 EGAL Evolution Timeline

\---

\#\# EGAL-6.1  

\# Attention Recovery Sprint

\---

\#\#\# Core Problem

Users missed important feedback.

\---

\#\#\# Major Discoveries

Attention placement matters.

\---

\#\#\# Components Introduced

\#\#\#\# WaitingPage messaging

Purpose:

replace abrupt alerts.

\---

\#\#\#\# ResultPage attention centering

Purpose:

focus important outcomes.

\---

\#\#\#\# Guided attention improvements

Purpose:

reduce overlooked feedback.

\---

\#\#\# Architecture Impact

First shift toward:

\> confidence-aware UX

\---

\#\#\# Status

Stable

\---

\#\# EGAL-6.2  

\# Guided Confidence Sprint

\---

\#\#\# Core Problem

Users still hesitated.

Even after understanding instructions.

\---

\#\#\# Major Discoveries

Understanding ≠ confidence.

\---

\#\#\# Components Introduced

\#\#\#\# Single Elder Assistance Mode

Purpose:

reduce overwhelm.

\---

\#\#\#\# ElderAssistButton

Purpose:

explicit help entry point.

\---

\#\#\#\# TTS Provider (V24.2.0)

Purpose:

audio reinforcement.

\---

\#\#\#\# AuthPage/HomePage guidance patch

Purpose:

better onboarding confidence.

\---

\#\#\# Architecture Impact

First movement toward:

\> guidance architecture

\---

\#\#\# Status

Stable

\---

\#\# EGAL-6.3  

\# Attention Orchestration Sprint

\---

\#\#\# Core Problem

Users lost context after interruption.

\---

\#\#\# Major Discoveries

Attention is recoverable state.

\---

\#\#\# Components Introduced

\#\#\#\# AttentionZone

Purpose:

focus anchoring.

\---

\#\#\#\# attentionOrchestrator

Purpose:

centralized attention behavior.

\---

\#\#\#\# guidedProgressionService

Purpose:

guided transitions.

\---

\#\#\#\# lastAttentionMessage recovery

Purpose:

context restoration.

\---

\#\#\# Architecture Impact

Beginning of:

\> orchestration thinking

\---

\#\#\# Status

Stable

\---

\#\# EGAL-6.4  

\# Guided Flow Integrity Sprint

\---

\#\#\# Core Problem

Flow consistency problems.

Different forms behaved differently.

\---

\#\#\# Major Discoveries

Component autonomy hurts predictability.

\---

\#\#\# Components Introduced

\#\#\#\# JoinClanForm guided progression

\---

\#\#\#\# CreateClanForm guided progression

\---

\#\#\#\# WaitingPage integration

\---

\#\#\# Architecture Impact

EGAL became:

\> flow-integrated

instead of:

\> optional enhancement.

\---

\#\#\# Status

Stable

\---

\#\# EGAL-6.5  

\# Lifecycle Safety Sprint

\---

\#\#\# Core Problem

Lifecycle inconsistency.

\---

\#\#\# Major Discoveries

Runtime predictability matters.

\---

\#\#\# Components Introduced

\#\#\#\# navigationLifecycle.service.js

Purpose:

navigation semantics.

\---

\#\#\#\# validationGate.service.js

Purpose:

authoritative transition validation.

\---

\#\#\#\# runtimeInvalidation.service.js

Purpose:

prevent stale runtime state.

\---

\#\#\#\# TRUE REVIEW PAGE

Purpose:

confidence-preserving review.

\---

\#\#\#\# lifecycle-safe forms

Applied to:

\- RegisterForm

\- JoinClanForm

\- CreateClanForm

\---

\#\#\# Architecture Impact

EGAL matured into:

\> layered orchestration architecture

\---

\#\#\# Status

PASS UAT

\---

\#\# EGAL-6.5.5 (Planned)  

\# Hardening Sprint

\---

\#\#\# Goal

Reliability proof.

\---

\#\#\# Focus

Lifecycle regressions.

Edit-return confidence.

Runtime consistency.

\---

\#\#\# Status

Planned

\---

\#\# EGAL-6.6 (Planned)  

\# UX Polish Sprint

\---

\#\#\# Goal

Consistency refinement.

\---

\#\#\# Focus

Micro-interactions.

Wording.

Confidence cues.

Cross-form consistency.

\---

\#\#\# Status

Planned

\---

\#\# EGAL-6.x Closeout (Planned)

\---

\#\#\# Goal

Architecture stabilization.

\---

\#\#\# Outcome

Freeze major semantics.

Transition to:

\> maintenance mode

\---

\#\#\# Status

Planned

\---

\# A.4 Architecture Evolution Map

\`\`\`txt

Functional UI

      ↓

Attention Recovery

      ↓

Guided Confidence

      ↓

Attention Orchestration

      ↓

Flow Integrity

      ↓

Lifecycle Safety

      ↓

Hardening

      ↓

UX Polish

      ↓

Architecture Closeout

\`\`\`

\---

\# A.5 Current Architecture Snapshot (EGAL-6.5)

\`\`\`txt

User

 ↓

Attention Layer

 ↓

Guidance Layer

 ↓

AuthPage Orchestration

 ↓

Validation Layer

 ↓

Lifecycle Layer

 ↓

Business Flow Layer

 ↓

Result Experience

\`\`\`

\---

\# A.6 Key Component Inventory

This section documents:

\> all major EGAL components.

\---

\# A.7 Component Inventory Table

| Component | Type | Status | Purpose |

|---|---|---|---|

| AuthPage | Orchestration | Active | Navigation authority |

| RegisterForm | Business flow | Active | Registration |

| JoinClanForm | Business flow | Active | Clan joining |

| CreateClanForm | Business flow | Active | Clan creation |

| WaitingPage | Review surface | Active | TRUE REVIEW PAGE |

| ResultPage | UX surface | Active | Outcome clarity |

| ElderAssistButton | Guidance | Active | Explicit help |

| AttentionZone | Attention | Active | Focus anchor |

| attentionOrchestrator | Attention | Active | Focus continuity |

| guidedProgressionService | Guidance | Active | Guided flow |

| TTS Provider | Guidance | Active | Audio reinforcement |

| navigationLifecycle.service.js | Lifecycle | Active | Navigation semantics |

| validationGate.service.js | Validation | Active | Transition authority |

| runtimeInvalidation.service.js | Lifecycle | Active | Stale runtime prevention |

| lifecycleContext | Orchestration | Active | Transition continuity |

| lastAttentionMessage | Attention | Active | Context restoration |

\---

\# A.8 Component Dependency Map

\`\`\`txt

AuthPage

 ├── RegisterForm

 ├── JoinClanForm

 ├── CreateClanForm

 ├── WaitingPage

 ├── lifecycleContext

 ├── validationGate.service

 └── navigationLifecycle.service

\`\`\`

\---

\#\# Attention Dependencies

\`\`\`txt

AttentionZone

      ↓

attentionOrchestrator

      ↓

lastAttentionMessage

\`\`\`

\---

\#\# Guidance Dependencies

\`\`\`txt

guidedProgressionService

      ↓

ElderAssistButton

      ↓

TTS Provider

\`\`\`

\---

\#\# Lifecycle Dependencies

\`\`\`txt

navigationLifecycle.service

            ↓

runtimeInvalidation.service

            ↓

lifecycle-safe forms

\`\`\`

\---

\# A.9 Ownership Reference Table

| Concern | Owner |

|---|---|

| Navigation | AuthPage |

| Validation approval | validationGate |

| Runtime validity | lifecycle layer |

| Attention continuity | attentionOrchestrator |

| Guidance | guidance layer |

| Review semantics | WaitingPage |

| Local rendering | Child forms |

| Business correctness | Existing flows/backend |

\---

\# A.10 Q1–Q8 Quick Reference

| Rule | Meaning |

|---|---|

| Q1 | Preserve working business flow |

| Q2 | Preserve UX/UI unless intentional |

| Q3 | Prefer anchor-level patch |

| Q4 | AuthPage is orchestration root |

| Q5 | Child forms do not own navigation |

| Q6 | WaitingPage \= TRUE REVIEW PAGE |

| Q7 | Validation before transition |

| Q8 | Draft ≠ runtime state |

\---

\# A.11 Known High-Risk Regression Areas

Future contributors should be extremely careful around:

\#\#\# WaitingPage edit return

Risk:

stale state.

\---

\#\#\# lifecycle ordering

Risk:

invisible trust regression.

\---

\#\#\# validation timing

Risk:

punitive UX.

\---

\#\#\# child navigation

Risk:

behavior drift.

\---

\#\#\# orchestration boundaries

Risk:

fragmentation.

\---

\#\#\# runtime invalidation

Risk:

unexpected persistence.

\---

\#\#\# attention continuity

Risk:

elder confusion.

\---

\# A.12 UAT PASS Snapshot (EGAL-6.5)

| Flow | Status |

|---|---|

| RegisterForm | PASS |

| JoinClanForm | PASS |

| CreateClanForm | PASS |

| WaitingPage review | PASS |

| Edit return | PASS |

| Stale validation fix | PASS |

| Lifecycle safety | PASS |

| AuthPage orchestration | PASS |

\---

\# A.13 Future Maintainer Quick Start

If continuing EGAL:

Recommended reading order:

\#\#\# 1

PART I — Executive Summary

\---

\#\#\# 2

PART VI — Design Doctrines

\---

\#\#\# 3

PART VII — Current Technical Architecture

\---

\#\#\# 4

PART VIII — Remaining Technical Debt

\---

\#\#\# 5

PART X — Forward Roadmap

\---

Then:

\#\#\# Hardening UAT

before:

\#\#\# UX changes

\---

\# A.14 One-Page EGAL Summary

EGAL is:

\> a confidence-preserving orchestration architecture

for:

\> elderly-first genealogy interaction.

Its mission is:

\> preserve trust without breaking business correctness.

Its architecture depends on:

\#\#\# centralized orchestration

\---

\#\#\# lifecycle safety

\---

\#\#\# authoritative validation

\---

\#\#\# TRUE REVIEW PAGE

\---

\#\#\# guided progression

\---

\#\#\# attention recovery

\---

Its greatest lesson:

\> technically correct systems can still feel unsafe.

And for elderly users:

\> unsafe often means abandonment.

\---

\#\# A.15 Appendix Conclusion

This appendix should function as:

\> rapid architecture orientation.

If the rest of the Architecture Bible explains:

\> \*\*why EGAL exists\*\*

This appendix explains:

\> \*\*what EGAL currently is\*\*

in a form suitable for:

\> future continuation without context loss.

\---

## \# END OF APPENDIX — TIMELINE & KEY COMPONENTS

# 02\_EGAL\_6.5.5\_Hardening\_UAT

## 02\_EGAL\_6.5.5\_Hardening\_UAT.md

# **PART I — Mission, Scope & Hardening Philosophy**

---

# **1\. Executive Summary**

EGAL-6.5.5 không phải là một sprint phát triển tính năng mới. Đây là giai đoạn:

```
hardening
```

— tức là xác minh và làm cứng kiến trúc đã hình thành trong các sprint trước.

Nếu EGAL-6.1 → EGAL-6.5 là giai đoạn:

```
architecture emergence
```

thì EGAL-6.5.5 là giai đoạn:

```
architecture verification
```

Mục tiêu cốt lõi của sprint này không phải:

```
“thêm chức năng”
```

mà là:

```
“chứng minh rằng kiến trúc lifecycle hiện tại thật sự ổn định”
```

trước khi được phép tiến sang:

```
EGAL-6.6 — UX Polish
```

hoặc:

```
EGAL-7.x
```

Nếu không thực hiện hardening đầy đủ, toàn bộ hệ thống có nguy cơ rơi vào trạng thái:

```
works in demo,
fails in reality
```

đặc biệt đối với:

```
elder-first UX
```

nơi người dùng thường:

```
- quay đi quay lại
- sửa nhiều lần
- nhầm thao tác
- không đi theo happy path
- có hành vi sử dụng không dự đoán trước
```

Do đó:

```
EGAL-6.5.5 là sprint mang tính kiến trúc bắt buộc.
```

---

# **2\. Why Hardening Is Necessary**

## **2.1. The Illusion of “Feature Complete”**

Sau EGAL-6.5, hệ thống có vẻ:

```
“đã xong”
```

vì:

```
✓ WaitingPage hoạt động
✓ ResultPage hoạt động
✓ JoinClanForm hoạt động
✓ CreateClanForm hoạt động
✓ guided progression hoạt động
✓ attention recovery hoạt động
✓ lifecycle reconstruction hoạt động
```

Tuy nhiên:

```
functional ≠ reliable
```

Một flow có thể:

```
chạy đúng 80% thời gian
```

nhưng:

```
sụp đổ ở 20% edge cases
```

mà chính các edge cases đó lại là:

```
elder reality
```

Ví dụ:

### **Happy path**

```
Register
→ fill đúng
→ WaitingPage
→ Submit
```

thường:

```
không gây lỗi
```

Nhưng elder thực tế thường:

```
Register
→ nhập sai
→ sửa
→ quay lại
→ sửa lần nữa
→ đổi ý
→ đổi phone
→ quay WaitingPage
→ edit
→ submit
```

và chính ở đây:

```
stale state bugs
```

đã từng xuất hiện.

---

## **2.2. UAT đã chứng minh điều gì?**

EGAL không phát triển theo:

```
design-first
```

mà thực tế phát triển theo:

```
UAT-driven architecture
```

Một số discovery quan trọng:

### **Discovery A**

Thông báo lỗi không nằm vùng chú ý.

Kết quả:

```
AttentionZone architecture
```

---

### **Discovery B**

WaitingPage không review được.

Kết quả:

```
TRUE REVIEW PAGE
```

---

### **Discovery C**

Form validation stale.

Ví dụ:

```
S0 invalid
→ S1 valid
→ user mutate field
→ submit still passes
```

Kết quả:

```
validationGate.service.js
runtimeInvalidation.service.js
navigationLifecycle.service.js
```

---

### **Discovery D**

Form quay lại sai trạng thái chú ý.

Ví dụ:

```
WaitingPage → Edit
```

không quay về:

```
step 1/4
```

mà:

```
step 3/4
```

Kết quả:

```
runtime reconstruction doctrine
```

---

## **2.3. Why This Cannot Be Deferred**

Nếu bỏ qua hardening:

và nhảy thẳng sang:

```
UI polish
```

hoặc:

```
EGAL-7.x
```

thì:

```
technical debt sẽ bị cement hóa
```

Nói cách khác:

```
càng polish,
càng khó sửa bug nền
```

Ví dụ:

Nếu:

```
stale validation
```

chưa được chứng minh hết:

nhưng:

```
WaitingPage UI redesign
```

đã triển khai,

thì:

```
root cause debugging
```

sẽ khó hơn rất nhiều vì:

```
UI noise che khuất logic defect
```

Do đó:

```
hardening phải diễn ra trước polish.
```

---

# **3\. Hardening Philosophy**

EGAL-6.5.5 dựa trên một triết lý rất đơn giản:

```
prove architecture under stress
```

nghĩa là:

```
không test happy path
```

mà test:

```
failure path
chaotic path
elder path
re-entry path
mutation path
```

---

## **3.1. The Elder Reality Principle**

Một nguyên tắc hình thành từ UAT:

```
elder users are nonlinear users
```

Người dùng cao tuổi:

```
không sử dụng hệ thống tuyến tính.
```

Họ thường:

```
- quay lại
- đổi ý
- sửa sau khi hoàn thành
- quên thao tác
- nhập rồi xoá
- submit nhiều lần
```

Vì vậy:

```
happy-path success
```

không có giá trị lớn.

Điều cần chứng minh là:

```
system survives nonlinear interaction
```

---

## **3.2. Hard Validation Before Transition**

Doctrine mới hình thành:

```
NO TRANSITION WITHOUT AUTHORITATIVE VALIDATION
```

Điều này có nghĩa:

Không một transition nào được phép xảy ra dựa trên:

```
UI impression
```

Ví dụ:

Sai:

```
button enabled
→ assume valid
```

Đúng:

```
button pressed
→ validationGate
→ fresh online validation
→ authoritative decision
→ transition
```

---

## **3.3. Draft Values ≠ Runtime State**

Một discovery cực kỳ quan trọng.

Sai lầm phổ biến:

```
restore everything
```

bao gồm:

```
completedFields
activeField
validation state
online validation state
```

Kết quả:

```
ghost completion
stale validation
fake progress
```

Doctrine mới:

### **Preserve**

```
draft values
```

### **Recompute**

```
runtime authority
```

Ví dụ:

Khi:

```
WaitingPage → Edit
```

được phép giữ:

```
phone
email
note
description
```

Nhưng phải:

```
recompute:
guided progression
validation
attention
online uniqueness
```

---

## **3.4. AuthPage Remains Orchestration Root**

Một rẽ nhánh kiến trúc rất lớn.

Ban đầu nhiều logic có xu hướng trôi vào:

```
JoinClanForm
CreateClanForm
```

Nhưng UAT cho thấy:

```
distributed navigation authority
```

gây:

```
mental confusion
```

cho elder.

Kiến trúc mới:

```
AuthPage
    ↓
RegisterForm
    ↓
Child forms
```

trong đó:

```
AuthPage = orchestration authority
```

Child forms:

```
consume orchestration
```

không:

```
own orchestration
```

---

# **4\. Scope of EGAL-6.5.5**

Sprint này KHÔNG bao gồm:

```
UI redesign
visual polish
micro-animation refinement
style optimization
```

Sprint này CHỈ tập trung:

## **Category A — Lifecycle Stability**

Ví dụ:

```
WaitingPage → Edit
```

---

## **Category B — Validation Integrity**

Ví dụ:

```
S0 → S1 → S2
```

không được:

```
stale pass
```

---

## **Category C — Navigation Predictability**

Ví dụ:

```
Register ↔ Login
Join ↔ Create
```

phải:

```
predictable
```

---

## **Category D — Elder Recovery Behavior**

Ví dụ:

```
wrong action
→ recover safely
```

---

## **Category E — Regression Prevention**

Ví dụ:

Một patch mới không được làm hỏng:

```
guided progression
attention
TRUE REVIEW
```

---

# **5\. Risk Taxonomy**

EGAL-6.5.5 sử dụng risk taxonomy sau.

## **Severity 1 — Critical**

Lỗi:

```
data integrity
```

Ví dụ:

```
stale validation
wrong submit
false approval
```

Kết quả:

```
BLOCK RELEASE
```

---

## **Severity 2 — High**

Lỗi:

```
elder confusion
```

Ví dụ:

```
wrong attention restore
wrong step restore
```

Kết quả:

```
must patch before 6.6
```

---

## **Severity 3 — Medium**

Lỗi:

```
friction
```

Ví dụ:

```
not auto-scroll enough
```

Kết quả:

```
acceptable in 6.5.5
```

---

## **Severity 4 — Low**

Lỗi:

```
visual imperfection
```

Ví dụ:

```
UI ugly
spacing imperfect
```

Kết quả:

```
defer to EGAL-6.6
```

---

# **6\. Success Definition of PART I**

EGAL-6.5.5 chỉ được coi là thành công khi nhóm phát triển trả lời được:

```
Can the system survive nonlinear elder behavior?
```

Nếu câu trả lời chưa chắc chắn:

```
EGAL-6.5.5 chưa hoàn thành.
```

---

#### END OF PART I

# **PART II — Critical UAT Matrix (Core Lifecycle)**

---

# **1\. Purpose of Core Lifecycle UAT**

Mục tiêu của PART II không phải:

```
“test tính năng”
```

mà là:

```
stress-test lifecycle architecture
```

được hình thành trong:

```
EGAL-6.5
```

Nói cách khác:

```
PART II kiểm tra:
liệu kiến trúc có thật sự chịu được hành vi elder thực tế hay không.
```

---

# **2\. Testing Principle**

Mỗi test case trong PART II phải trả lời được:

```
Does the system remain truthful?
```

Trong EGAL:

```
truthful
```

nghĩa là:

```
UI state
=
runtime state
=
validation truth
=
backend expectation
```

Không được tồn tại:

```
illusion of completion
```

Ví dụ:

```
UI nói valid
runtime thực ra invalid
```

hoặc:

```
button enable
nhưng submit không được
```

hoặc tệ hơn:

```
button disabled
dù data thực ra valid
```

---

# **3\. Core Lifecycle Domains**

EGAL-6.5 lifecycle gồm 5 domain chính:

| Domain | Purpose |
| ----- | ----- |
| D1 | Runtime Reconstruction |
| D2 | Validation Authority |
| D3 | Transition Integrity |
| D4 | Attention Recovery |
| D5 | Navigation Predictability |

Mỗi domain phải pass trước khi sang:

```
EGAL-6.6
```

---

# **D1 — Runtime Reconstruction**

## **Objective**

Chứng minh:

```
Draft restore
≠
Runtime restore
```

---

## **Test Matrix D1.1**

### **WaitingPage → Edit → JoinClanForm**

### **Preconditions**

```
JoinClanForm valid
→ WaitingPage
```

### **Steps**

#### **Step 1**

Nhấn:

```
Chỉnh sửa
```

#### **Step 2**

Quan sát:

```
focus position
step coach
attention
```

### **Expected Result**

```
✓ draft values restored
✓ step = 1/4
✓ attention = first meaningful section
✓ runtime recomputed
✓ no ghost completion
```

### **Failure Meaning**

Nếu:

```
step = 3/4
```

thì:

```
runtime state stale
```

Severity:

```
HIGH
```

---

## **Test Matrix D1.2**

### **WaitingPage → Edit → CreateClanForm**

### **Expected Result**

```
✓ restore clanName
✓ restore description
✓ restore phone/email
✓ restore note
✓ return to 1/4
✓ recompute progression
```

NOT:

```
resume previous step
```

### **Failure Meaning**

Nếu:

```
2/4
3/4
```

thì:

```
guided progression authority stale
```

Severity:

```
HIGH
```

---

## **Test Matrix D1.3**

### **Register → Login → Register**

### **Preconditions**

```
partially completed RegisterForm
```

### **Steps**

```
1. Fill 40%
2. Switch Login
3. Switch Register
```

### **Expected Result**

Must be:

```
predictable
```

Có thể:

### **Strategy A**

```
draft restored
runtime recomputed
```

hoặc:

### **Strategy B**

```
full reset
```

Nhưng:

```
must be deterministic
```

NOT:

```
sometimes restored
sometimes broken
```

Severity:

```
CRITICAL
```

---

# **D2 — Validation Authority**

## **Objective**

Chứng minh:

```
validationGate
```

đã trở thành:

```
single source of truth
```

---

## **Test Matrix D2.1**

### **S0 → S1 → S2 Mutation Test**

Đây là:

```
MOST IMPORTANT TEST
```

---

### **Preconditions**

Field:

```
phone
```

online uniqueness enabled.

---

### **Steps**

#### **S0**

Nhập:

```
phone duplicated
```

Expected:

```
invalid
```

---

#### **S1**

Sửa:

```
valid phone
```

Expected:

```
valid
```

Button:

```
enabled
```

---

#### **S2**

Nhập lại:

```
duplicate phone
```

### **Expected**

Immediately:

```
runtime invalidated
```

AND:

```
submit blocked
```

WaitingPage:

```
MUST NOT OPEN
```

---

### **Failure Meaning**

Nếu:

```
WaitingPage still opens
```

thì:

```
stale validation
```

Severity:

```
CRITICAL
BLOCK RELEASE
```

---

## **Test Matrix D2.2**

### **Nullable-but-important field**

Field:

```
temp_note
```

---

### **Preconditions**

```
required
>10 chars
```

---

### **Steps**

```
1. Fill valid
2. Delete content
3. Try submit
```

### **Expected**

```
✓ progression invalidated
✓ cannot submit
✓ attention returns
```

NOT:

```
still complete
```

Severity:

```
HIGH
```

---

## **Test Matrix D2.3**

### **Async Validation Race Condition**

### **Steps**

```
1. Type phone
2. Immediately press continue
```

before:

```
online check completes
```

### **Expected**

System:

```
waits for validation
```

or:

```
blocks transition
```

NOT:

```
assume valid
```

Severity:

```
CRITICAL
```

---

# **D3 — Transition Integrity**

## **Objective**

Chứng minh:

```
No invalid transition exists
```

---

## **Test Matrix D3.1**

### **Continue button trust test**

### **Preconditions**

UI:

```
button enabled
```

---

### **Steps**

Manipulate:

```
invalid hidden field
```

then:

```
press Continue
```

### **Expected**

Must run:

```
validationGate
```

NOT:

```
trust button state
```

---

## **Test Matrix D3.2**

### **WaitingPage transition**

### **Expected**

WaitingPage only opens when:

```
fresh validation pass
```

AND:

```
online validation pass
```

AND:

```
captcha valid
```

Severity:

```
CRITICAL
```

---

# **D4 — Attention Recovery**

## **Objective**

Chứng minh:

```
attention recovery
```

không gây:

```
elder confusion
```

---

## **Test Matrix D4.1**

### **Error attention**

### **Steps**

Submit invalid.

### **Expected**

Attention:

```
moves to failure area
```

AND:

```
visible without scroll
```

---

## **Test Matrix D4.2**

### **Success attention**

### **Steps**

Submit valid.

### **Expected**

ResultPage:

```
success region
=
attention center
```

NOT:

```
off-screen
```

---

## **Test Matrix D4.3**

### **WaitingPage → Edit**

### **Expected**

Attention:

```
return to first reviewable section
```

NOT:

```
last active field
```

Severity:

```
HIGH
```

---

# **D5 — Navigation Predictability**

## **Objective**

User must feel:

```
system behaves consistently
```

---

## **Test Matrix D5.1**

### **Join ↔ Create switch**

### **Steps**

```
Join partial
→ Create
→ Join
```

### **Expected**

Chosen behavior:

```
deterministic
```

Must not feel:

```
random
```

---

## **Test Matrix D5.2**

### **Login ↔ Register**

### **Expected**

No:

```
ghost state
```

No:

```
unexpected persistence
```

---

## **Test Matrix D5.3**

### **Multiple Back-and-Forth**

Simulate elder behavior:

```
Register
→ Waiting
→ Edit
→ Waiting
→ Edit
→ Login
→ Register
→ Continue
```

### **Expected**

Still:

```
stable
```

Severity:

```
CRITICAL
```

---

# **4\. Severity Rules**

## **BLOCK RELEASE**

If ANY:

```
stale validation
wrong transition
fake completion
invalid WaitingPage transition
```

exists.

---

## **PATCH BEFORE 6.6**

If:

```
attention confusion
wrong step restore
unpredictable recovery
```

exists.

---

## **ACCEPTABLE TEMPORARILY**

```
ugly UI
minor spacing
animation roughness
```

Deferred:

```
EGAL-6.6
```

---

# **5\. Exit Condition for PART II**

PART II only passes if:

```
ALL CRITICAL TESTS PASS
```

without:

```
manual workaround
```

because:

```
elder users never apply developer workaround.
```

---

#### END OF PART II

# **PART III — HARDENING WORKSTREAM**

---

# **3.1 Workstream Philosophy**

EGAL-6.5.5 hardening follows a simple rule:

Fix friction without disturbing validated behavior.

This means:

We are **not redesigning LoginForm**.

We are strengthening:

* clarity  
* reassurance  
* focus guidance  
* runtime safety  
* elder confidence

All changes in this sprint must satisfy:

## **Stability First**

If a proposed improvement introduces risk to:

* orchestration  
* lifecycle  
* navigation  
* validation authority

then:

reject the change.

EGAL-6.5 PASS remains the architectural baseline.

---

# **3.2 LoginForm Hardening**

## **Problem Statement**

UAT confirmed:

Login technically works.

However:

interaction confidence is weaker than desired.

Primary problems:

### **P1 — Result message outside attention zone**

### **P2 — Success lacks emotional closure**

### **P3 — Failure visibility inconsistent**

### **P4 — Repeated submission risk**

### **P5 — Elder attention not guided**

---

## **Hardening Goal**

Transform LoginForm from:

technically functional

to:

psychologically reassuring

without changing:

* business flow  
* AuthPage orchestration  
* validation authority  
* routing lifecycle

---

# **3.3 Attention Management Layer**

## **Problem**

After submit:

user attention remains at:

### **button location**

while result appears:

### **elsewhere**

This creates:

visual separation between action and consequence.

For elderly users:

this is dangerous UX.

Because:

the system feels unresponsive.

---

## **Hardening Principle**

After major action:

attention must be intentionally guided.

Not forced.

Guided.

The user should naturally understand:

“The system is talking to me here.”

---

## **Required Behavior**

After login submission:

system should gently shift attention toward:

### **result zone**

through:

### **visual focus**

### **controlled viewport positioning**

### **contextual emphasis**

without abrupt motion.

---

## **Design Constraint**

Avoid:

### **aggressive auto-scroll**

because sudden motion creates anxiety.

Avoid:

### **hidden messages**

because invisibility creates confusion.

Avoid:

### **modal interruption**

because modals feel punitive.

Preferred pattern:

gentle attention relocation.

---

## **Implementation Intent**

When important message appears:

UI should ensure:

### **message enters visible zone**

and becomes:

### **central attention point.**

This can be achieved through:

* controlled scrollIntoView  
* focus anchoring  
* visible state emphasis

But must remain:

lifecycle-safe.

Meaning:

Never depend on timing guesses.

Bad:

```
setTimeout(() => scroll(), 300)
```

Good:

React lifecycle-driven synchronization.

---

## **Success Criteria**

After pressing:

Đăng nhập

user immediately perceives:

### **“something happened”**

without searching.

without guessing.

without scrolling manually.

---

# **3.4 Login Success Reassurance Layer**

## **UAT Discovery**

Failure has emotional clarity.

Success does not.

This creates imbalance.

User psychology becomes:

“I know when it failed, but I’m not sure when it succeeded.”

This is unacceptable in elder UX.

---

## **Hardening Principle**

Success must feel:

### **calm**

### **explicit**

### **reassuring**

But never:

### **flashy**

### **childish**

### **over-animated**

### **celebratory**

EGAL tone:

respectful reassurance.

---

## **Required Success Behavior**

On successful login:

system must provide:

### **visible acknowledgement**

before transition.

User should mentally register:

“Đăng nhập thành công.”

before screen changes.

---

## **Timing Philosophy**

Success acknowledgement must exist long enough for:

### **recognition**

but not long enough to feel:

### **slow**

or:

### **blocked**

This balance is critical.

---

## **Design Guidance**

Preferred interaction:

### **clear confirmation**

### **stable visual region**

### **soft confidence signal**

Potential support:

* subtle visual confirmation  
* success voice cue  
* focus retention  
* confirmation state

Avoid:

### **large success modal**

Avoid:

### **forced confirmation click**

Avoid:

### **artificial delay**

---

## **Runtime Safety Rule**

Success feedback must never:

interfere with:

### **AuthPage orchestration**

Meaning:

LoginForm may display reassurance.

But:

AuthPage still owns:

### **navigation authority**

### **authenticated state transition**

### **lifecycle progression**

Child form must remain passive.

---

## **Success Criteria**

User experiences:

### **certainty**

before redirect.

No ambiguity.

No repeated click.

No doubt.

---

# **3.5 Failure State Hardening**

## **UAT Observation**

Error communication quality varies.

Some errors are:

### **loud**

Others are:

### **subtle**

### **easy to miss**

### **weakly contextualized**

This inconsistency reduces trust.

---

## **Hardening Principle**

Failure must always be:

### **visible**

### **understandable**

### **actionable**

---

## **Visibility Requirement**

Critical errors must appear in:

### **attention-safe zone**

Meaning:

never hidden below fold.

never visually detached.

never ambiguous.

---

## **Understanding Requirement**

Messages must reduce interpretation burden.

Bad:

Login failed

Weak:

Incorrect credentials

Good:

Không đúng email/số điện thoại hoặc mật khẩu.

Better:

Vui lòng kiểm tra lại thông tin và thử lại.

Elder-friendly systems explain:

what happened

and:

what to do next.

---

## **Emotional Tone Rule**

Error messaging should never feel:

### **accusatory**

Bad:

You entered wrong password.

Better:

Thông tin đăng nhập chưa chính xác.

Tone matters.

Especially for seniors.

EGAL avoids:

shame-based UX.

---

## **Retry Guidance**

Failure messaging should reduce panic behavior.

User must understand:

### **retry is allowed**

or:

### **waiting is required**

depending on context.

Example:

Bad:

Too many requests.

Better:

Bạn đã thử quá nhiều lần. Vui lòng chờ 15 phút trước khi thử lại.

The system must communicate:

### **expectation**

not merely failure.

---

## **Success Criteria**

User immediately understands:

1. what failed  
2. why it likely failed  
3. what to do next

without confusion.

---

# **3.6 Submission Safety Layer**

## **UAT Discovery**

Unclear system state encourages:

### **repeated clicking**

This behavior is common among seniors.

Especially when:

response visibility is weak.

---

## **Hardening Principle**

After submit:

system state must become:

unmistakably active.

User should understand:

### **“The system is working.”**

without wondering:

### **“Should I click again?”**

---

## **Required Behavior**

During processing:

prevent accidental duplicate submission.

Must include:

### **button protection**

### **state clarity**

### **interaction feedback**

---

## **Design Constraint**

Protection must not feel:

### **punitive**

### **broken**

### **frozen**

User should feel:

temporarily protected

not blocked.

---

## **Runtime Rule**

Submission protection must derive from:

### **authoritative async state**

Never from:

### **guessed timing.**

Bad:

```
setTimeout(() => enableButton(), 2000)
```

Good:

```
finally {
 setSubmitting(false)
}
```

Runtime truth:

state drives UI.

Not timers.

---

## **Success Criteria**

User naturally waits.

Duplicate clicks become unlikely.

No confusion.

No panic resubmission.

---

# **3.7 Accessibility Safety Layer**

## **Core Principle**

Accessibility is not decoration.

In EGAL:

accessibility IS business logic.

If an elder cannot understand the interface:

the feature functionally failed.

---

## **Accessibility Priorities**

### **Priority 1 — Visibility**

Important information must be:

### **immediately noticeable**

This includes:

* errors  
* success states  
* guidance  
* warnings

---

### **Priority 2 — Attention Anchoring**

System should gently direct:

### **visual focus**

toward:

### **meaningful content**

Never assume:

user will notice it.

---

### **Priority 3 — Readability**

Avoid:

* dense wording  
* technical jargon  
* compact paragraphs

Prefer:

### **short instruction patterns**

### **reassuring language**

### **clear action cues**

---

### **Priority 4 — Predictability**

Elder users rely on consistency.

If behavior changes unexpectedly:

confidence drops.

Therefore:

feedback patterns must remain:

### **stable**

across flows.

---

### **Priority 5 — Emotional Safety**

Interface should reduce:

### **embarrassment**

### **fear**

### **uncertainty**

EGAL UX tone:

respectful assistance

never:

user blame.

---

## **Success Criteria**

User feels:

### **guided**

not tested.

### **supported**

not confused.

---

# **3.8 Runtime Protection Layer**

## **Philosophy**

Hardening must improve reliability.

Never introduce fragility.

---

## **Runtime Risks To Prevent**

### **Race conditions**

### **stale state**

### **unmounted updates**

### **duplicate submit**

### **transition inconsistency**

### **lifecycle desynchronization**

---

## **Protection Rule \#1**

All async UI updates must remain:

lifecycle-aware.

Meaning:

no updates after unmount.

---

## **Protection Rule \#2**

Transitions must remain:

orchestration-driven.

AuthPage stays authoritative.

---

## **Protection Rule \#3**

Validation before transition.

Always.

No transition into invalid state.

---

## **Protection Rule \#4**

Derived UI state must never become:

source of truth.

Example:

Bad:

```
if (showSuccess)
```

drives navigation.

Good:

authenticated runtime state

drives navigation.

---

## **Protection Rule \#5**

Cleanup is mandatory.

Transient states must reset safely.

Especially:

* error state  
* loading state  
* timers  
* voice prompts  
* focus state

---

## **Expected Outcome of Runtime Hardening**

System becomes:

### **calmer**

### **safer**

### **harder to break**

while remaining:

### **architecturally unchanged**

---

## **PART III EXIT CONDITION**

EGAL-6.5.5 Login hardening is complete when:

### **users stop missing messages**

### **success feels explicit**

### **failure feels understandable**

### **duplicate submit risk decreases**

### **accessibility improves**

### **runtime remains stable**

AND

### **EGAL-6.5 architecture remains untouched**

# **PART IV — IMPLEMENTATION WORKSTREAMS & FILE-LEVEL CHANGES**

---

# **4.1 Sprint Objective**

EGAL-6.5.5 is a:

precision hardening sprint.

Meaning:

We do not broadly refactor.

We implement:

targeted improvements driven directly by UAT.

Changes must be:

### **minimal-risk**

### **architecture-safe**

### **psychologically meaningful**

### **easy to validate**

This sprint favors:

surgical fixes over ambitious redesign.

---

# **4.2 Primary Workstreams**

EGAL-6.5.5 consists of:

### **WS-1 — Login Attention Management**

### **WS-2 — Login Success Reassurance**

### **WS-3 — Error Visibility Hardening**

### **WS-4 — Submission Safety Protection**

### **WS-5 — Accessibility Safety Improvements**

### **WS-6 — Runtime Resilience Hardening**

Each workstream has:

* clear scope  
* file ownership  
* success criteria  
* regression constraints

---

# **WS-1 — LOGIN ATTENTION MANAGEMENT**

---

## **4.3 Problem Statement**

UAT showed:

important feedback appears:

outside immediate attention region.

Result:

elder users may miss:

### **login result**

### **guidance**

### **failure message**

### **success state**

This creates:

interaction uncertainty.

---

## **4.4 Objective**

Ensure:

after submit

the user's attention naturally reaches:

result region.

without:

### **confusion**

### **abrupt movement**

### **visual shock**

---

## **4.5 Target Files**

### **Primary**

```
src/components/auth/LoginForm.jsx
```

### **Possible Supporting**

```
src/components/common/MessageAlert.jsx
```

OR

shared feedback component.

(depending on actual EGAL implementation)

---

## **4.6 Required Change**

Introduce:

### **message focus anchoring**

when critical feedback appears.

Meaning:

When:

* login error  
* login success  
* lockout warning  
* validation warning

appears,

system should ensure:

### **message visibility.**

---

## **Implementation Direction**

Preferred:

### **ref-based focus region**

Possible mechanisms:

```
messageRef
scrollIntoView
focus container
aria-live reinforcement
```

But:

must be lifecycle-safe.

---

## **Strict Constraint**

NO:

random timeout-based scrolling.

Forbidden pattern:

```
setTimeout(() => {
 ref.current?.scrollIntoView()
}, 500)
```

Why forbidden?

Because:

timing assumptions fail under:

* slow devices  
* rerender timing  
* async state delay

EGAL runtime must remain deterministic.

---

## **Success Criteria**

During UAT:

After pressing:

Đăng nhập

user instantly notices:

### **feedback area**

without manual searching.

---

## **Regression Risk**

### **LOW**

if implemented via:

passive visibility improvement.

### **HIGH**

if coupled to navigation lifecycle.

Do not attach:

attention logic

to:

### **authentication transition.**

---

# **WS-2 — LOGIN SUCCESS REASSURANCE**

---

## **4.7 Problem Statement**

Success currently lacks:

emotional closure.

Failure:

feels explicit.

Success:

feels implicit.

This creates uncertainty.

---

## **Objective**

Provide:

### **calm certainty**

before transition.

User must understand:

“Đăng nhập thành công.”

without requiring interpretation.

---

## **Target Files**

### **Primary**

```
src/components/auth/LoginForm.jsx
```

### **Supporting**

Potential:

```
src/hooks/useVoiceFeedback.js
```

or equivalent audio system.

---

## **Required Change**

Introduce:

### **success acknowledgement state**

before orchestration transition.

This may include:

### **visible confirmation**

AND/OR

### **soft voice confirmation**

depending on existing EGAL audio model.

---

## **UX Tone Requirement**

Must feel:

### **respectful**

### **quiet**

### **reassuring**

NOT:

### **gamified**

### **celebratory**

### **childish**

Forbidden examples:

❌ giant success popup

❌ confetti

❌ forced confirmation modal

❌ “Success\!\!\! 🎉”

Correct EGAL tone:

“Đăng nhập thành công.”

Simple.

Certain.

Respectful.

---

## **Architectural Rule**

LoginForm:

may present reassurance.

But:

must NOT own redirect timing.

Authority remains:

### **AuthPage**

This is non-negotiable.

---

## **Success Criteria**

UAT participant clearly perceives:

### **successful login**

before transition occurs.

No:

“Không biết đã vào chưa.”

---

## **Regression Risk**

### **MEDIUM**

Because:

timing interactions with AuthPage may accidentally regress.

Requires careful verification.

---

# **WS-3 — ERROR VISIBILITY HARDENING**

---

## **4.8 Problem Statement**

Error experience lacks consistency.

Some errors are:

### **obvious**

Others:

### **hidden**

### **subtle**

### **insufficiently actionable**

---

## **Objective**

Create:

predictable failure communication.

Meaning:

All important failures should feel:

### **equally visible**

### **equally understandable**

---

## **Target Files**

### **Primary**

```
src/components/auth/LoginForm.jsx
```

### **Secondary**

Potential:

```
src/utils/authErrorMapper.js
```

or centralized error normalization layer.

---

## **Required Change**

Normalize:

### **error messaging hierarchy**

Each error should provide:

## **Level 1 — What happened**

Example:

Thông tin đăng nhập chưa chính xác.

---

## **Level 2 — What to do next**

Example:

Vui lòng kiểm tra lại và thử lại.

---

## **Level 3 — Constraint (if applicable)**

Example:

Bạn cần chờ 15 phút trước khi thử tiếp.

---

## **Priority Errors**

Must be hardened first:

### **Invalid credentials**

### **Account not found**

### **Wrong password**

### **Rate limit**

### **Locked state**

### **Network interruption**

### **Server unavailable**

---

## **Messaging Rule**

Never expose:

technical implementation.

Bad:

Firebase Auth Error: auth/too-many-requests

Correct:

Bạn đã thử quá nhiều lần. Vui lòng thử lại sau 15 phút.

---

## **Success Criteria**

UAT user understands:

### **failure reason**

AND

### **next step**

without assistance.

---

## **Regression Risk**

### **LOW**

If messaging layer only.

### **HIGH**

If validation ownership changes.

Do not move validation authority.

---

# **WS-4 — SUBMISSION SAFETY PROTECTION**

---

## **4.9 Problem Statement**

Uncertainty causes:

### **repeated clicking.**

Common elder behavior:

“Không thấy gì xảy ra, bấm lại.”

This may trigger:

### **duplicate submit**

### **request stacking**

### **emotional frustration**

---

## **Objective**

Make processing state:

unmistakably visible.

while preventing:

### **accidental duplicate action.**

---

## **Target Files**

### **Primary**

```
src/components/auth/LoginForm.jsx
```

---

## **Required Change**

During async submit:

Button becomes:

### **temporarily protected**

Must clearly communicate:

### **processing state.**

Examples:

Allowed:

```
Đang đăng nhập...
```

Disabled state.

Visual stability.

---

Forbidden:

Silent freeze.

Or:

button appears broken.

---

## **Runtime Rule**

Protection derives from:

### **authoritative async state**

Example:

```
isSubmitting
loading
authPending
```

NOT:

artificial timers.

Forbidden:

```
setTimeout(() => {
 enableButton()
}, 3000)
```

---

## **Success Criteria**

User naturally waits.

Repeat clicking decreases significantly.

---

## **Regression Risk**

### **LOW**

Provided:

state reset remains safe.

---

# **WS-5 — ACCESSIBILITY SAFETY IMPROVEMENTS**

---

## **4.10 Problem Statement**

PASS UX is not yet:

elder-optimized.

Some information competes for attention.

Important cues may feel weak.

---

## **Objective**

Increase:

### **clarity**

### **visibility**

### **confidence**

without redesigning UI.

---

## **Target Files**

Potential:

```
LoginForm.jsx
RegisterForm.jsx
ForgotPasswordForm.jsx
WaitingPage.jsx
```

Only where needed.

No unnecessary expansion.

---

## **Required Improvements**

### **A. Attention Priority**

Critical information must visually outrank:

secondary content.

Meaning:

Result feedback \> decorative content.

---

### **B. Reading Simplicity**

Prefer:

short sentences.

Avoid:

multi-clause instruction overload.

---

### **C. Predictable Feedback Position**

Feedback area should remain:

### **spatially consistent.**

Avoid:

message jumping.

Because elderly users build:

visual memory.

---

### **D. Voice \+ Visual Harmony**

When voice exists:

screen should reinforce.

Not contradict.

Not lag excessively.

---

### **E. Emotional Safety**

Tone must feel:

### **supportive**

never:

### **blaming**

---

## **Success Criteria**

User feels:

### **guided**

instead of:

### **tested.**

---

# **WS-6 — RUNTIME RESILIENCE HARDENING**

---

## **4.11 Problem Statement**

Hardening must not accidentally introduce:

instability.

Historically:

EGAL instability came from:

### **lifecycle desync**

### **ownership confusion**

### **stale transitions**

### **async leakage**

---

## **Objective**

Strengthen runtime safety.

Without architecture change.

---

## **Target Files**

Potential:

```
AuthPage.jsx
LoginForm.jsx
authService.js
hooks/*
```

Only if strictly necessary.

---

## **Required Protection**

### **A. Cleanup Safety**

Prevent:

state updates after unmount.

---

### **B. Transition Stability**

AuthPage remains:

### **orchestration root.**

No exceptions.

---

### **C. Validation Authority**

Validation before transition.

Always.

---

### **D. Async State Integrity**

Loading state must always reset.

Including:

### **failure**

### **cancellation**

### **interruption**

### **edge cases**

---

### **E. Stale State Prevention**

Avoid:

old validation leaking into new attempt.

Each submission should feel:

fresh.

---

## **Success Criteria**

Runtime feels:

### **predictable**

### **calm**

### **hard to break**

during UAT stress testing.

---

# **PART IV EXIT CONDITION**

EGAL-6.5.5 implementation phase is complete when:

### **Login feedback becomes impossible to miss**

### **Success feels explicit**

### **Failure feels understandable**

### **Duplicate submit behavior decreases**

### **Accessibility noticeably improves**

### **Runtime remains lifecycle-safe**

WITHOUT:

### **breaking EGAL-6.5 PASS architecture**

# **PART V — UAT TEST PLAN & ACCEPTANCE CRITERIA**

---

# **5.1 Purpose of PART V**

PART V defines how EGAL-6.5.5 must be tested.

This is not a broad regression cycle.

It is a:

hardening validation cycle.

The question is not only:

“Does it work?”

The real question is:

“Does it feel safer, clearer, and easier for elderly users?”

Therefore, EGAL-6.5.5 UAT must validate both:

### **functional correctness**

and

### **elder confidence.**

---

# **5.2 UAT Testing Principles**

## **Principle 1 — Test With Elder Assumptions**

Assume the user may:

* read slowly  
* hesitate  
* miss subtle UI changes  
* click twice when uncertain  
* become anxious when nothing visibly changes  
* need explicit confirmation

EGAL must support this behavior.

It must not punish it.

---

## **Principle 2 — Observe Confidence, Not Only Completion**

A test is not fully passed if the user completes the flow but says:

“Tôi không chắc đã xong chưa.”

That is a partial fail.

EGAL success requires:

### **task completion**

AND

### **user certainty.**

---

## **Principle 3 — Do Not Over-Explain During Test**

During UAT, observer should not guide the user too much.

The system itself must guide.

If tester must explain:

“Thông báo nằm phía dưới, bác kéo xuống”

then the interface failed.

---

## **Principle 4 — Preserve EGAL-6.5 Baseline**

Any new failure in previously PASS flows is regression.

Hardening cannot trade:

stability

for:

polish.

---

# **5.3 UAT Scope**

## **In Scope**

### **LoginForm**

Primary focus.

Test:

* success login  
* wrong password  
* nonexistent identifier  
* too-many-attempts  
* network/server failure  
* repeated clicking  
* attention movement  
* message visibility

---

### **AuthPage**

Regression check.

Test:

* orchestration remains stable  
* transition still controlled by AuthPage  
* no child-form redirect regression

---

### **ForgotPasswordForm**

Limited regression.

Test:

* rate-limit state  
* disabled submit button behavior  
* countdown visibility  
* error message clarity

---

### **WaitingPage**

Regression check.

Test:

* review page identity remains unchanged  
* Edit → Return still works  
* no accidental loading-page regression

---

# **5.4 Out of Scope**

Do not retest every visual detail.

Do not redesign typography.

Do not expand workflow.

Do not introduce new flows.

Do not change validation ownership.

---

# **5.5 Core Acceptance Criteria**

EGAL-6.5.5 passes UAT only if all conditions below are met.

---

## **AC-1 — Login Feedback Visibility**

After pressing:

Đăng nhập

the result message must become visible without manual scrolling.

### **PASS**

User sees message immediately or naturally.

### **FAIL**

User asks:

“Thông báo ở đâu?”

or needs to scroll to find it.

---

## **AC-2 — Login Success Certainty**

After successful login:

user clearly understands:

đăng nhập thành công.

### **PASS**

User says or behaves as if success is clear.

### **FAIL**

User hesitates and asks:

“Đã vào chưa?”

---

## **AC-3 — Error Message Clarity**

For each login failure:

message must explain:

### **what happened**

and

### **what to do next.**

### **PASS**

User understands next action.

### **FAIL**

User does not know whether to retry, wait, or ask for help.

---

## **AC-4 — Duplicate Submit Protection**

During login processing:

button must prevent accidental repeated submit.

### **PASS**

Repeated clicking does not trigger duplicate request behavior.

### **FAIL**

Multiple rapid clicks create stacked actions or confusing UI.

---

## **AC-5 — Rate-Limit Communication**

When rate-limited:

system must clearly communicate:

### **user must wait**

and preferably:

### **how long.**

### **PASS**

User understands they should not continue trying immediately.

### **FAIL**

User keeps clicking because the wait requirement is unclear.

---

## **AC-6 — Runtime Stability**

No console instability:

* no state update after unmount  
* no lifecycle warnings  
* no stuck loading state  
* no stale message leakage

### **PASS**

Flow remains stable across repeated attempts.

### **FAIL**

UI becomes stuck, stale, or inconsistent.

---

## **AC-7 — Architecture Preservation**

AuthPage remains orchestration root.

Child forms do not own navigation.

### **PASS**

No child-level redirect ownership introduced.

### **FAIL**

LoginForm or child forms directly control global navigation in violation of EGAL doctrine.

---

# **5.6 LoginForm UAT Matrix**

| Test ID | Scenario | Expected Result | Pass/Fail |
| ----- | ----- | ----- | ----- |
| LF-01 | Login with valid account | Success message visible; transition stable |  |
| LF-02 | Wrong password | Error visible; user knows to check password |  |
| LF-03 | Nonexistent account | Error visible; user knows account not found / info incorrect |  |
| LF-04 | Empty required fields | Validation visible before submit transition |  |
| LF-05 | Rapidly click login button | Only one submit cycle active |  |
| LF-06 | Rate-limit state | Button protected; wait message visible |  |
| LF-07 | Network failure | Friendly error; user knows to try again later |  |
| LF-08 | Submit after previous error | Old error cleared or replaced correctly |  |
| LF-09 | Success after previous error | Success message replaces error clearly |  |
| LF-10 | Mobile viewport | Message visible without manual search |  |

---

# **5.7 ForgotPasswordForm Regression Matrix**

| Test ID | Scenario | Expected Result | Pass/Fail |
| ----- | ----- | ----- | ----- |
| FP-01 | Send reset normally | Processing state visible |  |
| FP-02 | Too many reset requests | Button disabled or protected |  |
| FP-03 | Countdown active | User sees wait state clearly |  |
| FP-04 | Countdown ends | Button becomes usable again |  |
| FP-05 | Error after retry | Message remains visible and understandable |  |

---

# **5.8 WaitingPage Regression Matrix**

| Test ID | Scenario | Expected Result | Pass/Fail |
| ----- | ----- | ----- | ----- |
| WP-01 | Register → WaitingPage | Review information visible |  |
| WP-02 | CreateClan → WaitingPage | Review page remains stable |  |
| WP-03 | JoinClan → WaitingPage | Review page remains stable |  |
| WP-04 | Edit from WaitingPage | Returns to correct form with values |  |
| WP-05 | Edit → Submit → Return | Updated data shown correctly |  |
| WP-06 | Refresh/back stress | No lifecycle crash or stale review state |  |

---

# **5.9 Observer Notes Template**

During UAT, record not only bugs.

Record hesitation.

Use this template:

```
## UAT Observation

Test ID:

User action:

Observed behavior:

Did user notice the message immediately?
- Yes / No

Did user understand what happened?
- Yes / No

Did user know what to do next?
- Yes / No

Did user click repeatedly?
- Yes / No

Emotional state:
- Calm / Unsure / Confused / Frustrated

Notes:

Conclusion:
- PASS / PARTIAL PASS / FAIL
```

---

# **5.10 Final UAT Pass Definition**

EGAL-6.5.5 is accepted when:

### **all critical LoginForm cases pass**

### **no EGAL-6.5 PASS flow regresses**

### **elderly user can perceive feedback without searching**

### **success feels explicit**

### **failure feels actionable**

### **repeat-click behavior is controlled**

### **WaitingPage remains TRUE REVIEW PAGE**

### **AuthPage remains orchestration root**

---

# **PART V EXIT CONDITION**

PART V is complete when EGAL-6.5.5 has a testable UAT checklist that validates:

### **usability**

### **accessibility**

### **confidence**

### **runtime safety**

### **architecture preservation**

# **PART VI — IMPLEMENTATION GUIDELINES & PATCH STRATEGY**

---

# **6.1 Purpose of PART VI**

PART VI defines:

how EGAL-6.5.5 must be implemented safely.

This section exists because:

historically,

many regressions were caused by:

### **“good improvements”**

implemented in:

### **dangerous ways.**

Meaning:

The problem was not:

what changed

The problem was:

how it changed.

EGAL-6.5.5 therefore follows:

hardening through controlled patching.

Not:

aggressive rewriting.

---

# **6.2 EGAL Hardening Doctrine**

Hardening means:

strengthening validated behavior.

Not replacing it.

This is the core implementation philosophy.

When modifying a PASS component:

Always ask:

“Can this be improved without changing ownership?”

If yes:

do the smaller change.

If no:

re-evaluate necessity.

---

## **Correct Mental Model**

BAD thinking:

“I can rewrite this cleaner.”

GOOD thinking:

“How do I preserve working behavior while reducing risk?”

EGAL favors:

### **predictability**

over:

### **elegance.**

---

# **6.3 Patch Hierarchy (Mandatory)**

All EGAL-6.5.5 changes must follow this hierarchy.

Always choose:

smallest safe intervention.

---

## **LEVEL 1 — Anchor-Level Patch (Preferred)**

Modify:

### **localized logic only.**

No architecture movement.

No ownership changes.

Example:

Improve LoginForm message visibility.

Patch:

```
messageRef.current?.scrollIntoView()
```

inside existing lifecycle.

No restructuring.

---

### **Use When**

Problem is:

* UI clarity  
* visibility  
* messaging  
* minor runtime protection  
* accessibility

---

### **Risk**

### **LOW**

Preferred approach.

---

## **LEVEL 2 — Localized Behavioral Patch**

Modify:

### **component behavior**

without changing:

### **architecture contracts.**

Example:

Improve submit protection.

Allowed:

```
isSubmitting
```

integration.

Forbidden:

moving submission ownership.

---

### **Use When**

Need:

### **interaction safety**

or:

### **stronger state protection.**

---

### **Risk**

### **MEDIUM**

Requires regression testing.

---

## **LEVEL 3 — Shared Utility Patch**

Modify:

shared helper layer.

Examples:

```
authErrorMapper.js
useVoiceFeedback.js
validation utils
```

---

### **Constraint**

Must remain:

backward compatible.

Never break:

existing consumers.

---

### **Risk**

### **MEDIUM–HIGH**

Requires broad validation.

---

## **LEVEL 4 — Architecture Modification (Forbidden)**

Examples:

❌ AuthPage redesign

❌ navigation ownership shift

❌ form ownership rewrite

❌ validation architecture rewrite

❌ state model replacement

❌ context migration

---

### **Status**

STRICTLY FORBIDDEN

during EGAL-6.5.5.

---

# **6.4 File Ownership Rules**

To prevent architectural confusion:

ownership boundaries are locked.

---

## **AuthPage.jsx**

### **Responsibility**

Owns:

* orchestration  
* navigation  
* authentication transitions  
* flow progression

---

### **Must NOT**

Become:

### **UI detail manager.**

AuthPage should not manage:

* alert positioning  
* scrolling  
* form accessibility micro-behavior

Those belong locally.

---

### **EGAL Rule**

AuthPage remains:

orchestration root.

Always.

---

## **LoginForm.jsx**

### **Responsibility**

Owns:

* credential capture  
* local validation  
* submit interaction  
* feedback rendering  
* attention guidance

---

### **Must NOT**

Own:

### **navigation authority.**

Forbidden:

```javascript
navigate('/dashboard')
```

inside LoginForm.

Or:

```javascript
window.location.href
```

ownership.

---

### **Allowed**

LoginForm may:

### **display reassurance.**

But transition decision remains external.

---

## **WaitingPage.jsx**

### **Responsibility**

TRUE REVIEW PAGE.

Must preserve:

### **editability**

### **reassurance**

### **confidence**

---

### **Forbidden Regression**

Turning WaitingPage into:

loading transport state.

Never reduce:

review experience.

---

## **Shared Hooks**

Examples:

```
useVoiceFeedback
useAccessibility
useValidation
```

---

### **Rule**

Shared hooks must remain:

composable

not:

orchestration owners.

No hook should secretly control:

### **navigation**

### **business progression**

---

# **6.5 LoginForm Hardening Implementation Guidance**

## **Goal**

Improve:

### **visibility**

### **certainty**

### **reassurance**

without destabilization.

---

## **Safe Pattern 1 — Ref-Based Attention Guidance**

Preferred mechanism:

```
messageRef
focusRef
scroll target
```

---

### **Why Safe**

Because:

it stays local.

No architecture movement.

No lifecycle dependency explosion.

---

### **Constraint**

Must execute:

after message state becomes available.

Never assume timing.

---

### **Anti-Pattern**

Forbidden:

```javascript
setTimeout(() => {
  scroll()
}, 400)
```

Why forbidden?

Device timing differs.

Creates:

### **race conditions.**

---

## **Safe Pattern 2 — Authoritative Loading State**

Preferred:

```
isSubmitting
authPending
loading
```

---

### **Why Safe**

UI derives from:

### **runtime truth.**

No guessing.

No duplicated state.

---

### **Anti-Pattern**

Forbidden:

```javascript
let fakeLoading = true
```

outside real async lifecycle.

Or:

timer-based loading.

---

## **Safe Pattern 3 — Message Replacement**

When new state occurs:

old message should:

### **safely replace**

not stack unpredictably.

Example:

Error → Success

should become:

### **obvious transition.**

Not:

multiple competing alerts.

---

### **Goal**

Reduce:

### **cognitive overload.**

Especially for seniors.

---

## **Safe Pattern 4 — Predictable Spatial Feedback**

Feedback should appear:

in consistent region.

Do not make alerts:

jump unpredictably.

Elder users rely on:

muscle memory.

Consistency reduces anxiety.

---

# **6.6 Accessibility Patch Guidance**

Accessibility hardening must be:

subtle but powerful.

Meaning:

Users should feel:

### **“everything became easier”**

without noticing major redesign.

---

## **Priority A — Attention Safety**

Important content must be:

### **impossible to miss.**

But avoid:

### **visual aggression.**

---

## **Priority B — Emotional Safety**

Preferred wording:

supportive

Avoid:

blame tone.

Bad:

Wrong password.

Better:

Mật khẩu chưa chính xác.

Even better:

Vui lòng kiểm tra lại mật khẩu.

---

## **Priority C — Reading Simplicity**

Avoid:

large instruction walls.

Prefer:

### **one action per sentence.**

Example:

Bad:

Không thể đăng nhập do lỗi kết nối mạng hoặc máy chủ không phản hồi. Hãy kiểm tra lại Internet rồi thử lại sau.

Better:

Không thể kết nối hệ thống.  
Vui lòng kiểm tra Internet và thử lại.

---

## **Priority D — Reinforcement**

Voice \+ visual should cooperate.

Not compete.

Not contradict.

---

# **6.7 Runtime Hardening Guidance**

## **Rule 1 — Cleanup First**

Any effect added:

must clean itself.

Examples:

* timer  
* listener  
* observer  
* speech  
* async state

---

### **Anti-Pattern**

Forbidden:

memory leaks.

Or:

state update after unmount.

---

## **Rule 2 — Fresh Submission State**

Every submit attempt must feel:

new.

Meaning:

previous state should not contaminate:

new attempt.

Avoid:

### **stale error persistence.**

unless intentional.

---

## **Rule 3 — Transition Safety**

Transition must never happen from:

### **invalid state.**

Validation remains:

### **authoritative gate.**

---

## **Rule 4 — No Hidden Async Ownership**

Avoid:

secret async logic.

Everything important should remain:

### **visible**

### **inspectable**

### **debuggable**

---

# **6.8 Regression Prevention Checklist**

Before merge:

verify:

### **AuthPage untouched architecturally**

### **Login still PASS**

### **WaitingPage unchanged philosophically**

### **validation unchanged**

### **no child navigation ownership**

### **no stale state leakage**

### **duplicate submit protected**

### **feedback visible**

### **success explicit**

### **error actionable**

---

# **PART VI EXIT CONDITION**

Implementation is approved only if:

### **improvements are meaningful**

AND

### **architecture remains untouched**

AND

### **runtime remains lifecycle-safe**

AND

### **EGAL-6.5 PASS baseline survives fully**

WITHOUT:

### **hidden regressions**

### **ownership drift**

### **accidental redesign**

# 03\_EGAL\_6.6\_UX\_Polish.md

**Project:** EGAL — *Elder Guidance & Accessibility Layer*  
 **Sprint:** EGAL-6.6  
 **Status:** UX Polish Sprint  
 **Dependency:** EGAL-6.5 PASS UAT \+ EGAL-6.5.5 Hardening Complete  
 **Architecture Baseline:** LOCKED

---

# **PART I — UX POLISH PHILOSOPHY & ELDER EXPERIENCE DOCTRINE**

---

# **1.1 Purpose of EGAL-6.6**

EGAL-6.6 exists for one reason:

make the experience feel effortless.

Important distinction:

EGAL-6.6 is **not**:

### **bug fixing**

### **hardening**

### **architecture work**

### **feature sprint**

Those were already handled in:

### **EGAL-6.5**

and:

### **EGAL-6.5.5**

EGAL-6.6 focuses on:

emotional quality.

Meaning:

The system already works.

Now it must feel:

### **calmer**

### **clearer**

### **safer**

### **easier**

### **more reassuring**

for elderly users.

---

## **Core Question of EGAL-6.6**

Not:

“Can user complete task?”

That question was answered in UAT.

The new question becomes:

“How does the user feel while completing task?”

Because:

elder users do not only evaluate:

### **outcome**

They evaluate:

### **confidence during journey.**

This distinction defines EGAL.

---

# **1.2 Why UX Polish Matters For Elder Systems**

Modern software often optimizes for:

### **speed**

### **minimalism**

### **density**

### **efficiency**

But elderly-first systems require:

### **clarity**

### **reassurance**

### **confidence**

### **predictability**

### **patience**

The UX goal changes from:

shortest interaction

to:

lowest cognitive burden.

This is a fundamental philosophical difference.

---

## **Example**

Modern UX thinking:

Fewer words \= better.

EGAL thinking:

Fewer doubts \= better.

Sometimes:

additional reassurance is superior to brevity.

Especially for seniors.

---

## **Another Example**

Typical startup UX:

Remove friction.

EGAL UX:

Remove uncertainty.

These are not the same thing.

A slightly slower interface may still be:

emotionally easier.

And therefore:

objectively better.

---

# **1.3 EGAL UX Doctrine**

EGAL-6.6 formally establishes:

Elder Experience Doctrine.

The doctrine defines:

how UX decisions are judged.

---

## **Doctrine E1 — Confidence Over Speed**

If forced to choose between:

### **faster**

or

### **more reassuring**

Choose:

### **reassurance.**

Elder users do not value:

micro-speed improvements.

They value:

### **certainty.**

Example:

Bad optimization:

Instant redirect after login success.

Why bad?

User never mentally registers success.

Better:

Small acknowledgment.

Then transition.

---

## **Doctrine E2 — Guidance Over Cleverness**

Avoid:

### **hidden interaction**

### **implicit meaning**

### **discoverability puzzles**

### **“smart” UX tricks**

Prefer:

### **obvious interaction**

### **visible affordance**

### **direct instruction**

### **guided flow**

The interface should never ask:

“Can user figure this out?”

Instead ask:

“How do we help user succeed?”

---

## **Doctrine E3 — Calmness Over Excitement**

EGAL tone is:

respectful calm.

Not:

### **energetic**

### **playful**

### **loud**

### **gamified**

Forbidden patterns:

❌ celebration overload

❌ animated distraction

❌ bouncing elements

❌ dopamine UX

❌ urgency pressure

Correct tone:

stable reassurance.

Users should feel:

### **comfortable**

not stimulated.

---

## **Doctrine E4 — Predictability Over Novelty**

Elder users build:

interface memory.

If system behaves inconsistently:

confidence drops rapidly.

Meaning:

same action should create:

same expectation.

Examples:

If feedback appears:

always place it consistently.

If button changes:

behavior must remain predictable.

Consistency reduces cognitive load.

---

## **Doctrine E5 — Redundancy Is Acceptable**

Modern UX often removes redundancy.

EGAL accepts:

meaningful repetition.

Example:

Good elder UX:

### **voice confirmation**

PLUS

### **visual confirmation**

Because:

multiple channels improve certainty.

Redundancy becomes:

### **reassurance.**

Not clutter.

---

# **1.4 UX Polish Scope**

EGAL-6.6 includes:

### **micro-interaction refinement**

### **emotional reassurance**

### **visual hierarchy polish**

### **attention guidance**

### **readability improvement**

### **flow clarity**

### **transition smoothness**

### **confidence reinforcement**

### **interaction predictability**

---

## **In Scope**

### **LoginForm polish**

### **RegisterForm polish**

### **JoinClanForm polish**

### **CreateClanForm polish**

### **WaitingPage polish**

### **feedback consistency**

### **readability improvement**

### **interaction confidence**

---

## **Out of Scope**

### **architecture changes**

### **routing redesign**

### **state management rewrite**

### **major visual redesign**

### **component ownership change**

### **business flow rewrite**

### **feature expansion**

### **new architecture experiments**

Architecture remains:

locked.

---

# **1.5 UX Success Definition**

EGAL-6.6 succeeds when:

user experiences:

### **less hesitation**

### **less confusion**

### **less uncertainty**

### **less repeated clicking**

AND

more:

### **confidence**

### **clarity**

### **reassurance**

### **calmness**

WITHOUT:

### **noticing major redesign.**

This is important.

Good UX polish often feels:

invisible.

User simply says:

“Dễ dùng hơn.”

without knowing why.

That is success.

---

# **1.6 Elder Friction Model**

EGAL-6.6 recognizes:

elder friction is different.

Not all friction is visual.

Many issues are:

### **emotional friction.**

---

## **Type A — Attention Friction**

User misses:

important information.

Examples:

* message off-screen  
* unclear focus  
* weak visibility

Result:

confusion.

---

## **Type B — Confidence Friction**

User completes action but feels:

unsure.

Examples:

* success not explicit  
* unclear completion  
* weak confirmation

Result:

repeated action.

---

## **Type C — Interpretation Friction**

User sees message but cannot easily interpret:

### **meaning**

or:

### **next step.**

Examples:

Login failed

instead of:

Vui lòng kiểm tra lại mật khẩu.

Result:

uncertainty.

---

## **Type D — Emotional Friction**

System feels:

### **intimidating**

### **punishing**

### **blame-oriented**

Result:

### **anxiety.**

Especially dangerous for elderly users.

---

## **Type E — Interaction Friction**

User unsure:

### **where to click**

### **whether system responded**

### **whether action is complete**

Result:

### **hesitation.**

---

# **1.7 EGAL UX Maturity Model**

EGAL UX maturity evolves through stages.

---

## **Level 1 — Functional**

User can technically finish.

But feels:

### **confused.**

---

## **Level 2 — Stable**

No major bugs.

But interaction still feels:

### **effortful.**

---

## **Level 3 — Understandable**

User understands:

what happened.

---

## **Level 4 — Reassuring**

User feels:

### **safe.**

### **supported.**

---

## **Level 5 — Effortless**

User no longer thinks about interface.

They simply:

accomplish task comfortably.

EGAL-6.6 targets:

### **Level 4 → Level 5\.**

---

# **1.8 UX Polish Philosophy**

EGAL-6.6 changes should feel like:

removing tiny invisible stones from a shoe.

Nothing dramatic changes.

But walking becomes:

### **easier.**

### **calmer.**

### **more natural.**

This is the spirit of UX polish.

---

# **PART I EXIT CONDITION**

EGAL-6.6 begins only after:

team fully accepts:

### **architecture is frozen**

### **hardening already completed**

### **UX—not functionality—is primary objective**

### **elder confidence becomes success metric**

### **reassurance outranks cleverness**

### **predictability outranks novelty**

### **calmness outranks excitement**

### **clarity outranks minimalism**

# **PART II — UX POLISH WORKSTREAMS**

---

# **2.1 Purpose of PART II**

PART II defines:

where UX polish will happen.

This sprint is intentionally:

highly selective.

EGAL-6.6 is not:

“improve everything.”

Because excessive polish often creates:

### **inconsistency**

### **accidental redesign**

### **architectural drift**

### **UX instability**

Instead:

EGAL-6.6 focuses only on:

high emotional impact areas.

Meaning:

small improvements that create:

### **disproportionately large confidence gains.**

---

# **2.2 UX Polish Strategy**

EGAL-6.6 follows:

friction-first prioritization.

Meaning:

we polish:

### **where elderly hesitation happens.**

Not where developers think:

“this could look nicer.”

This distinction matters.

EGAL optimizes for:

human confidence.

Not visual impressiveness.

---

## **Priority Order**

### **P1 — Confidence-critical moments**

Examples:

* Login success  
* Form submission  
* WaitingPage review  
* error recovery

---

### **P2 — High repetition moments**

Examples:

* typing forms  
* validation feedback  
* button interaction  
* repeated navigation

---

### **P3 — Emotional moments**

Examples:

* success  
* failure  
* waiting  
* uncertainty

---

### **P4 — Readability friction**

Examples:

* dense wording  
* instruction overload  
* cognitive burden

---

# **WORKSTREAM 1 — LOGIN EXPERIENCE POLISH**

---

# **2.3 Problem Statement**

Login is:

emotional gateway.

If login feels confusing:

users immediately lose confidence.

Even if everything after login works.

UAT revealed:

Login technically passes.

But emotional experience still has:

### **hesitation.**

### **uncertainty.**

### **reassurance gaps.**

---

## **Objective**

Transform Login experience into:

calm certainty.

User should feel:

### **guided**

### **informed**

### **reassured**

at every step.

---

## **Areas of Polish**

### **A. Submit Clarity**

After pressing:

Đăng nhập

system should visibly respond.

No:

“Did button work?”

moment.

Response should feel:

### **immediate**

yet:

### **calm.**

---

### **B. Success Confidence**

Success should feel:

### **acknowledged.**

Without being:

### **noisy.**

Goal:

User mentally registers:

“Đăng nhập thành công.”

before transition.

---

### **C. Failure Recovery**

Failure should feel:

### **recoverable.**

not:

### **embarrassing.**

System tone matters.

Bad feeling:

“I made mistake.”

Better feeling:

“The system is helping me try again.”

---

### **D. Reduced Hesitation**

User should never wonder:

### **what next?**

Good Login UX answers:

### **what happened**

### **what to do**

### **whether system is responding**

---

## **Expected Emotional Outcome**

User feels:

“Mọi thứ rõ ràng.”

instead of:

“Không biết có đúng chưa.”

---

# **WORKSTREAM 2 — REGISTER FORM POLISH**

---

# **2.4 Problem Statement**

Registration is cognitively heavier than login.

More fields.

More decisions.

More opportunity for fatigue.

For seniors:

long forms create:

### **anxiety.**

### **hesitation.**

### **abandonment risk.**

---

## **Objective**

Reduce:

### **cognitive burden**

without reducing:

### **information quality.**

---

## **Areas of Polish**

### **A. Input Rhythm**

Form should feel:

### **step-by-step.**

not:

### **overwhelming.**

Users should perceive:

manageable progress.

---

### **B. Validation Timing**

Validation must feel:

### **helpful.**

Never:

### **punitive.**

Bad:

error explosion after submit.

Better:

gentle guidance.

---

### **C. Error Recovery**

Recovery must feel:

### **simple.**

Users should never think:

“Phải làm lại hết à?”

Confidence preservation is critical.

---

### **D. Emotional Reinforcement**

Submission should feel:

### **meaningful.**

not:

### **risky.**

Registration often creates:

fear of making mistake.

UX should reduce this.

---

## **Expected Emotional Outcome**

User feels:

“Có vẻ làm được.”

instead of:

“Khó quá.”

---

# **WORKSTREAM 3 — JOIN CLAN FORM POLISH**

---

# **2.5 Problem Statement**

JoinClan has unique emotional risk:

uncertainty.

User may wonder:

### **chọn đúng chưa?**

### **thông tin đã đủ chưa?**

### **có nhầm gia tộc không?**

Because genealogy is:

### **emotionally meaningful.**

Mistakes feel serious.

---

## **Objective**

Increase:

### **confidence before submit.**

Especially:

### **review confidence.**

---

## **Areas of Polish**

### **A. Selection Clarity**

Chosen clan context should feel:

### **visible**

### **unmistakable.**

No ambiguity.

---

### **B. Relationship Clarity**

Family relationship wording should feel:

### **understandable.**

Avoid cognitive overload.

Avoid terminology confusion.

---

### **C. Confirmation Reassurance**

Before submission:

user should feel:

“Đúng rồi.”

WaitingPage plays major role here.

---

### **D. Edit Confidence**

User must feel:

### **safe to revise.**

No fear of breaking flow.

---

## **Expected Emotional Outcome**

User feels:

“Tôi kiểm tra được trước khi gửi.”

instead of:

“Lỡ sai thì sao?”

---

# **WORKSTREAM 4 — CREATE CLAN FORM POLISH**

---

# **2.6 Problem Statement**

CreateClan creates:

### **responsibility pressure.**

User feels:

“Mình đang tạo mới.”

This increases hesitation.

Especially:

when terminology feels formal.

---

## **Objective**

Make creation feel:

### **approachable.**

### **understandable.**

### **safe.**

---

## **Areas of Polish**

### **A. Field Confidence**

Field meaning should feel:

### **obvious.**

No guesswork.

No hidden assumptions.

---

### **B. Form Burden Reduction**

Avoid:

### **psychological heaviness.**

Form should feel:

### **manageable.**

---

### **C. Submission Confidence**

User should feel:

### **prepared.**

before commit.

WaitingPage again becomes:

### **reassurance layer.**

---

### **D. Error Recovery**

Mistakes should feel:

### **reversible.**

No panic.

---

## **Expected Emotional Outcome**

User feels:

“Tôi hiểu mình đang làm gì.”

instead of:

“Không chắc điền đúng.”

---

# **WORKSTREAM 5 — WAITINGPAGE POLISH**

---

# **2.7 Problem Statement**

WaitingPage already PASS UAT.

But:

can become emotionally stronger.

Important:

We are NOT redesigning WaitingPage.

We are strengthening:

review confidence.

---

## **Doctrine Reminder**

WaitingPage is:

TRUE REVIEW PAGE.

Never:

### **loading screen**

### **transport state**

### **fake waiting layer**

---

## **Objective**

Increase:

### **confidence before commit.**

User should feel:

### **reassured**

### **informed**

### **in control.**

---

## **Areas of Polish**

### **A. Review Clarity**

Information hierarchy should support:

### **confidence checking.**

User should quickly verify:

“Đúng chưa?”

---

### **B. Edit Safety Feeling**

Edit action should feel:

### **safe.**

not:

### **disruptive.**

---

### **C. Calm Confirmation Tone**

WaitingPage should emotionally feel:

### **stable.**

No urgency.

No pressure.

---

### **D. Decision Confidence**

Final submission should feel:

### **intentional.**

not rushed.

---

## **Expected Emotional Outcome**

User feels:

“Tôi đã xem lại kỹ.”

instead of:

“Không biết đã đúng chưa.”

---

# **WORKSTREAM 6 — FEEDBACK CONSISTENCY POLISH**

---

# **2.8 Problem Statement**

Different feedback styles create:

### **unpredictability.**

Elder users struggle when:

system tone changes unexpectedly.

---

## **Objective**

Unify:

### **feedback experience.**

Across:

* Login  
* Register  
* JoinClan  
* CreateClan  
* WaitingPage

---

## **Areas of Polish**

### **A. Message Tone**

Tone should remain:

### **respectful**

### **supportive**

### **calm**

---

### **B. Message Position**

Feedback should appear in:

### **predictable locations.**

Consistency improves memory.

---

### **C. Message Structure**

Preferred structure:

### **What happened**

### **What to do next**

Simple.

Reliable.

---

### **D. Voice \+ Visual Alignment**

No contradiction.

No mismatch.

No delayed confusion.

---

## **Expected Emotional Outcome**

User experiences:

consistency.

instead of:

unpredictability.

---

# **WORKSTREAM 7 — READABILITY POLISH**

---

# **2.9 Problem Statement**

Elder friction often comes from:

### **reading effort.**

Not logic.

Not functionality.

Just:

### **cognitive load.**

---

## **Objective**

Reduce:

### **reading fatigue.**

---

## **Areas of Polish**

### **A. Sentence Simplification**

Prefer:

short instructions.

Avoid:

nested complexity.

---

### **B. Action-Oriented Language**

Tell user:

### **what to do.**

Not merely:

### **what failed.**

---

### **C. Chunked Information**

Avoid:

wall of text.

Prefer:

### **structured readability.**

---

### **D. Reduced Interpretation Cost**

User should not need to infer meaning.

Meaning should feel:

### **obvious.**

---

## **Expected Emotional Outcome**

User feels:

“Dễ hiểu.”

instead of:

“Đọc khó quá.”

---

# **PART II EXIT CONDITION**

UX polish scope is approved when:

### **Login feels calmer**

### **Register feels lighter**

### **JoinClan feels safer**

### **CreateClan feels clearer**

### **WaitingPage feels more reassuring**

### **Feedback feels consistent**

### **Reading feels easier**

WITHOUT:

### **redesigning architecture**

### **changing business flow**

### **breaking EGAL-6.5 PASS UAT baseline**

# **PART III — MICRO-INTERACTION POLISH & ELDER ATTENTION DESIGN**

---

# **3.1 Purpose of PART III**

EGAL-6.6 recognizes an important truth:

Users do not experience:

architecture.

Users experience:

moments.

Tiny moments.

Examples:

* button response  
* message appearance  
* success confirmation  
* waiting feeling  
* error recovery  
* form confidence

These tiny moments are called:

micro-interactions.

Micro-interactions often determine:

whether a system feels:

### **frustrating**

or:

### **effortless.**

For elderly users:

their importance increases dramatically.

---

# **3.2 What Is A Good Elder Micro-Interaction?**

Modern UX often optimizes micro-interactions for:

### **delight**

### **animation**

### **novelty**

### **engagement**

EGAL optimizes for:

### **reassurance**

### **clarity**

### **predictability**

### **confidence**

This difference matters.

A good elder micro-interaction should feel:

quietly supportive.

Not:

visually exciting.

---

## **Example**

Bad modern interaction:

Tiny spinner appears.

Button fades subtly.

Nothing obvious happens.

Designer says:

elegant.

Elder user says:

“Nó có chạy chưa?”

EGAL interaction:

Button clearly changes state.

Feedback appears visibly.

User immediately understands:

“Hệ thống đang xử lý.”

That is better UX for EGAL.

---

# **3.3 Attention Design Philosophy**

One of the largest UX failures in elder systems:

assuming users will notice things.

They often do not.

Especially when:

### **attention is divided**

### **eyesight is weaker**

### **cognitive load increases**

### **screen scrolling exists**

EGAL therefore follows:

intentional attention design.

Meaning:

Important information must:

### **guide attention.**

Not compete for it.

---

## **Attention Rule A**

After important action:

attention should move toward:

### **consequence.**

Example:

Press:

Đăng nhập

User attention should naturally shift toward:

### **result.**

Not remain stuck at:

### **button location.**

---

## **Attention Rule B**

Critical information must visually outrank:

secondary information.

Meaning:

Bad:

Everything same visual priority.

Good:

Important information clearly dominates.

Examples:

### **login result**

### **warning**

### **success confirmation**

### **next instruction**

---

## **Attention Rule C**

Never force visual searching.

Elder users should never ask:

“Nó nằm ở đâu?”

Good UX means:

important content feels:

### **immediately noticeable.**

---

# **3.4 Login Micro-Interaction Polish**

Login is:

highest emotional sensitivity screen.

Therefore:

micro-interactions matter most here.

---

## **Submit Interaction**

Current emotional risk:

user presses:

Đăng nhập

and wonders:

“Có phản hồi chưa?”

Polish goal:

remove ambiguity.

---

### **Preferred Experience**

Button immediately communicates:

### **processing.**

Examples:

Allowed:

```
Đang đăng nhập...
```

Subtle state shift.

Stable feedback.

No panic.

---

### **Forbidden Experience**

No feedback.

Frozen UI.

Ambiguous state.

Tiny spinner only.

This fails elder expectations.

---

## **Success Interaction**

Success should feel:

### **acknowledged.**

But:

### **calm.**

Preferred feeling:

“Xong rồi.”

Not:

“Wow\!”

---

### **Correct Success Tone**

Examples:

Good:

Đăng nhập thành công.

Good:

Chào mừng quay lại.

Bad:

Success\! 🎉

Bad:

Awesome\! You’re in\!

Tone mismatch creates discomfort.

---

## **Error Interaction**

Failure must feel:

### **recoverable.**

Never humiliating.

Preferred emotional tone:

“Không sao, thử lại nhé.”

Even if not literally written.

System personality matters.

---

# **3.5 Form Input Polish**

Forms create:

### **mental workload.**

Especially:

for elderly users.

EGAL-6.6 reduces:

invisible exhaustion.

---

## **Problem**

Long forms often feel:

### **intimidating.**

even when technically simple.

Why?

Because users mentally process:

### **uncertainty.**

Examples:

* Did I type correctly?  
* What if wrong?  
* What happens next?  
* Can I fix later?

These invisible concerns create:

### **fatigue.**

---

## **UX Goal**

Forms should feel:

manageable.

not:

demanding.

---

## **Input Confidence Principle**

Each field should feel:

### **understandable.**

Meaning:

user immediately understands:

### **what belongs here.**

No guesswork.

---

## **Validation Interaction**

Validation should feel:

### **supportive.**

not:

### **punishment.**

Bad interaction:

User submits.

Ten red errors explode.

Creates:

### **emotional collapse.**

Better:

Gentle progressive guidance.

---

## **Recovery Interaction**

Fixing error should feel:

### **easy.**

User should never fear:

“Mất hết dữ liệu.”

Confidence preservation matters.

---

# **3.6 WaitingPage Emotional Polish**

WaitingPage already functions correctly.

EGAL-6.6 improves:

emotional confidence.

Not architecture.

---

## **Emotional Role of WaitingPage**

WaitingPage psychologically answers:

“Tôi có cơ hội kiểm tra lại.”

This reduces:

### **fear of mistake.**

Especially important in:

### **genealogy context.**

Because genealogy feels:

### **personal**

### **meaningful**

### **permanent**

Users worry about:

### **family accuracy.**

---

## **UX Goal**

WaitingPage should emotionally feel:

### **calm**

### **safe**

### **editable**

### **trustworthy**

---

## **Important Principle**

Never create urgency.

Forbidden feelings:

Hurry up.

Continue quickly.

Don’t delay.

WaitingPage exists to encourage:

### **careful review.**

---

## **Review Interaction**

Review should feel:

### **effortless.**

User should quickly answer:

“Đúng chưa?”

without cognitive struggle.

---

## **Edit Interaction**

Edit button must feel:

### **safe.**

Psychological meaning:

“Tôi vẫn kiểm soát được.”

This feeling is critical.

---

# **3.7 Feedback Visibility Polish**

Feedback competes for attention.

EGAL does not allow:

competition with important information.

Important feedback must become:

### **dominant.**

---

## **Visibility Hierarchy**

Priority order:

### **P1 — Critical outcome**

Examples:

* login success  
* validation failure  
* submission issue

---

### **P2 — What to do next**

Examples:

* thử lại  
* chỉnh sửa  
* kiểm tra thông tin

---

### **P3 — Supporting information**

Examples:

secondary explanation.

---

### **P4 — Decorative content**

Always lowest priority.

---

## **UX Rule**

If decorative content visually dominates:

critical information,

then:

polish failed.

---

# **3.8 Emotional Transition Design**

Transitions matter.

Because:

state change often causes:

### **uncertainty.**

Examples:

* login → authenticated  
* form → waiting page  
* edit → return  
* submit → confirmation

---

## **Good Transition Feeling**

User understands:

### **what happened**

### **why transition happened**

### **what state they are in now**

No ambiguity.

---

## **Bad Transition Feeling**

User suddenly sees:

different screen.

And thinks:

“Sao lại sang đây?”

This causes distrust.

---

## **EGAL Transition Principle**

Every transition should feel:

### **expected.**

not:

### **surprising.**

---

# **3.9 Elder Attention Window**

Elder users often need:

### **more processing time.**

EGAL therefore respects:

attention window.

Meaning:

Important information must exist long enough to be:

### **perceived**

### **processed**

### **trusted**

But:

not long enough to feel:

### **blocking.**

Balance matters.

---

## **Example**

Bad:

Instant success redirect.

User misses message.

---

Also bad:

Long artificial pause.

Feels broken.

---

Correct:

Short confidence acknowledgment.

Then smooth progression.

---

# **3.10 UX Polish Success Signals**

EGAL-6.6 polish succeeds when:

Users:

### **stop hesitating**

### **stop re-clicking**

### **stop searching for messages**

### **stop asking “đúng chưa?”**

AND instead:

say:

“Rõ ràng hơn.”

“Dễ dùng hơn.”

“Yên tâm hơn.”

without noticing major redesign.

That is:

invisible UX success.

---

# **PART III EXIT CONDITION**

Micro-interaction polish is complete when:

### **attention feels guided**

### **feedback feels obvious**

### **forms feel lighter**

### **WaitingPage feels safer**

### **transitions feel predictable**

### **users feel calmer**

WITHOUT:

### **adding unnecessary animation**

### **redesigning architecture**

### **increasing cognitive load**

### **making UI flashy**

# **PART IV — SCREEN-BY-SCREEN UX POLISH SPECIFICATION**

---

# **4.1 Purpose of PART IV**

PART IV translates:

UX philosophy

into:

screen-level polish actions.

This section defines:

exactly where EGAL-6.6 improvements happen.

Importantly:

this is **not redesign**.

This is:

precision UX refinement.

Meaning:

same architecture.

same flow.

same ownership.

same business logic.

But:

### **less hesitation**

### **less friction**

### **more confidence**

### **calmer interaction**

---

# **4.2 UX Polish Severity Model**

Not all screens deserve equal effort.

EGAL-6.6 prioritizes screens based on:

emotional importance.

---

## **Tier 1 — Confidence Critical**

Highest UX priority.

Includes:

### **LoginForm**

### **WaitingPage**

Because these moments determine:

### **trust.**

---

## **Tier 2 — Cognitive Burden Screens**

Medium-high priority.

Includes:

### **RegisterForm**

### **JoinClanForm**

### **CreateClanForm**

Because:

they require effort.

---

## **Tier 3 — Supporting Screens**

Lower polish priority.

Only polish if friction exists.

Avoid unnecessary intervention.

---

# **SCREEN 1 — LOGINFORM UX POLISH**

---

# **4.3 LoginForm UX Goals**

LoginForm must feel:

### **immediate**

### **reassuring**

### **predictable**

### **confidence-building**

Login is:

emotional entry gate.

If login feels uncertain:

entire system trust declines.

---

## **Current State**

### **Functional PASS**

But UAT revealed:

### **hesitation moments.**

Examples:

* missed message  
* uncertainty after submit  
* success ambiguity  
* repeated click tendency

---

## **UX Goal**

Transform login feeling from:

“Không biết đúng chưa.”

to:

“Rõ ràng rồi.”

---

## **UX Polish Areas**

### **A. Message Visibility**

Important feedback should feel:

### **impossible to miss.**

System must never assume:

user will scroll.

Desired experience:

after submit:

attention naturally lands on:

### **result.**

---

### **B. Button State Confidence**

Button interaction should feel:

### **responsive.**

During submit:

button should visually communicate:

### **active processing.**

User should never think:

“Nó bị đứng à?”

---

### **C. Success Closure**

Success requires:

### **emotional completion.**

User must mentally register:

login succeeded.

before transition.

Even a tiny reassurance moment matters.

---

### **D. Error Recovery**

Failure should feel:

### **fixable.**

Never:

### **intimidating.**

User must feel:

“Thử lại được.”

not:

“Mình làm sai rồi.”

---

## **Success Signal**

Users stop asking:

“Đăng nhập được chưa?”

---

# **SCREEN 2 — REGISTERFORM UX POLISH**

---

# **4.4 RegisterForm UX Goals**

RegisterForm must feel:

### **lighter**

### **less overwhelming**

### **more guided**

Registration is emotionally harder than login.

Because:

there are:

### **more inputs**

### **more uncertainty**

### **more fear of error**

---

## **Current Risk**

Users may experience:

### **form fatigue.**

Especially seniors.

Long forms psychologically feel:

difficult.

even when not objectively difficult.

---

## **UX Goal**

Form should feel:

manageable.

---

## **UX Polish Areas**

### **A. Information Rhythm**

Information should feel:

### **progressively digestible.**

Avoid visual overload.

Form should not emotionally feel:

endless.

---

### **B. Validation Confidence**

Validation should feel:

### **helpful.**

not:

### **punishing.**

Avoid:

large simultaneous error bursts.

Preferred feeling:

“À, sửa chỗ này.”

---

### **C. Submission Confidence**

Before submit:

user should feel:

### **prepared.**

not:

### **uncertain.**

WaitingPage plays reassurance role here.

---

### **D. Error Preservation**

Users should never fear:

mất dữ liệu.

Recovery must feel:

### **safe.**

---

## **Success Signal**

User finishes form without:

visible hesitation spikes.

---

# **SCREEN 3 — JOINCLANFORM UX POLISH**

---

# **4.5 JoinClanForm UX Goals**

JoinClanForm must feel:

### **safe**

### **clear**

### **confidence-building**

Because genealogy decisions feel:

### **important.**

Users fear:

### **choosing wrong family.**

---

## **Emotional Risk**

Common emotional state:

“Nhỡ nhầm thì sao?”

This anxiety matters.

---

## **UX Goal**

Increase:

### **confidence before confirmation.**

---

## **UX Polish Areas**

### **A. Clan Context Visibility**

Selected clan should feel:

### **unmistakably visible.**

No ambiguity.

No hidden context.

---

### **B. Relationship Clarity**

Relationship terminology must feel:

### **understandable.**

Avoid jargon overload.

Avoid cognitive complexity.

---

### **C. Review Confidence**

Before submit:

user should feel:

“Mình đã kiểm tra.”

WaitingPage reinforces this.

---

### **D. Edit Safety**

Editing should feel:

### **safe.**

Psychological meaning:

“Tôi vẫn kiểm soát được.”

---

## **Success Signal**

User feels:

confident enough to continue.

without needing reassurance from others.

---

# **SCREEN 4 — CREATECLANFORM UX POLISH**

---

# **4.6 CreateClanForm UX Goals**

CreateClanForm must feel:

### **approachable.**

Creating new clan information creates:

### **responsibility pressure.**

Users fear:

### **making important mistakes.**

---

## **UX Goal**

Reduce:

### **psychological heaviness.**

without reducing:

### **seriousness.**

---

## **UX Polish Areas**

### **A. Field Meaning Clarity**

Fields should feel:

### **self-explanatory.**

User should not wonder:

“Điền gì ở đây?”

---

### **B. Form Confidence**

Progress should feel:

### **achievable.**

not:

### **intimidating.**

---

### **C. Submit Readiness**

Before submit:

user should feel:

### **ready.**

not rushed.

---

### **D. Reversibility Feeling**

Mistakes should feel:

### **recoverable.**

Confidence matters.

---

## **Success Signal**

User feels:

“Tôi hiểu việc mình đang làm.”

---

# **SCREEN 5 — WAITINGPAGE UX POLISH**

---

# **4.7 WaitingPage UX Goals**

WaitingPage is:

highest emotional leverage screen.

Because:

it transforms:

### **uncertainty**

into:

### **confidence.**

---

## **Doctrine Reminder**

WaitingPage is:

TRUE REVIEW PAGE.

Never:

### **fake loading page**

### **transport state**

### **visual delay trick**

---

## **UX Goal**

Strengthen:

### **confidence before commitment.**

---

## **UX Polish Areas**

### **A. Review Hierarchy**

Information should visually support:

### **quick checking.**

User asks:

“Đúng chưa?”

Page should answer:

“Đây, kiểm tra nhé.”

---

### **B. Calm Atmosphere**

WaitingPage must emotionally feel:

### **stable.**

No urgency.

No pressure.

No countdown energy.

---

### **C. Edit Confidence**

Edit action should feel:

### **non-destructive.**

User must trust:

“Có thể sửa lại.”

---

### **D. Confirmation Confidence**

Final action should feel:

### **intentional.**

not accidental.

---

## **Success Signal**

User voluntarily reviews.

Instead of rushing.

---

# **SCREEN 6 — FORGOTPASSWORDFORM UX POLISH**

---

# **4.8 ForgotPasswordForm UX Goals**

ForgotPassword is emotionally sensitive.

Users entering here often already feel:

### **stressed.**

### **frustrated.**

### **worried.**

Especially elderly users.

---

## **UX Goal**

Transform emotional feeling from:

“Mình gặp vấn đề rồi.”

to:

“Có cách xử lý.”

---

## **UX Polish Areas**

### **A. Recovery Clarity**

System should clearly explain:

### **next step.**

No ambiguity.

---

### **B. Rate-Limit Calmness**

When limited:

user should understand:

### **waiting is normal.**

not:

### **punishment.**

---

### **C. Countdown Confidence**

Countdown should feel:

### **informative.**

not:

### **threatening.**

---

### **D. Retry Safety**

When retry available:

user should clearly perceive:

### **system ready again.**

---

## **Success Signal**

User feels:

recovery possible.

instead of:

panic.

---

# **SCREEN 7 — CROSS-FLOW CONSISTENCY POLISH**

---

# **4.9 Goal**

All screens should emotionally feel:

same family.

Consistency reduces:

### **cognitive switching cost.**

Especially for seniors.

---

## **Consistency Areas**

### **A. Message Tone**

Tone must remain:

### **respectful**

### **calm**

### **supportive**

---

### **B. Interaction Rhythm**

Same pacing expectation.

No abrupt behavior differences.

---

### **C. Feedback Location**

Predictable placement.

Users build:

### **visual habit.**

---

### **D. Confirmation Style**

Success/failure should feel:

### **coherent.**

across screens.

---

## **Success Signal**

System feels:

familiar.

across entire flow.

---

# **PART IV EXIT CONDITION**

Screen-level UX polish is complete when:

### **Login feels reassuring**

### **Register feels lighter**

### **JoinClan feels safer**

### **CreateClan feels clearer**

### **WaitingPage feels trustworthy**

### **ForgotPassword feels recoverable**

### **entire system feels emotionally consistent**

WITHOUT:

### **redesigning architecture**

### **changing business flow**

### **increasing visual noise**

### **reducing predictability**

# **PART V — UX POLISH IMPLEMENTATION GUIDELINES & NON-NEGOTIABLE RULES**

---

# **5.1 Purpose of PART V**

PART V answers:

“How do we polish UX safely?”

Because:

bad UX polish often breaks:

### **stability**

### **consistency**

### **trust**

### **architecture**

Especially in elder systems.

Many teams accidentally turn:

UX improvement

into:

behavior regression.

EGAL-6.6 explicitly avoids this.

This section defines:

the implementation doctrine.

---

# **5.2 EGAL UX Rule \#1**

## **Preserve PASS Behavior**

Golden rule:

If it already PASS UAT, do not redesign it.

Only polish.

Meaning:

Bad approach:

“This flow feels old. Let’s rethink it.”

Correct approach:

“This flow works. Let’s reduce friction.”

---

## **Allowed**

### **visibility improvements**

### **wording improvement**

### **reassurance improvement**

### **interaction clarity**

### **accessibility enhancement**

### **readability improvement**

---

## **Forbidden**

### **navigation rewrite**

### **validation ownership changes**

### **architecture movement**

### **state management experimentation**

### **workflow redesign**

### **hidden behavioral changes**

---

# **5.3 EGAL UX Rule \#2**

## **Architecture Is Frozen**

EGAL-6.6 is:

### **UX sprint**

NOT:

### **architecture sprint.**

The following remain locked.

---

## **AuthPage Doctrine**

AuthPage remains:

orchestration root.

Always.

Still owns:

### **navigation**

### **transition lifecycle**

### **authentication progression**

### **screen orchestration**

---

### **Forbidden**

LoginForm directly owning:

```javascript
navigate()
window.location.href
router.push()
```

No exceptions.

---

## **WaitingPage Doctrine**

WaitingPage remains:

TRUE REVIEW PAGE.

Never:

### **loading placeholder**

### **fake delay screen**

### **transport mechanism**

### **transition trick**

Its purpose remains:

### **reassurance**

### **editability**

### **confidence**

---

## **Child Form Doctrine**

Forms remain:

### **controlled participants.**

Never:

### **orchestration owners.**

---

# **5.4 EGAL UX Rule \#3**

## **Calmness Before Beauty**

Modern product teams often prioritize:

### **visual impressiveness.**

EGAL prioritizes:

### **emotional ease.**

Question is not:

“Does this look modern?”

Question is:

“Does this feel easier for seniors?”

Example:

Bad polish:

Tiny elegant loading state.

Looks modern.

But unclear.

Better:

Simple obvious feedback.

Slightly less trendy.

Far more understandable.

---

## **UX Design Filter**

Before any polish:

ask:

### **Does this reduce hesitation?**

### **Does this reduce confusion?**

### **Does this increase confidence?**

### **Would an elderly user understand immediately?**

If answer is unclear:

do not implement.

---

# **5.5 EGAL UX Rule \#4**

## **No Surprise UX**

Surprise is bad for elder users.

Unexpected behavior increases:

### **anxiety.**

### **distrust.**

### **hesitation.**

Therefore:

EGAL avoids:

### **hidden interactions**

### **sudden transitions**

### **disappearing controls**

### **mysterious automation**

### **unpredictable layouts**

---

## **Correct Principle**

Interaction should feel:

expected.

Example:

Bad:

button suddenly moves.

Good:

button remains stable.

---

## **Another Example**

Bad:

message appears somewhere unexpected.

Good:

message appears in consistent location.

Predictability builds:

### **interface memory.**

---

# **5.6 EGAL UX Rule \#5**

## **Feedback Must Be Obvious**

Elder users should never ask:

“Hệ thống có phản hồi chưa?”

Critical states must be:

### **unmistakable.**

Examples:

### **submitting**

### **success**

### **failure**

### **waiting**

### **retry available**

---

## **Wrong Assumption**

Bad developer mindset:

user will notice.

No.

EGAL assumes:

system must help user notice.

---

## **Correct Feedback Pattern**

Every important action answers:

### **What happened?**

### **Is system responding?**

### **What should user do next?**

---

# **5.7 EGAL UX Rule \#6**

## **Supportive Language Only**

Tone matters.

Especially:

during failure.

System language should feel:

### **respectful**

### **calm**

### **helpful**

Never:

### **blaming**

### **technical**

### **cold**

### **punitive**

---

## **Bad Messaging**

Wrong password.

Feels accusatory.

---

## **Better Messaging**

Mật khẩu chưa chính xác.

More neutral.

---

## **Best Messaging**

Mật khẩu chưa chính xác.  
Vui lòng kiểm tra lại và thử tiếp.

This reduces:

### **emotional friction.**

---

## **Technical Error Rule**

Never expose:

technical internals.

Forbidden:

```
auth/network-request-failed
FirebaseError
500 internal error
```

Translate into:

human meaning.

---

# **5.8 EGAL UX Rule \#7**

## **Micro-Interaction Must Stay Quiet**

Micro-interactions should support.

Not distract.

Forbidden:

### **excessive animation**

### **bouncing UI**

### **flashy transitions**

### **dopamine mechanics**

### **reward effects**

### **gamification**

Wrong emotional tone.

---

## **Correct Feeling**

User should feel:

system is calm.

not:

interface is performing.

---

## **Example**

Good:

subtle stable feedback.

Bad:

animated celebration explosion.

---

# **5.9 EGAL UX Rule \#8**

## **Accessibility Over Minimalism**

Minimalism sometimes harms elder UX.

EGAL accepts:

meaningful redundancy.

Meaning:

Allowed:

### **visual confirmation**

PLUS

### **voice confirmation.**

Allowed:

### **repeated reassurance.**

Allowed:

### **explicit explanation.**

Because:

certainty matters more than visual purity.

---

## **Forbidden Minimalism**

Bad:

Hidden instruction.

Tiny icons.

Implicit meaning.

Unlabeled behavior.

Assumed knowledge.

---

## **Correct Elder UX**

Visible.

Readable.

Obvious.

Supportive.

---

# **5.10 EGAL UX Rule \#9**

## **Attention Must Be Guided**

Critical content should become:

### **natural focus point.**

Never rely on:

### **user searching.**

Examples requiring attention guidance:

### **login result**

### **validation problem**

### **retry availability**

### **waiting review**

### **confirmation**

---

## **Goal**

User should feel:

“Mình biết nhìn ở đâu.”

without thinking.

---

# **5.11 EGAL UX Rule \#10**

## **Consistency Beats Creativity**

Creative inconsistency increases:

### **learning burden.**

Elder users rely on:

### **repetition.**

### **familiarity.**

### **stable expectation.**

Therefore:

same patterns should repeat across system.

Examples:

### **same feedback style**

### **same wording structure**

### **same interaction rhythm**

### **same visual expectation**

---

## **Good UX Feeling**

User thinks:

“À, cái này giống lúc nãy.”

This reduces effort.

---

# **5.12 UX Implementation Priority Matrix**

When resources limited:

follow order:

---

## **Priority 1**

### **confidence-critical friction**

Examples:

* login ambiguity  
* missed messages  
* hesitation

---

## **Priority 2**

### **repeated confusion**

Examples:

* validation misunderstanding  
* repeated clicking  
* uncertainty loops

---

## **Priority 3**

### **readability burden**

Examples:

* long instruction  
* wording friction

---

## **Priority 4**

### **visual refinement**

Only after everything above.

Never reverse order.

---

# **5.13 UX Regression Checklist**

Before merge:

verify:

### **Login still PASS**

### **Register still PASS**

### **JoinClan still PASS**

### **CreateClan still PASS**

### **WaitingPage still TRUE REVIEW PAGE**

### **ForgotPassword stable**

### **AuthPage orchestration untouched**

### **no navigation ownership drift**

### **no validation regression**

### **no hidden async issue**

### **messages still obvious**

### **users feel calmer**

---

# **PART V EXIT CONDITION**

UX implementation is approved only when:

### **confidence increases**

### **hesitation decreases**

### **system feels calmer**

### **clarity improves**

WITHOUT:

### **architecture change**

### **hidden regressions**

### **flashy redesign**

### **business-flow modification**

# **PART VI — UX POLISH UAT, SUCCESS METRICS & SPRINT CLOSE CONDITIONS**

---

# **6.1 Purpose of PART VI**

PART VI defines:

how EGAL-6.6 will be judged successful.

Because:

UX polish is dangerous to evaluate incorrectly.

A common failure:

team ships changes and says:

“Looks better.”

But:

users still hesitate.

Or worse:

users become more confused.

EGAL rejects:

cosmetic success.

Real UX success means:

lower emotional friction.

This must be observable.

---

# **6.2 UX Success Philosophy**

EGAL-6.6 success is not:

### **prettier UI**

### **more animation**

### **more modern appearance**

### **visual redesign**

Those are:

non-goals.

Success means:

### **lower hesitation**

### **lower confusion**

### **higher confidence**

### **clearer interaction**

### **calmer emotional experience**

for elderly users.

---

## **Core Question**

Not:

“Did we improve UI?”

Ask:

“Did we improve certainty?”

Because:

certainty is the real UX currency in EGAL.

---

# **6.3 Elder UX UAT Method**

Traditional UAT asks:

“Can user finish task?”

EGAL UX UAT asks:

“How difficult did it feel emotionally?”

This difference matters.

---

## **Observe Behavior**

Do not only record:

### **technical failures.**

Observe:

### **hesitation**

### **confusion**

### **repeated clicking**

### **uncertainty**

### **visible anxiety**

### **repeated reading**

These are:

UX signals.

---

## **Example**

Task completes.

But user repeatedly asks:

“Đúng chưa?”

That is:

### **UX friction.**

Even if functionally PASS.

---

## **Observer Rule**

Avoid explaining too much.

If observer must say:

“Thông báo ở phía dưới.”

then UX failed.

System itself must guide.

---

# **6.4 EGAL UX Success Metrics**

EGAL-6.6 defines measurable success.

---

## **Metric 1 — Hesitation Reduction**

Measure:

visible pause moments.

Examples:

Before polish:

User pauses:

### **5–7 times.**

After polish:

### **1–2 times.**

Improvement confirmed.

---

### **Pass Signal**

User flows naturally.

---

### **Fail Signal**

User repeatedly stops to think:

“Giờ làm gì?”

---

## **Metric 2 — Reduced Repeat Clicking**

Measure:

duplicate interaction attempts.

Examples:

* repeated login click  
* repeated submit click  
* repeated forgot-password request

---

### **Pass Signal**

User trusts system response.

---

### **Fail Signal**

User repeatedly presses because:

feedback unclear.

---

## **Metric 3 — Feedback Recognition Speed**

Measure:

how quickly user notices:

### **message**

### **result**

### **instruction**

---

### **Pass Signal**

User sees immediately.

---

### **Fail Signal**

User searches visually.

Or asks:

“Thông báo đâu?”

---

## **Metric 4 — Success Confidence**

Measure:

whether user understands:

### **task completed.**

---

### **Pass Signal**

User naturally proceeds.

---

### **Fail Signal**

User asks:

“Xong chưa?”

---

## **Metric 5 — Error Recovery Confidence**

Measure:

user emotional reaction after error.

---

### **Pass Signal**

User calmly retries.

---

### **Fail Signal**

User freezes.

Panics.

Asks for help.

Feels intimidated.

---

## **Metric 6 — WaitingPage Confidence**

Measure:

review confidence.

---

### **Pass Signal**

User willingly reviews information.

Uses edit safely.

---

### **Fail Signal**

User rushes without confidence.

Or:

appears confused.

---

## **Metric 7 — Readability Comfort**

Measure:

reading burden.

---

### **Pass Signal**

User reads comfortably.

---

### **Fail Signal**

Repeated rereading.

Visible fatigue.

Long pauses.

---

# **6.5 UX UAT Scenario Matrix**

---

## **Scenario UX-01**

### **Login Success**

Goal:

verify confidence.

Expected:

* visible response  
* clear success  
* smooth transition

Questions:

Did user understand login succeeded?

Did user click twice?

---

## **Scenario UX-02**

### **Login Failure**

Goal:

verify recoverability.

Expected:

* understandable error  
* clear next step  
* calm retry behavior

Questions:

Did user understand problem?

Did user panic?

---

## **Scenario UX-03**

### **Register Flow**

Goal:

verify cognitive load.

Expected:

* manageable form feeling  
* low hesitation  
* understandable validation

Questions:

Did user feel overwhelmed?

---

## **Scenario UX-04**

### **JoinClan Flow**

Goal:

verify confidence.

Expected:

* safe clan selection  
* review confidence

Questions:

Did user worry excessively?

---

## **Scenario UX-05**

### **CreateClan Flow**

Goal:

verify clarity.

Expected:

* understandable process  
* low intimidation

Questions:

Did user feel lost?

---

## **Scenario UX-06**

### **WaitingPage Review**

Goal:

verify TRUE REVIEW PAGE doctrine.

Expected:

* user reviews willingly  
* edit confidence present

Questions:

Did user feel in control?

---

## **Scenario UX-07**

### **Forgot Password**

Goal:

verify emotional recovery.

Expected:

* clear recovery path  
* calm retry experience

Questions:

Did user understand next step?

---

# **6.6 Observer Checklist**

During UAT:

record:

```
## UX Observation

Screen:

Scenario:

Did user hesitate?
- Yes / No

Did user look confused?
- Yes / No

Did user re-click?
- Yes / No

Did user ask for reassurance?
- Yes / No

Did user understand next step?
- Yes / No

Emotional state:
- Calm
- Slightly Unsure
- Confused
- Frustrated

Notes:

Result:
- PASS
- PARTIAL PASS
- FAIL
```

---

# **6.7 Non-Negotiable Pass Conditions**

EGAL-6.6 cannot PASS if:

### **users still miss messages**

### **users repeatedly ask “xong chưa?”**

### **repeated clicking remains common**

### **WaitingPage feels rushed**

### **errors feel intimidating**

### **forms feel overwhelming**

### **architecture regresses**

### **AuthPage ownership changes**

### **WaitingPage doctrine breaks**

### **EGAL-6.5 PASS baseline regresses**

---

# **6.8 Definition of UX Success**

EGAL-6.6 succeeds when elderly users say things like:

“Dễ dùng hơn.”

“Rõ ràng hơn.”

“Ít bị rối hơn.”

“Yên tâm hơn.”

without necessarily noticing:

what changed.

That is:

invisible UX success.

---

# **6.9 Sprint Completion Criteria**

EGAL-6.6 closes only when:

### **Login feels calmer**

### **Register feels lighter**

### **JoinClan feels safer**

### **CreateClan feels clearer**

### **WaitingPage feels more reassuring**

### **ForgotPassword feels recoverable**

### **feedback feels consistent**

### **hesitation measurably decreases**

### **confidence measurably increases**

WITHOUT:

### **architecture changes**

### **hidden regressions**

### **emotional overload**

### **unnecessary redesign**

---

# **FINAL EXIT CONDITION — EGAL-6.6 COMPLETE**

EGAL-6.6 is officially complete when:

The system reaches:

elder-first effortless interaction.

Meaning:

users no longer fight the interface.

They simply:

complete meaningful genealogy work calmly and confidently.

This is the intended end-state of:

UX Polish Sprint 6.6.

# 04\_EGAL\_6.x\_Project\_Closeout.md

# **04\_EGAL\_6.x\_Project\_Closeout.md**

**Project:** EGAL — *Elder Guidance & Accessibility Layer*  
**Phase:** EGAL-6.x Closeout  
**Status:** Final Engineering Closeout  
**Coverage:** EGAL-6.1 → EGAL-6.6  
**Architecture Status:** Stabilized  
**Project State:** UAT PASS \+ Hardening PASS \+ UX Polish PASS

---

# **PART I — EXECUTIVE SUMMARY & WHY EGAL-6.x HAPPENED**

---

# **1.1 Purpose of This Document**

This document formally closes:

EGAL-6.x

as an engineering phase.

Its purpose is to record:

### **what happened**

### **what changed**

### **what stabilized**

### **what was learned**

### **what remains unresolved**

### **where EGAL goes next**

This document is not:

### **sprint log**

### **implementation note**

### **bug tracker**

### **technical specification**

Those already exist.

Instead:

this is:

project closeout documentation.

Meaning:

A historical and architectural record of:

how EGAL matured.

---

# **1.2 What EGAL Actually Is**

EGAL stands for:

Elder Guidance & Accessibility Layer

for a:

genealogy system

built using:

### **React**

### **Vite**

Its purpose is not merely:

accessibility.

EGAL exists to solve a deeper problem:

Elderly users struggle with modern interaction patterns.

Especially when systems require:

### **multi-step forms**

### **validation**

### **confirmation**

### **navigation**

### **confidence under uncertainty**

Genealogy systems amplify this problem.

Because genealogy data feels:

### **emotionally important**

### **historically meaningful**

### **difficult to undo**

### **identity-sensitive**

As a result:

mistakes feel psychologically expensive.

EGAL exists to reduce this burden.

---

# **1.3 Why EGAL-6.x Became Necessary**

EGAL existed before 6.x.

However:

prior versions suffered from:

### **instability**

### **flow inconsistency**

### **ownership confusion**

### **emotional friction**

### **runtime fragility**

Functional behavior often existed.

But:

user confidence did not.

Common symptoms included:

### **broken edit-return lifecycle**

### **stale validation**

### **inconsistent transitions**

### **child navigation ownership problems**

### **uncertainty after submit**

### **WaitingPage confusion**

### **weak elder reassurance**

System behavior became:

technically functional

but psychologically unstable.

This distinction matters.

For elder-first systems:

### **emotional instability**

is functional instability.

---

# **1.4 The Core Problem EGAL-6.x Solved**

Before EGAL-6.x:

the system suffered from:

orchestration ambiguity.

Meaning:

No stable answer existed for:

### **who owns navigation?**

### **who owns transitions?**

### **who validates?**

### **who decides progression?**

### **who controls review state?**

This created:

### **fragile runtime behavior.**

Symptoms included:

### **inconsistent screen transitions**

### **hidden lifecycle issues**

### **stale values**

### **edit-return failures**

### **broken confidence loops**

### **duplicated authority**

---

## **Example Failure Pattern**

Child forms occasionally behaved as if they owned:

### **navigation.**

This violated:

single orchestration truth.

Result:

### **instability.**

---

## **Another Example**

WaitingPage lacked fully stabilized identity.

Question emerged:

Is this loading?

Is this confirmation?

Is this temporary state?

Unclear role created:

### **UX ambiguity.**

---

# **1.5 EGAL-6.x Was Not A Feature Sprint**

This is critical historical context.

EGAL-6.x was:

architecture stabilization.

Not:

### **feature expansion.**

Not:

### **redesign.**

Not:

### **visual overhaul.**

Not:

### **optimization sprint.**

The mission became:

make system trustworthy.

Before adding more capability.

This decision was intentional.

Because:

adding features on unstable architecture would increase:

### **regression risk**

### **confusion**

### **technical debt**

---

# **1.6 The Real Objective Of EGAL-6.x**

EGAL-6.x pursued one core objective:

predictable confidence.

Meaning:

Users should always understand:

### **what state they are in**

### **what happened**

### **what to do next**

### **whether action succeeded**

### **whether correction is possible**

This sounds simple.

But achieving it required solving:

### **orchestration**

### **validation**

### **review lifecycle**

### **runtime consistency**

### **emotional UX**

simultaneously.

---

# **1.7 The Three Layers Of EGAL-6.x**

EGAL-6.x ultimately evolved into:

three consecutive maturity phases.

---

## **Phase 1 — Stabilization (EGAL-6.1 → 6.5)**

Question:

Can this architecture become stable?

Focus:

### **lifecycle consistency**

### **orchestration control**

### **WaitingPage identity**

### **edit-return reliability**

### **validation authority**

### **runtime stabilization**

Outcome:

PASS UAT baseline.

---

## **Phase 2 — Hardening (EGAL-6.5.5)**

Question:

Can the system feel safer?

Focus:

### **Login attention**

### **feedback visibility**

### **success certainty**

### **runtime resilience**

### **duplicate-submit prevention**

### **accessibility safety**

Outcome:

Reduced friction.

---

## **Phase 3 — UX Polish (EGAL-6.6)**

Question:

Can the experience feel effortless?

Focus:

### **emotional confidence**

### **micro-interactions**

### **readability**

### **calm transitions**

### **reassurance**

### **elder-first clarity**

Outcome:

emotional maturity.

---

# **1.8 The Most Important Realization Of EGAL-6.x**

Perhaps the most important discovery:

Functional PASS is not enough.

A screen can:

### **technically work**

while still emotionally failing.

Example:

Login succeeds.

But user asks:

“Đã vào chưa?”

Technically:

PASS.

Emotionally:

FAIL.

EGAL-6.x permanently changed project philosophy:

from:

task completion

to:

confident task completion.

This became foundational.

---

# **1.9 EGAL’s Defining Philosophy**

EGAL ultimately rejected:

modern minimalist UX assumptions.

Instead:

it embraced:

### **reassurance**

### **predictability**

### **clarity**

### **redundancy**

### **emotional safety**

Core belief:

Elder users should never feel tested by software.

System responsibility is:

reduce uncertainty.

Not increase it.

---

## **EGAL Philosophy In One Sentence**

Modern UX asks:

How quickly can user finish?

EGAL asks:

How calmly can user succeed?

This distinction defines everything.

---

# **1.10 End State Of EGAL-6.x**

At closeout:

EGAL reached:

stable architecture

PLUS

hardening maturity

PLUS

elder-centered UX clarity

Major flows now stabilize:

### **Login**

### **Register**

### **JoinClan**

### **CreateClan**

### **WaitingPage review lifecycle**

### **Edit → Return**

### **validation-before-transition**

### **orchestration consistency**

### **feedback predictability**

### **runtime safety**

This does not mean:

perfect system.

But it means:

trustworthy foundation.

Which is far more important.

---

# **PART I EXIT CONDITION**

EGAL-6.x can officially enter closeout only when:

team agrees:

### **architecture stabilized**

### **UAT PASS baseline achieved**

### **hardening complete**

### **UX polish complete**

### **elder confidence measurably improved**

### **orchestration ambiguity resolved**

### **WaitingPage doctrine stabilized**

### **AuthPage ownership stabilized**

### **project now rests on trustworthy foundations**

# **PART II — SPRINT CHRONICLE (EGAL-6.1 → EGAL-6.6)**

---

# **2.1 Purpose of PART II**

PART II records:

what actually happened during EGAL-6.x.

Not merely:

### **what was implemented**

But:

### **why changes became necessary**

### **what broke**

### **what stabilized**

### **what the team learned**

Because:

EGAL-6.x was not linear.

It evolved through:

### **repeated UAT discovery**

### **architectural correction**

### **runtime stabilization**

### **doctrine formation**

### **elder UX refinement**

This history matters.

Because future teams may ask:

“Why was this architecture designed this way?”

The answer exists here.

---

# **2.2 EGAL-6.x Starting State**

At the beginning of 6.x:

system already existed.

But architecture maturity was:

incomplete.

Common symptoms:

### **inconsistent lifecycle behavior**

### **uncertain ownership boundaries**

### **stale state leakage**

### **unreliable transitions**

### **edit-return instability**

### **confusing WaitingPage behavior**

### **weak emotional reassurance**

System technically functioned.

But confidence remained fragile.

---

## **Initial Engineering Risk**

Project risk was not:

missing features.

Risk was:

unstable foundation.

Without stabilization:

future development would likely produce:

### **regression chains**

### **fragile UX**

### **state confusion**

### **difficult debugging**

Therefore:

team deliberately prioritized:

stabilization before expansion.

This decision proved correct.

---

# **EGAL-6.1 — FOUNDATIONAL STABILIZATION**

---

# **2.3 Primary Goal**

Core question:

Can we establish a reliable flow foundation?

At this stage:

system behavior still suffered from:

### **ambiguity.**

Especially around:

### **progression**

### **transitions**

### **lifecycle ownership**

---

## **Major Focus Areas**

### **flow consistency**

### **screen progression**

### **form-state persistence**

### **transition reliability**

### **reducing chaos**

---

## **Discovery**

Important realization emerged:

uncontrolled ownership causes instability.

When multiple components appear to own:

### **transition logic**

system becomes:

### **unpredictable.**

This would later become foundational doctrine.

---

## **Result**

EGAL-6.1 established:

stabilization direction.

But architecture still immature.

---

# **EGAL-6.2 — ORCHESTRATION DISCOVERY**

---

# **2.4 Primary Goal**

Question evolved into:

Who actually owns system flow?

This became one of the most important discoveries in EGAL history.

---

## **Architectural Problem**

Child forms sometimes behaved as though they owned:

### **navigation.**

This caused:

### **lifecycle inconsistency**

### **unpredictable transitions**

### **fragile runtime behavior**

---

## **Major Discovery**

EGAL formally discovered:

orchestration must be centralized.

Result:

### **AuthPage doctrine emerged.**

---

## **AuthPage Doctrine**

AuthPage became:

orchestration root.

Responsible for:

### **navigation**

### **progression**

### **authentication transition**

### **state progression**

Child forms became:

controlled participants.

This reduced:

### **ownership confusion.**

dramatically.

---

## **Result**

System behavior became:

### **more deterministic.**

Still incomplete.

But significantly safer.

---

# **EGAL-6.3 — WAITINGPAGE IDENTITY CRISIS**

---

# **2.5 Primary Goal**

Question emerged:

What exactly is WaitingPage?

Historically:

WaitingPage suffered:

### **role ambiguity.**

Possible interpretations included:

### **loading page**

### **temporary transport screen**

### **confirmation state**

### **review stage**

Confusion created:

### **UX inconsistency.**

---

## **Discovery**

UAT revealed:

elder users needed:

reassurance before commitment.

Meaning:

users wanted opportunity to:

### **review**

### **edit**

### **confirm**

before final submission.

---

## **Major Architectural Discovery**

WaitingPage formally evolved into:

TRUE REVIEW PAGE.

Not:

### **loading screen**

Not:

### **spinner state**

Not:

### **fake delay page**

Its true purpose became:

### **confidence preservation.**

---

## **Result**

WaitingPage doctrine stabilized.

This became:

one of the most important EGAL design decisions.

---

# **EGAL-6.4 — VALIDATION & EDIT-RETURN STABILIZATION**

---

# **2.6 Primary Goal**

Question:

Can users safely revise without breaking flow?

At this stage:

major friction existed around:

### **edit lifecycle**

### **stale validation**

### **data persistence**

### **return flow consistency**

---

## **Problems Discovered**

Common issues:

### **returning values not preserved**

### **validation stale after edits**

### **inconsistent state restoration**

### **broken confidence loop**

User feeling:

“Sửa xong không biết có giữ không.”

This severely damaged confidence.

---

## **Major Discovery**

Validation must happen:

before transition.

Always.

And:

draft values must not become:

runtime truth.

This distinction proved critical.

---

## **Edit → Return Doctrine**

System formally stabilized:

Edit → Return lifecycle.

Meaning:

User can:

### **review**

### **edit**

### **return safely**

without losing confidence.

---

## **Result**

Large reduction in:

### **flow fragility.**

Major UAT improvement.

---

# **EGAL-6.5 — UAT PASS STABILIZATION**

---

# **2.7 Primary Goal**

Question:

Can the architecture survive real UAT?

EGAL-6.5 became:

stabilization sprint.

The goal was not beauty.

The goal was:

### **reliability.**

---

## **Major Focus**

### **Login flow**

### **Register flow**

### **JoinClan flow**

### **CreateClan flow**

### **WaitingPage lifecycle**

### **Edit-return safety**

### **validation consistency**

### **runtime resilience**

---

## **Key Achievement**

EGAL reached:

PASS UAT baseline.

Major flows stabilized.

For first time:

system behavior became:

### **dependable.**

---

## **Historical Importance**

This became:

architectural lock point.

Meaning:

Future work should preserve:

EGAL-6.5 baseline.

Not destabilize it.

This eventually became:

### **Q1/Q2 doctrine.**

---

# **EGAL-6.5.5 — HARDENING SPRINT**

---

# **2.8 Primary Goal**

Question shifted:

Can the system feel safer?

UAT revealed:

technical PASS ≠ emotional PASS.

Common issues:

### **missed messages**

### **uncertainty after login**

### **repeated clicking**

### **weak success certainty**

### **inconsistent visibility**

---

## **Focus Areas**

### **Login attention management**

### **accessibility safety**

### **runtime protection**

### **feedback visibility**

### **success certainty**

### **duplicate-submit prevention**

---

## **Major Discovery**

Critical realization:

confidence is part of functionality.

Especially:

for elder users.

A technically correct system may still fail emotionally.

---

## **Result**

Hardening dramatically reduced:

### **hesitation**

### **ambiguity**

### **missed feedback**

without architecture redesign.

---

# **EGAL-6.6 — UX POLISH SPRINT**

---

# **2.9 Primary Goal**

Question evolved again:

Can the experience feel effortless?

At this point:

system already worked.

Now:

focus became:

### **emotional ease.**

---

## **Focus Areas**

### **micro-interactions**

### **readability**

### **calmness**

### **reassurance**

### **predictability**

### **confidence**

### **emotional safety**

---

## **Major Discovery**

Modern UX assumptions failed elderly users.

EGAL formally rejected:

### **minimalist ambiguity**

### **hidden interactions**

### **clever UX tricks**

### **novelty-first design**

Instead embraced:

### **reassurance**

### **clarity**

### **predictability**

### **guided interaction**

---

## **Result**

System became:

### **calmer**

### **easier**

### **more emotionally stable**

without major redesign.

---

# **2.10 Evolution Of EGAL-6.x Thinking**

Project philosophy evolved dramatically.

---

## **Early Thinking**

Focus:

Can this work?

---

## **Middle Thinking**

Focus:

Can this remain stable?

---

## **Later Thinking**

Focus:

Can elderly users feel confident?

---

## **Final Thinking**

Focus:

Can elderly users succeed calmly?

This philosophical shift defines:

mature EGAL.

---

# **2.11 Most Important Milestones**

EGAL-6.x achieved several permanent milestones.

---

### **Milestone 1**

AuthPage stabilized as:

orchestration root.

---

### **Milestone 2**

WaitingPage stabilized as:

TRUE REVIEW PAGE.

---

### **Milestone 3**

Validation-before-transition became:

authoritative doctrine.

---

### **Milestone 4**

Edit → Return lifecycle stabilized.

---

### **Milestone 5**

Hardening became:

emotional safety layer.

---

### **Milestone 6**

UX polish became:

elder-first confidence refinement.

---

# **2.12 Final Outcome Of EGAL-6.x**

By EGAL-6.6 close:

project moved from:

unstable but functional

to:

stable, trustworthy, elder-centered system foundation.

This transition was:

### **architectural**

### **emotional**

### **operational**

### **philosophical**

simultaneously.

---

# **PART II EXIT CONDITION**

Sprint Chronicle is complete when:

team understands:

### **what changed**

### **why changes happened**

### **why doctrines emerged**

### **how architecture matured**

### **how UAT shaped design**

### **why EGAL ultimately became elder-first**

and:

### **why EGAL-6.x became foundational for future development**

# **PART III — MAJOR ARCHITECTURAL DISCOVERIES**

---

# **3.1 Purpose of PART III**

PART III documents:

what EGAL fundamentally learned.

Not:

### **implementation details**

Not:

### **sprint notes**

Not:

### **bug history**

Instead:

this section records:

architectural truths discovered through UAT and engineering.

These discoveries permanently changed:

### **system structure**

### **ownership model**

### **UX philosophy**

### **runtime expectations**

### **elder interaction doctrine**

Most importantly:

they explain:

why EGAL architecture looks the way it does.

---

# **3.2 Discovery \#1**

# **Orchestration Must Have A Single Owner**

This may be the most important discovery in EGAL-6.x.

---

## **Initial Problem**

Earlier system behavior suggested:

multiple components appeared to own:

### **progression**

### **transition**

### **navigation**

### **submit flow**

This created:

### **hidden conflict.**

Symptoms included:

### **inconsistent redirect**

### **broken lifecycle**

### **difficult debugging**

### **state confusion**

### **transition unpredictability**

---

## **Root Cause**

The system lacked:

orchestration singularity.

Meaning:

No single source of truth existed for:

who decides what happens next.

This caused:

### **duplicated authority.**

which inevitably produces:

### **instability.**

---

## **Major Architectural Conclusion**

EGAL discovered:

orchestration must be centralized.

Result:

### **AuthPage became orchestration root.**

---

## **Permanent Doctrine**

Child forms:

### **collect input**

### **validate locally**

### **present feedback**

But:

must never own:

### **navigation**

### **progression authority**

### **lifecycle transition**

This doctrine became:

non-negotiable.

---

## **Why This Matters**

Without centralized orchestration:

systems become:

emotionally unpredictable.

Users feel:

“Không biết chuyện gì đang xảy ra.”

This is especially harmful for elderly users.

---

# **3.3 Discovery \#2**

# **WaitingPage Is A TRUE REVIEW PAGE**

Initially:

WaitingPage identity remained unclear.

This created one of the most important design crises.

---

## **Competing Interpretations**

Some system behavior implied:

WaitingPage might be:

### **temporary transport screen**

### **loading page**

### **delay state**

### **submission transition**

However:

UAT repeatedly revealed:

elder users treated it differently.

Users instinctively used it to:

### **review**

### **re-check**

### **gain confidence**

### **edit safely**

This changed everything.

---

## **Major Discovery**

WaitingPage exists for:

confidence preservation.

Not:

### **loading illusion**

Not:

### **technical transport**

Its purpose is:

### **emotional reassurance.**

---

## **Permanent Doctrine**

WaitingPage is:

TRUE REVIEW PAGE.

Meaning:

### **reviewability required**

### **editability required**

### **confidence reinforcement required**

### **calm pacing required**

Forbidden regression:

turning it into:

fake loading screen.

---

## **Why This Matters**

Genealogy data feels:

### **personal**

### **important**

### **identity-related**

Users fear mistakes.

WaitingPage lowers:

### **submission anxiety.**

This is essential.

---

# **3.4 Discovery \#3**

# **Validation Must Happen Before Transition**

A critical engineering discovery.

---

## **Original Problem**

Earlier flow occasionally allowed:

transition into:

### **invalid state.**

This created:

### **stale errors**

### **broken confidence**

### **confusing return flow**

### **inconsistent UX**

User perception:

“Sao sang trang rồi mới báo lỗi?”

Emotionally damaging.

---

## **Major Discovery**

Validation cannot be:

optional post-check.

Validation must become:

authoritative gate.

Meaning:

transition only happens after:

### **valid state confirmed.**

---

## **Permanent Doctrine**

Rule:

validation before transition.

Always.

No exception.

---

## **Why This Matters**

This improved:

### **predictability**

### **confidence**

### **runtime integrity**

Users now understand:

“Nếu sang bước tiếp theo nghĩa là ổn.”

Confidence dramatically increased.

---

# **3.5 Discovery \#4**

# **Draft Values ≠ Runtime Truth**

One of the most technically important discoveries.

---

## **Original Problem**

System occasionally behaved as though:

temporary form values became:

runtime truth.

This caused:

### **stale state**

### **edit inconsistency**

### **confusing restoration**

### **unreliable return behavior**

---

## **Discovery**

EGAL realized:

There are two fundamentally different things:

---

### **Draft State**

Temporary.

Editable.

Mutable.

---

### **Runtime State**

Authoritative.

Validated.

Trusted.

---

## **Architectural Consequence**

Draft values cannot drive:

### **orchestration**

### **navigation**

### **lifecycle decisions**

Only:

### **validated runtime truth**

may do so.

---

## **Why This Matters**

Without this separation:

systems become:

### **unpredictable.**

Especially after:

### **edit → return cycles.**

This discovery stabilized:

major flows.

---

# **3.6 Discovery \#5**

# **Functional PASS ≠ Emotional PASS**

Perhaps the most transformative discovery.

---

## **Earlier Assumption**

Engineering initially focused on:

Does feature work?

However:

UAT exposed hidden reality.

Users could technically complete task.

Yet still ask:

“Đã xong chưa?”

Or:

“Mình làm đúng không?”

Technically:

PASS.

Emotionally:

FAIL.

---

## **Major Discovery**

Confidence is:

part of functionality.

Especially:

for elderly users.

Meaning:

system quality includes:

### **reassurance**

### **clarity**

### **certainty**

### **emotional safety**

---

## **Architectural Consequence**

Hardening sprint emerged.

UX polish emerged.

Because emotional friction became:

engineering problem.

Not cosmetic issue.

---

## **Why This Matters**

EGAL permanently changed definition of success:

from:

task completion

to:

confident task completion.

---

# **3.7 Discovery \#6**

# **Elder UX Is Fundamentally Different**

EGAL rejected:

modern startup UX assumptions.

---

## **Traditional UX Assumption**

Optimize for:

### **speed**

### **minimalism**

### **fewer words**

### **hidden sophistication**

### **clever interaction**

---

## **UAT Reality**

Elder users preferred:

### **obviousness**

### **reassurance**

### **repetition**

### **predictability**

### **guidance**

This forced:

philosophical redesign.

---

## **Major Discovery**

Minimal friction ≠ minimal interface.

Sometimes:

more explanation creates:

### **lower burden.**

Because uncertainty decreases.

---

## **Architectural Consequence**

EGAL formally embraced:

### **guided UX**

over:

### **clever UX.**

---

## **Why This Matters**

Future decisions now use:

elder-first evaluation.

Question becomes:

“Would elderly users immediately understand?”

---

# **3.8 Discovery \#7**

# **Calmness Is A System Requirement**

Unexpected discovery.

---

## **Observation**

Users struggled when interface felt:

### **rushed**

### **abrupt**

### **unpredictable**

### **overstimulating**

This created:

### **anxiety.**

Even when functionality worked.

---

## **Major Discovery**

Calmness improves:

### **trust**

### **confidence**

### **comprehension**

### **willingness to continue**

---

## **Architectural Consequence**

EGAL formally adopted:

### **calm transitions**

### **stable pacing**

### **reassurance-first UX**

### **low cognitive burden**

---

## **Why This Matters**

Emotion directly affects:

### **task success.**

Especially for seniors.

---

# **3.9 Discovery \#8**

# **Predictability Beats Cleverness**

Repeated UAT confirmed:

elder users rely on:

interaction memory.

Meaning:

they remember:

### **where messages appear**

### **where buttons exist**

### **how flow behaves**

---

## **Problem**

Creative inconsistency caused:

### **confusion.**

Even when visually “better.”

---

## **Major Discovery**

Predictability lowers:

### **cognitive load.**

More than novelty.

---

## **Architectural Consequence**

EGAL adopted:

### **stable patterns**

### **repeated structure**

### **consistent feedback**

### **interaction familiarity**

---

## **Why This Matters**

Users stop thinking about:

### **interface.**

And focus on:

### **task.**

This is mature UX.

---

# **3.10 Discovery \#9**

# **Accessibility Is Business Logic**

This discovery permanently changed priorities.

---

## **Earlier Thinking**

Accessibility was initially treated as:

enhancement.

Something optional.

---

## **UAT Reality**

If elderly users cannot:

### **notice message**

### **understand feedback**

### **recover from mistake**

then:

feature functionally failed.

---

## **Major Discovery**

Accessibility is:

core functionality.

Not bonus quality.

---

## **Architectural Consequence**

Hardening sprint prioritized:

### **visibility**

### **attention guidance**

### **reassurance**

### **feedback clarity**

### **cognitive safety**

---

## **Why This Matters**

This permanently changed engineering priorities.

---

# **3.11 Final Architectural Realization**

EGAL ultimately discovered:

Elder confidence is architecture.

Not merely:

### **UI detail.**

Not:

### **wording preference.**

Not:

### **visual polish.**

Confidence emerges from:

### **orchestration**

### **validation**

### **predictability**

### **reassurance**

### **runtime stability**

working together.

This realization defines:

mature EGAL.

---

# **PART III EXIT CONDITION**

Architectural discoveries are complete when:

team understands:

### **why AuthPage owns orchestration**

### **why WaitingPage became TRUE REVIEW PAGE**

### **why validation happens before transition**

### **why draft state ≠ runtime truth**

### **why emotional PASS matters**

### **why elder UX differs fundamentally**

### **why predictability beats cleverness**

### **why accessibility became business logic**

and ultimately:

### **why EGAL architecture matured into elder-first confidence engineering**

# **PART IV — WHAT STABILIZED (FINAL STATE OF EGAL-6.x)**

---

# **4.1 Purpose of PART IV**

PART IV answers:

What exactly became stable?

Because EGAL-6.x was not merely:

adding capability.

Its real achievement was:

reducing instability.

This section formally records:

the final stabilized state of:

### **architecture**

### **runtime**

### **UX behavior**

### **lifecycle**

### **emotional confidence**

This matters historically.

Because future teams may unintentionally ask:

“Why not redesign this?”

Answer:

because instability already cost heavily.

EGAL-6.x solved that instability.

The stabilized foundation must be protected.

---

# **4.2 Stabilization Philosophy**

EGAL-6.x taught an important lesson:

A system is not mature when:

it works once.

A system becomes mature when:

it behaves predictably under repetition.

Meaning:

same action

→ same expectation

→ same result

This predictability became:

core maturity indicator.

---

# **4.3 AuthPage Stabilized As Orchestration Root**

One of the largest achievements.

---

## **Before EGAL-6.x**

Flow ownership felt:

### **fragmented.**

Questions existed:

### **who transitions?**

### **who navigates?**

### **who decides next screen?**

### **who owns progression?**

This ambiguity created:

### **runtime fragility.**

---

## **After EGAL-6.x**

Architecture stabilized around:

single orchestration authority.

### **AuthPage**

became permanent owner of:

### **authentication transition**

### **route progression**

### **lifecycle movement**

### **screen orchestration**

### **flow continuity**

---

## **Final Stable Rule**

Child forms may:

### **collect input**

### **validate**

### **show feedback**

But never:

### **control navigation.**

---

## **Stabilization Result**

System behavior became:

### **deterministic.**

Much easier to debug.

Much easier to trust.

---

# **4.4 WaitingPage Stabilized As TRUE REVIEW PAGE**

Perhaps the most important UX stabilization.

---

## **Before EGAL-6.x**

WaitingPage identity remained:

### **ambiguous.**

Sometimes perceived as:

### **loading state**

### **transport screen**

### **temporary delay**

This weakened:

### **confidence.**

---

## **After EGAL-6.x**

WaitingPage permanently stabilized as:

TRUE REVIEW PAGE.

Its responsibilities became clear:

### **review**

### **reassurance**

### **editability**

### **confidence building**

### **submission safety**

---

## **Final Stable Rule**

WaitingPage must never become:

### **spinner page**

### **fake loading**

### **rushed transition**

### **transport mechanism**

---

## **Stabilization Result**

Users gained:

### **emotional certainty.**

Common feeling shifted from:

“Không biết có đúng không.”

to:

“Có thể xem lại trước.”

This dramatically improved trust.

---

# **4.5 Edit → Return Lifecycle Stabilized**

Historically:

one of the most fragile areas.

---

## **Before EGAL-6.x**

Editing often caused:

### **state confusion**

### **lost information**

### **stale validation**

### **broken flow continuity**

User concern:

“Sửa xong có mất không?”

Confidence collapsed easily.

---

## **After EGAL-6.x**

Edit-return became:

### **predictable.**

### **safe.**

### **reversible.**

Users can now:

### **review**

### **edit**

### **return**

without emotional penalty.

---

## **Final Stable Rule**

Edit must preserve:

### **continuity.**

Never punish correction.

---

## **Stabilization Result**

User confidence improved dramatically.

Especially in:

### **genealogy-sensitive workflows.**

---

# **4.6 Validation Stabilized As Pre-Transition Authority**

Major engineering milestone.

---

## **Before EGAL-6.x**

Validation behavior sometimes felt:

### **delayed**

### **inconsistent**

### **stale**

### **reactive**

Users occasionally experienced:

transition first

then:

correction later.

This created:

### **distrust.**

---

## **After EGAL-6.x**

Validation became:

authoritative gate.

Transition only occurs after:

### **valid state confirmed.**

---

## **Final Stable Rule**

No invalid transition.

Ever.

Validation happens:

before progression.

---

## **Stabilization Result**

User expectation became:

“Nếu sang bước tiếp thì chắc ổn.”

Confidence increased.

Runtime errors decreased.

---

# **4.7 Runtime Lifecycle Stabilized**

One of the most invisible improvements.

Yet critically important.

---

## **Before EGAL-6.x**

Runtime occasionally felt:

### **fragile.**

Symptoms included:

### **stale state**

### **lifecycle inconsistency**

### **transition mismatch**

### **hidden async issues**

### **difficult debugging**

---

## **After EGAL-6.x**

Lifecycle became:

### **calmer**

### **safer**

### **more predictable**

---

## **Stable Characteristics**

### **cleaner ownership**

### **deterministic transitions**

### **lower async confusion**

### **reduced stale state**

### **safer rerender behavior**

---

## **Stabilization Result**

System became:

harder to accidentally break.

Critical for future development.

---

# **4.8 Login Flow Stabilized**

Login became:

### **emotionally reliable.**

Not only technically functional.

---

## **Before Hardening**

Users experienced:

### **missed feedback**

### **uncertainty after submit**

### **repeated clicking**

### **success ambiguity**

---

## **After 6.5.5 \+ 6.6**

Login became:

### **clearer**

### **calmer**

### **more confidence-oriented**

---

## **Stable Characteristics**

### **visible feedback**

### **predictable submit state**

### **clearer success**

### **understandable failure**

### **lower hesitation**

---

## **Stabilization Result**

Login transformed from:

functional

to:

trustworthy.

---

# **4.9 Register / JoinClan / CreateClan Stabilized**

Form experiences matured significantly.

---

## **Before EGAL-6.x**

Forms felt:

### **cognitively heavy**

### **fragile**

### **intimidating**

Especially:

for elderly users.

---

## **After EGAL-6.x**

Forms became:

### **more guided**

### **more recoverable**

### **easier to trust**

---

## **Stable Characteristics**

### **validation clarity**

### **edit confidence**

### **WaitingPage reassurance**

### **lower submission anxiety**

---

## **Stabilization Result**

Users gained:

### **willingness to continue.**

Less abandonment.

Less hesitation.

---

# **4.10 Elder UX Stabilized**

One of the deepest outcomes.

---

## **Before EGAL-6.x**

UX still implicitly assumed:

modern user behavior.

This caused:

### **confusion**

### **uncertainty**

### **overload**

for elderly users.

---

## **After EGAL-6.x**

System fully transitioned toward:

elder-first UX.

Stable characteristics include:

### **reassurance-first**

### **predictability-first**

### **calmness-first**

### **guided interaction**

### **low cognitive burden**

---

## **Stabilization Result**

UX became:

### **emotionally safer.**

This changed system identity.

---

# **4.11 Project Philosophy Stabilized**

Unexpected but important achievement.

---

## **Before EGAL-6.x**

Primary engineering question:

Does feature work?

---

## **After EGAL-6.x**

Primary engineering question became:

Does user feel confident?

This philosophical shift stabilized:

future decision-making.

---

## **Final Stable Principles**

### **confidence over speed**

### **predictability over novelty**

### **reassurance over minimalism**

### **guidance over cleverness**

### **accessibility as business logic**

---

# **4.12 What Became Predictable**

EGAL-6.x ultimately stabilized:

### **navigation ownership**

### **review lifecycle**

### **validation timing**

### **edit-return behavior**

### **submit confidence**

### **WaitingPage identity**

### **user expectations**

### **runtime progression**

### **emotional reassurance**

This predictability became:

EGAL maturity.

---

# **4.13 Final Stable State Of EGAL-6.x**

By closeout:

EGAL became:

stable enough to safely grow.

Meaning:

Future development can now happen on:

### **trustworthy architecture.**

Instead of:

### **fragile improvisation.**

This is arguably:

the most important achievement of EGAL-6.x.

---

# **PART IV EXIT CONDITION**

Stabilization is complete when:

team agrees:

### **AuthPage orchestration stabilized**

### **WaitingPage stabilized**

### **edit-return stabilized**

### **validation stabilized**

### **runtime stabilized**

### **login stabilized**

### **forms stabilized**

### **elder UX stabilized**

### **project philosophy stabilized**

Meaning:

EGAL finally behaves:

predictably, calmly, and confidently.

# **PART V — UAT LESSONS & ELDER UX FINDINGS**

---

# **5.1 Purpose of PART V**

PART V documents:

what UAT actually taught EGAL.

This section is critical.

Because many of EGAL-6.x’s most important decisions did not come from:

### **engineering theory**

or

### **design preference**

They came from:

observing real user behavior.

Especially:

### **elderly hesitation**

### **confusion patterns**

### **emotional reactions**

### **confidence breakdown**

### **recovery behavior**

UAT repeatedly changed assumptions.

Sometimes dramatically.

This section records those discoveries.

---

# **5.2 Most Important UAT Discovery**

The single biggest lesson:

Functional success is insufficient.

This discovery permanently changed EGAL.

---

## **Earlier Assumption**

Before repeated UAT:

engineering often measured:

task completion.

Question:

“Can user finish?”

If yes:

PASS.

---

## **UAT Reality**

Users sometimes completed task

while still feeling:

### **uncertain**

### **anxious**

### **unconvinced**

Example:

User logs in successfully.

Then asks:

“Đã vào chưa?”

Technically:

PASS.

Emotionally:

FAIL.

---

## **Final Lesson**

Confidence must become:

success criteria.

Not optional enhancement.

---

# **5.3 Elder Users Fear Mistakes More Than Younger Users**

Unexpected but important discovery.

---

## **Observation**

Younger users often experiment.

If mistake happens:

they retry casually.

Elder users behave differently.

Common emotional response:

“Lỡ sai thì sao?”

Especially in:

### **genealogy context.**

Because genealogy feels:

### **historically meaningful**

### **family-sensitive**

### **emotionally important**

### **identity-related**

Mistakes feel:

### **serious.**

---

## **UX Consequence**

System must communicate:

### **reversibility.**

Users need confidence that:

correction is possible.

---

## **Resulting Design Shift**

WaitingPage became:

### **confidence checkpoint.**

Edit-return lifecycle became:

### **critical.**

This was not cosmetic.

It became:

psychological safety.

---

# **5.4 Elder Users Need Explicit Confirmation**

Repeated UAT confirmed:

elder users strongly prefer:

### **certainty.**

Especially after:

### **important action.**

---

## **Observation**

Absence of failure does not equal:

### **perceived success.**

Example:

Login succeeds silently.

User asks:

“Được chưa?”

No technical issue exists.

But confidence fails.

---

## **Final Lesson**

Success must be:

### **explicit.**

Not implied.

Especially:

for:

### **login**

### **submission**

### **confirmation**

---

## **UX Consequence**

Hardening sprint added:

### **success reassurance**

### **visible confirmation**

### **calmer transitions**

without noisy UX.

---

# **5.5 Elder Users Miss Information More Often Than Engineers Expect**

Repeatedly observed.

---

## **Engineering Assumption**

Developers assume:

user will notice message.

Reality:

often false.

Especially when:

### **scrolling exists**

### **focus remains elsewhere**

### **visual priority weak**

---

## **UAT Observation**

Users frequently missed:

### **validation**

### **submit result**

### **important guidance**

because message existed:

outside attention zone.

---

## **Final Lesson**

Visibility alone is insufficient.

Need:

attention guidance.

Critical content must become:

### **natural focus point.**

---

## **UX Consequence**

Hardening prioritized:

### **message visibility**

### **attention anchoring**

### **feedback predictability**

---

# **5.6 Elder Users Repeat Actions Under Uncertainty**

One of the clearest behavioral patterns.

---

## **Observation**

When unsure:

elder users commonly:

### **click again**

### **submit repeatedly**

### **retry prematurely**

because they think:

“Chắc chưa bấm được.”

or:

“Không thấy gì xảy ra.”

---

## **Engineering Interpretation**

Repeated clicking is often:

confidence symptom.

Not user error.

---

## **Final Lesson**

System uncertainty creates:

### **repeated interaction.**

Reduce uncertainty.

Repeated clicking decreases naturally.

---

## **UX Consequence**

Hardening introduced:

### **clearer submit states**

### **button protection**

### **obvious processing feedback**

---

# **5.7 Elder Users Prefer Predictability Over Cleverness**

Repeatedly confirmed.

---

## **Modern UX Assumption**

Novel interaction feels:

### **delightful.**

UAT contradicted this.

---

## **Observation**

Unexpected UI behavior increased:

### **hesitation.**

Examples:

### **changing interaction pattern**

### **inconsistent feedback location**

### **hidden state changes**

### **subtle UI cues**

Result:

### **confusion.**

---

## **Final Lesson**

Predictability reduces:

### **cognitive burden.**

Far more than cleverness.

---

## **UX Consequence**

EGAL standardized:

### **interaction rhythm**

### **message positioning**

### **feedback style**

### **calm pacing**

---

# **5.8 Minimalism Often Hurt Elder UX**

A major philosophical discovery.

---

## **Earlier Assumption**

Less UI means:

### **easier UX.**

Not always true.

---

## **Observation**

Minimal interfaces sometimes increased:

### **interpretation burden.**

Examples:

Tiny hint text.

Implicit meaning.

Missing instruction.

Hidden explanation.

Result:

### **uncertainty.**

---

## **Final Lesson**

Sometimes:

more clarity \= less burden.

Especially:

for elderly users.

---

## **UX Consequence**

EGAL accepted:

### **meaningful redundancy.**

Examples:

### **voice \+ visual confirmation**

### **repeated reassurance**

### **explicit guidance**

---

# **5.9 Emotional Tone Matters More Than Expected**

Unexpected discovery.

---

## **Observation**

Error wording changed emotional reaction.

Example:

Bad:

Wrong password.

User reaction:

### **shame**

### **embarrassment**

Better:

Mật khẩu chưa chính xác.

Reaction:

### **calmer retry.**

---

## **Final Lesson**

System tone changes:

### **willingness to continue.**

Especially after failure.

---

## **UX Consequence**

EGAL adopted:

### **supportive language.**

Never:

### **blame language.**

---

# **5.10 Calmness Improves Success Rate**

A subtle but important lesson.

---

## **Observation**

Interfaces feeling:

### **rushed**

### **abrupt**

### **overstimulating**

reduced confidence.

Even when technically fine.

---

## **Example**

Instant transitions sometimes created:

### **uncertainty.**

User mentally lagged behind system.

---

## **Final Lesson**

Calm pacing improves:

### **comprehension**

### **trust**

### **confidence**

### **completion quality**

---

## **UX Consequence**

EGAL intentionally embraced:

### **calm transitions**

### **reassurance pacing**

### **confidence-first rhythm**

---

# **5.11 Accessibility Was More Important Than Expected**

Originally underestimated.

---

## **Observation**

Small accessibility issues caused:

### **disproportionate confusion.**

Examples:

### **message placement**

### **readability**

### **weak emphasis**

### **hidden focus**

---

## **Final Lesson**

Accessibility problems become:

functional problems.

for elder users.

---

## **Engineering Shift**

Accessibility changed from:

enhancement

to:

business logic.

Permanent shift.

---

# **5.12 Most Surprising UAT Discovery**

Unexpected truth:

Users often valued:

### **confidence**

more than:

### **speed.**

Example:

Slightly slower but reassuring flow

outperformed:

fast but ambiguous flow.

---

## **Final Lesson**

Optimization target changed.

From:

speed

to:

confidence-per-action.

This became:

core EGAL philosophy.

---

# **5.13 What UAT Ultimately Taught EGAL**

UAT fundamentally revealed:

elder-first software requires:

### **reassurance**

### **predictability**

### **explicit confirmation**

### **calm pacing**

### **emotional safety**

### **editability**

### **guided interaction**

### **low cognitive burden**

without sacrificing:

### **correctness.**

This realization permanently changed:

how EGAL is built.

---

# **5.14 Final UAT Conclusion**

Most important conclusion:

Elder users do not merely use software.

They negotiate confidence with it.

If software creates doubt:

interaction degrades.

If software creates reassurance:

users succeed calmly.

EGAL ultimately learned:

confidence engineering matters as much as software engineering.

---

# **PART V EXIT CONDITION**

UAT lessons are complete when:

team understands:

### **why functional PASS was insufficient**

### **why WaitingPage mattered**

### **why confidence drives behavior**

### **why predictability beat cleverness**

### **why accessibility became business logic**

### **why emotional tone mattered**

### **why calmness improved success**

and ultimately:

### **why EGAL evolved into elder-first confidence architecture**

# **PART VI — WHAT WAS DELIBERATELY NOT CHANGED**

---

# **6.1 Purpose of PART VI**

PART VI documents:

what EGAL intentionally refused to change.

This section is historically important.

Because future teams may look at EGAL and ask:

“Why didn’t they modernize this?”

or:

“Why not redesign everything?”

Without historical context:

stable decisions may accidentally be rewritten.

This would be dangerous.

Because many EGAL choices are:

intentional constraints.

Not technical limitations.

This section explains:

### **what stayed fixed**

### **why it stayed fixed**

### **what risks were consciously avoided**

---

# **6.2 The Philosophy Of Deliberate Restraint**

EGAL-6.x learned a difficult engineering truth:

Sometimes:

not changing something

is the correct engineering decision.

Especially after:

### **repeated UAT**

### **architecture stabilization**

### **lifecycle hardening**

### **emotional validation**

The team deliberately chose:

maturity over reinvention.

This decision prevented:

### **regression**

### **instability**

### **ownership confusion**

### **emotional UX breakage**

---

# **6.3 AuthPage Was Deliberately NOT Rewritten**

One of the strongest intentional decisions.

---

## **Temptation**

Engineering temptation existed:

simplify orchestration.

or:

decentralize flow.

or:

let child forms navigate.

This superficially appeared:

### **cleaner.**

### **simpler.**

### **more componentized.**

---

## **Why Rejected**

EGAL learned:

distributed ownership caused:

### **instability.**

Repeatedly.

Symptoms historically included:

### **transition confusion**

### **lifecycle mismatch**

### **hidden navigation logic**

### **unpredictable flow**

---

## **Final Decision**

AuthPage remained:

orchestration root.

Permanently.

---

## **What Was NOT Changed**

### **navigation ownership**

### **transition authority**

### **progression control**

### **lifecycle orchestration**

---

## **Reason**

Predictability mattered more than:

### **architectural elegance.**

---

# **6.4 WaitingPage Was Deliberately NOT Simplified**

Another intentional decision.

---

## **Temptation**

Modern UX pressure suggested:

remove waiting step.

or:

auto-submit immediately.

or:

shorten process.

At first glance:

appeared:

### **faster.**

### **cleaner.**

### **more modern.**

---

## **Why Rejected**

UAT strongly contradicted this.

Elder users used WaitingPage to:

### **verify**

### **reassure themselves**

### **regain confidence**

### **safely edit**

Removing this step increased:

### **anxiety.**

---

## **Final Decision**

WaitingPage remained:

TRUE REVIEW PAGE.

---

## **What Was NOT Changed**

WaitingPage did NOT become:

### **loading state**

### **transport layer**

### **fake delay page**

### **auto-submit checkpoint**

---

## **Reason**

Confidence mattered more than:

### **interaction speed.**

---

# **6.5 Validation Architecture Was Deliberately NOT Relaxed**

Temptation existed:

move validation later.

or:

allow progression then fix later.

Sometimes seen as:

### **smoother UX.**

---

## **Why Rejected**

Earlier experiments showed:

post-transition validation created:

### **confusion**

### **broken trust**

### **stale state**

### **edit frustration**

Users emotionally interpreted:

“Hệ thống không ổn định.”

---

## **Final Decision**

Validation remained:

pre-transition authority.

Always.

---

## **What Was NOT Changed**

No:

### **invalid-state transition**

No:

### **delayed critical validation**

No:

### **silent correction logic**

---

## **Reason**

Confidence requires:

### **predictable progression.**

---

# **6.6 Business Flow Was Deliberately NOT Redesigned**

Important restraint.

---

## **Temptation**

After stabilization:

some flow simplification appeared possible.

Examples:

### **merge steps**

### **shorten sequence**

### **reduce screens**

### **remove confirmations**

---

## **Why Rejected**

UAT showed:

many “extra” steps actually reduced:

### **uncertainty.**

Especially:

for elderly users.

---

## **Final Decision**

Business flow remained:

### **familiar**

### **progressive**

### **confidence-oriented**

---

## **What Was NOT Changed**

### **Login progression**

### **Register progression**

### **JoinClan progression**

### **CreateClan progression**

### **review lifecycle**

---

## **Reason**

Familiarity reduced:

### **cognitive burden.**

---

# **6.7 Modern Minimalist UX Was Deliberately NOT Adopted**

One of the biggest philosophical choices.

---

## **Temptation**

Industry pressure favors:

### **less text**

### **fewer cues**

### **hidden sophistication**

### **subtle interaction**

### **clean minimalism**

---

## **Why Rejected**

UAT repeatedly showed:

minimalism increased:

### **interpretation burden.**

Especially for elderly users.

Users often asked:

“Ý nghĩa là gì?”

or:

“Bấm vào đâu?”

---

## **Final Decision**

EGAL embraced:

elder-first clarity.

---

## **What Was NOT Changed**

No:

### **hidden controls**

### **tiny implicit messaging**

### **overly subtle feedback**

### **“figure-it-out” UX**

---

## **Reason**

Clarity mattered more than:

### **aesthetic minimalism.**

---

# **6.8 Gamified UX Was Deliberately NOT Introduced**

Important emotional decision.

---

## **Temptation**

Modern products often add:

### **celebration**

### **animation**

### **reward feedback**

### **emotional stimulation**

---

## **Why Rejected**

Genealogy context felt:

### **serious**

### **respectful**

### **meaningful**

Gamified behavior felt:

### **inappropriate.**

And elderly users often preferred:

### **calmness.**

---

## **Final Decision**

UX tone remained:

respectful reassurance.

---

## **What Was NOT Changed**

No:

### **confetti**

### **flashy success**

### **dopamine mechanics**

### **celebratory overload**

### **playful UX gimmicks**

---

## **Reason**

Calm confidence matched user expectation.

---

# **6.9 Runtime Architecture Was Deliberately NOT Refactored**

Very important.

---

## **Temptation**

After stabilization:

temptation existed to:

### **rewrite state model**

### **refactor orchestration**

### **redesign architecture**

because system now understood better.

---

## **Why Rejected**

Stable systems are fragile during refactor.

Large refactor risked:

### **regressions**

### **lifecycle bugs**

### **hidden instability**

### **confidence breakdown**

---

## **Final Decision**

EGAL prioritized:

preservation of working architecture.

---

## **What Was NOT Changed**

No:

### **global rewrite**

### **state-management migration**

### **orchestration redesign**

### **navigation restructuring**

---

## **Reason**

Working predictability outranked:

### **theoretical improvement.**

---

# **6.10 Accessibility Was Deliberately NOT Treated As Optional**

Earlier mindset often treats accessibility as:

enhancement.

EGAL rejected this.

---

## **Final Decision**

Accessibility became:

required functionality.

---

## **What Was NOT Changed**

No deprioritization of:

### **readability**

### **visibility**

### **reassurance**

### **attention guidance**

---

## **Reason**

Without accessibility:

elder users effectively lose functionality.

---

# **6.11 Elder-First Philosophy Was Deliberately Protected**

Perhaps the most important restraint.

---

## **Temptation**

Optimize for:

### **modern user expectation.**

or:

### **younger behavior.**

---

## **Why Rejected**

EGAL exists specifically for:

elderly confidence.

Changing target audience logic would destroy:

### **system identity.**

---

## **Final Decision**

Every decision filtered through:

elder-first lens.

Question remained:

“Would elderly users immediately feel confident?”

---

## **What Was NOT Changed**

No shift toward:

### **speed-first UX**

### **novelty-first UX**

### **trend-first UX**

### **startup-style interaction**

---

## **Reason**

Confidence remained:

primary metric.

---

# **6.12 Final Lesson Of Deliberate Non-Change**

Perhaps the deepest engineering lesson:

Good engineering is not:

changing everything.

Good engineering is:

protecting what already works.

EGAL-6.x succeeded partly because:

team repeatedly chose:

disciplined restraint.

instead of:

ambitious reinvention.

This decision preserved:

### **stability**

### **confidence**

### **predictability**

### **emotional safety**

---

# **PART VI EXIT CONDITION**

This section is complete when:

team understands:

### **why AuthPage remained untouched**

### **why WaitingPage remained TRUE REVIEW PAGE**

### **why validation stayed authoritative**

### **why business flow stayed familiar**

### **why minimalism was rejected**

### **why gamification was avoided**

### **why runtime refactor was avoided**

### **why elder-first philosophy remained protected**

and ultimately:

### **why restraint became part of EGAL maturity**

# **PART VII — REMAINING TECHNICAL DEBT & OPEN RISKS**

---

# **7.1 Purpose of PART VII**

PART VII answers an uncomfortable but necessary question:

What still remains imperfect?

EGAL-6.x achieved:

### **architecture stabilization**

### **hardening maturity**

### **UX polish maturity**

However:

no serious engineering project reaches:

zero debt.

This section intentionally documents:

### **remaining weaknesses**

### **unresolved tradeoffs**

### **future risks**

### **deferred improvements**

### **areas intentionally postponed**

The goal is not criticism.

The goal is:

engineering honesty.

Because future teams must understand:

what still deserves attention.

---

# **7.2 Philosophy Of Technical Debt In EGAL**

EGAL learned an important lesson:

Not all debt should be fixed immediately.

Some debt is:

acceptable temporary compromise.

Especially when fixing it risks:

### **regression**

### **architecture destabilization**

### **emotional UX breakage**

### **confidence loss**

EGAL intentionally favored:

stable imperfect system

over:

unstable perfect architecture.

This tradeoff was deliberate.

---

# **7.3 Debt Category \#1**

# **Runtime Complexity Debt**

---

## **Current Situation**

Architecture stabilized.

But runtime behavior still contains:

### **interaction complexity.**

Because EGAL prioritizes:

### **reassurance**

### **editability**

### **confidence loops**

This naturally increases:

### **state transitions.**

---

## **Remaining Risk**

As system grows:

interaction complexity may create:

### **hidden lifecycle edge cases.**

Especially around:

### **multi-step flows**

### **asynchronous transition timing**

### **review lifecycle**

### **edit-return recursion**

---

## **Why Deferred**

Large runtime simplification currently risks:

### **destabilizing PASS flows.**

Not worth immediate risk.

---

## **Future Recommendation**

Post-6.x:

consider:

### **carefully isolated runtime audit.**

NOT:

### **rewrite.**

---

# **7.4 Debt Category \#2**

# **Form Complexity Growth**

---

## **Current Situation**

Forms remain manageable.

However:

future genealogy expansion may increase:

### **field count**

### **terminology burden**

### **validation complexity**

Especially:

### **Register**

### **JoinClan**

### **CreateClan**

---

## **Remaining Risk**

Form complexity may eventually produce:

### **elder fatigue.**

Symptoms may include:

### **hesitation**

### **abandonment**

### **submission anxiety**

---

## **Why Deferred**

Current UAT still acceptable.

No immediate critical issue.

---

## **Future Recommendation**

EGAL-7 may explore:

### **progressive disclosure**

or:

### **guided segmentation**

WITHOUT breaking:

### **confidence model.**

---

# **7.5 Debt Category \#3**

# **Genealogy Terminology Burden**

Unexpected long-term risk.

---

## **Current Situation**

Some genealogy concepts naturally contain:

### **formal language**

### **historical terminology**

### **family hierarchy complexity**

These terms may remain difficult for some users.

Especially:

non-technical elderly users.

---

## **Remaining Risk**

Users may still experience:

### **interpretation friction.**

Examples:

### **clan hierarchy confusion**

### **relationship naming uncertainty**

### **family structure ambiguity**

---

## **Why Deferred**

Requires:

### **domain refinement**

not merely engineering.

Potentially culturally sensitive.

---

## **Future Recommendation**

Potential:

### **contextual explanation system**

or:

### **elder-friendly glossary**

But must remain:

### **lightweight.**

---

# **7.6 Debt Category \#4**

# **Accessibility Depth Debt**

Important but non-critical.

---

## **Current Situation**

Accessibility improved significantly.

However:

current accessibility still prioritizes:

### **visual reassurance.**

More advanced accessibility remains unexplored.

---

## **Remaining Risk**

Future elderly users may benefit from:

### **larger adaptive text**

### **stronger voice guidance**

### **keyboard navigation support**

### **assistive interaction modes**

### **high-contrast accessibility options**

---

## **Why Deferred**

Beyond EGAL-6.x scope.

Would significantly expand complexity.

---

## **Future Recommendation**

Potential:

Accessibility Layer 2.0

inside:

### **EGAL-7+**

---

# **7.7 Debt Category \#5**

# **Voice Guidance Incompleteness**

Potential future opportunity.

---

## **Current Situation**

Voice exists as:

### **reinforcement.**

But not yet:

### **conversational guidance.**

---

## **Remaining Risk**

Some elderly users still hesitate during:

### **multi-step interaction.**

Especially:

### **uncertainty moments.**

---

## **Why Deferred**

Risk of:

### **over-complexity**

### **distraction**

### **implementation instability**

---

## **Future Recommendation**

Explore:

### **optional voice coaching.**

Important word:

optional.

Never forced.

---

# **7.8 Debt Category \#6**

# **Mobile Ergonomic Debt**

Potential future issue.

---

## **Current Situation**

Mobile experience functional.

But long-term ergonomic optimization remains incomplete.

Especially for:

### **older phones**

### **small screens**

### **touch precision limitations**

---

## **Remaining Risk**

Potential friction:

### **scrolling fatigue**

### **target size issues**

### **attention shift difficulty**

---

## **Why Deferred**

Current UAT acceptable.

No severe blocker.

---

## **Future Recommendation**

Dedicated:

### **elder-mobile ergonomics sprint.**

---

# **7.9 Debt Category \#7**

# **Emotional Confidence Measurement Debt**

Interesting discovery.

---

## **Current Situation**

Confidence improved.

But still measured:

### **qualitatively.**

through:

### **observation**

### **hesitation patterns**

### **UAT interviews**

---

## **Remaining Risk**

No formal metric currently exists for:

confidence index.

Meaning:

future UX regression may become:

### **harder to quantify.**

---

## **Why Deferred**

Would require:

### **behavioral analytics model.**

Potentially too heavy.

---

## **Future Recommendation**

Lightweight:

### **Elder Confidence Score**

for future UAT.

---

# **7.10 Debt Category \#8**

# **Future Architecture Scaling Risk**

Long-term concern.

---

## **Current Situation**

Architecture stable for:

### **EGAL-6.x scope.**

However:

future expansion may increase:

### **orchestration complexity.**

Especially if adding:

### **more genealogy workflows**

### **admin workflows**

### **deeper clan interaction**

### **historical editing**

---

## **Remaining Risk**

AuthPage orchestration may eventually grow too large.

---

## **Why Deferred**

Premature optimization avoided intentionally.

Current architecture remains:

### **stable enough.**

---

## **Future Recommendation**

Future scaling should prioritize:

### **orchestration segmentation**

WITHOUT breaking:

### **single-authority doctrine.**

---

# **7.11 Debt Category \#9**

# **Documentation Synchronization Risk**

Unexpected operational risk.

---

## **Current Situation**

Documentation now extensive.

Including:

### **Architecture Bible**

### **Hardening Sprint**

### **UX Polish Sprint**

### **Closeout**

---

## **Remaining Risk**

Future implementation may drift from:

### **doctrine.**

Especially if:

new contributors lack historical context.

---

## **Why Deferred**

Not engineering blocker.

But important governance risk.

---

## **Future Recommendation**

Maintain:

doctrine-first onboarding.

for future contributors.

---

# **7.12 What Is NOT Considered Technical Debt**

Important clarification.

These are intentional decisions.

Not debt.

---

## **NOT Debt**

### **WaitingPage existence**

### **extra reassurance**

### **calm pacing**

### **predictable flow**

### **visible confirmation**

### **supportive messaging**

### **elder-first redundancy**

---

## **Why**

These are:

strategic UX decisions.

Not inefficiencies.

Future teams must not mistakenly “optimize away” confidence.

---

# **7.13 Risk Summary**

Remaining risk level:

| Area | Risk Level | Status |
| ----- | ----- | ----- |
| Runtime stability | Low | Stable |
| Flow regression | Low | Stable |
| Form complexity growth | Medium | Watch |
| Genealogy terminology | Medium | Watch |
| Accessibility depth | Medium | Future |
| Mobile ergonomics | Medium | Future |
| Architecture scaling | Medium | Future |
| Documentation drift | Medium | Governance |
| Confidence measurement | Low–Medium | Optional |

---

# **7.14 Final Engineering Assessment**

At close of EGAL-6.x:

remaining debt exists.

But importantly:

no critical instability debt remains.

Most remaining issues are:

### **scalability debt**

### **ergonomics debt**

### **refinement debt**

NOT:

### **architecture fragility.**

This distinction matters.

Because:

the foundation is now:

trustworthy.

---

# **PART VII EXIT CONDITION**

Technical debt review is complete when:

team understands:

### **what still remains imperfect**

### **what risks were consciously deferred**

### **why some debt was accepted**

### **why stability outranked refactor**

### **which risks belong to EGAL-7+**

and ultimately:

### **why EGAL-6.x closed with manageable—not dangerous—technical debt**

**PART VIII — PRODUCTION READINESS ASSESSMENT**  
---

# **8.1 Purpose of PART VIII**

PART VIII answers:

Is EGAL actually ready?

Not:

### **theoretically ready**

Not:

### **technically demo-ready**

Not:

### **“works on developer machine”**

The real question:

Is EGAL stable enough for meaningful real-world use?

Especially:

for:

### **elderly users**

### **genealogy-sensitive workflows**

### **emotionally important interactions**

This assessment intentionally evaluates:

### **engineering readiness**

### **runtime maturity**

### **UX readiness**

### **confidence readiness**

### **operational stability**

---

# **8.2 Production Readiness Philosophy**

EGAL uses a stricter definition of readiness.

Traditional engineering often asks:

Does feature work?

EGAL asks:

Can elderly users trust the system?

Because:

in genealogy systems:

trust matters as much as correctness.

A technically correct system that creates doubt:

is:

practically unstable.

Therefore production readiness includes:

### **emotional readiness.**

---

# **8.3 Readiness Framework**

EGAL evaluates readiness across:

### **R1 — Architecture Readiness**

### **R2 — Runtime Stability**

### **R3 — Workflow Reliability**

### **R4 — UX Confidence**

### **R5 — Accessibility Safety**

### **R6 — UAT Readiness**

### **R7 — Future Expandability**

---

# **R1 — ARCHITECTURE READINESS**

---

# **8.4 Assessment**

### **STATUS: READY**

---

## **Why**

Major architectural ambiguity resolved.

Critical doctrines stabilized.

Including:

### **AuthPage orchestration root**

### **WaitingPage TRUE REVIEW PAGE**

### **validation-before-transition**

### **edit-return lifecycle**

### **draft state separation**

Ownership boundaries now feel:

### **deterministic.**

---

## **Remaining Risk**

Minimal.

Mostly future scaling concerns.

No critical instability identified.

---

## **Final Assessment**

Architecture no longer feels:

experimental.

It now behaves as:

stable foundation.

---

# **R2 — RUNTIME STABILITY**

---

# **8.5 Assessment**

### **STATUS: READY WITH MONITORING**

---

## **Why**

Runtime significantly stabilized during:

### **EGAL-6.5**

### **EGAL-6.5.5**

Major improvements include:

### **lower lifecycle confusion**

### **safer transitions**

### **reduced stale state**

### **predictable flow behavior**

### **cleaner interaction lifecycle**

---

## **Remaining Risk**

Still monitor:

### **edge-case interaction timing**

Especially:

### **future feature growth.**

No severe blocker currently.

---

## **Final Assessment**

Runtime now feels:

resilient enough for production.

Not fragile.

---

# **R3 — WORKFLOW RELIABILITY**

---

# **8.6 Assessment**

### **STATUS: READY**

---

## **Major Flows**

Stable:

### **Login**

### **Register**

### **JoinClan**

### **CreateClan**

### **WaitingPage review**

### **Edit → Return lifecycle**

### **validation progression**

### **forgot-password recovery**

---

## **UAT Evidence**

Repeated flows successfully passed:

### **real interaction testing.**

Most importantly:

confidence loops stabilized.

---

## **Remaining Risk**

Low.

Mostly future expansion complexity.

---

## **Final Assessment**

Workflow layer now behaves:

### **predictably.**

This is major maturity milestone.

---

# **R4 — UX CONFIDENCE READINESS**

---

# **8.7 Assessment**

### **STATUS: READY**

---

## **Why**

EGAL no longer optimizes merely for:

task completion.

Now optimizes for:

confident completion.

Major improvements include:

### **clearer feedback**

### **reduced hesitation**

### **lower uncertainty**

### **calmer interaction**

### **reassurance-first experience**

---

## **UAT Signals**

Positive indicators:

### **fewer repeated clicks**

### **lower confusion**

### **stronger perceived clarity**

### **better completion confidence**

---

## **Remaining Risk**

Minor refinement opportunities remain.

But no major confidence blockers.

---

## **Final Assessment**

UX now feels:

emotionally trustworthy.

This is major achievement.

---

# **R5 — ACCESSIBILITY SAFETY**

---

# **8.8 Assessment**

### **STATUS: READY WITH FUTURE ENHANCEMENT**

---

## **Why**

Accessibility matured significantly.

Improvements include:

### **message visibility**

### **attention guidance**

### **calmer feedback**

### **readability improvements**

### **confidence-oriented interaction**

---

## **Remaining Gap**

Future potential:

### **stronger voice assistance**

### **larger adaptive text**

### **accessibility personalization**

### **deeper elder support**

---

## **Final Assessment**

Current accessibility sufficient for:

### **production use.**

But expandable.

---

# **R6 — UAT READINESS**

---

# **8.9 Assessment**

### **STATUS: PASS**

---

## **Why**

System survived:

### **repeated real-world usage testing.**

Important:

not just:

### **happy path testing.**

But:

### **hesitation testing**

### **uncertainty testing**

### **confidence testing**

### **edit-return testing**

### **emotional friction testing**

---

## **Major UAT Outcome**

System no longer feels:

unstable.

to users.

This matters enormously.

---

## **Final Assessment**

EGAL achieved:

meaningful UAT maturity.

---

# **R7 — FUTURE EXPANDABILITY**

---

# **8.10 Assessment**

### **STATUS: CAUTIONARY READY**

---

## **Why**

Architecture stable enough to grow.

But:

future growth must remain disciplined.

EGAL now depends heavily on:

### **doctrine preservation.**

Danger comes from:

### **careless feature expansion.**

Not current instability.

---

## **Key Warning**

Future teams must avoid:

### **architecture rewrite temptation**

### **orchestration fragmentation**

### **WaitingPage degradation**

### **confidence removal**

### **speed-over-reassurance decisions**

---

## **Final Assessment**

Expansion possible.

But:

must remain:

doctrine-driven.

---

# **8.11 Production Risk Matrix**

| Area | Status | Risk |
| ----- | ----- | ----- |
| Architecture | Ready | Low |
| Runtime | Ready w/ Monitoring | Low |
| Workflow reliability | Ready | Low |
| UX confidence | Ready | Low |
| Accessibility | Ready w/ Future Enhancement | Medium-Low |
| UAT maturity | PASS | Low |
| Expandability | Cautionary Ready | Medium |

---

# **8.12 What Would Block Production?**

Critical blockers would include:

### **orchestration instability**

### **WaitingPage doctrine regression**

### **broken edit-return lifecycle**

### **invalid-state transitions**

### **repeated UAT confusion**

### **emotional uncertainty resurgence**

### **repeated-click chaos**

Currently:

none are critical blockers.

This is significant.

---

# **8.13 What Production-Ready Means In EGAL**

Production-ready does NOT mean:

perfect.

It means:

### **stable enough**

### **understandable enough**

### **safe enough**

### **confidence-oriented enough**

for meaningful use.

By this definition:

EGAL qualifies.

---

# **8.14 Final Readiness Statement**

Formal assessment:

EGAL-6.x is production-ready.

With conditions:

### **doctrine preservation required**

### **future growth must remain disciplined**

### **elder-first philosophy must remain protected**

### **confidence engineering must remain core priority**

The system now rests on:

trustworthy architecture.

This is the most important outcome.

---

# **PART VIII EXIT CONDITION**

Production readiness assessment is complete when:

team agrees:

### **architecture stable**

### **runtime safe**

### **workflows reliable**

### **UX trustworthy**

### **accessibility sufficient**

### **UAT passed**

### **future growth possible**

WITHOUT:

### **critical instability risk**

### **major confidence breakdown**

### **dangerous architectural fragility**

Meaning:

EGAL is ready for meaningful real-world operation.

# **PART IX — LOCKED DESIGN DOCTRINES (Q1 / Q2 FINALIZATION)**

---

# **9.1 Purpose of PART IX**

PART IX formally locks:

the non-negotiable design doctrines of EGAL.

This section is one of the most important in the entire closeout.

Why?

Because future contributors may eventually ask:

“Can we improve this?”

Without doctrine:

stable systems slowly regress.

Usually:

not through bugs.

But through:

### **well-intentioned changes**

### **local optimization**

### **over-refactor**

### **UX trend adoption**

### **architectural “cleanup”**

Many systems fail this way.

EGAL deliberately prevents that.

This section formally establishes:

protected truths.

Meaning:

future work may extend EGAL,

but must not violate:

### **core architectural philosophy.**

---

# **9.2 Why Q1 / Q2 Became Necessary**

EGAL-6.x repeatedly experienced:

### **regression risk.**

Often caused by:

improvements.

Ironically:

many failures came from:

### **“cleaner architecture”**

### **“simpler UX”**

### **“modern patterns”**

that accidentally broke:

### **confidence**

### **predictability**

### **elder usability**

### **runtime stability**

Repeated UAT revealed:

some things must remain:

protected.

Thus emerged:

### **Q1**

and

### **Q2**

---

# **9.3 Q1 — Preserve Working Business Flow**

## **Formal Definition**

Do not break validated business flow.

Meaning:

If a flow already:

### **PASS UAT**

### **behaves predictably**

### **preserves confidence**

then:

### **preserve it.**

Only improve around it.

Never rewrite casually.

---

## **Why Q1 Exists**

Historically:

regressions often occurred when developers thought:

“This could be cleaner.”

or:

“This feels redundant.”

Then changed flow behavior.

Result:

### **instability**

### **confusion**

### **lost confidence**

---

## **Examples Of Q1 Protection**

Protected:

### **Login flow**

### **Register flow**

### **JoinClan flow**

### **CreateClan flow**

### **WaitingPage lifecycle**

### **Edit → Return lifecycle**

### **validation sequence**

---

## **Q1 Engineering Rule**

Allowed:

### **hardening**

### **polish**

### **reassurance improvement**

### **visibility enhancement**

Forbidden:

### **flow redesign**

### **ownership replacement**

### **hidden progression changes**

---

## **Q1 Principle In One Sentence**

Improve behavior without breaking trust.

---

# **9.4 Q2 — Preserve Existing UX/UI Unless Explicitly Modified**

## **Formal Definition**

Existing UX/UI remains stable unless intentionally changed.

Meaning:

Avoid:

### **accidental redesign.**

Especially:

during unrelated work.

---

## **Why Q2 Exists**

Historically:

small implementation changes unexpectedly altered:

### **interaction expectation**

### **visual hierarchy**

### **confidence rhythm**

### **attention behavior**

Result:

### **user discomfort.**

Especially:

for elderly users.

---

## **Major Discovery Behind Q2**

Elder users build:

interaction memory.

Meaning:

they remember:

### **location**

### **pacing**

### **wording**

### **sequence**

### **visual expectation**

Changing these carelessly creates:

### **cognitive reset.**

Which harms confidence.

---

## **Examples Of Q2 Protection**

Protected:

### **WaitingPage identity**

### **message placement**

### **interaction rhythm**

### **feedback consistency**

### **submit expectation**

### **edit behavior**

---

## **Q2 Engineering Rule**

If change is unrelated:

do not alter UX.

Example:

Bad:

Fix validation.

Accidentally redesign spacing.

Or interaction rhythm.

Correct:

localized patch only.

---

## **Q2 Principle In One Sentence**

Stability of expectation matters.

---

# **9.5 Doctrine \#3**

# **AuthPage Is Orchestration Root**

Permanent architecture law.

---

## **Formal Rule**

AuthPage owns:

### **progression**

### **navigation**

### **lifecycle movement**

### **authentication transition**

### **orchestration authority**

---

## **Child Forms May**

### **collect input**

### **validate locally**

### **display feedback**

---

## **Child Forms Must Never**

### **navigate**

### **redirect**

### **control orchestration**

### **own progression**

---

## **Why Locked**

Repeated experiments showed:

distributed orchestration caused:

### **instability.**

---

## **Permanent Principle**

Single orchestration truth.

---

# **9.6 Doctrine \#4**

# **WaitingPage Is TRUE REVIEW PAGE**

Permanent UX doctrine.

---

## **Formal Rule**

WaitingPage exists for:

### **reassurance**

### **review**

### **editability**

### **confidence**

Not:

### **loading**

### **transport**

### **artificial delay**

---

## **Why Locked**

UAT repeatedly showed:

elder users rely heavily on:

confidence checkpoint.

Removing or weakening WaitingPage reduced:

### **trust.**

---

## **Forbidden Regression**

WaitingPage must never become:

### **spinner page**

### **fake transition**

### **rushed confirmation**

---

## **Permanent Principle**

Confidence before commitment.

---

# **9.7 Doctrine \#5**

# **Validation Before Transition**

Permanent engineering law.

---

## **Formal Rule**

No transition occurs before:

### **valid state confirmed.**

---

## **Why Locked**

Post-transition validation caused:

### **confusion**

### **distrust**

### **stale flow**

---

## **Forbidden**

### **invalid-state progression**

### **delayed critical validation**

### **hidden correction after transition**

---

## **Permanent Principle**

Validity precedes progression.

---

# **9.8 Doctrine \#6**

# **Draft State ≠ Runtime Truth**

Permanent architecture doctrine.

---

## **Formal Rule**

Draft values are:

### **temporary**

### **editable**

### **uncertain**

Runtime truth is:

### **validated**

### **authoritative**

### **trusted**

---

## **Why Locked**

Mixing these created:

### **stale state**

### **broken return flow**

### **confusing lifecycle**

---

## **Forbidden**

Draft state controlling:

### **orchestration**

### **navigation**

### **progression**

---

## **Permanent Principle**

Editable is not authoritative.

---

# **9.9 Doctrine \#7**

# **Elder Confidence Is A Functional Requirement**

One of EGAL’s deepest truths.

---

## **Formal Rule**

Confidence is:

part of correctness.

Not cosmetic enhancement.

---

## **Why Locked**

UAT repeatedly showed:

technical PASS still emotionally failed.

Example:

Login succeeds.

User asks:

“Được chưa?”

Technically PASS.

Emotionally FAIL.

---

## **Engineering Consequence**

System quality includes:

### **reassurance**

### **certainty**

### **calmness**

### **confidence**

---

## **Permanent Principle**

Confidence is functionality.

---

# **9.10 Doctrine \#8**

# **Predictability Over Cleverness**

Permanent UX law.

---

## **Formal Rule**

Favor:

### **familiar behavior**

### **stable rhythm**

### **repeated patterns**

Over:

### **surprising interaction**

### **clever shortcuts**

### **novelty**

---

## **Why Locked**

UAT showed:

elder users depend on:

expectation memory.

Unexpected change created:

### **hesitation.**

---

## **Permanent Principle**

Familiarity reduces burden.

---

# **9.11 Doctrine \#9**

# **Calmness Over Speed**

Permanent interaction philosophy.

---

## **Formal Rule**

If forced to choose:

### **faster**

or

### **calmer**

Choose:

### **calmer.**

---

## **Why Locked**

Elder users prefer:

### **confidence**

over:

### **raw speed.**

---

## **Permanent Principle**

Calmness improves success.

---

# **9.12 Doctrine \#10**

# **Accessibility Is Business Logic**

Permanent engineering doctrine.

---

## **Formal Rule**

Accessibility problems are:

functionality problems.

Not optional enhancements.

---

## **Why Locked**

If elderly users cannot:

### **notice message**

### **understand feedback**

### **recover safely**

then feature failed.

---

## **Permanent Principle**

Accessibility is core behavior.

---

# **9.13 Doctrine Compatibility Matrix**

| Doctrine | Status | Protected |
| ----- | ----- | ----- |
| Q1 Preserve business flow | LOCKED | Yes |
| Q2 Preserve UX/UI | LOCKED | Yes |
| AuthPage orchestration | LOCKED | Yes |
| WaitingPage doctrine | LOCKED | Yes |
| Validation-before-transition | LOCKED | Yes |
| Draft ≠ runtime truth | LOCKED | Yes |
| Confidence \= functionality | LOCKED | Yes |
| Predictability \> cleverness | LOCKED | Yes |
| Calmness \> speed | LOCKED | Yes |
| Accessibility \= business logic | LOCKED | Yes |

---

# **9.14 Final Doctrine Statement**

At closeout:

EGAL no longer relies on:

undocumented intuition.

Its philosophy is now:

### **explicit**

### **protected**

### **repeatable**

### **teachable**

Future development may continue.

But must remain:

doctrine-compatible.

This is how EGAL protects:

### **stability**

### **confidence**

### **elder usability**

over time.

---

# **PART IX EXIT CONDITION**

Doctrine lock is complete when:

team understands:

### **what must never regress**

### **why Q1/Q2 exist**

### **why AuthPage is protected**

### **why WaitingPage is protected**

### **why confidence became engineering requirement**

### **why predictability outranked novelty**

### **why calmness outranked speed**

and ultimately:

### **why doctrine preservation became necessary for EGAL maturity**

# **PART X — FORWARD ROADMAP (POST-6.x / EGAL-7 DIRECTION)**

---

# **10.1 Purpose of PART X**

PART X answers:

What happens after EGAL-6.x?

This section is intentionally:

forward-looking.

But also:

disciplined.

Because after a successful stabilization phase,

many teams make a dangerous mistake:

immediately expand aggressively.

EGAL deliberately avoids this.

Why?

Because:

### **newly stable systems are fragile**

to careless growth.

The purpose of this roadmap is:

to define:

### **what should happen next**

### **what should NOT happen next**

### **what order future work should follow**

### **how to preserve maturity**

while continuing progress.

---

# **10.2 First Principle Of Post-6.x**

EGAL-6.x completed:

### **stabilization**

### **hardening**

### **UX polish**

Meaning:

The next phase is NOT:

rescue architecture.

That phase already happened.

Post-6.x must become:

disciplined expansion.

This distinction matters.

Future work should assume:

foundation already trustworthy.

Do not repeatedly reopen:

### **solved architecture questions.**

Especially:

### **orchestration ownership**

### **WaitingPage identity**

### **validation timing**

### **edit-return lifecycle**

These are:

settled truths.

---

# **10.3 What EGAL-7 Is NOT**

Important protection rule.

EGAL-7 should NOT become:

### **rewrite sprint**

### **architecture replacement**

### **framework experiment**

### **modernization project**

### **visual redesign initiative**

### **trend adoption exercise**

Because:

these activities usually create:

### **regression**

### **instability**

### **confidence erosion**

without meaningful elder benefit.

---

## **Explicit Non-Goals**

EGAL-7 should not pursue:

❌ AuthPage redesign

❌ WaitingPage removal

❌ aggressive minimalism

❌ startup-style UX

❌ novelty-first interaction

❌ orchestration decentralization

❌ validation relaxation

❌ speed-over-confidence optimization

These would violate:

EGAL maturity.

---

# **10.4 Recommended Direction \#1**

# **Elder Guidance Enhancement**

Highest recommended priority.

---

## **Why**

EGAL already improved:

### **confidence.**

But guidance can still deepen.

Especially for:

### **uncertain moments.**

Examples:

### **first registration**

### **clan joining**

### **family relation selection**

### **confirmation decisions**

---

## **Potential Future Areas**

### **smarter contextual guidance**

### **elder-friendly explanation hints**

### **terminology assistance**

### **contextual reassurance**

### **lightweight onboarding**

---

## **Constraint**

Must remain:

### **calm**

### **unobtrusive**

### **optional**

Never:

### **overwhelming**

### **noisy**

### **tutorial-heavy**

---

## **Recommended Priority**

### **HIGH**

---

# **10.5 Recommended Direction \#2**

# **Genealogy Terminology Simplification**

Important long-term opportunity.

---

## **Why**

Genealogy naturally introduces:

### **historical language**

### **family hierarchy complexity**

### **relationship ambiguity**

Some elderly users still experience:

### **interpretation friction.**

---

## **Potential Future Areas**

### **contextual definitions**

### **elder glossary**

### **relationship explanation**

### **visual kinship assistance**

---

## **Constraint**

Must avoid:

### **academic overload.**

Keep explanations:

### **simple**

### **human-readable**

### **reassuring**

---

## **Recommended Priority**

### **HIGH–MEDIUM**

---

# **10.6 Recommended Direction \#3**

# **Accessibility Layer 2.0**

Meaningful future investment.

---

## **Why**

Accessibility improved significantly.

But can still deepen.

Especially:

for older users with:

### **eyesight decline**

### **slower reading**

### **lower technical confidence**

---

## **Potential Future Areas**

### **larger adaptive typography**

### **optional elder mode**

### **stronger contrast system**

### **improved focus visibility**

### **keyboard accessibility**

### **screen-reader friendliness**

---

## **Constraint**

Must remain:

### **optional.**

Never force alternative UX.

---

## **Recommended Priority**

### **MEDIUM–HIGH**

---

# **10.7 Recommended Direction \#4**

# **Optional Voice Guidance**

Potentially transformative.

But must be cautious.

---

## **Why**

Voice reinforcement already showed value.

Some users benefit from:

### **reassurance through hearing.**

Especially during:

### **uncertainty moments.**

---

## **Potential Future Areas**

### **optional spoken guidance**

### **submit reassurance**

### **review assistance**

### **contextual instruction**

---

## **Critical Constraint**

Must remain:

optional.

Never:

### **intrusive**

### **overly talkative**

### **cognitively noisy**

Voice must support:

### **calmness.**

Not distraction.

---

## **Recommended Priority**

### **MEDIUM**

---

# **10.8 Recommended Direction \#5**

# **Mobile Elder Ergonomics**

Future refinement opportunity.

---

## **Why**

Many elderly users increasingly use:

### **phones**

### **tablets**

instead of desktop.

Long-term comfort matters.

---

## **Potential Future Areas**

### **touch-target optimization**

### **thumb-friendly spacing**

### **reduced scrolling burden**

### **clearer mobile focus behavior**

---

## **Constraint**

Never break:

### **desktop confidence.**

---

## **Recommended Priority**

### **MEDIUM**

---

# **10.9 Recommended Direction \#6**

# **Confidence Analytics**

Interesting future possibility.

---

## **Why**

Current confidence measurement remains:

### **observational.**

through:

### **hesitation**

### **repeated clicking**

### **UAT observation**

Could become:

### **measurable.**

---

## **Potential Future Areas**

### **hesitation detection**

### **repeated-submit tracking**

### **correction frequency**

### **confidence indicators**

---

## **Constraint**

Must avoid:

### **invasive analytics.**

Must remain:

### **respectful.**

---

## **Recommended Priority**

### **LOW–MEDIUM**

---

# **10.10 Recommended Direction \#7**

# **Architecture Segmentation (Only When Necessary)**

Long-term engineering consideration.

---

## **Why**

As EGAL grows:

AuthPage orchestration may eventually become:

### **large.**

Potential future need:

### **orchestration modularization.**

---

## **Critical Warning**

Must NOT violate:

single orchestration doctrine.

Meaning:

Segmentation ≠ decentralization.

---

## **Constraint**

No premature refactor.

Only act when:

### **genuine complexity appears.**

---

## **Recommended Priority**

### **LOW**

---

# **10.11 Roadmap Priority Matrix**

| Direction | Priority | Time Horizon |
| ----- | ----- | ----- |
| Elder guidance enhancement | High | Near-term |
| Genealogy terminology simplification | High–Medium | Near-term |
| Accessibility Layer 2.0 | Medium–High | Mid-term |
| Voice guidance | Medium | Mid-term |
| Mobile elder ergonomics | Medium | Mid-term |
| Confidence analytics | Low–Medium | Long-term |
| Architecture segmentation | Low | Long-term |

---

# **10.12 Recommended Post-6.x Strategy**

Recommended order:

---

## **Phase A — Protect Stability**

Goal:

do no harm.

Focus:

### **doctrine preservation**

### **regression prevention**

### **maintaining confidence**

---

## **Phase B — Improve Guidance**

Goal:

reduce remaining uncertainty.

Focus:

### **terminology clarity**

### **elder assistance**

### **contextual support**

---

## **Phase C — Deep Accessibility**

Goal:

widen inclusion.

Focus:

### **elder ergonomics**

### **optional accessibility modes**

### **adaptive support**

---

## **Phase D — Scale Carefully**

Goal:

sustainable growth.

Focus:

### **architecture discipline**

### **orchestration integrity**

### **feature compatibility**

---

# **10.13 Final Warning To Future Teams**

The greatest risk to EGAL is no longer:

instability.

The greatest risk now is:

forgetting why the system works.

Meaning:

future teams may unintentionally remove:

### **reassurance**

### **predictability**

### **calmness**

### **redundancy**

in pursuit of:

### **speed**

### **simplicity**

### **modern trends**

This would be:

regression disguised as improvement.

---

# **10.14 Final Future Statement**

EGAL-6.x did not finish the project.

It achieved something more important:

trustworthy foundations.

Future work should therefore ask:

not:

“How can we modernize this?”

But:

“How can we deepen confidence without breaking trust?”

That question defines:

mature EGAL.

---

# **FINAL EXIT CONDITION — EGAL-6.x CLOSED**

EGAL-6.x officially closes when:

team accepts:

### **architecture stabilized**

### **hardening completed**

### **UX polish completed**

### **doctrines locked**

### **technical debt manageable**

### **production readiness achieved**

### **roadmap established**

and most importantly:

### **elderly users can now interact calmly, predictably, and confidently.**

This is the intended outcome of:

EGAL-6.x Foundation Era.

# **APPENDIX — TIMELINE & KEY COMPONENTS**

---

# **A.1 Purpose of Appendix**

This appendix serves as:

historical engineering reference.

It summarizes:

### **timeline evolution**

### **key architecture decisions**

### **doctrine emergence**

### **stabilization milestones**

### **major components**

### **critical turning points**

The goal:

Future contributors should be able to answer:

“How did EGAL become what it is?”

without reading every sprint chronicle.

---

# **A.2 High-Level Timeline Overview**

| Phase | Goal | Outcome |
| ----- | ----- | ----- |
| Pre-6.x | Functional experimentation | Unstable but promising |
| EGAL-6.1 | Stabilization | Reduced chaos |
| EGAL-6.2 | Orchestration discovery | AuthPage doctrine |
| EGAL-6.3 | WaitingPage identity | TRUE REVIEW PAGE |
| EGAL-6.4 | Validation & edit-return | Lifecycle stabilization |
| EGAL-6.5 | UAT stabilization | PASS baseline |
| EGAL-6.5.5 | Hardening | Confidence safety |
| EGAL-6.6 | UX polish | Emotional maturity |
| Post-6.x | Controlled growth | Doctrine-protected future |

---

# **A.3 Pre-6.x Era**

## **Characteristic**

System already existed.

But maturity level:

unstable-functional.

Meaning:

features worked.

But behavior felt:

### **inconsistent**

### **emotionally fragile**

### **difficult to trust**

---

## **Major Problems**

### **orchestration ambiguity**

### **WaitingPage confusion**

### **stale validation**

### **edit-return instability**

### **confidence breakdown**

### **lifecycle unpredictability**

---

## **User Experience**

Common feeling:

“Không chắc chuyện gì đang xảy ra.”

---

## **Historical Importance**

This instability created:

necessity for EGAL-6.x.

---

# **A.4 EGAL-6.1 Timeline**

## **Primary Goal**

establish order.

---

## **Focus**

### **flow stabilization**

### **progression consistency**

### **runtime cleanup**

### **reducing chaos**

---

## **Major Outcome**

First movement toward:

architectural discipline.

Still incomplete.

But direction became clearer.

---

## **Key Learning**

Uncontrolled ownership creates:

### **instability.**

---

# **A.5 EGAL-6.2 Timeline**

## **Primary Goal**

determine orchestration truth.

---

## **Architectural Crisis**

Question emerged:

Who owns progression?

Conflicting ownership created:

### **runtime confusion.**

---

## **Major Outcome**

### **AuthPage doctrine emerged.**

AuthPage became:

orchestration root.

---

## **Historical Significance**

One of the most important EGAL decisions.

Permanent architectural milestone.

---

# **A.6 EGAL-6.3 Timeline**

## **Primary Goal**

define WaitingPage identity.

---

## **UX Crisis**

Question:

What is WaitingPage?

Possibilities included:

### **loading**

### **temporary transport**

### **confirmation**

### **review**

---

## **UAT Discovery**

Elder users naturally used WaitingPage for:

### **reassurance.**

---

## **Major Outcome**

WaitingPage formally became:

TRUE REVIEW PAGE.

---

## **Historical Significance**

Permanent confidence doctrine.

---

# **A.7 EGAL-6.4 Timeline**

## **Primary Goal**

stabilize edit-return lifecycle.

---

## **Problems**

### **stale validation**

### **broken return state**

### **confidence collapse after edit**

---

## **Major Outcome**

### **Edit → Return stabilized**

### **Validation-before-transition doctrine formed**

### **Draft state separation clarified**

---

## **Historical Significance**

Critical lifecycle maturity point.

---

# **A.8 EGAL-6.5 Timeline**

## **Primary Goal**

survive UAT.

---

## **Focus**

### **reliability**

### **consistency**

### **runtime stability**

### **confidence preservation**

---

## **Major Outcome**

PASS UAT baseline.

Critical milestone.

---

## **Historical Significance**

EGAL finally became:

### **dependable.**

---

# **A.9 EGAL-6.5.5 Timeline**

## **Primary Goal**

harden confidence.

---

## **Trigger**

UAT revealed:

technical PASS ≠ emotional PASS.

---

## **Focus**

### **login reassurance**

### **visibility**

### **submit certainty**

### **accessibility safety**

### **duplicate-click prevention**

---

## **Major Outcome**

Reduced:

### **hesitation**

### **uncertainty**

### **missed feedback**

---

## **Historical Significance**

Confidence formally became:

engineering requirement.

---

# **A.10 EGAL-6.6 Timeline**

## **Primary Goal**

emotional maturity.

---

## **Focus**

### **micro-interactions**

### **calmness**

### **predictability**

### **readability**

### **reassurance**

---

## **Major Outcome**

System became:

### **calmer**

### **easier**

### **more elder-friendly**

without redesign.

---

## **Historical Significance**

EGAL matured beyond:

functional correctness.

Toward:

effortless confidence.

---

# **A.11 Major Components Overview**

---

## **AuthPage**

### **Role**

orchestration root.

---

### **Owns**

### **navigation**

### **authentication transition**

### **progression**

### **lifecycle**

---

### **Protected Doctrine**

Must never decentralize orchestration.

---

## **LoginForm**

### **Role**

authentication interaction.

---

### **Owns**

### **credential input**

### **local validation**

### **feedback**

### **reassurance**

---

### **Does NOT Own**

### **navigation authority**

---

## **RegisterForm**

### **Role**

guided account creation.

---

### **Focus**

### **manageable cognitive load**

### **confidence**

### **recoverability**

---

## **JoinClanForm**

### **Role**

genealogy relationship entry.

---

### **Focus**

### **confidence before commitment**

### **family correctness reassurance**

---

## **CreateClanForm**

### **Role**

clan establishment workflow.

---

### **Focus**

### **approachable seriousness**

### **confidence-oriented completion**

---

## **WaitingPage**

### **Role**

TRUE REVIEW PAGE.

---

### **Purpose**

### **review**

### **reassurance**

### **editability**

### **confidence**

---

### **Never Becomes**

### **loading screen**

### **transport page**

### **fake delay**

---

## **ForgotPasswordForm**

### **Role**

recovery reassurance.

---

### **Focus**

### **emotional recovery**

### **retry confidence**

### **calm guidance**

---

# **A.12 Final Doctrine Summary**

| Doctrine | Meaning |
| ----- | ----- |
| Q1 | Preserve validated flow |
| Q2 | Preserve stable UX/UI |
| AuthPage | Single orchestration truth |
| WaitingPage | TRUE REVIEW PAGE |
| Validation | Before transition |
| Draft State | Not runtime truth |
| Confidence | Functional requirement |
| Predictability | Over cleverness |
| Calmness | Over speed |
| Accessibility | Business logic |

---

# **A.13 Final Engineering Transformation**

EGAL evolved from:

unstable but functional

into:

stable, confidence-oriented elder system.

Transformation occurred across:

### **architecture**

### **runtime**

### **validation**

### **emotional UX**

### **accessibility**

### **doctrine**

simultaneously.

---

# **A.14 Final Historical Statement**

EGAL-6.x should be remembered as:

the foundation era.

Not because:

new features exploded.

But because:

the project finally learned:

how to become trustworthy.

This trust became possible through:

### **stabilization**

### **hardening**

### **UX maturity**

### **doctrine protection**

### **elder-first thinking**

Together:

these transformed EGAL into:

confidence engineering for genealogy.

---

# **APPENDIX EXIT CONDITION**

Appendix is complete when:

future contributors can understand:

### **how EGAL evolved**

### **why architecture stabilized**

### **why doctrines exist**

### **what major milestones happened**

### **which components matter most**

and ultimately:

### **why EGAL became elder-first confidence architecture.**

## ​​

