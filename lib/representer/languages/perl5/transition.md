# Perl's transition

This file says how the Perl outputs of this service differ from the tools they replace, and why.

## Representation

Perl had no representer of its own, so the track used Basic, which writes a solution's tokens line by line and renames nothing.
The Perl representer parses each solution with tree-sitter-perl instead, and writes the tree that Perl's own parser would give.
It makes the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. This representer renames every name the solution defines, wherever it appears: its packages and classes, its subs and methods, the constants from `use constant`, its labels, and the variables declared with `my`, `our`, `state`, `field`, a `for` loop or a signature. Perl's own variables, such as `$_`, `@_`, `$a` and `@ISA`, keep their names, and so do hash keys and the functions that come from a module.
- **Layout.** Basic kept line breaks. This representer drops comments, POD, layout, the `;` between statements, a trailing `,` in a list, and brackets that only group. The brackets of a list assignment, such as `my ($x) = @_`, and of a repeated list, such as `(0) x 5`, stay, because they change what the code does.
- **Imports.** Every `use` and `require` of a module is dropped, and so are `use strict`, `use warnings`, `no strict`, `no warnings`, `use lib` and the export lists (`our @EXPORT`, `our @EXPORT_OK` and `our %EXPORT_TAGS`). The other pragmas stay, such as `use v5.38`, `use feature`, `use experimental`, `use integer` and `use constant`, because they change how Perl reads the code.
- **Calls.** Perl's parser reads a call the same way with or without brackets, so `print("hi")` and `print "hi"` are the same, and so are `$obj->name()` and `$obj->name`. `foreach` and `for` are the same, and so are `m/a/` and `/a/`, and `y///` and `tr///`.
- **Strings.** Basic kept each string as written. This representer writes each string as its value, so `'a'`, `"a"`, `q{a}` and `qq{a}` are the same, and so are `qw(a b)` and `('a', 'b')`, a word before `=>` and the same word in quotes, and a heredoc and the same string in quotes. A double-quoted string reads its `\n`, `\t`, `\r`, `\\`, `\"`, `\$` and `\@` escapes, and keeps the code it interpolates. Any other escape stays as it is written. A regular expression keeps its text, and its flags can come in any order.
- **Numbers.** Basic kept each number as written. This representer writes each number as its value: `1_000` and `1000` are the same, and so are `0x1F`, `017`, `0b11111` and `31`. Perl stores an integer and a decimal in different ways, so `1.0` and `1` stay apart.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with the Perl representer's version.

The representation starts at version 6, one above Basic's version 5.

## Analysis

This service doesn't make Perl analyses yet, and Perl had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to work on lines, because the track had no grammar.
It now reads the solution's syntax tree, so it removes every comment and every block of POD wherever it is, and skips whole statements at the top of the file, such as an `our @EXPORT_OK` list over several lines.
Its version is now 2.
