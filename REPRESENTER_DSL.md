# Representer DSL

This file defines every declaration and verb that a language can use.
Ruby and Elixir are staged languages, and every language will become one.
The other languages are still on the old structure, and use the rule DSL described in the last section.
[CONTRIBUTING.md](./CONTRIBUTING.md) explains how to add a language.

## How a staged language is laid out

Each staged language has a folder of its own in `lib/representer/languages/`.
The folder's `spec.rb` defines a class called `Spec`, which declares the language's setup, names and imports.
Each stage the language needs is a class in a file of its own beside it, in the same module:

```
lib/representer/languages/ruby/
  spec.rb           Ruby::Spec
  generate_ast.rb   Ruby::GenerateAST
  normalise.rb      Ruby::Normalise
  reorder.rb        Ruby::Reorder
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

When a language defines its `Spec`, the engine looks in the language's folder for each stage's file.
If a file is missing, the language doesn't run that stage.

## Setup declarations

### tracks

A language says which tracks it represents, and the engine then uses it for those tracks.

```ruby
tracks "ruby"
```

### version

The website represents a track's solutions again when the version changes, so a language bumps its version whenever the output for any solution could change.
Versions run from 2 to 32767, because the old per-track representers all reported 1.

```ruby
version 11
```

### grammar

A language names its tree-sitter grammar's entry in `grammars.yml`.

```ruby
grammar "ruby"
```

### extensions

The engine only represents solution files with one of these extensions, and ignores files such as Rust's `Cargo.toml`.

```ruby
extensions ".rb"
```

## Names and imports

### names_are

A language lists the leaf types that hold names, after `GenerateAST`.
If a type's text starts with something that isn't part of the name, the language gives it as `without_prefix:`.
A language can call `names_are` more than once.

```ruby
names_are :simple_symbol, without_prefix: ":"
```

### names_are_defined_by

A language lists the node types that define a name, after `GenerateAST`.
A type given on its own defines each of its children that is a name.
A type given with a field defines only the child in that field, so `assignment: :left` defines `x` in `x = y`, and not `y`.
A language can call `names_are_defined_by` more than once.

```ruby
names_are_defined_by :method_parameters, assignment: :left
```

### imports

A solution that passes its tests has already loaded everything it needs, so the engine drops every import from every file, after `GenerateAST`.
A language lists the code that counts as an import, as code patterns.

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

## Stages

Each stage is a subclass of the engine's class for that stage, and runs on a tree.
The engine runs the stages in this order, between its own steps (see "What the engine does for every language" below):

1. `GenerateAST` runs on each file. It turns tree-sitter's tree into the tree given by the language's own parser, with the tree helpers below.
2. `Normalise` runs on each file. It applies the equivalences and removals decided for the language, with the verbs below.
3. `Reorder` runs on all the files joined into one tree. It sorts code if its order makes no difference.

```ruby
module Representer::Languages::Ruby
  class Reorder < Representer::Engine::Reorder
    sort :class_body, :hash
  end
