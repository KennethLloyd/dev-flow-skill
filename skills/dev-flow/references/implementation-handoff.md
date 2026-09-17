# Implementation handoff contract

This contract defines the host-neutral boundary between the Dev Flow
coordinator and its implementation worker. `SKILL.md` remains authoritative for
workflow stages, role responsibilities, and human gates.

Applicable AGENTS.md remains authoritative for repository-local conventions, but Dev Flow handoff rules override conflicting delivery mechanics such as PR creation, PR updates, merge behavior, and completion boundaries.

## Transport

The host supplies a logical `implementation` handoff and chooses its worker,
model, and transport. Invoking it must return a waitable task or continuation
that the coordinator retains until one authoritative final result arrives. A
detached chat, process, or branch without a waitable continuation is not a
valid handoff.

Resume the same task for an approved revision when possible. Start a new worker
only when continuation is unavailable or the existing worker cannot continue.

## Initial request

Supply:

- the full ticket URL;
- the approved specification or implementation contract;
- explicit implementation approval;
- applicable `AGENTS.md` instructions;
- the coordinator's Implementation Guide;

Keep the approved contract and Implementation Guide distinct. The contract
defines required behavior; the guide recommends the technical path.

## Revision request

Supply:

- the original ticket and approved contract;
- the current implementation branch;
- the approved consolidated Revision Contract;
- explicit revision approval;
- applicable `AGENTS.md` instructions;
- a Quick Resume covering what is correct, what changes, likely affected
  areas, what stays unchanged, and focused verification;
- Implementation Guidance;

The Revision Contract defines required behavior. Implementation Guidance
recommends the technical path.

## Worker result

The worker completes the approved repository work, verifies it, commits it,
pushes the branch, and returns one final handoff containing:

- branch name and useful commit information;
- a concise factual summary of implemented behavior;
- material deviations from the supplied design or approved scope;
- verification commands and results;
- unresolved issues or material decisions.

The worker returns material changes to approved behavior, architecture,
responsibility boundaries, public contracts, persistence, scope, or major
abstractions to the coordinator. It creates no pull request and never merges.

The result is complete only when every item above is present or explicitly
reported as not applicable.

## Ownership boundary

The worker owns active repository execution until its final handoff. During
that interval, the coordinator waits and preserves the worker's context; it
does not edit concurrently, duplicate the implementation, or replace the
worker unless the worker reports that it cannot continue, returns unfinished
work, or the runtime confirms failure.

After the final handoff, ownership returns to the coordinator for review,
revision arbitration, and pull-request creation. Host adapters must preserve
this waitable ownership boundary.
