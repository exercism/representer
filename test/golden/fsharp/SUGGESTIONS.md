# Suggestions for the F# representer

The F# representer matches what the old representer (`exercism/fsharp-representer`) did, apart from the decisions that apply to every language.
These are changes that could improve it.
None of them is made, because a change to F#'s own behaviour needs the maintainers to decide it.

## Spellings that are apart today

The F# compiler's parser gives each of these pairs the same tree, but the grammar doesn't, so they stay apart:

1. **A match written on one line.** The grammar reads `match x with | A -> 1 | B -> 2` as one case, with `| B -> 2` as `|` and `->` operators in its body. Rewriting these as cases would merge them with the same match written over several lines. A few golden solutions write one.
2. **Interpolated strings.** `$"a{x}"` keeps its quotes and its raw text, so `$"a{x}"` and `$"""a{x}"""` stay apart, and its escapes aren't read.
3. **Numbers with an exponent.** The grammar reads `1.5e3` as the number `1.5` followed by the name `e3`, so `1.5e3` and `1500.0` stay apart.

## Sorting

The old representer sorted nothing, so Reorder doesn't exist for F#:

4. **Sort the fields of a record expression.** `{ Name = n; Age = a }` and `{ Age = a; Name = n }` build the same record. F# runs each field's code in the order written, so the two only mean the same when that code has no side effects. The fields of a record type and the cases of a union stay in order, because F# compares records and unions in that order.
