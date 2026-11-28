# Suggestions for SQLite

[`transition.md`](../../../lib/rosetta/languages/sqlite/transition.md) says how Rosetta treats SQLite differently from Basic, which the track used before.
These are changes that could improve it.
None of them is made, because a change to SQLite's own behaviour needs the maintainers to decide it.
The counts come from the 328 golden solutions.

## Code that could be dropped

1. **Drop the sqlite shell's dot-commands.** Six golden solutions start with lines such as `.mode csv` or `.import data.csv bob`, which repeat the setup that the tests already do. They aren't SQL, so a mentor would ignore them.
2. **Drop `ASC` after an `ORDER BY` term.** `ORDER BY a ASC` and `ORDER BY a` sort the same way, because ascending is the default. SQLite's parser marks the two differently, so they stay apart today. 11 golden solutions write `ASC`.

## Spellings that are apart today

3. **Read a double-quoted text as a string if no column has that name.** SQLite reads `"single-square"` as a name if the table has such a column, and as the string `'single-square'` otherwise. 126 golden solutions use double quotes, mostly for strings such as `WHERE task = "total"`. Rosetta never reads the exercise's schema, so today a double-quoted text gets a node of its own and stays apart from both a name and a string.
4. **Read a double-quoted name in any case.** SQLite matches `"Input"` to the column `input`, as it does for names without quotes. Today a double-quoted name keeps its case.
5. **Write `iif(a, b, c)` as `CASE WHEN a THEN b ELSE c END`.** The two give the same value. 45 golden solutions call `iif`.
6. **Write `CASE x WHEN a THEN ...` as `CASE WHEN x = a THEN ...`.** The two give the same value, apart from a `NULL` in `x`, which matches no `WHEN` either way.
7. **Write each function with two names in one way.** SQLite gives some functions two names: `pow` and `power`, `substr` and `substring`, `ceil` and `ceiling`. `ifnull(a, b)` and `coalesce(a, b)` give the same value too. 25 golden solutions call `pow` or `power`.
8. **Write `TRUE` and `FALSE` as `1` and `0`.** SQLite stores them as those integers.
9. **Write `- 5` as `-5`.** The grammar reads `-5` as one number, and `- 5` and `-(5)` as other trees, while SQLite's parser reads all three as `-` before `5`.
10. **Write `LIMIT a, b` as `LIMIT b OFFSET a`.** The two limit the rows in the same way.

## Names

11. **Rename the names of named windows.** `WINDOW w AS (ORDER BY a)` defines `w`, which `OVER w` uses, but neither is renamed today.
12. **Rename the columns that a table alias lists.** `FROM t AS x(a, b)` defines `a` and `b`, which keep their names today.
