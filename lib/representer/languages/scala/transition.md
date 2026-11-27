# Scala's transition

This file says how the Scala outputs of this service differ from the tools they replace, and why.

## Representation

Scala had no representer of its own, so the track used Basic, which drops comments, imports and formatting and keeps everything else as tokens.
The Scala representer parses each solution with tree-sitter instead.
It makes the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. This representer renames every name the solution defines, wherever it appears, including objects, classes, traits, enums and their cases, types, type parameters, methods, givens, values, variables, parameters and the variables bound by patterns. In a pattern, only a name that starts with a lower-case letter binds a variable, so `case Nil` keeps `Nil`. A name in backticks is the same name without them.
- **Layout.** Basic kept the line breaks and the indentation. This representer ignores layout, so a body in braces and the same body after Scala 3's `:` and indentation are the same, and so are `if (a) b` and `if a then b`, and `for (x <- xs)`, `for { x <- xs }` and `for x <- xs`. An indented block that holds one expression is that expression, as Scala's parser reads it.
- **Brackets.** Brackets that only group make no difference, so `(a && b) || c` and `a && b || c` are the same.
- **Strings.** Basic kept each string as written. This representer writes each string as its value, so `"""a"""` and `"a"` are the same, and so are `"\u0041"` and `"A"`. A string in triple quotes has no escapes, so `"""\n"""` keeps its backslash. In an interpolated string, `$a` and `${a}` are the same, and each escape keeps its text, because each interpolator reads escapes in its own way.
- **Numbers.** Basic kept each number as written. This representer writes each number as its value, so `1_000` and `1000` are the same, and so are `0x1F` and `31`. A `Long`, a `Float` and a `Double` with a suffix keep it, so `1`, `1L`, `1.0f` and `1.0d` stay apart.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with the Scala representer's version.

## Analysis

This service doesn't make Scala analyses yet, and Scala has no old analyzer to compare with.

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
While Scala used Basic, its snippet found the comments with Scala's lexer and skipped the package clause and imports by the text at the start of each line.
It now reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the package clause and the imports at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
