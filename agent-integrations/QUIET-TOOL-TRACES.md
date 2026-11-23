# Quiet tool traces specification

## Purpose

Keep an agent harness's interactive transcript focused on the conversation by hiding routine tool traces, without changing tool execution or conversation history.
This repo owns the specification, not a harness extension implementation.
When asked to set up quiet tool traces for a harness, assess native display settings before building an adapter.
A specification cannot grant display capabilities that the harness does not expose.

## Display behavior

Quiet mode is enabled at session startup, including when starting a new session, resuming a session, or reloading the integration.
The preference is session-local and is not persisted.
A tool trace is visible when quiet mode is disabled, the user explicitly expands it, or the harness marks the tool call or result as an error.
Otherwise, hide both the tool call and its result, including streaming or partial output.
Apply the rule to every tool the harness renders, including built-in, extension, and MCP tools, and tools loaded after startup.

Hidden traces occupy zero terminal lines.
Do not leave tool titles, summaries, colored boxes, borders, padding, or blank placeholders behind.
A collapsed one-line summary is only an approximation of this behavior.
Keep the harness's normal busy indicator, assistant messages, permission and confirmation prompts, and harness or extension errors visible.
Do not hide a prompt that requires user action.

Use the harness's structured error status rather than guessing from words such as "error" in successful output.
When a pending call fails, reveal its identifying call information and error result even in quiet mode.
Prefer the existing tool renderers when displaying traces, preserving their formatting and supported content types.
If the supported API cannot delegate to those renderers, explain what a replacement renderer would lose and ask before implementing it.

## Controls

Provide explicit controls to show and hide routine traces.
Prefer `/tool-traces on` to show them and `/tool-traces off` to hide them when the harness supports custom slash commands.
Here, `on` refers to trace visibility, not quiet mode.
Equivalent native commands or settings are acceptable; document their exact names.
Invalid arguments should show usage without changing the current state.
A display command must not start an agent turn or call a language model.
Briefly confirm the new state and explain that errors remain visible.

Changing visibility must redraw existing traces in the active transcript as well as affect future calls.
Showing traces should expand their detail; hiding traces should clear expansion so routine traces disappear again.
Preserve the harness's native expand/collapse shortcut and allow explicit expansion to reveal hidden traces while quiet mode remains enabled.
Do not introduce a new hotkey or replace an existing binding without asking.

## Invariants

This is a presentation-only integration.
Do not intercept, block, replace, or change tool execution, arguments, results, permissions, scheduling, or error status.
Do not remove messages from model context, rewrite session history, redact stored results, or change logging to make the terminal look quiet.
Keep hidden traces available for later inspection through the harness's normal history facilities.
Do not alter non-interactive output, machine-readable events, RPC behavior, or transcript exports to implement terminal hiding.
If the harness shares renderers across terminal and export views, check that exports retain tool information and report any limitation.

There is no telemetry, usage tracking, background watcher, additional model call, or external service.
Instructions telling the model not to show tool calls, a model-callable tool, or an MCP server alone do not satisfy this specification.

## Agent-assisted setup

1. Identify the target harness and its installed version.
   If the target is unspecified, ask which harness to configure.
2. Read its current documentation and inspect its supported settings and extension APIs.
   Check trace suppression, structured errors, renderer composition, redraw of existing traces, expansion controls, and mode boundaries.
   Do not assume that lifecycle hooks or plugin support include transcript rendering.
3. Prefer native configuration if it meets the requirements.
   Otherwise, build the smallest supported adapter outside this repo, in the harness's user extension directory or a separate user-selected project.
   Keep existing extensions and unrelated settings intact.
4. If exact support is unavailable, report the specific gaps and distinguish an approximation from a compliant integration.
   Ask before implementing reduced behavior, installing dependencies, using an external UI or output wrapper, patching undocumented internals, or forking the harness.
   Do not filter terminal output with string matching to simulate renderer support.
5. Verify in the actual interactive harness, including the user's terminal and tmux where applicable.
   Report the installed version, configuration or adapter path, controls, verification performed, and remaining limitations.
   Keep setup repeatable without duplicate integrations and explain how to disable or remove it.

Pi's tool-renderer resolver, render context, session-start event, and tool-expansion UI control are suitable integration points in versions that expose them.
For a zero-height Pi component, account for the renderer's surrounding shell as well as its returned lines.
Copilot CLI and other harnesses must be assessed against their installed versions; this spec does not assert that they expose equivalent controls.
The existing personal Pi extension is the inspiration, not a portable dependency or a reason to copy Pi-specific APIs into another harness.

## Acceptance checks

- Start, resume, and reload a session and verify routine calls, streaming output, and successful results are hidden with no empty boxes or spacing.
- Verify assistant messages, busy state, and permission or confirmation prompts remain visible.
- Trigger a harmless tool failure and verify its call identity and error result appear while quiet mode is enabled.
- Show traces and verify both earlier and new calls appear with their normal detail and formatting.
- Hide traces again and verify earlier and new routine traces disappear while errors remain visible.
- Verify native expansion reveals hidden traces and collapsing hides them again while quiet mode is enabled.
- Verify invalid command arguments do not change visibility or start an agent turn.
- Verify available built-in, extension, and MCP tools follow the same rule, including a tool registered after startup where supported.
- Verify tools still execute normally, the model receives unchanged results, and session history retains hidden calls and results.
- Verify non-interactive output and transcript exports retain their normal tool information.
- Verify repeated setup preserves unrelated settings and does not duplicate the integration.
