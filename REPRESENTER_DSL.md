# Representer DSL

The representer turns a student's solution into a normal form, so that two solutions with the same approach give the same output.
To do this for a language, it needs to know a few things that only a person who knows the language can say: which names the solution defines, which code does nothing (such as comments and imports), and which spellings mean the same thing.
A language says these things in a folder of small files of declarations, plus one file for each stage the language needs.
[CONTRIBUTING.md](./CONTRIBUTING.md) explains how to add a language.

## What the engine does for every language

The engine does the rest of the work.
For every language, it does these things in order:

1. It ignores files without one of the language's extensions, and test and config files.
2. It turns Windows line endings into plain line breaks, then parses each file with the language's grammar. If a file doesn't parse, the solution gets Basic's representation instead (see README.md).
3. It drops the comments declared in `common/spec.rb`, and runs the language's common stages (`GenerateAST`, then `Normalise`) on each file.
4. It drops the representation's imports from each file.
5. It runs the representation's `Normalise` stage on each file.
6. It renames every name defined by the solution, wherever the name appears: in its definition, and in every use, call and symbol. A name that the solution doesn't define keeps its name, such as a call to a library method. The engine never reads the exercise's tests or stub for names.
7. It joins the files into one tree, in an order set by their code, and leaves out the file names.
8. It runs the representation's `Reorder` stage on the joined tree.
9. It numbers the placeholders in the order the names appear, and writes the tree out as a nested, bracketed text form (an s-expression).

The snippet works on the grammar's own tree, before step 3.

## How a language is laid out

Each language has a folder of its own in `lib/representer/languages/`.
The folder has a folder for each output, and a folder called `common/` for what every output shares.
Each of these folders holds a `spec.rb` with its settings, and the stages for that output.
The folder's `common/spec.rb` says what the language is and how its files are read:

```
lib/representer/languages/ruby/
  common/spec.rb                Ruby::Common::Spec
  common/generate_ast.rb        Ruby::Common::GenerateAST
  common/normalise.rb           Ruby::Common::Normalise
  representation/spec.rb        Ruby::Representation::Spec
  representation/normalise.rb   Ruby::Representation::Normalise
  representation/reorder.rb     Ruby::Representation::Reorder
  snippet/spec.rb               Ruby::Snippet::Spec
  transition.md
```

`common/` holds the stages that every output needs, and `representation/` holds the stages that only the representation needs.
`transition.md` says how the language differs from the tools it replaces.

```ruby
module Representer::Languages::Ruby::Common
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
module Representer::Languages::Ruby::Representation
  class Spec < Representer::Engine::Representation
    version 12
  end
end
```

When a language defines its `Common::Spec`, the engine looks in the language's folder for each output's `spec.rb` and each stage's file.
If a file is missing, the language doesn't run that stage.

A language that builds on another can subclass the other language's outputs and stages, as TypeScript's `class GenerateAST < Representer::Languages::JavaScript::Common::GenerateAST` does.
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

A language lists the code that counts as a docstring, as code patterns.
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

## The representation's declarations

These declarations go in `representation/spec.rb`.
In the inline examples, «» marks the captured name: the part of the code that the item on that line matches.

### version

When the version changes, the website represents all of the track's solutions again.
A language therefore bumps its representation's version whenever the representation of any solution could change.
Versions run from 2 to 32767, because the old per-track representers all reported 1.

```ruby
version 12
```

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
A language lists the code that counts as an import, as code patterns (see "Code patterns" below).

```ruby
imports 'require "{{_}}"'
```

### pattern_contexts

Some code patterns don't parse on their own, such as a `def` without its `end`.
A language lists code to put such a pattern in, and marks the pattern's place with `{{pattern}}`.
The engine tries the contexts in order.

```ruby
pattern_contexts "{{pattern}}\nend"
```

### placeholder_suffix

The engine spells each placeholder in a code pattern as a name, such as `name__` for `{{name}}`.
If the grammar can't read a name that ends in `__`, as Nim's can't, a language gives another suffix.

```ruby
placeholder_suffix "placeholder"
```

### keywords_used_as_names

If one of the grammar's keywords comes out as a name in a code pattern, the engine rejects that parse (see "Code patterns" below).
A language lists the keywords that it also uses as names, such as Common Lisp's `cl`, so a pattern such as `:cl` can use them.

```ruby
keywords_used_as_names "cl"
```

## Stages and their verbs

A stage is a class in its own file in the language's folder.
Each stage inherits from the engine's class of the same name, and runs on a tree.
The engine runs the stages in this order, between its own steps (see "What the engine does for every language" above):

