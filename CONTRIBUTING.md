# Adding a language

Every track gets the Basic representer until it has a representer of its own.
This guide explains how to add one.
Ruby, in [`lib/representer/languages/ruby/`](./lib/representer/languages/ruby/), is the worked example, and the quickest way to start is to copy it.

The steps are:

1. Pin and build the grammar.
2. Port the old representer's tests.
3. Declare the language's names and write its stages.
4. Add tests for each stage.
5. Write the snippet.
6. Set the version.

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
If the grammar doesn't commit its `parser.c`, add `generate: true`. Building it then runs `tree-sitter generate`, so you need node and the tree-sitter CLI (`npm install -g tree-sitter-cli@0.25.10`). Never commit the generated file.
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
- `parse_error: true`: the input has a syntax error that tree-sitter rejects, so it gets Basic's representation. The test checks that, and nothing else.
- `merges_with`: other tests that this representer gives the same representation, although the old representer kept them apart. Use it only for solutions that differ in code that makes no difference to them working, such as imports.
- `why`: the reason. Every deviation needs one.

The common deviations are old outputs that weren't valid code, and names that the old representer kept and this one renames.
Never use a deviation to hide a merge that the old representer kept apart.

## 3. Declare the names and write the stages

[REPRESENTER_DSL.md](./REPRESENTER_DSL.md) defines every declaration and verb used in this step.

### The rules for every language

These rules decide what a language may do:

