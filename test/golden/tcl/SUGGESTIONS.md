# Suggestions for Tcl

[`transition.md`](../../../lib/rosetta/languages/tcl/transition.md) says how Rosetta treats Tcl differently from Basic, which the track used before.
These are changes that could improve it.
None of them is made, because a change to Tcl's own behaviour needs the maintainers to decide it.
The counts come from the 371 golden solution files.

## Spellings that Tcl reads as the same

1. **Read a word in braces as a string when it holds no script.** Tcl's parser reads `{abc}` and `abc` as the same word, and `{a b}` and `"a b"` too, but the grammar reads a braced word in a command's arguments as a script, so `return {abc}` and `return abc` stay apart. Reading it as a string everywhere would lose the renaming inside the scripts given to `lmap`, `method` and the like. 4 golden solutions pass a braced word that holds one word, such as `{abc}`.
2. **Read a body without braces as the same script.** `if {$a} return` and `if {$a} {return}` run the same script. 2 golden solutions leave out the braces around a body of one word.
3. **Read the other escapes as their characters.** Tcl reads `\d` as `d` and `\x41` as `A`, but Rosetta keeps every escape with a letter or a digit as its text. Reading `\d` as `d` would put the regular expression `"\d"` with `"d"`. 1 golden solution has such an escape in quotes.
4. **Read the case of a boolean the same way.** `if {True}` and `if {true}` test the same value, but `expr {True}` returns `True`, so the two stay apart.

## Equivalences for the maintainers to decide

5. **Drop `[expr {...}]` inside a condition.** `if {[expr {$a % 4}] == 0}` and `if {$a % 4 == 0}` test the same thing. 8 golden solutions call `expr` inside the condition of an `if` or a `while`.
6. **Write `switch $x a {...} b {...}` as `switch $x {a {...} b {...}}`.** Both forms of `switch` take the same patterns and bodies. 36 golden solutions put the patterns in braces, and 4 write them inline.
7. **Drop a `return` before the last command of a procedure.** A procedure returns the result of its last command, so `return [expr {$a + 1}]` at the end and `expr {$a + 1}` are the same. 328 golden solutions use `return`, though some of these return early.
8. **Write `if {...} {return true} else {return false}` as `return [expr {...}]`.** Both return the result of the test. 7 golden solutions return true or false from the two branches of an `if`.
9. **Drop `namespace export` and `namespace ensemble create`.** The tests call the procedures with their full names, so these commands change nothing that the tests use. 20 golden solutions export procedures, and 13 create an ensemble.
10. **Write `incr x` and `set x [expr {$x + 1}]` the same way.** Both add one to `x`. 144 golden solutions use `incr`, and 1 uses `set` with `expr`.
11. **Read a number word in a command the same way however it is written.** `lindex $l 0x1` and `lindex $l 1` pick the same item, but the two words are different strings, so they stay apart.

## Names

12. **Rename the parameters of an `apply` lambda.** `apply {{x} {expr {$x * 2}}} 3` defines `x`, but Rosetta doesn't read the lambda, so `x` keeps its name unless the solution defines it elsewhere. 3 golden solutions use `apply`.
13. **Keep words that aren't names apart from the names the solution defines.** Every Tcl word is a string, and renaming goes by text, so if a solution defines a variable called `end`, the `end` in `lindex $l end` is renamed too. This can only keep two solutions apart, never merge them.
14. **Rename a procedure that is defined with its namespace.** `proc ::leap::isLeapYear` and `isLeapYear` inside `namespace eval leap` define the same procedure, but they are renamed as different names, so a call of one spelling doesn't match a definition with the other. 3 golden solutions define a procedure with its namespace.
15. **Rename the variables that `dict update` and `dict with` create.** `dict update d key var {...}` defines `var`, and `dict with d {...}` defines a variable for each key, but Rosetta only renames the dictionary's variable.
