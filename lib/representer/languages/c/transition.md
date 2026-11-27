# C's transition

This file says how the C outputs of this service differ from the tools they replace, and why.

## Representation

C used Basic before, which split the code into tokens, dropped the comments and the `#include` lines, and kept everything else as it was written, including the line breaks and the names.
The representation now reads the code's syntax tree, and differs from Basic in the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and in these ways:

- **Names.** Basic renamed nothing. This representation renames every name the solution defines: its functions, variables, parameters, types, `struct` and `enum` tags, fields, enumerators, macros and labels. A name the solution doesn't define, such as `strlen`, keeps its name.
- **Layout.** Basic kept the line breaks and the spaces between tokens. This representation ignores all layout.
- **Numbers and strings.** Basic kept each one as it was written. This representation writes each integer that fits in an int and has no suffix as its value, so `0x1F`, `037` and `31` are the same, and each decimal without a suffix as its value, so `1.50` and `1.5` are the same. It writes each string as its value, reading its escapes and joining strings written next to each other, so `"a" "b"` and `"ab"` are the same.
- **Brackets.** Brackets that only group are left out, so `(a % 4 == 0) && b` and `a % 4 == 0 && b` are the same, and so are `while ((c = next()))` and `while (c = next())`.
- **Preprocessor lines.** As before, the `#include` lines go. Every other preprocessor line stays, including include guards and `#pragma once`. The body of a `#define` stays as its text, so the names inside it keep their names.

A solution with a syntax error still gets Basic's representation, with C's version.

## Analysis

This service doesn't make C analyses yet, and C had no analyzer before.

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
While C used Basic, its snippet found the comments with C's lexer and skipped the `#include`, `#ifndef` and `#pragma` lines at the top of the file.
It now reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips those lines as statements.
A block between `#if 0` and `#endif` now stays in the snippet, because the grammar reads it as code.
