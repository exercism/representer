# Suggestions for the Gleam representer

[`transition.md`](../../../lib/representer/languages/gleam/transition.md) says how the Gleam representer differs from the old one.
These are changes that could improve it.
None of them is made, because a change to Gleam's own behaviour needs the maintainers to decide it.

## Names

1. **Rename type variables.** The `a` in `fn first(xs: List(a)) -> a` is chosen by the student, so `List(a)` and `List(t)` could get one representation. Today they keep their names.
2. **Rename the aliases of constructors in imports.** After `import gleam/option.{Some as Just}`, `Just(1)` keeps the name `Just`, where an aliased function or type becomes the name it stands for.

## Spellings that are apart today

3. **Drop `pub`.** A solution that passes its tests works the same whether a helper function is public or private, so `pub fn helper` and `fn helper` could get one representation.
4. **Drop the type annotations of `let`.** `let x: Int = 1` and `let x = 1` mean the same, because Gleam infers the type.
