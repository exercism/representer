# Suggestions for the Rust representer

[`transition.md`](../../../lib/representer/languages/rust/transition.md) says how the Rust representer differs from the old one.
These are changes that could improve it.
None of them is made, because a change to Rust's own behaviour needs the maintainers to decide it.

## Spellings that are apart today

1. **Read character literals as values.** `'\''` and `'\x27'` are the same character, but only strings are read today.
2. **Drop a `return` at the end of a function.** `return x;` as a function's last statement and a final `x` give the same result, and Clippy asks for the second.

## Sorting

3. **Sort the variants of an enum and the fields of a struct.** Their order makes no difference to code that names them, but `#[derive(PartialOrd)]` compares variants and fields in their order, so this would need to leave alone the types that derive an ordering.
