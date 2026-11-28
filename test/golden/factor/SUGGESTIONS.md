# Suggestions for Factor

These are improvements to Factor's representation for the maintainers to discuss.
None of them is in Rosetta yet.

- **Octal and binary numbers.** Rosetta writes decimal and hexadecimal integers as their values, and keeps octal and binary integers as they are written. So `0o17` and `15` stay apart, and so do `0b101` and `5`.
- **Strings.** Rosetta keeps each string as it is written, so `"\x41"` and `"A"` stay apart.
- **Declared words.** The grammar reads `TUPLE:`, `CONSTANT:`, `SYMBOL:`, `GENERIC:` and `M:` as plain words, so the names they define keep their names. Two solutions that differ only in the name of a tuple or a constant stay apart.
- **Characters.** The grammar reads `CHAR: space` as the character `s` followed by the word `pace`. It reads every spelling the same way, so it merges nothing, but a mentor reading the representation would find it confusing.
