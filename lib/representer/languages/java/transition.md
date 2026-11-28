# Java's transition

This file says how the Java outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old Java representer (`exercism/java-representer`), which renamed the names in Spoon's model of the solution and printed the model back as formatted code.
It matches what the old representer did, apart from the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and these differences:

- A solution with a syntax error gets Basic's representation, which only drops comments and formatting. The old representer's compiler repaired small errors, such as a missing semicolon, and represented the result. Every solution that the representer sees passes its tests, so this only affects code that doesn't compile.
- A character literal keeps the text it is written with. The old representer read its value, so it merged `'A'` and `'A'`. No golden solution writes a character with a Unicode or octal escape.
- `else { if (a) b(); }` and `else if (a) b();` get the same representation, as they did before, but both are written as an `else` whose block holds the `if`. The old representer wrote both as an `else if`.

## Spellings that share a representation

Java's parser reads each of these pairs as the same program, so the representer gives them the same representation:

- An escape and the character it stands for in a string: `"\101"` → `"A"`, `"\u0041"` → `"A"`, `"a\sb"` → `"a b"`, and `"it\'s"` → `"it's"`.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `017` → `15`, `0b11` → `3`, `1.50` → `1.5`, `1e3` → `1000.0`, `1.5e3F` → `1500.0f`, and `0x10l` → `16L`.
- Brackets that only group: `(a * b) + c` → `a * b + c`.
- Brackets around a lambda's single parameter: `(x) -> x` → `x -> x`.
- Several variables in one declaration: `int a, b = 1;` → `int a; int b = 1;`.
- Braces around a single statement: `if (x) g();` → `if (x) { g(); }`, and the same for `else`, `for`, `while` and `do`.
- A trailing comma after the last item: `{1, 2,}` → `{1, 2}`, and `enum C { RED, GREEN, }` → `enum C { RED, GREEN }`.
- A `;` after an enum's constants with nothing after it: `enum C { RED, GREEN; }` → `enum C { RED, GREEN }`.

## Analysis

This service doesn't make Java analyses yet, so there is nothing to compare with the old analyzer (`exercism/java-analyzer`).

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments, the package declaration and imports by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the package declaration and the imports at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
