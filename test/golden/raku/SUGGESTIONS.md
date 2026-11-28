# Suggestions for Raku

[`transition.md`](../../../lib/inspector/languages/raku/transition.md) says how Inspector differs from the old Raku representer.
These are changes that could improve it.
None of them is made, because a change to Raku's own behaviour needs the maintainers to decide it.

## Spellings that Rakudo reads as the same

1. **Read more escapes and quoting forms.** Rakudo reads `"\x41"` and `"A"` as the same string, and `q{a}`, `Q[a]`, `「a」` and `'a'` too. Today these keep their text.
2. **Write the other statement modifiers as blocks.** `say $x while $y`, `until`, `given` and `with` could be written as blocks, as `if`, `unless` and `for` are.

## Names

3. **Rename public attributes with their accessors.** `has $.size` defines the attribute `$!size` and the method `size`. Renaming all three spellings together would follow the rule for every other name the solution defines. Today all three keep their names.
4. **Rename named parameters.** `sub f(:$size)` defines `$size`, and today it keeps its name.
5. **Rename enums, subsets and the tokens, rules and regexes of a grammar.** `enum Color`, `subset Pos` and `token word` define names, and today they keep them.
