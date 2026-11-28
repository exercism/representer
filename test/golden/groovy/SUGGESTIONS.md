# Suggestions for Groovy

These are improvements to Groovy's representation for the maintainers to discuss.
None of them is in Rosetta yet.

- **Implicit returns.** `int f() { return 1 }` and `int f() { 1 }` stay apart. A method returns the value of its last statement, so dropping a `return` at the end of a method or closure would make them the same. A mentor might still suggest one spelling over the other.
- **Optional `public`.** `public class A` and `class A` stay apart, and so do `public int f()` and `int f()`. Classes and methods are public unless they say otherwise, so dropping `public` from them would make the solutions the same. On a field, `public` stops Groovy from making a property, so a field's `public` would have to stay.
- **Explicit `this`.** Inside a class, `this.count` and `count` stay apart when no local variable is called `count`. Dropping `this.` there would make them the same, but Rosetta would have to know which names are local in each method.
- **The implicit closure parameter.** `list.each { println it }` and `list.each { x -> println x }` stay apart. Both closures take one parameter, so writing `it` as a named parameter would make them the same. A mentor might comment on either spelling.
- **Braces around a single statement.** `if (a) return 1` and `if (a) { return 1 }` stay apart, and so do the same loops. Adding braces to every body with `add_braces_to` would make them the same.
- **Compound assignments.** `x += 1`, `x = x + 1` and `x++` stay apart. The first two do the same thing, but a mentor might comment on the longer one.
- **Annotations.** Rosetta keeps annotations such as `@CompileStatic` and `@Override`. They make no difference to a solution that passes its tests, so dropping them would make solutions with and without them the same. A mentor might comment on `@CompileStatic`, though.
- **Script variables.** In a script, `x = 1` outside any method makes a variable in the script's binding. Rosetta doesn't rename these variables, because the same code inside a method assigns to a name defined elsewhere. Renaming them would make scripts that differ only in these names the same.
- **Import aliases.** `import java.time.Year as Y` defines the name `Y`, but Rosetta drops the import before it renames names, so `Y` keeps its name. Renaming aliases would make solutions that choose different aliases the same.
- **Class members.** The order of the fields and methods in a class makes no difference, so sorting a class's body with `Reorder` would group solutions that list their methods in a different order.
- **Command chains with several calls.** The grammar reads `take 2 of x` as two calls, `take 2` and `of x`, where Groovy's parser reads one chain, `take(2).of(x)`. No solution in the golden data has such a chain. Giving the grammar's tree the shape of the chain would need a change to the grammar.
