---
name: dev-flow
description: >
  Human-gated software development workflow for Pareto planning,
  specification, minimal ticket decomposition, delegated implementation,
  independent two-axis PR review, pull request understanding, and controlled
  revisions. Coordinates grill-with-docs, to-spec, to-tickets, implement,
  code-review, understand-pr, and a configured implementation handoff.
---

# Dev Flow

Coordinate substantial software development work from initial idea through planning, tickets, implementation, pull request review, and revisions.

This workflow is intentionally human-gated.

The user owns:

- product decisions;
- architecture approval;
- ticket approval;
- implementation authorization;
- revision approval;
- merge decisions.

Never cross a human gate implicitly.

Use the installed specialized skills for their respective jobs rather than reimplementing, approximating, or substituting their internal behavior:

- `grill-with-docs`
- `to-spec`
- `to-tickets`
- `implement`
- `code-review`
- `understand-pr`

When this workflow names a skill, invoke that exact skill.

Do not substitute a similarly named skill, a lower-level skill used internally by it, or your own approximation of its workflow.

The named skill owns its internal composition. For example, if `grill-with-docs` internally invokes or coordinates other skills, let `grill-with-docs` control that behavior rather than invoking those pieces independently.

If a required skill cannot be found or invoked, stop and report the problem instead of silently substituting another workflow.

Use the configured `implementation` handoff for implementation work. The
handoff is a host capability, not a provider, model, or transport requirement
of this skill. If it is unavailable, stop and report the problem rather than
silently substituting another worker. Read
[the implementation handoff contract](references/implementation-handoff.md)
when this packaged reference is available.

Always read and obey applicable `AGENTS.md` instructions.

---

# Core principles

## Human-controlled orchestration

Automate execution aggressively below an approved decision boundary.

Do not automate crossing the decision boundary itself.

A completed phase does not automatically authorize the next phase.

When this workflow says `STOP`, return control to the user and wait for explicit authorization.

## Pareto principle

Optimize for the smallest amount of human decision-making that safely resolves the largest amount of important uncertainty.

Prefer:

- important decisions over exhaustive decisions;
- recommended defaults over unnecessary questions;
- minimal coherent tickets over excessive fragmentation;
- Quick Reads over forcing the user to inspect every detail;
- focused implementation agents over implementation noise in the coordinator thread.

Do not use Pareto simplification to hide meaningful risk or unresolved architecture decisions.

## Coordinator and worker separation

The main agent is the coordinator.

The coordinator owns:

- discussion;
- requirements;
- planning;
- architecture decisions with the user;
- specifications;
- ticket planning;
- human approval gates;
- independent post-implementation review;
- PR understanding;
- revision planning.

The configured `implementation` handoff is the worker.

The coordinator must not make code changes in parallel with an active implementation worker.

Review findings discovered by `code-review` or `understand-pr` never transfer
implementation ownership to the coordinator.

### Worker ownership and waiting

Once work is delegated to the `implementation` agent, that worker owns the
entire delegated implementation lifecycle until it explicitly returns control.

This includes:

- repository investigation;
- implementation;
- tests and builds;
- browser or UI verification;
- implementation-local verification and reviews required by `implement`;
- commits and pushes;
- PR creation or updates;
- final reporting.

The worker's implementation-local review does not satisfy the independent
`code-review` gate. That gate begins only after the worker returns its final
handoff.

The coordinator must wait for the worker's final handoff.

Elapsed time, silence, long-running verification, browser automation, context
compaction, or delayed final reporting are NOT evidence that the worker is
stuck.

The coordinator may request a concise progress update, but a progress request
must not interrupt or terminate the worker.

If the worker reports that it is still progressing, continue waiting.

While the worker owns the task, the coordinator must NOT:

- interrupt or close the worker because it appears slow;
- take over repository work;
- inspect or modify the worker's branch as a substitute for waiting;
- rerun the worker's tests, builds, reviews, or verification;
- invoke replacement implementation or independent review workers;
- create or update the PR on the worker's behalf.

Only reclaim implementation ownership if the worker:

- explicitly reports that it cannot continue;
- explicitly requests a material decision;
- explicitly returns control with unfinished work; or
- is explicitly reported by the agent runtime as failed or terminated.

If recovery is required, return control to the user and explain the situation
before performing or delegating replacement work.

After the worker's explicit final handoff, implementation ownership returns to
the coordinator. The coordinator then invokes the independent `code-review`
gate before invoking `understand-pr`.

---
# Resume behavior

