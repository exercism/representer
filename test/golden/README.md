# Golden data

This folder holds real solutions that students published on Exercism, for every track.
For each track there are up to 100 groups of solutions that production gave the same representation (usually three solutions each), and up to 100 solutions that production gave a representation of their own (the singles).
All of them passed the tests.
Each single also has a near-miss variant: a copy with one small change to its code, which must get a different representation.

Three tests in [`test/golden_test.rb`](../golden_test.rb) run over every track:

1. **Representations stay the same.** Each solution gets exactly the representation in its `representation.txt`.
2. **Groups stay the same.** The groups that today's representations make are the groups these solutions were in on production, apart from the differences listed in the track's `differences.yml`.
   If a new difference appears, or a listed one stops happening, the test fails.
3. **Near misses stay apart.** Each single gets a different representation from its variant, apart from the near-miss merges listed in the track's `differences.yml`.
   If a new one appears, or a listed one stops happening, the test fails.

So if a change merges two groups or splits one, the groups test will fail, even when the change was meant to change the representations.

## The layout

```text
test/golden/<track>/
  groups.yml                  the production groups
  differences.yml             how today's groups differ from them
  <exercise>/
    exercise/                 the exercise files the website sends
    solutions/<handle>/
      solution/               the student's files
      representation.txt      the representation the solution gets today
      meta.yml                the public URL and the production representation id
      variant.yml             (singles only) the near-miss variant's change
      variant/                (singles only) the file that the variant changes
```

- The website sends the exercise files with each request: `.meta/config.json`, and the test, editor and stub files that the config lists.
  They come from the track's repo at `main`, and each exercise has one copy.
- A solution's folder is named after the student's handle.
  If two solutions have the same handle (deleted accounts are all called `ExercismGhost`), the second one gets `-2`.
- `representation.txt` holds the representation, or `unrepresentable: <reason>` if the solution gets none, or `error: <message>` if the representer raises an error.
- The solutions are students' published solutions in a public repo, so only the files, the public URL and the production representation id are kept.

## Changing the representations

After a change that is meant to change some representations, run:

```shell
./bin/regenerate-golden ruby      # one or more tracks
./bin/regenerate-golden           # every track (about a minute)
```

This rewrites each solution's `representation.txt` and the track's `differences.yml`.
Then review `git diff test/golden`.
A difference already listed in `differences.yml` keeps its status, `why` and note.
A new one gets `status: undecided` and a note that says where the solutions differ.

`./bin/setup-hooks` installs a pre-commit hook ([`bin/pre-commit`](../../bin/pre-commit)).
The hook runs with the Ruby named in `.ruby-version`, whatever Ruby the shell has, and says so if it can't find one.
If a commit changes a language's class or its grammar's pin, the hook regenerates that language's golden data.
If any golden file then changes, it will stop the commit until you stage the files.
The hook doesn't look at changes to the engine, which can change every language, so run `./bin/regenerate-golden` for those.
CI checks every track either way.

## Deciding on the differences

Each difference in `differences.yml` has a `status`.
It stays `undecided` until iHiD decides whether the difference is right (`accepted`) or a bug to fix (`rejected`).
A decided difference also has a one-line `why`.
A rejected difference stays listed until the fix lands, and the fix then removes it when the data is regenerated.

- A **split** is a production group whose solutions now get different representations.
  `solutions` lists the new groups.
  A split means a mentor's feedback will no longer reach some of the solutions it used to reach.
- A **merge** is a set of solutions from different production groups that now get the same representation.
  `solutions` lists them by production group.
  A merge means a mentor's feedback will now reach solutions it didn't reach before.
- An **unrepresentable** solution gets no representation today, although production gave it one.
- A **near-miss merge** is a single that gets the same representation as its variant (see below).
  `solutions` names the single, and the note says what the variant changes.
  A near-miss merge means a mentor's feedback on one solution would reach a solution with different code.

## The near-miss variants

Each single has a variant: a copy of the solution with exactly one small change to its code.
The change makes it different code, so the variant must never get the same representation as the single.
`variant.yml` records the kind of change (`mutation`), the file and line, and a one-line description, and `variant/` holds the changed file.

A one-off script made the variants, and the data stays fixed until someone makes them again.
It tries these kinds of change in order, and uses the first kind the code has:

1. **operator**: swap a binary operator for another of the same kind, such as `+` and `-`, `<` and `<=`, `==` and `!=`, or `&&` and `||`. Languages with their own spelling use it, such as Haskell's `/=`, Erlang's `=<` and Lua's `~=`. In WebAssembly, the operators are instructions such as `i32.add` and `i32.sub`.
2. **number**: add 1 to a number.
3. **string**: change one letter in a string.
4. **boolean**: swap `true` and `false`.
5. **library**: swap a library call for another from a small table for each language, such as `upcase` and `downcase`, `min` and `max`, or `map` and `filter`. A name the student defines is never swapped.

