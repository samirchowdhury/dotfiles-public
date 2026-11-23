# Code review ontology

## Overview

Code review has typically been an O(n) operation, where `n = number of lines of code`.
This type of review is infeasible as agents take over coding work.
To manage complexity, this document sets up an ontology of primitives that humans can review instead of lines of code.
The guiding philosophy is to converge to a form of engineering governance for systems we cannot fully understand.

## Categories

| Symbol | Category |
| --- | --- |
| D | Design decision |
| B | Behavior change |
| I | Interface/API and return-type changes |
| R | Resource usage with room for significant optimization |
| U | Unhappy code paths or user interactions |

Let K denote `D + B + ... + U`.
The goal is for human code review to be an O(K) operation.

The following table lists example operations that should be flagged, along with their categories.

| Example | Category |
| --- | --- |
| Avoid micro-optimizations when there is no relevant constraint | |
| Choose a database read instead of an in-memory data structure | |
| Replace synchronous work with a background queue | |
| Introduce a dependency or a new service boundary | |
| Commit to a specific code path instead of generating fallbacks | |
| Change a Python return type or return ordering | |
| An in-memory data structure with unbounded growth | |
| Issue database queries one-by-one when queries can be batched | |
| User error from a complex UI | |
