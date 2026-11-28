# Suggestions for CoffeeScript

These are improvements to CoffeeScript's representation for the maintainers to discuss.
None of them is in Inspector yet.

- **Implicit returns.** `f = -> return x` and `f = -> x` stay apart. A function returns the value of its last statement, so dropping a `return` at the end of a function would make them the same. A mentor might still suggest one spelling over the other.
- **`unless` and `until`.** `unless a` and `if not a` stay apart, and so do `until a` and `while not a`. They do the same thing, but a mentor might suggest `unless` over `if not`, or the other way round.
- **Exports.** Inspector keeps `module.exports = Leap`. Every solution needs it to pass its tests, so dropping it would only merge solutions that export the class in another way, such as `module.exports = class Leap` and `class Leap` followed by `module.exports = Leap`. A mentor would give those the same feedback.
- **Properties set on a class.** `Leap.isLeap = (year) -> ...` defines `isLeap`, but Inspector renames only the members written in a class's body and the properties set on `this` or a prototype, so `isLeap` keeps its name. The keys of other objects keep their names too. Renaming properties set on a class would make solutions that differ only in those names the same.
- **Class members.** The order of the members in a class's body makes no difference, so sorting them with `Reorder` would group solutions that list their methods in a different order.
- **`new` without brackets.** `new Foo` and `new Foo()` stay apart. CoffeeScript gives both the same call with no arguments, so writing them the same way would make them the same.
- **Strings over several lines.** A string that spans several lines keeps its text as written, so `"a` and `b"` on two lines with different indentation stay apart. CoffeeScript trims each line of such a string and joins them with a space (or, in a heredoc, removes the common indentation), so reading the string the same way would make them the same.
- **Bound functions.** `(x) => x * 2` and `(x) -> x * 2` stay apart. They differ only when the body uses `this`, so writing a `=>` whose body doesn't use `this` as `->` would make them the same. A mentor might comment on a needless `=>`, though.
