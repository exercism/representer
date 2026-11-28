# Suggestions for V

[`transition.md`](../../../lib/inspector/languages/vlang/transition.md) says how Inspector treats V differently from Basic, which V used before.
These are changes that could improve it.
None of them is made, because a change to V's own behaviour needs the maintainers to decide it.

## Spellings that V reads as the same

1. **Drop `module main`.** V's parser gives a file without a module clause the module `main`, so `module main` changes nothing. Today a solution without it stays apart from one with it. One golden solution (nucleotide-count, meteoraxv) has no module clause.
2. **Read `'$a.b'` as `'${a.b}'`.** V's parser reads a `$` followed by a field access as an interpolation of that field. Today only `$name` on its own is read as an interpolation, and the rest stays as it is written. No golden solution uses the longer form.
3. **Read the escapes in a rune.** `` `\n` `` and a rune that holds a real line break are the same character. Today a rune keeps its text. No golden solution relies on this.
4. **Check that V reads `017` as octal.** The grammar reads an integer that starts with `0` as octal, and so does Inspector. If V reads it as decimal, `017` would merge with `15` when it should merge with `17`. No golden solution writes an integer like this.

## Equivalences for the maintainers to decide

5. **Write a name from a selective import as the qualified name.** `import math { abs }` with `abs(x)` and `import math` with `math.abs(x)` call the same function. Today they stay apart. Five golden solutions use a selective import.
6. **Drop `pub`.** Every solution is in the module `main`, which its tests share, so `pub fn` and `fn` behave the same. Today they stay apart. 23 golden solutions mark a function `pub`. Mentors may comment on it.
7. **Reorder the top-level declarations.** V lets functions, structs, enums and constants come in any order, so a Reorder stage could sort them, as Go's does. Today two solutions that only order their functions differently stay apart.
8. **Write a counting `for` loop as a range.** `for i := 0; i < n; i++ {}` and `for i in 0 .. n {}` do the same thing if the body doesn't change `i`. Five golden solutions use the first form and 19 the second. Mentors do comment on the choice, so this may be better kept.
