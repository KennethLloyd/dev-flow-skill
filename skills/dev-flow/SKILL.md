---
name: dev-flow
description: Human-gated workflow from idea to reviewed pull request, with Pareto planning, Quick Reads, delegated implementation, and explicit approval gates.
disable-model-invocation: true
---

# Dev Flow

Use this workflow for substantial software work that needs a clear path from
idea to merge:

```text
Pareto planning → specification → minimal tickets → implementation
→ independent Standards/Spec review → understand-pr → human merge decision
```

The workflow's differentiators are:

- Pareto planning: resolve the most important uncertainty first.
- Quick Reads: make each plan and ticket easy to scan.
- Human gates: keep product, architecture, implementation, revision, and merge
  authorization with the user.
- Delegated implementation: keep repository-heavy work out of the coordinator
  conversation while preserving worker ownership.
- Independent review: run separate Standards and Spec axes after the worker
  hands off.
- Controlled revisions: return approved fixes to the same implementation PR.

## Roles and boundaries

The user owns:

- product and domain decisions;
- architecture approval;
- ticket approval and creation authorization;
- implementation authorization;
- revision approval;
- the merge decision.

The coordinator owns discussion, planning, specifications, tickets, human
gates, post-implementation review, PR understanding, and revision planning.

The configured `implementation` handoff owns approved repository work. Read
[`references/implementation-handoff.md`](references/implementation-handoff.md)
when configuring, invoking, resuming, or debugging that handoff.

When this workflow names a skill, invoke that exact skill. Do not replace it
with a similarly named skill, a lower-level skill used internally by it, or a
coordinator-written approximation. If a required skill or handoff is missing,
stop and report the problem.

Use these separately installed prerequisite skills:

- `grill-with-docs` for planning;
- `to-spec` for the durable specification;
- `to-tickets` for ticket drafts;
- `implement` for implementation and repository verification;
- `code-review` for the independent two-axis review;
- `understand-pr` for the human-oriented PR explanation.

## Supervised handoff

The implementation handoff is a supervised delegation, not a fire-and-forget
dispatch. Invoke it once and retain the returned task, continuation, or
equivalent completion handle. Wait or poll that exact execution in the parent
coordinator task until the worker returns one authoritative final handoff.

A new chat, branch, or worktree is intermediate execution state. It is not a
completed handoff. If the host cannot preserve the parent-to-worker linkage and
provide a waitable result, the handoff is unavailable for Dev Flow.

Once delegated, the worker owns repository investigation, implementation,
tests, builds, browser/UI verification, commits, pushes, PR creation or
updates, and final reporting. Silence, long checks, browser automation, or
context compaction do not end that ownership. Reclaim only when the worker:

- explicitly cannot continue;
- requests a material decision;
- returns unfinished work; or
- is reported failed or terminated by the runtime.

The coordinator remains the coordinator in the parent task. It does not take
over code, inspect a worker branch as a substitute for waiting, duplicate
implementation, or create a replacement worker while the delegated worker is
active.

The worker must invoke the exact `implement` workflow for implementation. Dev
Flow deliberately defers `implement`'s terminal `code-review` step to the
coordinator-owned review gate. The implementation worker does not invoke
`code-review`, create review chats or worktrees, or write substitute
Standards/Spec prompts. It returns after implementation checks, commits,
pushes, and PR handling.

If the implementation workflow creates any other child task, that task remains
subordinate to the implementation worker. The worker waits for required child
results and includes them in its final handoff. A child result is never a
replacement for the worker's final handoff.

## Resume

Dev Flow may resume in a fresh coordinator session. On resume:

1. read applicable `AGENTS.md` instructions;
2. read the available specification, ticket, and PR;
3. reconstruct the current phase from those canonical artifacts;
4. give a short Quick Resume: done, current phase, important constraint, and
   recommended next step;
5. preserve every human gate and require fresh implementation authorization
   unless the user clearly provides it again.

Resume from the reconstructed phase. Do not restart planning merely because
the coordinator conversation changed.

## Phase 1 — Pareto planning

For substantial work, invoke `grill-with-docs` directly. Do not substitute
`grilling` or conduct a coordinator-only version of the same workflow.

Ask only questions that materially affect architecture, domain behavior,
public/API contracts, persistence, security, significant user behavior, or an
expensive-to-reverse decision. Infer reversible details from the codebase,
`AGENTS.md`, documentation, conventions, or strong defaults.

End planning with:

### Decisions made

Important decisions explicitly approved by the user.

### Defaults inferred

Low-risk choices inferred from the repository, conventions, or recommended
defaults.

### Important constraints

Behavior, architecture, compatibility, or verification constraints the work
must preserve.

### Unresolved risks

Only material unresolved risks.

Do not implement during planning.

## Phase 2 — Specification

After material decisions are resolved, invoke `to-spec` when the work benefits
from a durable implementation contract. The specification records the agreed
decisions; it does not silently reopen them.

If the specification reveals a material contradiction or unresolved product or
architecture decision, return to the user before ticketing.

## Phase 3 — Minimal ticketing

Invoke `to-tickets` against the approved specification. Then compress the
result into the smallest coherent set that keeps implementation and review
safe. As a default, prefer 2–4 tickets.

