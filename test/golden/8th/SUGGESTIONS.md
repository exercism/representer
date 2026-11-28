# Suggestions for 8th

These are improvements to 8th's representation for the maintainers to discuss.
None of them is in Rosetta yet.

- **Words with and without a namespace.** 8th gives many words a short name in the global namespace as well as a name in their own namespace, so `mod` and `n:mod`, and `=` and `n:=`, are the same word. Rosetta keeps each word as it is written, so `100 mod` and `100 n:mod` stay apart. The golden leap solutions use both spellings.
- **The `G:` forms.** `G:if`, `G:else`, `G:then`, `G:(` and `G:)` name the same words as `if`, `else`, `then`, `(` and `)` in the global namespace. Rosetta keeps them apart. One golden solution uses them.
- **Numbers with a multiplier.** 8th reads `1k` as `1000`, `1g` as `1000000000` and `1t` as `1000000000000`. Rosetta keeps their text, so `1k` and `1000` stay apart. The golden gigasecond solutions use `1t`, `1k` and `1g`.
- **Names in a namespace.** A solution that starts with `ns: cb` defines its words in the `cb` namespace. If it then calls one of them as `cb:head@`, that call keeps its name, although the bare `head@` gets a placeholder. None of the golden solutions calls its own words with the namespace.
- **`var,` and `var` with `!`.** `0 var, count` creates a variable and sets it, as `var count 0 count !` does. Rosetta keeps the two spellings apart.