Dev Flow must not depend on a single conversation session.

When invoked with `resume`, or when the user clearly asks to continue an existing Dev Flow workflow in a fresh session:

1. Read applicable `AGENTS.md`.
2. Read the provided or discoverable spec, ticket, and PR.
3. Reconstruct the current workflow phase from those canonical artifacts.
4. Give the user a short Quick Resume:
   - what is done;
   - what is current;
   - what matters;
   - recommended next step.
5. Preserve all human gates.
6. Do not assume implementation or revision authorization from a previous session unless the user clearly provides it again.
7. Continue from the reconstructed phase instead of restarting Dev Flow from Phase 1.
---

# Phase 1 — Pareto planning

For substantial work, invoke `grill-with-docs` directly.

Do not invoke `grilling` as a substitute. Any lower-level skills used by
`grill-with-docs` are its implementation detail.

Apply the Pareto constraints below around the resulting planning process
without bypassing or replacing `grill-with-docs`.

## Ask only high-value questions

Only ask the user questions that materially affect:

- architecture;
- domain behavior or business rules;
- public/API contracts;
- persistence or data model;
- security;
- significant user-facing behavior;
- expensive-to-reverse decisions.

Do not ask about reversible implementation details when a strong default can safely be inferred.

Before asking a question, first investigate whether the answer can be obtained from:

- the codebase;
- applicable `AGENTS.md`;
- existing project documentation;
- established project conventions;
- previously agreed decisions in the current conversation.

If those sources answer the question sufficiently, infer the answer instead.

## Question style

When a question is necessary:

1. explain the decision briefly;
2. use simplified technical English;
3. avoid unnecessary jargon;
4. present only meaningful options;
5. recommend the option that appears best;
6. briefly explain why it is recommended.

Prefer approximately 3–7 high-value decisions for normal work rather than exhaustive interrogation.

This is a guideline, not a hard limit.

Ask more questions when meaningful unresolved risk genuinely requires them.

If the user repeatedly accepts recommended options and the remaining decisions are low-risk or reversible, prefer sensible defaults rather than continuing to interrogate.

## Planning result

At the end of grilling, provide a concise decision summary:

### Decisions made
Important decisions explicitly approved by the user.

### Defaults inferred
Low-risk decisions inferred from the codebase, conventions, or recommended defaults.

### Important constraints
Constraints implementation must preserve.

### Unresolved risks
Only material unresolved risks, if any.

Do not implement during planning.

---

# Phase 2 — Specification

Once material decisions are resolved, use `to-spec` when the work benefits from a durable implementation contract.

The specification must preserve the decisions reached during planning.

Do not silently reopen or change settled decisions.

If producing the specification reveals a material contradiction or unresolved architectural decision, return to discussion with the user.

The specification is the canonical implementation contract for subsequent ticketing.

---

# Phase 3 — Pareto ticketing

Use `to-tickets` to derive implementation tickets from the approved specification.

Then perform a ticket compression pass before presenting the result.

## Optimize for minimal coherent tickets

Use the minimum number of tickets that keeps implementation and review reasonably safe and understandable.

Target approximately 2–4 tickets for a normal feature or architectural change.

Prefer four strong tickets over eight granular tickets.

This is a target, not a hard maximum.

Create more than four tickets only when there is a strong reason, such as:

- genuinely independent workstreams;
- substantial risk boundaries;
- independently useful/deployable milestones;
- unavoidable sequencing boundaries;
- a combined ticket would become too large or unsafe to implement and review.

## Combine related work

Prefer combining work when it:

- implements the same user-facing behavior;
- depends on the same architecture decision;
- naturally belongs in one vertical slice;
- is likely to be implemented and reviewed together;
- would leave an awkward intermediate repository state if split.

Do not create separate tickets merely to isolate:

- tests from their implementation;
- small refactors required by the feature;
- documentation required by the same change;
- migrations required solely by the same feature;
- closely coupled frontend and backend changes;
- cleanup that is naturally part of completing the implementation.

## Compression pass

Before presenting the ticket set, explicitly ask internally:

> Can any of these tickets be safely combined without making implementation, verification, or review significantly harder?

If yes, combine them.

Do not expose unnecessary intermediate decompositions to the user.

---

# Ticket Plan Quick Read

Before the full ticket drafts, provide:

## Quick Read

**Recommended:** N tickets

**Why this number:**  
Briefly explain why this is the smallest sensible decomposition.

**Tickets:**

