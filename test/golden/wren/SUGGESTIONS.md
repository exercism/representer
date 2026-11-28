# Suggestions for Wren

These are improvements to Wren's representation for the maintainers to discuss.
None of them is in Inspector yet.

- **Byte escapes.** Inspector doesn't read `\xHH`, so `"\x41"` and `"A"` stay apart.
- **Raw strings.** Wren drops the first line of a raw string if it holds only spaces, and the last line too. Inspector keeps them, so `"""\nabc\n"""` and `"abc"` stay apart.
