# Suggestions for TypeScript

[`transition.md`](../../../lib/inspector/languages/typescript/transition.md) says how Inspector differs from the old TypeScript representer.
These are changes that could improve it.
None of them is made, because a change to TypeScript's own behaviour needs the maintainers to decide it.

## Imports

1. **Drop `require` and `import x = require(...)`.** The representation drops `import ... from` and `export { ... }`, but keeps `const fs = require("fs")`, because the grammar reads `require` as a keyword and a code pattern can't name it. No golden solution uses `require`.

## Names

2. **Rename destructured names.** `const { a } = obj` and `const { a: b } = obj` keep `a` and `b`, because a shorthand name is also a property's name. Renaming `b` in the second form would group solutions that only differ in that name.
3. **Rename a class expression's name.** `const A = class B {}` renames `A` and keeps `B`.

## Spellings that are apart today

4. **Read every escape.** Only the common escapes are read, so `"\q"` and `"q"` stay apart, although JavaScript gives them the same value.
