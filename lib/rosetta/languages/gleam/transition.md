# Gleam's transition

This file says how the Gleam outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old Gleam representer (`exercism/gleam-representer`), which was Exercism's template representer.
It joined the solution's files, removed blank lines and trailing whitespace, and kept every name as it was written.
This service applies the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and these rules of its own:

- **Syntax errors.** A solution with a syntax error gets Basic's representation, which only drops comments and formatting. The old representer worked on text, so it represented any file.
- **Comments and layout.** Comments (`//`, `///` and `////`), brackets, commas and the keywords that sit in a fixed place are left out, because the tree already shows them.
- **Imports.** Every `import` is dropped. A name given with `as` in an import becomes the name it stands for, so after `import gleam/list as l`, `l.length` is `list.length`.
- **Names.** The names of functions, constants, types, constructors and fields are renamed, along with parameters and the variables bound by `let`, `let assert`, `use` and the patterns of a `case`. The labels of a function's parameters and the type variables, such as the `a` in `List(a)`, keep their names.
- **Labelled arguments.** `f(age:)` is written as `f(age: age)`, and `Circle(radius:)` in a pattern as `Circle(radius: radius)`, because Gleam reads them the same way.
- **Numbers and strings.** Each number is written as its value, so `1_000`, `0x3E8` and `1000` are the same, and `1.50` and `1.5` are the same. Each string is written as its value, so `"\u{41}"` and `"A"` are the same.

## Spellings that share a representation

Gleam's parser reads each of these pairs as the same program, so Rosetta gives them the same representation:

- An escape and the character it stands for: `"\u{41}"` → `"A"`, and `"a\nb"` → the string with a real line break.
- Number spelling: `1_000` → `1000`, `0x3E8` → `1000`, `0b11` → `3`, `0o10` → `8`, `1.50` → `1.5` and `1.0e3` → `1000.0`.
- A trailing comma after the last item: `[1, 2,]` → `[1, 2]`, and `g(a, b,)` → `g(a, b)`.
- A labelled argument without a value: `g(age:)` → `g(age: age)`.

## Analysis

This service doesn't make Gleam analyses yet, so there is nothing to compare with an old analyzer.

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments and `import` lines by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the imports at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
