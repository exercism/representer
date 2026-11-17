# Adding a language

Every track gets the Basic representer until it has a class of its own.
This guide explains how to add one.
The Ruby, JavaScript and C# classes in [`lib/representer/languages/`](./lib/representer/languages/) are worked examples, and the quickest way to start is to copy the one closest to your language.

The steps are:

1. Pin and build the grammar.
2. Port the old representer's tests.
3. Write the language's class.
4. Add tests for anything else the class does.
5. Set the version.

## The goal

Two solutions should get the same representation if a mentor would give them the same feedback, and different representations otherwise.
The website only represents solutions that pass the tests, so a mentor's feedback is about the approach.

That gives one firm rule: **only rename a name if the solution gives it its whole meaning.**
If the language, a library, the tests or a protocol also gives the name a meaning, keep it.
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
Add `src:` if the grammar's `parser.c` isn't in `src/` (for example `src: typescript/src`), and `symbol:` if the grammar's C name isn't the entry's name (tree-sitter-c-sharp exports `tree_sitter_c_sharp`, so its entry is called `c_sharp`).

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
- `fallback: true`: the input has a syntax error that tree-sitter rejects, so it gets Basic. Only distinctness is checked.
- `why`: the reason. Every deviation needs one.

The common deviations are library names (this representer keeps them; several old ones renamed them) and old outputs that weren't valid code.
Never use a deviation to hide a merge that the old representer kept apart.

## 3. Write the language's class

Create `lib/representer/languages/<track>.rb`.
It is loaded automatically.

```ruby
module Representer
  module Languages
    class Python < Language
      tracks "python"
      version 2
      grammar "python"
      extensions ".py"

      names :identifier

      drop "(comment)"
      drop_tokens "(", ")", ":", ","

      rewrite "(parenthesized_expression (_) @inner)", "@inner"

      rename "(parameters (identifier)* @name)"
      rename_member "(function_definition name: (identifier) @name)"
      member "(attribute attribute: (identifier) @name)"
      keep "__init__", "__str__"
    end
  end
end
```

Run `./bin/inspect <track> <file>` to see the tree that your rules work on, with each node's type, field names and tokens.
Write the rules against that tree.

### Setup

- `tracks "python"`: the track slugs this class represents.
- `version 2`: the representer version (see step 5).
- `grammar "python"`: the grammar's name in `grammars.yml`.
- `extensions ".py"`: the language's file extensions. Exercise files with other extensions are ignored.
- `names :identifier, ...`: the leaf types that hold names. Only these can be renamed. If a type's text includes a prefix that isn't part of the name, give it as a keyword (Ruby has `simple_symbol: ":"` for `:name`).

### Patterns

Every rule takes a pattern, written in a subset of [tree-sitter's query syntax][queries]:

| Pattern | Matches |
|---|---|
| `(call)` | a node of type `call` |
| `(_)` | any named node |
| `_` | any node, including tokens |
| `(call method: (identifier))` | a `call` whose `method` field is an `identifier` |
| `(call !receiver)` | a `call` with no `receiver` field |
| `(binary "==")` | a `binary` with an `==` token among its children |
| `(identifier "String")` | an `identifier` whose text is `String` |
| `(identifier /\Aattr_/)` | an `identifier` whose text matches the regular expression |
| `[(class) (module)]` | either |
| `(argument_list (symbol)* @name)` | every `symbol` child, captured as a list |
| `(parameters (identifier)? @name)` | the child, if there is one |
| `(method name: (_) @name)` | captures the name as `@name` |

Child patterns without a field match children in order, and other children may sit between them.
Patterns may span several lines (use a heredoc), and `;` starts a comment.

### Drop rules

- `drop "(comment)"` removes every node that matches.
- `drop "(method_parameters)", where: ->(match) { match.node.children.empty? }` removes only the matches that pass the check.
- `drop_tokens "(", ")", ";"` leaves these anonymous tokens out of the tree. Only drop a token if the node's type already says everything the token says. For example, Ruby drops `"if"` (the node type is `if`) but keeps `"=="` and `"!="` (both are `binary` nodes).

### Rewrite rules

Rewrite rules turn different spellings of the same code into one.
They run from the leaves up, and run again on their own output.

- With a template: `rewrite "(if_modifier body: (_) @body condition: (_) @condition)", "(if condition: @condition consequence: (then @body))"`. A template uses the pattern syntax: `(type ...)` builds a node, `field:` sets a field, `@name` inserts a copy of a capture, and `"!"` adds a token. Check with `./bin/inspect` that the template builds exactly the tree that the grammar produces for the other spelling, including the order of children.
- With a block, which receives the match and returns the replacement node, or nil to change nothing. `match.node` is the matched node and `match[:name]` a capture. The helpers `build(type, *children)`, `leaf(type, text)`, `literal(value)`, `token(text)` and `copy(node)` make new nodes. A block can also change `match.node` in place and return it.
- `retype do_block: :block` gives nodes of one type another type.
- `unwrap :parenthesized_expression` replaces a node that has one named child with that child.

A rule must not match its own output, or it will run forever (the engine raises an error after 50 rewrites of one node).
For example, Ruby's string rule only matches strings that still have their quote token, and its output has none.

Strings are a common rewrite: turn each string into its value with `literal(value)`, so that `'a'` and `"a"` are the same.
Decode only the escapes you are sure of, and keep any other escape's source text, so two different strings can never get the same value.

### Rename and keep rules

Each of these patterns captures a name's leaf as `@name`.
Renaming goes by name, not by scope: every use of a renamed name gets the same placeholder.

- `rename`: a name the student defines for a local variable or parameter. It is renamed everywhere, except after a dot.
- `rename_member`: a name the student defines for a method, function, property, field, class or constant. It is renamed everywhere, including after a dot, unless it is a library name.
- `member`: a name used after a dot (`obj.name`), or anywhere else that refers to some other object's member. It is only renamed if the solution defines a member with that name, so `xs.count` keeps `count` even if the student has a local called `count`.
- `keep "initialize", "to_s"`: names that are never renamed, such as methods the language calls itself.
- `keep "(keyword_parameter name: (identifier) @name)"`: names that a pattern finds are never renamed, such as keyword parameters, which callers use.
- `library_names File.join(__dir__, "library_names", "python.txt")`: a file of the language's core and standard-library names, one per line. A student's member with one of these names keeps it.

Every name used in the exercise's test files is kept automatically, and so is every member defined in the exercise's stub.

## 4. Add tests for anything else the class does

Add tests to `test/languages/<track>_test.rb` for every rewrite rule, and for pairs of solutions that must stay apart.
`RepresenterTest` gives you `assert_same_representation`, `refute_same_representation` and `assert_falls_back`.
See [`test/languages/ruby_test.rb`](./test/languages/ruby_test.rb).

Also add a request test: a `tests/<track>/<name>/request.json` with a typical solution and its tests, and an `expected_response.json` made by running `./bin/run.sh tests/<track>/<name>/request.json tests/<track>/<name>` and copying `response.json` after checking it.

Run everything with `./bin/run-tests.sh`.

## 5. Set the version

A new language starts at version 2, because the old per-track representers all reported version 1.

Bump a language's version whenever its output could change for any solution: a new or changed rule, a new library names list, or a new grammar commit.
The website will then represent the track's solutions again.

A language that can't parse a solution falls back to Basic but reports its own version.
So a change to Basic's output must bump Basic's version and every language's version, in the same commit.

[parsers]: https://github.com/tree-sitter/tree-sitter/wiki/List-of-parsers
[queries]: https://tree-sitter.github.io/tree-sitter/using-parsers/queries/index.html
