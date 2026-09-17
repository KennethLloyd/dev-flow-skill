# dev-flow

`dev-flow` is a human-gated development workflow that turns a rough idea into a
clean, reviewed pull request without letting the implementation agent drive the
architecture.

## Why it exists

Most agent workflows ask one model to plan, code, review, and explain the work.

`dev-flow` separates those responsibilities:

- **Coordinator as technical lead** — owns planning, architecture, implementation
  guidance, review, and PR creation.
- **Worker as implementer** — focuses on repository execution: inspect, code,
  verify, commit, and push.
- **Human gates** — the user explicitly approves tickets, implementation,
  revisions, and merge.
- **Consolidated revisions** — accepted review findings are grouped into one
  revision contract instead of endless back-and-forth.
- **PR after review** — the coordinator reviews the implementation first, then
  creates the final reviewer-facing PR.
- **Minimal by default** — prefer the smallest coherent solution and avoid
  speculative abstractions, unnecessary tests, and over-engineering.

## Flow

```text
idea
→ Pareto planning
→ spec
→ minimal tickets
→ human approval
→ coordinator implementation design
→ delegated implementation
→ coordinator review
→ optional approved revision
→ final review
→ coordinator-created PR
→ understand-pr
→ human merge decision
```

The core idea is simple:

```text
Human decides.
Coordinator designs and reviews.
Worker executes.
```

## Skills used

`dev-flow` orchestrates these separately installed skills:

- [`grill-with-docs`](https://github.com/mattpocock/skills/tree/main/skills/engineering/grill-with-docs)
- [`to-spec`](https://github.com/mattpocock/skills/tree/main/skills/engineering/to-spec)
- [`to-tickets`](https://github.com/mattpocock/skills/tree/main/skills/engineering/to-tickets)
- [`understand-pr`](https://github.com/KennethLloyd/understand-pr-skill)

It also uses a host-specific implementation worker that follows the published
[implementation handoff contract](skills/dev-flow/references/implementation-handoff.md).

## Install

```bash
npx skills add KennethLloyd/dev-flow-skill --skill dev-flow -g -y
```

Install the prerequisite skills separately from their upstream repositories.

For Codex, an optional worker adapter is included at:

```text
adapters/codex/implementation.toml
```

## Package layout

```text
skills/dev-flow/
├── SKILL.md
└── references/
    └── implementation-handoff.md

adapters/
└── codex/
    └── implementation.toml
```

## License

MIT. See [`LICENSE`](LICENSE).
