# Suggestions for the Elixir representer

The Elixir representer matches what the old representer (`exercism/elixir-representer`) did, apart from the decisions that apply to every language.
These are changes that could improve it.
None of them is made, because a change to Elixir's own behaviour needs the maintainers to decide it.

## Names

1. **Give each function's variables their own placeholders.** Renaming goes by name, so a variable called `count` shares its placeholder with `Enum.count`, and a variable called `minute` with the field in `clock.minute`. This causes the `armstrong-numbers`, `hamming` and `rna-transcription` splits in the golden data. Renaming a variable only within its function would fix it.
2. **Rename the name given with `as:`.** The engine drops every `alias`, so in `alias Foo.Bar, as: B`, `B` is never defined and keeps its name. The old representer renamed it. Writing each alias as the full name of its module (`B.x()` as `Foo.Bar.x()`) and then dropping the alias would merge more.
3. **Rename parametrised types and callbacks.** `@type t(a) :: ...` and `@callback f(x) :: y` define `t` and `f`, but only a type without parameters counts as a definition. The old representer renamed both. No golden solution has a parametrised type, and every callback in the golden data is implemented with a `def`, which renames it.
4. **Rename attributes that are set but never read.** An attribute counts as defined only if the solution reads it, so that Elixir's own attributes (`@impl`, `@behaviour`, `@enforce_keys`) keep their names without a list. The old representer had a list of Elixir's attributes and renamed every other one.

## Spellings that are apart today

Elixir's parser gives each of these pairs the same tree. No golden solution writes the second spelling, so they stay apart:

5. A charlist and its list of code points, such as `'ab'` and `[97, 98]`. Only `''` is `[]`.
6. `try(do: a, rescue: (e -> e))` and `try do a rescue e -> e end`. Only `do:` and `else:` are read as blocks.
7. `["a b": 1]` and `[{:"a b", 1}]`, and `%{m | :a => 1}` and `%{m | a: 1}`.
8. **Read every escape.** Only `\n`, `\t`, `\r`, `\s`, `\e`, `\0`, `\\`, `\"`, `\'` and `\#` are read, so `"\x41"` and `"A"`, and `"A"` and `"A"`, stay apart.

## Spellings that are merged today

9. `Mod.f` and `Mod.f()` get the same tree, because Elixir's parser gives them one. A mentor might suggest the brackets, which the formatter adds.

## Sorting module bodies

Reorder sorts each module's body, and Normalise moves each `@spec` into its function first:

10. **Move `@impl` with its function.** `@impl true` stays a statement of its own, so sorting can move it away from its function. A `@spec` before an `@impl` moves into the `@impl`, not the function.
11. **Keep the clauses of a function in order.** Elixir tries a function's clauses in order, and sorting can reorder them. Both orders must pass the tests, so a merge can only join solutions that behave the same in the tests, such as one with an unreachable clause.
