# Tcl's transition

This file says how the Tcl outputs of this service differ from the tools they replace, and why.

## Representation

Tcl had no representer of its own, so the track used Basic, which writes a solution's tokens line by line and renames nothing.
Rosetta parses each solution with tree-sitter-tcl instead, and writes the words that Tcl's own parser reads.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. Rosetta renames every name the solution defines, wherever it appears as a word or a variable. Tcl passes variables by name, so the names come from the commands that create them: `set`, the procedures of `proc` and their parameters, the variables of `foreach`, `lmap` and `dict for`, `lappend`, `append`, `incr`, `lassign`, `scan`, `gets`, `upvar`, `array set`, the `dict` commands that change a variable, `variable` and `my variable`, the match variables of `regexp` and `regsub`, the variables of `catch` and of `try`'s handlers, `namespace eval`, and the classes, methods and constructor parameters of `oo::class`. A parameter called `args` keeps its name, because it takes the rest of the arguments.
- **Layout.** Basic kept line breaks. Rosetta drops comments, layout, line continuations, the `;` and line breaks between commands, and brackets that only group in an expression, so `expr {($a + 1) * 2}` and `expr {(($a + 1)) * 2}` are the same.
- **Imports.** The `package require` and `namespace import` commands are dropped, as imports.
- **Words.** Basic kept each word as written. Rosetta writes each word as its value wherever nothing is substituted into it, so `"abc"`, `{abc}` and `abc` are the same, and so are `"a b"`, `{a b}` and `a\ b`. A word that holds variables or commands keeps them, with the text between them written as values, so `"a$b"` and `a$b` are the same. Tcl reads some escapes in a word: `\n`, `\t` and `\r`, and a backslash before a character that isn't a letter or a digit, which stands for that character. Any other escape, such as `\x41` or `\d`, keeps its text. The grammar reads a word in braces as a script wherever it could be one, as in a command's arguments, and Rosetta keeps it as a script, so spacing inside it makes no difference.
- **Expressions.** An expression in braces and one without them stay apart, because Tcl substitutes into an unbraced expression before `expr` reads it. Each number in an expression is written as its value, so `0x1F` and `31` are the same, and so are `1e3` and `1000.0`. An integer and a decimal stay apart.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with Tcl's version.

The representation starts at version 6, one above Basic's version 5.

## Spellings that share a representation

Tcl's parser reads each of these pairs as the same program, so Rosetta gives them the same representation:

- Quotes and braces around a word with nothing substituted into it: `"abc"` → `abc`, `{a b}` → `"a b"`, `{}` → `""`, and `{$a}` → `"\$a"`.
- Quotes around a word with substitutions: `"a$b"` → `a$b`, and `"$b"` → `$b`.
- An escape and the character it stands for: `"a\tb"` → the string with a real tab, `"\-"` → `-`, and `a\ b` → `"a b"`.
- Braces around a variable's name: `${count}` → `$count`.
- A `;` and a line break between commands: `set a 1; set b 2` → the two commands on two lines.
- A backslash and a line break, which continue a command: `puts a \` and `b` on the next line → `puts a b`.
- The optional `then` and `else` of `if`: `if {$a} then {b} else {c}` → `if {$a} {b} {c}`.
- Braces around a list of one name: `proc f a {}` → `proc f {a} {}`, and `foreach x $l {}` → `foreach {x} $l {}`.
- Brackets that only group in an expression: `expr {($a * $b) + 1}` → `expr {$a * $b + 1}`.
- Number spelling in an expression: `0x1F` → `31`, `0b101` → `5`, `0o17` → `15`, `.5` → `0.5` and `1e3` → `1000.0`.

## Analysis

This service doesn't make Tcl analyses yet, and Tcl had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to work on lines, with Basic's rules for the track.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the `package` commands at the top of the file, up to the first other command.
Its version is now 2.
