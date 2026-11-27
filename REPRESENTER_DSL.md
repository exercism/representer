# Representer DSL

The representer turns a student's solution into a normal form, so that two solutions with the same approach give the same output.
To do this for a language, it needs to know a few things that only a person who knows the language can say: which names the solution defines, which code does nothing (such as comments and imports), and which spellings mean the same thing.
A staged language says these things in a folder with a small `spec.rb` of declarations, plus one file for each stage the language needs.
Other languages still use the old rule DSL, described in the last section.
[CONTRIBUTING.md](./CONTRIBUTING.md) explains how to add a language.

## What the engine does for every language

The engine does the rest of the work.
For every staged language, it does these things in order:

1. It ignores files without one of the language's extensions, and test and config files.
2. It turns Windows line endings into plain line breaks, then parses each file with the language's grammar. If a file doesn't parse, the solution gets no representation.
3. It runs the language's `GenerateAST` stage on each file.
4. It drops the language's imports from each file.
5. It runs the language's `Normalise` stage on each file.
6. It renames every name defined by the solution, wherever the name appears: in its definition, and in every use, call and symbol. A name that the solution doesn't define keeps its name, such as a call to a library method. The engine never reads the exercise's tests or stub for names.
7. It joins the files into one tree, in an order set by their code, and leaves out the file names.
8. It runs the language's `Reorder` stage on the joined tree.
9. It numbers the placeholders in the order the names appear, and writes the tree out as a nested, bracketed text form (an s-expression).

## How a staged language is laid out

Each staged language has a folder of its own in `lib/representer/languages/`.
The folder's `spec.rb` defines a class called `Spec`, which declares the language's setup, names and imports.
Each stage the language needs is a class in a file beside it, in the same module:

```
lib/representer/languages/ruby/
  spec.rb           Ruby::Spec
  generate_ast.rb   Ruby::GenerateAST
  normalise.rb      Ruby::Normalise
  reorder.rb        Ruby::Reorder
  snippet.rb        Ruby::Snippet
```

```ruby
module Representer::Languages::Ruby
  class Spec < Representer::Engine::Language
    tracks "ruby"
    version 11
    grammar "ruby"
    extensions ".rb"
  end
end
```

When a language defines its `Spec`, the engine looks in the language's folder for each stage's file, and for `snippet.rb` (see "Snippets" below).
If a file is missing, the language doesn't run that stage.

## Setup declarations

### tracks

A language says which tracks it represents.
The engine then uses the language for those tracks.

```ruby
tracks "ruby"
```

### version

When the version changes, the website represents all of the track's solutions again.
A language therefore bumps its version whenever the output for any solution could change.
Versions run from 2 to 32767, because the old per-track representers all reported 1.

```ruby
version 11
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

## Names and imports

In the inline examples in each `spec.rb`, «» marks the captured name: the part of the code that the item on that line matches.

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
A language can call `names_are_defined_by` more than once.

```ruby
names_are_defined_by :method_parameters, assignment: :left
```

### imports

A solution that passes its tests has already loaded everything it needs.
The engine therefore drops every import from every file, after `GenerateAST`.
A language lists the code that counts as an import, as code patterns (see "Code patterns" below).

```ruby
imports 'require "{{file}}"'
```

### pattern_contexts

Some code patterns don't parse on their own, such as a `def` without its `end`.
A language lists code to put such a pattern in, and marks the pattern's place with `...`.
The engine tries the contexts in order.

```ruby
pattern_contexts "...\nend"
```

## Stages and their verbs

A stage is a class in its own file in the language's folder.
Each stage inherits from the engine's class of the same name, and runs on a tree.
The engine runs the stages in this order, between its own steps (see "What the engine does for every language" above):

1. `GenerateAST` (in `generate_ast.rb`) runs on each file. It turns tree-sitter's tree into the tree that the language's own parser would give, such as Ruby's `parser` gem or Elixir's `Code.string_to_quoted`. [WRITING_GENERATE_AST.md](./WRITING_GENERATE_AST.md) explains how to write it.
2. `Normalise` (in `normalise.rb`) runs on each file. It removes code that makes no difference and gives one form to code that means the same thing, with the verbs below.
3. `Reorder` (in `reorder.rb`) runs on all the files joined into one tree. It sorts code that can come in any order.

### Verbs for Normalise

These verbs go in `normalise.rb`.

#### drop

This verb removes every piece of code that matches one of the patterns.

```ruby
drop "@moduledoc {{text}}", "@doc {{text}}"
```

#### drop_calls_to

This verb removes every call to these methods, written as `name({{arguments}})`.

```ruby
drop_calls_to :puts
```

#### rewrite

This verb turns each piece of code that matches the pattern into the code given in `as:`.
It starts with the innermost code and works outwards.
Each placeholder in `as:` becomes a copy of the code that it matched.

```ruby
rewrite "{{list}}.length", as: "{{list}}.size"
```

#### attach_to_next

Some statements belong to the definition after them, such as Elixir's `@spec`.
This verb moves each statement that matches one of the patterns into the next statement, as its last child.
The two then move together when `Reorder` sorts them.
If several matches come one after the other, they all move into the next statement.

```ruby
attach_to_next "@spec {{spec}}"
```

#### attach_to_each_following

Some lines change every definition after them, such as Ruby's `private`.
This verb removes each line that matches one of the patterns.
It gives a copy of the line to every definition after it that matches a pattern in `to:`, up to the next of these lines or the end of the container.
Each definition then keeps the line's meaning wherever it moves.

```ruby
attach_to_each_following "private", "public", to: ["def {{name}}\nend"]
```

#### inside

Every verb above also takes `inside:`, which gives its code patterns a context of their own (see "pattern_contexts" above).

```ruby
drop "*{{x}}", inside: "def f(...) end"
```

### Verbs for Reorder

#### sort

This verb goes in `reorder.rb`.
It sorts the children of every node of these types by their code, written with every renamed name blank.
Children with the same code keep their order, and inner nodes are sorted before the nodes around them.
A language lists only containers of definitions or entries, such as a class's body or a hash, because a block of statements runs in order.
If the grammar gives such a container the same type as a block of statements, `GenerateAST` gives it a type of its own first.

```ruby
module Representer::Languages::Ruby
  class Reorder < Representer::Engine::Reorder
    sort :class_body, :hash
  end
