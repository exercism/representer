# Suggestions for YAMLScript

These are improvements to YAMLScript's representation for the maintainers to discuss.
None of them is in Inspector yet.

- **Operators and their functions.** `a && b` and `and(a b)` stay apart, and so do `x % 4` and `rem(x 4)`, and `a == b` and `eq(a b)`. The compiler turns each operator into a function, such as `%` into `rem`, so writing each operator as its function would make them the same. Inspector would need the compiler's full table of operators, and a wrong entry would merge different programs.
- **Method calls.** `x.f(a)` and `f(x a)` stay apart. The compiler passes the value before the `.` as the first argument, so writing them the same would make them the same. A few functions, such as `take` and `drop`, take it in another place, so Inspector would need the compiler's list of them.
- **Assignments.** `x =: 1` followed by more code, and `let x 1:` with that code below it, stay apart. The compiler turns an assignment in a function's body into a `let` around the rest of the body, so writing assignments as `let` would make them the same.
- **Function definitions.** `defn f(x): x` and `(defn f [x] x)` stay apart, and so do `fn(x): x` and `fn([x] x)`. The compiler gives the same `defn` and `fn` forms for both.
- **Names in interpolated strings.** `"One for $name"` keeps the name `name` as it is written, so two solutions that differ only in that name stay apart. Reading the names out of the string would rename them with the rest.
