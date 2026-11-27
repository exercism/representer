# F#'s transition

This file says how the F# outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old F# representer (`exercism/fsharp-representer`).
It matches what the old representer did, apart from the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes.

## Analysis

This service doesn't make F# analyses yet, so there is nothing to compare with the old F# analyzer.

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor skipped `open` lines and comments, found by the text at the start of each line.
This service reads the solution's syntax tree instead.
It also skips the `module` and `namespace` declarations at the top of the file, and shows the code inside them.
It removes every comment wherever it is, including XML documentation, and keeps the first 15 lines of the main file, where snippet-extractor kept 10.
