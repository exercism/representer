# V's transition

This file says how the V outputs of this service differ from the tools they replace, and why.

## Representation

V had no representer of its own, so the track used Basic, which drops comments and formatting and keeps everything else as tokens.
The representation now parses the solution with tree-sitter-v (from vlang/v-analyzer) and writes the tree that V's own parser (v.ast) would give.
It follows the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes.
For V, these are the changes:

- **Names.** Basic kept every name. Every name the solution defines now gets a placeholder: functions and methods, their receivers and parameters, generic types, variables defined with `:=` or in a `for` loop, short lambda parameters, constants, globals, labels, structs and their fields, enums and their values, type aliases and sum types, and interfaces and their methods. A name the solution doesn't define keeps its name, such as `println`, `it` or `strings.Builder`. `_` keeps its name.
- **Imports.** `import` lines are dropped, including an alias (`import arrays as arr`) and a list of names (`import math { abs }`). Basic kept them.
- **Layout.** Comments, semicolons, trailing commas and line breaks make no difference. Basic kept line breaks and commas. A line that starts with `.` continues the expression on the line before it, as V's parser reads it.
- **Brackets.** Brackets that only group make no difference, so `(a % 4 == 0) && b` and `a % 4 == 0 && b` are the same.
- **Strings.** Each string is written as its value, so `'a'` and `"a"` are the same. The escapes `\n`, `\t`, `\r`, `\a`, `\b`, `\f`, `\v`, `\\`, `\'`, `\"`, `\$`, `\xHH` (below 128), `\uXXXX` and three octal digits are read. Any other escape stays as it is written. A raw string (`r'a\b'`) is the same as the string with the same value. `'$name'` and `'${name}'` are the same, as V's parser reads them. A `$` before anything other than a plain name, as in `'$a.b'`, stays as it is written. A C string (`c'a'`) stays apart from a string, and a rune (`` `a` ``) keeps its text.
- **Numbers.** Each number is written as its value, so `1_000_000_000` and `1000000000` are the same, and so are `0x1F` and `31`, and `1.50` and `1.5`. An integer that starts with `0`, such as `017`, is read as octal. An integer stays apart from a float.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with V's version.

The representation starts at version 6, one above Basic's version 5.

## Spellings that share a representation

V's parser reads each of these pairs as the same program, so Inspector gives them the same representation:

- Quote style: `"you"` → `'you'`.
- A raw string and its escaped spelling: `r'a\n'` → `'a\\n'`.
- An escape in a string and the character it stands for: `'\x41'` → `'A'`.
- Braces around a name in a string: `'$name!'` → `'${name}!'`.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `0o17` → `15`, `017` → `15`, `0b11` → `3` and `1.50` → `1.5`.
- Brackets that only group: `(a * b) + c` → `a * b + c`.
- A trailing comma after the last item: `[1, 2,]` → `[1, 2]`, `g(a, b,)` → `g(a, b)`, and `P{ x: 1, }` → `P{ x: 1 }`.
- A `;` between statements: `a := 1; return a` → the same statements on separate lines.
- A line that starts with `.`: `xs.filter(it > 0)` with `.len` on the next line → `xs.filter(it > 0).len`.

## Analysis

This service doesn't make V analyses yet, and V had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to come from Basic's rules, which only removed the comments found by Rouge's V lexer.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the module clause and imports at the top of the file, up to the first other statement.
Its version is now 2.
