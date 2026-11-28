# AWK's transition

This file says how the AWK outputs of this service differ from the tools they replace, and why.

## Representation

AWK had no representer of its own, so the track used Basic, which writes a solution's tokens line by line and renames nothing.
The AWK representer parses each solution with tree-sitter-awk instead, and writes the tree that gawk's parser would give.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. This representer renames every name the solution defines, wherever it appears: functions and their parameters, and the variables and arrays that the solution assigns to, changes, subscripts, reads into with `getline`, deletes, loops over, or passes to a builtin that fills it, such as `split` or `gsub`. AWK's own variables, such as `NR`, `FS` and `PROCINFO`, keep their names, and so do the builtins and the functions that come from an `@load`, such as `ord`.
- **Layout.** Basic kept line breaks. This representer drops comments, layout, the `;` and line breaks between statements and rules, a lone `;`, the `\` at the end of a line, and brackets that only group.
- **Blocks.** AWK's parser reads a block as the statements inside it, so `if (x) { y }` and `if (x) y` are the same, and so are `else { if (z) w }` and `else if (z) w`. A block inside a block joins the list around it.
- **Calls.** AWK's parser reads `print(a, b)` as `print a, b`, `printf("%s", x)` as `printf "%s", x`, `func` as `function`, and `length` as `length()`, so the representer gives each pair the same representation.
- **Imports.** Every `@include` and `@load` is dropped. An `@namespace` stays, because it changes the names that the file defines.
- **Strings.** Basic kept each string as written. This representer writes each string as its value, with its `\n`, `\t`, `\r`, `\\` and `\"` escapes read, and drops a `\` at the end of a line inside a string. Any other escape stays as it is written. A regular expression keeps its text, and stays apart from a string with the same text.
- **Numbers.** Basic kept each number as written. AWK stores every number as a float, so this representer writes each number as its value: `1.0` and `1` are the same, and so are `0x1F` and `31`, `011` and `9`, and `1e3` and `1000`.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with the AWK representer's version. This includes the shell scripts of the basics exercise.

The representation starts at version 6, one above Basic's version 5.

## Spellings that share a representation

AWK's parser reads each of these pairs as the same program, so the representer gives them the same representation:

- Braces around a single statement: `if (x > 0) { print x }` → `if (x > 0) print x`, and the same for `else`, `for` and `while`.
- Braces around a block inside a block: `{ x = 1; { y = 2 } }` → `{ x = 1; y = 2 }`.
- A `;` after the last statement: `{ x = 1; print x; }` → `{ x = 1; print x }`.
- A `;` and a line break between statements: `x = 1; print x` → `x = 1` and `print x` on two lines.
- An empty statement: `x = 1;; print x` → `x = 1; print x`.
- A `\` at the end of a line: `x = 1 + \` and `2` on the next line → `x = 1 + 2`.
- Brackets around the arguments of `print` and `printf`: `printf("%s", x)` → `printf "%s", x`, and `print(a, b)` → `print a, b`.
- `length` without brackets: `length` → `length()`.
- `func` and `function`: `func f(x) { return x }` → `function f(x) { return x }`.
- Brackets that only group: `(a * b) + c` → `a * b + c`.
- Number spelling: `0x1F` → `31`, `011` → `9`, `1.50` → `1.5`, `1.0` → `1` and `1e3` → `1000`.
- An escape and the character it stands for: `"a\tb"` → the same string written with a real tab.

## Analysis

This service doesn't make AWK analyses yet, and AWK had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to be Basic's, which removed the comments found by the track's Rouge lexer.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the `@include` and `@load` lines at the top of the file, up to the first other statement.
Its version is now 2.
