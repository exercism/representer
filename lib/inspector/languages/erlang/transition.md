# Erlang's transition

This file says how the Erlang outputs of this service differ from the tools they replace, and why.

## Representation

Erlang had no representer of its own, so the track used Basic, which drops comments, imports, export lists and formatting and keeps everything else as tokens.
The representation now parses the solution with tree-sitter-erlang and writes the tree that Erlang's parser (`erl_parse`) would give.
It follows the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes.
For Erlang, these are the changes:

- **Names.** Basic kept every name. Every name the solution defines now gets a placeholder: the module, functions, variables, records and their fields, types, and macros. A predefined macro such as `?MODULE` keeps its name, and so does `_`.
- **Imports.** `-import`, `-include` and `-include_lib` are dropped, as Basic dropped them.
- **Export lists.** Basic dropped `-export` and `-export_type`. The representation keeps them, because they aren't imports, so two solutions that export different functions now stay apart.
- **Layout.** Comments, brackets that only group, separators and the keywords that sit in a fixed place make no difference. Basic kept line breaks and the brackets around expressions. `-behavior` and `-behaviour` are the same.
- **Atoms.** A quoted atom that doesn't need its quotes is the atom, so `'ok'` and `ok` are the same.
- **Strings.** Each string is written as its value, with its `\n`, `\t`, `\s`, `\\`, `\"` and `\'` escapes read. Any other escape stays as it is written. Strings written next to each other are one string, so `"a" "b"` and `"ab"` are the same.
- **Numbers.** Each number is written as its value, so `1_000` and `1000` are the same, and so are `16#FF` and `255`, and `1.0e3` and `1000.0`. `1` and `1.0` stay apart, because Erlang reads `1.0` as a float.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with Erlang's version.

The representation starts at version 6, one above Basic's version 5.

## Spellings that share a representation

Erlang's parser reads each of these pairs as the same program, so Inspector gives them the same representation:

- Quote style: `'ok'` → `ok`.
- An escape and the character it stands for: `"a\sb"` → `"a b"`, and `"a\'b"` → `"a'b"`.
- Strings next to each other: `"a" "b"` → `"ab"`.
- Number spelling: `1_000` → `1000`, `16#FF` → `255`, `2#11` → `3`, `1.50` → `1.5` and `1.0e3` → `1000.0`.
- Brackets that only group: `(A * B) + C` → `A * B + C`.
- The spelling of `-behaviour`: `-behavior(gen_server).` → `-behaviour(gen_server).`.

## Analysis

This service doesn't make Erlang analyses yet, and Erlang had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to work on lines, because the track had no grammar.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the module attributes at the top of the file, up to the first other statement.
Its version is now 2.
