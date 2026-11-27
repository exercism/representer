# Rust's transition

This file says how the Rust outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old Rust representer (`exercism/rust-representer`), which parsed the solution with syn, renamed the names it met and printed the result with prettyplease.
It differs from the old representer in the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and in these ways:

- Doc comments are dropped with the other comments. The old representer read them as attributes and printed them.
- Numbers are written as their values, so `1_000` and `1000` are the same, and so are `0x1F` and `31`. An integer or float keeps its type suffix, as in `1000u32`. The old representer printed each number as written.
- Strings are written as their values, so a raw string and a regular string with the same text are the same, and the escapes `\n`, `\r`, `\t`, `\0`, `\\`, `\"`, `\'`, `\x41` and `\u{41}` are read. A byte string or C string stays apart from a string. The old representer printed each string as written.
- An assignment at the end of a block is the same with or without its `;`, because an assignment's value is always `()`.
- A match arm's block that holds one expression is the same as the expression, so `x => { y }` and `x => y` are the same, and `x => {}` is the same as `x => ()`.
- A shorthand field is the same as the field written in full, so `Point { x }` and `Point { x: x }` are the same, in values and in patterns.
- An empty statement (`;;`) is dropped.
- The items of a file and the items in an impl, a trait or a module are sorted by their code, with the renamed names left out, and each attribute moves with its item. The old representer sorted only the items of a file and of an impl, by their names, so two solutions that named things differently could be sorted differently.
- A name in a pattern that starts with a capital letter, such as `None`, `Ok` in `Ok(v)` or `Less`, refers to an enum variant, a struct or a constant, so it defines no name. It is renamed only if the solution defines it elsewhere, such as an enum variant of the solution's own. The old representer kept `Some` and `None` and renamed every other name in a pattern.

## Analysis

This service doesn't make Rust analyses yet, so there is nothing to compare with the old analyzer (`exercism/rust-analyzer`).

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments, `use` lines and crate attributes by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the `use` declarations, `extern crate` declarations and crate attributes at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
