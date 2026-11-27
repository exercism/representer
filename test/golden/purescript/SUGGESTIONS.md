# Suggestions for the PureScript representer

[`transition.md`](../../../lib/representer/languages/purescript/transition.md) says how the PureScript representer differs from Basic, which PureScript used before.
These are changes that could improve it.
None of them is made, because a change to PureScript's own behaviour needs the maintainers to decide it.

## Spellings that the compiler reads as the same

1. **Group operators by their fixity.** The grammar reads every chain of operators from the left, so `a + b * c` comes out as `(a + b) * c`. The representer therefore keeps the brackets around an operator expression inside another one, and `a + (b * c)` stays apart from `a + b * c`, although the compiler reads them the same. Regrouping by the Prelude's fixities would merge them. A solution can declare its own fixities with `infixl`, `infixr` and `infix`, so regrouping would have to read those too.
2. **Read a module's alias as the module.** After `import Data.Map as M`, `M.lookup` and `Map.lookup` (after `as Map`) are the same function. The engine drops the import, so today they stay apart.
3. **Write a character as its value.** `'\n'` and `'\x0a'` are the same character, but each character keeps its text today.
4. **Sort the labels of a record.** PureScript's rows have no order, so `{ x: 1, y: 2 }` and `{ y: 2, x: 1 }` are the same record, and `{ x :: Int, y :: Int }` and `{ y :: Int, x :: Int }` are the same type. A Reorder stage could sort `record_literal`, `record_type_literal` and `pat_fields`.

## Equivalences for the maintainers to decide

5. **Drop the export list.** Every solution exports what the tests use, so `module Leap (isLeapYear) where` and `module Leap where` would pass the same tests. Elm's representer drops its exposing list for this reason.
6. **Drop the names of instances.** Since PureScript 0.15, `instance Show Shape` and `instance showShape :: Show Shape` declare the same instance, and nothing in a solution refers to an instance's name. Today the name gets a placeholder, so the two stay apart.
7. **Write `f $ x` as `f x`, and `x # f` as `f x`.** `show $ length xs` and `show (length xs)` do the same. Mentors do comment on the choice, so this is a judgement call.
8. **Write a `do` block with one expression as the expression.** `main = do log "a"` and `main = log "a"` are the same program, but the compiler's parser keeps the `do`.
9. **Treat `where` and `let ... in` the same.** `f x = y * 2 where y = x + 1` and `f x = let y = x + 1 in y * 2` do the same. Mentors do sometimes comment on the choice.
10. **Treat `otherwise` and `true` in a guard the same.** Prelude defines `otherwise` as `true`, so `| otherwise = 0` and `| true = 0` do the same.
11. **Reorder the top-level declarations.** The order of the top-level declarations makes no difference in PureScript. A Reorder stage could attach each signature to its function and sort the declarations, so that `helper` defined before or after `isLeapYear` gives the same representation.

## The grammar

12. **Read as-patterns.** The pinned grammar rejects `xs@[a, b]` and `m@(Just x)`, so a solution that uses an as-pattern gets Basic's representation. One golden solution (meetup) has one.
