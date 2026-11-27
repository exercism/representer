# Swift's transition

This file says how the Swift outputs of this service differ from the tools they replace, and why.

## Representation

Swift had no representer of its own, so the track used Basic, which drops comments, imports and formatting and keeps everything else as tokens.
The Swift representer parses each solution with tree-sitter instead.
It makes the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. This representer renames every name the solution defines, wherever it appears, including types, protocols, type aliases, generic parameters, functions, properties, enum cases, parameters and their argument labels, tuple labels, closure parameters, the variables bound by patterns and conditions, and statement labels. A name in backticks is the same name without them.
- **Strings.** Basic kept each string as written. This representer writes each string as its value, so `#"a"#` and `"a"` are the same, and so are `"\u{41}"` and `"A"`. A multi-line string is the same as the single-line string with the same value. `#"a\#(x)"#` and `"a\(x)"` are the same interpolation.
- **Numbers.** Basic kept each number as written. This representer writes each number as its value, so `1_000` and `1000` are the same, and so are `0x1F` and `31`. An integer stays apart from a decimal, so `1` and `1.0` stay apart.
- **Layout.** Brackets that only group, the brackets around a closure's parameters, trailing commas and semicolons make no difference.
- **Products.** The grammar reads a product written without spaces, such as `a*b`, as one name. This representer reads it as a product wherever nothing next to it binds more tightly than `*`, so `a*b + 1` and `a * b + 1` are the same.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with the Swift representer's version.

## Analysis

This service doesn't make Swift analyses yet, and Swift has no old analyzer to compare with.

## Snippet

The snippet used to work on lines, because the track had no grammar.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the imports at the top of the file, up to the first other statement.
Its version is now 2.
