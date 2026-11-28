# Suggestions for Ruby

[`transition.md`](../../../lib/rosetta/languages/ruby/transition.md) says how Rosetta differs from the old Ruby representer.
These are changes that could improve it.
None of them is made, because a change to Ruby's own behaviour needs the maintainers to decide it.

## Names

1. **Give each method's locals their own placeholders.** Renaming goes by name, so a method called `steps` and a local called `steps` share one placeholder. This causes the `collatz-conjecture` split in the golden data. Numbering locals within their method would fix it, and placeholder numbers would also stop changing when two methods happen to share a local's name.
2. **Rename the methods defined with `attr_reader`, `attr_writer` and `attr_accessor`.** These are calls, and a call defines no name, so `attr_reader :total` keeps `total`, as do the calls to it.

## Spellings that are merged today

Ruby's parser gives each of these pairs the same tree, so they are merged. A mentor often comments on the choice, so each could stay apart:

3. `x ? a : b` and `if x then a else b end`. The golden data has 39 solutions with a ternary.
4. `elsif` and an `if` inside `else`. A mentor would suggest `elsif`. The golden data has 18 solutions with `elsif`.
5. `unless x ... else ... end` and `if x` with the branches swapped. A mentor would point out that `unless` with `else` is hard to read.
6. `and`, `or` and `not` and `&&`, `||` and `!`. A mentor often comments on `and` and `or`.

## Spellings that are apart today

7. **Read every escape.** Only the escapes used in the golden data are read (`\n`, `\t`, `\s`, `\e`, `\0`, `\\`, `\"`, `\'` and `\#`). So `"\x41"` and `"A"`, and `"\033"` and `"\e"`, stay apart.
8. **Operator methods called by name.** `a.+(b)` and `a + b`, `a.!` and `!a`, and `a.[](1)` and `a[1]` stay apart. No golden solution writes them.
9. **Aliases.** `length` and `size`, `map` and `collect`, `select` and `filter`, `inject` and `reduce`, `find` and `detect`, `is_a?` and `kind_of?`, and `raise` and `fail` do the same thing. Merging them changed no group in the golden data, which is too small to show a gain.

## Sorting class and module bodies

Reorder sorts each class's and module's body, and Normalise marks each method with its `private`, `protected` or `public` line first. These lines change the code after them in the same way, but get no mark, so they can now move:

10. **Mark the methods after `module_function`.** A bare `module_function` line makes the methods after it module functions. Sorting moves the line, so a module with one method before it and one after it gets the same representation as a module with both after it. No golden solution has a method before its `module_function` in the same body.
11. **Keep `**h` in its place in a hash.** In `{**h, a: 1}`, `a` overrides the same key in `h`, and in `{a: 1, **h}` it doesn't. Sorting the entries merges the two.
12. **Treat `private attr_reader :x` as `attr_reader :x` after a `private` line.** Only `private def` gets the mark today.
