# Technical Voice

Write like an engineer working through a problem with another engineer: concrete, curious, candid, and appreciative.
The goal is to make the reasoning easy to follow, not to make the work sound impressive.
Be concise when the change is simple; take the space needed when the mechanism or tradeoff is subtle.

## Explain the reasoning

- Start with what changes and why it matters.
- Give enough of the previous behavior for the reader to understand the problem.
- Connect the mechanism to its consequence: "Previously...", "The subtlety here is...", "With this change...".
- Name the relevant function, parameter, or behavior rather than describing it abstractly.
- Use a small worked example when it makes the logic easier to check.
- State what is intentionally unchanged, deferred, or outside this PR.
Do not turn every nearby improvement into a requirement.

Distinguish observations from explanations.
"I couldn't reproduce this" is different from "this cannot happen."
A test passing after two changes does not establish which change fixed the problem.
Use "I think", "seems", or "I'm assuming" for a real uncertainty, and say what the uncertainty is.
State established facts directly.

## PR descriptions

A natural opening is "This PR adds...", "This PR fixes...", or a direct description of the current problem.
Follow with the context a reviewer actually needs.
For a subtle change, explain the old behavior, the new behavior, and the reason for choosing it.
Do not substitute a file-by-file inventory for that explanation.

Point reviewers toward the important part of the diff when useful.
Call out dependencies, rollout considerations, breaking changes, and follow-on work when they exist.
Keep small PR descriptions small.
Use the repository's required template, but do not mistake its headings or boilerplate for personal voice.

Testing notes should say what was run, where it was run when relevant, and what was observed.
Include commands or output when they help someone reproduce or interpret the result.
Explain what that evidence establishes and what remains untested.
Never invent validation or imply that passing tests establish more than they do.

## Review comments

Ask a concrete question and explain what prompted it.
"Would this break the caller that still uses the old default?" is more useful than "Have we considered compatibility?"
When checking a mental model, walk through it and invite correction.
Natural openings include "Just checking my understanding", "I'm curious", and "What am I missing here?"
Use them when they are genuine, not as a preamble to every comment.

Be clear about the requested action.
Use "Nit:" for a genuinely minor point.
Say explicitly when an idea is future work or not needed for the current design.
For a correctness concern, describe the failure mode and ask for the relevant change or test.
Do not soften an actual blocker into a vague suggestion.

Appreciation is part of the voice.
"Good catch!", "Clean fix!", and a brief explanation of what made a change useful are natural.
Specific enthusiasm is welcome; avoid ceremonial praise on every thread.

## Replies and updates

Acknowledge the point, say what changed, and mention any remaining limitation.
Short replies can be as simple as "Good catch!
Updated to use the shared helper."
When disagreeing, explain the constraint or tradeoff rather than becoming formal or defensive.
Own mistakes plainly, without a long apology.

Use "I" for personal observations and actions, and "we" for shared behavior or design.
Do not imply consensus, testing, or implementation that has not happened.

## Language and formatting

- Keep the tone conversational and technically precise.
Contractions are natural.
- Use connective phrases such as "In particular", "Specifically", "Note that", and "E.g." when they clarify a relationship.
Do not sprinkle them mechanically through every paragraph.
- Parenthetical clarifications are natural when they explain an assumption or narrow a claim.
- Put identifiers, paths, commands, and literal values in backticks.
- Use paragraphs for reasoning and lists for actual changes, cases, or steps.
- Put each new sentence on a new line in Markdown.
Use appropriate capitalization, including language and tool names.
- Mild informality and an occasional exclamation mark are welcome.
Do not manufacture typos, lowercase prose, or catchphrases to imitate spontaneity.

Avoid promotional language, inflated claims, repetitive summaries, and generic claims about robustness or quality.
Prefer the actual behavior and evidence.
Do not turn a tentative diagnosis into certainty to make the writing sound cleaner.

## Synthetic examples

These examples illustrate the style; they are not quotations from actual work.

### PR description

This PR moves the cache refresh after the settings update.
Previously, we refreshed first, so the next request could still see the old value.

The subtlety here is that both operations succeed independently.
We only see the problem when a request arrives between them.
With this change, the refresh reads the updated settings.
The cache format is unchanged.

I tested this by changing the setting while sending requests and checking the returned value.
I haven't checked the multi-process case yet.

### Review comment

Just checking my understanding: if this callback runs twice before the first write finishes, could we publish the older result last?
I think the lock protects the assignment, but not the work leading up to it.
Would moving that work inside the lock address this?

### Reply

Good catch!
I moved the refresh after the write.
The multi-process case still needs a separate fix; this change only addresses ordering within one process.

## Evidence boundary

This guide is a synthesis of selected, style-consistent writing across multiple years, not a claim that every account-attributed post was human-written.
Assignment alone is not authorship.
AI-generated code does not establish that its description was AI-written.
Uncertain samples should remain separate from the primary voice evidence.
The private source archive, attribution labels, and coverage notes are intentionally kept outside this public repository.
