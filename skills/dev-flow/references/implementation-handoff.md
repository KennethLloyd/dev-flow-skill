# Implementation handoff contract

`dev-flow` delegates approved repository work through a logical
`implementation` handoff. The host chooses the worker, model, and transport;
the coordinator retains a waitable task or continuation and waits for one
authoritative final result. A detached chat or branch alone is not a handoff.

For initial implementation, supply the full ticket URL, approved spec or
implementation contract when applicable, explicit implementation approval,
and applicable `AGENTS.md`. For revisions, also supply the existing PR URL,
approved consolidated Revision Contract, explicit revision approval, and a
Quick Resume covering what is correct, what changes, likely affected areas,
what remains unchanged, and focused verification.

The worker reads relevant repository context, implements the approved
requirements with the smallest clean solution, runs appropriate verification,
commits and pushes, creates or updates the PR, and returns changes, check
results, useful commit information, full PR URL, and any unresolved material
decision in one final handoff. It returns product or architecture decisions
that cannot safely be inferred to the coordinator. It never merges.

For an approved revision, continue the same worker context when possible. The
worker focuses on affected code and necessary dependencies, avoids repeated
broad discovery unless architecture is uncertain, addresses all accepted
concerns in one pass, and updates the same PR. Preserve approved behavior
unless the Revision Contract changes it; earlier code structure may be
simplified or replaced. Use a fresh worker only if continuation is unavailable
or the worker cannot continue.

The worker owns execution until its final handoff. The coordinator waits for
that result, does not duplicate active implementation, and then performs its
own integrated PR review. Host adapters must preserve this ownership and
waitable completion boundary.
