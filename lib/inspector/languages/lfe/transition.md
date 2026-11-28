# LFE's transition

This file says how the LFE outputs of this service differ from the tools they replace, and why.

## Representation

The track used Basic before, which writes a solution's tokens line by line and renames nothing.
Inspector parses each solution with tree-sitter-lfe instead, and writes the forms that LFE's reader would give: lists, symbols and values.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. Inspector renames every name the solution defines, wherever it appears: the module, the functions and macros, the local functions of `flet`, `fletrec`, `let-function` and `letrec-function`, records and their fields, the parameters of functions and lambdas, and every variable bound by a pattern in a function clause, `match-lambda`, `let`, `case`, `receive`, `catch`, a `?=` in `cond`, or a `<-` or `<=` in a comprehension. Inspector renames by text, so an atom such as `'go` gets the same placeholder as a function called `go`. The names that the solution doesn't define keep their names, such as `lists:map`, `tuple` or `string:to_upper`, and so do the functions that a record defines, such as `make-robot`.
- **Layout.** Basic kept line breaks and the spaces between tokens. Inspector drops comments and layout.
- **Imports.** Inspector drops `import` and `module-alias` inside `defmodule`, and every `include-lib` and `include-file`, because a solution that passes its tests has already loaded everything it needs. It keeps `export`.
- **Strings.** Basic kept each string as written. Inspector writes each string as its value, and reads the escapes `\n`, `\t`, `\\` and `\"`. It keeps a string with any other escape as it is written, so it can't merge with another string.
- **Numbers.** Inspector writes each number as its value, as LFE reads it: `#x1F`, `#16r1F` and `31` are the same, and so are `#b101` and `5`, and `1.50` and `1.5`. An integer and a float stay apart, so `1` and `1.0` stay apart.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with LFE's version.

The representation starts at version 6, one above Basic's version 5.

## Spellings that share a representation

LFE's reader reads each of these pairs as the same program, so Inspector gives them the same representation:

- Square brackets and round brackets: `(let [(x 1)] x)` → `(let ((x 1)) x)`.
- A quote mark and the form it stands for: `'ok` → `(quote ok)`, `'(1 2)` → `(quote (1 2))`, `` `(a ,b ,@c) `` → `(backquote (a (comma b) (comma-at c)))`, and `#'f/2` → `(function f 2)`.
- A symbol between bars and the same symbol without them: `|abc|` → `abc`.
- The two ways to write a binary of a string: `#"abc"` → `#B("abc")`.
- An escape in a string and the character it stands for: `"a\nb"` → the same string with a real line break.
- The two ways to write a character: `#\x41;` → `#\A`.
- Number spelling: `#x1F` → `31`, `#b101` → `5`, `#o17` → `15` and `1.50` → `1.5`.

## Analysis

This service doesn't make LFE analyses yet, and LFE had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to be Basic's, which removed the comments found by the track's Rouge lexer.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the `defmodule` form and any `include-lib` at the top of the file, up to the first other statement.
Its version is now 2.
