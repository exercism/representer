# Common

Inspector turns a student's solution into a normal form, so that two solutions with the same approach give the same output.
To do this for a language, it needs to know a few things that only a person who knows the language can say: which names the solution defines, which code does nothing (such as comments and imports), and which spellings mean the same thing.
A language says these things in a folder of small files of declarations, plus one file for each stage the language needs.
This doc covers the folder's layout and its `common/` folder, which holds what every output shares: the declarations in `common/spec.rb`, `GenerateAST` and its declarations, and `common/normalise.rb`.
Each output's own declarations and verbs are in [representation.md](./representation.md), [analysis.md](./analysis.md) and [snippets.md](./snippets.md), and [code-patterns.md](./code-patterns.md) explains the code patterns that all three use.
[CONTRIBUTING.md](../CONTRIBUTING.md) explains how to add a language.

## How a language is laid out

Each language has a folder of its own in `lib/inspector/languages/`.
The folder has a folder for each output, and a folder called `common/` for what every output shares.
Each of these folders holds a `spec.rb` with its settings, and the stages for that output.
The folder's `common/spec.rb` says what the language is and how its files are read:

```
lib/inspector/languages/ruby/
  common/spec.rb                Ruby::Common::Spec
  common/generate_ast.rb        Ruby::Common::GenerateAST
  common/normalise.rb           Ruby::Common::Normalise
  representation/spec.rb        Ruby::Representation::Spec
  representation/normalise.rb   Ruby::Representation::Normalise
  representation/reorder.rb     Ruby::Representation::Reorder
  analysis/spec.rb              Ruby::Analysis::Spec
  analysis/normalise.rb         Ruby::Analysis::Normalise
  snippet/spec.rb               Ruby::Snippet::Spec
  transition.md
```

`common/` holds the stages that every output needs, and `representation/` holds the stages that only the representation needs.
`analysis/` holds the analysis's own `Normalise` stage and one file of rules for each exercise (see [analysis.md](./analysis.md)).
`transition.md` says how the language differs from the tools it replaces.

```ruby
module Inspector::Languages::Ruby::Common
  class Spec < Inspector::Engine::Language
    tracks "ruby"
    grammar "ruby"
    extensions ".rb"

    # Treat these as comments.
    comments_are :comment # x = 1 «# The answer»
  end
end
```

```ruby
module Inspector::Languages::Ruby::Representation
  class Spec < Inspector::Engine::Representation
    version 12
  end
end
```

When a language defines its `Common::Spec`, the engine looks in the language's folder for each output's `spec.rb` and each stage's file.
If a file is missing, the language doesn't run that stage.

A language that builds on another can subclass the other language's outputs and stages, as TypeScript's `class GenerateAST < Inspector::Languages::JavaScript::Common::GenerateAST` does.
Each subclass starts with its parent's declarations and adds its own to them, so it declares only what its language adds.

## The language's declarations

These declarations go in `common/spec.rb`.

### tracks

A language says which tracks it represents.
The engine then uses the language for those tracks.

```ruby
tracks "ruby"
```

### grammar

A language names its tree-sitter grammar's entry in `grammars.yml`.
Tree-sitter is the parser library that reads each file.
[tree-sitter-ecosystem.md](./tree-sitter-ecosystem.md) lists the grammars that exist for each track.

```ruby
grammar "ruby"
```

### extensions

The engine represents only the solution files that have one of these extensions.
It ignores other files, such as Rust's `Cargo.toml`.

```ruby
extensions ".rb"
```

### comments_are

A language lists the node types that are comments.
The engine drops them before `GenerateAST`, and the snippet removes them.

```ruby
comments_are :line_comment, :block_comment
```

### comment_text

Some grammars don't know the language's comments, as Factor's reads `! The answer` as words.
A language gives the comments' text as a regular expression, and the engine replaces each match with spaces before it parses a file.
`outside:` gives the code that a comment can't be inside, such as a string, so a comment marker in it stays.

```ruby
comment_text(/(?<!\S)#?!(?=\s|\z)[^\n]*/,
             outside: /"(?:\\.|[^"\\])*"/m)
```

### docstrings_are

A language lists the code that counts as a docstring, as code patterns (see [code-patterns.md](./code-patterns.md)).
The snippet removes it, and a `Normalise` stage can drop it with `drop :docstrings`.
The snippet works on the grammar's own tree, so the engine compiles each pattern twice: once for the grammar's tree, for the snippet, and once through `GenerateAST`, for the stages.

