# Roc's transition

This file says how the Roc outputs of this service differ from the tools they replace, and why.

## Representation

Roc had no representer of its own, so the track used Basic, which writes a solution's tokens line by line and renames nothing.
The Roc representer parses each solution with tree-sitter-roc instead, and writes the tree that the Roc compiler's parser would give.
It makes the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. This representer renames every name the solution defines, wherever it appears: values, functions, their parameters, the variables in patterns, mutable variables such as `$total`, types, the fields of records, the tags of tag unions and type variables.
- **Layout.** Basic kept line breaks and indentation. This representer drops comments, documentation comments, layout, commas and brackets that only group, so `f((x))` and `f(x)` are the same. Brackets around an operator expression or a negation inside an operator expression stay, as in `(a + b) * c`, because the grammar writes `a + b * c` as one flat list.
- **Imports.** The `import` statements are dropped.
- **Strings.** Basic kept each string as written. This representer writes each string as its value, with its `\n`, `\t`, `\r`, `\\`, `\"`, `\'`, `\${` and `\u(...)` escapes read, so `"\u(41)"` and `"A"` are the same. Any other escape stays as it is written. An interpolation keeps its code. A multiline string keeps its own form, with its lines joined by line breaks. A character such as `'a'` keeps its quotes, so `'a'` and `"a"` stay apart.
- **Numbers.** Basic kept each number as written. This representer writes each number as its value, so `0x1F` and `31` are the same, and so are `1_000` and `1000`, `1.50` and `1.5`, and `(-5)` and `-5`. `1` and `1.0` stay apart, because Roc reads `1.0` as a fraction. A number with a type, such as `5.U8`, keeps its text.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with the Roc representer's version.

The representation starts at version 6, one above Basic's version 5.

## Analysis

This service doesn't make Roc analyses yet, and Roc had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to work on lines, with Basic's rules for the track.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the `module` header and the `import` statements at the top of the file, up to the first other statement.
A file that doesn't parse still gets the rules for lines.
Its version is now 2.
