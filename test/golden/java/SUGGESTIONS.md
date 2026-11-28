# Suggestions for Java

[`transition.md`](../../../lib/rosetta/languages/java/transition.md) says how Rosetta differs from the old Java representer.
These are changes that could improve it.
None of them is made, because a change to Java's own behaviour needs the maintainers to decide it.

## Spellings that are apart today

1. **Read character literals and text blocks as values.** `'A'` and `'A'` are the same character, and a text block has the same value as a string with the same text. Only regular strings are read today. No golden solution writes either with an escape.
2. **Drop `this.` before a member.** `this.count` and `count` name the same field when no parameter or local variable has that name, and the engine already gives a field and a parameter with the same name one placeholder. C# drops `this.`.
3. **Read hexadecimal decimals as values.** `0x1p3` and `8.0` are the same `double`, and only decimal spellings are read today.

## Names

4. **Rename the variables of type patterns and record patterns.** `case Circle c ->` and `if (o instanceof Point(int x, int y))` define `c`, `x` and `y`, but only `instanceof Circle c` counts as a definition today. A type pattern's type sits beside its variable with no field name, so `GenerateAST` would need to mark the variable first. No golden solution uses these patterns.

## Sorting

Java has no Reorder stage yet:

5. **Sort the members of classes, interfaces, enums and records.** The order of methods and fields in a class makes no difference to what the code does (apart from the order in which field initializers run).
