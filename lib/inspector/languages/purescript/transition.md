# PureScript's transition

This file says how the PureScript outputs of this service differ from the tools they replace, and why.

## Representation

PureScript had no representer of its own, so it used Basic, which writes a solution's tokens line by line and renames nothing.
The representation now parses the solution with tree-sitter-purescript and writes the tree that the PureScript compiler's parser would give.
It follows the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes.
For PureScript, these are the changes:

- Every name the solution defines gets a placeholder: the module, functions, operators, values, parameters, the variables in patterns, types, classes, instances, constructors, record labels and type variables. Basic kept every name.
- The methods in an instance keep their names, because the class defines them. If the solution defines the class, its signatures define the names, so they get placeholders.
- Comments, documentation comments, imports and layout make no difference. Basic kept line breaks, the spaces between tokens and the indentation of each line.
- The Unicode spellings (`∷`, `→`, `←`, `⇒`, `∀`) are the same as the ASCII ones, because the compiler reads them the same.
- Brackets that only group are dropped, so `f (g x)` and `f ((g x))` are the same. Brackets around an operator expression or a negation inside an operator expression or an operator section stay, as in `(a + b) * c`, because the grammar reads every chain of operators from the left, whatever the operators' fixity.
- A record pun is the same as the field written in full, so `{ x }` and `{ x: x }` are the same, in a record and in a pattern.
- A number is written as its value, so `0xFF` and `255` are the same, and so are `1_000` and `1000`. `1` and `1.0` stay apart, because PureScript reads `1` as an Int and `1.0` as a Number.
- A string is written as its value, with its `\n`, `\r`, `\t`, `\\`, `\"` and `\'` escapes read, so `"a"` and `"""a"""` are the same. Any other escape stays as it is written. A character keeps its quotes, so `'a'` and `"a"` stay apart.

The representation starts at version 6, one above Basic's version 5.
If a solution doesn't parse, it still gets Basic's representation, now with version 6.

## Spellings that share a representation

PureScript's parser reads each of these pairs as the same program, so Inspector gives them the same representation:

- Unicode symbols: `∷` → `::`, `→` → `->`, `∀` → `forall`, `⇒` → `=>` and `←` → `<-`.
- Quote style: `"""you"""` → `"you"`.
- An escape and the character it stands for: `"a\"b"` → `"""a"b"""`.
- Number spelling: `1_000` → `1000`, `0xFF` → `255`, `1.50` → `1.5` and `1e3` → `1000.0`.
- Brackets that only group: `g ((h x))` → `g (h x)`, and `-(x)` → `-x`.
- A record pun: `{ x }` → `{ x: x }`.

## Analysis

This service doesn't make PureScript analyses yet, and PureScript had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to come from Basic, which only removed comments.
It now also skips the module header and the imports at the top of the file, up to the first other statement, so the card starts with the student's own code.
It works on lines, as Basic's did, and its version is now 2.