Combine work that forms one vertical slice or shares one architecture and
verification boundary. Do not split out tests, small required refactors,
documentation, migrations, or closely coupled frontend/backend work merely to
make the ticket count larger.

Before the full tickets, provide a ticket-plan Quick Read:

- recommended ticket count and why it is the smallest sensible number;
- one-sentence purpose for each ticket;
- important sequence or independence constraints.

Every ticket begins with:

```markdown
## Quick Read

**What changes**
...

**Why**
...

**Architectural / domain impact**
... or `None`

**Important**
...

**Done when**
...
```

### HUMAN GATE 1 — Ticket creation

Present the complete draft set and stop. Clear user approval of the final set
authorizes ticket creation; questions, wording requests, or partial approval do
not.

After approval:

1. create the approved tickets;
2. return their full URLs;
3. identify the recommended first ticket;
4. do not begin implementation.

Stop again and ask whether the user wants to start that ticket.

## Phase 4 — Delegated implementation

Ticket creation never authorizes implementation. Only explicit authorization to
start a specific ticket does.

### HUMAN GATE 2 — Implementation

After explicit approval:

1. resolve the full ticket URL;
2. invoke the configured `implementation` handoff once and retain its returned
   task or continuation;
3. tell the worker that implementation is explicitly approved;
4. instruct it to invoke the exact `implement` workflow with the full ticket
   URL and obey applicable `AGENTS.md` instructions;
5. delegate repository exploration, implementation checks, commits, pushes,
   and PR handling to the worker;
6. wait or poll the exact worker execution until its explicit final handoff.

Do not make code changes concurrently. If the worker reports a material
unresolved decision, bring that decision to the user.

The worker's final handoff must contain what changed, checks and results,
implementation-local review status, useful commit information, and the full PR
URL. It is not the independent review or the human-oriented PR explanation.

## Phase 5 — Independent two-axis review

Every completed implementation or revision PR passes the exact `code-review`
skill before `understand-pr` or user PR review.

Invoke `code-review` once in the existing coordinator task after the worker's
final handoff. “Independent” describes the review inputs and reasoning, not a
new coordinator task or worktree. Supply:

- the full PR URL;
- the original ticket and specification context;
- the resolved PR base branch or merge-base fixed point;
- the latest diff.

Do not create a task whose job is merely to invoke `code-review`. Do not
dispatch Standards and Spec prompts directly; `code-review` owns reviewer
creation, supervision, and aggregation.

The Standards and Spec reviewers created by `code-review` are leaf contexts.
Each receives one axis-specific brief and returns its report to the existing
review invocation. They do not invoke `dev-flow` or `code-review`, create
another worktree or reviewer, or hand work to another task. If the host cannot
provide leaf review contexts, report the review gate as unsupported rather than
starting a recursive chain.

Wait for the aggregate result from the exact `code-review` invocation. An
individual reviewer result, child chat, or PR-body summary is not the review
result.

### Review findings

If either axis has an actionable finding:

1. preserve the Standards and Spec separation while aggregating and
   deduplicating;
2. explain each finding in simplified technical English;
3. classify it as a requirement mismatch, correctness defect, architectural
   concern, maintainability concern, or minor observation;
4. recommend which findings require revision;
5. create one concise Revision Contract;
6. stop at HUMAN GATE 3.

Do not invoke `understand-pr` while actionable independent-review findings
remain.

If both axes are clean, invoke the exact `understand-pr` skill automatically
using the full PR URL.

## Phase 6 — Pull request understanding

`understand-pr` explains the cleanly reviewed PR for the human. Do not replace
it with a coordinator-written summary.

If `understand-pr` finds an actionable issue:

1. explain it and classify it;
2. recommend whether it should be fixed before merge;
3. create a concise Revision Contract when code changes are needed;
4. stop at HUMAN GATE 3.

Review findings never authorize coordinator code changes.

## Revision Contract and revision gate

When a PR concern is raised, investigate the PR, ticket, specification, code,
and repository conventions before deciding whether it is a defect, trade-off,
misunderstanding, or preference. A concern is not implementation authorization.

Use:

```markdown
## Revision Contract

### Concern
...

### Agreed change
...

### Keep unchanged
...

### Verify
...
```

### HUMAN GATE 3 — Revision implementation

Stop after presenting the Revision Contract. Only explicit approval authorizes
the revision.

After approval, invoke a fresh implementation handoff with:

- the original full ticket URL;
- the existing full PR URL;
- the approved Revision Contract;
- explicit revision authorization;
- applicable `AGENTS.md` instructions.

The worker updates the existing PR branch and the same PR. It does not create a
second PR and preserves previously approved behavior unless the contract
overrides it. Wait for its final handoff, then run the independent `code-review`
gate again against the latest state. Only a clean review reaches
`understand-pr` again.

## HUMAN GATE 4 — Merge

Never merge merely because implementation, tests, CI, either review axis, or
`understand-pr` passed. The merge decision belongs to the user. Follow
repository merge rules and require explicit merge authorization.

## Multiple tickets

After a ticket's PR is complete or merged, identify the recommended next ticket
and return control to the user. Do not begin dependent work automatically.

## Repository instructions

Read and obey applicable `AGENTS.md` instructions for architecture, commands,
branching, commits, pushes, PR handling, and merge rules. Repository mechanics
may refine this workflow; they do not remove its human authorization gates.
