# Suggestions for Clojure

[`transition.md`](../../../lib/inspector/languages/clojure/transition.md) says how Inspector differs from the old Clojure representer.
These are changes that could improve it.
None of them is made, because a change to Clojure's own behaviour needs the maintainers to decide it.

## Order

1. **Sort every set.** The order of a set's items never makes a difference, and the engine's sort ignores the names a solution chose, so `#{a (inc b)}` and `#{(inc b) a}` could get one representation. Today only sets of strings, characters, numbers and keywords are sorted.
2. **Sort the entries of every map.** The same holds for a map's entries, such as `{:b x :a 1}` and `{:a 1 :b x}`.

## Spellings that are apart today

3. **Read the escapes in strings.** `"A"` and `"A"` are the same string, and so are `"a\nb"` and a string with a real line break.
4. **Read ratios and numbers in other bases.** `2/4` and `1/2` are the same ratio, and `2r101` and `5` are the same number.

## Macros

5. **Expand more of the core macros.** `doseq`, `case`, `condp`, `when-first`, `if-some` and `when-some` stay as they are written, and so does a `loop` that destructures.
6. **Expand `for` with `:while` after a `:let`.** That `for` stays as it is written today.
