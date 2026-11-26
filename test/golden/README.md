# Golden data

This folder holds real solutions that students published on Exercism, for every track.
For each track there are up to 100 groups of solutions that production gave the same representation (usually three solutions each), and up to 100 solutions that production gave a representation of their own.
All of them passed the tests.

Two tests in [`test/golden_test.rb`](../golden_test.rb) run over every track:

1. **Representations stay the same.** Each solution gets exactly the representation in its `representation.txt`.
2. **Groups stay the same.** The groups that today's representations make are the groups these solutions were in on production, apart from the differences listed in the track's `differences.yml`.
   If a new difference appears, or a listed one stops happening, the test fails.

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
A difference already listed in `differences.yml` keeps its status and note.
A new one gets `status: undecided` and a note that says where the solutions differ.

`./bin/setup-hooks` installs a pre-commit hook ([`bin/pre-commit`](../../bin/pre-commit)).
If a commit changes a language's class, its library names or its grammar's pin, the hook regenerates that language's golden data.
If any golden file then changes, it will stop the commit until you stage the files.
The hook doesn't look at changes to the engine, which can change every language, so run `./bin/regenerate-golden` for those.
CI checks every track either way.

## Deciding on the differences

Each difference in `differences.yml` has a `status`.
It stays `undecided` until iHiD decides whether the difference is right (`accepted`) or a bug to fix (`rejected`).
A rejected difference stays listed until the fix lands, and the fix then removes it when the data is regenerated.

- A **split** is a production group whose solutions now get different representations.
  `solutions` lists the new groups.
  A split means a mentor's feedback will no longer reach some of the solutions it used to reach.
- A **merge** is a set of solutions from different production groups that now get the same representation.
  `solutions` lists them by production group.
  A merge means a mentor's feedback will now reach solutions it didn't reach before.
- An **unrepresentable** solution gets no representation today, although production gave it one.

## The differences today

The data holds 19,557 solutions in 82 tracks: 4,187 production groups of two or three solutions, and 7,017 solutions that were alone in their representation.
Compared with production, today's representer makes 774 splits and 128 merges, and 161 solutions get no representation.
Every difference is still `undecided`.

### The 59 tracks that use Basic

These tracks have 597 splits and 41 merges.
Production's basic representer deleted all whitespace and kept comments.
Today's Basic does the opposite: it keeps line breaks, the spaces between tokens and (in languages like Python) indentation, and it drops comments.

- 478 splits come from line breaks, 108 from spaces between tokens or inside strings, and 11 from indentation.
  Some of these are right: in Scheme, `(1- n)` and `(1 - n)` mean different things, and so do strings with different spaces.
- All 41 merges are solutions that differ only in comments and whitespace.

### The 23 tracks with a class of their own

These tracks have 177 splits, 87 merges and 161 unrepresentable solutions.

The main causes of splits are:

- **Names used by the tests (48 splits).** The representer keeps every name that appears anywhere in the exercise's files. So if one student calls a variable `input` and the tests also use `input`, that variable keeps its name, while another student's `s` gets a placeholder. Go (14), Ruby (7), Rust (6) and PHP (5) have the most.
- **Numbers (15 splits).** Numbers written differently stay different, such as Elixir's `41_000` and `41000`, or `0b10_000_000` and `128`.
- **File names (8 splits).** The representation includes each file's name, so a solution submitted before an exercise was renamed (such as `pop-count` to `eliuds-eggs`) splits from a newer one.
- **Elm parentheses (15 splits).** Elm keeps redundant parentheses, so `(modBy 2 n) + x` and `modBy 2 n + x` differ. A few more Elm splits come from the order of the names in `exposing`.
- **C++ preprocessor lines (13 splits).** The representation keeps each `#include`, include guard and `using` line, in order.
- **F# layout (about 10 splits).** The F# grammar builds a different tree for the same expression laid out differently, such as a pipeline split across lines.
- The rest are mostly code that really differs, which an old representer treated as the same (such as PHP's `!==` and `!=`, or JavaScript's `toUpperCase` and `toLocaleUpperCase`).

The merges are:

- 29 merges of solutions with the same code, or code that differs only in whitespace or comments. Production had them in separate groups, probably because they were represented by different versions.
- 58 merges of solutions that differ in local names or formatting, which the language's class now normalises. Zig (13), Nim (9), Clojure (7), F# (6), Wren (5), Raku (4) and WebAssembly (4) have the most.

