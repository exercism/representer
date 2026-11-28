# Perl's transition

This file says how the Perl outputs of this service differ from the tools they replace, and why.

## Representation

Perl had no representer of its own, so the track used Basic, which writes a solution's tokens line by line and renames nothing.
Inspector parses each solution with tree-sitter-perl instead, and writes the tree that Perl's own parser would give.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. Inspector renames every name the solution defines, wherever it appears: its packages and classes, its subs and methods, the constants from `use constant`, its labels, and the variables declared with `my`, `our`, `state`, `field`, a `for` loop or a signature. Perl's own variables, such as `$_`, `@_`, `$a` and `@ISA`, keep their names, and so do hash keys and the functions that come from a module.
- **Layout.** Basic kept line breaks. Inspector drops comments, POD, layout, the `;` between statements, a trailing `,` in a list, and brackets that only group. The brackets of a list assignment, such as `my ($x) = @_`, and of a repeated list, such as `(0) x 5`, stay, because they change what the code does.
- **Imports.** Every `use` and `require` of a module is dropped, and so are `use strict`, `use warnings`, `no strict`, `no warnings`, `use lib` and the export lists (`our @EXPORT`, `our @EXPORT_OK` and `our %EXPORT_TAGS`). The other pragmas stay, such as `use v5.38`, `use feature`, `use experimental`, `use integer` and `use constant`, because they change how Perl reads the code.
- **Calls.** Perl's parser reads a call the same way with or without brackets, so `print("hi")` and `print "hi"` are the same, and so are `$obj->name()` and `$obj->name`. `foreach` and `for` are the same, and so are `m/a/` and `/a/`, and `y///` and `tr///`.
- **Strings.** Basic kept each string as written. Inspector writes each string as its value, so `'a'`, `"a"`, `q{a}` and `qq{a}` are the same, and so are `qw(a b)` and `('a', 'b')`, a word before `=>` and the same word in quotes, and a heredoc and the same string in quotes. A double-quoted string reads its `\n`, `\t`, `\r`, `\\`, `\"`, `\$` and `\@` escapes, and keeps the code it interpolates. Any other escape stays as it is written. A regular expression keeps its text, and its flags can come in any order.
- **Numbers.** Basic kept each number as written. Inspector writes each number as its value: `1_000` and `1000` are the same, and so are `0x1F`, `017`, `0b11111` and `31`. Perl stores an integer and a decimal in different ways, so `1.0` and `1` stay apart.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with Perl's version.

The representation starts at version 6, one above Basic's version 5.

## Spellings that share a representation

Perl's parser reads each of these pairs as the same program, so Inspector gives them the same representation:

- Quote style: `'Ding!'` → `"Ding!"`, `q{you}` → `'you'`, `qq{you}` → `"you"`, and `'$5'` → `"\$5"`.
- An escaped quote: `'it\'s'` → `"it's"`.
- A heredoc and the same string in quotes: `<<END` with the line `hi` → `"hi\n"`.
- A word list: `qw(a b)` → `("a", "b")`.
- A word that `=>` or a hash subscript quotes: `(a => 1)` → `("a" => 1)`, and `$h{key}` → `$h{"key"}`.
- A fat comma: `(a => 1)` → `("a", 1)`.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `017` → `15`, `0b101` → `5`, `1.50` → `1.5` and `1e3` → `1000.0`.
- Brackets that only group: `($a * $b) + $c` → `$a * $b + $c`.
- Brackets around a function's arguments: `print("hi")` → `print "hi"`.
- A `;` after the last statement of a block: `{ return 1; }` → `{ return 1 }`.
- A trailing comma after the last item: `(1, 2,)` → `(1, 2)`.
- An arrow between subscripts: `$x->[0]->[1]` → `$x->[0][1]`.
- `foreach` and `for`: `foreach my $x (@_)` → `for my $x (@_)`.
- The spelling of a regular expression: `m/a/` → `/a/`, `m{a}` → `/a/`, `y/a/b/` → `tr/a/b/`, and the order of its flags, `/a/ix` → `/a/xi`.

## Analysis

This service doesn't make Perl analyses yet, and Perl had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to work on lines, because the track had no grammar.
It now reads the solution's syntax tree, so it removes every comment and every block of POD wherever it is, and skips whole statements at the top of the file, such as an `our @EXPORT_OK` list over several lines.
Its version is now 2.
