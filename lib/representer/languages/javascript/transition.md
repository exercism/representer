# JavaScript's transition

This file says how the JavaScript outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old JavaScript representer (`exercism/javascript-representer`), which parsed the solution with typescript-estree, renamed its identifiers and printed it again as code.
It matches what the old representer did, apart from the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and these differences:

- Export lists (`export { a }`), `module.exports = { a }` and declarations that only `require` modules are dropped, with the imports. The `export` keyword is dropped too, so `export function f` and `function f` followed by `export { f }` get the same representation. The old representer kept all of them.
- Empty statements, such as the second `;` of `x = 1;;`, are dropped. The old representer printed each one. The empty parts of a `for`, as in `for (;; i++)`, stay.
- The escapes of a template string are read, so `` `a\nb` `` and `"a\nb"` get the same representation. The old representer printed a template's escapes as written, and a string's escapes as their values.
- Only the common escapes are read (`\n`, `\t`, `\r`, `\b`, `\f`, `\v`, `\0`, `\\`, the quotes, `\$`, `\xHH`, `\uHHHH`, `\u{H}` and a backslash at the end of a line). The old representer read every escape, so it merged `"\q"` and `"q"`, which stay apart here.

## Spellings that share a representation

JavaScript's parser reads each of these pairs as the same program, so the representer gives them the same representation:

- Quote style: `'you'` → `"you"`, and `` `you` `` → `"you"`.
- An escape and the character it stands for: `"\x41"` → `"A"`, `"\u0041"` → `"A"`, `"\u{41}"` → `"A"`, and `'it\'s'` → `"it's"`.
- A backslash at the end of a line inside a string: `"a\` followed by `b"` on the next line → `"ab"`.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `0o17` → `15`, `0b11` → `3`, `1.50` → `1.5`, `1.0` → `1` and `1e3` → `1000`.
- Brackets that only group: `(a * b) + c` → `a * b + c`.
- Brackets around an arrow function's single parameter: `(x) => x` → `x => x`.
- A trailing comma after the last item: `[1, 2,]` → `[1, 2]`, `{ a: 1, }` → `{ a: 1 }`, `f(a, b,)` → `f(a, b)`, and `function f(a, b,) {}` → `function f(a, b) {}`.
- A `;` at the end of a statement: `const n = 1` → `const n = 1;`, and `const n = 1;;` → `const n = 1;`.

## Analysis

This service doesn't make JavaScript analyses yet, so there is nothing to compare with the old analyzer (`exercism/javascript-analyzer`).

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments and `import` lines by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the imports at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
