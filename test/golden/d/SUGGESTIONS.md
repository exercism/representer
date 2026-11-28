# Suggestions for D

[`transition.md`](../../../lib/rosetta/languages/d/transition.md) says how Rosetta treats D differently from Basic, which the track used before.
These are changes that could improve it.
None of them is in Rosetta yet, because a change to D's own behaviour needs a human to decide it.
The counts come from the 127 golden solutions.

## Code that could be dropped

1. **Drop the `unittest` blocks.** D's exercises keep their tests in the solution file, and 120 golden solutions have a `unittest` block. Students change it: 95 set `allTestsEnabled` to 1, and some delete or add tests. Two solutions with the same code and a different `unittest` block stay apart today. The tests never change whether the solution works.
2. **Drop the module declaration.** `module leap;` names the module, and the exercise sets the name. 123 golden solutions have one. Rosetta already renames it, so only a solution with no module declaration stays apart from one with it. Java drops its package declaration.
3. **Drop `this.` before a member.** `this.count` and `count` name the same member when no parameter or local variable has that name. C# drops `this.`. 9 golden solutions write `this.`.

## Spellings that are apart today

4. **Write a body in braces that holds one statement as that statement.** `if (a) b;` and `if (a) { b; }` do the same thing, but D's parser keeps the braces as a block. 40 golden solutions have a body without braces, and 64 have braces around one statement.
5. **Write a uniform function call as a plain call.** `a.f(b)` and `f(a, b)` make the same call when `f` is a free function, and so do `xs.empty` and `xs.empty()`. D's parser gives each pair a different tree, and Rosetta can't always tell whether `f` is a member or a free function.
6. **Write `new C` and `new C()` the same way.** Both make a `C` with no arguments.
7. **Write each declarator as a declaration of its own.** `int a, b;` and `int a; int b;` declare the same variables. D's compiler makes a separate declaration for each name. 5 golden solutions declare several names at once.
8. **Read integers with a suffix as their values.** `1_000L` and `1000L` are the same `long`, and so are `2uL` and `2UL`. Today an integer with a suffix keeps its text. 9 golden solutions use a suffix.
9. **Read character literals as values.** `'\n'` and `'\x0A'` are the same character, and only strings are read today. 29 golden solutions use a character literal.
10. **Write `"a"c` as `"a"`.** A string with the `c` suffix has the type `string`, the type of a plain string. Today the suffix keeps it apart. No golden solution uses one.
11. **Read the other escapes.** Rosetta reads `\n`, `\t`, `\r`, `\0`, `\\`, `\"`, `\'`, `\xXX` up to `\x7F`, `\uXXXX` and `\UXXXXXXXX`. Reading octal escapes, `\a`, `\b`, `\f`, `\v`, `\?` and named entities such as `\&amp;` too would make more strings the same.

## Sorting

D has no Reorder stage yet:

12. **Sort the declarations at the top of a module.** D lets a module's functions, types and constants come in any order, unlike C. 34 golden solutions declare several of them.
13. **Sort the methods of classes and structs.** The order of methods in a body makes no difference. The fields would keep their order, because it sets the layout of the object. 16 golden solutions have a class or struct with several methods.
14. **Sort each declaration's attributes.** `pure nothrow int f()` and `nothrow pure int f()` are the same.
