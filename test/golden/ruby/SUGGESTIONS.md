# Suggestions for the Ruby representer

The Ruby representer matches what the old representer (`exercism/ruby-representer`) did, apart from the decisions that apply to every language and the bugs listed at the end.
These are changes that could improve it.
None of them is made, because a change to Ruby's own behaviour needs the maintainers to decide it.

## Names

1. **Rename the constants a solution defines.** Today `EXPECTED = 40` and `MINUTES = 40` stay apart, as they did in the old representer. A mentor would give both the same feedback.
2. **Rename methods defined with `def self.`.** Today a private helper called `def self.helper` keeps its name, as it did in the old representer, so it stays apart from the same helper called `def self.aid`. The golden data has 203 solutions with such methods. Names that the tests call would still be kept.
3. **Give each method's locals their own placeholders.** Renaming goes by name, so a method called `steps` with a local called `steps` can't have one renamed and the other kept. This causes the `collatz-conjecture` split in the golden data. Numbering locals within their method would fix it, and placeholder numbers would also stop changing when two methods happen to share a local's name.

## Spellings that are merged today

The old representer merged these because Ruby's parser gives them the same tree. A mentor often comments on the choice, so each could stay apart:

4. `x ? a : b` and `if x then a else b end`. The golden data has 39 solutions with a ternary.
5. `elsif` and an `if` inside `else`. A mentor would suggest `elsif`. The golden data has 18 solutions with `elsif`.
6. `unless x ... else ... end` and `if x` with the branches swapped. A mentor would point out that `unless` with `else` is hard to read.
7. `and`, `or` and `not` and `&&`, `||` and `!`. A mentor often comments on `and` and `or`.

## Spellings that are apart today

8. **Read every escape.** Only the escapes used in the golden data are read (`\n`, `\t`, `\s`, `\e`, `\0`, `\\`, `\"`, `\'` and `\#`). So `"\x41"` and `"A"`, and `"\033"` and `"\e"`, stay apart, although the old representer merged them.
9. **Operator methods called by name.** `a.+(b)` and `a + b`, `a.!` and `!a`, and `a.[](1)` and `a[1]` stay apart. No golden solution writes them.
10. **Aliases.** `length` and `size`, `map` and `collect`, `select` and `filter`, `inject` and `reduce`, `find` and `detect`, `is_a?` and `kind_of?`, and `raise` and `fail` do the same thing. Merging them changed no group in the golden data, which is too small to show a gain.

## Bugs fixed, where the old representer differed

- `x = $stdout` and `x = $stderr` stayed apart in the old representer, and the new one had merged them. Only globals that the solution assigns are renamed now.
- `count = 0; xs.map(&:count)` and `sum = 0; xs.map(&:sum)` stayed apart in the old representer, and the new one had merged them. A symbol is only renamed if the solution defines a method with its name.
- `|a,|` and `|a|` were merged by the old representer, although `|a,|` takes an array's first element. They stay apart now.
