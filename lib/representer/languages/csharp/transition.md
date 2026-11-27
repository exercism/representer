# C#'s transition

This file says how the C# outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old C# representer (`exercism/csharp-representer`), which ran Roslyn's simplifier and then its own rewriters.
It matches what the old representer did, apart from the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and this difference:

- `this.` is dropped before every name, even when a parameter or local variable has the same name, as in `this.count = count`. Roslyn's simplifier kept it there. The engine renames by name, so the field and the parameter get the same placeholder anyway, and two solutions only merge if both pass their tests.

## Analysis

This service doesn't make C# analyses yet, so there is nothing to compare with the old analyzer (`exercism/csharp-analyzer`).

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments and `using` lines by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the `using` directives at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
