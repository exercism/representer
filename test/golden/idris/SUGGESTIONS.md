# Suggestions for Idris

[`transition.md`](../../../lib/inspector/languages/idris/transition.md) says how Inspector treats Idris differently from Basic, which the track used before.
These are changes that could improve it.
None of them is in Inspector yet, because a change to Idris's own behaviour needs a human to decide it.
The counts come from the 132 golden solutions that parse.

## Code that could be dropped

1. **Drop the visibility modifiers.** `public export` and `export` both make a function visible to the tests, and a helper's visibility makes no difference to whether the solution works. 127 golden solutions use `export` and 30 use `public export`, so today `public export f : Int` and `export f : Int` stay apart.
2. **Drop the totality settings.** `%default total` and the `total`, `partial` and `covering` modifiers only change what the compiler checks. 4 golden solutions use `%default` and 3 use a modifier.

## Spellings that are apart today

3. **Write `f $ x` as `f (x)`.** Both apply `f` to `x`. 38 golden solutions use `$`. Today Inspector keeps `$` as an operator.
4. **Write `` a `div` b `` as `div a b`.** Both call `div` with the same arguments. 26 golden solutions use backticks.
5. **Write `let x := e` and `let x = e` the same way when `x` has no arguments.** Idris's parser reads them differently, but in a solution that passes its tests they give `x` the same value.
6. **Unwrap brackets that the operators' precedence makes redundant.** The grammar gives a chain of operators as a flat list, so `(a * b) + c` and `a * b + c` stay apart today. Merging them needs a table of the precedence and associativity of the Prelude's operators, and of any `infixl`, `infixr` or `infix` declaration in the solution.
7. **Read character literals as values.** `'\n'` and `'\10'` are the same character, and only strings are read today.
8. **Read the other escapes in strings.** Inspector reads `\n`, `\t`, `\\` and `\"`. Reading decimal escapes such as `\65`, hexadecimal escapes such as `\x41` and the named ones such as `\DEL` would make more strings the same.

## Names

9. **Keep the names of library methods that a solution implements.** If a solution implements `Show` and defines `show`, Inspector renames `show` everywhere, including the calls to `show` on library types. Keeping the name of a method of a library interface would keep those calls readable, and would follow the rule that a library name keeps its name.

## Sorting

Idris has no Reorder stage yet:

10. **Sort the declarations at the top of a module.** Idris needs a name to be declared before it is used, but independent functions can come in any order. A sort would have to keep each signature with its clauses, and keep each function after the names it uses. 70 golden solutions declare several functions.
