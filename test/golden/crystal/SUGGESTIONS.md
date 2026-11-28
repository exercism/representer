# Suggestions for Crystal

[`transition.md`](../../../lib/rosetta/languages/crystal/transition.md) says how Rosetta differs from the old Crystal representer.
These are changes that could improve it.
None of them is made, because a change to Crystal's own behaviour needs the maintainers to decide it.

## Spellings that the parser reads as the same

1. **Write a ternary as an `if`.** Crystal's parser reads `a ? b : c` as `if a; b; else; c; end`. Today the two stay apart.
2. **Write an `elsif` as an `if` inside an `else`.** The parser reads `if a; b; elsif c; d; end` as `if a; b; else; if c; d; end; end`.
3. **Turn heredocs into strings.** The parser reads a heredoc as a string with the same value. Today a heredoc keeps its start and its body as written.
4. **Join chained strings.** The parser reads `"a" \ "b"` as `"ab"`.
5. **Read characters as values.** `'\n'` and `'\u000A'` are the same character. Only strings are read today.

## Names

6. **Rename a generic type defined with a path.** `class Shop::Box(T)` doesn't rename `Box` today, although `class Box(T)` and `class Shop::Box` do. No golden solution defines one.
