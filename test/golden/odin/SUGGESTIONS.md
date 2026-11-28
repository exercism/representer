# Suggestions for Odin

[`transition.md`](../../../lib/rosetta/languages/odin/transition.md) says how Rosetta treats Odin differently from Basic, which the track used before.
These are changes that could improve it.
None of them is in Rosetta yet, because a change to Odin's own behaviour needs a human to decide it.
The counts come from a text search of the 160 golden solutions.

## Code that could be dropped

1. **Drop `@(private)` and other attributes that only change visibility or linking.** A helper's visibility makes no difference to whether the solution works. 3 golden solutions use `@(private)`, and 7 use an attribute of some kind.
2. **Drop `#partial` and other tags that only change what the compiler checks.** `#partial switch` only turns off the check that every case is handled. 2 golden solutions use it.

## Spellings that are apart today

3. **Write `x: T = v` as `x := T(v)`, and `x: int = 0` as `x := 0`.** Both declare a variable of the same type with the same value. 14 golden solutions declare a variable with both a type and a value.
4. **Write `x: T` as `x := T{}`, or the other way round.** Both declare a variable that holds the zero value of `T`. 25 golden solutions declare a variable with a type and no value.
5. **Write `proc(a: int, b: int)` as `proc(a, b: int)`.** Both declare two parameters of the same type. 16 golden solutions use each spelling.
6. **Write `cast(T)x` as `T(x)`.** Both convert `x` to `T`. 2 golden solutions use `cast`, and 32 use a conversion such as `f64(x)`.
7. **Write `x = x + 1` as `x += 1`.** Both change `x` in the same way. 3 golden solutions use the long form, and 54 use an operator such as `+=`.
8. **Write `else { if c { ... } }` as `else if c { ... }`.** Both run the same code, but Odin's parser reads the first as a block that holds an `if`.
9. **Read character literals as values.** `'\n'` and `'\x0a'` are the same rune, and only strings are read today. 2 golden solutions use an escape in a character.
10. **Write an import's alias as the package's own name.** The alias in `import str "core:strings"` keeps its name, so `str.to_upper(s)` and `strings.to_upper(s)` stay apart. No golden solution uses an alias.

## Loops

11. **Write `for i := 0; i < n; i += 1` as `for i in 0..<n`.** Both run the body with `i` from 0 to `n - 1`, if the body doesn't change `i`. 21 golden solutions use a C-style loop, and 22 loop over a range. A rule would have to check that the body never assigns to `i`.

## Sorting

Odin has no Reorder stage yet:

12. **Sort the declarations at the top of a package.** Odin doesn't need a name to be declared before it is used, so procedures, types and constants at the top of a file can come in any order. 55 golden solutions define more than one procedure.
