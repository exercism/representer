# Adding a language

Every track gets the Basic representer until it has a representer of its own.
This guide explains how to add one.
Ruby, in [`lib/representer/languages/ruby.rb`](./lib/representer/languages/ruby.rb) and [`lib/representer/languages/ruby/`](./lib/representer/languages/ruby/), is the worked example, and the quickest way to start is to copy it.

The steps are:

1. Pin and build the grammar.
2. Port the old representer's tests.
3. Write the language's stages.
4. Add tests for each stage.
5. Set the version.

## The goal

Every solution that the representer sees passes its tests.
So the representer can throw away any code that makes no difference to the solution working, such as comments, imports, brackets that only group, and the way a number or a string is written.
Two solutions that differ only in such code would pass the same tests in the same way, and a mentor would give them the same feedback.

Two solutions should get the same representation if a mentor would give them the same feedback, and different representations otherwise.
A merge is only harmful if a mentor would comment differently on the two solutions.

Names follow from the same principle, and give one firm rule: **only rename a name if the solution gives it its whole meaning.**
If the language, a library, the tests or a protocol also gives the name a meaning, renaming it could change what the code does, so keep it.
For example, Ruby keeps `initialize` (Ruby calls it), every name the tests use, and a method called `sum` (so `def sum(a) = a.sum` and `def max(a) = a.max` stay apart).

When in doubt, keep two solutions apart.
A missed merge only means a mentor sees one more solution.
A wrong merge shows a mentor's feedback to a student it doesn't fit.

## 1. Pin and build the grammar

Find the language's tree-sitter grammar (the [tree-sitter wiki][parsers] lists them) and add it to [`grammars.yml`](./grammars.yml) at a specific commit:

```yaml
python:
  repo: https://github.com/tree-sitter/tree-sitter-python
  commit: 26855eabccb19c6abf499fbc5b8dc7cc9ab8bc64
```

Use a full commit SHA, never a branch or tag, so the grammar can't change under you.
If the grammar doesn't commit its `parser.c`, add `generate: true`. Building it then runs `tree-sitter generate`, so you need node and the tree-sitter CLI (`npm install -g tree-sitter-cli@0.23.0`). Never commit the generated file.
Add `src:` if the grammar's `parser.c` isn't in `src/` (for example `src: typescript/src`) and `symbol:` if the grammar's C name isn't the entry's name (tree-sitter-c-sharp exports `tree_sitter_c_sharp`, so its entry is called `c_sharp`).

Then build it:

```shell
./bin/build-grammars python
```

The grammar must parse the exercises' example solutions without errors.
Check a few with `./bin/inspect`.
If it reports syntax errors on valid code, try a newer commit or another grammar.

Changing a grammar's commit later can change the representation of any solution in that language, so bump the language's version in the same commit (see step 5).

## 2. Port the old representer's tests

If the track has an old representer (`exercism/<track>-representer`), port every one of its golden tests.
Copy each test into `test/fixtures/<track>/<name>/`, using the old test's category and name for `<name>`:

- The test's input files, unchanged.
- `equivalent.<ext>`: code that the old representer treats as the same as the input. If the old representer printed normalised code (as C# and JavaScript did), this is its expected output, unchanged. Otherwise, write it by hand: take the input, rename the names the student chose, change the formatting, and use other spellings that the old representer normalised.
- `expected_mapping.json`: the old expected mapping, unchanged.
- `expected_representation.txt`: the old expected output, only if it isn't code (Ruby's was an AST).

Then create `test/languages/<track>_test.rb`:

```ruby
require "test_helper"

class PythonTest < RepresenterTest
  extend UpstreamTests

  track "python"

  DEVIATIONS = {}.freeze

  upstream_tests ".py", deviations: DEVIATIONS
end
```

`upstream_tests` (in [`test/test_helper.rb`](./test/test_helper.rb)) checks three things for every ported test:

1. Equivalence: the input and `equivalent.<ext>` get the same representation.
2. Mapping: the names renamed are the ones the old representer renamed.
3. Distinctness: two tests get the same representation exactly when the old representer gave them the same expected output.

Every ported test must pass.
Where this representer deliberately differs from the old one, add a deviation that says how and why:

```ruby
DEVIATIONS = {
  "Braces-BracesOnSameLine" => {
    restore: { "PLACEHOLDER_2" => "Add" },
    remove: ["Add"],
    why: "Add is a library method name (DateTime.Add), so a method the student calls Add keeps its name."
  }
}.freeze
```

