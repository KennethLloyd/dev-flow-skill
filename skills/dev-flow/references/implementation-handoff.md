# Implementation handoff contract

`dev-flow` depends on a logical `implementation` handoff for approved coding
work. This contract defines the behavior the coordinator needs; it does not
choose the host, provider, model, or transport that performs the handoff.

## Inputs

For new implementation, the coordinator supplies:

- the full URL of the approved ticket;
- any linked specification needed to implement the ticket;
- confirmation that the user explicitly approved implementation;
- the applicable repository instructions.

For a revision to an existing pull request, the coordinator supplies:

- the original full ticket URL;
- the existing full pull-request URL;
- the approved Revision Contract;
- confirmation that the user explicitly approved the revision;
- the applicable repository instructions.

## Worker responsibilities

The handoff worker owns the delegated lifecycle:

- read and obey repository instructions;
- use the repository's implementation workflow;
- implement the approved requirements;
- run appropriate implementation-local tests, checks, and reviews required by
  the implementation workflow;
- commit and push the work;
- create or update the pull request as required by the ticket and repository instructions;
- return an explicit final handoff containing what changed, checks and results,
  implementation-local review results, useful commit information, and the full
  pull-request URL. Include the PR base branch or merge-base for independent
  review when the worker has it; otherwise the coordinator resolves it from the
  PR before invoking `code-review`.

Implementation-local review is not the independent two-axis `code-review` gate.
The coordinator invokes that gate after this final handoff, in a separate
review context.

For a revision, the worker updates the existing pull request and its branch. It
does not create a second pull request. Previously approved behavior remains in
force unless the Revision Contract explicitly changes it.

The worker must stop and return a decision to the coordinator when it finds a
material unresolved product or architecture decision that cannot safely be
inferred from the supplied ticket, specification, repository instructions,
existing codebase conventions, or Revision Contract.

The worker does not merge a pull request unless the repository instructions
permit it and the user explicitly authorized the merge.

## Coordinator ownership and waiting

Once a handoff is accepted, the worker owns the delegated implementation,
verification, implementation-local review, commit, push, and pull-request
lifecycle until its final handoff. The coordinator must not edit code
concurrently, inspect or replace the worker because of silence or long checks,
duplicate its work, or create or update the pull request on its behalf.

After the final handoff, the coordinator owns the independent `code-review`
gate and then `understand-pr` when both review axes are clean.

The coordinator may reclaim the work only after an explicit inability,
unfinished handoff, or confirmed runtime failure makes the delegation
incomplete.

## Adapter boundary

Host-specific configuration belongs outside the core skill. An adapter may map
the logical `implementation` handoff to a local worker, a remote coding-agent
bridge, or another compatible execution mechanism. The adapter must preserve
the inputs, responsibilities, ownership, and final-handoff behavior above.
