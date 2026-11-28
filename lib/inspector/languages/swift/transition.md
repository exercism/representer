# Swift's transition

This file says how the Swift outputs of this service differ from the tools they replace, and why.

## Representation

Swift had no representer of its own, so the track used Basic, which drops comments, imports and formatting and keeps everything else as tokens.
Inspector parses each solution with tree-sitter instead.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. Inspector renames every name the solution defines, wherever it appears, including types, protocols, type aliases, generic parameters, functions, properties, enum cases, parameters and their argument labels, tuple labels, closure parameters, the variables bound by patterns and conditions, and statement labels. A name in backticks is the same name without them.
- **Strings.** Basic kept each string as written. Inspector writes each string as its value, so `#"a"#` and `"a"` are the same, and so are `"\u{41}"` and `"A"`. A multi-line string is the same as the single-line string with the same value. `#"a\#(x)"#` and `"a\(x)"` are the same interpolation.
- **Numbers.** Basic kept each number as written. Inspector writes each number as its value, so `1_000` and `1000` are the same, and so are `0x1F` and `31`. An integer stays apart from a decimal, so `1` and `1.0` stay apart.
- **Layout.** Brackets that only group, the brackets around a closure's parameters, trailing commas and semicolons make no difference.
- **Products.** The grammar reads a product written without spaces, such as `a*b`, as one name. Inspector reads it as a product wherever nothing next to it binds more tightly than `*`, so `a*b + 1` and `a * b + 1` are the same.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with Swift's version.

## Spellings that share a representation

Swift's parser reads each of these pairs as the same program, so Inspector gives them the same representation:

- A raw string and its plain spelling: `#"a"#` → `"a"`, and `#"a\n"#` → `"a\\n"`.
- A multi-line string and its one-line spelling: `"""` with the line `a` between the quotes → `"a"`.
- An escape in a string and the character it stands for: `"\u{41}"` → `"A"`, and `"a\tb"` → the string with a real tab.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `0o10` → `8`, `0b11` → `3`, `1.50` → `1.5` and `1e3` → `1000.0`.
- Brackets that only group: `(a * b) + c` → `a * b + c`, `if (x > 1)` → `if x > 1`, and `"a\((n))"` → `"a\(n)"`.
- Spaces around `*`: `a*b` → `a * b`.
- A trailing comma after the last item: `[1, 2,]` → `[1, 2]`, and `["a": 1,]` → `["a": 1]`.
- A `;` after a statement: `return a;` → `return a`.
- Backticks around a name: `` `count` `` → `count`.

## Analysis

This service doesn't make Swift analyses yet, and Swift has no old analyzer to compare with.

## Snippet

The snippet used to work on lines, because the track had no grammar.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the imports at the top of the file, up to the first other statement.
Its version is now 2.
