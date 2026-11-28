# Suggestions for Bash

[`transition.md`](../../../lib/rosetta/languages/bash/transition.md) says how Rosetta treats Bash differently from Basic, which the track used before.
These are changes that could improve it.
None of them is in Rosetta yet, because a change to Bash's own behaviour needs a human to decide it.
The counts come from a text search of the 379 golden solutions, so they are approximate.

## Spellings that are apart today

1. **Write `${x}` as `$x` where the braces hold only the name.** Bash expands both in the same way, and the braces only matter before a letter, digit or `_` that would otherwise join the name, which the tree already shows. 32 golden solutions use `${name}` with nothing else in the braces. This includes `"${@}"` and `"$@"`.
2. **Write `$x` as `x` inside arithmetic.** In `$(( $a + 1 ))` and `$(( a + 1 ))`, Bash reads the same variable, apart from rare cases where the variable holds an expression. About 100 golden solutions use `$` inside arithmetic, and about 250 use bare names.
3. **Write `"$x"` as `$x` where Bash doesn't split words.** The right side of an assignment (`y="$x"` and `y=$x`), the word after `case`, and the left side of `[[ ... ]]` are never split or globbed, so the quotes make no difference there. 45 golden solutions assign a quoted expansion, and 111 assign an unquoted one.
4. **Write a quoted string as a bare word when it holds no space, glob or special character.** `echo "hi"` and `echo hi` print the same, and so do `"a""b"` and `ab`. Today a bare word stays apart from a quoted string with the same text. 38 golden solutions pass a bare word to `echo`.
5. **Write `=` as `==` in `[ ... ]` and `[[ ... ]]`.** Both compare strings in the same way. About 36 golden solutions use `=` and about 82 use `==`.
6. **Write `test x` as `[ x ]`.** The `test` builtin and `[` are the same command. 4 golden solutions use `test`.
7. **Write `declare` as `local` inside a function.** Inside a function, `declare` makes a local variable, just as `local` does. 42 golden solutions use `declare` inside a function. `typeset` is another name for `declare`, but no golden solution uses it.
8. **Read the arguments of `let` as arithmetic.** `let x+=1` and `(( x += 1 ))` do the same thing, but the grammar keeps each argument of `let` as one word, so the names in it aren't renamed. 4 golden solutions use `let`.
9. **Rename the variable named by a nameref.** In `local -n ref=counts`, the word `counts` is the name of a variable, but it stays a word today. 5 golden solutions use `local -n` or `declare -n`, mostly with `$1` as the value.

## Snippet

10. **Skip `set` and `shopt` at the top of the file.** Lines such as `set -euo pipefail`, `set -o errexit` and `shopt -s extglob` only change how the script runs, so they could be left out of the card like the `source` lines. 23 golden solutions start with a `set` line.

## The grammar

11. **Parse arithmetic in an array's index that has no spaces.** The grammar reads `${a[i+1]}` as a word `i+1`, so the `i` isn't renamed. It parses `${a[i + 1]}` as arithmetic. 19 golden solutions have such an index.
12. **Parse a line of assignments before `elif` or `fi`.** The grammar reads `goal=one other=$b2` followed by `elif (( b2 == goal )); then` as one command with `elif` as an argument, so the tree for the `if` has the wrong shape. It parses without an error, and the same code always gets the same tree, so it makes no difference to the golden groups today. 6 golden solutions have it.
13. **Keep the text of `10#$x`.** The grammar leaves the `10#` out of a number such as `$((10#$x))`. Rosetta keeps it with `text_between_children`, and the same goes for a regular expression such as `-` in `[[ $x =~ - ]]`, which the grammar leaves out of the `=~` expression. A fix to the grammar would let Rosetta drop those declarations.
