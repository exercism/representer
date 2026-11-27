# GDScript's transition

This file says how the GDScript outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old GDScript representer (`exercism/gdscript-representer`), which parsed the solution with gdtoolkit, dropped docstrings, every statement that is only a string, and type hints, and renamed functions and the variables and parameters inside functions.
It matches what the old representer did, apart from the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and these differences:

- **Names.** The old representer left script-level variables, constants, classes, `class_name`, enums, enum values and signals as they were written. This one renames them too, because the engine renames every name the solution defines. Names bound by a `var` in a `match` pattern keep their names, as in the old representer.
- **Numbers.** The old representer kept each number as it was written. This one writes each number as its value, so `1_000` and `1000`, `0x1F` and `31`, and `1.50` and `1.5` are the same.
- **Strings.** `'a'` and `"a"` are the same string, and an escaped quote is the quote itself, so `'it\'s'` and `"it's"` are the same. Every other escape is kept as it is written.
- **Operators.** `&&`, `||` and `!` are the same as `and`, `or` and `not`, because GDScript reads them the same.
- **Region markers and line continuations.** `#region` and `#endregion` lines and a backslash at the end of a line are dropped, as layout.

## Analysis

This service doesn't make GDScript analyses yet, so there is nothing to compare with an old analyzer.

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment, region marker and docstring wherever they are.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
