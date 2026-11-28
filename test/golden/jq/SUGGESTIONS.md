# Suggestions for jq

[`transition.md`](../../../lib/rosetta/languages/jq/transition.md) says how Rosetta treats jq differently from Basic, which the track used before.
These are changes that could improve it.
None of them is made, because a change to jq's own behaviour needs the maintainers to decide it.
The counts come from the 379 golden solutions that parse.

## Spellings that mean the same

1. **Write `1` and `1.0` the same way.** jq stores every number as a decimal, so the two give the same results in arithmetic and comparisons. jq 1.7 can print a literal as it is written, so `1.0` on its own prints as `1.0`. No golden solution writes a whole number with `.0`.
2. **Write `..` as a call to `recurse`.** jq's parser reads `..` as `recurse`, so the two run the same code. 1 golden solution uses `..` and 1 calls `recurse`.
3. **Write `.a | .b` the same as `.a.b`.** Both give the same value. jq's parser gives them different code, so they stay apart today. 2 golden solutions pipe one field into another.
4. **Write `map(f)` the same as `[.[] | f]`.** jq defines `map(f)` as `[.[] | f]`. Mentors may comment on the style, so this needs a decision. 133 golden solutions use `map`.
5. **Write `select(c)` the same as `if c then . else empty end`.** jq defines `select` this way. Mentors may comment on the style, so this needs a decision. 75 golden solutions use `select`, and 1 writes `else empty`.

## Names

6. **Rename a value parameter's filter too.** In `def f($a): a;`, jq defines both `$a` and the filter `a`. Rosetta renames `$a` and keeps `a`, so two solutions that use `a` with different names stay apart.
7. **Keep the names fixed by the tests.** In exercises such as log-line-parser, the tests call the functions given in the stub by name, such as `message` and `log_level`, so those names are the same in every solution, and renaming them only makes the output harder to read. 164 golden solutions define a function.

## Parsing

8. **Try a newer grammar for the solutions that don't parse.** 21 of the 400 golden solutions don't parse with tree-sitter-jq, so they get Basic's representation. Most of them put a pipe in the value of an object, as in `{key: .value[] | ascii_downcase}`, which jq allows and the grammar rejects.
