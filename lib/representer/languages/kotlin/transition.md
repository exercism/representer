# Kotlin's transition

This file says how the Kotlin outputs of this service differ from the tools they replace, and why.

## Representation

Kotlin had no representer of its own, so the track used Basic, which drops comments, imports and formatting and keeps everything else as tokens.
The Kotlin representer parses each solution with tree-sitter instead.
It makes the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. This representer renames every name the solution defines, wherever it appears, including classes, objects, functions, properties, parameters, type parameters, enum entries and labels. A name in backticks is the same name without them.
- **Strings.** Basic kept each string as written. This representer writes each string as its value, so `"""a"""` and `"a"` are the same, and so are `"\u0041"` and `"A"`. A raw string has no escapes, so `"""\n"""` keeps its backslash. `"$a"` and `"${a}"` are the same interpolation.
- **Characters.** A character is written as its value too, so `'\u0041'` and `'A'` are the same. A character stays apart from a string with the same text.
- **Numbers.** Basic kept each number as written. This representer writes each number as its value, so `1_000` and `1000` are the same, and so are `0x1F` and `31`. A `Long`, an unsigned integer and a `Float` keep their suffix, so `1`, `1L`, `1u` and `1.0f` stay apart.
- **Layout.** Brackets that only group, trailing commas and semicolons make no difference.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with the Kotlin representer's version.

## Spellings that share a representation

Kotlin's parser reads each of these pairs as the same program, so the representer gives them the same representation:

- Quote style: `"""you"""` → `"you"`.
- An escape and the character it stands for: `"\u0041"` → `"A"`, and `'\u0041'` → `'A'`.
- Braces around a name in a string: `"a${b}"` → `"a$b"`.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `0b101` → `5`, `1.50` → `1.5` and `1e3` → `1000.0`.
- The case of a number's suffix: `1.5F` → `1.5f`, `1U` → `1u` and `1UL` → `1uL`.
- Number spelling with a suffix: `1_000L` → `1000L`, and `0x10L` → `16L`.
- Backticks around a name: `` `n` `` → `n`.
- Brackets that only group: `(a * b) + c` → `a * b + c`, and `(Int)` → `Int` in a type.
- A trailing comma after the last item: `listOf(1, 2,)` → `listOf(1, 2)`.
- A `;` at the end of a statement: `val n = 1;` → `val n = 1`.

## Analysis

This service doesn't make Kotlin analyses yet, and Kotlin has no old analyzer to compare with.

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments, the package header and imports by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the file annotations, the package header and the imports at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
