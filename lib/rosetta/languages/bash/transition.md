# Bash's transition

This file says how the Bash outputs of this service differ from the tools they replace, and why.

## Representation

The track used Basic before, which writes a solution's tokens line by line and renames nothing.
Rosetta parses each solution with tree-sitter-bash instead, and writes the tree that Bash's parser would give.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. Rosetta renames every name the solution defines, wherever it appears: functions and the commands that call them, and the variables that the solution assigns to, declares with `local`, `declare`, `export` or `readonly`, loops over, changes in arithmetic (`(( n++ ))`, `(( total += x ))`), assigns an item of (`seen[$w]=1`), or fills with `read`, `mapfile`, `readarray`, `printf -v` or `getopts`. Bash's own variables, such as `IFS`, `REPLY`, `RANDOM` and `BASH_REMATCH`, keep their names, and so do the positional parameters (`$1`), the special parameters (`$@`, `$#`) and the commands that the solution doesn't define, such as `tr` or the `die` from a sourced `utils.bash`.
- **Layout.** Basic kept line breaks and the spaces between tokens. Rosetta drops comments, the `#!` line, layout, the `;` and line breaks between commands, the `;;` that ends a `case` item, and brackets that only group in arithmetic.
- **Imports.** Rosetta drops every `source` and `.` command, because a solution that passes its tests has already loaded the files it needs.
- **Strings.** Basic kept each string as written. Rosetta writes each quoted string as its value: `'a b'`, `"a b"` and `$'a b'` are the same. In double quotes, it reads the escapes `\"`, `\\`, `\$` and `` \` ``, and drops a `\` at the end of a line. In `$'...'`, it reads `\n`, `\t`, `\r`, `\\`, `\'` and `\"`, and keeps a string with any other escape as it is written. A double-quoted string that holds an expansion stays a string of its pieces, so `"$x"` and `$x` stay apart. An unquoted word stays apart from a quoted string with the same text.
- **Numbers.** Inside arithmetic (`$(( ))`, `(( ))`, a `for ((...))` header and the offset and length of `${x:offset:length}`), Rosetta writes each number as its value, as Bash reads it: `0x1F` and `31` are the same, and so are `010` and `8`, and `2#101` and `5`. Outside arithmetic, Bash reads a number as text, so `x=010` and `x=8` stay apart.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with Bash's version.

The representation starts at version 6, one above Basic's version 5.

## Spellings that share a representation

Bash's parser reads each of these pairs as the same program, so Rosetta gives them the same representation:

- The three ways to write a function: `function f { ... }` → `f() { ... }`, and `function f() { ... }` → `f() { ... }`.
- A `;` and a line break between commands: `a; b` → `a` and `b` on two lines.
- A `;` or a line break before `then` and `do`: `if a; then` → `if a` and `then` on two lines.
- A `;` after the header of a `for ((...))` loop: `for ((i = 0; i < 3; i++)); do` → `for ((i = 0; i < 3; i++)) do`.
- The `(` before a `case` pattern: `(a) b ;;` → `a) b ;;`.
- Backquotes and `$(...)`: `` `date` `` → `$(date)`.
- The old arithmetic spelling: `$[1 + 2]` → `$((1 + 2))`.
- Brackets that only group in arithmetic: `(( (a * b) + c ))` → `(( a * b + c ))`.
- Quote style: `'a b'` → `"a b"`, and `$'a\tb'` → the same string written with a real tab.
- An escape in double quotes and the character it stands for: `"\$x"` → `'$x'`, and a `\` at the end of a line inside double quotes → nothing.
- Number spelling in arithmetic: `0x1F` → `31`, `010` → `8` and `2#101` → `5`.

## Analysis

This service doesn't make Bash analyses yet, and Bash had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to be Basic's, which removed the comments found by the track's Rouge lexer.
It now reads the solution's syntax tree, so it removes every comment wherever it is, including the `#!` line, and skips the `source` lines at the top of the file, up to the first other statement.
Its version is now 2.
