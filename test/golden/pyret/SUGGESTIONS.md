# Suggestions for Pyret

[`transition.md`](../../../lib/rosetta/languages/pyret/transition.md) says how Rosetta treats Pyret differently from Basic, which the track used before.
These are changes that could improve it.
None of them is made, because a change to Pyret's own behaviour needs the maintainers to decide it.
The counts come from the 111 golden solution files.

## Code that could be dropped

1. **Drop `check:`, `examples:` and `where:` blocks.** Pyret runs them only when it checks the module, and the track's tests check the solution from another file, so they make no difference to whether the solution works. 11 golden solutions have one, such as `fun leap(y): ... where: leap(2000) is true end`. A mentor may want to comment on a student's own tests, which is the reason to keep them.
2. **Drop docstrings.** `doc: "Returns the sum."` at the start of a function makes no difference to what it does. 21 golden solutions have one.
3. **Drop type annotations.** `fun f(x :: Number) -> Number:` and `fun f(x):` give the same result for every input that passes the annotations, and the tests only use such inputs. 56 golden solutions use `::`. A mentor may comment on annotations, which is the reason to keep them.

## Spellings that are apart today

4. **Write `block:` as `:`.** `fun f() block: ... end` and `fun f(): ... end` run the same code. Pyret only allows several statements in a body after `block:`, and its parser records which one was written, so they stay apart today. 10 golden solutions write `block:`.
5. **Write `L.map` as `map` after `import lists as L`.** The two call the same function. 27 golden solutions import a module under a name. Today the module's name stays, so `L.map` and `lists.map` stay apart from each other and from `map`.
6. **Write `else if` as a nested `if`, or `ask` as `if`.** `ask: | a then: 1 | otherwise: 2 end` and `if a: 1 else: 2 end` give the same value. 58 golden solutions use `ask`.
7. **Write `not(a == b)` as `a <> b`.** The two give the same value for the numbers, strings and lists in the exercises.

