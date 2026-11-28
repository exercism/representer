# Idris's transition

This file says how the Idris outputs of this service differ from the tools they replace, and why.

## Representation

Idris had no representer of its own, so the track used Basic. Basic splits the code into tokens, drops the comments and the `import` lines, and keeps everything else as it is written, including the line breaks, the indentation and the names.
Idris now has a representation of its own, which reads the solution's syntax tree with tree-sitter-idris and follows the decisions that apply to every language ([docs/how-it-works.md](../../../../docs/how-it-works.md) describes them).
These things change for Idris:

- **Names.** Basic renamed nothing. Inspector renames every name the solution defines: its module, namespaces, functions, values, parameters, the variables in patterns, `let` and `do` bindings, data types and their constructors, records with their constructors and fields, interfaces, the named arguments of a type such as `(n : Nat)`, and type variables. A lower case name in a type is a type variable unless it is applied to arguments, because Idris binds such a name as an implicit argument. A name the solution doesn't define, such as `map`, `Nothing` or `Show`, keeps its name. If a solution implements an interface from the library, such as `Show`, the names of the methods it defines, such as `show`, are renamed everywhere.
- **Layout.** Basic kept the line breaks and the indentation. Inspector ignores all layout, so explicit braces and semicolons are the same as indentation.
- **Comments.** As before, comments go, including `|||` documentation.
- **Imports.** As before, `import` declarations go.
- **Brackets.** Brackets that only group make no difference, so `f x = (g x)`, `if (a == b) then ...` and `[(f x), y]` are the same as the code without them. Brackets in the middle of an expression stay, as in `(a - b) - c`, because the grammar doesn't know the operators' precedence. The brackets of an operator section such as `(+ 1)`, and of a function's argument patterns such as `f (Just x)`, also stay.
- **Numbers.** Basic kept each number as written. Inspector writes each number as its value, so `0x1F` and `31` are the same, and so are `1_000` and `1000`, and `1.0e3` and `1000.0`. `1` and `1.0` stay apart, because Idris reads `1.0` as a Double.
- **Strings.** Basic kept each string as written. Inspector writes each string as its value, with its `\n`, `\t`, `\\` and `\"` escapes read. Any other escape stays as it is written. A character keeps its quotes, so `'a'` and `"a"` stay apart.
- **Idris's own equivalences.** Idris reads `Show A where` the same as `implementation Show A where`, and `\ case` the same as `\case`, so each pair gets the same representation.
- **Errors.** A solution with a syntax error still gets Basic's representation, with Idris's version.

The representation's version is 6, one above Basic's version 5, so the website will represent every Idris solution again.

## Spellings that share a representation

Idris's parser reads each of these pairs as the same program, so Inspector gives them the same representation:

- Unicode arrows: `←` → `<-`, and `⇒` → `=>`.
- Braces and semicolons in place of layout: `case x of { Z => 0; _ => 1 }` → the two cases on separate lines.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `1.50` → `1.5` and `1.0e3` → `1000.0`.
- Brackets that only group, when they sit outside any operator expression: `f x = (g x)` → `f x = g x`, `if (a == b) then ...` → `if a == b then ...`, and `[(f 1), 2]` → `[f 1, 2]`.
- The `implementation` keyword: `Show A where` → `implementation Show A where`.
- A space in `\case`: `\ case` → `\case`.

## Analysis

This service doesn't make Idris analyses yet, and Idris had no analyzer before.

## Snippet

The snippet used to come from Basic.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the module header, the imports and the `%default` pragma at the top of the file, up to the first other statement.
The snippet's version is now 2.
