# Exercism's Representer

![Tests](https://github.com/exercism/representer/workflows/Test/badge.svg)

This is Exercism's representer.
It takes a solution and turns it into a normalised representation, so that solutions which differ only in formatting, comments and the names the student chose get the same representation.
The website groups solutions by their representation, and shows a mentor's feedback on one solution to every later solution in the same group.

It runs as an AWS Lambda function behind Exercism's internal load balancer.
One service handles every track.
These languages have a class of their own, and the representer parses them with [tree-sitter][tree-sitter]: C#, C++, Clojure, Common Lisp, Crystal, Elixir, Elm, F#, GDScript, Gleam, Go, Java, JavaScript, Nim, PHP, Python, Raku, Ruby, Rust, TypeScript, WebAssembly, Wren and Zig.

Every other track gets a simpler token-based representation called Basic.

## The request and response

The website POSTs JSON like this:

```json
{
  "track_slug": "ruby",
  "exercise_slug": "two-fer",
  "solution_files": { "two_fer.rb": "def two_fer(name = 'you')\n ...\nend\n" },
  "exercise_files": { "two_fer_test.rb": "...", ".meta/config.json": "..." }
}
```

- `solution_files` are the student's files.
- `exercise_files` are the exercise's test files and stub. The representer only uses them to find the names that the tests use, so that it keeps those names.

It responds with `200` and:

```json
{
  "representation": "...",
  "mapping": { "PLACEHOLDER_1": "name" },
  "version": 2
}
```

- `representation` is the normalised solution.
- `mapping` says which name each placeholder replaced.
- `version` is the version of the track's representer. It changes whenever the track's output changes, so the website knows to represent the track's solutions again.

Some solutions can't be represented.
For those, the response is still a `200`, with the language's version, but `representation` is `null`, `mapping` is empty, and `reason` says why:

- `parse_error`: the grammar couldn't parse the code. This includes new syntax that the pinned grammar doesn't know yet.
- `too_deep`: the code nests deeper than 1,000 levels.
- `too_large`: the solution files hold more than 200 KB, or the exercise files more than 500 KB. The load balancer limits bodies to 1 MB.
- `too_complex`: the language's rules hit one of the representer's own limits. Either they changed one part of the tree more than 50 times, or they took more than 10 seconds. This usually means a rule is wrong, so the representer also writes the message to the log.
- `no_source_files`: none of the solution's files has one of the language's extensions. The representer ignores files in other formats, such as Rust's `Cargo.toml` or a `HELP.md`.

The website then marks the submission as unrepresentable.
Basic, which serves the tracks with no class of their own, can always represent a solution that isn't too large.

The response is a `400` if the request is invalid.

## How it works

For a language with its own class, the representer:

1. Parses each file with the language's tree-sitter grammar. It skips files without one of the language's extensions, and turns Windows line endings into plain line breaks.
2. Drops what carries no meaning, such as comments and brackets.
3. Rewrites different spellings of the same code into one, such as Ruby's `x if y` into a block `if`.
4. Replaces each name the student chose with a placeholder. It keeps every name with a meaning outside the solution: library names, names the tests use, and names the language calls itself (such as `initialize`).
5. Writes the tree out as an indented s-expression.

Each language describes steps 2 to 4 as rules in its class in [`lib/representer/languages/`](./lib/representer/languages/).
[CONTRIBUTING.md](./CONTRIBUTING.md) explains the rules and how to add a language.

Basic ([`lib/representer/languages/basic.rb`](./lib/representer/languages/basic.rb)) splits the code into tokens with the track's [Rouge][rouge] lexer, drops comments and spacing, and keeps everything else, including line breaks and (in languages like Python) indentation.
It renames nothing, so it only merges solutions that differ in nothing but comments and formatting.

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

To see how a language's representer parses and represents a file, run:

```shell
./bin/inspect ruby path/to/two_fer.rb
```

## Run the tests

```shell
./bin/run-tests.sh
```

This runs the unit tests in `test/` (including every golden test ported from the old per-track representers), and then the request tests in `tests/`.
Each request test runs `tests/<track>/<name>/request.json` and compares the response's body with `expected_response.json`.

The unit tests also include the golden data tests in [`test/golden/`](./test/golden/), which run over about 20,000 real published solutions.
They check that every solution keeps its representation, and that the solutions stay in the same groups as on production, apart from the differences listed for each track.
[`test/golden/README.md`](./test/golden/README.md) explains them, and how to regenerate them with `./bin/regenerate-golden` after a deliberate change.
[`test/fuzz_test.rb`](./test/fuzz_test.rb) runs every track over golden solutions and fixtures with simple changes, such as Windows line endings, a byte-order mark, invalid UTF-8, empty files and files cut short.
It checks that no request raises, and that the same request always gets the same response.
It takes one solution per track by default. Set `FUZZ_SAMPLE` (and `FUZZ_TRACKS`) to run it over more.

Run `./bin/setup-hooks` to install a pre-commit hook that regenerates them for you when you change a language.

To run the request tests against the Docker image, which is how the representer runs in production, run `./bin/run-tests-in-docker.sh`.

## Credit

This repo is built and maintained by Exercism.

Contributions are welcome!

[tree-sitter]: https://tree-sitter.github.io/tree-sitter/
[rouge]: https://github.com/rouge-ruby/rouge
