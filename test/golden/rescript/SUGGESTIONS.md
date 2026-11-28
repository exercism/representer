# Suggestions for ReScript

[`transition.md`](../../../lib/inspector/languages/rescript/transition.md) says how Inspector treats ReScript differently from Basic, which ReScript used before.
These are changes that could improve it.
None of them is made, because a change to ReScript's own behaviour needs the maintainers to decide it.

## Spellings that ReScript reads as the same

1. **Write a partial application as the function it stands for.** ReScript's parser reads `String.equal(_, x)` as `__x => String.equal(__x, x)`. Today the two stay apart. Five golden solutions use `_` this way.
2. **Read the other string escapes.** `"A"`, `"\x41"` and `"A"` are the same string. Today these escapes stay as they are written. No golden solution uses one.
3. **Write a template string without substitutions as a string.** `` `abc` `` and `"abc"` give the same value. Today they stay apart, because ReScript's parser marks the template string. No golden solution relies on this.
4. **Write `~x` in a parameter list as `~x as x`.** ReScript's parser gives both the same tree. Hardly anyone writes the long form.

## Equivalences for the maintainers to decide

5. **Write `x->f(a)` as `f(x, a)`.** The pipe only puts `x` first in the call, so the two pass the same tests. About half of the golden solutions use `->`, and mentors do comment on the choice.
6. **Write `mod(a, b)` as `a % b`.** Both call the same integer remainder. In leap, one golden solution uses `mod` and the others use `%`, and they stay apart.
7. **Drop type annotations.** A solution that passes its tests type-checks without them, so `(text: string): string =>` and `text =>` behave the same. Several golden solutions annotate every function. Mentors do sometimes comment on annotations.
8. **Read the `.resi` interface file.** Today Inspector ignores it, as OCaml's ignores `.mli`. A student who changes the interface, such as by exporting a helper, gets the same representation as one who doesn't.
9. **Reorder the fields of a record value and a record type.** `{x: 1, y: 2}` and `{y: 2, x: 1}` are the same record. A Reorder stage could sort them. Top-level definitions can't be reordered, because a ReScript definition can only use what comes before it.
10. **Treat `==` and `===` as the same for numbers and strings.** For these values both compare by value, so `year % 4 == 0` and `year % 4 === 0` pass the same tests. In leap, one golden solution uses `===`. Mentors do comment on the difference, so this may be better kept.