The unrepresentable solutions are:

- **Rust (74), Zig (1) and WebAssembly (1).** These solutions include a file in another format (`Cargo.toml`, `HELP.md`, `README.md` or a `.txt` file). The website sends every solution file, and the representer parses all of them with the language's grammar, so the whole solution fails to parse.
- **Rewrite errors (Go 3, Rust 6).** In some solutions to `tournament` and `forth`, a string rewrite rule keeps matching its own output, and the representer raises an error. On production, these requests will fail.
- **C++ (2).** The stored file holds only the text `[Invalid Unicode]`.
- **Grammar gaps (74).** The pinned grammar rejects code that the track's tests accept: WebAssembly (41, mostly a folded `if` with no `then`), C++ (11, such as explicit template instantiations), GDScript (8, mixed tabs and spaces), Common Lisp (7, mostly `loop`) and F# (7).

### Java

Java has only 10 solutions that were alone in their representation, against about 90 in most tracks.
The script that picked these solutions sorted each track's single-solution representations by a seeded random score on `_seq_no`, which isn't spread evenly, so it picked representations from a narrow range of ids.
For Java, all 100 picks came from two exercises (89 from `protein-translation` and 11 from `nucleotide-count`), with ids from 2,084,963 to 2,087,699.
No published solution with passing tests points at any of the 89 `protein-translation` representations, so they were all dropped, along with one `nucleotide-count` one.
They look like representations made by a rerun of older submissions, which are no longer any solution's published representation.

### Per track

