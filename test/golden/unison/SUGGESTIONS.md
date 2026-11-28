# Suggestions for Unison

These are improvements to Unison's representation for the maintainers to discuss.
None of them is in Inspector yet.

- **`do` and `'`.** `do f x` and `'(f x)` stay apart. Both delay the code, and Unison's parser reads both as a lambda that ignores its argument, so writing them the same would make them the same. A mentor might still prefer one spelling.
- **`cases` and `match`.** `f = cases x -> ...` and `f y = match y with x -> ...` stay apart. Unison reads `cases` as a lambda whose body matches its argument, so writing them the same would group solutions that only choose another spelling. A mentor might still suggest `cases`.
- **`let` blocks.** `x = let` followed by an indented block stays apart from the same block without `let`. Unison reads both the same, so dropping `let` would make them the same.
- **Brackets inside an expression.** `a + (b * c)` and `a + b * c` stay apart, and so do `(f x) + 1` and `f x + 1`. The grammar writes each expression as a flat list of its parts, so Inspector can only tell that brackets only group if it reads Unison's precedence rules. Doing that would group solutions that differ only in brackets that make no difference.
- **Brackets around a lambda's body.** `x -> (x + 1)` and `x -> x + 1` stay apart, for the same reason.
- **Qualified names.** `List.map f xs` and `map f xs` after `use List map` stay apart, because the `use` clause is dropped and `map` keeps no namespace. Writing every name with its namespace would make them the same, but Inspector would need to resolve each name the way Unison does.
- **Watch expressions.** Inspector keeps watch expressions such as `> leap 2000` and `test>` lines. They make no difference to the solution passing its tests, so dropping them would group solutions that differ only in what the student tried out.
- **The order of definitions.** The order of the definitions in a file makes no difference in Unison, so sorting the top-level definitions with `Reorder` would group solutions that only list their functions in another order.
- **Characters.** `?\s` and `? ` stay apart, and so do other escapes in characters. Reading the escapes in characters would make them the same.
