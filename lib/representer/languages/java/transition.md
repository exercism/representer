# Java's transition

This file says how the Java outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old Java representer (`exercism/java-representer`), which renamed the names in Spoon's model of the solution and printed the model back as formatted code.
It matches what the old representer did, apart from the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and these differences:

- A solution with a syntax error gets Basic's representation, which only drops comments and formatting. The old representer's compiler repaired small errors, such as a missing semicolon, and represented the result. Every solution that the representer sees passes its tests, so this only affects code that doesn't compile.
- A character literal keeps the text it is written with. The old representer read its value, so it merged `'A'` and `'A'`. No golden solution writes a character with a Unicode or octal escape.
- `else { if (a) b(); }` and `else if (a) b();` get the same representation, as they did before, but both are written as an `else` whose block holds the `if`. The old representer wrote both as an `else if`.

## Analysis

This service doesn't make Java analyses yet, so there is nothing to compare with the old analyzer (`exercism/java-analyzer`).

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments, the package declaration and imports by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the package declaration and the imports at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