1. Ticket purpose in one sentence.
2. Ticket purpose in one sentence.
3. Ticket purpose in one sentence.

**Sequence:**  
Briefly explain important dependencies or state that the tickets are independent.

Keep this section highly scannable.

---

# Quick Read for every ticket

Every draft ticket must begin with:

## Quick Read

**What changes**  
The core change in simple language.

**Why**  
Why this ticket exists.

**Architectural / domain impact**  
Call out meaningful architecture, domain, persistence, API, or behavioral changes.

Write `None` when there is no meaningful impact.

**Important**  
The assumption, behavior, compatibility constraint, or architectural decision most likely to be missed when skimming.

**Done when**  
A concise description of the successful end state.

The Quick Read should contain roughly the 20% of information needed to understand 80% of the ticket.

The detailed ticket follows the Quick Read.

---

# HUMAN GATE 1 — Ticket creation

After presenting the complete draft ticket set:

**STOP.**

Do not create GitHub issues automatically.

Ask the user to review and approve the ticket set.

Examples that are NOT approval:

- asking a question about a ticket;
- requesting a wording change;
- suggesting tickets should be combined;
- discussing ticket ordering;
- saying a ticket generally looks good while requesting changes elsewhere.

Only clear approval of the final ticket set authorizes ticket creation.

After approval:

1. create the approved tickets;
2. return their full URLs;
3. identify the recommended first ticket;
4. do not begin implementation.

Then:

**STOP.**

Ask whether the user wants to kick off the recommended first ticket.

---

# HUMAN GATE 2 — Implementation

Ticket creation does not authorize implementation.

Never automatically start the first or next ticket.

Only explicit authorization to start a specific ticket permits implementation.

When the user approves implementation:

1. resolve the full GitHub ticket URL;
2. invoke the configured `implementation` handoff;
3. state that the user explicitly approved implementation;
4. instruct the worker to use `implement` with the full ticket URL;
5. instruct it to read and obey applicable `AGENTS.md`;
6. delegate repository exploration, implementation, implementation-local tests
   and reviews, commits, pushes, and PR handling to the worker;
7. wait for the worker's explicit final handoff; follow the Worker ownership and waiting rules while it is active.

Do not implement code concurrently in the coordinator thread.

If the implementation worker reports a genuinely unresolved material decision, return that decision to the user.

Do not silently resolve a material product or architecture decision merely to keep implementation moving.

When implementation finishes and a PR has been created or updated:

1. receive the worker's explicit final handoff;
2. capture the resulting full PR URL;
3. resolve the PR's base branch or merge-base as the fixed point for review;
4. invoke the exact `code-review` skill in an independent review context,
   supplying the full PR URL, fixed point, ticket/spec context, and the latest
   diff;
5. let `code-review` run its separate Standards and Spec axes and aggregate
   their findings;
6. if either axis has an actionable finding, do not invoke `understand-pr`;
   aggregate the findings, create a concise Revision Contract, and stop at
   HUMAN GATE 3;
7. if both axes have no actionable findings, invoke the exact `understand-pr`
   skill automatically using the full PR URL;
8. let `understand-pr` complete its human-oriented comprehension workflow;
9. present the resulting PR understanding to the user;
10. return control to the user.

The user should not need to manually ask for either independent review or PR
understanding after every implementation.

Do not substitute a coordinator-written PR summary for `understand-pr`.

The implementation worker's final report is an implementation handoff, not the
independent review or final human review.

Do not automatically begin the next ticket.

---
# Phase 4 — Independent two-axis review

Every completed implementation PR must pass the exact `code-review` skill
before it reaches `understand-pr` or the user.

This phase is part of the normal Dev Flow lifecycle, not an optional follow-up.

The coordinator must invoke `code-review` in an independent review context
after every implementation or revision handoff. Supply the full PR URL, the
original ticket/spec context, and a resolved fixed point: the PR's base branch
or its merge-base commit. Do not invent a fixed point; resolve it from the PR
or repository before invoking the skill.

`code-review` owns the review mechanics. Its Standards and Spec axes must run
as separate parallel reviewers and remain separate in the aggregated report.
Any review performed inside the implementation worker is implementation-local
verification and does not satisfy this gate.

The latest PR state must pass both axes before `understand-pr` is invoked.

## Findings from `code-review`

When either axis returns an actionable finding:

1. aggregate and deduplicate the findings without collapsing the Standards and
   Spec axes;
2. explain the findings to the user in simplified technical English;
3. identify whether each finding is a requirement mismatch, correctness defect,
   architectural concern, maintainability concern, or minor observation;