1. `GenerateAST` (in `common/generate_ast.rb`) runs on each file. It turns tree-sitter's tree into the tree that the language's own parser would give, such as Ruby's `parser` gem or Elixir's `Code.string_to_quoted`. [WRITING_GENERATE_AST.md](./WRITING_GENERATE_AST.md) explains how to write it.
2. `Normalise` (in `common/normalise.rb` and `representation/normalise.rb`) runs on each file. It removes code that makes no difference and gives one form to code that means the same thing, with the verbs below.
3. `Reorder` (in `representation/reorder.rb`) runs on all the files joined into one tree. It sorts code that can come in any order.

### GenerateAST's declarations

These declarations go at the top of `GenerateAST`.
The engine writes the numbers before the language's own steps, and unwraps the brackets and strips the tokens after them, because the language's steps can still read them.

#### strip_tokens

This declaration strips anonymous tokens (keywords and punctuation) from every node, because the node types already show them.
With `only_in:`, it strips them only from the node types given.

```ruby
strip_tokens "def", "end", "(", ")"
strip_tokens "|", only_in: :block_parameters
```

#### keep_tokens

This declaration keeps tokens in the node types given in `in:`, although `strip_tokens` strips them from every other node.

```ruby
keep_tokens ";", in: :block_parameters
```

#### unwrap

This declaration replaces each node of these types that has exactly one named child with that child, for brackets that only group.

```ruby
unwrap :parenthesized_statements
```

#### lists_are

Some grammars give the items of a form no field names, such as the lists of Clojure and Scheme.
This declaration gives the first item of each node of these types the field name `head`, so the tree marks the form's head, and a code pattern's first item matches only a head.

```ruby
lists_are :list_lit, :vec_lit
```

#### numbers_are

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

### Verbs for Normalise

These verbs go in `common/normalise.rb` or `representation/normalise.rb`.

#### drop

This verb removes every piece of code that matches one of the patterns.
`drop :docstrings` removes the docstrings declared in `common/spec.rb`.

```ruby
drop "{{_}} if debug?"
drop :docstrings
```

#### drop_calls_to

This verb removes every call to these methods, written as `name({{...}})`.

```ruby
drop_calls_to :puts
```

#### rewrite

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

#### attach_to_next

Some statements belong to the definition after them, such as Elixir's `@spec`.
This verb moves each statement that matches one of the patterns into the next statement, as its last child.
The two then move together when `Reorder` sorts them.
If several matches come one after the other, they all move into the next statement.
With `past:`, the statements move past any statement that matches one of those patterns, and `past: :docstrings` gives the docstrings declared in `common/spec.rb`.

```ruby
attach_to_next "@spec {{...}}",
    past: :docstrings
```

#### attach_to_each_following

Some lines change every definition after them, such as Ruby's `private`.
This verb removes each line that matches one of the patterns.
It gives a copy of the line to every definition after it that matches a pattern in `to:`, up to the next of these lines or the end of the container.
Each definition then keeps the line's meaning wherever it moves.

```ruby
attach_to_each_following "private",
                         "public",
    to: ["def {{_}}({{...}})\n{{...}}\nend"]
```

#### add_braces_to

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

#### inside

Every verb above also takes `inside:`, which gives its code patterns a context of their own to parse in (see "pattern_contexts" above).

```ruby
drop "*{{_}}", inside: "def f({{pattern}}) end"
```

### Verbs for Reorder

#### sort

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

## Analysis

The analysis gives a student comments on their solution, in the analyzers' comment format.
A language declares the analysis's `version` in `analysis/spec.rb`, and bumps it whenever the comments on any solution could change.

The engine runs the common stages on the solution's main file, and then the analysis's own `Normalise` stage, in `analysis/normalise.rb`.
That stage only has to keep the code's meaning, such as Ruby's, which writes every way of defining a method on a class as `def self.name`.
Before adding a rewrite to it, check that no rule needs the spelling it removes.
The analysis keeps the imports and the student's names, and doesn't reorder the code.

Each exercise has a file of rules in `analysis/`, named after its slug, such as `analysis/two_fer.rb` for two-fer:

```ruby
module Representer::Languages::Ruby::Analysis
  class Leap < Representer::Engine::AnalysisRules
    within ["class Year; {{...}}; end", "module Year; {{...}}; end"] do
      within "def self.leap?({{...}}); {{...}}; end" do
        uses(["Date.leap?({{...}})", "Date.gregorian_leap?({{...}})"]) { actionable "ruby.leap.std_lib" }
      end
    end
  end
end
```

