# R's transition

This file says how the R outputs of this service differ from the tools they replace, and why.

## Representation

R had no representer of its own (there is no `exercism/r-representer`), so R used Basic. Basic drops comments and the spaces between tokens, and keeps everything else as it is written, including line breaks.
R now has a representation of its own, which follows the decisions that apply to every language ([README.md](../../../../README.md#how-it-works) describes them).
These things change for R:

- The representer renames every name the solution defines, so two solutions that differ only in their names get the same representation. This includes the functions and variables assigned with `<-`, `<<-`, `=` or `->`, parameters, loop variables, and the fields assigned with `$`, such as `robot$direction <- "north"`. Basic kept every name.
- The representer reads the solution's syntax tree, so line breaks and semicolons make no difference.
- Each string and number is written as its value, so `'you'`, `"you"` and `r"(you)"` are the same, and so are `1e9`, `1000000000` and `1000000000.0`, because R stores them all as the same double. `1L` stays apart from `1`, because R reads it as an integer.
- Brackets that only group make no difference. R's parser keeps them, but they only change whether a value is printed at the top level, which a passing solution never relies on.
- R's parser reads these pairs the same way, so the representer gives each pair the same representation: `1 -> x` and `x <- 1`, `a ** 2` and `a ^ 2`, `\(x) x` and `function(x) x`, `x |> f(y)` and `f(x, y)`, `` `f`(x) `` and `f(x)`, and `list("a" = 1)` and `list(a = 1)`.
- The representer drops `library` and `require` calls, as imports, and the `if (!require(...)) install.packages(...)` that loads a package.
- A solution with a syntax error still gets Basic's representation, with R's version.

The representation's version is 6, one above Basic's version 5, so the website will represent every R solution again.

## Spellings that share a representation

R's parser reads each of these pairs as the same program, so the representer gives them the same representation:

- Quote style: `'you'` → `"you"`.
- A raw string and its escaped spelling: `r"(a\n)"` → `"a\\n"`.
- An escape and the character it stands for: `'a\'b'` → `"a'b"`.
- Number spelling: `1.50` → `1.5`, `1.0` → `1`, `0x1F` → `31`, `1e3` → `1000` and `0x1FL` → `31L`.
- Brackets that only group: `(a * b) + c` → `a * b + c`.
- A right assignment: `1 -> x` → `x <- 1`, and `1 ->> x` → `x <<- 1`.
- The power operator: `a ** 2` → `a ^ 2`.
- The short lambda: `\(x) x` → `function(x) x`.
- A pipe and the call it makes: `x |> f(z)` → `f(x, z)`, and `x |> f(z, w = _)` → `f(z, w = x)`.
- A name in backticks: `` `f`(x) `` → `f(x)`.
- An argument name in quotes: `list("a" = 1)` → `list(a = 1)`.
- A `;` at the end of a statement: `x <- 1;` → `x <- 1`.

## Analysis

This service doesn't make R analyses yet, and R has no old analyzer to compare with.

## Snippet

The snippet used to work on lines, because the track had no grammar.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the `library` and `require` calls at the top of the file, up to the first other statement.
Its version is now 2.
