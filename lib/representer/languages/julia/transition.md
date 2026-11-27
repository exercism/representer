# Julia's transition

This file says how the Julia outputs of this service differ from the tools they replace, and why.

## Representation

Julia had no representer of its own, so the track used Basic, which drops comments, imports and formatting and keeps everything else as tokens.
The Julia representer parses each solution with tree-sitter instead.
It makes the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. This representer renames every name the solution defines, wherever it appears, including functions, macros, modules, structs and their fields, abstract and primitive types, type parameters, parameters, keyword parameters and variables. A function that the solution adds a method to after `import Base: show` counts as defined by the solution, so `show` is renamed there. `Base.show(io, x) = ...` keeps its name.
- **Imports.** `using`, `import` and `include("file.jl")` are dropped. Basic dropped only the lines that start with `using` or `import`.
- **Strings.** Basic kept each string as written. This representer writes each string as its value, so `"""a"""` and `"a"` are the same, and so are `"é"` and `"é"`. `"$a"` and `"$(a)"` are the same interpolation. A triple-quoted string that spans lines keeps its text as written, because Julia removes its indentation. Prefixed strings, such as `r"a"` and `raw"a"`, keep their text.
- **Characters.** A character is written as its value too, so `'\u41'` and `'A'` are the same. A character stays apart from a string with the same text.
- **Numbers.** Basic kept each number as written. This representer writes each decimal integer and each `Float64` as its value, so `1_000` and `1000` are the same, and so are `1e3` and `1000.0`. Hexadecimal, octal and binary integers and `Float32`s keep their text, because their spelling sets their type.
- **Loops.** `for i in xs`, `for i = xs` and `for i ∈ xs` are the same, as they are to Julia's parser.
- **Multiplication.** `2x` and `2 * x` are the same, as they are to Julia's parser.
- **Layout.** Brackets that only group, trailing commas and semicolons between statements make no difference. The `;` before keyword arguments and the `;` in a matrix stay.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with the Julia representer's version.

## Analysis

This service doesn't make Julia analyses yet, and Julia has no old analyzer to compare with.

## Snippet

Julia has no snippet of its own yet, so it keeps Basic's, which removes the comments found by the track's Rouge lexer.
