---
name: dev-flow
description: Human-gated development from idea to a reviewed, understandable pull request.
disable-model-invocation: true
---

# Dev Flow

Use this workflow for substantial software work:

```text
Pareto planning → specification → minimal tickets → implementation approval
→ delegated implementation → integrated review → optional consolidated revision
→ final review → coordinator PR creation → understand-pr → merge decision
```

The coordinator is the technical lead. It owns planning, the approved contract,
implementation design, integrated review, review arbitration, and PR creation.
A dedicated worker owns approved repository execution through its final handoff.
The user owns product and architecture decisions, ticket creation, implementation
and revision authorization, and the final merge decision.

Prefer the smallest coherent implementation that satisfies the approved
contract. Reuse repository patterns. Add abstractions, helper layers, generalized
infrastructure, speculative extensibility, or tests only when they protect
meaningful behavior or materially improve the change.

Invoke the separately installed `grill-with-docs`, `to-spec`, and `to-tickets`
skills for their stages, and `understand-pr` for the final PR explanation. Report
a missing required skill. Independent `code-review` remains outside Dev Flow and
may be invoked manually by the user.

Read [the implementation handoff contract](references/implementation-handoff.md)
before configuring, invoking, or resuming the worker. Read and obey applicable
`AGENTS.md` throughout; repository mechanics never remove a human gate.

## Supervised implementation

Retain the worker's waitable task or continuation and wait for one authoritative
final handoff. Silence, long checks, and context compaction do not end worker
ownership. Do not edit concurrently, duplicate the work, or replace the worker
unless it reports that it cannot continue, returns unfinished work, or the
runtime confirms failure.

On a fresh coordinator session, reconstruct the stage from applicable
`AGENTS.md`, the approved contract, ticket, relevant code, and branch or PR when
one exists. Give a Quick Resume: what is done, current stage, important
constraint, and next step. Prior approval never authorizes a new implementation
or revision.

## 1. Pareto planning

Invoke `grill-with-docs`. Resolve the highest-value uncertainty first. Ask only
about choices that materially affect architecture, domain behavior, public
contracts, persistence, security, significant user behavior, or expensive
reversal. Infer reversible details from repository evidence and strong defaults.

Finish with decisions made, defaults inferred, important constraints, and
material unresolved risks. Do not implement.

## 2. Specification

Invoke `to-spec` when a durable implementation contract helps. Record agreed
decisions without reopening them. Return material contradictions or unresolved
product or architecture choices to the user before ticketing.

## 3. Minimal tickets

Invoke `to-tickets` against the approved specification, then compress the result
into the smallest coherent set that keeps implementation and review safe.
Prefer 2–4 tickets. Keep a vertical slice together; coupled tests, refactors,
docs, migrations, frontend work, and backend work do not need separate tickets.

Before the drafts, give a ticket-plan Quick Read with the recommended count,
one-sentence purpose of each ticket, and sequence constraints. Begin every
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

Present the complete draft set and stop. Only clear approval of the final set
authorizes ticket creation. After approval, create the tickets, return their
full URLs, recommend the first ticket, and stop before implementation.

## 4. Delegated implementation

### HUMAN GATE 2 — Implementation

Ticket creation does not authorize implementation. After explicit approval to
start a specific ticket, inspect the relevant repository areas enough to define
the implementation design and likely execution path.

Write a concise Implementation Guide covering:

- expected design and data or control flow;
- affected responsibilities, interfaces, contracts, or schema;
- likely files and symbols;
- repository patterns to reuse;
- important invariants and edge cases;
- scope boundaries and behavior that stays unchanged;
- high-value verification;
- complexity to avoid.

Say when a simple local solution is enough. The approved ticket or spec remains
authoritative; the guide transfers technical reasoning already established by
the coordinator. The coordinator decides the intended structure and why. The
worker chooses the clean low-level expression of that structure.

