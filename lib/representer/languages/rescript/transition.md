# ReScript's transition

This file says how the ReScript outputs of this service differ from the tools they replace, and why.

## Representation

ReScript had no representer of its own, so the track used Basic, which drops comments and formatting and keeps everything else as tokens.
The representation now parses the solution with tree-sitter-rescript and writes the tree that the ReScript compiler's parser would give.
It follows the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes.
For ReScript, these are the changes:

- **Names.** Basic kept every name. Every name the solution defines now gets a placeholder: values and functions, their parameters and labels, the variables in patterns and `for` loops, types, type variables, abstract types, variant constructors, exceptions, record fields, polymorphic variants declared in a type, modules, functor parameters and externals. A name the solution doesn't define keeps its name, such as `Array.map` or `Some`.
- **Imports.** `open` statements are dropped, including `open!`. Basic kept them. `include` stays, because it copies a module's code into the solution.
- **Layout.** Comments, semicolons and formatting make no difference. Basic kept line breaks.
- **Brackets.** Brackets that only group make no difference, so `(a * b) / c` and `a * b / c` are the same, and so are `switch (x)` and `switch x`. A function's one parameter is the same with or without brackets, so `x => x` and `(x) => x` are the same. Braces around one expression make no difference, so `x => { x + 1 }` and `x => x + 1` are the same, and so are `| A => { 1 }` and `| A => 1`. ReScript's parser gives each of these pairs the same tree.
- **Punning.** ReScript's parser reads `{x}` as `{x: x}` and `f(~x)` as `f(~x=x)`, in records, record patterns and labelled arguments, so each pair is the same. A guard written with `when` is the same as one written with `if`.
- **Strings.** Each string is written as its value, with its `\n`, `\t`, `\r`, `\b`, `\\`, `\"` and `\'` escapes read, so `"a\tb"` and a string holding a real tab are the same. Any other escape stays as it is written. A template string stays apart from a string, because ReScript's parser marks it as different, and a character stays apart from a string.
- **Numbers.** Each number is written as its value, so `1_000` and `1000` are the same, and so are `0xFF` and `255`, and `1.` and `1.0`. An integer stays apart from a float, and a BigInt such as `10n` keeps its text.
- **Files.** The representer reads `.res` files, and ignores any `.resi` interface file.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with the ReScript representer's version.

The representation starts at version 6, one above Basic's version 5.

## Analysis

This service doesn't make ReScript analyses yet, and ReScript had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to work on lines, because the track had no grammar.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the opens at the top of the file, up to the first other statement.
Its version is now 2.
