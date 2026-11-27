# Suggestions for the Scala representer

[`transition.md`](../../../lib/representer/languages/scala/transition.md) says how the Scala representer differs from Basic, which the track used before.
These are changes that could improve it.
None of them is made, because a change to Scala's own behaviour needs the maintainers to decide it.
The counts come from the 362 golden solutions.

## Spellings that are apart today

1. **Write a block in braces that holds one expression as that expression.** `def f(x: Int) = { x + 1 }` and `def f(x: Int) = x + 1` give the same method. Scala 3's parser keeps the braces as a block, so they are apart today, although an indented block of one expression already counts as that expression. 144 golden solutions have such a block.
2. **Write a call with braces around its argument as a call with brackets.** `xs.map { x => x * 2 }` and `xs.map(x => x * 2)` make the same call. 55 golden solutions pass an argument in braces, and 56 pass a lambda in brackets.
3. **Write an operator in infix form and as a method call the same way.** `xs map f` and `xs.map(f)` make the same call, and so do `a + b` and `a.+(b)`. Scala 3's parser gives them different trees, so they are apart today. 59 golden solutions call a named method in infix form, such as `1 to n`.
4. **Write `_` and a lambda's single named parameter the same way.** `xs.map(_ * 2)` and `xs.map(x => x * 2)` are the same lambda. The engine renames `x`, so they stay apart today. 139 golden solutions use `_` and 70 write a lambda.
5. **Write both spellings of a vararg the same way.** `f(xs: _*)` (Scala 2) and `f(xs*)` (Scala 3) pass the same arguments. Four golden solutions pass a vararg.
6. **Read character literals as values.** `'A'` and `'\u0041'` are the same character, and only strings are read today.
7. **Read the escapes of `s` and `f` strings.** `s"a\t$b"` and the same string with a real tab hold the same text, but the escapes in an interpolated string keep their text today, because a different interpolator could read them differently.

## Code that could be dropped

8. **Drop `this.` before a member.** `this.count` and `count` name the same member when no parameter or local variable has that name. C# drops `this.`. 13 golden solutions write `this.`.
9. **Drop a final `return`.** `def f = { return x }` and `def f = x` return the same value. Seven golden solutions use `return`.
10. **Drop the package clause.** `package leap` says where the file lives, and the engine already leaves out file names. A solution that passes its tests has the package the tests expect. Java drops its package declaration. No golden solution has one.

## Declarations

11. **Write each name of a `val` or `var` as a definition of its own.** `var a, b = 0` and `var a = 0; var b = 0` define the same variables. Scala 2's parser splits them, and Scala 3's keeps them together. 10 golden solutions define several names at once.

## Names

12. **Rename the alias of an import.** `import scala.collection.mutable.{Map => MMap}` defines `MMap`, but the engine drops the import before it renames, so `MMap` keeps its name.

## Sorting

Scala has no Reorder stage yet:

13. **Sort the members of objects, classes and traits.** The order of methods in a body makes no difference to what the code does. A `val` with an initialiser runs in order, so the `val`s and `var`s would keep their order.
14. **Sort each definition's modifiers.** `private lazy val` and `lazy private val` are the same.