1. Every solution that the representer sees is valid code that passes its tests. A stage may throw away code that makes no difference to the solution working, but it never adds code that only copes with invalid input.
2. The engine makes the decisions that apply to every language (see [REPRESENTER_DSL.md](./REPRESENTER_DSL.md#what-the-engine-does-for-every-language)). A language only says what the engine can't know, such as which code counts as an import. A stage never repeats one of the engine's decisions.
3. Within a language, match what the old representer (`exercism/<track>-representer`) did. A language-specific difference from the old behaviour only goes in if a human has decided it, and the language's `transition.md` records it. List any other improvement you'd suggest in `test/golden/<track>/SUGGESTIONS.md` for the maintainers to discuss. Fix bugs, such as wrong merges and crashes.

### The language's folder

Each language has a folder of its own, named after it, such as `lib/representer/languages/ruby/`.
The folder holds all the language's files, and splits its stages by the outputs that need them:

```text
languages/ruby/
  spec.rb                       Ruby::Spec
  representation.rb             Ruby::Representation
  analysis.rb                   Ruby::Analysis
  snippet.rb                    Ruby::Snippet
  common/generate_ast.rb        Ruby::Common::GenerateAST
  common/normalise.rb           Ruby::Common::Normalise
  representation/normalise.rb   Ruby::Representation::Normalise
  representation/reorder.rb     Ruby::Representation::Reorder
  analysis/normalise.rb         Ruby::Analysis::Normalise
  analysis/two_fer.rb           Ruby::Analysis::TwoFer
```

- `spec.rb` says what the language is and how its files are read: its `tracks`, `extensions` and `grammar`, which code is a comment (`comments_are`) and which code is a docstring (`docstrings_are`). A grammar that needs `text_nodes` or `text_between_children` declares them here too.
- `representation.rb` declares the representation's settings: its `version`, `names_are`, `names_are_defined_by`, `imports` and `pattern_contexts`.
- `analysis.rb` declares the analysis's `version`. Bump it whenever the comments on any solution could change.
- `snippet.rb` declares the snippet's `version` and what to leave out of it (see step 5).
- `common/` holds the stages that every output needs, which are the representation and the analysis.
- `representation/` holds the stages that only the representation needs.
- `analysis/` holds the Normalise stage that only the analysis needs, and one file of rules for each exercise, named after the exercise's slug ([REPRESENTER_DSL.md](./REPRESENTER_DSL.md#analysis) describes the rules). Give each exercise's rules a test file in `test/languages/<track>/`, such as `two_fer_analysis_test.rb`.

A rewrite goes in `common/normalise.rb` only if it hides no spelling that an analysis rule would need. If you aren't sure, put it in `representation/normalise.rb`.
Every `Reorder` goes in `representation/`, and so does dropping docstrings, as the analysis may read them.

Every file uses the compact module form:

```ruby
module Representer::Languages::Ruby
  class Spec < Representer::Engine::Language
    tracks "ruby"
    grammar "ruby"
    extensions ".rb"

    # Treat these as comments.
    comments_are :comment # x = 1 «# The answer»
  end
end
```

```ruby
module Representer::Languages::Ruby
  class Representation < Representer::Engine::Representation
    version 12

    # Rename a symbol such as `:count` as the name `count`, without the colon.
    names_are :simple_symbol, without_prefix: ":" # :«count»
  end
end
```

A stage in `representation/` is a class inside the output's class:

```ruby
class Representer::Languages::Ruby::Representation
  class Reorder < Representer::Engine::Reorder
    # Reorder manually written hash keys.
    # {"a": 1, "b": 2} == {"b": 2, "a": 1}
    sort :hash
  end
end
```

When a language defines its `Spec`, the engine finds the outputs and the stage files in the language's folder, and loads each one the first time it needs it.
If a file doesn't exist, the language doesn't run that stage, so a language only has the files it needs, and never needs `require` lines for them.

Give `names_are` and `names_are_defined_by` the node types that `GenerateAST` leaves.
Check the grammar's `queries/locals.scm` and `queries/tags.scm`, which mark the nodes that define locals, methods and classes.

### The stages

The engine runs the stages and its own steps in this order:

1. The engine drops the comments declared in `spec.rb` from each file.
2. `common/generate_ast.rb` runs on each file. It turns tree-sitter's tree, which has every token, into the tree given by the language's own parser. It turns spellings that the parser treats as one into one tree (for Ruby, these include heredocs and strings, `%w[]` and arrays, and `do ... end` and braces). The declarations at the top of the class strip tokens, unwrap brackets that only group and write numbers as their values (see "GenerateAST's declarations" below).
3. `common/normalise.rb` runs on each file. It applies the equivalences that a human has decided for the language and that every output wants.
4. The engine drops the imports from each file.
5. `representation/normalise.rb` runs on each file. It applies the equivalences and removals that only the representation wants.
6. The engine renames every name the solution defines, in all the files together (see "Names" below).
7. The engine joins the files into one tree, in an order set by their code.
8. `representation/reorder.rb` runs on the joined tree. It sorts code if its order makes no difference, by a key that ignores names.
9. The engine numbers the placeholders, in the order the names appear, and writes the tree out as an s-expression.

The snippet works on tree-sitter's own tree, before any of these steps.

`GenerateAST` works on the tree with the tree helpers, because it has to know the grammar's tree in detail.
A `Normalise` stage lists its rules with verbs such as `drop`, `rewrite`, `attach_to_next` and `add_braces_to`, and their arguments are code patterns: code in the language itself, with `{{word}}` placeholders.
Use a verb wherever one fits, and write a method only when no verb can say the rule.
A `Reorder` stage lists the node types it sorts with `sort`.
Only sort containers of definitions or entries, such as a class's body or a hash, and never a block of statements.
If the grammar gives a container the same type as a block of statements, give it a type of its own in `GenerateAST` before sorting it, as Ruby's `class_body` does.
If a rule genuinely needs logic, write it as a small, clearly named Ruby method.
Each step in a stage is a bang method named for what it does to the tree, such as `write_every_dictionary_initialiser_the_same_way!`.
A stage's `call` method is only a series of these steps, written with `super.tap`, so any direct call to `drop`, `unwrap`, `transform` or `drop_tokens` goes in a bang method of its own.
A `GenerateAST` stage has no `super`, so it starts from `tree.tap` instead.

```ruby
def call
  super.tap do |root|
    drop_empty_brackets_from_new_with_initializer!(root)
    write_every_dictionary_initialiser_the_same_way!(root)
  end
end
```

Run `./bin/inspect <track> <file>` to see tree-sitter's tree, with each node's type, field names and tokens.

### Comments in language files

Each language file follows the style of Ruby's [`common/normalise.rb`](./lib/representer/languages/ruby/common/normalise.rb) and [`representation/reorder.rb`](./lib/representer/languages/ruby/representation/reorder.rb).
The comment at the top of a file says briefly why the stage exists.
For example, all solutions pass the tests and the code is never run, so reordering only exists to group students who list things in a different order.
The comment above each rule or method is an instruction that says what to do, such as "Mark each method..." or "Reorder the methods and other code inside classes and modules".
Add the reason only if it isn't obvious, usually because the difference can't change whether a passing solution works, or because the language's parser treats the two spellings as one.
Then show an example of the effect, in the comment block above the rule.
Write one example per line, and use `->` for a rule that changes code from one form to another (`# if (a) return 1;  ->  if (a) { return 1; }`).
Use `==` only where two spellings end up the same and neither is the form that the rule writes, mainly for sorting (`# {"a": 1, "b": 2} == {"b": 2, "a": 1}`).
For anything bigger, write "e.g. We convert:" followed by the code, then "internally into:" followed by the result.
Keep the examples short, and check each one against what the code does.
Leave no blank line between a comment and the code it describes.

A comment must tell the reader something the code doesn't, either why it is done or an example of the effect.
Never describe a constant, list or variable in words, and never write a fragment that only names a thing.
If there is nothing to add, write no comment.

```ruby
# Don't write this. It only restates the code.
# The escapes that a string reads, and the text each one stands for.
ESCAPES = { "n" => "\n", "t" => "\t" }
```

A declaration list is different: each item in a `names_are`, `names_are_defined_by`, `imports`, `pattern_contexts`, `comments_are`, `docstrings_are`, `skip_at_top` or similar list goes on its own line, with a short example of the code it matches at the end of the line, and «» around the name or code it matches.
The examples in a list line up in one column.
The line above each declaration is an instruction, such as "Rename the names of classes and modules."
A rule never has an example at the end of its line.

When a call spans several lines, lay it out like this:

- Each positional item, such as a name in `names_are_defined_by` or a pattern given to `drop` or `add_braces_to`, lines up with the first item.
- Each keyword argument, such as `as:` or `within:`, goes on a line of its own, four spaces in from the call, so the string after a `rewrite`'s `as:` starts in the same column as the pattern.
- A short `rewrite` goes on one line. In a run of one-line rewrites, the `as:` keywords line up in one column. Split a rewrite onto several lines only when it has another keyword, such as `within:`, or won't fit comfortably.

```ruby
rewrite "{{x}} == true",  as: "{{x}}"
rewrite "{{x}} != false", as: "{{x}}"

rewrite "{{type}}.{{name}}",
    as: "{{name}}",
    within: ["class {{type}} {}", "struct {{type}} {}"]

add_braces_to "if ({{...}}) {{body}}",
              "if ({{...}}) { } else {{body}}"
```

In a language file, a string is always code (a pattern, a token or an example), and a symbol is always a node type from the grammar.
Write every list out in full, such as `[:int, :xint]` or `["f", "d"]`, and never use `%i[]` or `%w[]`.
So `strip_tokens` and `keep_tokens` take strings, and their `only_in:` and `in:` take symbols.
When a declaration has several keyword arguments on several lines, they line up with the first:

```ruby
numbers_are integer: [:int, :xint],
            decimal: :float
```

Code comments and docs never mention the old representers, analyzers or `exercism/snippet-extractor`.
Each comment explains its rule on its own terms.
Instead, each language has a `transition.md` in its folder, with three sections: "Representation", "Analysis" and "Snippet".
Each section says how this service differs from the tool it replaces (the language's old representer, its old analyzer and snippet-extractor) and why.
If there is nothing to say for a section yet, it says so in one sentence.

Update a comment whenever the code below it changes.
Write every comment by the rules in "Writing comments and docs" below.

Put a blank line above a comment that describes the code below it, so each comment and its code read as one unit. The comment needs no blank line when it's the first thing in a method, class, module or block, follows another comment, or follows `private`. Rubocop checks this with `Representer/EmptyLineBeforeComment` (in `rubocop/cop/representer/`) and can fix it with `bundle exec rubocop -a`.

### GenerateAST's declarations

The top of `GenerateAST` lists the steps that every language needs, as declarations.
The engine applies them around the language's own steps:

```ruby
module Representer::Languages::Ruby::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    strip_tokens "def", "end", "if", "then"

    # Strip these tokens only from block parameters, because elsewhere they are operators.
    strip_tokens "|", only_in: :block_parameters

    # Keep the `;` in block parameters, because `|a; b|` makes b a block-local variable.
    keep_tokens ";", in: :block_parameters

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (1 + 2)  ->  1 + 2
    unwrap :parenthesized_statements

    # Write each number as its value.
    # 1_000  ->  1000
    numbers_are integer: :integer, decimal: :float
  end
end
```

The engine writes the numbers before the language's own steps.
The language's steps can still read the tokens and the brackets, so the engine unwraps the brackets and strips the tokens after them.
If one of the language's steps needs the brackets gone, unwrap them in a step of its own instead, at the right point (as Elixir and F# do).
[REPRESENTER_DSL.md](./REPRESENTER_DSL.md#generateasts-declarations) explains each declaration.

`strip_tokens` lists the tokens to strip explicitly.
To draft the list from the grammar, run:

```shell
./bin/draft-ast-tokens <grammar>
```

It lists the tokens that always sit in a fixed place in a node, which are safe to strip.
It also lists the tokens that are optional, one of a choice, or have text that varies, for a human to review.
The ones to review often carry meaning (C++'s `delete[]`, Ruby's `&.`), but some are only layout (brackets around Ruby's arguments).
Check each one, write the reviewed list into the class in a few grouped lines, and say in a comment why each group is stripped.
Read a token's text before stripping it if its text varies (Ruby's string opener can be `'`, `"` or `%q(`), and check the grammar's extras, which can hold content (Ruby's heredoc bodies).

### Strings and numbers

Turn each string into its value with `literal(value)`, so that `'a'` and `"a"` are the same.
Read only the escapes used in solutions, and keep any other escape as a node of its own, so two different strings can never get the same value.
Give two numbers one form only if the language reads them as the same value of the same type.
`numbers_are` does this with the readers in [`Engine::Numbers`](./lib/representer/engine/numbers.rb), and takes the prefixes and suffixes that the language reads.

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
`RepresenterTest` gives you `assert_same_representation`, `refute_same_representation`, `assert_basic_representation` (which checks that a solution doesn't parse, and so gets Basic's representation) and `assert_unrepresentable` (which checks that a solution gets no representation, for a given reason).

Also add a request test: a `tests/<track>/<name>/request.json` with a typical solution and its tests, and an `expected_response.json` made by running `./bin/run.sh tests/<track>/<name>/request.json tests/<track>/<name>` and copying `response.json` after checking it.

Run the tests as "Running the tests" below says.

If the track has golden data in [`test/golden/<track>/`](./test/golden/), run `./bin/regenerate-golden <track>` after changing a stage, and review the diff.
The golden tests fail if a change splits or merges any of the production groups, unless the difference is listed in the track's `differences.yml` (see [`test/golden/README.md`](./test/golden/README.md)).

## 5. Write the snippet

The website shows the first 15 lines of each solution on its card.
Create `snippet.rb` in the language's folder, and list what to leave out, such as comments and the imports at the top of the file:

```ruby
module Representer::Languages::Ruby
  class Snippet < Representer::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 1

    # Remove every comment, wherever it is.
    remove :comments # x = 1 «# The answer»

    # Skip the requires at the top of the file, up to the first other statement.
    skip_at_top :require,          # «require "set"»
                :require_relative  # «require_relative "helpers"»
  end
end
```

A language's snippet reads the comments and docstrings declared in `spec.rb`, so `remove :comments, :docstrings` needs nothing else.
[REPRESENTER_DSL.md](./REPRESENTER_DSL.md#snippets) explains every declaration.
To choose the words, look at the start of the track's example solutions.
Add a test to [`test/engine/snippet_test.rb`](./test/engine/snippet_test.rb) for anything unusual, and run the track's request tests, whose expected responses include the snippet.
If Rouge has no lexer for the language, add `comment_lines`, so a file that doesn't parse still loses its comments.

A track with no representer of its own can have a snippet too.
Its folder holds only `snippet.rb`, which starts with `tracks "<slug>"`, and its rules apply to lines.

Bump the snippet's version whenever its snippets could change. The snippet's version is separate from the representation's version.

## 6. Set the version

The representation's version is in `representation.rb`.
A new language starts at version 2, because the old per-track representers all reported version 1.

Bump the representation's version whenever its output could change for any solution: a change to a stage, a rule or the names, or a new grammar commit.
The website will then represent the track's solutions again.

Basic has its own version, for the tracks with no representer of their own.
If a solution doesn't parse, it gets Basic's representation with the language's version, so a change to Basic's output must also bump every language's version.

## How the code is organised

The code is built from small [Mandate](https://github.com/iHiD/mandate) commands.
Each command is a class that does one clearly named job, such as `Engine::RenameUserDefinedNodes` or `Engine::DropImports`.
It takes its inputs with `initialize_with`, and code calls it with `.()`, as in `Engine::DropImports.(tree, language)`.
Each command has a unit test file of its own, named after it, such as `test/engine/rename_user_defined_nodes_test.rb`.
The tests check the command on small trees, apart from any language where they can.

Every file uses the compact module form, such as `module Representer::Engine` or `module Representer::Languages::Ruby`, and never nested modules.

Write new code this way, and convert older code to it when you change that code.

## Running the tests

If a change only touches comments, docs or the Rubocop config, run `bundle exec rubocop --except Metrics` and skip the tests.

If a change only touches one language's files (its folder, its grammar's pin or its golden data), run only that language's tests:

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
