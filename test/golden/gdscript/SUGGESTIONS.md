# Suggestions for the GDScript representer

[`transition.md`](../../../lib/representer/languages/gdscript/transition.md) says how the GDScript representer differs from the old one.
These are changes that could improve it.
None of them is made, because a change to GDScript's own behaviour needs the maintainers to decide it.

1. **Rename the names bound in `match` patterns.** A `var x` in a pattern defines `x`, but it keeps its name today, so `match n: var x: return x` and the same code with `y` stay apart.
2. **Read the other escapes in strings.** Only an escaped quote of the string's own kind is read today, so `"A"` and `"A"`, and `"it\'s"` and `"it's"`, stay apart.
