# Suggestions for Dart

These are improvements to Dart's representation for the maintainers to discuss.
None of them is in Inspector yet.

- **Arrow bodies.** `int f() => 1;` and `int f() { return 1; }` stay apart, and so do `(x) => x` and `(x) { return x; }`. Writing an arrow body as a block that returns its expression would make them the same. The two spellings run the same way, but a mentor might comment on a long body written as an arrow.
- **Optional `new` and `const`.** `new Duration(seconds: 1)` and `Duration(seconds: 1)` stay apart, and so does a `const` inside a list that is already `const`. Since Dart 2, both keywords are optional in these places and change nothing, so dropping them would make the solutions the same.
- **Local variable types.** `var x = 1;`, `int x = 1;` and `final x = 1;` stay apart. The first two give `x` the same type, so they could become one. Merging `final` with them is a larger decision, because a mentor might suggest `final` for a variable that never changes.
- **Explicit `this`.** Inside a class, `this.count` and `count` stay apart when no local variable is called `count`. Dropping `this.` there would make them the same, but Inspector would have to know which names are local in each method.
- **Braces around a single statement.** `if (a) return 1;` and `if (a) { return 1; }` stay apart, and so do the same loops. Adding braces to every body, as other languages do with `add_braces_to`, would make them the same.
- **Compound assignments.** `x += 1`, `x = x + 1` and `x++` stay apart. The first two do the same thing, but a mentor might comment on the longer one.
- **Adjacent strings.** `'a' 'b'` and `'ab'` stay apart, because the parser keeps them as two strings. The compiler joins them into one string, so writing them as one value would make them the same.
- **Brackets around a chain of calls.** `(a.b).c` and `a.b.c` stay apart, because the grammar gives `a.b` as a name followed by a selector, and brackets around two nodes don't only group. Removing the brackets would make them the same. It would be wrong for a chain with `?.`, because `(a?.b).c` and `a?.b.c` behave differently when `a` is null.
- **Library and part directives.** Inspector keeps `library leap;`, `part 'src/x.dart';` and `part of leap;`. A solution that passes its tests already has all its files, so dropping these would make solutions with and without them the same.
- **Annotations.** Inspector keeps `@override`. It only tells the analyzer to check the method, and makes no difference to a solution that passes its tests, so dropping it would make solutions with and without it the same.
- **Class members.** The order of the fields and methods in a class makes no difference, so sorting a class's body would group solutions that list their methods in a different order. The grammar gives each method as a signature and a separate body, so `GenerateAST` would first have to join them.
