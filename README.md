# dev-flow

`dev-flow` is the coordination layer for a human-gated software development
workflow. It uses Pareto planning to reduce the most important uncertainty
first, compresses the result into the smallest coherent ticket set, and starts
each ticket with a Quick Read so the human can review the change, rationale,
architectural impact, important constraint, and done-when state quickly.

It then enforces explicit gates between planning, ticket creation,
implementation, revision, and merge. Approved repository work is delegated to
a configured implementation handoff, while the coordinator preserves worker
ownership and automatically routes completed pull requests through
human-oriented `understand-pr` review before returning control to the user.

That coordination policy is the point of this skill. The prerequisite skills
provide specialized work; `dev-flow` decides when they run, what must remain a
human decision, how work is handed off, and how revisions return to the same
pull request.

## Design

The core skill is provider-neutral. It invokes a logical `implementation`
handoff and does not assume a particular agent runtime, model, or transport.
The handoff contract is documented in
[`skills/dev-flow/references/implementation-handoff.md`](skills/dev-flow/references/implementation-handoff.md).

Host-specific configuration belongs in an adapter. This repository includes an
optional Codex adapter at
[`adapters/codex/implementation.toml`](adapters/codex/implementation.toml).
Install that adapter only in an environment that supports Codex-style custom
workers. If a remote coordinator routes coding through a Codex runtime, install
the adapter where that runtime executes rather than coupling the core skill to
the coordinator.

## Prerequisites

Install these separately; they are intentionally not bundled here:

- [`grill-with-docs`](https://github.com/mattpocock/skills/tree/main/skills/engineering/grill-with-docs)
- [`to-spec`](https://github.com/mattpocock/skills/tree/main/skills/engineering/to-spec)
- [`to-tickets`](https://github.com/mattpocock/skills/tree/main/skills/engineering/to-tickets)
- [`implement`](https://github.com/mattpocock/skills/tree/main/skills/engineering/implement)
- [`understand-pr`](https://github.com/KennethLloyd/understand-pr-skill)
- a host-specific implementation handoff satisfying the published contract

The first four skills are maintained in
[Matt Pocock's skills repository](https://github.com/mattpocock/skills). Install
them from those upstream directories, separately from this skill.
`understand-pr` is a separate user-owned skill. Keeping them separate lets each
skill be updated, installed, and reused independently.

## Installation

Use the skill installer for your agent, selecting `skills/dev-flow` from this
repository. For a manual installation, copy the `skills/dev-flow` directory
into the agent's skill directory.

Then configure one implementation adapter in the host that will perform coding
work. The core skill should be installed wherever the coordinator runs; the
adapter should be installed wherever the configured implementation handoff
executes.

The workflow fails closed when a required prerequisite skill or implementation
handoff cannot be found. It never treats ticket creation as implementation
approval, starts dependent work automatically, or merges a pull request without
explicit authorization.

## Repository layout

```text
skills/dev-flow/
├── SKILL.md
└── references/
    └── implementation-handoff.md
adapters/codex/
└── implementation.toml
```

## License

MIT. See [`LICENSE`](LICENSE).