```ruby
docstrings_are "@moduledoc {{...}}", "@doc {{...}}"
```

### text_nodes

Some grammars give a node's quotes or marks as its children, and leave its text out, such as F#'s `1.5` and `@"a\b"`.
A language lists these node types, and the engine turns each such node into a leaf that holds its whole source text.

```ruby
text_nodes :float, :verbatim_string
```

### text_between_children

Some grammars leave the text between a node's children out of the tree, such as the text of an F# string.
A language lists these node types, and the engine keeps each stretch of that text as a "fragment" leaf.

```ruby
text_between_children :string
```

## Stages

A stage is a class in its own file in the language's folder.
Each stage inherits from the engine's class of the same name, and runs on a tree.
The engine runs the stages in this order, between its own steps (see [how-it-works.md](./how-it-works.md#the-engines-steps)):

1. `GenerateAST` (in `common/generate_ast.rb`) runs on each file. It turns tree-sitter's tree into the tree that the language's own parser would give, such as Ruby's `parser` gem or Elixir's `Code.string_to_quoted`. [writing-generate-ast.md](./writing-generate-ast.md) explains how to write it.
2. `Normalise` (in `common/normalise.rb` and `representation/normalise.rb`) runs on each file. It removes code that makes no difference and gives one form to code that means the same thing, with the verbs in [representation.md](./representation.md#verbs-for-normalise).
3. `Reorder` (in `representation/reorder.rb`) runs on all the files joined into one tree. It sorts code that can come in any order (see [representation.md](./representation.md#verbs-for-reorder)).

The analysis runs `GenerateAST`, the common `Normalise` and its own `analysis/normalise.rb` (see [analysis.md](./analysis.md)).

## common/normalise.rb

`common/normalise.rb` holds the `Normalise` rules that both the representation and the analysis need, written with the verbs in [representation.md](./representation.md#verbs-for-normalise).
A rewrite goes in `common/normalise.rb` only if it hides no spelling that an analysis rule would need.
If you aren't sure, put it in `representation/normalise.rb`.
Every `Reorder` goes in `representation/`, and so does dropping docstrings, as the analysis may read them.

## GenerateAST's declarations

These declarations go at the top of `GenerateAST`.
The engine writes the numbers before the language's own steps, and unwraps the brackets and strips the tokens after them, because the language's steps can still read them.

### strip_tokens

This declaration strips anonymous tokens (keywords and punctuation) from every node, because the node types already show them.
With `only_in:`, it strips them only from the node types given.

```ruby
strip_tokens "def", "end", "(", ")"
strip_tokens "|", only_in: :block_parameters
```

### keep_tokens

This declaration keeps tokens in the node types given in `in:`, although `strip_tokens` strips them from every other node.

```ruby
keep_tokens ";", in: :block_parameters
```

### unwrap

This declaration replaces each node of these types that has exactly one named child with that child, for brackets that only group.

```ruby
unwrap :parenthesized_statements
```

### lists_are

Some grammars give the items of a form no field names, such as the lists of Clojure and Scheme.
This declaration gives the first item of each node of these types the field name `head`, so the tree marks the form's head, and a code pattern's first item matches only a head.

```ruby
lists_are :list_lit, :vec_lit
```

### numbers_are

This declaration writes each number leaf of these types as its value, so `1_000` and `1000` become the same leaf.
`integer:` and `decimal:` each take a node type or a list of them.
If the grammar gives integers and decimals one node type, as Clojure's does, give that type to both. The engine then reads each number as an integer if it can, and as a decimal otherwise.
If the language stores every number the same way, as JavaScript does, give the type to `number:` instead. The engine then writes a whole number without a point, so `1.0` and `1` become the same leaf.
`prefixes:` maps each base prefix of an integer to its base, in the order to try them.
`suffixes:` lists the type suffixes that a decimal may end with, which stay in lower case.
`separators:` lists the characters that may separate digits, and is `["_"]` unless the language gives it.
A number that the engine can't read keeps its text.

```ruby
numbers_are integer: :integer,
            decimal: :float,
            prefixes: { "0x" => 16, "0o" => 8, "0b" => 2, "0" => 8 }

numbers_are number: :number

numbers_are integer: [:base10, :base16],
            decimal: :float,
            separators: ["_", ","]
```
