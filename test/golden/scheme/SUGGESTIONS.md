# Suggestions for Scheme

These are improvements to Scheme's representation for the maintainers to discuss.
None of them is in Rosetta yet.

- **Two ways to define a function.** `(define (f x) (* x 2))` and `(define f (lambda (x) (* x 2)))` stay apart. The reader gives them different lists, but every Scheme expands the first into the second. Writing the first as the second would make them the same. A mentor might still prefer one of them.
- **`else` and `#t` in `cond`.** `(cond ((null? xs) 0) (else 1))` and `(cond ((null? xs) 0) (#t 1))` stay apart. A last clause of `#t` always runs, as `else` does, so writing it as `else` would make them the same.
- **`if` and `when` or `unless`.** `(when (> n 0) (display n))` stays apart from `(if (> n 0) (begin (display n)))`, and `(unless a b)` from `(if (not a) b)`. Guile and Chez expand them into the `if` forms, but a mentor might comment on the choice.
- **Nested and starred `let`.** `(let* ((a 1)) a)` and `(let ((a 1)) a)` stay apart, and so does a `let*` from the nested `let` forms that it expands to. With one binding they do the same thing.
- **Prefixes of imported names.** `(use-modules ((srfi srfi-1) #:prefix s1:))` lets a solution call `s1:fold`. Rosetta drops the import, but `s1:fold` stays apart from `fold`. Dropping the prefix from the calls would make them the same.
- **The accessors that an R6RS record makes.** `(define-record-type point (fields x y))` makes `make-point`, `point?`, `point-x` and `point-y`. Rosetta renames `point`, `x` and `y`, and keeps the names that the record makes, so the same record with another name stays apart. Renaming the made names too would make them the same.
- **The variables of `match`.** Guile's `(match xs ((a . rest) a))` binds `a` and `rest`, and Rosetta keeps their names. Renaming the variables in each pattern would group solutions that only differ in them.
- **Guile's `1+` and `1-`.** `(1+ n)` and `(+ n 1)` stay apart. They give the same number, but `1+` only exists in Guile and a mentor might comment on it.
- **The order of top-level definitions.** Two solutions that define the same functions in another order stay apart. The order of the definitions at the top of a file makes no difference to a passing solution, so sorting them would make them the same. The top of a file can also hold statements that run in order, such as a `display`, so a sort would have to leave those in place.
- **Other escapes.** Rosetta reads `\n`, `\\` and `\"`, the escapes used in the solutions, and keeps the text of any string with another escape. Reading `\t`, `\x41;` and the others too would make `"\x41;"` and `"A"` the same. None of the solutions uses them yet.
