# Suggestions for PowerShell

[`transition.md`](../../../lib/inspector/languages/powershell/transition.md) says how Inspector treats PowerShell differently from Basic, which the track used before.
These are changes that could improve it.
None of them is made, because a change to PowerShell's own behaviour needs the maintainers to decide it.
The counts come from the 205 golden solutions.

## Spellings that PowerShell reads as the same

1. **Write `-not` and `!` the same way.** Both are the same operator, but the parser keeps the spelling. 30 golden solutions use `-not` and 1 uses `!`.
2. **Write the case-insensitive operators the same way as the default ones.** `-ieq` and `-eq` compare in the same way, and so do `-imatch` and `-match`. 1 golden solution uses an `-i` operator.
3. **Write `$PSItem` as `$_`.** Both name the current pipeline object. No golden solution uses `$PSItem`, and 57 use `$_`.
4. **Write each type accelerator as its full type.** `[int]`, `[int32]` and `[System.Int32]` name the same type, and so do `[string]` and `[System.String]`. 71 golden solutions use `[int]`, 2 use `[int32]` and 3 use `[System.String]`.
5. **Write each built-in alias as its command.** `%` and `foreach` run `ForEach-Object`, and `?` and `where` run `Where-Object`, unless the solution defines its own command with that name. 31 golden solutions use `ForEach-Object` and 1 uses `%`, and 18 use `Where-Object` and 5 use `?` or `where`.
6. **Write `"$($x)"` as `"$x"`.** Both put the value of `$x` in the string. 1 golden solution writes `$($x)` around a plain variable.

## Equivalences for the maintainers to decide

7. **Write a function's parameters one way.** `function f([int]$x) { }` and `function f { param([int]$x) }` define the same function. 17 golden solutions put the parameters after the name, and 175 use `param(...)`.
8. **Drop `[CmdletBinding()]`.** It adds the common parameters, such as `-Verbose`, which no test uses. The stubs of 77 of the 95 exercises have it, and 157 golden solutions keep it.
9. **Drop a `return` before the last value of a function.** `return $x` and `$x` as the last statement both write out `$x`. 168 golden solutions use `return`, though some of these return early.
10. **Write `Write-Output $x` as `$x`.** Both write `$x` to the pipeline. 2 golden solutions use `Write-Output`.
11. **Sort the entries of a hashtable literal.** A `@{ }` hashtable has no order, so `@{ a = 1; b = 2 }` and `@{ b = 2; a = 1 }` are the same. An `[ordered]@{ }` keeps its order. 39 golden solutions write a hashtable.
12. **Sort the members of a class.** The order of properties and methods in a class makes no difference to the class. 26 golden solutions define a class.

## Names

13. **Rename the variables of a multiple assignment.** `$a, $b = 1, 2` defines `$a` and `$b`, but Inspector only renames a variable assigned to on its own, so they keep their names unless the solution assigns them elsewhere. 2 golden solutions use a multiple assignment.
14. **Keep the names fixed by the tests.** The tests call the functions and their parameters by name, such as `Test-LeapYear -Year 2000`, so those names are the same in every solution, and renaming them only makes the output harder to read.
15. **Keep hash keys and member names apart from variables.** A hash key such as `@{ count = 1 }` is a string and keeps its name, but `$h.count` is a member name and is renamed if the solution defines `$count`. Renaming the two the same way would keep them matching.
