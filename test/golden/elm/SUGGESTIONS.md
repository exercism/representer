# Suggestions for Elm

[`transition.md`](../../../lib/rosetta/languages/elm/transition.md) says how Rosetta differs from the old Elm representer.
These are changes that could improve it.
None of them is made, because a change to Elm's own behaviour needs the maintainers to decide it.

## Spellings that the compiler reads as the same

1. **Write `else if` the same way, with or without brackets.** `if a then b else if c then d else e` and `if a then b else (if c then d else e)` are the same, but the grammar writes the first as one flat `if` and the second as an `if` inside another. Today they stay apart.
2. **Read a module's alias as the module.** After `import List as L`, `L.map` and `List.map` are the same function. The engine drops the import, so today they stay apart.
3. **Write a character as its value.** `'\u{41}'` and `'A'` are the same character. Today each escape in a character keeps its text.