4. recommend which findings require revision before merge;
5. create one concise Revision Contract for the agreed code changes;
6. STOP at HUMAN GATE 3.

Do not invoke `understand-pr` while actionable independent-review findings
remain unresolved.

When both axes have no actionable findings, invoke the exact `understand-pr`
skill automatically using the full PR URL.

---

# Phase 5 — Automatic pull request understanding

Every completed implementation PR must pass through `understand-pr`
automatically after a clean independent two-axis review and before the
coordinator returns the PR to the user.

This phase is part of the normal Dev Flow lifecycle, not an optional follow-up.

## Findings from `understand-pr`

`understand-pr` may discover implementation defects, requirement mismatches,
architectural concerns, or missing acceptance criteria while explaining the PR.

These findings are review results only.

They do NOT authorize the coordinator to modify code, update the branch,
create commits, or change the PR directly.

When `understand-pr` finds an actionable issue:

1. explain the finding to the user in simplified technical English;
2. identify whether it is:
   - a requirement mismatch;
   - a correctness defect;
   - an architectural concern;
   - a maintainability concern;
   - or a minor/non-blocking observation;
3. recommend whether it should be fixed before merge;
4. if a code change is recommended, create a concise Revision Contract;
5. STOP at HUMAN GATE 3.

Do not implement the fix in the coordinator session.

Only explicit user approval of the Revision Contract authorizes a fresh
`implementation` agent to update the existing PR.

---

# Concerns during PR review

A concern raised during PR review is a discussion input.

It is NOT implementation authorization.

Examples:

- "I don't like this abstraction."
- "Why did this introduce another service?"
- "Could we reuse the existing repository?"
- "This behavior seems wrong."
- "I think this is more complicated than necessary."

When the user raises a concern:

1. investigate the relevant PR, ticket, spec, code, and project conventions;
2. determine whether the concern represents:
   - a real problem;
   - a trade-off;
   - a misunderstanding;
   - a preference;
3. explain the finding in simplified technical English;
4. recommend the best course of action;
5. discuss material alternatives with the user when necessary.

Do not invoke the implementation handoff yet.

Reach agreement on the desired revision first.

---

# Revision Contract

When a PR revision is agreed, summarize the agreement before implementation.

Use:

## Revision Contract

### Concern

What problem or concern was identified.

### Agreed change

Exactly what should change.

### Keep unchanged

Previously approved behavior, architecture, APIs, data, or other constraints that must remain intact.

### Verify

Concrete checks demonstrating that the revision was implemented correctly.

Keep the contract concise.

It should contain the final agreed decision, not the entire discussion that produced it.

---

# HUMAN GATE 3 — Revision implementation

After presenting the Revision Contract:

**STOP.**

Do not edit code.

Do not invoke the implementation handoff.

Wait for explicit user approval.

When the user approves the revision:

1. resolve the original full ticket URL;
2. resolve the existing full PR URL;
3. invoke a fresh `implementation` handoff;
4. provide:
   - the ticket URL;
   - the existing PR URL;
   - the Revision Contract;
5. explicitly state that this is a revision of an existing implementation;
6. instruct the worker to:
   - use the existing PR branch;
   - update the existing implementation;
   - update the SAME PR;
   - not create another PR;
   - preserve previously approved behavior unless the Revision Contract overrides it;
   - read and obey applicable `AGENTS.md`;
   - use the `implement` workflow against the updated requirements;
7. wait for completion.

When finished:

- receive the worker's explicit final handoff;
- resolve the existing PR's base branch or merge-base as the fixed point;
- invoke the independent `code-review` gate again against the latest PR state;
- if either axis has actionable findings, repeat the Revision Contract cycle;
- only after both axes are clean, invoke `understand-pr` again;
- summarize the revision result and return the existing PR URL;
- return control to the user.

Do not automatically merge.

The independent two-axis review is mandatory after every revision. No updated
PR reaches `understand-pr` until its latest state passes both axes.

Repeat the concern → Revision Contract → approval → implementation cycle as many times as necessary.

---

# HUMAN GATE 4 — Merge

Never merge a pull request merely because:

- implementation completed;
- tests passed;
- CI passed;
- code review passed;
- spec review passed;
- `understand-pr` found no major concerns;
- the PR appears mergeable.

Follow applicable `AGENTS.md` merge rules.

The merge decision belongs to the user.

Do not interpret ambiguous positive language as authorization to merge.

