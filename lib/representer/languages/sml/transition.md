# Standard ML's transition

This file says how the Standard ML outputs of this service differ from the tools they replace, and why.

## Representation

Standard ML had no representer of its own, so the track used Basic, which writes a solution's tokens line by line and renames nothing.
The Standard ML representer parses each solution with tree-sitter-sml instead, and writes the tree that an SML compiler's parser would give.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. This representer renames every name the solution defines, wherever it appears: values, functions, operators, the variables in patterns, constructors, exceptions, record labels, types, type variables, structures, signatures, functors and their parameters. The constructors and exceptions of the Basis Library, such as `SOME`, `true` and `Fail`, keep their names in patterns.
- **Layout.** Basic kept line breaks. This representer drops comments, layout, the `;` between declarations, the `|` before the first case of a match, and brackets that only group.
- **Operators.** The grammar can't know which names are infix, so it reads `a + b * c` as a flat list. This representer groups the operators by the Basis Library's precedences and by the solution's own `infix`, `infixr` and `nonfix` declarations, as an SML compiler does. So `a + (b * c)` and `a + b * c` are the same, and so are `(f a) b` and `f a b`, and `foldl op+ 0` and `foldl (op +) 0`. `op + (a, b)` stays apart from `a + b`.
- **Records.** SML's parser reads the record pattern `{width}` as `{width = width}`, so the two are the same.
- **Imports.** Every `open` is dropped, as Basic dropped the `open` lines.
- **Strings.** Basic kept each string as written. This representer writes each string as its value, with its `\a`, `\b`, `\t`, `\n`, `\v`, `\f`, `\r`, `\"` and `\\` escapes read, and drops the `\ ... \` gaps that let a string go on over several lines. Any other escape stays as it is written. A character keeps its text, so `#"a"` and `"a"` stay apart.
- **Numbers.** Basic kept each number as written. This representer writes each integer and real as its value, so `1_000` and `1000` are the same, and so are `0x1F` and `31`, and `2.50` and `2.5`. An integer stays apart from a real. A negative number such as `~1` and a word such as `0w1` keep their text.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with the Standard ML representer's version.

The representation starts at version 6, one above Basic's version 5.

## Spellings that share a representation

SML's parser reads each of these pairs as the same program, so the representer gives them the same representation:

- A `;` after a top-level declaration, including the last one: `val a = 1;` → `val a = 1`.
- A `|` before the first case of a match: `case x of | 0 => 1 | _ => 2` → `case x of 0 => 1 | _ => 2`.
- Brackets that only group: `(a * b) + c` → `a * b + c`, `fun f (x) = x` → `fun f x = x`, and `(g a) b` → `g a b`.
- Brackets around `op`: `(op +) (1, 2)` → `op + (1, 2)`.
- Number spelling: `0x1F` → `31`, and `2.50` → `2.5`.
- An escape in a string and the character it stands for: `"a\nb"` → the string with a real line break, and a gap `"ab\   \cd"` → `"abcd"`.
- A record field that only names a variable: `fun f {width} = width` → `fun f {width = width} = width`.

## Analysis

This service doesn't make Standard ML analyses yet, and Standard ML had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to be Basic's, which removed the comments found by the track's Rouge lexer.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the opens at the top of the file, up to the first other statement.
Its version is now 2.
