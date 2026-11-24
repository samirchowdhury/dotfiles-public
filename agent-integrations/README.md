# Agent integrations

This folder contains harness-neutral specifications, not harness extension implementations.
To set up a new computer, ask an agent:

> Set up all integrations in `agent-integrations/` for Copilot CLI.

Replace Copilot CLI with your target harness.
Do not assume that a harness automatically reads this folder.

## Specifications

- [Quiet tool traces](QUIET-TOOL-TRACES.md): hide routine tool calls and output, keep errors visible, and reveal traces on demand without changing execution or history.
- [Snippet picker](SNIPPET-PICKER.md): fuzzy-search reusable prompts and insert a selection into the draft without submitting it.
- [Multi-skill expansion](MULTI-SKILL.md): autocomplete consecutive leading skill commands and expand them into one request, preserving each skill's instructions and relative references.

Snippet data lives in [`../snippets.json`](../snippets.json), separate from these specifications.
The repo installer links it to `~/.config/agent-snippets/snippets.json` but does not install harness integrations.

## Shared setup workflow

1. Identify the requested harness and its installed version.
   Ask which harness to configure if the target is unspecified.
2. Read every specification in this folder and assess it against the harness's current documentation and supported APIs.
   Do not assume that plugin support includes transcript rendering or prompt-editor access.
3. Prefer native configuration when it meets a specification.
   Otherwise, build the smallest supported adapter outside this repo, in the harness's user extension directory or a separate user-selected project.
4. Preserve unrelated settings, existing extensions, and keybindings.
   Ask before implementing an approximation, adding dependencies, broadening permissions, using an external UI, or patching undocumented internals.
   Explain specific capability gaps rather than claiming unsupported behavior works.
5. Verify each integration using its acceptance checks in the actual interactive harness, including the user's terminal and tmux where applicable.
   If interactive verification is unavailable, report which checks remain unverified.
6. Make setup repeatable without duplicate integrations or overwritten user settings.
   Report each integration's status, the harness version, installed paths, controls, verification performed, remaining limitations, and removal instructions.

Follow each specification's additional requirements as well as this shared workflow.
Assess every spec, but do not silently install reduced behavior for unsupported integrations.
