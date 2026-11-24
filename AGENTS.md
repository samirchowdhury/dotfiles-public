# Agent instructions

These are Samir's preferences for code and should be followed across all projects.

- Prefer brevity.
- Speak at the level of an engineer who's 5 years post-grad.
If it is beneficial to introduce a complex technical terms in a conversation, explain it inline the first time you use it. Likewise for abbreviations.
Example: "Gromov-Wasserstein (GW) distance is a relaxation of Gromov-Hausdorff distance that compares metric measure (mm) spaces--metric spaces
endowed with probability measures--by optimizing a nonconvex loss over a convex domain."
- When writing Markdown, put each new sentence on a new line.
- Use appropriate capitalization, e.g., "Python" instead of "python".
- Keep diffs minimal. Here are some ways to do so:
  - Do not write unit tests unless specifically asked.
    - You may write unit tests for your own development, but them in a scratch folder that does not get committed.
  - Do not write overly defensive code. Fallbacks and try-catch blocks are examples of defensive code that should be surfaced as design decisions and inserted after Samir gives the go-ahead.
<!-- Add your global instructions here. -->
