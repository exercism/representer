# Suggestions for Free Pascal

[`transition.md`](../../../lib/rosetta/languages/free_pascal/transition.md) says how Rosetta treats Free Pascal differently from Basic, which the track used before.
These are changes that could improve it.
None of them is made, because a change to Free Pascal's own behaviour needs the maintainers to decide it.
The counts come from the 103 golden solution files.

## Code that could be dropped

1. **Drop the `interface` section's declarations.** Every unit repeats each function's header in its `interface` section, and the tests need those headers, so a solution can't leave them out. Today a solution's headers count twice. All 103 golden solutions have an `interface` section.
2. **Drop `const` before a parameter.** `function f(const s: string)` and `function f(s: string)` give the same result, because a solution that compiles never assigns to a `const` parameter. 100 golden solutions use `const` parameters, and the exercises' stubs write them. A mentor may comment on `const`, which is the reason to keep it.

## Spellings that are apart today

3. **Write `a += b` as `a := a + b`.** Free Pascal's parser turns `+=`, `-=`, `*=` and `/=` into the longer form. 13 golden solutions use one of them.
4. **Write a call with empty brackets without them.** `Halt()` and `Halt` call the same procedure. 4 golden solutions write empty brackets. A bare name can also be a variable, so the rule could only drop the brackets.
5. **Split declarations that share a type.** `var a, b: integer;` and `var a: integer; b: integer;` declare the same variables, and so do the parameters `(a, b: integer)` and `(a: integer; b: integer)`. 36 golden solutions declare several variables or fields together, and 20 declare several parameters together.
6. **Write `a[i][j]` as `a[i, j]`.** The two index the same element of an array of arrays. 8 golden solutions write `][`.
7. **Unwrap `begin ... end` around one statement.** `if a then begin b end` and `if a then b` run the same code.
8. **Write an assignment to the function's name as an assignment to `Result`.** `LeapYear := x` and `Result := x` set the same result inside `function LeapYear`. 1 golden solution assigns to the function's name.
9. **Write `Inc(x)` as `x := x + 1`.** The two give the same value for the integers in the exercises. 23 golden solutions call `Inc`.
