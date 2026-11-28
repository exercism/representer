# Suggestions for AWK

These are improvements to AWK's representation for the maintainers to discuss.
None of them is in Inspector yet.

- **`print` and `print $0`.** `{ print }` stays apart from `{ print $0 }`, and a rule with only a pattern, such as `NR > 1`, stays apart from `NR > 1 { print }`. AWK prints `$0` in each case, so writing them the same way would group them. A mentor would likely comment on each the same way.
- **`length` and `length($0)`.** `length` and `length()` are the same today, because AWK's parser reads them as one call. `length($0)` stays apart from them, although gawk reads a `length` with no argument as `length($0)`.
- **A regular expression on its own.** A pattern such as `/^a/` stays apart from `$0 ~ /^a/`. AWK matches a regular expression on its own against `$0`, so writing it as a match would group them.
- **The order of joined strings.** `a (b c)` stays apart from `a b c`, because the brackets change the tree. Joining strings gives the same result in either order, so dropping these brackets would group them.
- **Subscripts with several indexes.** `seen[i, j]` stays apart from `seen[i SUBSEP j]`. AWK joins the indexes with `SUBSEP`, so the two make the same key.
- **Increments as statements.** `x++`, `++x`, `x += 1` and `x = x + 1` all stay apart when they are statements on their own. They change `x` in the same way, but a mentor might comment on the choice.
- **Several `BEGIN` or `END` rules.** Two `BEGIN` rules stay apart from one `BEGIN` rule that holds both bodies. gawk runs every `BEGIN` rule in order as if it were one, so joining them would group them.
- **The order of functions.** AWK reads every function before it runs anything, so the order of the function definitions makes no difference. Sorting them would group solutions that only list their functions in a different order. The rules must stay in their order.
- **Other escapes.** Inspector reads `\n`, `\t`, `\r`, `\\` and `\"`. Other escapes keep their text, so `"\042"` and `"\""`, and `"\/"` and `"/"`, stay apart. Reading them too would make each pair the same.
- **Arrays that the solution only reads.** Inspector renames a variable or an array if the solution assigns to it, changes it, subscripts it, reads into it, deletes it, loops over its keys or passes it to a builtin that fills it. An array that is only tested with `in`, or only passed to a function of the solution that fills it, keeps its name. Renaming every name that isn't one of AWK's own would rename these too, but it would also rename the functions and variables that come from an `@include` or an `@load`, such as `ord`.
- **Shell scripts.** The basics exercise is a shell script that runs `awk`, which tree-sitter-awk can't parse, so its solutions get Basic's representation. Parsing them with tree-sitter-bash, or reading the AWK programs inside them, would give them a tree.
- **Rules on one line.** The grammar can't parse a rule that starts on the same line as the `}` before it, such as `{ x++ } END { print x }`, so those solutions get Basic's representation. A fix to the grammar would give them a tree.
