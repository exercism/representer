# Dart's transition

This file says how the Dart outputs of this service differ from the tools they replace, and why.

## Representation

Dart had no representer of its own (there is no `exercism/dart-representer`), so Dart used Basic. Basic drops comments, imports and the spaces between tokens, and keeps everything else as it is written, including line breaks.
Dart now has a representation of its own, which follows the decisions that apply to every language ([docs/how-it-works.md](../../../../docs/how-it-works.md) describes them).
These things change for Dart:

- The representer renames every name the solution defines, so two solutions that differ only in their names get the same representation. Basic kept every name.
- The representer reads the solution's syntax tree, so line breaks make no difference.
- Each string and number is written as its value, so `'you'` and `"you"`, and `1_000` and `1000`, are the same. A trailing comma, and brackets that only group, make no difference either.
- The representer drops `export` directives as well as imports.
- A solution with a syntax error still gets Basic's representation, with Dart's version.

The representation's version is 6, one above Basic's version 5, so the website will represent every Dart solution again.

## Spellings that share a representation

Dart's parser reads each of these pairs as the same program, so the representer gives them the same representation:

- Quote style: `'you'` → `"you"`, and `'''you'''` → `'you'`.
- A raw string and its escaped spelling: `r'a\n'` → `'a\\n'`.
- An escape and the character it stands for: `'\x41'` → `'A'`.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `010` → `10`, `1.50` → `1.5` and `1e3` → `1000.0`.
- Brackets that only group: `(a * b) + c` → `a * b + c`.
- A trailing comma after the last item: `[1, 2,]` → `[1, 2]`, and `f(a, b,)` → `f(a, b)`.
- Braces around a name in a string: `'$name'` → `'${name}'`.

## Analysis

This service doesn't make Dart analyses yet, and Dart has no old analyzer to compare with.

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments, imports, exports and the library declaration by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the imports, exports and library declaration at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
