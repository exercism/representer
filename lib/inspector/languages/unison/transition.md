# Unison's transition

This file says how the Unison outputs of this service differ from the tools they replace, and why.

## Representation

Unison had no representer of its own, so the track used Basic, which writes a solution's tokens line by line and renames nothing.
The representation now parses the solution with tree-sitter-unison and writes the tree that Unison's parser would give.
It follows the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes.
For Unison, these are the changes:

- Every name the solution defines gets a placeholder: terms and their parameters, the parameters of lambdas, the variables in patterns, types, their constructors and record fields, abilities and their operations, and type variables. A namespace before a name, such as the `leap.` of `leap.leap`, keeps its text. Basic kept every name.
- A name with a capital in a pattern is a constructor, so `Less` and `Greater` keep their names, and a lower case name in a pattern is a variable.
- Comments, documentation blocks (`{{ ... }}`), everything after a `---` line, `use` clauses and layout make no difference. Basic kept line breaks, the spaces between tokens and the indentation of each line.
- Brackets around a single part, or around the whole of an expression, are dropped, so `f (x) y` and `f x y` are the same, and so are `x = (a + b)` and `x = a + b`. Other brackets stay, because the grammar writes each expression as a flat list of its parts and the brackets are the only sign of how the parts group. So `(a + b) * c` and `a + b * c` stay apart, and so do `a + (b * c)` and `a + b * c`.
- An operator in brackets, such as `(+)`, stays apart from the operator, so `foldLeft (+) 0` and `foldLeft + 0` stay apart.
- A number is written as its value, so `0x1f` and `31` are the same, and so are `1.50` and `1.5`. `1` (a Nat), `+1` (an Int) and `1.0` (a Float) stay apart.
- A string is written as its value, with its `\n`, `\t`, `\\` and `\"` escapes read. Any other escape stays as it is written. A raw string (`"""`) and a character keep their text.

The representation starts at version 6, one above Basic's version 5.
If a solution doesn't parse, it still gets Basic's representation, now with version 6.

## Spellings that share a representation

Unison's parser reads each of these pairs as the same program, so Inspector gives them the same representation:

- Number spelling: `0x1f` → `31`, `1.50` → `1.5`, `1e3` → `1000.0` and `-0` → `+0`.
- Brackets that only group: `f (x) y` → `f x y`, `g ((h x))` → `g (h x)`, `x = (a + b)` → `x = a + b`, `| (x > 0) -> 1` → `| x > 0 -> 1`, `Some (x) -> x` → `Some x -> x` and `(Nat) -> Nat` → `Nat -> Nat`.
- An escape and the character it stands for: `"a\"b"` → the string `a"b`.

## Analysis

This service doesn't make Unison analyses yet, and Unison had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to apply its rules to lines, and kept every comment, because Rouge has no Unison lexer.
It now reads the solution's syntax tree, so it removes every comment, documentation block and everything after a `---` line, and skips the `use` clauses at the top of the file, up to the first other statement.
If a file doesn't parse, the snippet finds the comments by the way they start (`--` and `{- ... -}`).
The snippet's version is now 2.
