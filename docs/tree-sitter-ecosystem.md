# The tree-sitter ecosystem for Exercism's tracks

This file lists, for each of Exercism's 85 active tracks, which tree-sitter grammar exists, who owns it, whether it is actively maintained, which ABI it targets and whether nvim-treesitter ships it.

All data was pulled on 2026-11-26 through the GitHub API (read only), apart from the rows for Exercism's own grammar repos, which were pulled on 2026-11-28. "Last commit" is the last commit on the default branch. It is not the repo's `pushed_at` date, because many tree-sitter org repos show a push in September 2026 with no new commits on their main branch.

## Counts

| Rating | Tracks |
|---|---|
| Active | 64 |
| Slow but alive | 21 |
| Stale | 0 |
| None | 0 |

The ratings use each track's grammar, which is the one Inspector pins or, for a track with no Inspector language, the recommended one. The rule for each rating is:

- Active means a commit in the last 6 months and maintainers who respond.
- Slow but alive means a commit 6 to 24 months ago, or recent commits with no maintainer replies to the issues and PRs that came in.
- Stale means nothing for 24 months, or an archived repo.
- None means no grammar was found.

A repo with recent commits and no incoming issues or PRs counts as responsive, because nobody was waiting for a reply. "Maintainers responded" means a comment from an owner, member or collaborator, a merged PR, or a closed issue in the last 6 months, among each repo's 8 most recently updated issues and 8 most recently updated PRs. This test is rough. Ratings near a boundary deserve a second look before anyone depends on them.

## Parse rates

The Parse rate column shows one of two measures. For tracks whose grammar Inspector pins from golden data, it shows the share of the track's golden solutions (students' published solutions in `test/golden`) that parse, marked "golden". A rate marked "has_error" was measured with `ruby_tree_sitter`'s `root_node.has_error?`. The grammars pinned from Exercism's repos each parse 98% or more of their golden solutions.

For the other tracks, the column shows the share of the track's own example and exemplar solutions (every non-test file with the track's extension under `.meta/`, or `examples/` for PureScript) that parse with no `ERROR` or `MISSING` node. The count of files is in brackets. These tests used tree-sitter CLI 0.25.10. The grammars pinned by Inspector were tested at their pinned commit, and the others at their latest commit on 2026-11-26. The rate is the highest for a grammar in the table, and measures parsing of well-formed example code only. It does not measure the quality of node names or the stability of the tree shape, and student code will parse worse. The column says "not measured" for the 36 tracks that were not tested. The Notes column names the first construct that broke each failing file, so a file may contain more failing constructs.

## Tracks with no grammar, or a stale one

Every track has a grammar. Exercism's own repos supply the grammars for the tracks that had no usable upstream grammar (8th, euphoria, yamlscript, futhark, reasonml and uiua among them), so no track is rated None or Stale.

Tracks whose grammar is not in the Exercism org and has 2 stars or fewer: awk, factor, mips, odin, red and wren. Their rating can fall quickly if the one maintainer stops.

## Summary of the data

These counts cover the 85 rows of the table. Three rows (awk, cairo and factor) have no checked `highlights.scm` entry.

- 70 rows ship `queries/highlights.scm` and 12 do not.
- 53 of the 85 languages are in nvim-treesitter's main branch (not always the grammar Inspector pins). The master branch is frozen at 2026-03-23, and main was last updated on 2026-11-21. In main every parser has a tier (stable, unstable, unmaintained). Only three of the languages are marked unmaintained: gdscript, roc and unison. Only csharp and python are marked stable.
- 19 grammars have a committed `parser.c` at ABI 14 and 60 have one at ABI 15. libtree-sitter 0.25 loads ABI 13 to 15. Inspector's own requirement is ABI 15 (libtree-sitter 0.25), so ABI 14 grammars load, and the ones that need regenerating are easy to spot in the ABI column.
- 6 grammars do not commit `parser.c` and need `tree-sitter generate` at build time: abap, cfml, perl5, raku, sqlite and swift. For these the ABI column shows "gen", and the CLI version named in `package.json` decides the ABI.

## One row per track

The ABI column shows the `LANGUAGE_VERSION` in the committed `src/parser.c` (in the subfolder for typescript, php, ocaml, fsharp, prolog and vlang), or "gen" when there is none. Stars and commit counts are for the repo that the row names. For a row in the Exercism org, the grammar repo column also gives the first 12 characters of the commit that `grammars.yml` pins. The nvim-treesitter column describes the main branch.

