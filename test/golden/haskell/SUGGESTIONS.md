# Suggestions for Haskell

[`transition.md`](../../../lib/inspector/languages/haskell/transition.md) says how Inspector treats Haskell differently from Basic, which Haskell used before.
These are changes that could improve it.
None of them is made, because a change to Haskell's own behaviour needs the maintainers to decide it.

## Spellings that GHC reads as the same

1. **Group operators by their fixity.** The grammar reads every chain of operators from the right, so `a * b + c` comes out as `a * (b + c)`. Inspector therefore keeps the brackets around an operator expression inside another one, and `a + (b * c)` stays apart from `a + b * c`, although GHC reads them the same. Regrouping by the Prelude's fixities, as F#'s GenerateAST does, would merge them. A solution can declare its own fixities, so regrouping would have to read `infixl` and `infixr` declarations too.
2. **Read a tight dot before arguments as composition.** `f.g x` means `f . (g x)`, but the grammar reads it as a record field applied to `x`, so it stays apart from `f . g x`. Today only a tight dot with no arguments after it, such as `not.isSpace`, is composition.
3. **Read `$name` as an application of `$`.** Without TemplateHaskell, GHC reads `map snd $sortBy f xs` as `map snd $ sortBy f xs`, but the grammar reads `$sortBy` as a splice. One golden solution (rail-fence-cipher) has this.
4. **Read a module's alias as the module.** After `import qualified Data.Map as M`, `M.fromList` and `Map.fromList` (after `as Map`) are the same function. The engine drops the import, so today they stay apart.
5. **Write a character as its value.** `'\n'` and `'\10'` are the same character, but each character keeps its text today.

## Equivalences for the maintainers to decide

6. **Drop the export list.** Every solution exports what the tests use, so `module Leap (isLeapYear) where` and `module Leap where` would pass the same tests. Inspector drops Elm's exposing list for this reason.
7. **Drop pragmas that can't change what a passing solution does.** `{-# OPTIONS_GHC -Wall #-}`, `{-# INLINE f #-}` and a `LANGUAGE` pragma for an extension the code doesn't use make no difference. Some `LANGUAGE` pragmas, such as `OverloadedStrings`, change what the code means, so they would have to stay.
8. **Keep the names of instance methods.** `instance Show Shape where show = ...` defines `show`, so the engine renames every `show` in the solution, including calls on other types. Keeping the name of a method of a class the solution doesn't define would keep these calls readable. The same applies to operators such as `==` in `instance Eq`.
9. **Write `f $ x` as `f x`.** `print $ length xs` and `print (length xs)` do the same, but GHC's parser gives an operator application for the first. Mentors do comment on the choice, so this is a judgement call.
10. **Write a `do` block with one expression as the expression.** `main = do print 1` and `main = print 1` are the same program, but GHC's parser keeps the `do`.
11. **Treat `where` and `let ... in` the same.** `f x = y * 2 where y = x + 1` and `f x = let y = x + 1 in y * 2` do the same. Mentors do sometimes comment on the choice.
12. **Sort the classes in a `deriving` clause.** `deriving (Show, Eq)` and `deriving (Eq, Show)` derive the same instances.
13. **Reorder the top-level declarations.** The order of the top-level declarations makes no difference in Haskell. A Reorder stage could attach each signature to its function and sort the declarations, so that `helper` defined before or after `main` gives the same representation.
14. **Drop the commas in tuples that have no missing element.** Today every tuple keeps its commas, so that `(, 1)` and `(1, )` stay apart. Only the tuple sections need them, and dropping them elsewhere would make the output shorter without changing any group.
