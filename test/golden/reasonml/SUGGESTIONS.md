# Suggestions for ReasonML

[`transition.md`](../../../lib/rosetta/languages/reasonml/transition.md) says how Rosetta treats ReasonML differently from Basic, which the track used before.
These are changes that could improve it.
None of them is made, because a change to ReasonML's own behaviour needs the maintainers to decide it.
The counts come from the 178 golden solution files.

## Spellings that Reason's parser may read as the same

1. **Write `let f(x) = e` as `let f = (x) => e`.** Both define the same function. 1 golden solution uses the first form.
2. **Write `f(())` as `f()`.** Both call `f` with the unit value. No golden solution passes `()` in brackets.

## Equivalences for the maintainers to decide

3. **Rename the variables inside a `{j|...|j}` string.** BuckleScript reads `$name` in such a string as the variable `name`. Rosetta keeps the string's text, so the variable is renamed everywhere except in the string. This can only keep two solutions apart, never merge them. 5 golden solutions use `{j|...|j}` strings.
4. **Write a `{js|...|js}` string with only ASCII text as a plain string.** BuckleScript gives both the same value in that case. No golden solution uses `{js|...|js}`.
5. **Write `x |> f` as `f(x)`, and `x->f(y)` as `f(x, y)`.** Each pair calls the same function with the same arguments, but a mentor may prefer the pipe or comment on it. 79 golden solutions use `|>`, and 20 use `->`.
6. **Write `c ? a : b` as `if (c) { a } else { b }`.** Both choose a value in the same way. 31 golden solutions use the ternary, and 25 use `if`.
7. **Write `or` as `||`, and `&` as `&&`.** OCaml's standard library defines the older operators as the same functions. 1 golden solution uses `or`, and none uses `&`.

## Parsing

8. **Parse a type with one constructor and no `|`.** tree-sitter-reasonml can't parse `type t = Circle(float);`, so such a solution gets Basic's representation. `type t = | Circle(float);` parses. No golden solution is affected.