end
```

## Snippets

The website shows the first lines of each solution on its card.
Each track's `Snippet` class says what to leave out of them, so that the card shows the student's own code.
A staged language keeps it in its folder, as `snippet.rb`.
Every other track has a folder holding only `snippet.rb`, such as `lib/representer/languages/python/snippet.rb`.
A language on the old structure puts its `Snippet` class inside its class, and a track with no class of its own starts with `tracks`.
A track with no snippet of its own gets Basic's, which removes the comments found by the track's Rouge lexer.

```ruby
module Representer::Languages::Ruby
  class Snippet < Representer::Engine::Snippet
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
The snippet has its own version, so a change to it never makes the website represent the track's solutions again.

### remove

`remove :comments` removes every comment, wherever it is.
With a tree, a comment is any node with `comment` in its type, or a type listed in `comment_types`.
Without one, the engine finds the comments with the track's Rouge lexer, or with the markers given to `comment_lines`.

`remove :docstrings` removes every docstring. The language says which nodes are docstrings with `docstrings_are`.

```ruby
remove :comments, :docstrings
comment_types :xml_doc
docstrings_are { |node, parent| node.type == "string" && %w[module block].include?(parent&.type) }
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

A placeholder is a word in double braces, such as `{{file}}`.
A placeholder matches any code.
In a list, such as a method's parameters, it matches any number of items.
If the grammar reads a placeholder as something other than a name, it matches one node of that kind, so `"{{file}}"` in quotes matches one string without interpolation.
Placeholders use braces, because a `$word` is real code in several languages.

```ruby
'require "{{file}}"'
```

A pattern matches a node if the pattern's children match the node's children in order.
The node may have more children between and after them, such as a method's body, but it may not have a child with a field name before them, such as a call's receiver.
So `require "{{file}}"` matches `require "set"`, and doesn't match `Kernel.require "set"` or `require name`.

If a pattern doesn't parse on its own, the engine tries it in each of the language's pattern contexts.
If one of the grammar's keywords comes out as a name, the engine rejects that parse and tries the next context.
If the code doesn't parse in any context, the engine tries every context again with each placeholder capitalised, as Ruby's `class {{x}}` needs.

## Common mistakes

- If a node type that defines a name is missing from `names_are_defined_by`, the engine won't rename that name. Two solutions that differ only in the spelling of that name will then give different output. Check that every kind of definition in the language is listed.
- Never list a block of statements in `sort`. Statements run in order, so sorting them changes what the program does. List only containers whose order makes no difference, such as a class's body or a hash.
- A `rewrite` block that changes nothing must return nil. If it returns the node, the engine will treat the node as rewritten and match it again, and the rule will match the same node forever.
- If a pattern doesn't match, check its shape with `./bin/inspect <track> <file>`. The pattern is parsed and run through `GenerateAST`, so it must match the tree after `GenerateAST`, which can differ from tree-sitter's tree.

## The rule DSL for languages that aren't staged yet

A language that isn't staged yet uses this DSL, until it becomes a staged language.
Each one is a class in `lib/representer/languages/` that inherits from `Representer::Language`.
It uses the setup declarations above, and lists drop, rewrite and rename rules.
The engine parses the solution with the language's grammar, then applies the drop rules, then the rewrite rules, then the rename rules.
The rules use the tree patterns and tree helpers described in [WRITING_GENERATE_AST.md](./WRITING_GENERATE_AST.md).

### names

A language lists the leaf types that hold names, which the rename rules may rename.
A keyword argument gives a prefix that isn't part of the name.

```ruby
names :identifier, :constant, simple_symbol: ":"
```

### fold_names

Some languages treat several spellings of a name as one name, such as Nim, where `my_var` and `myVar` are the same.
The block takes a name and returns one canonical spelling of it.
The engine treats names with the same canonical spelling as one name, so they get one placeholder.
Names that the engine doesn't rename are written in their canonical spelling too.
For each placeholder, the engine keeps the student's first spelling of the name.

```ruby
fold_names { |name| name.empty? ? name : name[0] + name[1..].delete("_").downcase }
```

### inherit

A language that is a superset of another copies all of the other language's rules and names before its own rules.

```ruby
inherit JavaScript
```

### text_nodes

Some nodes' text isn't made of their children, such as Gleam's module path `gleam/list`.
The engine turns each node of these types into a leaf that holds its whole source text.

```ruby
text_nodes :module
```

### text_between_children

Some nodes' children don't cover all of their text, such as Python's string contents around an escape.
The engine keeps the text between the children of these types as "fragment" leaves.

```ruby
text_between_children :string_content
```

### syntax_check

Some code is accepted by the grammar but rejected by the language, such as Python 2's `print "x"`.
The block receives the source and the tree, and returns a message if the code is invalid.
The solution then gets no representation.

```ruby
syntax_check { |source, _tree| "Python 2 print" if source.match?(/^print "/) }
```

### drop

The engine removes every node that matches the pattern.
The optional `where:` block receives the match and says whether the rule applies.

```ruby
drop "(comment)"
```

### drop_tokens

The engine leaves these anonymous tokens (keywords and punctuation) out of the tree.
A language drops a token only if the node around it already says everything the token says.

```ruby
drop_tokens "(", ")", ",", ";"
```

### keep_tokens_in

Some dropped tokens are the only thing that tells two programs apart in one node type.
The engine keeps them in that type.

```ruby
keep_tokens_in :delete_expression, "[", "]"
```

### rewrite

The engine replaces each node that matches the pattern, starting with the innermost code and working outwards, and again on its own results.
A rule gives either a template or a block.
The block receives the match and returns the replacement node, or nil to leave the node.
If a block changes the matched node in place, it must return that node, and it must return nil if it changed nothing. Otherwise the rule will keep matching the same node.

```ruby
rewrite "(if_modifier body: (_) @body condition: (_) @condition)",
  "(if condition: @condition consequence: (then @body))"
```

### numbers

The engine writes every number leaf of these types in one form.
The block receives the number's text and returns its canonical text, or nil to keep the text.
`Engine::Numbers` has readers for integers and decimals, and writers for their values.
A language gives two spellings one form only if it reads them as the same value of the same type.

```ruby
numbers(:integer) { |text| Engine::Numbers.integer(text)&.to_s }
```

### retype

The engine gives nodes of one type another type, for two spellings with the same meaning.

```ruby
retype do_block: :block
```

### unwrap

The engine replaces a node that has exactly one named child with that child, for brackets that only group.

```ruby
unwrap :parenthesized_statements
```

### rename

Each rename pattern captures the name's leaf as `@name`.
Renamed names become `PLACEHOLDER_1`, `PLACEHOLDER_2` and so on, in the order they first appear.
A name gets the same placeholder everywhere.
The exception is a name that a rewrite gave a scope, by setting `leaf.scope = node` (where `node` is the node that declares the name, such as a method).
The same name in two different scopes then gets two different placeholders, so the numbers don't depend on whether two methods happen to use the same name for their locals.

`rename` marks a name defined by the student for a local variable or parameter.
The engine renames it everywhere except after a dot.

```ruby
rename "(assignment left: (identifier) @name)"
```

### rename_member

`rename_member` marks a name defined by the student for a method, function, property, class or constant.
The engine renames it everywhere, including after a dot.

```ruby
rename_member "(method name: (_) @name)"
```

### member

`member` marks a name used after a dot, or anywhere else that refers to a member of another object.
The engine renames it only if the solution defines a member with that name.

```ruby
member "(call receiver: (_) method: (_) @name)"
```

### keep

`keep` marks names that the engine never renames, given as the names themselves or as a pattern that captures `@name`.

```ruby
keep "initialize", "(keyword_parameter name: (identifier) @name)"
```

### Helpers for rewrite blocks

A rewrite block builds nodes with `build`, `leaf`, `literal`, `token` and `copy`, as in the tree helpers in [WRITING_GENERATE_AST.md](./WRITING_GENERATE_AST.md).
It reads the match with `match.node` (the matched node) and `match[:name]` (the node captured as `name`).

```ruby
rewrite("(hash_key_symbol) @key") { |match| leaf(:simple_symbol, ":#{match[:key].text}") }
```
