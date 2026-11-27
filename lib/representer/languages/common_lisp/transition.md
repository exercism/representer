# Common Lisp's transition

This file says how the Common Lisp outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old Common Lisp representer (`exercism/common-lisp-representer`), which read the solution with SBCL's reader, replaced the package name, the exported names, the names of `defun` functions and their lambda-list variables with generated keywords, and printed the forms.
It differs from the old representer in the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and in these ways:

- Every name the solution defines is renamed, wherever it is defined: functions, macros, methods, global variables, structures and their slots, classes with their slots and accessors, local bindings (`let`, `flet`, `labels`, `dolist`, `multiple-value-bind` and the others), loop variables and condition handlers' variables. The old representer only renamed the package, its exports, and the names and lambda-list variables of `defun`.
- A keyword is renamed if the solution defines a name with the same text, so `:twofer` in `(:export :twofer)` and `(defun twofer ...)` get one placeholder.
- Docstrings are dropped. The old representer recorded whether a `defun` had one.
- `(quote x)` and `'x` are the same, and so are `(function x)` and `#'x`, because the reader reads them as the same forms. `'nil`, `'()`, `()` and `NIL` are all `nil`. `#'(lambda ...)` and `(lambda ...)` are the same. The old representer read `'x` as `(quote x)` too, and kept the others apart.
- `cl:car` is `car`, `:common-lisp` is `:cl`, and `#:name` is `:name`.
- Numbers are their values, so `#x1F` and `31` are the same, and so are `2/4` and `1/2`. A float with an exponent marker other than `e`, such as `1.0d0`, keeps its text.
- `require`, `export`, `import` and `use-package` forms are dropped, and so are the `:use`, `:export` and `:import-from` options of `defpackage`. The old representer kept them, and renamed the names in `:use` and `:export`.
- A loop's `for` and `with` clauses keep only their variable, so two loops that differ only in their bounds, as in `for i from 0 below n` and `for i from 1 to n`, get the same representation. The old representer kept the whole clause.
- The options left in a `defpackage` are sorted by their code. The old representer sorted them by their keyword.
- A solution with a syntax error, such as a missing bracket, gets Basic's representation, which only drops comments and formatting. The old representer gave SBCL's reader error as the representation.
- `#.` forms are represented like any other code. The old representer refused them, because SBCL's reader would run them.

## Analysis

This service doesn't make Common Lisp analyses yet, so there is nothing to compare with the old analyzer (`exercism/common-lisp-analyzer`).

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the `defpackage` and `in-package` forms at the top of the file, up to the first other form.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
