# Suggestions for CFML

[`transition.md`](../../../lib/rosetta/languages/cfml/transition.md) says how Rosetta treats CFML differently from Basic, which CFML used before.
These are changes that could improve it.
None of them is made, because a change to CFML's own behaviour needs the maintainers to decide it.

## Names that Rosetta keeps

1. **Rename the index of a `cfloop`.** `cfloop(index="i" from="1" to="#len(s)#")` defines the variable `i`, but the name sits in a string, so `i` keeps its name. One golden solution uses this loop.
2. **Rename the properties of a component.** `property name="count";` defines `count` and, with `accessors=true`, `getCount()` and `setCount()`. The names sit in strings, so they keep their names. No golden solution has a property.

## Spellings that a CFML engine treats as the same

3. **Write `var x` and `local.x` the same way.** Inside a function, both set `x` in the local scope. Today `var total = 0` and `local.total = 0` stay apart. Mentors might still comment on the choice of spelling.
4. **Write `arguments.x` as `x`.** Inside a function, both read the argument `x`, unless a local variable has the same name. Today `return arguments.year % 4` and `return year % 4` stay apart.
5. **Drop `public` from a function.** A function without an access level is public, so `public function f()` and `function f()` define the same function. The golden solutions use `public` 15 times.
6. **Write `1` and `1.0` the same way.** Lucee stores every number literal as a double, so the two are the same value there. Adobe ColdFusion can keep them apart, so this needs a decision.
7. **Write a string that holds only an expression as the expression.** `"#x#"` is `x` turned into a string. Mentors would likely comment on the extra quotes, so the two may deserve to stay apart.
8. **Write a quoted struct key the same way as an unquoted one.** `{"a": 1}` and `{a: 1}` give the same key in Lucee, but Adobe ColdFusion writes an unquoted key in upper case. Today the two stay apart.

## Equivalences for the maintainers to decide

9. **Treat member functions as the built-in functions they call.** `s.len()` and `len(s)` do the same, and so do `a.append(x)` and `arrayAppend(a, x)`. Mentors often comment on the choice, so this is a judgement call.
10. **Reorder the functions of a component.** The order of a component's functions makes no difference to how it works. A Reorder stage could sort the component's body.
11. **Write `x++`, `x += 1` and `x = x + 1` the same way.** All three add one to `x` as a statement. Mentors may comment on the choice.
12. **Write `=>` and `->` closures the same way.** Lucee spells a closure `=>` and a lambda `->`. They differ in how they capture variables, which rarely matters in a solution. Today they stay apart.