Each rule starts with a condition written as code patterns (see "Code patterns" below), and its block says what to do when the condition holds.
A list of patterns means any of them.
The rules run in the order they are written, and the analysis returns every comment they add, in that order.
Each comment comes once, unless its params differ.
The block is plain Ruby, so it can hold more rules, which run only when its condition holds.
A one-line rule uses braces, so Ruby needs brackets around its patterns.

- `uses(patterns)` runs its block if the code has a match. With `more_than: n`, it needs more than n matches, and a match inside another match doesn't count, so an `elsif` counts as part of its `if`.
- `uses_all(patterns)` runs its block if the code has a match of every pattern.
- `missing(patterns)` runs its block if the code has no match of any of them.
- `within(patterns)` runs its block once for each match, and the rules inside it only look inside that match. If nothing matches, the block doesn't run.
- `first_of` runs only the first rule inside it whose condition holds. A rule with no block stops the `first_of` without a comment.
- `essential`, `actionable`, `informative` and `celebratory` add a comment with its key and params, such as `actionable "ruby.two-fer.splat_args", name_variable: "{{name}}"`. A param that names a placeholder gives the code it matched.
- `indented_in_steps_of?(2)` says whether the main file is indented with spaces, in steps of two.

A word in a pattern must match the same code as the same word in a `within` around it, so `within "def self.two_fer({{name}} = {{default}}); {{...}}; end"` lets the rules inside it use the parameter as `{{name}}`.
A `{{_}}` or `{{...}}` never has to match another one.
Every pattern matches exactly (see "Code patterns" below), so `def self.two_fer({{name}} = "you"); {{_}}; end` matches a method with one optional parameter and one statement.

## Snippets

The website shows the first lines of each solution on its card.
Each track's `Snippet::Spec` class says what to leave out of them, so that the card shows the student's own code.
A language keeps it in its folder, as `snippet/spec.rb`, and its snippet reads the comments and docstrings declared in `common/spec.rb`.
A track with no language of its own can have a folder holding only `snippet/spec.rb`, such as `lib/representer/languages/lean/snippet/spec.rb`, which starts with `tracks`.
A track with no snippet of its own gets Basic's, which removes the comments found by the track's Rouge lexer.

```ruby
module Representer::Languages::Ruby::Snippet
  class Spec < Representer::Engine::Snippet
    version 1
    remove :comments
    skip_at_top :require, :require_relative
  end
end
```

The snippet comes from the solution's main file.
This is the first file listed in `files.solution` in the exercise's `.meta/config.json` that the student submitted, or else the student's first file.
The engine runs the snippet on the tree from the language's grammar, before `GenerateAST` or any other stage changes it.
If the track has no grammar, or the file doesn't parse, the rules apply to lines instead.

Each removal cuts the bytes out of the original source, so the student's formatting stays.
The engine then drops the lines left empty by a removal and the blank lines at the top, turns each run of blank lines into one, keeps the first 15 lines and cuts each line after 200 characters.
If the main file is over 200 KB, the snippet is its first 15 lines.

Bump the snippet's version (`version 2`) whenever its snippets could change.
The snippet has its own version, separate from the representation's, so a change to it never makes the website represent the track's solutions again.

### remove

`remove :comments` removes every comment, wherever it is.
With a tree, a comment is any node with `comment` in its type, or a type listed in the Spec's `comments_are`.
Without one, the engine finds the comments with the track's Rouge lexer, or with the markers given to `comment_lines`.

`remove :docstrings` removes every docstring. A language says which code is a docstring in its Spec, with `docstrings_are`.
If a code pattern can't describe a language's docstrings, its snippet defines `self.docstring?(node, parent)` instead, as Python's does.

```ruby
remove :comments, :docstrings
```

### skip_at_top

This declaration skips the statements at the top of the file that start with one of these words, such as imports.
A word must match a whole word, in any case, so `:require` doesn't match `require_relative`.
The engine stops at the first other statement, so the same words further down stay.

```ruby
skip_at_top :import, :from
```