If the user explicitly requests merge and repository instructions permit it, follow the applicable repository workflow.

---

# Multiple-ticket progression

After a ticket's PR is completed or merged, do not automatically begin the next ticket.

Identify the recommended next ticket and return control to the user.

Ask whether they want to kick it off.

The user may:

- continue;
- stop;
- reprioritize;
- revise remaining tickets;
- inspect the product;
- change the plan based on what was learned.

Treat each ticket implementation as independently authorized.

---

# Existing PR revisions

Never assume that re-running `implement` means creating a new implementation from scratch.

When a revision targets an existing PR, always provide the worker with both:

- the original full ticket URL;
- the existing full PR URL.

The existing PR is the continuation target.

The worker must update its branch and PR rather than creating a duplicate.

---

# Repository instructions

`AGENTS.md` owns repository-specific behavior.

Examples include:

- architecture conventions;
- development commands;
- test commands;
- branch strategy;
- commit requirements;
- push requirements;
- PR creation rules;
- PR update rules;
- merge restrictions.

Do not unnecessarily duplicate these rules in tickets or this workflow.

Read and follow them.

If `AGENTS.md` conflicts with this workflow on repository mechanics, follow the applicable repository instruction.

Human authorization gates in this workflow must still be respected.

---

# Skill responsibilities

Keep responsibilities separated.

`grill-with-docs`
: Investigate and resolve important planning decisions with the user.

`to-spec`
: Convert agreed decisions into a durable implementation specification.

`to-tickets`
: Convert the specification into implementation tickets.

`dev-flow`
: Apply Pareto constraints, compress ticket decomposition, enforce human gates, and coordinate the overall lifecycle.

Configured `implementation` handoff
: Perform approved implementation or revision work.

`implement`
: Drive implementation, verification, and implementation-level review inside the worker.

`code-review`
: Run the independent parallel Standards and Spec review after every implementation or revision handoff.

`understand-pr`
: Help the user understand the resulting PR after the independent review is clean.

Do not recreate specialized skill behavior inside `dev-flow` when the specialized skill already owns it.

---

# Context management

Keep the coordinator context focused on:

- intent;
- decisions;
- architecture;
- specifications;
- ticket plans;
- approvals;
- PR understanding;
- revision decisions.

Delegate implementation noise to the implementation worker.

Do not copy large test logs, diffs, or exploratory output back into the coordinator thread unless they reveal information the user needs to understand or decide.

Preserve agreed decisions across phases.

Do not repeatedly ask the user to reconfirm decisions already explicitly made.

---

# URLs

Use full GitHub URLs when handing work between agents.

Prefer:

`https://github.com/org/repo/issues/123`

over:

`#123`

Prefer:

`https://github.com/org/repo/pull/456`

over:

`PR #456`

This reduces ambiguity for fresh-context workers.

---

# Failure and escalation

If a specialized skill, configured handoff, repository instruction, required tool, ticket, or PR cannot be resolved:

- do not improvise a destructive workaround;
- explain the blocker concisely;
- return control to the user when their input is required.

If implementation discovers a material decision not covered by the approved spec/ticket:

- stop implementation;
- escalate the decision to the coordinator;
- resolve it with the user;
- update the implementation contract as needed;
- resume only after approval.

Prefer stopping at an uncertainty boundary over silently making an expensive-to-reverse decision.

---

# Desired workflow

The normal lifecycle is:

Idea  
→ Pareto `grill-with-docs`  
→ `to-spec`  
→ Pareto `to-tickets`  
→ ticket compression  
→ Ticket Plan Quick Read  
→ per-ticket Quick Reads  
→ **HUMAN APPROVAL**  
→ create tickets  
→ **STOP**  
→ ask to start first ticket  
→ **HUMAN APPROVAL**  
→ invoke `implementation` handoff  
→ `implement <full-ticket-url>`  
→ PR  
→ return to coordinator  
→ independent `code-review` (Standards + Spec) <br>
→ clean review <br>
→ `understand-pr <full-pr-url>` with the user  
→ merge if explicitly authorized

If revision is needed:

PR concern  
→ investigate and discuss  
→ agree revision  
→ Revision Contract  
→ **HUMAN APPROVAL**  
→ fresh `implementation` agent  
→ original ticket + existing PR + Revision Contract  
→ update SAME PR  
→ return to coordinator  
→ independent `code-review` again <br>
→ clean review <br>
→ `understand-pr` again  
→ repeat if necessary  
→ merge if explicitly authorized
