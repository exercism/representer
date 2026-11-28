# Suggestions for R

These are improvements to R's representation for the maintainers to discuss.
None of them is in Rosetta yet.

- **The two assignment operators.** `x <- 1` and `x = 1` stay apart. R's parser gives them different calls, but as a statement they do the same thing. A mentor might still ask a student to use `<-`, as the tidyverse style guide does.
- **Braces around one expression.** `if (a) b` and `if (a) { b }` stay apart, and so do `function(x) x` and `function(x) { x }`. R's parser keeps the braces as a call to `{`, but a passing solution behaves the same either way. Adding braces to every body would make them the same.
- **An explicit `return` at the end.** `f <- function(x) { return(x + 1) }` and `f <- function(x) { x + 1 }` stay apart. A function returns its last value either way, so writing a final `return(...)` as its value would make them the same. A mentor might comment on the `return`.
- **Argument names.** In `list(count = 0)`, `c(red = 1)` and `switch(card, ace = 11)`, the names keep their names, unless the solution also defines them elsewhere. Renaming them would group solutions that differ only in those names, such as the card names in blackjack, but Rosetta can't tell them from a library function's argument names, such as `collapse` in `paste(x, collapse = "")`.
- **Fields written as strings.** `x$a`, `x$"a"` and `x[["a"]]` stay apart. They all read the element `a` of a list, so writing the string as a name would make them the same. This is also a decision about names.
- **The magrittr pipe.** `x %>% f(y)` stays apart from `x |> f(y)` and `f(x, y)`. magrittr's pipe is a function, so R's parser keeps it, but it calls `f(x, y)` in the same way.
- **Namespaced calls.** `stringr::str_detect(s, "a")` stays apart from `str_detect(s, "a")` after `library(stringr)`. Rosetta drops the `library` call, so dropping the `stringr::` would make them the same.
- **Integers and doubles.** `1L` and `1` stay apart, because R reads one as an integer and the other as a double. Most functions treat them the same, and `1L == 1` is `TRUE`, but a mentor might comment on the `L`.
- **Printing.** Calls to `print` and `message` stay. The tests read what a function returns, so dropping the statements that only print would group solutions that only differ in their debugging output.
- **Other escapes.** Rosetta reads `\n`, `\t`, `\r`, `\\`, `\"` and `\'`, the escapes used in the solutions. Reading `\0`, `\a`, `\x41`, `é` and the others too would make `"\x41"` and `"A"` the same. None of the solutions uses them yet.
