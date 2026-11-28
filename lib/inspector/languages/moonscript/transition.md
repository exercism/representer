# MoonScript's transition

This file says how the MoonScript outputs of this service differ from the tools they replace, and why.

## Representation

MoonScript had no representer of its own, so the track used Basic, which writes a solution's tokens line by line and renames nothing.
Inspector parses each solution with tree-sitter-moonscript instead, and writes the tree that MoonScript's own parser would give.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. Inspector renames every name the solution defines, wherever it appears: variables, functions, parameters, the variables of loops and of unpacked tables, classes and their properties, table keys, and the fields assigned on `self`, a class or a table (such as `@count = 0` and `M.go = ->`). The names that the solution doesn't define keep their names, such as `table.insert` and `string.format`. A class's constructor `new` and metamethods such as `__tostring` keep their names, because MoonScript and Lua call them by these names.
- **Layout.** Basic kept line breaks and indentation. Inspector drops comments, layout and brackets that only group, so `(a * b) + c` and `a * b + c` are the same. The brackets around a call or `...` stay, because they keep only its first value.
- **Imports.** Inspector drops `import ... from require "..."` and each assignment of a `require`, such as `List = require 'pl.List'`.
- **Strings and numbers.** Each string and number is written as its value, so `'you'`, `"you"` and `[[you]]`, and `0x1F` and `31`, are the same. `1` and `1.0` stay apart, because Lua reads one as an integer and the other as a float.
- **Spellings.** The spellings that MoonScript's parser reads the same way share a representation (see the list below).
- A solution with a syntax error still gets Basic's representation, with MoonScript's version.

The representation's version is 6, one above Basic's version 5, so the website will represent every MoonScript solution again.

## Spellings that share a representation

MoonScript's parser reads each of these pairs as the same program, so Inspector gives them the same representation:

- Quote style: `'you'` → `"you"`, `[[you]]` → `"you"` and `[==[you]==]` → `"you"`. A single-quoted string never interpolates, so `'#{x}'` stays apart from `"#{x}"`.
- A line break straight after the opening brackets of a long string: `[[` followed by a new line and `you]]` → `[[you]]`.
- An escaped quote: `'a\'b'` → `"a'b"`.
- Number spelling: `0x1F` → `31`, `.5` → `0.5` and `1e3` → `1000.0`.
- Brackets that only group: `(a * b) + c` → `a * b + c`.
- A call with or without brackets: `f a, b` → `f(a, b)`, and `f!` → `f()`.
- A body on the same line as its statement: `if a then b` → `if a` with `b` on the next line, and the same for `->`, `else`, `when`, and loops with `do`.
- An empty parameter list: `() -> 1` → `-> 1`.
- A table without braces: `x = a: 1, b: 2` → `x = {a: 1, b: 2}`, `f x, a: 1` → `f x, {a: 1}`, and a table written as indented `key: value` lines after `=` → the same table in braces.
- The separators in a table: `{1, 2,}` and `{1` and `2` on separate lines`}` → `{1, 2}`.
- A shorthand key: `{:count}` → `{count: count}`.

## Analysis

This service doesn't make MoonScript analyses yet, and MoonScript has no old analyzer to compare with.

## Snippet

The snippet reads tree-sitter's tree, so it removes comments by the tree and skips the `import` lines at the top of the file. Its version is 2.
