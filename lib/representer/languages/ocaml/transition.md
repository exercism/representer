# OCaml's transition

This file says how the OCaml outputs of this service differ from the tools they replace, and why.

## Representation

OCaml had no representer of its own, so the track used Basic, which writes a solution's tokens line by line and renames nothing.
The OCaml representer parses each solution with tree-sitter-ocaml instead, and writes the tree that the OCaml compiler's parser would give.
It makes the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. This representer renames every name the solution defines, wherever it appears: values, functions, operators, parameters and their labels, the variables in patterns and loops, types, constructors, exceptions, record fields, type variables, modules, module types, classes, methods and instance variables.
- **Layout.** Basic kept line breaks. This representer drops comments, layout, `;;`, the `|` before the first case of a match, trailing semicolons in lists and records, and brackets that only group, so `(a * b) / c` and `a * b / c` are the same, and so are `begin e end` and `(e)`.
- **Imports.** The `open` lines at the top of a module are dropped, as Basic dropped them. A local open stays, because it changes which names the code uses. OCaml's parser reads `let open M in e` as `M.(e)`, so those two are the same.
- **Punning.** OCaml's parser reads `~n` as `~n:n` and `{ name }` as `{ name = name }`, in patterns and in expressions, so each pair is the same.
- **Strings.** Basic kept each string as written. This representer writes each string as its value, with its `\n`, `\t`, `\r`, `\b`, `\\`, `\"`, `\'` and `\ ` escapes read, so `{|say "hi"|}` and `"say \"hi\""` are the same. Any other escape stays as it is written. A character keeps its text, so `'a'` and `"a"` stay apart.
- **Numbers.** Basic kept each number as written. This representer writes each number as its value, so `1_000` and `1000` are the same, and so are `0x1F` and `31`, and `1.` and `1.0`. An integer stays apart from a float, and a number with a type suffix such as `10L` keeps its text.
- **Files.** The representer reads `.ml` files, and ignores any `.mli` interface file.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with the OCaml representer's version.

The representation starts at version 6, one above Basic's version 5.

## Analysis

This service doesn't make OCaml analyses yet, and OCaml had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to work on lines, because the track had no grammar.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the opens at the top of the file, up to the first other statement.
Its version is now 2.
