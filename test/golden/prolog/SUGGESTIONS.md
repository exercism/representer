# Suggestions for Prolog

[`transition.md`](../../../lib/rosetta/languages/prolog/transition.md) says how Rosetta treats Prolog differently from Basic, which Prolog used before.
These are changes that could improve it.
None of them is made, because a change to Prolog's own behaviour needs the maintainers to decide it.

## Spellings that Prolog's reader reads as the same

1. **Write operator notation and functional notation as one term.** Prolog reads `X + 1` and `+(X, 1)` as the same term, and `(a, b)` and `','(a, b)` too. Today the grammar gives them different nodes, so they stay apart. No golden solution writes an operator in functional notation.
2. **Read the other escapes.** `"\x41\"`, `"\101\"` and `"A"` are the same string, and `\e`, `\a`, `\b`, `\f`, `\v`, `\0` and a backslash before a line break each stand for one character. Today these escapes stay as they are written.
3. **Write a back-quoted string as its list of codes.** In SWI-Prolog, `` `ab` `` is the list `[97, 98]`. Today it keeps its text. One golden exercise (bottle-song) uses back-quoted strings.
4. **Unquote an atom made of symbol characters.** `'+'` and `+`, and `'=='` and `==`, are the same atom. Today only atoms made of letters, digits and `_` that start with a lower-case letter lose their quotes.

## Equivalences for the maintainers to decide

5. **Drop the module declaration.** Every solution exports what the tests use, so `:- module(leap, [leap/1]).` makes no difference to the tests. Basic dropped it. Two golden solutions (acronym and yacht) have one.
6. **Read double-quoted strings by the `double_quotes` flag.** After `:- set_prolog_flag(double_quotes, chars).`, `"abc"` is the list `[a, b, c]`. Today the string stays a string, and the directive stays in the representation. Four golden solutions (matching-brackets) set the flag.
7. **Write an underscore variable used once as `_`.** `f(_Name) :- true.` and `f(_) :- true.` do the same. Today `_Name` is renamed and `_` stays, so the two stay apart.
8. **Treat `not/1` and `\+` as the same.** `not(g(X))` and `\+ g(X)` do the same in SWI-Prolog. Mentors do sometimes comment on the choice.
9. **Reorder the predicates.** The order of the predicates in a file makes no difference, as long as the clauses of each predicate keep their order. A Reorder stage could group the clauses by predicate and sort the groups, so that a helper defined before or after its caller gives the same representation.
10. **Rename a predicate only where it is used as a predicate.** The engine renames every atom with a defined predicate's name, so in bob, `code_type(C, 'upper')` gets a placeholder because the solution also defines a grammar rule called `upper`. Renaming by name and arity would need the engine to know which atoms are calls.
