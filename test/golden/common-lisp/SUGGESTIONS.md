# Suggestions for Common Lisp

[`transition.md`](../../../lib/rosetta/languages/common_lisp/transition.md) says how Rosetta differs from the old Common Lisp representer.
These are changes that could improve it.
None of them is made, because a change to Common Lisp's own behaviour needs the maintainers to decide it.

## Code that is dropped today

1. **Keep the rest of a loop's `for` and `with` clauses.** Only each clause's variable stays today, so `for i from 0 below n` and `for i from 1 to n` get the same representation, although a mentor could comment on the bounds. The golden data has three near-miss variants that change only a loop bound and still get the same representation as their solution.

## Spellings that are apart today

2. **Drop a `(declare ...)` form.** A type or `ignore` declaration doesn't change whether a passing solution works, but it stays in the representation today.
3. **Treat `first` and `car`, and `rest` and `cdr`, as one function.** They do the same thing on lists.
