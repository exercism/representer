# Suggestions for LFE

[`transition.md`](../../../lib/rosetta/languages/lfe/transition.md) says how Rosetta treats LFE differently from Basic, which the track used before.
These are changes that could improve it.
None of them is in Rosetta yet, because a change to LFE's own behaviour needs a human to decide it.
The counts come from a text search of the 84 golden solutions, so they are approximate.

## Spellings that are apart today

1. **Write a character as its code.** LFE's reader reads `#\a` as the integer 97, so `(=:= c #\a)` and `(=:= c 97)` are the same program. Today they stay apart, because a mentor might comment on the choice. 11 golden solutions use characters.
2. **Write a function with one clause the same as a function with plain parameters.** The compiler gives the same code for `(defun f ((x) (g x)))` and `(defun f (x) (g x))`, and for `(match-lambda ((x) (g x)))` and `(lambda (x) (g x))`, but the reader gives them different forms. Most golden solutions that use clauses have more than one, so this would merge few of them.
3. **Write `(fun f 1)` as `#'f/1`.** The `fun` macro expands to the same `function` form as `#'f/1`. No golden solution uses either today.
4. **Drop the docstrings of `defmodule`, `defun` and `defmacro`.** A docstring makes no difference to a solution working. A few golden solutions have one.
5. **Drop `export`, or sort the functions in it.** A solution that passes its tests exports at least the functions the tests call, and an extra export or a different order makes no difference to it working. Every golden solution has an `export`. Rosetta keeps it today, as it does for Erlang.
6. **Write a `let*` with one binding as a `let`.** The two mean the same when there is only one binding. The golden solutions use `let*` 24 times.

## Names

7. **Keep atoms apart from the names the solution defines.** Rosetta renames by text, so in a `gen_server` solution the message `'direction` in `(gen_server:call robot 'direction)` gets the same placeholder as the function `direction`. The renaming is consistent, so it makes no difference to the groups, but an atom with the same text as a function stays an atom in the program. 1 golden solution is a `gen_server` module.
8. **Rename the functions that a record defines.** `(defrecord robot x)` defines `make-robot`, `robot-x`, `set-robot-x` and `match-robot`. Rosetta renames `robot` and `x`, but those functions keep their names. 2 golden solutions use `defrecord`.

## The grammar

9. **Parse `case` inside `try`.** The grammar reads `case` only with a value before its clauses, so `(try (f) (case ((tuple a) a)))` doesn't parse, and the solution gets Basic's representation. No golden solution uses `try`.

## Snippet

10. **Skip `defrecord` at the top of the file.** A record definition sits between the module and the functions, so the card could start at the first function. 2 golden solutions have a `defrecord` between the `defmodule` and the first function.