end
```

### drop

`Normalise` removes every piece of code that matches one of the patterns.

```ruby
drop "@moduledoc {{text}}", "@doc {{text}}"
```

### drop_calls_to

`Normalise` removes every call to these methods, written as `name({{arguments}})`.

```ruby
drop_calls_to :puts
```

### rewrite

`Normalise` turns each piece of code that matches the pattern into the code given in `as:`, from the leaves up.
Each placeholder in `as:` becomes a copy of the code it matched.

```ruby
rewrite "{{list}}.length", as: "{{list}}.size"
```

### attach_to_next

Some statements belong to the definition after them, such as Elixir's `@spec`.
`Normalise` moves each statement that matches one of the patterns into the next statement, as its last child, so the two move together when `Reorder` sorts them.
If several matches come one after the other, they all move into the next statement.

```ruby
attach_to_next "@spec {{spec}}"
```

### attach_to_each_following

Some lines change every definition after them, such as Ruby's `private`.
`Normalise` removes each line that matches one of the patterns, and gives a copy of it to every definition after it that matches a pattern in `to:`, up to the next of these lines or the end of the container.
Each definition then keeps the line's meaning wherever it moves.

```ruby
attach_to_each_following "private", "public", to: ["def {{name}}\nend"]
```

### sort

`Reorder` sorts the children of every node of these types by their code, written with every renamed name blank.
Children with the same code keep their order, and inner nodes are sorted before the nodes around them.
A language only lists containers of definitions or entries, such as a class's body or a hash, because a block of statements runs in order.
If a grammar gives such a container the same type as a block of statements, `GenerateAST` gives it a type of its own first.

```ruby
sort :class_body, :module_body, :hash
```

### inside

Every `Normalise` verb also takes `inside:`, which gives its code patterns a context of their own (see "pattern_contexts" above).

```ruby
drop "*{{x}}", inside: "def f(...) end"
```

## Code patterns

A code pattern is code in the language itself, with placeholders.
The engine parses a pattern with the language's grammar and runs the language's `GenerateAST` on it, so a pattern has the same shape as a solution's tree.

A placeholder is a word in double braces, such as `{{file}}`.
A placeholder matches any code, and in a list, such as a method's parameters, it matches any number of items.
If the grammar reads a placeholder as something other than a name, it matches one node of that kind, so `"{{file}}"` in quotes matches one string without interpolation.
A `$word` is real code in several languages, so placeholders use braces.

```ruby
'require "{{file}}"'
```

A pattern matches a node if the pattern's children match the node's children in order.
The node may have more children between and after them, such as a method's body, but nothing with a field name before them, such as a call's receiver.
So `require "{{file}}"` matches `require "set"`, and it doesn't match `Kernel.require "set"` or `require name`.

If a pattern doesn't parse on its own, the engine tries it in each of the language's pattern contexts.
If one of the grammar's keywords comes out as a name, the engine rejects that parse and tries the next context.
If the code doesn't parse in any context, the engine tries every context again with each placeholder capitalised, as Ruby's `class {{x}}` needs.

## What the engine does for every language

A language only says what the engine can't know.
The engine does these things for every staged language:

1. It ignores files without one of the language's extensions, and test and config files.
2. It parses each file with the language's grammar, after turning Windows line endings into plain line breaks. If a file doesn't parse, the solution gets no representation.
3. It drops the language's imports from each file, after `GenerateAST`.
4. It renames every name the solution defines, wherever the name appears: in its definition, and in every use, call and symbol. A name the solution doesn't define keeps its name, such as a call to a library method. The engine never reads the exercise's tests or stub for names.
5. It joins the files into one tree, in an order set by their code, and leaves out the file names.
6. It numbers the placeholders in the order the names appear, and writes the tree out as an s-expression.

## Tree helpers

`GenerateAST` works on the tree with the helpers in `Engine::TreeHelpers`, which every stage includes.
Each helper visits a node once, so a rule can't loop on its own output.
A helper that can replace the root returns the new root.
Their patterns use the syntax in "Tree patterns" below, and they also accept a code pattern.

| Helper | Does | Example |
|---|---|---|
| `each_node` | It visits every node and its parent, parents first, in source order. | `each_node(tree) { \|node, parent\| ... }` |
| `find_all` | It returns every match of the pattern. | `find_all(tree, "(call)")` |
| `captured` | It returns every node captured as `@name`. | `captured(tree, "(class body: (_) @name)")` |
| `transform` | It replaces each match with a template or the block's result, from the leaves up. The block can return nil to leave the node. | `transform(tree, "(do_block) @b") { \|match\| ... }` |
| `drop` | It removes each match with its children. | `drop(tree, "(comment)")` |
| `drop_tokens` | It removes anonymous tokens: `everywhere` from every node apart from the types in `kept_in`, and `only_in` from the types it names. | `drop_tokens(tree, everywhere: %w[( )])` |
| `unwrap` | It replaces a match that has one named child with that child. | `unwrap(tree, "(parenthesized_statements)")` |
| `retype` | It gives nodes of one type another type. | `retype(tree, do_block: :block)` |
| `attach` | It adds children to the end of a node, without field names, so they move with it. | `attach(method, mark)` |
| `build` | It makes a node. Children can be nodes or `field: node` pairs. | `build(:if, { condition: x })` |
| `leaf` | It makes a named leaf. | `leaf(:identifier, "call")` |
| `literal` | It makes a value that the output always writes in quotes. | `literal("a")` |
| `token` | It makes an anonymous token. | `token("!")` |
| `copy` | It makes a deep copy of a node. | `copy(node)` |
| `text_of` | It returns the text of a node's leaves, joined. | `text_of(node)` |

Run `./bin/inspect <track> <file>` to see tree-sitter's tree, with each node's type, field names and tokens.

### Tree patterns

Tree patterns use a subset of tree-sitter's query syntax.

| Syntax | Matches |
|---|---|
| `(type child...)` | It matches a node of this type if its children match the child patterns in order. Other children may sit between them. |
| `(_)` | It matches any named node. |
| `_` | It matches any node, named or anonymous. |
| `field: pattern` | It matches the child with this field name, if the child matches the pattern. |
| `!field` | It matches a node with no child under this field name. |
| `"text"` | It matches an anonymous token with this text. Inside a leaf's pattern, it matches the leaf's text. |
| `/regex/` | It works like `"text"`, with a regular expression. |
| `[a b c]` | It matches any one of the patterns. |
| `pattern?` | It matches the pattern, or nothing. |
| `pattern*` | It matches every remaining child that fits, and its captures become lists. |
| `pattern @name` | It matches the pattern, and captures the match as `name`. |

### Templates

A template builds a new node in the same syntax.

| Syntax | Builds |
|---|---|
| `(type child...)` | It builds a new node of this type. |
| `field: child` | It builds a child with this field name. |
| `@name` | It builds a copy of the node captured as `name`. If nothing was captured under that name, the template leaves it out. |
| `"text"` | It builds an anonymous token. |

## The rule DSL for languages on the old structure

Languages still on the old structure use this DSL, until they become staged languages.
Each one is a class in `lib/representer/languages/` that inherits from `Representer::Language`.
It uses the setup declarations above, and lists drop, rewrite and rename rules.
The engine parses the solution with the language's grammar, then applies the drop rules, then the rewrite rules, then the rename rules.

### names

An old-structure language lists the leaf types that hold names, which the rename rules may rename.
A keyword argument gives a prefix that isn't part of the name.

```ruby
names :identifier, :constant, simple_symbol: ":"
```

### fold_names

Some languages treat several spellings of a name as one name, so the block returns one canonical spelling.
The mapping keeps the student's first spelling.

```ruby
fold_names { |name| name.empty? ? name : name[0] + name[1..].delete("_").downcase }
```

### inherit

A language that is a superset of another copies all of the other language's rules and names, before its own rules.

```ruby
inherit JavaScript
```

### text_nodes

Some nodes' text isn't made of their children, such as Gleam's module path `gleam/list`, so each node of these types becomes a leaf that holds its whole source text.

```ruby
text_nodes :module
```

### text_between_children

Some nodes' children don't cover all of their text, such as Python's string contents around an escape, so the engine keeps the text between their children as "fragment" leaves.

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
The optional `where:` lambda receives the match and says whether the rule applies.

```ruby
drop "(comment)"
```

### drop_tokens

The engine leaves these anonymous tokens out of the tree.
A language only drops a token if the node around it already says everything the token says.

```ruby
drop_tokens "(", ")", ",", ";"
```

### keep_tokens_in

Some dropped tokens are the only thing that tells two programs apart in one node type, so the engine keeps them in that type.

```ruby
keep_tokens_in :delete_expression, "[", "]"
```

### rewrite

The engine replaces each node that matches the pattern, from the leaves up, and again on its own results.
A rule gives either a template or a block.
The block receives the match and returns the replacement node, or nil to leave the node.
If a block changes the matched node in place, it must return that node, and nil if it changed nothing. Otherwise the rule will keep matching.

```ruby
rewrite "(if_modifier body: (_) @body condition: (_) @condition)",
  "(if condition: @condition consequence: (then @body))"
```

### numbers

The engine writes every number leaf of these types in one form.
The block receives the number's text and returns its canonical text, or nil to keep it.
`Engine::Numbers` has readers for integers and decimals, and writers for their values.
A language only gives two spellings one form if it reads them as the same value of the same type.

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
A name gets the same placeholder everywhere, unless a rewrite has given its leaf a scope (`leaf.scope = node`).

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
The engine only renames it if the solution defines a member with that name.

```ruby
member "(call receiver: (_) method: (_) @name)"
```

### keep

`keep` marks names that are never renamed, given as the names themselves or as a pattern that captures `@name`.

```ruby
keep "initialize", "(keyword_parameter name: (identifier) @name)"
```

### Helpers for rewrite blocks

A rewrite block builds nodes with `build`, `leaf`, `literal`, `token` and `copy`, as in the tree helpers above.
It reads the match with `match.node` (the matched node) and `match[:name]` (the node captured as `name`).

```ruby
rewrite("(hash_key_symbol) @key") { |match| leaf(:simple_symbol, ":#{match[:key].text}") }
```
