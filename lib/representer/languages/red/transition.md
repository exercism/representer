# Red's transition

This file says how the Red outputs of this service differ from the tools they replace, and why.

## Representation

Red never had a working representer of its own. The `exercism/red-representer` repository holds only the files that every Exercism repository starts with, so there is nothing to compare with.
The representation follows the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes.

## Analysis

This service doesn't make Red analyses yet, and Red has no old analyzer to compare with.

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Both work on lines, and skip the comments, the `comment {...}` blocks and the `Red [...]` header at the top of the file, up to the first line of code.
This service also removes the comments further down the file, including a comment after code on the same line.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