| Track | Representer | Solutions | Groups | Singles | Splits | Merges | Unrepresentable |
|---|---|---|---|---|---|---|---|
| 8th | Basic | 163 | 22 | 97 | 4 | 0 | 0 |
| abap | Basic | 400 | 100 | 100 | 15 | 11 | 0 |
| arm64-assembly | Basic | 104 | 4 | 93 | 0 | 0 | 0 |
| arturo | Basic | 100 | 3 | 91 | 1 | 0 | 0 |
| awk | Basic | 200 | 34 | 98 | 18 | 2 | 0 |
| ballerina | Basic | 210 | 37 | 100 | 12 | 0 | 0 |
| bash | Basic | 377 | 93 | 98 | 7 | 0 | 0 |
| c | Basic | 394 | 98 | 100 | 10 | 0 | 0 |
| cairo | Basic | 106 | 4 | 94 | 1 | 0 | 0 |
| cfml | Basic | 65 | 1 | 63 | 0 | 0 | 0 |
| clojure | Clojure | 344 | 87 | 83 | 8 | 10 | 0 |
| cobol | Basic | 191 | 31 | 98 | 10 | 0 | 0 |
| coffeescript | Basic | 124 | 13 | 85 | 6 | 0 | 0 |
| common-lisp | CommonLisp | 388 | 97 | 97 | 13 | 2 | 7 |
| cpp | Cpp | 382 | 99 | 85 | 14 | 0 | 13 |
| crystal | Crystal | 392 | 97 | 103 | 8 | 5 | 0 |
| csharp | CSharp | 391 | 99 | 94 | 7 | 0 | 0 |
| d | Basic | 125 | 9 | 98 | 5 | 0 | 0 |
| dart | Basic | 328 | 98 | 34 | 9 | 0 | 0 |
| elixir | Elixir | 394 | 99 | 97 | 15 | 0 | 0 |
| elm | Elm | 400 | 100 | 100 | 21 | 11 | 0 |
| emacs-lisp | Basic | 173 | 30 | 83 | 23 | 4 | 0 |
| erlang | Basic | 377 | 99 | 80 | 30 | 0 | 0 |
| euphoria | Basic | 109 | 3 | 100 | 2 | 0 | 0 |
| factor | Basic | 133 | 16 | 87 | 5 | 1 | 0 |
| fortran | Basic | 114 | 10 | 84 | 1 | 0 | 0 |
| free-pascal | Basic | 102 | 1 | 99 | 1 | 0 | 0 |
| fsharp | FSharp | 393 | 99 | 96 | 16 | 8 | 7 |
| futhark | Basic | 101 | 1 | 98 | 0 | 0 | 0 |
| gdscript | GDScript | 99 | 1 | 96 | 0 | 0 | 8 |
| gleam | Gleam | 346 | 91 | 73 | 1 | 2 | 0 |
| go | Go | 359 | 88 | 96 | 16 | 0 | 3 |
| groovy | Basic | 227 | 45 | 92 | 13 | 0 | 0 |
| haskell | Basic | 399 | 100 | 100 | 28 | 0 | 0 |
| idris | Basic | 114 | 11 | 82 | 2 | 1 | 0 |
| java | Java | 298 | 96 | 10 | 4 | 0 | 0 |
| javascript | JavaScript | 369 | 94 | 88 | 5 | 0 | 0 |
| jq | Basic | 392 | 100 | 92 | 69 | 0 | 0 |
| julia | Basic | 392 | 98 | 100 | 6 | 0 | 0 |
| kotlin | Basic | 372 | 96 | 84 | 25 | 0 | 0 |
| lean | Basic | 121 | 7 | 100 | 3 | 0 | 0 |
| lfe | Basic | 31 | 1 | 28 | 1 | 0 | 0 |
| lua | Basic | 289 | 77 | 58 | 9 | 1 | 0 |
| mips | Basic | 123 | 8 | 99 | 2 | 0 | 0 |
| moonscript | Basic | 93 | 0 | 93 | 0 | 0 | 0 |
| nim | Nim | 256 | 52 | 100 | 1 | 9 | 0 |
| ocaml | Basic | 219 | 48 | 75 | 23 | 0 | 0 |
| odin | Basic | 159 | 20 | 99 | 3 | 0 | 0 |
| perl5 | Basic | 130 | 17 | 79 | 5 | 0 | 0 |
| pharo-smalltalk | Basic | 115 | 5 | 100 | 1 | 0 | 0 |
| php | PHP | 331 | 84 | 79 | 11 | 4 | 0 |
| powershell | Basic | 205 | 35 | 100 | 9 | 0 | 0 |
| prolog | Basic | 400 | 100 | 100 | 22 | 0 | 0 |
| purescript | Basic | 87 | 8 | 64 | 4 | 0 | 0 |
| pyret | Basic | 95 | 1 | 92 | 0 | 0 | 0 |
| python | Python | 393 | 99 | 96 | 4 | 1 | 0 |
| r | Basic | 388 | 97 | 97 | 10 | 1 | 0 |
| racket | Basic | 261 | 59 | 84 | 30 | 2 | 0 |
| raku | Raku | 46 | 12 | 10 | 0 | 4 | 0 |
| reasonml | Basic | 178 | 26 | 100 | 4 | 0 | 0 |
| red | Basic | 183 | 30 | 93 | 6 | 0 | 0 |
| rescript | Basic | 45 | 1 | 42 | 1 | 0 | 0 |
| roc | Basic | 3 | 1 | 0 | 1 | 0 | 0 |
| ruby | Ruby | 368 | 93 | 89 | 10 | 0 | 0 |
| rust | Rust | 385 | 98 | 91 | 8 | 0 | 80 |
| scala | Basic | 347 | 89 | 85 | 32 | 0 | 0 |
| scheme | Basic | 230 | 46 | 92 | 32 | 0 | 0 |
| sml | Basic | 211 | 37 | 100 | 19 | 0 | 0 |
| sqlite | Basic | 328 | 76 | 100 | 38 | 10 | 0 |
| swift | Basic | 333 | 91 | 60 | 10 | 2 | 0 |
| tcl | Basic | 366 | 90 | 96 | 5 | 0 | 0 |
| typescript | TypeScript | 382 | 96 | 95 | 4 | 2 | 0 |
| uiua | Basic | 205 | 39 | 88 | 12 | 0 | 0 |
| unison | Basic | 94 | 5 | 79 | 0 | 0 | 0 |
| vbnet | Basic | 145 | 25 | 71 | 0 | 1 | 0 |
| vimscript | Basic | 110 | 8 | 86 | 0 | 0 | 0 |
| vlang | Basic | 188 | 31 | 95 | 11 | 0 | 0 |
| wasm | Wasm | 282 | 63 | 93 | 9 | 4 | 42 |
| wren | Wren | 207 | 39 | 90 | 2 | 11 | 0 |
| x86-64-assembly | Basic | 293 | 66 | 95 | 0 | 5 | 0 |
| yamlscript | Basic | 123 | 9 | 96 | 1 | 0 | 0 |
| zig | Zig | 362 | 94 | 80 | 0 | 14 | 1 |