| Track | Grammar repo | Owner type | Stars | Last commit | Commits in 12 months | ABI | highlights.scm | nvim-treesitter | Rating | Parse rate | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 8th | exercism/tree-sitter-8th (b7bef23effed) | Exercism org | 0 | 2026-11-28 | 2 | 15 | yes | no | Active | 100.0% (168/168) golden | Standalone repo. |
| abap | kennyhml/tree-sitter-abap | individual | 16 | 2026-09-24 | 549 | gen (CLI ^0.25.10) | yes | no | Slow but alive | 91% (52/57) | Single maintainer. Nearly all commits in the last 12 months are by one person, and recent commits come in large bursts (549 in 12 months). One open issue. Alternative: albertmink/tree-sitter-abap (1 star, 2 commits). Fails on named parameters inside inline calls (`substring( val = ... )`) and on `REPLACE ... REGEX`. |
| arm64-assembly | exercism/tree-sitter-arm64-assembly (014867d05aed) | Exercism org | 0 | 2026-11-28 | 1 | 15 | yes | yes (unstable) | Active | 100.0% (111/111) golden | Standalone repo. |
| arturo | exercism/tree-sitter-arturo (48de8dde9954) | Exercism org | 0 | 2026-11-28 | 1 | 15 | yes | no | Active | 100.0% (109/109) golden | Standalone repo. |
| awk | konomanoasa/tree-sitter-awk | individual | 0 | 2026-11-04 | 23 | 15 | not checked | no | Active | 98.9% (92/93) | MIT. Fails only on the regex `/^[-+*/]$/`. Alternative: Beaglefoot/tree-sitter-awk (26 stars, last commit 2024-11-02, ABI 14, in nvim-treesitter, Helix and Zed), 94.6% (88/93). It fails on regex literals with `/` or `[` inside a bracket expression, and on a bare `length < 10 { ... }` pattern. |
| ballerina | exercism/tree-sitter-ballerina (9d1468b6d19e) | Exercism org | 0 | 2026-11-26 | 2 | 15 | no | no | Active | not measured | Standalone repo with only a `main` branch. No `queries/highlights.scm`. |
| bash | exercism/tree-sitter-bash (b8b2d323be65) | Exercism org | 0 | 2026-11-28 | 17 | 15 | yes | yes (unstable) | Active | 100.0% (379/379) golden, has_error | Standalone repo with only a `main` branch. |
| batch | wharflab/tree-sitter-batch | community org | 15 | 2026-07-22 | 76 | 14 | yes | no | Slow but alive | 87% (20/23) | Half of the commits in the last 12 months are by renovate[bot]. One human maintainer. 11 open PRs. Not in nvim-treesitter. Alternative: davidevofficial/tree-sitter-batch (2 stars, last commit 2025-02-21). Fails on `set^` caret escapes, `!sqrt(n):...` delayed expansion and `if not defined a[%b%]`. |
| c | tree-sitter/tree-sitter-c | tree-sitter org | 396 | 2026-04-22 | 5 | 15 | yes | yes (unstable), but uses tree-sitter-grammars/tree-sitter-c | Slow but alive | 99% (152/154) | Official repo had 5 commits in the last 12 months, all by one person (clason). nvim-treesitter main now points to the tree-sitter-grammars fork, which is 2 commits ahead. Alternative: tree-sitter-grammars/tree-sitter-c (fork of the official repo, 2 commits ahead, used by nvim-treesitter main). The two failures are a macro used as a `for` header and `#undef` after a backslash-continued macro. Missing syntax: `_BitInt`, C23 enum underlying types, `_Thread_local` and `case a ... b:`. |
| cairo | starkware-libs/tree-sitter-cairo | company org | 10 | 2026-07-23 | 5 | 15 | not checked | no (nvim-treesitter uses the older fork) | Active | 100% (91/91) | Apache-2.0. Owned by StarkWare, which maintains Cairo. Used by Helix and Zed. Alternatives: tree-sitter-grammars/tree-sitter-cairo (3 stars, last commit 2024-04-27, ABI 14, in nvim-treesitter) and JoranHonig/tree-sitter-cairo (16 stars, 2022). Both parse 4.4% (4/91) because they predate Cairo 2 syntax (`pub`, `+Drop<T>`, `array!`). The tree-sitter-grammars repo is a fork whose original (archseer/tree-sitter-cairo) no longer resolves. |
| cfml | cfmleditor/tree-sitter-cfml | community org | 13 | 2026-10-31 | 534 | gen (CLI 0.27.0) | no | no | Active | not measured | Very active (329 commits in 6 months), but many recent commits are authored by an account called "claude". No committed parser.c (it needs `tree-sitter generate`), so ABI follows the CLI (0.27 in package.json). No queries folder found. Not in nvim-treesitter. |
| clojure | clj-commons/tree-sitter-clojure | community org | 191 | 2026-11-21 | 1 | 14 | yes | yes (unstable) | Active | not measured | The repo now lives at clj-commons/tree-sitter-clojure and sogaiu/ redirects to it. One commit in 12 months. Latest tag v0.0.13 (2024-05-15). |
| cobol | exercism/tree-sitter-cobol (4b625de31a84) | Exercism org | 0 | 2026-11-28 | 2 | 14 | no | no | Active | 100.0% (193/193) golden, has_error | Standalone repo with only a `main` branch. The symbol is `COBOL`. |
| coffeescript | exercism/tree-sitter-coffeescript (c194886fff1c) | Exercism org | 0 | 2026-11-28 | 1 | 15 | yes | no | Active | 100.0% (141/141) golden, has_error | Standalone repo. `parser.c` is 67 MB. |
| common-lisp | exercism/tree-sitter-commonlisp (20b268fe784f) | Exercism org | 0 | 2026-11-26 | 1 | 14 | no | yes (unstable) | Active | not measured | Standalone repo with only a `main` branch. Parses more `loop` forms and `defun` shapes found in student solutions than tree-sitter-grammars/tree-sitter-commonlisp, which parsed 95% (91/96) of the track's example solutions. |
| cpp | exercism/tree-sitter-cpp (331d4587452f) | Exercism org | 0 | 2026-09-17 | 4 | 15 | yes | yes (unstable) | Active | not measured | Fork of tree-sitter/tree-sitter-cpp. Parses braced default arguments, class template instantiations and a trailing space after `#include`. |
| crystal | exercism/tree-sitter-crystal (c463abd0a29c) | Exercism org | 0 | 2026-11-26 | 1 | 15 | no | no | Active | not measured | Standalone repo with only a `main` branch. Parses splats in array literals and capitalised class variables, which the upstream crystal-lang-tools/tree-sitter-crystal grammar does not (it parsed 99%, 144/145, of the track's example solutions). |
| csharp | tree-sitter/tree-sitter-c-sharp | tree-sitter org | 327 | 2026-11-18 | 41 | 15 | yes | yes (stable) | Active | not measured | Official org. Marked stable in nvim-treesitter main. 41 commits in 12 months. |
| d | gdamore/tree-sitter-d | individual | 67 | 2026-06-19 | 10 | 14 | yes | yes (unstable) | Active | not measured | Single main maintainer (gdamore). Latest tag v0.9.1 (2026-06-19). |
| dart | UserNobody14/tree-sitter-dart | individual | 108 | 2026-10-18 | 13 | 15 | yes | yes (unstable) | Active | not measured | Two live candidates. The original has 108 stars and 13 commits in 12 months, and nvim-treesitter uses it. The nielsenko repo is newer and much busier. Unsure which one to pick. Alternative: nielsenko/tree-sitter-dart (11 stars, 156 commits in 12 months, tag v0.3.0 2026-10-25). |
| delphi | Isopod/tree-sitter-pascal | individual | 81 | 2026-11-22 | 11 | 14 | yes | yes (unstable) | Active | not measured | Unsure which to pick. The Pascal grammar is the established one and covers Free Pascal and Delphi syntax. A Delphi-only grammar exists but is brand new. Alternative: Alexl-git/tree-sitter-delphi13 (4 stars, 311 commits in 12 months, most by an account named delphi13-fresh). |
| elixir | elixir-lang/tree-sitter-elixir | language org | 287 | 2026-10-20 | 9 | 14 | yes | yes (unstable) | Active | not measured | Owned by the elixir-lang org. 9 commits in 12 months, release v0.3.5 (2026-03-02). ABI 14. |
| elm | elm-tooling/tree-sitter-elm | community org | 87 | 2026-07-20 | 34 | 15 | yes | yes (unstable) | Active | not measured | Revived in the last year (34 commits, release v5.9.4 on 2026-07-08). |
| emacs-lisp | Wilfred/tree-sitter-elisp | individual | 84 | 2026-08-18 | 38 | 15 | yes | no | Active | not measured | Not in nvim-treesitter (maps to the name elisp). Most recent commits are by an account called "claude" (28 of 38 in 12 months). Single human maintainer. |
| erlang | WhatsApp/tree-sitter-erlang | company org | 97 | 2026-11-18 | 30 | 15 | yes | yes (unstable) | Active | not measured | Owned by the WhatsApp org. Release 0.22.0 on 2026-11-18. Main author is alanz. |
| euphoria | exercism/tree-sitter-euphoria (df98821f1955) | Exercism org | 0 | 2026-11-28 | 1 | 15 | yes | no | Active | 100.0% (109/109) golden | Standalone repo. |
| factor | erochest/tree-sitter-factor | individual | 1 | 2025-01-12 | 0 | 14 | not checked | no | Slow but alive | 97.0% (161/166) | No licence stated, so forking it is legally unclear. Fails on a multi-line `USING:` list, `B{` byte arrays and `:> ( a b )` local bindings. Alternative: razetime/tree-sitter-factor (2 stars, last commit 2022-09-16, ABI 13), 44.0% (73/166). It fails on `TUPLE:`, `ERROR:` and `CONSTANT:` declarations. nvim-treesitter has a different grammar called forth (AlexanderBrevig/tree-sitter-forth), which is not Factor. |
| fortran | stadelmanma/tree-sitter-fortran | individual | 55 | 2026-11-12 | 97 | 15 | yes | yes (unstable) | Active | not measured | 97 commits in 12 months. Tag v0.6.0 (2026-04-24). CLI pinned exactly (==0.26.3). |
| free-pascal | exercism/tree-sitter-pascal (f32cfad6c630) | Exercism org | 0 | 2026-11-22 | 11 | 15 | yes | yes (unstable) | Active | 99.0% (102/103) golden, has_error | Fork of Isopod/tree-sitter-pascal. Adds the nodes `range`, `kPow` and `kOtherwise`. |
| fsharp | exercism/tree-sitter-fsharp (7f7bd5cf766f) | Exercism org | 0 | 2026-11-24 | 85 | 15 | yes | yes (unstable) | Active | not measured | Fork of ionide/tree-sitter-fsharp. The grammar is in the `fsharp/` subfolder. Fixes three parse errors found in student solutions. |
| futhark | exercism/tree-sitter-futhark (c6c76dfa17f0) | Exercism org | 0 | 2026-11-28 | 1 | 15 | yes | no | Active | 100.0% (103/103) golden | Standalone repo. |
| gdscript | PrestonKnopp/tree-sitter-gdscript | individual | 122 | 2026-10-21 | 32 | 14 | no | yes (unmaintained) | Active | not measured | nvim-treesitter main marks it unmaintained (tier 3), yet the repo has had 32 commits in 12 months, mostly by NathanLovato, who is not the repo owner. No queries folder in the repo itself. Already pinned by Inspector. |
| gleam | gleam-lang/tree-sitter-gleam | language org | 107 | 2026-09-18 | 24 | 15 | yes | yes (unstable) | Active | not measured | Owned by the gleam-lang org. Release v1.1.0 (2025-07-21). 24 commits in 12 months. |
| go | tree-sitter/tree-sitter-go | tree-sitter org | 425 | 2025-09-15 | 0 | 15 | yes | yes (unstable) | Slow but alive | 100% (310/310) | Official org. Last commit 2025-09-15, release v0.25.0 (2025-08-29). No commits in 14 months. Already pinned by Inspector. Missing syntax: `new(expr)` (Go 1.26) and type parameters on methods. |
| groovy | exercism/tree-sitter-groovy (a780a4d77313) | Exercism org | 0 | 2026-11-28 | 554 | 15 | no | yes (unstable) | Active | 100.0% (237/237) golden | Fork of dekobon/tree-sitter-groovy. |
| haskell | tree-sitter/tree-sitter-haskell | tree-sitter org | 189 | 2026-09-30 | 12 | 15 | yes | yes (unstable), but uses tree-sitter-grammars/tree-sitter-haskell | Active | not measured | Official repo has 12 commits in 12 months, mostly by amaanq. nvim-treesitter main points at a fork that has diverged from it. Alternative: tree-sitter-grammars/tree-sitter-haskell (fork, diverged: 9 commits ahead and 12 behind, 1 star, used by nvim-treesitter main). |
| idris | kayhide/tree-sitter-idris | individual | 16 | 2026-10-26 | 10 | 15 | yes | yes (unstable) | Active | not measured | Single maintainer. 10 commits in 12 months, release v0.1.0 (2026-10-26). |
| java | tree-sitter/tree-sitter-java | tree-sitter org | 279 | 2025-09-15 | 0 | 14 | yes | yes (unstable) | Slow but alive | 100% (232/232) | Official org. Last commit 2025-09-15, release v0.23.5 (2024-12-21). ABI 14. Already pinned by Inspector. Missing syntax: `import module` and statements before `super()` (both Java 25). |
| javascript | tree-sitter/tree-sitter-javascript | tree-sitter org | 497 | 2025-09-15 | 0 | 15 | yes | yes (unstable) | Slow but alive | 100% (171/171) | Official org. Last commit 2025-09-15, release v0.25.0 (2025-09-01). Already pinned by Inspector. Missing syntax: a `using` declaration in a `for (;;)` initialiser. |
| jq | nverno/tree-sitter-jq | individual | 8 | 2025-02-26 | 0 | 15 | yes | no (nvim-treesitter uses flurie) | Slow but alive | 99% (77/78) | Alternative: flurie/tree-sitter-jq (34 stars, last commit 2025-05-10, ABI 13, in nvim-treesitter), 86% (67/78). It fails on function definitions that end in `;`, multi-line strings and quoted object keys, and has 4 open issues and 3 open PRs with no replies. |
| julia | tree-sitter/tree-sitter-julia | tree-sitter org | 130 | 2025-11-08 | 0 | 15 | yes | yes (unstable), but uses tree-sitter-grammars/tree-sitter-julia | Slow but alive | 98% (145/148) | Official repo last commit 2025-11-08. nvim-treesitter main points at a fork that has diverged from it. Alternative: tree-sitter-grammars/tree-sitter-julia (diverged fork: 14 commits ahead, 10 behind, used by nvim-treesitter main). Fails on `f(x)y`, a `$$` splice and `n ÷`. The nvim-treesitter fork fails the same three files. |
| kotlin | fwcd/tree-sitter-kotlin | individual | 199 | 2026-10-31 | 135 | 14 | yes | yes (unstable) | Active | not measured | One main contributor (VladimirMakaev, 77 of 100 recent commits). Last release 0.3.8 (2024-08-03). ABI 14. Alternative: tree-sitter-grammars/tree-sitter-kotlin (8 stars). |
| lean | exercism/tree-sitter-lean4 (8791a430f01b) | Exercism org | 0 | 2026-11-28 | 1 | 15 | yes | no | Active | 100.0% (121/121) golden, has_error | Standalone repo. |
| lfe | exercism/tree-sitter-lfe (dab716929a35) | Exercism org | 0 | 2026-11-28 | 1 | 15 | yes | no | Active | 100.0% (84/84) golden | Standalone repo with only a `main` branch. |
| lua | tree-sitter-grammars/tree-sitter-lua | tree-sitter-grammars org | 106 | 2026-02-26 | 16 | 15 | yes | yes (unstable) | Slow but alive | 100% (126/126) | Last commit 2026-02-26 (release v0.5.0). Single main committer (clason). Alternative: MunifTanjim/tree-sitter-lua (fork, 1 star, older). Lua 5.4 syntax parses. LuaJIT extensions are missing. |
| mips | omeyenburg/tree-sitter-mips | individual | 1 | 2026-03-22 | 13 | 14 | yes | no | Slow but alive | disputed (97.3% or 0%) | 1 star. 10 of 13 recent commits are by github-actions[bot]. Last human commit 2026-03. Alternative: cknacayama/tree-sitter-mips (2 stars, last commit 2024-04-30). Two parse runs disagree: 73 of 75 files passed in one and 0 of 75 in the other. The cause was not found, so rerun it before relying on either number. The failures seen in the 97.3% run were `mfhi $t1,` and one multi-line `.word` list. The failures in the 0% run were `.globl`, `.eqv`, dot-prefixed labels and `'\n'` characters. cknacayama and RosieTheGhostie parse 0%, and the generic RubixDev asm grammar parses 4.0% (3/75). |
| moonscript | exercism/tree-sitter-moonscript (a5be2aa8cabe) | Exercism org | 0 | 2026-11-28 | 1 | 15 | yes | no | Active | 100.0% (112/112) golden, has_error | Standalone repo. `parser.c` is 51 MB. |
| nim | alaviss/tree-sitter-nim | individual | 61 | 2026-07-03 | 7 | 14 | yes | yes (unstable) | Active | not measured | Last release 0.6.2 (2024-07-11). 7 commits in 12 months, 4 of them dependabot. Already pinned by Inspector. |
| objective-c | tree-sitter-grammars/tree-sitter-objc | tree-sitter-grammars org | 42 | 2025-01-31 | 0 | 14 | yes | yes (unstable) | Slow but alive | 92% (94/102) | Last commit 2025-01-31. No commits in 12 months. All 8 failures are Foundation macros (`NS_ENUM`, `NS_OPTIONS`, `NS_ASSUME_NONNULL_BEGIN`). Four open issues describe them and nobody has replied. |
| ocaml | tree-sitter/tree-sitter-ocaml | tree-sitter org | 101 | 2026-11-07 | 26 | 15 | yes | yes (unstable) | Active | not measured | Official org. Grammar lives in `grammars/ocaml`. 26 commits in 12 months, mostly by 314eter. |
| odin | BradLewis/tree-sitter-odin (91ecbcc509a1) | individual | 1 | 2026-10-11 | 4 | 14 | yes | yes (unstable) | Slow but alive | 99.4% (159/160) golden | Single maintainer. Alternative: tree-sitter-grammars/tree-sitter-odin (42 stars, last commit 2025-01-12, ABI 14), which fails on procedures with several return values (`-> (int, Error)`) and parsed 82% (60/73) of the track's example solutions. |
| perl5 | tree-sitter-perl/tree-sitter-perl | community org | 62 | 2026-11-20 | 177 | gen (CLI ^0.26.0) | yes | yes (unstable) | Active | not measured | Owned by the tree-sitter-perl org. 177 commits in 12 months, many authored by an account called "claude". No committed parser.c, so ABI follows the CLI (^0.26) when generated. Alternative: ganezdragon/tree-sitter-perl (38 stars, last commit 2026-04-12, 17 commits in 12 months). |
| pharo-smalltalk | exercism/tree-sitter-pharo-smalltalk (53722ebc287e) | Exercism org | 0 | 2026-11-28 | 1 | 15 | yes | no | Active | 100.0% (139/139) golden | Standalone repo. |
| php | tree-sitter/tree-sitter-php | tree-sitter org | 234 | 2026-11-19 | 32 | 15 | yes | yes (unstable) | Active | not measured | Official org. Grammar lives in the `php/` subfolder. Release v0.25.2 (2026-11-19). 22 commits in 6 months. |
| powershell | exercism/tree-sitter-powershell (0ba26ce9fad2) | Exercism org | 0 | 2026-10-18 | 90 | 15 | yes | yes (unstable) | Active | 100.0% (205/205) golden | Fork of woodruffw-trough/tree-sitter-powershell. `parser.c` is 51 MB (12.9 MB compiled). |
| prolog | exercism/tree-sitter-prolog (2bce045d33d7) | Exercism org | 0 | 2026-11-28 | 3 | 15 | no | no | Active | 99.8% (399/400) golden | Standalone repo with only a `main` branch. The grammar is in the `grammars/prolog/src` folder, with symbol `prolog`. |
| purescript | postsolar/tree-sitter-purescript | individual | 23 | 2025-06-17 | 0 | 15 | yes | yes (unstable) | Slow but alive | 97% (31/32) | Last commit 2025-06-17. 6 open issues. The one failure is an as-pattern (`y@(Open c)`), open as an issue since 2026-01. |
| pyret | exercism/tree-sitter-pyret (761e2ccf98f9) | Exercism org | 0 | 2026-11-28 | 1 | 15 | no | no | Active | 100.0% (111/111) golden | Standalone repo with only a `main` branch. |
| python | tree-sitter/tree-sitter-python | tree-sitter org | 575 | 2025-09-15 | 0 | 15 | yes | yes (stable) | Slow but alive | 100% (165/165) | Official org. Marked stable in nvim-treesitter main. Last commit 2025-09-15, release v0.25.0 (2025-09-11). Already pinned by Inspector. Missing syntax: type parameter defaults (3.13), `lazy import` and unpacking comprehensions (3.15). t-strings and `except A, B` parse. |
| r | r-lib/tree-sitter-r | community org | 155 | 2026-06-22 | 16 | 14 | yes | yes (unstable) | Active | not measured | Owned by the r-lib org. 16 commits in 12 months, mostly DavisVaughan. Release v1.3.0 (2026-06-19). ABI 14. |
| racket | 6cdh/tree-sitter-racket | individual | 37 | 2026-08-22 | 15 | 15 | yes | yes (unstable) | Active | not measured | Single maintainer (6cdh). Tag v0.25.0 (2026-08-22). |
| raku | exercism/tree-sitter-raku (29ad91a0ed34) | Exercism org | 0 | 2026-11-26 | 3 | gen | yes | no | Active | not measured | Standalone repo with only a `main` branch. Parses more operators and method calls found in student solutions than rexylic/tree-sitter-raku, the only upstream Raku grammar that parses real code (69.2%, 72/104 example solutions). Generates `parser.c` at build time. No licence is stated. |
| reasonml | exercism/tree-sitter-reasonml (04252fee1ea6) | Exercism org | 0 | 2026-11-28 | 1 | 15 | yes | no | Active | 100.0% (178/178) golden | Standalone repo. |
| red | red/tree-sitter-red | language org | 2 | 2026-03-12 | 54 | 15 | yes | no | Slow but alive | 100% (52/52) | Chosen: this grammar. Owned by the red org itself, with Apache-2.0 and 7 query files. Single author (qtxie), last commit 2026-03-12, no commits in the last 6 months. No tags. Not in nvim-treesitter. Zed uses it through qtxie/tree-sitter-red. |
| rescript | rescript-lang/tree-sitter-rescript | language org | 62 | 2026-11-15 | 55 | 15 | yes | yes (unstable) | Active | not measured | Owned by the rescript-lang org. Release v6.0.0 (2026-04-26). 12 commits in 6 months. |
| roc | faldor20/tree-sitter-roc | individual | 59 | 2026-11-08 | 45 | 15 | yes | yes (unmaintained) | Active | not measured | nvim-treesitter main marks it unmaintained (tier 3), but the repo had 24 commits in 6 months. No tags. |
| ruby | tree-sitter/tree-sitter-ruby | tree-sitter org | 229 | 2026-03-10 | 3 | 14 | yes | yes (unstable) | Slow but alive | 99% (134/135) | Official org. 3 commits in 12 months, latest release v0.23.1 (2024-11-11). ABI 14. Already pinned by Inspector. The one failure is a one-line `def` with a command call. Lines that begin with `\|\|`, `and` or `or` (Ruby 4.0) do not continue the previous line. |
| rust | tree-sitter/tree-sitter-rust | tree-sitter org | 538 | 2026-03-27 | 8 | 15 | yes | yes (unstable) | Slow but alive | 99% (116/117) | Official org. 8 commits in 12 months, release v0.24.2 (2026-03-27). Already pinned by Inspector. The one failure is `dyn 'a + Trait`. `safe fn` in `unsafe extern` and macros named like primitive types fail. Let chains, async closures and `use<...>` parse. |
| scala | tree-sitter/tree-sitter-scala | tree-sitter org | 200 | 2026-11-26 | 543 | 15 | yes | yes (unstable) | Active | not measured | Official org. Very active (428 commits in 6 months, release v0.26.14 on 2026-11-26). |
| scheme | 6cdh/tree-sitter-scheme | individual | 52 | 2026-10-12 | 42 | 15 | yes | yes (unstable) | Active | not measured | Single maintainer (6cdh). Tag v0.25.0 (2026-10-12). |
| sml | MatthewFluet/tree-sitter-sml | individual | 15 | 2025-05-22 | 0 | 15 | yes | no | Slow but alive | 100% (92/92) | Last commit 2025-05-22, no commits in 12 months. Not in nvim-treesitter. Alternative: stonebuddha/tree-sitter-sml (25 stars, last commit 2022-01-14, ABI 10). |
| sqlite | exercism/tree-sitter-sql (451110de1fa5) | Exercism org | 0 | 2026-11-10 | 103 | gen | yes | yes (unstable) | Active | 100.0% (328/328) golden, has_error | Fork of DerekStride/tree-sitter-sql. Generates `parser.c` at build time (about 5 minutes, 47 MB). A general SQL grammar, not specific to SQLite. |
| swift | alex-pinkus/tree-sitter-swift | individual | 225 | 2026-11-26 | 87 | gen (CLI ^0.23) | yes | yes (unstable) | Active | not measured | Individual maintainer, no org. 61 commits in 6 months, release 0.7.4. The official tree-sitter/tree-sitter-swift is archived (last commit 2022). No committed parser.c, it is generated at build time. |
| tcl | exercism/tree-sitter-tcl (d383c5f8a63c) | Exercism org | 0 | 2026-11-09 | 17 | 15 | no | yes (unstable) | Active | 99.5% (369/371) golden | Fork of tree-sitter-grammars/tree-sitter-tcl. |
| typescript | tree-sitter/tree-sitter-typescript | tree-sitter org | 537 | 2025-01-30 | 0 | 14 | yes | yes (unstable) | Slow but alive | 99% (112/113) | Official org. Grammar lives in the `typescript/` subfolder. Last commit 2025-01-30, release v0.23.2 (2024-11-11). ABI 14. Already pinned by Inspector. The one failure reads `i < x.length` in a `for` header as type arguments. Missing syntax: `in`/`out` variance annotations (TS 4.7) and `export type * as N`. |
| uiua | exercism/tree-sitter-uiua (d38adee3ee80) | Exercism org | 0 | 2026-11-28 | 1 | 15 | yes | no | Active | 100.0% (217/217) golden | Standalone repo. |
| unison | exercism/tree-sitter-unison (6663e840ede6) | Exercism org | 0 | 2026-10-19 | 125 | 15 | yes | yes (unmaintained) | Active | 99.1% (114/115) golden, has_error | Fork of kylegoetz/tree-sitter-unison. Calls are flat, with no call node. |
| vbnet | exercism/tree-sitter-vbnet (65244c298ac5) | Exercism org | 0 | 2026-11-27 | 35 | 15 | yes | no | Active | 100.0% (174/174) golden | Fork of alfpricot/tree-sitter-vbnet. Inspector builds from the committed `parser.c`. |
| vimscript | exercism/tree-sitter-vim (5e7643b3f507) | Exercism org | 0 | 2026-07-12 | 21 | 15 | no | yes (unstable) | Active | 98.4% (122/124) golden, has_error | Fork of tree-sitter-grammars/tree-sitter-vim. Vim9 code parses only shallowly. |
| vlang | vlang/v-analyzer | language org | 206 | 2026-11-02 | 13 | 15 | no | yes (unstable) | Active | not measured | The grammar is a subfolder (`tree_sitter_v`) of the v-analyzer language server, which is what nvim-treesitter uses. 13 commits in 12 months, none about the grammar specifically. Release tags are for the language server. Alternative: nedpals/tree-sitter-v (24 stars, last commit 2022-10-30, ABI 13). |
| wasm | exercism/tree-sitter-wat (afe87728c821) | Exercism org | 0 | 2026-11-26 | 20 | 15 | yes | no | Active | not measured | Standalone repo with only a `main` branch. Adds the folded `if` shorthand that wabt 1.0.32 accepts (`(if c t)` and `(if c t e)`), with the same tree as the spec form with `(then ...)`. It is based on g-plane/tree-sitter-wat, which parsed 98.9% (86/87) of the track's example solutions. |
| wren | jossephus/tree-sitter-wren | individual | 1 | 2026-02-28 | 7 | 15 | yes | no | Slow but alive | 100% (313 of 313 real solutions) at the pinned commit, which is the latest | 1 star, single author. Last commit 2026-02-28. Already pinned by Inspector. Not in nvim-treesitter. The pinned commit is the latest, and it parses all 121 files. Alternatives: jlcrochet/tree-sitter-wren (88.4%) and hgmich/wren-tree-sitter (88.4%). |
| x86-64-assembly | exercism/tree-sitter-x86-64-assembly (315c828c8392) | Exercism org | 0 | 2026-11-28 | 1 | 15 | yes | yes (unstable) | Active | 100.0% (298/298) golden | Standalone repo. |
| yamlscript | exercism/tree-sitter-yamlscript (b917e2abe2f1) | Exercism org | 0 | 2026-11-28 | 1 | 15 | yes | no | Active | 100.0% (127/127) golden, has_error | Standalone repo. |
| zig | exercism/tree-sitter-zig (f04eb963fee5) | Exercism org | 0 | 2026-11-26 | 1 | 14 | yes | yes (unstable) | Active | not measured | Standalone repo with only a `main` branch. Parses destructuring declarations and assignments, which the nvim-treesitter grammar (tree-sitter-grammars/tree-sitter-zig) does not. Both parsed 100% (104/104) of the track's example solutions. |
## Language name mappings

- csharp is `c_sharp` in nvim-treesitter and `c-sharp` in the repo name.
- common-lisp is `commonlisp` (Inspector calls it `common_lisp`).
- emacs-lisp is `elisp`. nvim-treesitter does not have it.
- perl5 is `perl`. raku is a separate grammar, and nvim-treesitter does not have it.
- vimscript is `vim`, in the `tree-sitter-grammars/tree-sitter-vim` repo.
- objective-c is `objc`.
- free-pascal and delphi both use `pascal`. Inspector has a language for free-pascal only.
- wasm is `wat` (Inspector's name too).
- vlang is `v`, and it lives inside the `vlang/v-analyzer` repo.
- sqlite uses `sql`, a general SQL grammar, in Exercism's fork of DerekStride/tree-sitter-sql.
- arm64-assembly and x86-64-assembly each use their own Exercism grammar. nvim-treesitter ships the generic `asm` grammar and `nasm`, which Inspector does not use.
- reasonml has no `reason` entry in nvim-treesitter. nvim-treesitter's `ocaml` is for OCaml syntax only.
- pharo-smalltalk uses Exercism's `pharo_smalltalk` grammar. nvim-treesitter has no Pharo grammar.
- factor has nothing in nvim-treesitter. Its `forth` parser is a different language.

## Risks

Tracks where the choice of grammar is unclear:

- dart (two live repos, the established one and a much busier newer one)
- delphi (Inspector pins Exercism's Pascal fork for free-pascal, and a Delphi-only grammar exists but is new)

Grammars that depend on one maintainer, where over 70% of the last 100 commits in 12 months came from one human: abap, red, scheme, racket, idris, kotlin, roc, wren, erlang, php, ocaml, r, gdscript, rust and the tree-sitter-grammars repos that clason maintains (c and lua). Several official tree-sitter org repos (c, cpp, ruby, rust, haskell, php) also have only 1 to 4 committers in the last 12 months, and the same names (maxbrunsfeld, amaanq, clason) appear across several of them. If a few people leave, many grammars could go quiet together.

Forks and moves:

- nvim-treesitter main now points c, julia and haskell at `tree-sitter-grammars` repos. The c fork is 2 commits ahead of `tree-sitter/tree-sitter-c`. The julia and haskell forks have diverged from the official repos (14 ahead and 10 behind for julia, 9 ahead and 12 behind for haskell). Inspector pins the official `tree-sitter` repos for the languages it already has, so the choice of repo matters for these three.
- tree-sitter-grammars/tree-sitter-cairo is a fork of a repo that doesn't exist any more. The recommended grammar is the StarkWare one.
- Zig: Inspector pins Exercism's standalone repo `exercism/tree-sitter-zig`. `maxxnino/tree-sitter-zig` is archived (last commit 2024-10-13, ABI 14), and nvim-treesitter uses `tree-sitter-grammars/tree-sitter-zig` (ABI 15, last commit 2025-09-10).
- The official `tree-sitter/tree-sitter-swift` is archived. nvim-treesitter and everyone else use `alex-pinkus/tree-sitter-swift`.
- The clojure repo has moved to `clj-commons/tree-sitter-clojure`, and `sogaiu/` still redirects to it.

Grammars already pinned by Inspector that are stale or at risk:

- wasm: the pin is Exercism's standalone repo `exercism/tree-sitter-wat`, based on `g-plane/tree-sitter-wat` (ABI 15), which adds wabt's folded `if` shorthand. The alternative, wasm-lsp/tree-sitter-wasm, had its last commit on 2022-05-17, targets ABI 13 and has 8 open PRs.
- zig: the pin is Exercism's standalone repo (see above). The archived maxxnino grammar and the nvim-treesitter one both parse all 104 solutions.
- wren: 1 star, one author, last commit 2026-02-28. The pinned commit is the latest, and it parses all 313 real solutions in the golden data.
- raku: the pin is Exercism's standalone repo, which is based on rexylic/tree-sitter-raku (0 stars, first commit 2026-10-23). rexylic's grammar is the only upstream Raku grammar that parses real code (69.2%).
- gdscript: marked unmaintained in nvim-treesitter. The repo still gets commits, mostly from a contributor who is not the owner.
- crystal: no commits since 2025-10-12 and 6 open issues without replies.
- go, java, javascript, python, ruby, typescript, rust, common-lisp and nim have no commit in the last 6 months. These are mature official grammars, and the pins make updates deliberate, so this is low risk. Ruby (ABI 14), Java (14) and TypeScript (14) have not been regenerated for ABI 15 yet. They parse 99% to 100% of their track's solutions, but each lacks some syntax from the last two releases of its language (see the Notes column).

Other risks:

- Three grammars have many recent commits authored by an account named "claude" (cfml, perl5 and emacs-lisp). Their activity numbers are high, and the grammar may change a lot between pins.
- Two grammars are generic and do not match the track: sqlite (general SQL) and delphi (Pascal). A tree-sitter grammar for these tracks will parse more than the track teaches, or fail on the track's dialect.
- Few grammars belong to the language's own organisation. Of the 85 repos, 34 belong to the Exercism org, 22 to individuals, 16 to the tree-sitter or tree-sitter-grammars orgs, 6 to community orgs, 5 to a language org (elixir-lang, gleam-lang, rescript-lang, red, vlang) and 2 to a company.
- 12 of the 85 grammars have no `queries/highlights.scm`. Inspector's tree-sitter prototype relies on each grammar's own `highlights.scm` and `locals.scm`, so these tracks need their queries written.
- Release tags are rare, so Inspector pins every grammar to a commit.

## Sources

All accessed on 2026-11-26 unless noted.

- Parse rates: each track's `exercism/<track>` repo, with the solutions under `.meta/` parsed by tree-sitter CLI 0.25.10 (see Parse rates). Alternative grammars were found through GitHub, Codeberg and sourcehut searches, nvim-treesitter `main`, Helix `languages.toml` and the Zed extension registry.

- `grammars.yml` in `~/Code/exercism/inspector` (82 pinned grammars), and the golden parse rates of the Exercism grammars measured on 2026-11-28 with `ruby_tree_sitter` against `test/golden`.
- nvim-treesitter `lockfile.json` and `lua/nvim-treesitter/parsers.lua` on the `master` branch, and `lua/nvim-treesitter/parsers.lua` and `SUPPORTED_LANGUAGES.md` on `main` (github.com/nvim-treesitter/nvim-treesitter). The master branch has been frozen since 2026-03-23.
- The repo lists of the `tree-sitter` and `tree-sitter-grammars` GitHub orgs (`gh api orgs/<org>/repos`).
- GitHub repository searches for `tree-sitter-<name>` for every track without a match in the lists above.
- Per grammar repo: the GitHub GraphQL API for stars, archived state, last commit, commits in the last 6 and 12 months, release and tag, open issues and PRs, recent issue and PR comments, and the presence of `queries/highlights.scm`, `tree-sitter.json` and `package.json`. The raw `src/parser.c` header on raw.githubusercontent.com for `LANGUAGE_VERSION`.
- The GitHub compare API for the fork checks (c, julia, haskell, vim).
- README files of RubixDev/tree-sitter-asm, PhilippReinke/tree-sitter-arm64 and naclsn/tree-sitter-nasm.
