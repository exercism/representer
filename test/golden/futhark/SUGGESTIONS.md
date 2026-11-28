# Suggestions for Futhark

These are improvements to Futhark's representation for the maintainers to discuss.
None of them is in Rosetta yet.

- **Characters and numbers.** `c == 'a'` and `c == 97` stay apart. Futhark reads a character as the integer of its code point, so writing characters as numbers would make them the same. A mentor might still prefer the character.
- **Record punning.** `let {a} = r` and `let {a = a} = r` stay apart, and so do `{a}` and `{a = a}` in an expression. Futhark reads both spellings as the same field, so writing the short one in full would make them the same.
- **`local`.** `local def f x = x` and `def f x = x` stay apart. The tests can only call definitions that aren't local, so dropping `local` would group solutions that differ only in hiding their helpers. A mentor might still comment on it.
- **Indexing.** `a[i, j]` and `a[i][j]` stay apart, although both read the same element. Writing one as the other would make them the same.
- **Pipes.** `xs |> map f` and `map f xs` stay apart, and so do `f <| x` and `f x`. Writing pipes as calls would group solutions that differ only in this style, which a mentor might comment on.
- **Unsuffixed numbers.** `1i32` and `1` stay apart, although Futhark infers `1` as an `i32` wherever the code needs one. Reading the types would make them the same, but Rosetta would need Futhark's type inference.
- **Backticks.** ``a `max` b`` and `max a b` stay apart. Futhark's parser reads both as a call of `max`, so writing them the same would make them the same.
