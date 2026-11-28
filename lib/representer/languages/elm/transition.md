# Elm's transition

This file says how the Elm outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old Elm representer (`exercism/elm-representer`), which parsed the solution with elm-syntax, renamed every name that wasn't in its list of Elm's standard names or in the module's exposing list or imports, and printed the result as Elm code.
It matches what the old representer did, apart from the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and these differences:

- The list of what the module exposes is dropped, because every solution exposes what the tests use. The old representer printed it.
- Brackets that only group are dropped, so `f (g x)` and `f (g (x))` are the same. Brackets around an operator expression inside another one stay, as in `(a + b) * c`, because the grammar writes `a + b * c` as one flat list. The old representer printed every pair of brackets.
- A number is written as its value, so `0x1F` and `31` are the same, and so are `1.50` and `1.5`. The old representer kept a hexadecimal number as it was written. `1` and `1.0` stay apart, because Elm reads `1.0` as a Float.
- A constrained type variable keeps its name if it starts with `number`, `comparable`, `appendable` or `compappend`, as `comparable2` does, because Elm reads every such name as a constraint. The old representer kept only those four names exactly, and renamed `comparable2` like any other type variable.

## Spellings that share a representation

Elm's parser reads each of these pairs as the same program, so the representer gives them the same representation:

- Quote style: `"""a"""` → `"a"`.
- An escape in a string and the character it stands for: `"a\u{41}"` → `"aA"`, and `"\'"` → `"'"`.
- Number spelling: `0x1F` → `31`, `1.50` → `1.5` and `1e3` → `1000.0`.
- Brackets that only group: `g (h (x))` → `g (h x)`, and `(g x)` → `g x`. Brackets around an operator expression inside another one stay, as in `(a * b) + c`.

## Analysis

This service doesn't make Elm analyses yet, so there is nothing to compare with the old Elm analyzer (`exercism/elm-analyzer`).

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments, `module` lines and `import` lines by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the `module` declaration and the `import` statements at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