If the language puts the rest of the file inside a node with a header line (as F# does with `module Leap`), list that node's type in `containers`.
The engine then skips only the header line and the closing bracket, and goes on with the statements inside.
If skipping would leave nothing, the engine keeps the containers, and if that leaves nothing too, it skips nothing.

```ruby
containers :named_module, :namespace
```

Without a tree, `skip_at_top` skips lines.
It also skips the lines after a skipped line that are indented or start with a closing bracket, such as the names in a multi-line import.
A pair skips a block of lines, from a line that starts with the first word to the next line that holds the second:

```ruby
skip_at_top "CLASS" => "IMPLEMENTATION."
```

### Rules for lines

These declarations only work without a tree:

- `skip_at_bottom :end` skips the lines at the bottom that start with one of the words.
- `remove_lines ".data"` removes the lines that start with one of the words, wherever they are.
- `comment_lines "//", "/*" => "*/"` finds comments by the way they start, for a track with no Rouge lexer. A string is a line comment, and a pair is a block comment's start and end. A block comment must start its line. A line comment may also follow code after a space, unless it might be inside a string.

`lines_only` makes a language with a grammar apply its rules to lines, for a grammar with no useful tree for the code at the top of a file.

## Code patterns

A code pattern is code in the language itself, with placeholders.
The engine parses a pattern with the language's grammar and runs the language's `GenerateAST` on it, so a pattern has the same shape as a solution's tree.

A pattern matches code exactly.
A node matches if it has the pattern's type and its children match the pattern's children one for one, with nothing left over.
So `f(1)` matches `f(1)`, and doesn't match `f(1, 2)`, `f()`, `x.f(1)` or `f(1) { }`.

Placeholders stand for the code that can vary:

- `{{x}}` matches exactly one item (one node, one argument, one statement) and binds it as `x`.
- `{{_}}` matches exactly one item and binds nothing.
- `{{...rest}}` matches zero or more items in a row and binds them all as `rest`, so a `rewrite`'s `as:` can write them back.
- `{{...}}` matches zero or more items and binds nothing.

So `f(1, {{...}})` matches `f(1)`, `f(1, 2)` and `f(1, 2, 3)`.
The same rules apply in every list: statements in a body, arguments, parameters, array items and class members.
Placeholders use braces, because a `$word` is real code in several languages.

```ruby
rewrite "f({{...args}})", as: "g({{...args}})"
```

Use a named placeholder only for code that a `rewrite`'s `as:` copies, or that has to match the same code twice.
Within one rule, a name used more than once (including in `within:`) must match the same code each time, so `{{x}} == {{x}}` matches `a == a` and not `a == b`.
A list of one item is the same code as that item.

If the grammar reads a placeholder as something other than a name, it matches a leaf of that kind, so `"{{_}}"` in quotes matches one string without interpolation.
A list placeholder of that kind matches any number of leaves of that kind.

Some grammars wrap each item of a list in a node of its own, such as PHP's and C#'s `argument`, or wrap a name in two nodes, as D's `import` does.
A placeholder that is the whole of such an item matches whole items, so PHP's `f({{x}})` matches `f($a)`, and `f({{...x}})` matches `f()` and `f($a, $b)`.

Many grammars leave out a list's node when the list is empty, as Ruby's leaves out the parameters of `def f`.
A part of the pattern that holds nothing but list placeholders (and tokens) can therefore also be missing from the code, so `def f({{...}}); {{...}}; end` matches `def f; end`.
A token before a list placeholder, or before such a part, can be missing with it, so Haskell's `import {{...}} as {{...}} ({{...}})` also matches `import Data.List`.
If the grammar can't read `{{...}}` on its own as an item, write an item made only of `{{...}}` placeholders, such as Erlang's `-import({{_}}, [{{...}}/{{...}}]).`, and it stands for any number of items.

If a pattern doesn't parse on its own, the engine tries it in each of the language's pattern contexts.
If one of the grammar's keywords comes out as a name, the engine rejects that parse and tries the next context, unless the language lists the keyword in `keywords_used_as_names`.
If the code doesn't parse in any context, the engine tries every context again with each placeholder capitalised, as Ruby's `class {{x}}` needs.
If the code is one token inside a larger node, such as the `readonly` of C#'s `ref readonly int`, the pattern is that token.

Some grammars give a file as a flat list of tokens, such as Factor's and Ballerina's.
If the code is several top-level items, such as Factor's `USING: {{...}} ;`, the pattern matches a run of children in a row, inside any node.
In such a run, `{{x}}` and `{{_}}` match one child, and a list placeholder matches as few children as it can.
So `USING: {{...}} ;` matches `USING: kernel math ;` up to the first `;`, and `USE: {{_}}` matches `USE: io`.
A pattern like this can only be dropped, so it works in `imports` and `drop`.

## Common mistakes

- If a node type that defines a name is missing from `names_are_defined_by`, the engine won't rename that name. Two solutions that differ only in the spelling of that name will then give different output. Check that every kind of definition in the language is listed.
- Never list a block of statements in `sort`. Statements run in order, so sorting them changes what the program does. List only containers whose order makes no difference, such as a class's body or a hash.
- If a pattern doesn't match, check its shape with `./bin/inspect <track> <file>`. The pattern is parsed and run through `GenerateAST`, so it must match the tree after `GenerateAST`, which can differ from tree-sitter's tree.
