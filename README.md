# Exercism's Rosetta

![Tests](https://github.com/exercism/rosetta/workflows/Test/badge.svg)

This is Exercism's Rosetta.
It is responsible for analyzing a student's solution and returning information about it. 
It aims to be fast, have coverage across all of Exercism's live languages, and be readable and understandable by humans.

The application is deployed on AWS Lambda, accepts a request (see "Deployment"), and responds with some outputs, currently:
- [Representation](./docs/representation.md): A normalised representation of the solution, used to group solutions
- [Analysis](./docs/analysis.md): A series of comments about how a solution matches its exercise.
- [Code Snippet](./docs/snippets.md): A short snippet with noise stripped, which can be shown on solution cards around the website

## Representations

A representation is a normal form of a student's solution.
Rosetta drops everything that makes no difference to the solution working, such as comments and imports, gives one spelling to code that means the same thing, and replaces the names the solution defines with placeholders.
Two solutions with the same approach then get the same representation, so the website can group them, and a mentor's feedback on one solution reaches every solution in its group.

Each language with a `common/spec.rb` in its folder in [`lib/rosetta/languages/`](./lib/rosetta/languages/) has a language of its own in Rosetta, which parses its solutions with [tree-sitter][tree-sitter].
Every other track gets Basic, a simpler representation that splits the code into tokens with the track's [Rouge][rouge] lexer and drops only comments, spacing and some imports.
[docs/representation.md](./docs/representation.md) describes the output, Basic, versions, the golden data tests and the declarations each language makes.

## Analysis

The analysis gives the student comments on their solution, in the format used by Exercism's analyzers.
Each exercise with an analysis has a file of rules. A rule describes code with code patterns (code in the language itself, with placeholders such as `{{name}}`), and adds a comment when the solution matches them.
Only Ruby has an analysis so far.
[docs/analysis.md](./docs/analysis.md) describes the output and how to write the rules.

## Snippets

A snippet is the first 15 lines of the solution's main file, without its comments or the boilerplate at its top, such as imports.
The website shows it on the solution's card, so the card shows the student's own code.
Every track gets a snippet, even when its solution can't be represented.
[docs/snippets.md](./docs/snippets.md) describes the output and the declarations that say what to leave out.

## Deployment

Rosetta runs as an AWS Lambda function behind Exercism's internal load balancer.
One service handles every track.

### The request

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

- `outputs` lists what to generate, as one or more of `representation`, `snippet` and `analysis`. Rosetta only runs the steps needed for these outputs.
- `solution_files` are the student's files.
- `exercise_files` are the exercise's test files and stub. The snippet and the analysis read the exercise's `.meta/config.json` from them, to find the solution's main file. The representation doesn't use them.

### The response

Rosetta responds with `200` and one key for each output asked for:

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

Each output's doc lists its fields: [representation](./docs/representation.md#the-representation-output), [analysis](./docs/analysis.md#the-analysis-output) and [snippet](./docs/snippets.md#the-snippet-output).
Each output has its own version, so a change to one output never makes the website generate the others again.

If Rosetta can't generate an output, that output holds an error instead, and the other outputs still come back.
An error has the same shape for every output: `error` gives the reason, `message` says what went wrong, and `version` is the output's version for the track, if it has one.
If a track doesn't support an output yet, the error is `not_supported`.
Each output's doc lists its other reasons.

The response is a `400` if the request is invalid, including when `outputs` is missing or empty.

From Ruby, call `Rosetta::Generate` with the outputs as symbols:

```ruby
Rosetta::Generate.("ruby", solution_files, outputs: %i[representation snippet], exercise_files:)
```

## How it works

For a language with a grammar, Rosetta parses each file with tree-sitter, and then runs the language's stages on the tree.
The stages drop code that makes no difference and write different spellings of the same code as one.
For the representation, Rosetta then joins the files, sorts code that can come in any order and replaces names with placeholders.
The engine makes the decisions that apply to every language, and each language declares only what the engine can't know, such as which code counts as an import.
[docs/how-it-works.md](./docs/how-it-works.md) lists every step.

Each language has a folder in [`lib/rosetta/languages/`](./lib/rosetta/languages/), such as [`ruby/`](./lib/rosetta/languages/ruby/).
Its `common/` folder holds what every output shares, such as the language's grammar and comments.
Next to `common/`, the language's folder has one folder for each output: `representation/`, `analysis/` and `snippet/`.
Its `transition.md` says how the language differs from the tools it replaces.
[docs/common.md](./docs/common.md) describes the folder and what every output shares, [docs/code-patterns.md](./docs/code-patterns.md) describes code patterns, and [CONTRIBUTING.md](./CONTRIBUTING.md) explains how to add a language.

## Set up

You need Ruby 3.4, git and a C compiler.
Some grammars (marked `generate: true` in `grammars.yml`) don't commit their `parser.c`, so building them also needs node and the tree-sitter CLI (`npm install -g tree-sitter-cli@0.25.10`).

1. Run `bundle install`.
2. Run `./bin/build-grammars` to fetch and compile the tree-sitter grammars pinned in [`grammars.yml`](./grammars.yml). This puts them in `grammars/build/`, which git ignores.

## Run Rosetta

To represent a solution, write a request body to a file (see [`test/fixtures/requests/`](./test/fixtures/requests/) for examples) and run:

```shell
./bin/run.sh path/to/request.json
```

To see how Rosetta parses and represents a file, and the file's snippet, run:

```shell
./bin/inspect ruby path/to/two_fer.rb
```

## Run the tests

```shell
./bin/run-tests.sh
```

To run only one language's tests, give its track slug: `./bin/run-tests.sh ruby` (see "Running the tests" in [CONTRIBUTING.md](./CONTRIBUTING.md)).

With no slug, this runs the unit tests in `test/` (including every golden test ported from the old per-track representers), and then the request tests in `test/fixtures/requests/`.
Each request test runs `test/fixtures/requests/<track>/<name>/request.json` and compares the response's body with `expected_response.json`.

The unit tests also include the golden data tests in [`test/golden/`](./test/golden/), which run over about 20,000 real published solutions.
They check that every solution keeps its representation, and that the solutions stay in the same groups as on production, apart from the differences listed for each track.
Each solution that was alone in its production representation also has a near-miss variant, a copy with one small change to its code, and the tests check that the two get different representations.
[`test/golden/README.md`](./test/golden/README.md) explains them, and how to regenerate them with `./bin/regenerate-golden` after a deliberate change.
[`test/fuzz_test.rb`](./test/fuzz_test.rb) runs every track over golden solutions and fixtures with simple changes, such as Windows line endings, a byte-order mark, invalid UTF-8, empty files and files cut short.
It checks that no request raises, and that the same request always gets the same response.
It takes one solution per track by default. Set `FUZZ_SAMPLE` (and `FUZZ_TRACKS`) to run it over more.

Run `./bin/setup-hooks` to install a pre-commit hook that regenerates them for you when you change a language.
The hook runs with the Ruby named in `.ruby-version`, whatever Ruby your shell has.

To run the request tests against the Docker image, which is how Rosetta runs in production, run `./bin/run-tests-in-docker.sh`.

## Credit

This repo is built and maintained by Exercism.

Contributions are welcome!

[tree-sitter]: https://tree-sitter.github.io/tree-sitter/
[rouge]: https://github.com/rouge-ruby/rouge
