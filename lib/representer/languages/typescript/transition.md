# TypeScript's transition

This file says how the TypeScript outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old TypeScript representer (`exercism/typescript-representer`), which parsed the solution with typescript-estree and printed the tree as JSON, with every identifier renamed.
It matches what the old representer did, apart from the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and these differences:

- A string is its value, so `'a'`, `"a"` and `` `a` `` are the same, and so are `"\x41"` and `"A"`. The old representer printed each string's source text too, so it kept them apart.
- A number is its value, so `1_000`, `1000.0`, `1e3` and `0x3E8` are the same. JavaScript has one number type, so they are the same number. The old representer printed each number's source text too.
- An empty statement (a stray `;`) is dropped, apart from the empty parts of a `for`, as in `for (;; i++)`. The old representer kept it.
- A private name such as `#count` is renamed, because the solution defines it. The old representer kept it.
- `module.exports = { a }` and declarations that only `require` modules are dropped, with the imports. The old representer kept them.

## Spellings that share a representation

TypeScript's parser reads each of these pairs as the same program, so the representer gives them the same representation:

- Quote style: `'you'` → `"you"`, and `` `you` `` → `"you"`.
- An escape in a string and the character it stands for: `"\x41"` → `"A"`, `"\u{41}"` → `"A"`, `'it\'s'` → `"it's"`, and `"a\nb"` → a template with a real line break.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `0o10` → `8`, `0b11` → `3`, `1.50` → `1.5`, `1e3` → `1000` and `1.0` → `1`.
- Brackets that only group: `(a * b) + c` → `a * b + c`.
- Brackets around an arrow function's single untyped parameter: `(x) => x + 1` → `x => x + 1`.
- A trailing comma after the last item: `[1, 2,]` → `[1, 2]`, `g(a, b,)` → `g(a, b)`, `{ a: 1, }` → `{ a: 1 }`, and `f(a: number,)` → `f(a: number)`.
- A `;` after a statement, and an empty statement: `return 1;` → `return 1`, and `let a = 1;;` → `let a = 1;`.
- The separator between an interface's members: `{ a: number; b: string; }` → `{ a: number, b: string }`.

## Analysis

This service doesn't make TypeScript analyses yet, so there is nothing to compare with the old analyzer (`exercism/typescript-analyzer`).

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments and `import` lines by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the imports at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
