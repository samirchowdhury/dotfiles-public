# Agent snippet picker specification

## Purpose

Provide a small, file-backed picker for reusable prompts inside an agent harness.
This repo owns the snippet data and specification, not a harness extension implementation.
When asked to set up this repo for an agent harness, include assessing this integration.
Do not assume that any harness natively reads `snippets.json`.

## Data

The installer links `snippets.json` to `~/.config/agent-snippets/snippets.json`.
Read that installed path whenever the picker opens, so edits are available on the next opening without an import or harness restart.
The JSON file contains an array of objects with unique, nonempty string `id` values, nonempty string `name` values, and nonempty string `text` values.
Text may contain newlines.
Keep private prompts out of this public repo.

## Interaction

| Event | Required behavior |
| --- | --- |
| Hotkey | Open the picker from the harness prompt editor |
| Empty query | Show snippets in file order |
| Typing | Fuzzy-search names and text, with file order breaking equal-score ties |
| Up/Down | Move the selection |
| Enter | Insert the selected text into the draft, close the picker, and restore editor focus |
| Escape | Close the picker without changing the draft |

Insert at the cursor without discarding existing text or submitting the prompt.
If the harness cannot expose cursor insertion but supports reading and replacing a draft, explain the limitation and ask before implementing append-only insertion.
Selecting a snippet never starts an agent turn or executes its contents.
Show a clear empty state when no snippets match.
Report missing files, invalid JSON, or invalid entries visibly without modifying the draft.
Do not silently replace invalid data with an empty library.

There is no frequency ranking, usage history, telemetry, background watcher, automatic expansion, or language-model call.
Prefer the harness's existing picker and fuzzy-search facilities over adding dependencies.

## Agent-assisted setup

1. Identify the target harness and its installed version.
   If multiple harnesses are installed and the target is unspecified, ask which to configure.
2. Inspect its current documentation and installed extension APIs.
   Determine whether native features satisfy the file loading, hotkey, fuzzy search, and draft-insertion requirements.
   A snippet import feature, slash-command submission, or model-callable tool alone does not satisfy them.
3. If native support exists, configure it against the installed snippet path and explain the workflow.
   Otherwise, build the smallest supported adapter outside this repo, using the harness's user extension directory or a separate user-selected project.
4. Check the chosen hotkey against the harness, terminal, and tmux mappings.
   Do not replace a conflicting shortcut without asking.
   Keep existing settings and extensions intact.
5. If the exact integration is unsupported, explain the specific gap.
   Ask before using an external-editor adapter, clipboard workflow, global application, broader permissions, or new dependencies.
   Do not modify undocumented internal state or fork the harness to simulate support.
6. Verify the behavior in the actual interactive harness and report any remaining limitations.
   Keep installation repeatable without duplicating extensions or replacing user settings.

Native custom UI and prompt editing are promising integration points in Pi.
Other harnesses, including Claude Code, must be assessed against their installed version rather than treated as equivalent.
This specification is not a promise of built-in snippet support in any harness.
An MCP tool alone cannot supply the interactive hotkey and draft editor.

## Acceptance checks

- Edit the example snippet and verify its new text appears on the next picker opening.
- Verify file ordering with no query, fuzzy matching, and keyboard selection.
- Verify Enter inserts multiline text without submitting and preserves an existing draft.
- Verify Escape and no-match states leave the draft unchanged.
- Verify malformed data produces a visible error without damaging the draft.
- Verify the chosen hotkey works through the user's terminal and tmux where applicable.
- Verify repeated setup does not duplicate the integration or overwrite unrelated settings.
