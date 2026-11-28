# C#'s transition

This file says how the C# outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old C# representer (`exercism/csharp-representer`), which ran Roslyn's simplifier and then its own rewriters.
It matches what the old representer did, apart from the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and this difference:

- `this.` is dropped before every name, even when a parameter or local variable has the same name, as in `this.count = count`. Roslyn's simplifier kept it there. The engine renames by name, so the field and the parameter get the same placeholder anyway, and two solutions only merge if both pass their tests.

## Spellings that share a representation

C#'s parser reads each of these pairs as the same program, so Inspector gives them the same representation:

- A verbatim string and its escaped spelling: `@"a""b"` → `"a\"b"`, and `@"a\n"` → `"a\\n"`.
- An escape in a string and the character it stands for: `"\x41"` → `"A"`, and `"\u0041"` → `"A"`.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `0b11` → `3`, `1.50` → `1.5` and `1e3` → `1000.0`.
- The case of a `float` or `double` suffix: `1.5D` → `1.5d`, and `1E7F` → `10000000.0f`.
- Brackets that only group: `(a * b) + c` → `a * b + c`.
- Braces around the single statement of an `if` or `else`: `if (a > b) { return a; }` → `if (a > b) return a;`.
- A trailing comma after the last item: `new[] { 1, 2, }` → `new[] { 1, 2 }`, and `enum E { X, Y, }` → `enum E { X, Y }`.
- A `;` after a type's closing brace: `class A { };` → `class A { }`.

Inspector also gives the same representation to code that Roslyn reads differently but that works the same way: `this.` before a name (`this.count` → `count`), and the type's own name before one of its members (`Counter.Start()` → `Start()` inside `class Counter`).

## Analysis

This service doesn't make C# analyses yet, so there is nothing to compare with the old analyzer (`exercism/csharp-analyzer`).

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments and `using` lines by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the `using` directives at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
