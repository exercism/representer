# Suggestions for Standard ML

These are improvements to Standard ML's representation for the maintainers to discuss.
None of them is in Rosetta yet.

- **An operator called with `op`.** `op + (a, b)` stays apart from `a + b`. The Definition of Standard ML reads `a + b` as `op + (a, b)`, so writing one as the other would make them the same. A mentor might still comment on the `op` form.
- **`[]` and `nil`.** `[]` and `nil` stay apart, and so do `[a, b]` and `a :: b :: nil`. The Definition reads a list in brackets as its constructors, so writing both the same way would group them.
- **`fun` and `val rec ... fn`.** `fun f x = x + 1` stays apart from `val rec f = fn x => x + 1`, and a `fun` with several clauses stays apart from a `fn` with a `case`. The Definition defines `fun` as the second form, but a mentor would likely comment on the choice.
- **`if` and `case` on a boolean.** `if b then 1 else 2` stays apart from `case b of true => 1 | false => 2`, and `a andalso b` from `if a then b else false`. The Definition defines each as the other, but a mentor would likely comment on the choice.
- **A function in brackets in an infix definition.** `fun (a ++ b) = a + b` and `fun a ++ b = a + b` are the same today. `fun op ++ (a, b) = a + b` stays apart from them, although it defines the same function.
- **The body of a `let`.** `let ... in a; b end` stays apart from `let ... in (a; b) end`. SML's parser reads the first as the second, so writing them the same way would group them.
- **Negative numbers and words.** `~1` and `~ 1` stay apart, and so do `0w10` and `0wxA`. Reading `~` as a minus sign, and reading words as their values, would make each pair the same. Words would still need to stay apart from integers.
- **The scope of fixity declarations.** Rosetta reads every `infix`, `infixr` and `nonfix` in a file as if it applied to the whole file, and doesn't read them from the solution's other files. A solution that declares an operator infix in one file and uses it in another keeps that use as a plain call, so it stays apart from the same code in one file.
- **The constructors of opened structures.** Rosetta keeps the names of the Basis Library's top-level constructors and exceptions in patterns, and renames every other unqualified name in a pattern as a variable. A constructor brought in by an `open`, such as `Jan` after `open Date`, is then renamed as if it were a variable.
- **Other escapes.** Rosetta reads the escapes that the solutions use. `\065`, `A` and `\^A` keep their text, so `"\065"` and `"A"` stay apart. Reading them too would make them the same.
