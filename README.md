# dev-flow

`dev-flow` is a human-gated development workflow for moving from an idea to a
reviewable, understandable pull request.

## Quick read

Use it when a change needs more structure than “implement this”:

- **Pareto planning** resolves the highest-value uncertainty first.
- **Quick Reads** make plans and tickets easy to scan.
- **Human gates** keep product, architecture, implementation, revision, and
  merge decisions with the human.
- **Delegated implementation** keeps repository-heavy work in a configured
  worker while the coordinator preserves ownership and waits for its handoff.
- **Independent review** checks Standards and Spec separately after each
  implementation or revision.
- **`understand-pr`** turns a clean review into a human-oriented reading path.
- **Same-PR revisions** keep fixes controlled and re-reviewed before merging.

The normal flow is:

```text
plan → spec → minimal tickets → implement → Standards/Spec review
→ understand-pr → explicit merge decision
```

## Prerequisites

Install these separately; this repository intentionally does not bundle them:

- [`grill-with-docs`](https://github.com/mattpocock/skills/tree/main/skills/engineering/grill-with-docs)
- [`to-spec`](https://github.com/mattpocock/skills/tree/main/skills/engineering/to-spec)
- [`to-tickets`](https://github.com/mattpocock/skills/tree/main/skills/engineering/to-tickets)
- [`implement`](https://github.com/mattpocock/skills/tree/main/skills/engineering/implement)
- [`code-review`](https://github.com/mattpocock/skills/tree/main/skills/engineering/code-review)
- [`understand-pr`](https://github.com/KennethLloyd/understand-pr-skill)
- a host-specific implementation handoff satisfying the
  [published contract](skills/dev-flow/references/implementation-handoff.md)

The first five come from [Matt Pocock's skills repository](https://github.com/mattpocock/skills).
`understand-pr` is a separate user-owned skill. Keeping them separate lets each
skill be installed and updated independently.

## Install

Install `dev-flow` globally with the Skills CLI:

```bash
npx skills add KennethLloyd/dev-flow-skill --skill dev-flow -g -y
```

Install each prerequisite separately from its upstream repository. For example:

```bash
npx skills add mattpocock/skills --skill grill-with-docs -g -y
```

Repeat that command with the other prerequisite skill names listed above. Then
install one host adapter wherever the implementation handoff executes. The
coordinator and worker may run on different machines.

The optional Codex adapter is
[`adapters/codex/implementation.toml`](adapters/codex/implementation.toml).
The core skill remains provider-neutral.

## Package layout

```text
skills/dev-flow/
├── SKILL.md
└── references/implementation-handoff.md
adapters/codex/implementation.toml
```

## License

MIT. See [`LICENSE`](LICENSE).
