# Multi-skill expansion specification

## Purpose

Autocomplete several skill names in the prompt editor, then expand the selected skills into one user message before the agent sees it.
Both editor completion and submission-time expansion are required; an input hook alone does not provide completion while typing.
Do not rely on the model to notice skill names and read the files itself.
This repo owns the specification, not a harness extension implementation.

## Input and expansion

Support consecutive leading skill commands followed by an optional task:

```text
/skill:eng-governance-review /skill:bfr-gitlab-cli study <MR URL>
```

Allow spaces or newlines between skill commands and support more than two skills.
Only expand the leading command sequence.
Leave skill mentions in prose, quoted text, code blocks, and the task body untouched.
Keep ordinary input and single-skill invocations on the harness's native path.
Expand repeated names only once, preserving first-occurrence order.
Do not invent precedence between conflicting skill instructions.

Resolve names through the harness's active skill registry, respecting its discovery, trust, and name-collision decisions.
Do not scan arbitrary extra directories or hard-code machine-specific skill paths.
Read the current skill files on each invocation so edits are not hidden by an extension-level cache.
Strip skill frontmatter using the harness's parser when available.
Preserve each skill's name, source-file location, reference directory, and complete instruction body using the harness's normal skill wrapper where available.
Keep the task text after the command sequence and preserve image attachments and normal steering/follow-up delivery.
Do not recursively interpret skill commands embedded in loaded skill instructions.

If a name is unknown or a file cannot be read, visibly identify the problem and stop submission of the whole request.
Do not silently drop a skill or send a partially expanded request to the model.
Errors should not start an agent turn.

## Editor completion

Open skill-name suggestions immediately when `/` is typed for the second or later command in the leading sequence, without requiring Tab or `/skill:`.
Allow bare-name fuzzy queries such as `/bfr`, `/gitlab`, or `/bgl` to find `bfr-gitlab-cli`, while continuing to support `/skill:bfr`.
Treat an additional slash within the token as a file-path query rather than a skill-name query.
Use the harness's normal completion menu, descriptions, filtering, and selection controls.
Selecting a skill must insert the complete `/skill:<name>` token followed by a space without submitting the request or changing earlier commands or later task text.
Keep ordinary slash commands and file completion working outside the leading skill sequence.
Prefer a supported autocomplete-provider wrapper for suggestions and completion insertion.
If immediate slash triggering also requires an editor adapter, use a minimal supported subclass and delegate all other input to the native editor.
Do not patch private editor methods or intercept raw terminal input.

## Agent-assisted setup

1. Identify the target harness and installed version, then inspect current documentation and supported APIs.
2. Prefer native multi-skill expansion if it meets this specification.
   Otherwise, use a small extension outside this repo with both editor completion and input transformation.
3. Preserve unrelated extensions and configuration.
   Do not patch harness internals, install dependencies, add services, or make extra model calls for expansion.
4. Verify the acceptance checks below and report any checks that require an interactive session.
5. Report the installed path, reload instructions, limitations, and removal instructions.
   Keep repeated setup idempotent and avoid duplicate hooks.

## Pi setup notes

Implemented locally for Pi 1.4.0 at `~/.pi/agent/extensions/multi-skill.ts`.
The implementation is intentionally outside this repository; recreate it from this specification on a new computer.

Pi 1.4.0 natively expands only one leading `/skill:name` command per message.
Use `pi.on("input", ...)` to transform a leading sequence containing at least two commands before native skill expansion.
Return `{ action: "continue" }` for unrelated input, single-skill invocations, and extension-injected messages (`event.source === "extension"`).
Use `pi.getCommands()` entries with `source === "skill"` to resolve `skill:<name>` and read `sourceInfo.path`.
Use the skill file's parent directory for relative references and Pi's exported `stripFrontmatter` helper for its body.
Wrap each body as Pi does:

```text
<skill name="<name>" location="<file path>">
References are relative to <skill file's parent directory>.

<instruction body>
</skill>
```

Return `{ action: "transform", text, images: event.images }` on success.
For lookup or file-read errors, call `ctx.ui.notify(message, "error")` and return `{ action: "handled" }` without sending a user message.
The hook must not submit another message itself, which could duplicate a turn or lose the original delivery mode.

After installation or edits, run `/reload` in Pi.
To remove it, delete `~/.pi/agent/extensions/multi-skill.ts` and run `/reload`.
In `session_start`, when `ctx.mode === "tui"`, register a wrapper through `ctx.ui.addAutocompleteProvider()`.
Recognize a partial slash token only after one or more leading `/skill:<name>` commands.
For that token, ask the current provider for suggestions as if the token were the first command, with `force: false` even when Tab requested completion, and keep only `skill:` results.
Handle applying these completions explicitly so the inserted token retains its leading slash and trailing space; delegate other suggestions, completions, trigger characters, and file-completion decisions to the current provider.
Pi 1.4.0's provider hook does not itself auto-trigger a menu on a bare second slash.
Install a minimal `CustomEditor` subclass through `ctx.ui.setEditorComponent()` to supply that trigger.
In `handleInput`, first call `super.handleInput(data)`; when `data === "/"` and the resulting cursor is at a bare continuation token, call `super.handleInput("\t")` to request the normal completion action.
This supports both the first line and a continuation on a later line, without changing input elsewhere.
It uses Pi's native Tab completion binding; verify this binding if the user has customized it.
Do not change keybindings, and ask before replacing an unrelated custom editor if one is already installed.
Pi may render only the first wrapper as a skill card; verify that the complete combined text reaches model context rather than treating card appearance as proof of expansion.

## Acceptance checks

- Type `/skill:eng-governance-review /` in the real editor and verify the skill menu appears immediately without Tab or submission.
- Continue with bare-name queries such as `/bfr`, `/gitlab`, and `/bgl`, then select a result and verify both full `/skill:<name>` tokens remain intact with a trailing space and no agent turn.
- Verify explicit `/skill:` filtering, immediate third-skill and newline slash triggering, and completion with task text after the cursor.
- Verify ordinary slash-command and file completion still work outside the leading skill sequence.
- Submit two and then three leading skill commands and verify every body appears in order with the correct location and reference directory.
- Separate commands with a newline and verify expansion still works.
- Repeat a skill name and verify its body appears only once.
- Verify the task body is unchanged and skill-looking text after task prose is not expanded.
- Verify ordinary input and single-skill invocations retain native behavior.
- Verify an unknown second skill or unreadable skill file stops the whole submission with a visible error and no model call.
- Edit a skill file and verify the next expansion reads the updated body.
- Verify image attachments survive and steering/follow-up messages retain their normal delivery mode.
- Verify extension-injected messages are not transformed and loaded instructions are not recursively expanded.
- Reload twice and verify there is only one expansion per skill and unrelated extensions still work.
- Verify the interactive transcript and model context contain the complete request even if the UI summarizes the first skill.
