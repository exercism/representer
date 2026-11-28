# F#'s transition

This file says how the F# outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old F# representer (`exercism/fsharp-representer`).
It matches what the old representer did, apart from the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes.

## Spellings that share a representation

F#'s parser reads each of these pairs as the same program, so Rosetta gives them the same representation:

- Quote style: `@"a""b"` → `"a\"b"`, and `"""a"b"""` → `"a\"b"`.
- An escape and the character it stands for: `"\x41"` → `"A"`, and `"\u0042"` → `"B"`.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `0b11` → `3`, `010` → `10` and `1.50` → `1.5`.
- Brackets that only group: `(a * b) + c` → `a * b + c`.
- Brackets around a tuple: `(1, 2)` → `1, 2`.
- Brackets around a single argument: `g(x)` → `g x`.
- `else if` and `elif`: `if a then 1 else if b then 2 else 3` → `if a then 1 elif b then 2 else 3`.
- A `|` before the first case: `type Shape = | Circle | Square` → `type Shape = Circle | Square`, and the same before the first case of a `match`.
- Separators in a list: `[1; 2; 3]` → the items on separate lines, and `[1; 2; 3;]` → `[1; 2; 3]`.

## Analysis

This service doesn't make F# analyses yet, so there is nothing to compare with the old F# analyzer.

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor skipped `open` lines and comments, found by the text at the start of each line.
This service reads the solution's syntax tree instead.
It also skips the `module` and `namespace` declarations at the top of the file, and shows the code inside them.
It removes every comment wherever it is, including XML documentation, and keeps the first 15 lines of the main file, where snippet-extractor kept 10.
