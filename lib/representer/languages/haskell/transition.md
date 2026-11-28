# Haskell's transition

This file says how the Haskell outputs of this service differ from the tools they replace, and why.

## Representation

Haskell had no representer of its own, so it used Basic, which writes a solution's tokens line by line and renames nothing.
The representation now parses the solution with tree-sitter-haskell and writes the tree that GHC's parser would give.
It follows the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes.
For Haskell, these are the changes:

- Every name the solution defines gets a placeholder: the module, functions, operators, values, parameters, the variables in patterns, types, classes, constructors, record fields and type variables. Basic kept every name.
- Comments, Haddock documentation, imports and layout make no difference. Basic kept line breaks, the spaces between tokens and the indentation of each line.
- Explicit braces and semicolons are the same as indentation, and the Unicode spellings (`∷`, `→`, `∀`) are the same as the ASCII ones, because GHC reads them the same.
- Brackets that only group are dropped, so `f (g x)` and `f ((g x))` are the same. Brackets around an operator expression or a negation inside an operator expression stay, as in `(a - b) - c`, because the grammar reads every chain of operators from the right.
- A dot between two names with no spaces is composition, so `not.isSpace` and `not . isSpace` are the same, unless the module turns on `OverloadedRecordDot`.
- A number is written as its value, so `0x1F` and `31` are the same, and so are `1e3` and `1000.0`. `1` and `1.0` stay apart, because Haskell reads `1.0` as a fraction.
- A string is written as its value, with its `\n`, `\t`, `\\` and `\"` escapes read. Any other escape stays as it is written. A character keeps its quotes, so `'a'` and `"a"` stay apart.
- An operator defined in brackets is the operator, so `(|>) :: ...` names the same operator as `x |> f = ...`.

The representation starts at version 6, one above Basic's version 5.
If a solution doesn't parse, it still gets Basic's representation, now with version 6.

## Spellings that share a representation

GHC's parser reads each of these pairs as the same program, so the representer gives them the same representation:

- Unicode symbols: `∷` → `::`, `→` → `->`, `←` → `<-`, `⇒` → `=>` and `∀` → `forall`.
- Braces and semicolons in place of layout: `do { x <- getLine; pure x }` → the two statements on separate lines, and the same for `case ... of { ... }`.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `0o17` → `15`, `0b11` → `3`, `1.50` → `1.5` and `1e3` → `1000.0`.
- Brackets that only group: `g ((h x))` → `g (h x)`, `a + (g x)` → `a + g x`, and `f x = (g x)` → `f x = g x`. Brackets around an operator expression inside another operator expression stay, as in `(a * b) + c`.
- A dot with no spaces between two names: `not.isSpace` → `not . isSpace`, unless the module turns on `OverloadedRecordDot`.

## Analysis

This service doesn't make Haskell analyses yet, and Haskell had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to come from Basic, which applied its rules to lines.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the pragmas, the module header and the imports at the top of the file, up to the first other statement.
Before, a pragma at the top of the file stopped the skipping, so the card showed the pragma, the module header and the imports.
The snippet's version is now 2.
