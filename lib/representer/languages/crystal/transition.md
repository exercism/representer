# Crystal's transition

This file says how the Crystal outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old Crystal representer (`exercism/crystal-representer`), which parsed the solution with the Crystal compiler, renamed the names the solution defines, sorted the methods, and printed the tree back as Crystal code.
It differs from the old representer in the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and in these ways:

- **Imports.** The old representer kept each `require`. This one drops them.
- **Spellings.** The old representer printed the code in the compiler's own layout. This one writes each string as its value, keeping its interpolations, and each number as its value, so `1_000` and `1000` are the same, and so are `0x1F` and `31`. It drops a number's type suffix if it names the type the number has anyway, so `1_i32` is `1` and `2.0_f64` is `2.0`. It also drops brackets that only group, and the empty brackets of a call, so `f()` is `f`.
- **Accessors.** `getter :count` and `getter count` are the same here, and so are the `setter` and `property` forms. The old representer kept the symbol, so the two stayed apart.
- **Order.** Both representers sort the methods inside each class, module and struct, and at the top of the file, and put them in the places where methods were. The old representer sorted them by their names before renaming them, so two solutions that named their methods differently could get different orders. This one sorts them by their code, with the renamed names left out.
- **Names.** Both representers rename the names the solution defines, wherever they appear, and give `@count`, `@@count` and `count` the same placeholder. This one also renames the members of an enum, the type variables of a generic type (`T` in `class Box(T)`) and the type variables of `forall`, which the old representer kept.

## Analysis

This service doesn't make Crystal analyses yet, so there is nothing to compare with the old analyzer (`exercism/crystal-analyzer`).

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments and `require` lines by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the `require` statements at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
