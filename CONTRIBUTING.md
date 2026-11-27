# Adding a language

Every track gets the Basic representer until it has a representer of its own.
This guide explains how to add one.
Ruby, in [`lib/representer/languages/ruby/`](./lib/representer/languages/ruby/), is the worked example, and the quickest way to start is to copy it.

The steps are:

1. Pin and build the grammar.
2. Port the old representer's tests.
3. Declare the language's names and write its stages.
4. Add tests for each stage.
5. Set the version.

## The goal

Every solution that the representer sees passes its tests.
So the representer can throw away any code that makes no difference to the solution working, such as comments, imports, brackets that only group, and the way a number or a string is written.
Two solutions that differ only in such code would pass the same tests in the same way, and a mentor would give them the same feedback.

Two solutions should get the same representation if a mentor would give them the same feedback, and different representations otherwise.
A merge is only harmful if a mentor would comment differently on the two solutions.

Names follow from the same principle, and give one rule: **rename every name the solution defines, wherever it appears.**
A name the solution doesn't define, such as a call to a library method, keeps its name.
If the solution defines a method called `sum`, the engine renames it, even though the library has a `sum` too.

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
- `replace`: text in `equivalent.<ext>` to replace with other text, for names that this representer renames and the old one kept.
- `add` and `remove`: names to add to or remove from the old mapping.
- `unrepresentable: true`: the input has a syntax error that tree-sitter rejects, so it gets no representation. The test checks that, and nothing else.
- `merges_with`: other tests that this representer gives the same representation, although the old representer kept them apart. Use it only for solutions that differ in code that makes no difference to them working, such as imports.
- `why`: the reason. Every deviation needs one.

The common deviations are old outputs that weren't valid code, and names that the old representer kept and this one renames.
Never use a deviation to hide a merge that the old representer kept apart.

## 3. Declare the names and write the stages

[REPRESENTER_DSL.md](./REPRESENTER_DSL.md) defines every declaration and verb used in this step.
The other languages still use the older rule DSL, described at the end of that file, until they move to stages.

### The rules for every language

These rules decide what a language may do:

