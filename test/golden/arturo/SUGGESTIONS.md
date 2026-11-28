# Suggestions for Arturo

[`transition.md`](../../../lib/inspector/languages/arturo/transition.md) says how Inspector treats Arturo differently from Basic, which Arturo used before.
These are changes that could improve it.
None of them is made, because a change to Arturo's own behaviour needs the maintainers to decide it.

## Names

1. **Rename the keys set through a path.** In `counts\total: 0`, `total` is a key the student chose. Inspector renames it only if a label also defines it, as in `counts: #[total: 0]`. If a solution adds a key only through a path, two solutions that differ only in that key's name will stay apart.
2. **Rename the attributes a function takes.** A function can take an attribute such as `.roman`, and read it with `attr 'roman`. Inspector renames the `roman` in `attr 'roman`, because a literal word defines a name, but keeps the `.roman` in the call. Two solutions that differ only in an attribute's name then stay apart. One golden solution uses `attr`.
3. **Keep the names of Arturo's magic methods.** Inside `define`, some method names have a meaning of their own, as `init` runs when an object is made. Inspector renames them like any other label, so `init: method [x][...]` and `setup: method [x][...]` get the same representation.

## Spellings that Arturo reads as the same

4. **Write `$` as `function`.** `$[x][x * 2]` and `function [x][x * 2]` make the same function. Today they stay apart.
5. **Write `\hour` as `this\hour`.** Inside a method, `\hour` is short for `this\hour`. Today they stay apart.
6. **Write a symbol as the word it stands for.** Arturo reads `a % b` as `mod a b`, `a + b` as `add a b` and `a = b` as `equal? a b`. Today each spelling stays apart. 18 golden solutions use `%` or `mod`.
7. **Write a string in braces over several lines as its value.** Arturo trims the margin of the lines of `{...}`, and of the strings that start with `«` or `---`. Inspector keeps those strings as written, so two solutions that indent such a string differently stay apart. Four golden solutions have one.

## Equivalences for the maintainers to decide

8. **Drop brackets that only group several values.** `zero? (year % 4)` and `zero? year % 4` do the same, but Arturo's parser keeps `(...)` as a value of its own. Inspector drops the brackets only around a single value.
9. **Write `x -> y` as `x [y]`.** A `->` turns the value after it into a block, so `if a -> return b` and `if a [return b]` do the same. 205 golden lines use `->`.
10. **Write `'x + 1` as `x: x + 1`.** A literal word before an operator changes the variable in place, so the two do the same.
11. **Reorder the labels in a dictionary.** `#[a: 1 b: 2]` and `#[b: 2 a: 1]` hold the same keys and values. A Reorder stage could sort them.
