# Exercism's Representer

![Tests](https://github.com/exercism/representer/workflows/Test/badge.svg)

This is Exercism's representer.
It takes a solution and turns it into a normalised representation, so that solutions which differ only in formatting, comments and the names the student chose get the same representation.
The website groups solutions by their representation, and shows a mentor's feedback on one solution to every later solution in the same group.

It runs as an AWS Lambda function behind Exercism's internal load balancer.
One service handles every track.
These languages have a class of their own, and the representer parses them with [tree-sitter][tree-sitter]: C#, C++, Clojure, Common Lisp, Crystal, Elixir, Elm, F#, GDScript, Gleam, Go, Java, JavaScript, Nim, PHP, Python, Ruby, Rust, TypeScript, WebAssembly, Wren and Zig.

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

If a solution has a syntax error (or nests deeper than 1,000 levels), its language falls back to Basic.
The response is still a `200`, with the language's own version, so a track never mixes two version numbers.

The other responses are:

- `400` if the request is invalid.
- `413` if the solution files hold more than 200 KB, or the exercise files more than 500 KB. The load balancer limits bodies to 1 MB.

## How it works

For a language with its own class, the representer:

1. Parses each file with the language's tree-sitter grammar.
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

To run the request tests against the Docker image, which is how the representer runs in production, run `./bin/run-tests-in-docker.sh`.

## Credit

This repo is built and maintained by Exercism.

Contributions are welcome!

[tree-sitter]: https://tree-sitter.github.io/tree-sitter/
[rouge]: https://github.com/rouge-ruby/rouge