- `restore`: placeholders in `equivalent.<ext>` to turn back into names, for names that the old representer renamed but this one keeps.
- `add` and `remove`: names to add to or remove from the old mapping.
- `unrepresentable: true`: the input has a syntax error that tree-sitter rejects, so it gets no representation. The test checks that, and nothing else.
- `merges_with`: other tests that this representer gives the same representation, although the old representer kept them apart. Use it only for solutions that differ in code that makes no difference to them working, such as imports.
- `why`: the reason. Every deviation needs one.

The common deviations are library names (this representer keeps them; several old ones renamed them) and old outputs that weren't valid code.
Never use a deviation to hide a merge that the old representer kept apart.

## 3. Write the language's stages

A language is a module with four stages, each a [Mandate](https://github.com/iHiD/mandate) command class in its own file.
Ruby is the worked example: [`lib/representer/languages/ruby.rb`](./lib/representer/languages/ruby.rb) and the files in [`lib/representer/languages/ruby/`](./lib/representer/languages/ruby/).
The other languages still use the older rule DSL, described in [REPRESENTER_DSL.md](./REPRESENTER_DSL.md#the-rule-dsl), until they are moved to stages.

### The rules for every language

These rules decide what each stage may do:

1. Every solution that the representer sees is valid code that passes its tests. A stage may throw away code that makes no difference to the solution working, but never adds code that only copes with invalid input.
2. Some decisions apply to every language: drop imports, includes and export lists; leave file names out (the engine orders the files by their code); keep library names only where the choice of method is something a mentor comments on; and never represent invalid code.
3. Within a language, match what the old representer (`exercism/<track>-representer`) did. A language-specific difference from the old behaviour only goes in if a human has decided it. List any other improvement you'd suggest in `test/golden/<track>/SUGGESTIONS.md` for the maintainers to discuss. Fix bugs, such as wrong merges and crashes.

### The module

`lib/representer/languages/<track>.rb` defines the module and its setup, and requires the stages:

```ruby
module Representer
  module Languages
    module Ruby
      extend StagedLanguage

      tracks "ruby"
      version 8
      grammar "ruby"
      extensions ".rb"

      names :identifier, :constant, :instance_variable, :class_variable, :global_variable, simple_symbol: ":"

      library_names File.join(__dir__, "library_names", "ruby.txt")
    end
  end
end

require_relative "ruby/generate_ast"
require_relative "ruby/normalise"
require_relative "ruby/rename"
require_relative "ruby/reorder"
```

- `tracks`: the track slugs this module represents.
- `version`: the representer version (see step 5).
- `grammar`: the grammar's name in `grammars.yml`.
- `extensions`: the language's file extensions. Solution and exercise files with other extensions are ignored.
- `names`: the leaf types that hold names. Only these can be renamed. A keyword gives a prefix that isn't part of the name (Ruby's `simple_symbol: ":"` for `:name`).
- `library_names`: a file of the library's method names, one per line (see "Library names" below).

### The stages

The engine runs the stages in this order:

1. `GenerateAST` runs on each file. It turns tree-sitter's tree, which has every token and comment, into the tree that the language's own parser would give. It drops comments and the tokens the parser drops, unwraps brackets that only group, and turns spellings that the parser treats as one into one tree (for Ruby: heredocs and strings, `%w[]` and arrays, `do ... end` and braces, and so on).
2. `Normalise` runs on each file. It applies the representer's own equivalences and removals: the global decisions, such as dropping imports, and any that a human has decided for the language.
3. `Rename` runs on all the files together. It decides which names are the student's, and marks their leaves. It returns the names of the members that the files define, which the engine uses for the exercise's stub.
4. The engine joins the files into one tree, in an order set by their code.
5. `Reorder` runs on the joined tree. It sorts code whose order doesn't matter, by a key that ignores names.
6. The engine numbers the placeholders, in the order the names appear, and writes the tree out as an s-expression.

Each stage takes the tree (`Rename` takes the list of trees and the names that the exercise keeps) and returns it:

```ruby
module Representer
  module Languages
    module Ruby
      class Normalise
        include Mandate
        include Engine::TreeHelpers

        initialize_with :tree

        def call
          drop(tree, "(call !receiver method: (identifier /\\Arequire(_relative)?\\z/) arguments: (argument_list (literal)))")
        end
      end
    end
  end
end
```

Start each file with a comment that lists, in plain English and one bullet each, everything the stage does: what it drops, what it treats as the same, what it renames and keeps and why.
The list is for a maintainer who doesn't know the code, so update it whenever the stage changes.

Run `./bin/inspect <track> <file>` to see tree-sitter's tree, with each node's type, field names and tokens.

### The helpers

`Engine::TreeHelpers` has the operations that every stage needs.
Each one visits a node once, so a rule can't loop on its own output.
[REPRESENTER_DSL.md](./REPRESENTER_DSL.md#tree-helpers-for-stages) lists them all. The main ones are:

- `transform(tree, pattern, template)` or `transform(tree, pattern) { |match| ... }`: replaces each match, from the leaves up.
- `drop(tree, pattern)`: removes each match.
- `drop_tokens(tree, everywhere:, only_in:, kept_in:)`: removes anonymous tokens.
- `unwrap(tree, pattern)`: replaces a match that has one named child with that child.
- `each_node`, `find_all` and `captured`: walk the tree and find matches.
- `build`, `leaf`, `literal`, `token` and `copy`: make nodes.
- `names_in` and `mark_student_names`: collect names and mark the student's.

Patterns and templates use the syntax in [REPRESENTER_DSL.md](./REPRESENTER_DSL.md#patterns).

### GenerateAST's tokens

`GenerateAST` lists the tokens it drops explicitly.
Draft the list from the grammar with:

```shell
./bin/draft-ast-tokens <grammar>
```

It lists the tokens that always sit in a fixed place in a node, which are safe to drop, and the tokens that are optional, one of a choice, or have text that varies, for a human to review.
The ones to review often carry meaning (C++'s `delete[]`, Ruby's `&.`), but some are only layout (brackets around Ruby's arguments).
Check each one, write the reviewed list into the class, and say in a comment why each group is dropped.
Read a token's text before dropping it if its text varies (Ruby's string opener can be `'`, `"` or `%q(`), and check the grammar's extras, which can hold content (Ruby's heredoc bodies).

### Strings and numbers

Turn each string into its value with `literal(value)`, so that `'a'` and `"a"` are the same.
Read only the escapes that solutions use, and keep any other escape as a node of its own, so two different strings can never get the same value.
Give two numbers one form only if the language reads them as the same value of the same type, using the readers in [`Engine::Numbers`](./lib/representer/engine/numbers.rb).

### Names

Only rename a name if the solution gives it its whole meaning.
`Rename` collects the names that the solution defines for locals and members, and the leaves where a name refers to another object's member (such as the name after a dot), then calls `mark_student_names`.
A member use is only renamed if the solution defines a member with that name.
Pass in, as kept names, the names the engine gives (every name in the tests, and the members of the stub), the names that callers use (such as keyword parameters), and the members the solution names after library methods.

### Library names

The library names list keeps a student's method that has a library method's name, so `def sum(a) = a.sum` and `def max(a) = a.max` stay apart.
Only list methods where the choice of method is something a mentor comments on, and the methods the language calls itself (such as Ruby's `initialize`).
Ruby's list is made from what the golden solutions call, by [`bin/draft-ruby-library-names`](./bin/draft-ruby-library-names).

## 4. Add tests for each stage

Give each stage a test file of its own in `test/languages/<track>/`, which tests that stage's job.
See [`test/languages/ruby/`](./test/languages/ruby/).

Test `GenerateAST` against the language's own parser: for a set of snippets (from the tests and the golden data), check that two snippets get the same tree from `GenerateAST` exactly when the parser gives them the same tree, ignoring locations and names.
Ruby's test uses the `parser` gem, which the old Ruby representer used, and lists each pair where `GenerateAST` deliberately differs, with the reason.

Keep the ported tests and the tests of the whole representer in `test/languages/<track>_test.rb`.
`RepresenterTest` gives you `assert_same_representation`, `refute_same_representation` and `assert_unrepresentable` (which checks that a solution gets no representation, for a given reason).

Also add a request test: a `tests/<track>/<name>/request.json` with a typical solution and its tests, and an `expected_response.json` made by running `./bin/run.sh tests/<track>/<name>/request.json tests/<track>/<name>` and copying `response.json` after checking it.

Run everything with `./bin/run-tests.sh`.

If the track has golden data in [`test/golden/<track>/`](./test/golden/), run `./bin/regenerate-golden <track>` after changing a stage, and review the diff.
The golden tests fail if a change splits or merges any of the production groups, unless the difference is listed in the track's `differences.yml` (see [`test/golden/README.md`](./test/golden/README.md)).

## 5. Set the version

A new language starts at version 2, because the old per-track representers all reported version 1.

Bump a language's version whenever its output could change for any solution: a change to a stage or a rule, a new library names list, or a new grammar commit.
The website will then represent the track's solutions again.

Basic has its own version, which only covers the tracks with no class of their own.

[parsers]: https://github.com/tree-sitter/tree-sitter/wiki/List-of-parsers
[queries]: https://tree-sitter.github.io/tree-sitter/using-parsers/queries/index.html
