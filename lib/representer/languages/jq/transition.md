# jq's transition

This file says how the jq outputs of this service differ from the tools they replace, and why.

## Representation

jq had no representer of its own, so the track used Basic, which writes a solution's tokens line by line and renames nothing.
The jq representer parses each solution with tree-sitter-jq instead, and writes the tree that jq's own parser would give.
It makes the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. This representer renames every name the solution defines, wherever it appears: functions, their parameters, the variables bound by `as` and in its patterns, and labels. A variable keeps its `$`, so `$x` and a function called `x` stay apart. The names of fields, such as `.name`, and of builtins, such as `length`, stay as they are.
- **Layout.** Basic kept line breaks and indentation. This representer drops comments, layout and brackets that only group, so `{a: (.b)}` and `{a: .b}` are the same.
- **Imports.** The `import` and `include` directives are dropped.
- **Strings.** Basic kept each string as written. This representer writes each string as its value, with its `\n`, `\"` and `\\` escapes read. Any other escape stays as it is written. An interpolation keeps its code.
- **Numbers.** Basic kept each number as written. This representer writes each number as its value, so `.8` and `0.8` are the same, and so are `1.50` and `1.5`. `1` and `1.0` stay apart.
- **Spellings that jq's parser reads as one.** These spellings now give the same representation, because jq's parser gives them the same code:
  - `.a`, `."a"` and `.["a"]`, and `.a.b` and `.a["b"]`.
  - `{a: 1}` and `{"a": 1}`, `{a}` and `{a: .a}`, and `{$a}` and `{a: $a}`. The same goes for the patterns after `as`, so `. as {$a}` and `. as {a: $a}` are the same.
  - `x?` and `try x`.
  - `elif` and an `if` inside the `else`, and an `if` without an `else` and the same `if` with `else .`.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with the jq representer's version.

The representation starts at version 6, one above Basic's version 5.

## Analysis

This service doesn't make jq analyses yet, and jq had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to work on lines, with Basic's rules for the track.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the `module`, `import` and `include` directives at the top of the file, up to the first other statement.
A file that doesn't parse still gets the rules for lines.
Its version is now 2.
