#!/bin/sh

set -eu

skill="skills/dev-flow/SKILL.md"
contract="skills/dev-flow/references/implementation-handoff.md"
adapter="adapters/codex/implementation.toml"

require() {
  file="$1"
  pattern="$2"

  if ! rg --quiet --fixed-strings "$pattern" "$file"; then
    printf 'missing contract requirement in %s: %s\n' "$file" "$pattern" >&2
    exit 1
  fi
}

require "$skill" "The handoff is a supervised delegation, not a fire-and-forget dispatch."
require "$skill" "retain the returned worker task"
require "$skill" "A child task completing is not worker completion."
require "$skill" "The coordinator must wait for \`code-review\`'s aggregate result."
require "$contract" "The final handoff is the worker's single authoritative completion result."
require "$contract" "An adapter that only starts a detached child"
require "$adapter" "retain each child task's returned handle or continuation"
require "$adapter" "partial results"

printf 'handoff supervision contract: ok\n'
