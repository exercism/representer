# Cairo's transition

This file says how the Cairo outputs of this service differ from the tools they replace, and why.

## Representation

Cairo never had a representer of its own (there is no `exercism/cairo-representer`), so there is nothing to compare with.
The representation follows the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes.

## Analysis

This service doesn't make Cairo analyses yet, and Cairo has no old analyzer to compare with.

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments and `use` lines by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the `use` declarations at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
