# Representations

A representation is a normal form of a student's solution.
Inspector throws away everything that makes no difference to the solution working, gives one spelling to code that means the same thing, and replaces the names the solution defines with placeholders.
Two solutions with the same approach then get the same representation, and the website groups them, so a mentor's feedback on one reaches every solution in the group.

Every solution that Inspector sees passes its tests.
So it can throw away code such as comments, imports, brackets that only group, and the way a number or a string is written, because two solutions that differ only in such code would pass the same tests in the same way, and a mentor would give them the same feedback.

This doc covers the `representation` output, Basic, versions, the golden data, and the declarations and verbs that only the representation uses.
[common.md](./common.md) covers the language folder, the declarations in `common/spec.rb` and `GenerateAST`, and [code-patterns.md](./code-patterns.md) covers code patterns. The representation shares both with the other outputs.
[how-it-works.md](./how-it-works.md) explains the steps that turn a solution into its representation.

## The `representation` output

The `representation` output has these fields:

- `representation` is the normalised solution.
- `mapping` says which name each placeholder replaced.
- `version` is the version of the track's representer. It changes whenever the track's output changes, so the website knows to represent the track's solutions again.

```json
{
  "representation": {
    "representation": "...",
    "mapping": { "PLACEHOLDER_1": "name" },
    "version": 12
  }
}
```

The representation doesn't use the request's `exercise_files`.

Some solutions can't be represented.
For those, the `representation` output is an error with the language's version, and `error` is one of these reasons:

- `too_deep`: the code nests deeper than 1,000 levels.
- `too_large`: the solution files hold more than 200 KB, or the exercise files more than 500 KB. The load balancer limits bodies to 1 MB.
- `no_source_files`: none of the solution's files is a source file of the language. Inspector ignores files in other formats, such as Rust's `Cargo.toml` or a `HELP.md`, and test and tool config files, such as `leap_test.go` or `babel.config.js`.
- `internal_error`: one of the representer's rules raised an error. This is a bug in the representer, so it also writes the error to the log.

The website then marks the submission as unrepresentable.
Basic, which serves the tracks with no representer of their own, can represent any solution that isn't too large and has a source file.
A solution that the grammar can't parse gets Basic's representation (see "Basic" below).

## Basic

