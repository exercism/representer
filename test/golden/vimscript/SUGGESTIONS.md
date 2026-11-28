# Suggestions for Vimscript

[`transition.md`](../../../lib/rosetta/languages/vimscript/transition.md) says how Rosetta treats Vimscript differently from Basic, which Vimscript used before.
These are changes that could improve it.
None of them is made, because a change to Vimscript's own behaviour needs the maintainers to decide it.

## Gaps in the grammar

1. **Represent Vim9 script.** Five golden solutions are Vim9 script, and they get Basic's representation, because the grammar reads `def`, `var` and the types as plain words. Basic also keeps their `#` comments, because Rouge's Vimscript lexer only knows `"` comments. A grammar that parses Vim9 script would give them a tree, and `comment_text` could drop their comments in the meantime.
2. **Rename the names in commands the grammar doesn't know.** The grammar reads the arguments of commands such as `lockvar` as words, so `lockvar s:prototype` keeps the name `prototype` while the rest of the solution renames it. One golden solution (custom-set) uses `lockvar`.

## Spellings that Vim reads as the same

3. **Write a method call as a call.** Vim runs `a:list->sort()` as `sort(a:list)`, and `x->f(y)` as `f(x, y)`. Today the two spellings stay apart. 79 method calls appear in the golden solutions. Mentors may comment on the choice.
4. **Write a member access with a name as an index.** For a dictionary, `d.key` is `d['key']`. The grammar can't tell a dictionary from a string, for which `d.key` is a concatenation, so the two stay apart. Rosetta also renames a member name the solution assigns to (`let self.count = 0`), and keeps a key written as a string (`{'count': 0}`), so the same member can have a placeholder in one solution and its name in another.
5. **Write a number key as a string.** Vim turns each dictionary key into a string, so `{1: 'a'}` and `{'1': 'a'}` are the same dictionary.
6. **Treat `+1` and `+ 1` as the same.** Rosetta writes the number `+1` as `1`, and keeps `+ 1` as a plus sign on `1`. They have the same value.

## Equivalences for the maintainers to decide

7. **Drop the `!` after `function`.** `function!` replaces a function that already exists. Each solution defines its functions once, so the `!` makes no difference to the tests. Most golden functions have it.
8. **Drop `abort`.** `abort` makes a function stop at its first error. A solution that passes its tests raises no errors it doesn't throw itself, but mentors do comment on whether a function has `abort`.
9. **Treat `==` and `==#` as the same.** With the default `ignorecase` off, `==` compares strings by case, as `==#` does. Mentors may recommend `==#`, so the difference may matter to them.
10. **Drop `scriptencoding`.** `scriptencoding utf-8` only says how the file is encoded. Four golden solutions (micro-blog) have it.
11. **Write `let x = x + 1` as `let x += 1`.** The two do the same, for numbers and for strings with `..`.
12. **Reorder the functions and dictionary entries.** The order of the functions in a file and of the entries in a dictionary makes no difference. A Reorder stage could sort them, so that a helper defined before or after its caller gives the same representation.
