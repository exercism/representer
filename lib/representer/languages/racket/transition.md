# Racket's transition

This file says how the Racket outputs of this service differ from the tools they replace, and why.

## Representation

Racket had no representer of its own, so the track used Basic, which drops comments and formatting and keeps everything else as tokens.
The representation now parses the solution with tree-sitter-racket and writes the forms that Racket's reader would give.
It follows the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes.
For Racket, these are the changes:

- **Names.** Basic kept every name. Every name the solution defines now gets a placeholder: functions and their parameters, global and local definitions, `let` and loop variables, `for/fold` accumulators, names bound by `match` patterns, macros defined with `define-syntax-rule`, structures and their fields, and classes with their fields and methods. A name the solution doesn't define keeps its name, such as `string-upcase`.
- **Imports.** `require` and `require/typed` forms are dropped. Basic kept them. `provide` forms stay, because they aren't imports.
- **Layout.** Comments, including `#|...|#` blocks and forms commented out with `#;`, and formatting make no difference. Basic kept line breaks.
- **Brackets.** `()`, `[]` and `{}` are the same, because Racket reads them as the same list. Basic kept the kind of bracket.
- **Quotes.** `'x` and `(quote x)` are the same, and so are the other quote marks and the forms they stand for, such as `` `x `` and `(quasiquote x)`.
- **Values.** `#true` and `#t` are the same, and so are `#false` and `#f`. A character written in two ways, such as `#\linefeed` and `#\newline`, is one character. Each string is written as its value, with its `\n`, `\t`, `\"`, `\\` and other one-letter escapes read, so a here string and a string with the same text are the same. Any other escape stays as it is written.
- **Numbers.** Each number is written as its value, so `#x1F` and `31` are the same, `1.50` and `1.5` are the same, `1e3` and `1000.0` are the same, and `2/4` and `1/2` are the same. `1` and `1.0` stay apart, because Racket reads `1` as exact and `1.0` as inexact.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with the Racket representer's version.

The representation starts at version 6, one above Basic's version 5.

## Spellings that share a representation

Racket's reader reads each of these pairs as the same program, so the representer gives them the same representation:

- The kind of bracket: `[name "you"]` → `(name "you")`, and `{list 1}` → `(list 1)`.
- A quote mark and the form it stands for: `'a` → `(quote a)`, and `` `(a ,b) `` → `(quasiquote (a (unquote b)))`.
- Boolean spelling: `#true` → `#t`, and `#F` → `#f`.
- Character spelling: `#\linefeed` → `#\newline`, `#\null` → `#\nul`, `#\ ` → `#\space`, `#\101` → `#\A` and `#\u41` → `#\A`.
- A here string and the string with the same text: `#<<END` with the line `a"b` → `"a\"b"`.
- Number spelling: `#x1F` → `31`, `#b11` → `3`, `1.50` → `1.5`, `1.` → `1.0`, `1e3` → `1000.0`, `2/4` → `1/2` and `4/2` → `2`.
- The case of a hash's kind: `#HASH((a . 1))` → `#hash((a . 1))`.

## Analysis

This service doesn't make Racket analyses yet, and Racket had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to work on lines, because the track had no grammar.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the `#lang` line and the `provide` and `require` forms at the top of the file, up to the first other form.
Its version is now 2.
