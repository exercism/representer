# Suggestions for Red

These are improvements to Red's representation for the maintainers to discuss.
None of them is in Rosetta yet.

- **Loop variables in a block.** Rosetta renames the word that `foreach` and `repeat` give each item (`foreach c "ab"`), and keeps the words in a block of them (`foreach [k v] m`). Renaming those too would put two solutions together if they only name their keys and values differently.
- **Loops in parens.** Rosetta only renames the loop variable of a `foreach` or `repeat` in a block or at the top of the file, and keeps it in a paren (`(foreach c "ab" [...])`).
- **Strings.** `"a"` and `{a}` are the same string, and stay apart. Writing each string as its value would make them the same.
- **Comment blocks.** `comment {...}` does nothing, and stays in the representation. Dropping it would put two solutions together if they only differ in such a comment.
- **Header.** The `Red [...]` header holds only facts about the file, such as its title and author, and stays in the representation. Dropping it would put two solutions together if they only differ in their header.
