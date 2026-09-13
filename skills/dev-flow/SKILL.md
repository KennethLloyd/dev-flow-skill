---
name: dev-flow
description: Human-gated workflow from idea to reviewed pull request, with Pareto planning, Quick Reads, delegated implementation, and explicit approval gates.
disable-model-invocation: true
---

# Dev Flow

Use this workflow for substantial software work:

```text
Pareto planning → specification → minimal tickets → human implementation approval
→ delegated implementation → coordinator review → optional consolidated revision
→ coordinator final review → understand-pr → human merge decision
```

The coordinator acts as technical lead: it owns planning, the approved
contract, integrated PR review, and review arbitration. A dedicated worker
owns approved repository execution. The user owns product and architecture
decisions, ticket creation, implementation and revision authorization, and
the final merge decision.

Invoke the separately installed `grill-with-docs`, `to-spec`, and `to-tickets`
skills for their stages, and `understand-pr` for the final human-oriented PR
explanation. Use each exact skill when its stage applies; report a missing
required skill. Independent `code-review` is outside Dev Flow and may be
invoked manually by the user.

Read [the implementation handoff contract](references/implementation-handoff.md)
when configuring, invoking, or resuming the worker. Read and obey applicable
`AGENTS.md` throughout; repository mechanics do not remove human gates.

## Supervised implementation

Delegate after approval, retain the worker's task or continuation, and wait
for one authoritative final handoff. The worker owns repository investigation,
implementation, verification, commits, pushes, and PR creation or updates.
Silence, long checks, and context compaction do not end that ownership. Do not
edit code concurrently, duplicate work, or replace the worker unless it
explicitly cannot continue, returns unfinished work, or the runtime confirms
failure. Bring unresolved material product or architecture decisions to the
user.

On a fresh coordinator session, read applicable `AGENTS.md`, the spec, ticket,
and PR; reconstruct the stage from those artifacts. Give a Quick Resume with
what is done, the current stage, important constraint, and next step. Preserve
human gates; past approval does not authorize a new implementation or revision.

## 1. Pareto planning

For substantial work, invoke `grill-with-docs`. Resolve the highest-value
uncertainty first. Ask only about decisions that materially affect architecture,
domain behavior, public contracts, persistence, security, significant user
behavior, or expensive-to-reverse choices. Infer reversible details from the
repository and strong defaults. End with decisions made, defaults inferred,
important constraints, and material unresolved risks. Do not implement yet.

## 2. Specification

Invoke `to-spec` when a durable implementation contract helps. Record agreed
decisions without reopening them. Return material contradictions or unresolved
product or architecture decisions to the user before ticketing.

## 3. Minimal tickets

Invoke `to-tickets` against the approved specification, then compress the
result into the smallest coherent set that keeps implementation and review
safe. Prefer 2–4 tickets by default. Keep a vertical slice together; tests,
small refactors, docs, migrations, and coupled frontend/backend work do not
automatically need separate tickets.

Before the drafts, provide a ticket-plan Quick Read with recommended count,
one-sentence purpose of each ticket, and sequence constraints. Begin each
ticket with:

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

Present the complete draft set and stop. Clear approval of the final set
authorizes ticket creation; questions or partial approval do not. After
approval, create the tickets, return their full URLs, recommend the first
ticket, and stop before implementation.

## 4. Delegated implementation

### HUMAN GATE 2 — Implementation

Ticket creation does not authorize implementation. After explicit approval to
start a specific ticket, hand the worker the full ticket URL, approved spec or
implementation contract when applicable, explicit authorization, and
applicable `AGENTS.md`. Ask it to implement the approved behavior with the
smallest clean solution, run appropriate verification, commit and push,
create or update the PR, and return one final handoff with changes, check
results, useful commit information, and the full PR URL. It must not merge.
Wait for its final handoff.

## 5. Coordinator integrated review

Review the latest PR diff directly against the approved ticket, spec, and
repository conventions. In one pass, assess spec fidelity and specified UX;
correctness, significant edge cases, security/privacy, and data integrity;
architecture and maintainability; simplicity and unnecessary abstractions or
indirection; and testing of meaningful behavior and expensive regressions.
Do not demand tests merely for wiring, mocks, framework behavior, trivial
markup, query keys, or implementation details.

Validate each concern before requesting revision. Reject weak, speculative,
or preference-only findings; deduplicate overlaps; resolve conflicting fixes;
and capture every accepted issue in one complete Revision Contract. Define
the final behavior, what stays unchanged, and focused verification so the
worker can address all accepted issues in one pass. Do not turn every
observation into a revision. Review is clean when the PR satisfies the
approved contract without material requirement, correctness, architecture,
maintainability, or specified UX problems. Optional refactors, style
preferences, and low-value tests do not block convergence.

## 6. Consolidated revision, if needed

Investigate PR concerns against the contract, code, and conventions before
deciding whether each is a defect, trade-off, misunderstanding, or preference.
A concern is not implementation authorization. Present one contract:

```markdown
## Revision Contract

### Concerns and agreed changes
...

### Keep unchanged
...

### Verify
...
```

### HUMAN GATE 3 — Revision implementation

Stop after presenting the contract. Only explicit approval authorizes the
revision. Continue the existing implementation worker and its PR context
when possible. Supply the original ticket/spec, existing PR URL, approved
Revision Contract, explicit authorization, applicable `AGENTS.md`, and a
Quick Resume: what is correct, what changes, likely affected areas, what
stays unchanged, and focused verification. Keep the Revision Contract focused
on approved behavior. Before handoff, inspect the PR and relevant repository
code enough to pass along Implementation Guidance when the solution is clear:
the expected approach, likely files or symbols, existing patterns to reuse,
and complexity to avoid or remove.

The worker should investigate affected code and necessary dependencies,
without repeating broad discovery unless material architectural uncertainty
appears. The Revision Contract is authoritative; Implementation Guidance is
the recommended technical path. The worker may adjust low-level details when
repository evidence shows a materially simpler or more correct solution, but
must return any change to approved product behavior or architecture to the
coordinator. It should fix all accepted concerns in one pass, preserve approved
behavior unless changed by the contract, and simplify or replace earlier code
structure when that yields the cleanest compliant result. It updates the same
PR. Use a fresh worker only if continuation is unavailable or the worker
cannot continue. Wait for its final handoff.

Review the revised PR yourself. A second revision cycle is exceptional: use
one only for a genuinely material unresolved requirement, correctness,
security/privacy, data integrity, architecture, or specified UX defect. Do
not reopen revisions for optional cleanup or speculative improvements.

## 7. Understand the PR

Once the coordinator's final review is clean, invoke the exact `understand-pr`
skill with the full PR URL. Use its human-oriented reading path; do not
replace it with a coordinator-written summary. If it reveals a material
issue, validate it and use the revision gate before changing code.

## HUMAN GATE 4 — Merge

Never merge automatically. Passing implementation, checks, review, or
`understand-pr` does not authorize a merge. Follow repository merge rules
and require explicit user merge authorization.

For multiple tickets, recommend the next one after a PR is complete or merged
and return control to the user. Do not start dependent work automatically.
