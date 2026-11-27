# Nim's transition

This file says how the Nim outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old Nim representer (`exercism/nim-representer`), which read the solution with Nim's own macros, renamed the names the solution defines, and printed the tree back as Nim code.
Nim's parser already writes operators and commands as calls, drops brackets that only group, and reads `fmt"..."` and `&"..."` the same way, and this one does too.
It differs from the old representer in the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and in these ways:

- **Imports.** The old representer kept each `import` and `from` statement, with the modules sorted. This one drops them, and drops `include` and `export` statements too.
- **Names.** The old representer renamed the names of routines, their parameters and the variables of `let`, `var` and `const`. It left type sections as written. This one also renames the types, fields and enum values that the solution defines, the variables of `for`, the names in a tuple such as `let (a, b) = pair`, and generic parameters such as the `T` in `proc f[T]`.
- **Spellings of names.** Both representers treat `helloWorld`, `hello_world` and `helloworld` as one name, as Nim does. The old representer wrote a name that it didn't rename as the student spelt it, so `toUpper` and `to_upper` stayed apart. This one writes every name in one spelling: its first letter as written, and the rest in lower case without underscores. The mapping gives each name in that spelling too, where the old mapping gave the student's first spelling.
- **Parameters.** This one writes `proc f(a, b: int)` as `proc f(a: int; b: int)`. The old representer read only the first name of a group of parameters that share a type.
- **Strings.** The old representer printed each string as its value, so `"\x41"` and `"A"` were the same. This one keeps each escape as it is written, so the two stay apart.

## Analysis

This service doesn't make Nim analyses yet, so there is nothing to compare with an old analyzer.

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments and import lines by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the `import`, `from`, `include` and `export` statements at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
