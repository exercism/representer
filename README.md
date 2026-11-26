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
- `exercise_files` are the exercise's test files, its stub and its `.meta/config.json`. The representer uses the tests to find the names that they use, so that it keeps those names. It uses `.meta/config.json` to find the solution's main file for the snippet.

It responds with `200` and:

```json
{
  "representation": "...",
  "mapping": { "PLACEHOLDER_1": "name" },
  "version": 2,
  "snippet": "def two_fer(name = 'you')\n ...\nend\n",
  "snippet_version": 1
}
```

- `representation` is the normalised solution.
- `mapping` says which name each placeholder replaced.
- `version` is the version of the track's representer. It changes whenever the track's output changes, so the website knows to represent the track's solutions again.
- `snippet` is the start of the solution's main file, which the website shows on the solution's card (see [the snippet](#the-snippet)).
- `snippet_version` is the version of the snippet rules. It is one number for every track, and it changes whenever any snippet could change, so the website knows to make its snippets again. The snippet never affects `representation`, `mapping` or `version`.

Some solutions can't be represented.
For those, the response is still a `200`, with the language's version and a snippet, but `representation` is `null`, `mapping` is empty, and `reason` says why:

- `parse_error`: the grammar couldn't parse the code. This includes new syntax that the pinned grammar doesn't know yet.
- `too_deep`: the code nests deeper than 1,000 levels.
- `too_large`: the solution files hold more than 200 KB, or the exercise files more than 500 KB. The load balancer limits bodies to 1 MB.

The website then marks the submission as unrepresentable.
Basic, which serves the tracks with no class of their own, can always represent a solution that isn't too large.

The response is a `400` if the request is invalid.

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

## The snippet

The snippet comes from the solution's main file.
That is the first file listed under `files.solution` in the exercise's `.meta/config.json` that the student submitted, or the student's first file if none of them is listed.

1. Comments are removed wherever they are. Imports and similar boilerplate (such as `package` lines, `#include`, `module ... exposing` and Python's module docstring) are only skipped at the top of the file. Code is never removed.
2. If a removal leaves a line empty, the line is dropped. Blank lines at the top are dropped too, and inside the code a run of blank lines becomes one.
3. The snippet keeps the first 15 lines, and cuts each line after 200 characters.

Everything else stays as the student wrote it.

A language with its own class finds comments and boilerplate in its parse tree, with its `comments` and `snippet_header` rules.
Basic finds comments with the track's Rouge lexer and skips no boilerplate. If the track has no lexer, nothing is removed.
If the main file can't be parsed, nothing is removed either, and the snippet is the file's first 15 lines.

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

To run the request tests against the Docker image, which is how the representer runs in production, run `./bin/run-tests-in-docker.sh`.

## Credit

This repo is built and maintained by Exercism.

Contributions are welcome!

[tree-sitter]: https://tree-sitter.github.io/tree-sitter/
[rouge]: https://github.com/rouge-ruby/rouge
