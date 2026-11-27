# Suggestions for the Racket representer

[`transition.md`](../../../lib/representer/languages/racket/transition.md) says how the Racket representer differs from Basic, which Racket used before.
These are changes that could improve it.
None of them is made, because a change to Racket's own behaviour needs the maintainers to decide it.

## Spellings that Racket reads as the same

1. **Read the other string escapes.** `"A"`, `"\x41"`, `"\101"` and `"A"` are the same string. Today these escapes stay as they are written. No golden solution uses one.
2. **Rename the names that a structure generates.** `(struct point (x y))` defines `point-x`, `point-y`, `point?` and `set-point-x!` as well as `point`. Today `point` and its fields get placeholders, and `point-x` keeps its text, so two solutions that name the structure differently stay apart.
3. **Write `(define f (lambda (x) ...))` as `(define (f x) ...)`.** Racket expands the second into the first, so they define the same function. Mentors do sometimes comment on the choice.
4. **Write `λ` as `lambda`.** Both names are bound to the same form in `racket/base`, so `(λ (x) x)` and `(lambda (x) x)` are the same function.

## Equivalences for the maintainers to decide

5. **Drop the `provide` forms.** Every solution provides what the tests use, so `(provide leap-year?)` and `(provide (all-defined-out))` pass the same tests. Today a solution that also provides a helper stays apart from one that doesn't. Mentors do sometimes comment on `all-defined-out`.
6. **Drop `(module+ test ...)` submodules.** Some solutions carry their own tests in a `test` submodule, which can't change whether the solution passes the exercise's tests.
7. **Treat `#lang racket/base` with its requires as `#lang racket`.** `racket/base` loads less, so a solution on `racket/base` needs requires that `racket` already gives. The engine drops the requires, so today only the `#lang` line keeps the two apart.
8. **Drop contracts.** `define/contract` and `contract-out` only check arguments, so `(define/contract (f x) (-> integer? integer?) x)` and `(define (f x) x)` pass the same tests. Mentors do comment on contracts, so this may be better kept.
9. **Drop Typed Racket's type annotations.** `(: f (-> Integer Integer))` makes no difference to a solution that passes its tests. One golden solution uses Typed Racket.
10. **Write `[#t ...]` in a `cond` as `[else ...]`.** Both clauses always run when no earlier clause does.
11. **Write `'()`, `empty`, `null` and `(list)` one way.** They are the same value. Mentors do sometimes comment on the choice.
12. **Reorder the definitions at the top of the module.** A module's definitions can refer to each other in any order, so a helper defined before or after its caller works the same. A Reorder stage could sort them, so that two solutions that only differ in the order of their functions get the same representation.
