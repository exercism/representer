# Suggestions for Cairo

These are improvements to Cairo's representation for the maintainers to discuss.
None of them is in Rosetta yet.

- **Strings.** Rosetta keeps each string as it is written, so `"a\x41"` and `"aA"` stay apart. Writing each string and short string as its value would make them the same.
- **Match arms.** `x => { y }` and `x => y` stay apart. Writing a match arm's block that holds one expression as the expression would make them the same, as Rust's representation does.
