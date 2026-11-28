# Raku's transition

This file says how the Raku outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old Raku representer (`exercism/raku-representer`), which printed Rakudo's AST of each solution file (`.AST.raku`) and replaced each name in it with a placeholder.
This service reads the code with tree-sitter, so it needs no Rakudo.
It differs from the old representer in the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and in these ways:

- The old representer replaced every name in the AST, including names that the solution doesn't define, such as `say`, `export` and `return`, and its mapping wrote each name in quotes. This service renames the names the solution defines: its subs, methods, classes, modules, constants, variables and parameters. A variable's sigil stays part of its name, so `$count` and a sub called `count` are two names. A public attribute (`$.size`) and a named parameter (`:$size`) keep their names, because callers use them.
- Comments and Pod blocks are dropped.
- The `use`, `need`, `require` and `import` of a module are dropped, because a solution that passes its tests has already loaded everything it needs. A pragma, such as `use v6`, `use lib` or `use MONKEY-SEE-NO-EVAL`, stays, because it changes how the code runs.
- A statement with an `if`, `unless` or `for` modifier is written as a block, so `say $x if $y` and `if $y { say $x }` are the same.
- A string in single quotes, ‘’ or double quotes is written as its value, so `'a'` and `"a"` are the same. A string with interpolation, or with an escape other than `\n`, `\t` and the escaped quotes, sigils and brackets, keeps its structure.
- A heredoc's indentation is removed, up to the indentation of its closing line, as Raku does.
- A Num, such as `1e3`, keeps its text, and a Rat, such as `1.50`, is written as its value (`1.5`).
- A solution with a syntax error gets Basic's representation, which only drops comments and formatting.

## Spellings that share a representation

Raku's parser reads each of these pairs as the same program, so the representer gives them the same representation:

- Quote style: `'you'` → `"you"`, and `‘you’` → `'you'`.
- An escape and the character it stands for: `'it\'s'` → `"it's"`, and `"a\$b"` → `'a$b'`.
- Number spelling: `1_000` → `1000`, `0x1F` → `31` and `1.50` → `1.5`.
- Brackets that only group: `($a * $b) + $c` → `$a * $b + $c`.
- A statement modifier and its block: `say $x if $y;` → `if $y { say $x }`, and the same for `unless` and `for`.
- A `;` after the last statement: `say 1;` → `say 1`, and `{ say $x; }` → `{ say $x }`.

## Analysis

This service doesn't make Raku analyses yet, so there is nothing to compare with an old analyzer.

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments and `use` lines by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment and Pod block wherever it is, and skips the `unit` declarations and `use` statements at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
