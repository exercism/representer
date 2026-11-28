# CoffeeScript's transition

This file says how the CoffeeScript outputs of this service differ from the tools they replace, and why.

## Representation

CoffeeScript had no representer of its own, so the track used Basic, which drops comments and formatting and keeps everything else as tokens, with each line's indentation.
Rosetta parses each solution with tree-sitter instead.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. Rosetta renames every name the solution defines, wherever it appears, including classes, class members (apart from `constructor`), properties set on `this` or on a prototype, variables, parameters, loop variables, the names in destructuring patterns and `catch` variables.
- **Imports.** Basic kept every line. Rosetta drops each assignment that only loads a module, such as `Leap = require './leap'`.
- **Strings.** Basic kept each string as written. Rosetta writes each string on one line as its value, so `'a'`, `"a"`, `'''a'''` and `"""a"""` are the same, and so are `"A"` and `"A"`. A string that spans several lines keeps its text as written.
- **Numbers.** Basic kept each number as written. Rosetta writes each number as its value, so `1_000` and `1000` are the same, and so are `0x1F` and `31`.
- **Layout.** Line breaks, indentation, brackets that only group, trailing commas and semicolons make no difference.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with CoffeeScript's version.

## Spellings that share a representation

CoffeeScript's parser reads each of these pairs as the same program, so Rosetta gives them the same representation:

- Quote style: `'you'` → `"you"`, `'''you'''` → `"you"`, and `"""you"""` → `"you"`.
- An escape and the character it stands for: `"\x41"` → `"A"`, `"A"` → `"A"`, `"\u{41}"` → `"A"`, and `'it\'s'` → `"it's"`.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `0o17` → `15`, `0b11` → `3`, `.5` → `0.5`, `1.0` → `1` and `1e3` → `1000`.
- Brackets that only group: `(a * b) + c` → `a * b + c`, and `(x for x in xs)` → `x for x in xs`.
- The operator words: `a and b` → `a && b`, `a or b` → `a || b`, `a is b` → `a == b`, `a isnt b` → `a != b`, and `not a` → `!a`.
- The boolean words: `yes` and `on` → `true`, and `no` and `off` → `false`.
- `@` for `this`: `@` → `this`, and `@count` → `this.count`.
- `::` for `.prototype.`: `Array::sum` → `Array.prototype.sum`.
- A call without brackets: `f x, y` → `f(x, y)`, and `new Error 'm'` → `new Error('m')`.
- An object without braces: `f a: 1, b: 2` → `f({a: 1, b: 2})`, and lines of `key: value` in a row → one object.
- A body on the same line: `if a then b` → `if a` with `b` on the next line, `(x) -> x * 2` → `(x) ->` with `x * 2` on the next line, and `else if` → `else` with `if` on the next line.
- A value on the line after its `=` or `:`: `x =` with `1` on the next line → `x = 1`.
- A condition or loop after its statement: `x if a` → `if a then x`, `x while a` → `while a then x`, and `f(x) for x in xs` → `for x in xs then f(x)`. `unless` and `until` stay apart from `if` and `while`.
- The `...` of a splat before or after it: `f(...a)` → `f(a...)`, and `(...rest) ->` → `(rest...) ->`.
- A trailing comma after the last item: `[1, 2,]` → `[1, 2]`.
- A `;` between statements: `a = 1; b = 2` → `a = 1` and `b = 2` on two lines.

## Analysis

This service doesn't make CoffeeScript analyses yet, and CoffeeScript has no old analyzer to compare with.

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, including `###` block comments.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
