# Prolog's transition

This file says how the Prolog outputs of this service differ from the tools they replace, and why.

## Representation

Prolog had no representer of its own, so the track used Basic, which drops comments, imports, module declarations and formatting and keeps everything else as tokens.
The representation now parses the solution with tree-sitter-prolog and writes the tree of terms that Prolog's reader (`read_term`) would give.
It follows the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes.
For Prolog, these are the changes:

- **Names.** Basic kept every name. Every predicate the solution defines (by a fact, a rule or a grammar rule) now gets a placeholder wherever its name appears, and so does every variable. `_` keeps its name, because each `_` is a different variable.
- **Imports.** `:- use_module(...)` and `:- ensure_loaded(...)` are dropped, as Basic dropped them.
- **Module declarations.** Basic dropped `:- module(...)`. The representation keeps it, because it isn't an import, so two solutions that export different predicates now stay apart.
- **Layout.** Comments, brackets that only group, separators and full stops make no difference. Basic kept line breaks and the brackets around goals.
- **Atoms.** A quoted atom that doesn't need its quotes is the atom, so `'ok'` and `ok` are the same. `[ ]` and `[]` are the same atom, and so are `{ }` and `{}`.
- **Strings.** Each double-quoted string is written as its value, with its `\n`, `\t`, `\\`, `\"`, `\'` and `` \` `` escapes read, and a quote written twice read as one quote. Any other escape stays as it is written.
- **Lists.** A list with a list as its tail is one list, so `[a|[b, c]]` and `[a, b, c]` are the same, and so are `[a|[]]` and `[a]`.
- **Numbers.** Each number is written as its value, so `1_000` and `1000` are the same, and so are `0x1F` and `31`, `1.0e3` and `1000.0`, and the character code `0'a` and `97`. `1` and `1.0` stay apart, because Prolog reads `1.0` as a float. `-1` (a number) and `- 1` (the term `-(1)`) stay apart.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with Prolog's version.

The representation starts at version 6, one above Basic's version 5.

## Spellings that share a representation

Prolog's reader reads each of these pairs as the same term, so Inspector gives them the same representation:

- Quote style: `'ok'` → `ok`.
- An escape and the character it stands for: `"a\tb"` → a string with a tab, and `"say ""hi"""` → `"say \"hi\""`.
- A list with a list as its tail: `[a|[b, c]]` → `[a, b, c]`, and `[a|[]]` → `[a]`.
- The spacing inside an empty list or braces: `[ ]` → `[]`, and `{ }` → `{}`.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `0b11` → `3`, `0o7` → `7`, `1.0e3` → `1000.0`, `0'a` → `97` and `0' ` → `32`.
- Brackets that only group: `(X > 1 -> true ; false)` → `X > 1 -> true ; false`, and `-(1)` → `- 1`.

## Analysis

This service doesn't make Prolog analyses yet, and Prolog had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to work on lines, because the track had no language of its own.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the module declaration and the imports at the top of the file, up to the first other statement.
Its version is now 2.
