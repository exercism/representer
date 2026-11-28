# Suggestions for Euphoria

[`transition.md`](../../../lib/rosetta/languages/euphoria/transition.md) says how Rosetta treats Euphoria differently from Basic, which Euphoria used before.
These are changes that could improve it.
None of them is made, because a change to Euphoria's own behaviour needs the maintainers to decide it.

## Names

1. **Rename the routine named in a `routine_id` string.** `routine_id("neq")` refers to a routine the solution defines, but the name sits in a string, so it keeps its text while the routine itself gets a placeholder. Two solutions that differ only in that routine's name then stay apart. Three golden solutions call `routine_id`.
2. **Rename the namespace given by `include ... as`.** In `include std/math.e as m`, `m` is a name the student chose, and calls such as `m:sum(s)` keep it. Rosetta drops the include before it renames names, so it never sees `m` defined. Three golden solutions use `as`.

## Spellings that Euphoria reads as the same

3. **Write a character as its number.** Euphoria reads `'a'` as the integer `97`, so `x = 'a'` and `x = 97` are the same program. Today they stay apart. Mentors may prefer the character, so the difference may matter to them. 59 golden lines hold a character.
4. **Write a string as a sequence.** Euphoria reads `"ab"` as `{97, 98}` and `""` as `{}`. Today they stay apart. 21 golden lines hold `""` and 41 hold `{}`, so treating `""` and `{}` as the same would merge some solutions.
5. **Treat `1.0` and `1` as the same.** Euphoria has one kind of number (an atom), and `integer(1.0)` is true, so the two may be the same value. Today they stay apart, because the grammar gives them different node types. Four golden lines have a number such as `1.0`.

## Equivalences for the maintainers to decide

6. **Treat `public` and `global` as the same, or drop them.** A test file can call a routine whether it is `public`, `global` or `export`, as long as the routine has one of them. Most golden routines are `public`, two are `global`, and 36 routine definitions have no scope word.
7. **Write `x += 1` as `x = x + 1`.** The two do the same. 100 golden lines use `+=`, `-=` or `&=`.
8. **Reorder the routines.** Euphoria 4 allows a call before the routine's definition, so the order of the routines in a file makes no difference. A Reorder stage could sort them, so that a helper defined before or after its caller gives the same representation.
