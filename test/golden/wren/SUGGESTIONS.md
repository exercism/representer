# Suggestions for Wren

These are improvements to Wren's representation for the maintainers to discuss.
None of them is in Rosetta yet.

- **Byte escapes.** Rosetta doesn't read `\xHH`, so `"\x41"` and `"A"` stay apart.
- **Raw strings.** Wren drops the first line of a raw string if it holds only spaces, and the last line too. Rosetta keeps them, so `"""\nabc\n"""` and `"abc"` stay apart.
