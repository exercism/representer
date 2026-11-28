# Scheme's transition

This file says how the Scheme outputs of this service differ from the tools they replace, and why.

## Representation

Scheme had no representer of its own (there is no `exercism/scheme-representer`), so Scheme used Basic. Basic drops comments and the spaces between tokens, and keeps everything else as it is written, including line breaks.
Scheme now has a representation of its own, which follows the decisions that apply to every language ([README.md](../../../../README.md#how-it-works) describes them).
These things change for Scheme:

- The representer renames every name the solution defines, so two solutions that differ only in their names get the same representation. This includes the names and parameters of `define`, `define*` and `lambda`, the variables of `let`, `let*`, `letrec`, named `let`, `let-values`, `receive`, `define-values` and `do`, the variable of a `guard`, the names of a record type (its type, constructor, predicate, fields, accessors and modifiers), and macros with their pattern variables. Basic kept every name.
- The representer reads the solution's syntax tree, so line breaks make no difference.
- The reader reads square brackets as round ones, so `(let ([x 1]) x)` and `(let ((x 1)) x)` are the same.
- The reader reads `'x` as `(quote x)`, and the other quote marks as their forms too (`` ` ``, `,`, `,@`, `#'` and the others), so the two spellings are the same.
- Each string, character, boolean and number is written as its value, so `"a\nb"` and a string with a real line break are the same, and so are `#\Space` and `#\space`, `#true` and `#t`, and `#x1F` and `31`. A string with an escape other than `\n`, `\\` and `\"` keeps its text. An exact number and an inexact one stay apart, so `1` and `1.0` stay apart, and a rational such as `1/2` keeps its text.
- `#;` comments out the datum after it, so the representer drops it with the other comments.
- The representer drops `import`, `use-modules`, `define-module` and `export` forms, as imports.
- A solution with a syntax error still gets Basic's representation, with Scheme's version.

The representation's version is 6, one above Basic's version 5, so the website will represent every Scheme solution again.

## Spellings that share a representation

Scheme's reader reads each of these pairs as the same program, so the representer gives them the same representation:

- Square and round brackets: `(let ([x 1]) x)` → `(let ((x 1)) x)`.
- A quote mark and its form: `'x` → `(quote x)`, `` `(a ,y) `` → `(quasiquote (a (unquote y)))`, and `,@y` → `(unquote-splicing y)`.
- An escape in a string and the character it stands for: `"a\nb"` → the string with a real line break.
- The case of a character's name: `#\Space` → `#\space`, and `#\NEWLINE` → `#\newline`.
- Boolean spelling: `#true` → `#t`, and `#false` → `#f`.
- Number spelling: `#x1F` → `31`, `#b101` → `5`, `#d10` → `10`, `+7` → `7`, `1.50` → `1.5` and `1e3` → `1000.0`.

## Analysis

This service doesn't make Scheme analyses yet, and Scheme has no old analyzer to compare with.

## Snippet

The snippet used to be Basic's, which removed the comments found by the track's Rouge lexer.
It now reads the solution's syntax tree, so it removes every comment and `#;` datum wherever they are, and skips the `import`, `use-modules` and `define-module` forms at the top of the file, up to the first other form.
Its version is now 2.
