# Suggestions for the Go representer

[`transition.md`](../../../lib/representer/languages/go/transition.md) says how the Go representer differs from the old one.
These are changes that could improve it.
None of them is made, because a change to Go's own behaviour needs the maintainers to decide it.

## Declarations

1. **Write a `var` with a `make` or a literal of its own type as a `:=`.** `var m map[string]int = make(map[string]int)` and `m := make(map[string]int)` give `m` the same type and value, and so do `var xs []int = []int{1}` and `xs := []int{1}`. Today only a `var` of a named type becomes a `:=`. This splits one production group in etl.
2. **Find the zero value of a type defined in another file.** `var t T` becomes `t := T{}` only if `T` is defined in the same file.
3. **Split a group of imports of `_` the same way as other groups.** `import _ "embed"` stays, but in a group with another import (`import ( _ "embed"; "fmt" )`) the whole group goes. No golden solution imports `_`.

## Spellings that are apart today

4. **Read runes as values.** `'A'` and `'\x41'` are the same rune. Only strings are read today.
