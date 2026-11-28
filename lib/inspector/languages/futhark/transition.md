# Futhark's transition

This file says how the Futhark outputs of this service differ from the tools they replace, and why.

## Representation

Futhark had no representer of its own, so the track used Basic, which writes a solution's tokens line by line and renames nothing.
Inspector parses each solution with tree-sitter-futhark instead, and writes the tree that the Futhark compiler's parser would give.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. Inspector renames every name the solution defines, wherever it appears: values, functions, operators, parameters, the variables in patterns and loops, types, their constructors, record fields, type parameters and sizes, modules, module parameters and module types. The names that the solution doesn't define keep their names, such as `i32.sum` and `map`.
- **Layout.** Basic kept line breaks. Inspector drops comments, layout, trailing commas, the `in` between two `let`s, and brackets that only group, so `(a * b) + c` and `a * b + c` are the same.
- **Definitions.** Futhark's parser reads a top-level `let` as `def`, so the two are the same. `entry` and `local` stay.
- **Imports.** Every `import` and `open` is dropped.
- **Strings.** Basic kept each string as written. Inspector writes each string as its value, with its `\n` escapes read. Any other escape stays as it is written. A character keeps its text, so `'a'` and `"a"` stay apart.
- **Numbers.** Basic kept each number as written. Inspector writes each number as its value, so `1_000` and `1000` are the same, and so are `0x1F` and `31`, `0b101` and `5`, `1.50` and `1.5`, and `1e3` and `1000.0`. A type suffix stays with its value, so `0x80u32` and `128u32` are the same, and `1i32`, `1i64` and `1` stay apart. An integer stays apart from a float.
- **Files.** Inspector reads `.fut` files.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with Futhark's version.

The representation starts at version 6, one above Basic's version 5.

## Spellings that share a representation

Futhark's parser reads each of these pairs as the same program, so Inspector gives them the same representation:

- A top-level `let` and `def`: `let f x = x` → `def f x = x`.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `0b101` → `5`, `1.50` → `1.5`, `1e3` → `1000.0`, `0x80u32` → `128u32`, `1.50f32` → `1.5f32` and `1f64` → `1.0f64`.
- Brackets that only group: `(a * b) + c` → `a * b + c`, `(g a) b` → `g a b`, `def f (x) = x` → `def f x = x` and `([]i32)` → `[]i32`.
- An `in` between two `let`s: `let a = 1 in let b = 2 in b` → `let a = 1 let b = 2 in b`.
- A comma after the last item: `[1, 2,]` → `[1, 2]`, and `{a = 1,}` → `{a = 1}`.
- An escape and the character it stands for: `"a\nb"` → the string with a real line break.

## Analysis

This service doesn't make Futhark analyses yet, and Futhark had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to apply its rules to lines, because the track had no grammar.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the imports and opens at the top of the file, up to the first other declaration.
If a file doesn't parse, the snippet still finds the comments by the way they start (`--`).
The snippet's version is now 2.
