# Suggestions for Kotlin

[`transition.md`](../../../lib/inspector/languages/kotlin/transition.md) says how Inspector treats Kotlin differently from Basic, which the track used before.
These are changes that could improve it.
None of them is made, because a change to Kotlin's own behaviour needs the maintainers to decide it.
The counts come from the 388 golden solutions.

## Code that could be dropped

1. **Drop the package header.** `package leap` says where the file lives, and the engine already leaves out file names. A solution that passes its tests has the package the tests expect. Java drops its package declaration. One golden solution has one.
2. **Drop file annotations.** `@file:JvmName("Leap")` only changes the name of the JVM class that holds the file's top-level functions, which the tests can't see. No golden solution has one.
3. **Drop `public`.** Kotlin's default visibility is `public`, so `public fun f()` and `fun f()` are the same. One golden solution writes it.
4. **Drop `this.` before a member.** `this.count` and `count` name the same property when no parameter or local variable has that name. C# drops `this.`. 48 golden solutions write `this.`.
5. **Drop the empty brackets before a trailing lambda.** `xs.forEach() { println(it) }` and `xs.forEach { println(it) }` make the same call.
6. **Drop the `: Unit` return type.** `fun f(): Unit { }` and `fun f() { }` declare the same function.

## Spellings that are apart today

7. **Put braces around the body of each `if`, `else`, `when` branch and loop.** `if (a) b() else c()` and `if (a) { b() } else { c() }` mean the same, and a block's value is its last expression. Java and Wren do this with `add_braces_to`.
8. **Write `it` and a lambda's single named parameter the same way.** `xs.map { it * 2 }` and `xs.map { x -> x * 2 }` are the same lambda. The engine would rename `x` and keep `it`, so they stay apart today. 146 golden solutions use `it` and 128 name a lambda parameter, so this could join many solutions.
9. **Write an expression body and a block that only returns the same way.** `fun f() = x + 1` and `fun f(): Int { return x + 1 }` give the same function, unless the expression body's inferred type differs from the declared one. 67 golden solutions use an expression body. This needs care, because the return type is part of the function.

## Names

10. **Rename the alias of an import.** `import kotlin.math.abs as absolute` defines `absolute`, but the engine drops the import before it renames, so `absolute` keeps its name.

## Sorting

Kotlin has no Reorder stage yet:

11. **Sort the members of classes, objects and interfaces.** The order of functions in a class body makes no difference to what the code does. The order of properties with initialisers and `init` blocks does matter, so they would keep their order.
12. **Sort each declaration's modifiers.** `private override fun` and `override private fun` are the same.
