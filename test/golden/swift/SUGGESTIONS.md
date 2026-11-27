# Suggestions for the Swift representer

[`transition.md`](../../../lib/representer/languages/swift/transition.md) says how the Swift representer differs from Basic, which the track used before.
These are changes that could improve it.
None of them is made, because a change to Swift's own behaviour needs the maintainers to decide it.
The counts come from the 373 golden solutions.

## Code that could be dropped

1. **Drop `return` from a body that is one expression.** Since Swift 5.1, `func f() -> Int { return x + 1 }` and `func f() -> Int { x + 1 }` return the same value, and so do closures, computed properties and getters with one expression. Swift's parser keeps the `return`, so they stay apart today. 311 golden solutions use `return` somewhere.
2. **Drop `self.` before a member.** `self.count` and `count` name the same property when no parameter or local variable has that name. C# drops `this.`. 90 golden solutions write `self.`. This needs care, because `self.x = x` in an initialiser needs its `self.`.
3. **Drop `get` from a computed property that only has a getter.** `var area: Int { get { w * h } }` and `var area: Int { w * h }` declare the same property. 4 golden solutions write `get`.
4. **Drop `internal`.** Swift's default access level is `internal`, so `internal func f()` and `func f()` are the same. No golden solution writes it.

## Spellings that are apart today

5. **Write a trailing closure and a closure in brackets the same way.** `xs.map { $0 * 2 }`, `xs.map({ $0 * 2 })` and `xs.map() { $0 * 2 }` make the same call. 19 golden solutions put a closure in brackets.
6. **Write `$0` and a closure's single named parameter the same way.** `xs.map { $0 * 2 }` and `xs.map { x in x * 2 }` are the same closure. The engine would rename `x` and keep `$0`, so they stay apart today. 91 golden solutions use `$0` and 25 name a closure's parameters.
7. **Write `if let x = x` and `if let x` the same way.** Since Swift 5.7, `if let x { }` is short for `if let x = x { }`, and so is `guard let x`. 5 golden solutions write the long form.
8. **Write the generic and the short spellings of a type the same way.** `Array<Int>` and `[Int]`, `Optional<Int>` and `Int?`, and `Dictionary<String, Int>` and `[String: Int]` are the same types. 4 golden solutions write `Array<`.

## Sorting

Swift has no Reorder stage yet:

9. **Sort the members of structs, classes, enums, extensions and protocols, and the declarations at the top of a file.** The order of methods and computed properties makes no difference to what the code does. Stored properties would keep their order, because a struct's memberwise initialiser takes them in that order.
10. **Sort each declaration's modifiers.** `private static func` and `static private func` are the same.

## The grammar

11. **Fix the grammar's reading of `*` written without spaces.** The pinned grammar lets a name go on with any emoji character, and `*` and `#` count as emoji. So it reads `a*b` as one name. GenerateAST splits such a name into a product where nothing next to it binds more tightly than `*`, so `a*b + 1` is the same as `a * b + 1`. It leaves `cart.x*cart.x`, `mf*(a - b)` and `x*=2` as the grammar reads them, so they stay apart from the spaced spellings. 9 golden solutions write a product without spaces. A grammar built without emoji names (by generating it with a tree-sitter CLI older than 0.20.5) or a fix upstream would read them all correctly.