Invoke the configured implementation handoff with the full ticket URL, approved
contract when applicable, explicit authorization, applicable `AGENTS.md`, and
the Implementation Guide. Require the worker to validate the design against
repository reality, implement and verify the approved behavior, commit, push
the branch, and return one final handoff. The worker must not create or update
the PR.

The worker may make small local adjustments supported by repository evidence.
It must return material changes to architecture, responsibility boundaries,
public contracts, persistence, approved behavior, or major abstractions to the
coordinator.

The final handoff is complete when it contains:

- branch name and useful commit information;
- a concise factual summary of implemented behavior;
- material deviations from the supplied design or approved scope;
- verification commands and results;
- known unresolved issues.

Wait for that handoff.

## 5. Integrated review

Review the pushed branch directly before PR creation. Review it against the
approved ticket, specification or contract, Implementation Guide, applicable
`AGENTS.md`, and relevant repository conventions.

In one pass, assess specified behavior and UX, correctness and significant edge
cases, security and privacy, data integrity, architecture and responsibility
boundaries, maintainability, simplicity, design fidelity, and tests of
meaningful behavior or expensive regressions. Do not demand tests for trivial
wiring, markup, framework behavior, mocks, query keys, or implementation
details.

Validate each concern. Reject speculative or preference-only findings,
deduplicate overlaps, resolve conflicting fixes, and collect every accepted
issue in one Revision Contract. Review is clean when no material requirement,
correctness, architecture, maintainability, security, privacy, data integrity,
or specified UX problem remains.

## 6. Consolidated revision, if needed

Classify each validated concern as a defect, trade-off, misunderstanding, or
preference. A concern is not revision authorization. Present one contract:

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

Stop after presenting the contract. Only explicit approval authorizes revision.

Resume the existing worker when possible. Supply the original contract, branch,
approved Revision Contract, explicit authorization, applicable `AGENTS.md`, and
a Quick Resume covering what is correct, what changes, likely affected areas,
what stays unchanged, and focused verification. Add Implementation Guidance
when the technical path is already clear. The Revision Contract controls
behavior; the guidance recommends the technical path.

Require one pass that addresses every accepted concern, preserves unchanged
behavior, verifies the result, commits and pushes the same branch, and returns
one final revision handoff. The worker may simplify or replace earlier code and
make evidence-backed local adjustments, but it must return material design or
behavior changes to the coordinator. It must not create or update the PR.

Use a fresh worker only when continuation is unavailable or the existing worker
cannot continue. Wait for the final handoff, then review the revised branch.
A second cycle is reserved for a material unresolved requirement, correctness,
security, privacy, data integrity, architecture, maintainability, or specified
UX defect.

## 7. Final review and PR creation

Perform one final branch review against the approved contract, Implementation
Guide, Revision Contract when applicable, `AGENTS.md`, and repository
conventions. Proceed only when approved behavior is complete, no material
regression or concern remains, the intended architecture still holds,
complexity is justified, and verification matches the change's risk.

Create the PR from the reviewed branch. Follow the repository's PR instructions
and template exactly. Preserve required structures such as `Quick Read`. Base
the description on the approved contract, final diff, material behavior or
architecture decisions, and final verification results.

Include only what helps a human understand or review the change. Omit internal
reasoning, workflow chronology, unnecessary file inventories, speculative
future work, obvious implementation details, and redundant logs. Return the
full PR URL.

## 8. Understand the PR

Invoke `understand-pr` with the full PR URL and use its human-oriented reading
path. Do not replace it with a coordinator-written summary.

If it reveals a material issue, validate it. Any code change requires a new
Revision Contract and explicit revision approval.

## HUMAN GATE 4 — Merge

Only explicit user authorization permits a merge. Passing implementation,
checks, review, PR creation, or `understand-pr` does not.

For multiple tickets, recommend the next ticket after the current PR is
complete or merged, then return control to the user. Never start dependent work
automatically.
