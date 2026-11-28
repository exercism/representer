# Factor's transition

This file says how the Factor outputs of this service differ from the tools they replace, and why.

## Representation

Factor had no representer of its own (there is no `exercism/factor-representer`), so this service has no earlier Factor representation to differ from.
It applies the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and these rules of its own:

- **Comments.** The grammar reads comments as words, so the representer removes each `! text` and `#! text` from the source before parsing it. A `!` inside a string stays.
- **Layout.** Brackets, the stack effect's `--` and the `;` that ends a definition are left out, because the tree already shows them.
- **Imports.** Every `USING: ... ;` and `USE: word` is dropped.
- **Names.** The words defined with `:` and `::`, the names in stack effects and the names bound with `:>` are renamed, wherever they appear. So a name used in a stack effect, such as `?` in `( n -- ? )`, is renamed wherever it appears, including where it is used as a word. Words in declarations such as `TUPLE:` and `CONSTANT:` keep their names, because the grammar gives them no structure.
- **Numbers.** Each decimal or hexadecimal integer and each float is written as its value, so `1,000`, `1_000` and `1000` are the same, `0x1F` and `31` are the same, and `1.50` and `1.5` are the same.

## Spellings that share a representation

Factor's parser reads each of these pairs as the same program, so the representer gives them the same representation:

- Number spelling: `1,000` → `1000`, `1_000` → `1000`, `0x1F` → `31`, `1.50` → `1.5` and `1e3` → `1000.0`.

## Analysis

This service doesn't make Factor analyses yet, and Factor has no old analyzer to compare with.

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
The grammar doesn't know Factor's comments, so the snippet works on lines and finds the comments with Rouge's Factor lexer.
It removes every comment wherever it is, and keeps the first 15 lines of the main file, where snippet-extractor kept 10.
