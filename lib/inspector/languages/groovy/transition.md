# Groovy's transition

This file says how the Groovy outputs of this service differ from the tools they replace, and why.

## Representation

Groovy had no representer of its own, so the track used Basic, which drops comments, imports and formatting and keeps everything else as tokens.
Inspector parses each solution with tree-sitter instead.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. Inspector renames every name the solution defines, wherever it appears, including classes, interfaces, traits, enums, methods, fields, properties, local variables, parameters, closure parameters, type parameters, enum constants and labels.
- **Strings.** Basic kept each string as written. Inspector writes each string as its value, so `'a'`, `"a"`, `'''a'''`, `"""a"""` and `/a/` are the same, and so are `"\u0041"` and `"A"`. A slashy string reads only the escape of its own delimiter, so `/\d/` keeps its backslash. `"$a"` and `"${a}"` are the same interpolation, and so are `"$a.b"` and `"${a.b}"`.
- **Numbers.** Basic kept each number as written. Inspector writes each number as its value, so `1_000` and `1000` are the same, and so are `0x1F` and `31`. A `Long`, a `BigInteger`, a `Float` and a `Double` keep their suffix, so `1`, `1L`, `1G`, `1.0f` and `1.0d` stay apart. A decimal with no suffix is a `BigDecimal`, so `1.5G` and `1.5` are the same.
- **Layout.** Brackets that only group, trailing commas and semicolons make no difference.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with Groovy's version.

## Spellings that share a representation

Groovy's parser reads each of these pairs as the same program, so Inspector gives them the same representation:

- Quote style: `'you'` → `"you"`, `'''you'''` → `"you"`, `"""you"""` → `"you"`, and `/you/` → `"you"`.
- An escape and the character it stands for: `"\u0041"` → `"A"`, `"\101"` → `"A"`, `'it\'s'` → `"it's"`, and `/a\/b/` → `"a/b"`.
- Braces around an interpolation: `"a${b}"` → `"a$b"`, and `"a${b.c}"` → `"a$b.c"`.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `017` → `15`, `0b11` → `3`, `1.50` → `1.5`, `1e3` → `1000.0` and `1.5G` → `1.5`.
- The case of a number's suffix: `1.5F` → `1.5f`, `1D` → `1.0d`, `1l` → `1L` and `1g` → `1G`.
- `def` and `var`, which declare no type: `var x = 1` → `def x = 1`, `static def f()` → `static f()`, and `def f(def a)` → `def f(a)`.
- A call without brackets: `println "a"` → `println("a")`, and `a.b c, d` → `a.b(c, d)`.
- A closure after a call's brackets: `list.inject(0) { s, x -> s + x }` → `list.inject(0, { s, x -> s + x })`, and `list.each { it }` → `list.each({ it })`.
- A map key or named argument that is a name: `[a: 1]` → `['a': 1]`, and `f(a: 1)` → `f('a': 1)`.
- The two loops over a collection: `for (x : xs)` → `for (x in xs)`.
- The two ways to give an assertion a message: `assert a, "m"` → `assert a : "m"`.
- Brackets that only group: `(a * b) + c` → `a * b + c`.
- A trailing comma after the last item: `[1, 2,]` → `[1, 2]`.
- A `;` at the end of a statement: `def n = 1;` → `def n = 1`.

## Analysis

This service doesn't make Groovy analyses yet, and Groovy has no old analyzer to compare with.

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments and imports by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the package declaration and the imports at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