Each language with a `common/spec.rb` in its folder in [`lib/representer/languages/`](../lib/representer/languages/) has a representer of its own, and Inspector parses it with [tree-sitter](https://tree-sitter.github.io/tree-sitter/).
Every other track gets a simpler token-based representation called Basic.

Basic ([`lib/representer/languages/basic.rb`](../lib/representer/languages/basic.rb)) splits the code into tokens with the track's [Rouge](https://github.com/rouge-ruby/rouge) lexer, drops comments, spacing and (in the tracks where it can find them reliably) imports, and keeps everything else, including line breaks and (in languages like Python) indentation.
It renames nothing, so it only merges solutions that differ in nothing but comments and formatting.

Basic also represents a solution that its language's grammar can't parse.
Every solution passes its tests, so a file that doesn't parse shows a gap in the grammar, such as syntax newer than the pinned commit.
Basic still groups those solutions with the ones that differ only in comments and formatting.
The representation starts with a line that says `basic`, so it can never equal a tree's representation, which starts with `(`.
It keeps the language's version, so each track has one version.
If Basic's output changes, every language's version must change too.

## Versions

When the version changes, the website represents all of the track's solutions again.
A language therefore bumps its representation's version, in `representation/spec.rb`, whenever the representation of any solution could change.
Versions run from 2 to 32767, because the old per-track representers all reported 1.

```ruby
version 12
```

Each output has its own version, so a change to the analysis or the snippet never makes the website represent the track's solutions again.

## Golden data

The golden data tests in [`test/golden/`](../test/golden/) run over about 20,000 real published solutions.
They check that every solution keeps its representation, and that the solutions stay in the same groups as on production, apart from the differences listed for each track.
Each solution that was alone in its production representation also has a near-miss variant, a copy with one small change to its code, and the tests check that the two get different representations.
[`test/golden/README.md`](../test/golden/README.md) explains them, and how to regenerate them with `./bin/regenerate-golden` after a deliberate change.

## The representation's declarations

These declarations go in `representation/spec.rb`, next to `version` (see "Versions" above).
The same file also declares `pattern_contexts`, `placeholder_suffix` and `keywords_used_as_names`, which say how the engine reads every code pattern in the language (see [code-patterns.md](./code-patterns.md#declarations-for-code-patterns)).
In the inline examples, «» marks the captured name: the part of the code that the item on that line matches.

### names_are

A language lists the leaf types that hold names, as they are after `GenerateAST`.
If a type's text starts with something that isn't part of the name, the language gives that text as `without_prefix:`.
A language can call `names_are` more than once.

```ruby
names_are :simple_symbol, without_prefix: ":"
```

### names_are_defined_by

A language lists the node types that define a name, as they are after `GenerateAST`.
A type given on its own defines each of its children that is a name.
A type given with a field defines only the child in that field, so `assignment: :left` defines `x` in `x = y`, and doesn't define `y`.
If the grammar puts several children in the field, as Go's `var a, b int` does, the type defines each of them.
A language can call `names_are_defined_by` more than once.

```ruby
names_are_defined_by :method_parameters, assignment: :left
```

### imports

A solution that passes its tests has already loaded everything it needs.
The engine therefore drops every import from every file, after the common stages.
A language lists the code that counts as an import, as code patterns (see [code-patterns.md](./code-patterns.md)).

```ruby
imports 'require "{{_}}"'
```

## Verbs for Normalise

These verbs go in `common/normalise.rb` or `representation/normalise.rb`, and the analysis's `analysis/normalise.rb` can use them too.
Their arguments are code patterns (see [code-patterns.md](./code-patterns.md)).

### drop

This verb removes every piece of code that matches one of the patterns.
`drop :docstrings` removes the docstrings declared in `common/spec.rb`.

```ruby
drop "{{_}} if debug?"
drop :docstrings
```

### drop_calls_to

This verb removes every call to these methods, written as `name({{...}})`.

```ruby
drop_calls_to :puts
```

### rewrite

This verb turns each piece of code that matches the pattern into the code given in `as:`.
It starts with the innermost code and works outwards.
Each named placeholder in `as:` becomes a copy of the code that it matched.

```ruby
rewrite "{{list}}.length", as: "{{list}}.size"
```

With `within:`, the rule only applies inside code that matches one of those patterns.
A placeholder used in both must match the same code, so this rule drops `Counter.` before `Counter.Start()` inside the class `Counter`, and leaves `Math.Max` alone:

```ruby
rewrite "{{type}}.{{name}}",
    as: "{{name}}",
    within: "class {{type}}\n{{...}}\nend"
```

### attach_to_next

Some statements belong to the definition after them, such as Elixir's `@spec`.
This verb moves each statement that matches one of the patterns into the next statement, as its last child.
The two then move together when `Reorder` sorts them.
If several matches come one after the other, they all move into the next statement.
With `past:`, the statements move past any statement that matches one of those patterns, and `past: :docstrings` gives the docstrings declared in `common/spec.rb`.

```ruby
attach_to_next "@spec {{...}}",
    past: :docstrings
```

### attach_to_each_following

Some lines change every definition after them, such as Ruby's `private`.
This verb removes each line that matches one of the patterns.
It gives a copy of the line to every definition after it that matches a pattern in `to:`, up to the next of these lines or the end of the container.
Each definition then keeps the line's meaning wherever it moves.

```ruby
attach_to_each_following "private",
                         "public",
    to: ["def {{_}}({{...}})\n{{...}}\nend"]
```

### add_braces_to

This verb puts braces around a body that has none.
Each pattern marks the body with `{{body}}`.
The engine writes the body as empty braces to read the pattern, and so learns the statement's type, the body's field and the type of a block.
It then wraps the body of every such statement in a block, unless it already is one.
If a pattern has other empty braces, they must come before `{{body}}`.

```ruby
add_braces_to "if ({{...}}) {{body}}",
              "if ({{...}}) { } else {{body}}"
```

Some grammars read empty braces as something else, such as Wren's, which reads them as an empty map.
A language then gives the block's type in `block:`, and the engine finds the body's field from the `{{body}}` in each pattern.

```ruby
add_braces_to "if ({{...}}) {{body}}",
              "while ({{...}}) {{body}}",
    block: :block
```

### inside

Every verb above also takes `inside:`, which gives its code patterns a context of their own to parse in (see [`pattern_contexts`](./code-patterns.md#pattern_contexts)).

```ruby
drop "*{{_}}", inside: "def f({{pattern}}) end"
```

## Verbs for Reorder

### sort

This verb goes in `representation/reorder.rb`.
It sorts the children of every node of these types by their code, written with every renamed name blank.
Children with the same code keep their order, and inner nodes are sorted before the nodes around them.
A language lists only containers of definitions or entries, such as a class's body or a hash, because a block of statements runs in order.
If the grammar gives such a container the same type as a block of statements, `GenerateAST` gives it a type of its own first.

```ruby
module Representer::Languages::Ruby::Representation
  class Reorder < Representer::Engine::Reorder
    sort :class_body, :hash
  end
end
```

## Common mistakes

- If a node type that defines a name is missing from `names_are_defined_by`, the engine won't rename that name. Two solutions that differ only in the spelling of that name will then give different output. Check that every kind of definition in the language is listed.
- Never list a block of statements in `sort`. Statements run in order, so sorting them changes what the program does. List only containers whose order makes no difference, such as a class's body or a hash.
- If a pattern doesn't match, check its shape with `./bin/inspect <track> <file>` (see [code-patterns.md](./code-patterns.md)).
