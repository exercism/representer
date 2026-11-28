# Cairo's transition

This file says how the Cairo outputs of this service differ from the tools they replace, and why.

## Representation

Cairo never had a representer of its own (there is no `exercism/cairo-representer`), so there is nothing to compare with.
The representation follows the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes.

## Spellings that share a representation

Cairo's parser reads each of these pairs as the same program, so the representer gives them the same representation:

- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `0o17` → `15` and `0b101` → `5`, with or without a type suffix, as in `0x1F_u8` → `31_u8`.
- Brackets that only group: `(a * b) + 1` → `a * b + 1`, and `if (a > 1)` → `if a > 1`.
- A trailing comma after the last item: `fn f(a: u32, b: u32,)` → `fn f(a: u32, b: u32)`, and `g(1, 2,)` → `g(1, 2)`.
- An empty statement: `let a = 1;;` → `let a = 1;`.
- A shorthand field and the field written in full: `P { x }` → `P { x: x }`, and `let P { x } = p;` → `let P { x: x } = p;`.

## Analysis

This service doesn't make Cairo analyses yet, and Cairo has no old analyzer to compare with.

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments and `use` lines by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the `use` declarations at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