Within a kind, the script shuffles the candidates with a seed made from the solution's uuid, so the choice is the same every time.
For a language with its own class, it finds the candidates in the grammar's tree, and the variant must still parse and still get a representation, or it tries the next candidate.
For a Basic track, it uses the track's lexer tokens (or, for a track with no lexer, a small lexer that knows the track's comments and strings).
It never changes comments, docstrings, or the names in an import or include.
It can change other parts of an import, such as a path, an Erlang export's arity or a Haskell import list, and those variants no longer compile.

Of the 8,041 singles, 7,727 have a variant: 5,361 change an operator, 1,760 a number, 354 a string, 204 a library call and 48 a boolean.
The other 314 have `mutation: none`. For 312 the code has nothing to change (Tcl has 46 of them, Prolog 19 and Factor 16), and for 2 no change left code that still parses.

### The near-miss merges today

The variants find 32 near-miss merges, and all of them are accepted.

- 3 are in Common Lisp. The Common Lisp class keeps only the variable of a `loop` clause such as `for x from 1 to n`, so `(loop for i from 1 to n ...)` and `(loop for i from 2 to n ...)` get the same representation (in `binary`, `rail-fence-cipher` and `sieve`). Every solution that the representer sees passes its tests, so a loop bound that the representation leaves out can't matter to a mentor.
- 29 change only an import, which the representer drops: a path in Ballerina (10), Odin (3) and Ruby (2), an arity in an Erlang `-export` (11), and a name in a Haskell (1) or PureScript (2) import list. Each of these variants would no longer compile or pass its tests, so no real solution can look like it.

## The differences today

The data holds 20,581 solutions in 82 tracks: 4,187 production groups of two or three solutions, and 8,041 singles.
Each track has between 33 and 100 singles (the median is 100), from between 22 and 100 exercises (the median is 69).
Compared with production, today's representer makes 664 splits and 160 merges, and 32 singles get the same representation as their variant.
All 160 merges, all 32 near-miss merges and 24 of the splits are accepted. The other splits are still `undecided`.

### The 55 tracks that use Basic

These tracks have 568 splits and 63 merges.
Production's basic representer deleted all whitespace and kept comments.
Today's Basic does the opposite: it keeps line breaks, the spaces between tokens and (in languages like Python) indentation, and it drops comments and, where it can find them reliably, imports.

- 464 splits come from line breaks, 93 from spaces between tokens or inside strings, and 11 from indentation.
  Some of these are right: in Scheme, `(1- n)` and `(1 - n)` mean different things, and so do strings with different spaces.
- 62 merges are solutions that differ only in comments, whitespace or imports. For 18 Haskell merges, production split the solutions because some also held a `package.yaml` or had their file at another path. Basic now ignores files that aren't code, and writes no file names.
- 1 Pharo merge is of a solution that also holds a `TestResults.txt`. Basic ignores that file, and the code is the same as the other group's.

### The 27 tracks with a language of their own

These tracks have 96 splits and 97 merges.

The main causes of splits are:

- **C++ headers (7 splits).** One solution declares its functions in a header and defines them in a source file, and the other defines them in the header.
- **Real differences (24 splits, accepted).** The solutions are different programs that an old representer treated as the same, such as PHP's `!==` and `!=`, JavaScript's `toUpperCase` and `toLocaleUpperCase`, or a solution with an extra file.
- The rest are one-off cases, such as Elm's `100` and `100.0` (an Int and a Float) or Elixir code that uses a function from an `import` without its module's name.

The merges are all accepted. They are solutions with the same code, code that differs only in comments, formatting or imports, or code that differs only in names or in spellings that mean the same.

If the pinned grammar rejects a solution's code, the solution gets Basic's representation, so no solution in these tracks is unrepresentable.
Five solutions get Basic's representation this way: four in GDScript and one in C#.

### Per track

"Singles" counts the solutions that were alone in their production representation, "Exercises" the exercises they come from, and "Variants" the singles with a near-miss variant.

