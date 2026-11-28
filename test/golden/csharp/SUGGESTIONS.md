# Suggestions for C#

[`transition.md`](../../../lib/inspector/languages/csharp/transition.md) says how Inspector differs from the old C# representer.
These are changes that could improve it.
None of them is made, because a change to C#'s own behaviour needs the maintainers to decide it.

## Spellings that are apart today

1. **Write every .NET type name as its keyword.** Only `String` becomes `string`. `Int32` and `int`, or `Boolean` and `bool`, name the same type, so they could become one too. No golden solution is split by this.
2. **Drop the brackets around a lambda's single parameter.** `(x) => x` and `x => x` mean the same, and Roslyn's simplifier can drop the brackets.
3. **Read raw strings and characters as values.** Roslyn gives `"""a"""` and `"a"` the same value, and `'\x41'` and `'A'` too. Only regular and verbatim strings are read today. No golden solution writes a raw string.

## Names

4. **Rename a namespace with a dotted name.** `namespace Shop;` renames `Shop`, but `namespace Shop.Counter;` keeps both names, because only a single name counts as a definition.

## Sorting

C# has no Reorder stage yet:

5. **Sort the members of classes, structs and records.** The order of methods, properties and fields in a class makes no difference to what the code does (apart from the order in which field initializers run).
6. **Sort the entries of a dictionary's initializer.** `{ { 1, "a" }, { 2, "b" } }` and `{ { 2, "b" }, { 1, "a" } }` build the same dictionary, unless two entries have the same key, which would throw.
