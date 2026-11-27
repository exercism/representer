# Exercism's Representer

![Tests](https://github.com/exercism/representer/workflows/Test/badge.svg)

This is Exercism's representer.
It takes a solution and turns it into a normalised representation, so that solutions which differ only in formatting, comments and the names the student chose get the same representation.
The website groups solutions by their representation, and shows a mentor's feedback on one solution to every later solution in the same group.

It runs as an AWS Lambda function behind Exercism's internal load balancer.
One service handles every track.
These languages have a class of their own, and the representer parses them with [tree-sitter][tree-sitter]: Ballerina, C#, C++, Cairo, Clojure, Common Lisp, Crystal, Elixir, Elm, F#, Factor, GDScript, Gleam, Go, Java, JavaScript, Nim, PHP, Python, Raku, Red, Ruby, Rust, TypeScript, WebAssembly, Wren and Zig.

Every other track gets a simpler token-based representation called Basic.

## The request and response

The website POSTs JSON like this:

```json
{
  "track_slug": "ruby",
  "exercise_slug": "two-fer",
  "outputs": ["representation", "snippet"],
  "solution_files": { "two_fer.rb": "def two_fer(name = 'you')\n ...\nend\n" },
  "exercise_files": { "two_fer_test.rb": "...", ".meta/config.json": "..." }
}
```

- `outputs` lists what to generate, as one or more of `representation`, `snippet` and `analysis`. The representer only runs the steps needed for these outputs.
- `solution_files` are the student's files.
- `exercise_files` are the exercise's test files and stub. The languages written with the rule DSL use them to find the names used in the tests, so that they keep those names. C#, Elixir, F# and Ruby, which are written with stages, ignore them.

It responds with `200` and one key for each output asked for:

```json
{
  "representation": {
    "representation": "...",
    "mapping": { "PLACEHOLDER_1": "name" },
    "version": 12
  },
  "snippet": {
    "snippet": "def two_fer(name = 'you')\n ...",
    "version": 1
  }
}
```

The `snippet` output holds the start of the solution, which the website shows on the solution's card, and the snippet's version:

```json
{ "snippet": { "snippet": "def two_fer(name = 'you')\n ...", "version": 1 } }
```

The `representation` output has these fields:

- `representation` is the normalised solution.
- `mapping` says which name each placeholder replaced.
- `version` is the version of the track's representer. It changes whenever the track's output changes, so the website knows to represent the track's solutions again.

Each output has its own version, so a change to one output never makes the website generate the others again.

If the representer can't generate an output, that output holds an error instead, and the other outputs still come back.
An error has the same shape for every output: `error` gives the reason, `message` says what went wrong, and `version` is the output's version for the track, if it has one.
If a track doesn't support an output yet, the error is `not_supported`.
The representer doesn't make analyses yet, so the `analysis` output always gets `not_supported`.
Every track gets a snippet, even when its solution can't be represented. If one of the snippet's rules raises an error, the snippet gets the error `internal_error`.

Some solutions can't be represented.
For those, the `representation` output is an error with the language's version, and `error` is one of these reasons:

- `parse_error`: the grammar couldn't parse the code. This includes new syntax that the pinned grammar doesn't know yet.
- `too_deep`: the code nests deeper than 1,000 levels.
- `too_large`: the solution files hold more than 200 KB, or the exercise files more than 500 KB. The load balancer limits bodies to 1 MB.
- `too_complex`: the language's rules hit one of the representer's own limits. Either they changed one part of the tree more than 50 times, or they took more than 10 seconds. This usually means a rule is wrong, so the representer also writes the message to the log.
- `no_source_files`: none of the solution's files is a source file of the language. The representer ignores files in other formats, such as Rust's `Cargo.toml` or a `HELP.md`, and test and tool config files, such as `leap_test.go` or `babel.config.js`.
- `internal_error`: one of the representer's rules raised an error. This is a bug in the representer, so it also writes the error to the log.

The website then marks the submission as unrepresentable.
Basic, which serves the tracks with no class of their own, can represent any solution that isn't too large and has a source file.

The response is a `400` if the request is invalid, including when `outputs` is missing or empty.

From Ruby, call `Representer::Generate` with the outputs as symbols:

```ruby
Representer::Generate.("ruby", solution_files, outputs: %i[representation snippet], exercise_files:)
```

## How it works

For a language with its own class, the representer:

1. Parses each file with the language's tree-sitter grammar. It skips files without one of the language's extensions, and test and config files, and turns Windows line endings into plain line breaks.
2. Drops what makes no difference to the solution working, such as comments, brackets that only group, and imports. Every solution that the representer sees passes its tests, so this code can't change what a mentor says about it.
3. Rewrites different spellings of the same code into one, such as Ruby's `x if y` into a block `if`, or `1_000` into `1000`.
4. Joins the files into one tree, in an order that depends only on their code. A file's name is never part of the representation, so renaming or reordering files doesn't change it.
5. Replaces each name the student chose with a placeholder. For C#, Elixir, F# and Ruby, this is every name the solution defines, wherever it appears. The other languages also keep the names used in the tests.
6. Writes the tree out as an indented s-expression.

C#, Elixir, F# and Ruby each have a folder: [`csharp/`](./lib/representer/languages/csharp/), [`elixir/`](./lib/representer/languages/elixir/), [`fsharp/`](./lib/representer/languages/fsharp/) and [`ruby/`](./lib/representer/languages/ruby/).
In each folder, `spec.rb` says what the language is and how its files are read, including its comments and docstrings.
`representation.rb` and `snippet.rb` declare the settings of each output, such as the representation's version, names and imports.
The stages that describe steps 2 and 3 sit in `common/`, for the stages that every output needs, and `representation/`, for the stages that only the representation needs.
`transition.md` says how the language differs from the tools it replaces.
A comment above each declaration and method says what it does.
The other languages describe these steps as rules in their class in [`lib/representer/languages/`](./lib/representer/languages/), until they are moved to stages, and the comment at the top of each class lists what its rules do.
[CONTRIBUTING.md](./CONTRIBUTING.md) explains the stages and how to add a language.

Basic ([`lib/representer/languages/basic.rb`](./lib/representer/languages/basic.rb)) splits the code into tokens with the track's [Rouge][rouge] lexer, drops comments, spacing and (in the tracks where it can find them reliably) imports, and keeps everything else, including line breaks and (in languages like Python) indentation.
It renames nothing, so it only merges solutions that differ in nothing but comments and formatting.

Every track also gets a snippet: the first 15 lines of the solution's main file, without its comments or the boilerplate at its top, such as imports.
Each track's `snippet.rb` in its folder in [`lib/representer/languages/`](./lib/representer/languages/) says what to leave out, and [REPRESENTER_DSL.md](./REPRESENTER_DSL.md#snippets) explains the rules.
For a language with a grammar, the snippet works on the grammar's tree, before any of the steps above change it.

## Set up

You need Ruby 3.4, git and a C compiler.
The Raku grammar doesn't commit its `parser.c`, so building it also needs node and the tree-sitter CLI (`npm install -g tree-sitter-cli@0.23.0`).

1. Run `bundle install`.
2. Run `./bin/build-grammars` to fetch and compile the tree-sitter grammars pinned in [`grammars.yml`](./grammars.yml). This puts them in `grammars/build/`, which git ignores.

## Run the representer

To represent a solution, write a request body to a file (see [`tests/`](./tests/) for examples) and run:

```shell
./bin/run.sh path/to/request.json
```

To see how a language's representer parses and represents a file, and the file's snippet, run:

```shell
./bin/inspect ruby path/to/two_fer.rb
```

## Run the tests

```shell
./bin/run-tests.sh
```

To run only one language's tests, give its track slug: `./bin/run-tests.sh ruby` (see "Running the tests" in [CONTRIBUTING.md](./CONTRIBUTING.md)).

With no slug, this runs the unit tests in `test/` (including every golden test ported from the old per-track representers), and then the request tests in `tests/`.
Each request test runs `tests/<track>/<name>/request.json` and compares the response's body with `expected_response.json`.

The unit tests also include the golden data tests in [`test/golden/`](./test/golden/), which run over about 20,000 real published solutions.
They check that every solution keeps its representation, and that the solutions stay in the same groups as on production, apart from the differences listed for each track.
Each solution that was alone in its production representation also has a near-miss variant, a copy with one small change to its code, and the tests check that the two get different representations.
[`test/golden/README.md`](./test/golden/README.md) explains them, and how to regenerate them with `./bin/regenerate-golden` after a deliberate change.
[`test/fuzz_test.rb`](./test/fuzz_test.rb) runs every track over golden solutions and fixtures with simple changes, such as Windows line endings, a byte-order mark, invalid UTF-8, empty files and files cut short.
It checks that no request raises, and that the same request always gets the same response.
It takes one solution per track by default. Set `FUZZ_SAMPLE` (and `FUZZ_TRACKS`) to run it over more.

Run `./bin/setup-hooks` to install a pre-commit hook that regenerates them for you when you change a language.
The hook runs with the Ruby named in `.ruby-version`, whatever Ruby your shell has.

To run the request tests against the Docker image, which is how the representer runs in production, run `./bin/run-tests-in-docker.sh`.

## Credit

This repo is built and maintained by Exercism.

Contributions are welcome!

[tree-sitter]: https://tree-sitter.github.io/tree-sitter/
[rouge]: https://github.com/rouge-ruby/rouge