| Track | Representer | Solutions | Groups | Singles | Exercises | Variants | Splits | Merges | Unrepresentable | Near-miss merges |
|---|---|---|---|---|---|---|---|---|---|---|
| 8th | Basic | 166 | 22 | 100 | 65 | 94 | 4 | 0 | 0 | 0 |
| abap | Basic | 400 | 100 | 100 | 45 | 94 | 15 | 10 | 0 | 0 |
| arm64-assembly | Basic | 111 | 4 | 100 | 70 | 98 | 0 | 0 | 0 | 0 |
| arturo | Basic | 109 | 3 | 100 | 69 | 96 | 1 | 0 | 0 | 0 |
| awk | Basic | 202 | 34 | 100 | 69 | 100 | 18 | 2 | 0 | 0 |
| ballerina | Ballerina | 210 | 37 | 100 | 51 | 98 | 0 | 6 | 0 | 10 |
| bash | Basic | 379 | 93 | 100 | 60 | 93 | 7 | 1 | 0 | 0 |
| c | C | 394 | 98 | 100 | 69 | 100 | 0 | 1 | 0 | 0 |
| cairo | Cairo | 112 | 4 | 100 | 52 | 90 | 0 | 4 | 0 | 0 |
| cfml | Basic | 95 | 1 | 93 | 43 | 89 | 0 | 0 | 0 | 0 |
| clojure | Clojure | 361 | 87 | 100 | 71 | 98 | 5 | 11 | 0 | 0 |
| cobol | Basic | 193 | 31 | 100 | 42 | 100 | 10 | 0 | 0 | 0 |
| coffeescript | Basic | 139 | 13 | 100 | 80 | 97 | 6 | 0 | 0 | 0 |
| common-lisp | CommonLisp | 391 | 97 | 100 | 76 | 93 | 13 | 1 | 0 | 3 |
| cpp | Cpp | 397 | 99 | 100 | 76 | 100 | 7 | 0 | 0 | 0 |
| crystal | Crystal | 389 | 97 | 100 | 94 | 97 | 5 | 4 | 0 | 0 |
| csharp | CSharp | 397 | 99 | 100 | 98 | 96 | 1 | 1 | 0 | 0 |
| d | Basic | 127 | 9 | 100 | 62 | 100 | 5 | 0 | 0 | 0 |
| dart | Basic | 394 | 98 | 100 | 50 | 98 | 9 | 0 | 0 | 0 |
| elixir | Elixir | 397 | 99 | 100 | 100 | 96 | 7 | 0 | 0 | 0 |
| elm | Elm | 400 | 100 | 100 | 74 | 96 | 5 | 14 | 0 | 0 |
| emacs-lisp | Basic | 190 | 30 | 100 | 70 | 99 | 23 | 4 | 0 | 0 |
| erlang | Erlang | 397 | 99 | 100 | 63 | 100 | 1 | 6 | 0 | 0 |
| euphoria | Basic | 109 | 3 | 100 | 62 | 98 | 2 | 0 | 0 | 0 |
| factor | Factor | 146 | 16 | 100 | 100 | 84 | 0 | 5 | 0 | 0 |
| fortran | Basic | 130 | 10 | 100 | 38 | 100 | 1 | 0 | 0 | 0 |
| free-pascal | Basic | 103 | 1 | 100 | 90 | 96 | 1 | 0 | 0 | 0 |
| fsharp | FSharp | 397 | 99 | 100 | 87 | 94 | 1 | 7 | 0 | 0 |
| futhark | Basic | 103 | 1 | 100 | 80 | 100 | 0 | 0 | 0 | 0 |
| gdscript | GDScript | 103 | 1 | 100 | 74 | 98 | 0 | 0 | 0 | 0 |
| gleam | Gleam | 373 | 91 | 100 | 76 | 88 | 1 | 2 | 0 | 0 |
| go | Go | 363 | 88 | 100 | 78 | 99 | 16 | 0 | 0 | 0 |
| groovy | Basic | 235 | 45 | 100 | 57 | 94 | 13 | 1 | 0 | 0 |
| haskell | Haskell | 399 | 100 | 100 | 73 | 98 | 0 | 19 | 0 | 1 |
| idris | Basic | 132 | 11 | 100 | 53 | 92 | 2 | 1 | 0 | 0 |
| java | Java | 388 | 96 | 100 | 80 | 98 | 3 | 0 | 0 | 0 |
| javascript | JavaScript | 381 | 94 | 100 | 74 | 96 | 4 | 0 | 0 | 0 |
| jq | Basic | 400 | 100 | 100 | 62 | 100 | 69 | 0 | 0 | 0 |
| julia | Julia | 392 | 98 | 100 | 85 | 100 | 2 | 0 | 0 | 0 |
| kotlin | Basic | 388 | 96 | 100 | 71 | 95 | 25 | 0 | 0 | 0 |
| lean | Basic | 121 | 7 | 100 | 81 | 94 | 3 | 0 | 0 | 0 |
| lfe | Basic | 84 | 1 | 81 | 52 | 81 | 1 | 0 | 0 | 0 |
| lua | Lua | 331 | 77 | 100 | 72 | 95 | 0 | 7 | 0 | 0 |
| mips | Basic | 124 | 8 | 100 | 52 | 100 | 2 | 0 | 0 | 0 |
| moonscript | Basic | 100 | 0 | 100 | 99 | 98 | 0 | 0 | 0 | 0 |
| nim | Nim | 256 | 52 | 100 | 64 | 98 | 1 | 6 | 0 | 0 |
| ocaml | OCaml | 244 | 48 | 100 | 48 | 100 | 0 | 9 | 0 | 0 |
| odin | Basic | 160 | 20 | 100 | 65 | 100 | 3 | 0 | 0 | 3 |
| perl5 | Basic | 151 | 17 | 100 | 75 | 100 | 5 | 0 | 0 | 0 |
| pharo-smalltalk | Basic | 115 | 5 | 100 | 45 | 100 | 1 | 1 | 0 | 0 |
| php | PHP | 352 | 84 | 100 | 68 | 99 | 11 | 4 | 0 | 0 |
| powershell | Basic | 205 | 35 | 100 | 91 | 94 | 9 | 0 | 0 | 0 |
| prolog | Basic | 400 | 100 | 100 | 73 | 81 | 22 | 1 | 0 | 0 |
| purescript | Basic | 123 | 8 | 100 | 25 | 98 | 4 | 0 | 0 | 2 |
| pyret | Basic | 103 | 1 | 100 | 65 | 97 | 0 | 0 | 0 | 0 |
| python | Python | 397 | 99 | 100 | 92 | 100 | 4 | 0 | 0 | 0 |
| r | R | 391 | 97 | 100 | 71 | 98 | 0 | 3 | 0 | 0 |
| racket | Basic | 277 | 59 | 100 | 56 | 98 | 30 | 0 | 0 | 0 |
| raku | Raku | 128 | 12 | 92 | 59 | 83 | 0 | 3 | 0 | 0 |
| reasonml | Basic | 178 | 26 | 100 | 26 | 95 | 4 | 0 | 0 | 0 |
| red | Red | 190 | 30 | 100 | 45 | 100 | 0 | 0 | 0 | 0 |
| rescript | Basic | 45 | 1 | 42 | 22 | 39 | 1 | 0 | 0 | 0 |
| roc | Basic | 36 | 1 | 33 | 28 | 32 | 1 | 0 | 0 | 0 |
| ruby | Ruby | 379 | 93 | 100 | 85 | 100 | 7 | 0 | 0 | 2 |
| rust | Rust | 394 | 98 | 100 | 76 | 99 | 8 | 0 | 0 | 0 |
| scala | Scala | 362 | 89 | 100 | 59 | 97 | 0 | 6 | 0 | 0 |
| scheme | Basic | 238 | 46 | 100 | 46 | 99 | 32 | 0 | 0 | 0 |
| sml | Basic | 211 | 37 | 100 | 60 | 95 | 19 | 0 | 0 | 0 |
| sqlite | Basic | 328 | 76 | 100 | 63 | 100 | 38 | 11 | 0 | 0 |
| swift | Basic | 373 | 91 | 100 | 62 | 96 | 10 | 2 | 0 | 0 |
| tcl | Basic | 370 | 90 | 100 | 91 | 54 | 5 | 0 | 0 | 0 |
| typescript | TypeScript | 387 | 96 | 100 | 63 | 95 | 2 | 2 | 0 | 0 |
| uiua | Basic | 217 | 39 | 100 | 76 | 91 | 12 | 0 | 0 | 0 |
| unison | Basic | 115 | 5 | 100 | 43 | 97 | 0 | 0 | 0 | 0 |
| vbnet | Basic | 174 | 25 | 100 | 76 | 94 | 0 | 1 | 0 | 0 |
| vimscript | Basic | 124 | 8 | 100 | 68 | 96 | 0 | 0 | 0 | 0 |
| vlang | Basic | 193 | 31 | 100 | 83 | 98 | 11 | 0 | 0 | 0 |
| wasm | Wasm | 289 | 63 | 100 | 59 | 100 | 0 | 2 | 0 | 0 |
| wren | Wren | 217 | 39 | 100 | 82 | 99 | 2 | 9 | 0 | 0 |
| x86-64-assembly | Basic | 298 | 66 | 100 | 71 | 100 | 0 | 4 | 0 | 0 |
| yamlscript | Basic | 127 | 9 | 100 | 57 | 89 | 1 | 0 | 0 | 0 |
| zig | Zig | 382 | 94 | 100 | 63 | 96 | 0 | 17 | 0 | 0 |
