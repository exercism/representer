# Representer DSL

Each language class in `lib/representer/languages/` describes its language with the rules below.
The engine parses the solution with the language's tree-sitter grammar, then applies the drop rules, then the rewrite rules, then the rename rules.
[CONTRIBUTING.md](./CONTRIBUTING.md) explains how to write a new class.

## Setup

### `tracks(*slugs)`

This sets the track slugs that the class represents.

```ruby
tracks "ruby"
```

### `version(number)`

This sets the language's representer version, from 2 to 32767.
Bump it whenever the output for any solution changes.

```ruby
version 2
```

### `grammar(name)`

This names the grammar's entry in `grammars.yml`.

```ruby
grammar "ruby"
```

### `extensions(*list)`

This lists the file extensions of the language's source files.
The engine ignores solution and exercise files with any other extension, such as Rust's `Cargo.toml`.

```ruby
extensions ".rb"
```

### `names(*types, **prefixed)`

This lists the leaf types that hold names, which the rename rules may rename.
A keyword argument gives a prefix that isn't part of the name, such as the `:` in `:name`.

```ruby
names :identifier, :constant, :instance_variable, :class_variable, :global_variable, simple_symbol: ":"
```

### `merge_files(name)`

This joins the solution's files into one tree before the rules run, so that splitting code across files doesn't change the representation.
The representation is written under the given file name.
Use it for a language where it doesn't matter which file code is in.

```ruby
merge_files "solution.go"
```

### `fold_names { |name| ... }`

The block returns one canonical spelling for a name.
Use it for a language that treats some spellings of a name as the same name.
The mapping keeps the student's first spelling.

```ruby
fold_names { |name| name.empty? ? name : name[0] + name[1..].delete("_").downcase }
```

### `inherit(parent)`

This copies all of another language's rules and names.
Use it for a language that is a superset of another, and call it before the class's own rules.

```ruby
inherit JavaScript
```

### `text_nodes(*types)`

This makes each node of these types a leaf that holds its whole source text.
Use it when a node's text isn't made of its children, such as Gleam's module path `gleam/list`, where the tree only has the slashes as children.

```ruby
text_nodes :module
```

### `text_between_children(*types)`

This keeps the text between the children of these node types, as "fragment" leaves.
Use it when a node's children don't cover all of its text, such as Python's string contents around an escape sequence.

```ruby
text_between_children :string_content, :format_specifier
```

## Drop rules

### `drop(pattern, where: nil)`

This removes every node that matches the pattern.
The optional `where:` lambda receives the match and returns whether the rule applies.

```ruby
drop "(comment)"
drop "(method_parameters)", where: ->(match) { match.node.children.empty? }
```

### `drop_tokens(*tokens)`

This leaves these anonymous tokens (keywords and punctuation) out of the tree.
Only drop a token if the node around it already says everything the token says.

```ruby
drop_tokens "(", ")", ",", ";", "def", "end"
```

## Rewrite rules

Rewrite rules apply from the leaves up, and again to their own results.

### `rewrite(pattern, template = nil, where: nil) { |match| ... }`

This replaces each node that matches the pattern.
Give either a template or a block.
The block receives the match and returns the replacement node, or `nil` to leave the node as it is.
A block that changes the matched node in place returns that node, and must return `nil` if it changed nothing, or the rule will keep matching.

```ruby
rewrite "(if_modifier body: (_) @body condition: (_) @condition)",
  "(if condition: @condition consequence: (then @body))"

rewrite("(hash_key_symbol) @key") { |match| leaf(:simple_symbol, ":#{match[:key].text}") }
```

### `retype(mapping)`

This gives nodes of one type another type.
Use it for two spellings with the same meaning.

```ruby
retype do_block: :block, block_body: :body_statement
```

### `unwrap(*types)`

This replaces a node that has exactly one named child with that child.
Use it for brackets that only group, because the tree's shape already shows the grouping.

```ruby
unwrap :parenthesized_statements
```

## Rename rules

Each rename pattern captures the name's leaf as `@name`.
Renamed names become `PLACEHOLDER_1`, `PLACEHOLDER_2` and so on, in the order they first appear.

### `rename(pattern)`

This marks a name the student defines for a local variable or parameter.
The engine renames it everywhere except after a dot.

```ruby
rename "[(assignment left: (identifier) @name) (operator_assignment left: (identifier) @name)]"
```

### `rename_member(pattern)`

This marks a name the student defines for a method, function, property, class or constant.
The engine renames it everywhere, including after a dot, unless it is also a library name.

```ruby
rename_member "[(method name: (_) @name) (singleton_method name: (_) @name)]"
```

### `member(pattern)`

This marks a name used after a dot, or anywhere else that refers to a member of some other object.
The engine only renames it if the solution defines a member with that name.

```ruby
member "(call receiver: (_) method: (_) @name)"
```

### `keep(*names_or_patterns)`

This marks names that are never renamed.
Give the names themselves, or a pattern that captures `@name`.

```ruby
keep "initialize", "to_s", "each", "<=>"
keep "(keyword_parameter name: (identifier) @name)"
```

### `library_names(path)`

This loads a file of the language's core and standard library names, one per line.
If the student defines a method or property with one of these names, the engine keeps it.

```ruby
library_names File.join(__dir__, "library_names", "ruby.txt")
```

## Patterns

Patterns use a subset of tree-sitter's query syntax.

| Syntax | Matches |
|---|---|
| `(type child...)` | A node of this type whose children match the child patterns in order. Other children may sit between them. |
| `(_)` | Any named node. |
| `_` | Any node, named or anonymous. |
| `field: pattern` | The child with this field name, if it matches the pattern. |
| `!field` | A node with no child under this field name. |
| `"text"` | An anonymous token with this text. Inside a leaf's pattern, it matches the leaf's text. |
| `/regex/` | Like `"text"`, but with a regular expression. |
| `[a b c]` | Any one of the patterns. |
| `pattern?` | The pattern, or nothing. |
| `pattern*` | Every remaining child that fits. Its captures become lists. |
| `pattern @name` | The pattern, captured as `name`. |

## Templates

A template builds a new node in the same syntax.

| Syntax | Builds |
|---|---|
| `(type child...)` | A new node of this type. |
| `field: child` | A child with this field name. |
| `@name` | A copy of the node captured as `name`. If nothing was captured under that name, the template leaves it out. |
| `"text"` | An anonymous token. |

## Helpers for rewrite blocks

| Helper | Returns |
|---|---|
| `build(type, *children)` | A new node. Children can be nodes or `field: node` pairs. |
| `leaf(type, text)` | A named leaf, such as an identifier. |
| `literal(value)` | A literal value, such as a string's contents, which the output always writes in quotes. |
| `token(text)` | An anonymous token. |
| `copy(node)` | A deep copy of a node. |
| `match.node` | The matched node. |
| `match[:name]` | The node captured as `name`. |