1. Every solution that the representer sees is valid code that passes its tests. A stage may throw away code that makes no difference to the solution working, but it never adds code that only copes with invalid input.
2. The engine makes the decisions that apply to every language (see [REPRESENTER_DSL.md](./REPRESENTER_DSL.md#what-the-engine-does-for-every-language)). A language only says what the engine can't know, such as which code counts as an import. A stage never repeats one of the engine's decisions.
3. Within a language, match what the old representer (`exercism/<track>-representer`) did. A language-specific difference from the old behaviour only goes in if a human has decided it. List any other improvement you'd suggest in `test/golden/<track>/SUGGESTIONS.md` for the maintainers to discuss. Fix bugs, such as wrong merges and crashes.

### The language's folder

Each language has a folder of its own, named after it, such as `lib/representer/languages/ruby/`.
The folder holds all the language's files:

- `spec.rb` defines `Ruby::Spec`, which declares the language's setup, names and imports.
- `generate_ast.rb`, `normalise.rb` and `reorder.rb` each define one stage, such as `Ruby::GenerateAST`.

Every file uses the compact module form, and each stage is a class beside `Spec` in the same module:

```ruby
module Representer::Languages::Ruby
  class Spec < Representer::Engine::Language
    tracks "ruby"
    version 11
    grammar "ruby"
    extensions ".rb"

    # A symbol such as `:count` names the method `count`, so the colon isn't
    # part of the name.
    names_are :simple_symbol, without_prefix: ":"
  end
end
```

```ruby
module Representer::Languages::Ruby
  class Reorder < Representer::Engine::Reorder
    sort :class_body, :module_body, :hash
  end
end
```

When a language defines its `Spec`, the engine finds the stage files in the language's folder, and loads each one the first time it needs that stage.
If a file doesn't exist, the language doesn't run that stage, so a language only has the files it needs, and never needs `require` lines for them.

Give `names_are` and `names_are_defined_by` the node types that `GenerateAST` leaves.
Check the grammar's `queries/locals.scm` and `queries/tags.scm`, which mark the nodes that define locals, methods and classes.

### The stages

The engine runs the stages and its own steps in this order:

1. `GenerateAST` runs on each file. It turns tree-sitter's tree, which has every token and comment, into the tree given by the language's own parser. It drops comments and the tokens dropped by the parser, unwraps brackets that only group, and turns spellings that the parser treats as one into one tree (for Ruby, these include heredocs and strings, `%w[]` and arrays, and `do ... end` and braces).
2. The engine drops the imports from each file.
3. `Normalise` runs on each file. It applies any equivalences and removals that a human has decided for the language.
4. The engine renames every name the solution defines, in all the files together (see "Names" below).
5. The engine joins the files into one tree, in an order set by their code.
6. `Reorder` runs on the joined tree. It sorts code if its order makes no difference, by a key that ignores names.
7. The engine numbers the placeholders, in the order the names appear, and writes the tree out as an s-expression.

`GenerateAST` works on the tree with the tree helpers, because it has to know the grammar's tree in detail.
`Normalise` lists its rules with verbs such as `drop`, `rewrite` and `attach_to_next`, and their arguments are code patterns: code in the language itself, with `{{word}}` placeholders.
`Reorder` lists the node types it sorts with `sort`.
Only sort containers of definitions or entries, such as a class's body or a hash, and never a block of statements.
If the grammar gives a container the same type as a block of statements, give it a type of its own in `GenerateAST` before sorting it, as Ruby's `class_body` does.
If a rule genuinely needs logic, write it as a small, clearly named Ruby method.

Run `./bin/inspect <track> <file>` to see tree-sitter's tree, with each node's type, field names and tokens.

### Comments

The comment at the top of each file only says, in one or two sentences, that [REPRESENTER_DSL.md](./REPRESENTER_DSL.md) defines its declarations or verbs.
Each declaration about the language's code (such as `names_are` or `imports`), each rule and each method then has a short comment directly above it, which says what it means for this language.
For example, Ruby's `spec.rb` has this comment above `names_are :simple_symbol, without_prefix: ":"`: "A symbol such as `:count` names the method `count`, so the colon isn't part of the name."
Update a comment whenever the code below it changes.
Write every comment by the rules in "Writing comments and docs" below.

### GenerateAST's tokens

`GenerateAST` lists the tokens it drops explicitly.
To draft the list from the grammar, run:

```shell
./bin/draft-ast-tokens <grammar>
```

It lists the tokens that always sit in a fixed place in a node, which are safe to drop.
It also lists the tokens that are optional, one of a choice, or have text that varies, for a human to review.
The ones to review often carry meaning (C++'s `delete[]`, Ruby's `&.`), but some are only layout (brackets around Ruby's arguments).
Check each one, write the reviewed list into the class, and say in a comment why each group is dropped.
Read a token's text before dropping it if its text varies (Ruby's string opener can be `'`, `"` or `%q(`), and check the grammar's extras, which can hold content (Ruby's heredoc bodies).

### Strings and numbers

Turn each string into its value with `literal(value)`, so that `'a'` and `"a"` are the same.
Read only the escapes used in solutions, and keep any other escape as a node of its own, so two different strings can never get the same value.
Give two numbers one form only if the language reads them as the same value of the same type, using the readers in [`Engine::Numbers`](./lib/representer/engine/numbers.rb).

### Names

The engine renames names in one step, [`Engine::RenameUserDefinedNodes`](./lib/representer/engine/rename_user_defined_nodes.rb), which walks the trees twice.
The first walk collects the text of every name defined by a node listed in `names_are_defined_by`.
The second walk renames every name with one of those texts, wherever it appears: in its definition, and in every use, call and symbol.
Renaming goes by name, so every use of a renamed name gets the same placeholder.
The engine never reads the exercise's tests or stub for names.

## 4. Add tests for each stage

Give each stage a test file of its own in `test/languages/<track>/`, which tests that stage's job, and test the language's names in `test/languages/<track>/names_test.rb`.
See [`test/languages/ruby/`](./test/languages/ruby/).

Test `GenerateAST` against the language's own parser: for a set of snippets (from the tests and the golden data), check that two snippets get the same tree from `GenerateAST` exactly when the parser gives them the same tree, ignoring locations and names.
Ruby's test uses the `parser` gem, which the old Ruby representer used, and lists each pair where `GenerateAST` deliberately differs, with the reason.

Keep the ported tests and the tests of the whole representer in `test/languages/<track>_test.rb`.
`RepresenterTest` gives you `assert_same_representation`, `refute_same_representation` and `assert_unrepresentable` (which checks that a solution gets no representation, for a given reason).

Also add a request test: a `tests/<track>/<name>/request.json` with a typical solution and its tests, and an `expected_response.json` made by running `./bin/run.sh tests/<track>/<name>/request.json tests/<track>/<name>` and copying `response.json` after checking it.

Run the tests as "Running the tests" below says.

If the track has golden data in [`test/golden/<track>/`](./test/golden/), run `./bin/regenerate-golden <track>` after changing a stage, and review the diff.
The golden tests fail if a change splits or merges any of the production groups, unless the difference is listed in the track's `differences.yml` (see [`test/golden/README.md`](./test/golden/README.md)).

## 5. Set the version

A new language starts at version 2, because the old per-track representers all reported version 1.

Bump a language's version whenever its output could change for any solution: a change to a stage, a rule or the names, or a new grammar commit.
The website will then represent the track's solutions again.

Basic has its own version, which only covers the tracks with no class of their own.

## How the code is organised

The code is built from small [Mandate](https://github.com/iHiD/mandate) commands.
Each command is a class that does one clearly named job, such as `Engine::RenameUserDefinedNodes` or `Engine::DropImports`.
It takes its inputs with `initialize_with`, and code calls it with `.()`, as in `Engine::DropImports.(tree, language)`.
Each command has a unit test file of its own, named after it, such as `test/engine/rename_user_defined_nodes_test.rb`.
The tests check the command on small trees, apart from any language where they can.

Every file uses the compact module form, such as `module Representer::Engine` or `module Representer::Languages::Ruby`, and never nested modules.
The languages still on the old structure use nested modules until they move to stages.

Write new code this way, and convert older code to it when you change that code.

## Running the tests

If a change only touches one language's files (its class or its folder, its grammar's pin or its golden data), run only that language's tests:

```shell
./bin/run-tests.sh ruby
```

With a track slug, the script runs the language's own tests (`test/languages/<track>_test.rb` and the files in `test/languages/<track>/`), its golden tests, its fuzz test and its request tests in `tests/<track>/`.
To run one of those on its own, use these commands:

```shell
bundle exec ruby -Itest test/languages/ruby_test.rb
bundle exec ruby -Itest test/golden_test.rb -n /test_ruby_/
FUZZ_TRACKS=ruby bundle exec ruby -Itest test/fuzz_test.rb
```

If a change touches the engine or anything shared by the languages, run the full suite with `./bin/run-tests.sh`.
CI runs the full suite on every push either way.

## Writing comments and docs

These rules apply to every comment and doc in this repo:

- Write plainly. Give the context first, then say what happens and who does it, in short everyday sentences.
- Write full sentences with a subject and a verb. Don't use fragments as openers or as list items, and that includes header comments and headings.
- Use an active actor. Write "This stage removes `require` calls", and don't write "`require` calls are removed".
- Put the context or condition first: "A solution that passes its tests has already loaded everything it needs, so this stage removes `require` and `require_relative`."
- Use the future tense for what would happen after a specific event, and the present tense for what is always true.
- Don't use em dashes, "not X but Y" framing, "The X is the Y" equations or shouted capitals.
- Don't use object relative clauses. Write "the names used in the tests", and don't write "the names that the tests use".

[parsers]: https://github.com/tree-sitter/tree-sitter/wiki/List-of-parsers
[queries]: https://tree-sitter.github.io/tree-sitter/using-parsers/queries/index.html
