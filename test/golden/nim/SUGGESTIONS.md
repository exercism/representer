# Suggestions for Nim

[`transition.md`](../../../lib/inspector/languages/nim/transition.md) says how Inspector differs from the old Nim representer.
These are changes that could improve it.
None of them is made, because a change to Nim's own behaviour needs the maintainers to decide it.

## Spellings that the parser reads as the same

1. **Read the escapes in strings.** Nim's parser reads `"\x41"` and `"A"` as the same string. Today each escape keeps its text.
2. **Read `s.len-1` as a subtraction.** The grammar reads `s.len-1` as the call `s.len(-1)`, although Nim reads it as `s.len - 1`. This splits a production group in reverse-string.

## Names

3. **Rename the variable of `except`.** `except ValueError as e` defines `e`, and today `e` keeps its name.

## Order

4. **Sort the exceptions that an `except` catches.** `except ValueError, IOError` and `except IOError, ValueError` catch the same exceptions. Today they stay apart.
