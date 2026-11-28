# Ballerina's transition

This file says how the Ballerina outputs of this service differ from the tools they replace, and why.

## Representation

Ballerina never had a representer of its own (there is no `exercism/ballerina-representer`), so there is nothing to compare with.
The representation follows the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes.

## Spellings that share a representation

Ballerina's parser reads each of these pairs as the same program, so Inspector gives them the same representation:

- A `'` before a name: `io:'println(1)` → `io:println(1)`.
- The spelling of a float without a type suffix: `1.50` → `1.5`, and `1e3` → `1000.0`.

## Analysis

This service doesn't make Ballerina analyses yet, and Ballerina has no old analyzer to compare with.

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Both find comments and `import` lines by the text at the start of each line, because Ballerina's grammar only splits the code into tokens.
This service skips the imports at the top of the file, up to the first other line, and keeps the first 15 lines of the main file, where snippet-extractor kept 10.
