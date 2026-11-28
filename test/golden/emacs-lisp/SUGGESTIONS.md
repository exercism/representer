# Suggestions for Emacs Lisp

[`transition.md`](../../../lib/rosetta/languages/emacs_lisp/transition.md) says how Rosetta treats Emacs Lisp differently from Basic, which the track used before.
These are changes that could improve it.
None of them is made, because a change to Emacs Lisp's own behaviour needs the maintainers to decide it.
The counts come from the 190 golden solutions.

## Code that could be dropped

1. **Drop docstrings.** The string after a function's parameters, such as `"Say who the one is for."`, only documents the function, if more forms follow it. At least 34 golden solutions have one. A function whose only form is a string returns it, so that string would stay.
2. **Drop `(provide 'feature)`.** All 190 golden solutions end with it. It only records that the file has loaded, and the tests load the file with `load-file`. When the feature has the same name as a function, the engine renames its symbol, so `provide` rarely splits groups today.
3. **Drop the `require` inside `eval-when-compile`.** `(eval-when-compile (require 'cl-lib))` only loads a library while the file compiles. Today the engine drops a bare `require` and keeps this form. No golden solution has one.
4. **Keep the `lexical-binding` cookie.** `;;; -*- lexical-binding: t; -*-` is a comment, so the engine drops it, but it changes how closures and `let` behave. 133 golden solutions have it and 58 don't. Every solution passes its tests either way, so dropping it is probably right, but a human should confirm it.

## Spellings that are apart today

5. **Write `'nil` as `nil` and `'t` as `t`**, and the same for a quoted number, string or keyword, because each evaluates to itself. Two golden solutions quote `nil` or `t`.
6. **Write `#'(lambda ...)` as `(lambda ...)`.** Both make the same function. Nine golden solutions use `#'(lambda ...)`.
7. **Expand `when` and `unless`.** `(when a b c)` expands to `(if a (progn b c))`, and `(unless a b)` to `(if a nil b)`. 32 golden solutions use one of them. Rosetta expands the Clojure macros that solutions use in the same way.
8. **Write `cl-incf` and `cl-decf` as `setq`.** `(cl-incf x)` and `(setq x (1+ x))` do the same for a variable. Six golden solutions use them.
9. **Write the `cl-` aliases of list functions as the functions.** `cl-first`, `first` and `car` are the same function, and so are `cl-rest`, `rest` and `cdr`.
10. **Split a `setq` of several variables.** `(setq a 1 b 2)` and `(setq a 1) (setq b 2)` do the same, as long as the forms run in order.
11. **Decide whether a character and its number are the same.** The reader reads `?a` and `97` as the same integer. They stay apart today, because a mentor would comment on `97` and not on `?a`.

## Names

12. **Rename keywords that match a `&key` parameter.** `(cl-defun f (&key name) ...)` is called as `(f :name "x")`. The engine renames `name` and keeps `:name`.
13. **Rename the names that `pcase` patterns bind.** In `(pcase x (`(,a ,b) a))`, `a` and `b` are local variables. Four golden solutions use `pcase`.
14. **Rename the functions that `cl-defstruct` defines.** `(cl-defstruct point x)` defines `make-point`, `point-p` and `point-x`. The engine renames `point` and `x`, and keeps the derived names.
15. **Keep the names of Emacs's own variables when a solution binds them.** `(let ((case-fold-search nil)) ...)` changes how `string-match` behaves. The engine renames `case-fold-search` today, because the `let` binds it.
16. **Rename a global variable that only `setq` creates.** `(setq counter 0)` at the top level creates `counter`, but the engine keeps its name, because `setq` also sets variables that Emacs defines.

## Sorting

Emacs Lisp has no Reorder stage yet:

17. **Sort the top-level `defun` forms.** Their order makes no difference to a solution that passes its tests, because Emacs looks up each function when a call runs. `defvar` and `defconst` would keep their order, because a later form can use their values.
