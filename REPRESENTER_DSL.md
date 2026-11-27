# Representer DSL

A language with its own representer is written in one of two ways:

- **With stages** (Ruby): a module that extends `StagedLanguage`. It declares which nodes are names and which nodes define them, and defines the stages it needs as subclasses of the engine's stage classes (`GenerateAST`, `Normalise` and `Reorder`). The engine renames the names. Every language should be written this way, and [CONTRIBUTING.md](./CONTRIBUTING.md) explains how.
- **With the rule DSL** (every other language, until it moves to stages): a class that inherits from `Language` and lists drop, rewrite and rename rules. The engine parses the solution with the language's tree-sitter grammar, then applies the drop rules, then the rewrite rules, then the rename rules.

Both use the same setup methods.
Every solution that the representer sees passes its tests, so a language can drop any code that makes no difference to the solution working (see "The goal" in CONTRIBUTING.md).

## Names in a staged language

A staged language declares two lists, with the node types that `GenerateAST` leaves:

```ruby
names_are :identifier, :constant, :instance_variable, simple_symbol: ":"
names_are_defined_by :class, :method_parameters, method: :name, assignment: :left
```

- `names_are` lists the leaf types that are names. A keyword gives a prefix that isn't part of the name, such as Ruby's `simple_symbol: ":"` for `:name`.
- `names_are_defined_by` lists the node types that define a name. A type given on its own defines each of its children that is a name. A type given with a field defines only the child in that field, so `assignment: :left` defines `x` in `x = y`, and not `y`.

[`Engine::RenameUserDefinedNodes`](./lib/representer/engine/rename_user_defined_nodes.rb) then walks the solution's trees twice.
The first walk collects the text of every name that the solution defines.
The second walk renames every name with one of those texts, wherever it appears: in its definition, and in every use, call and symbol.
A name in the language's library names list keeps its name, even if the solution defines it.
Every other name keeps its name, so a call to a library method stays as it is.
The engine never reads the exercise's tests or stub for names.

## Code patterns

A code pattern is code in the language itself, with placeholders.
A staged language lists its imports and its `Normalise` rules as code patterns.
The engine parses a pattern with the language's grammar and runs the language's `GenerateAST` on it, so a pattern has the same shape as a solution's tree, and a language never writes a tree-sitter query for it.
[`Engine::CodePattern`](./lib/representer/engine/code_pattern.rb) compiles each pattern once and caches it.

| Code | Matches |
|---|---|
| `{{word}}` | Any code. In a list, such as a method's parameters, it matches any number of items, including none. |
| `"{{file}}"` | One string without interpolation. If the grammar reads a placeholder as something other than a name, the placeholder matches one node of that kind. |
| Anything else | The same code. |

The placeholders use braces, because a `$word` is real code in Ruby, PHP, Perl, Bash, jq and JavaScript templates.

A pattern matches a node if the pattern's children match the node's children in order.
The node may have more children between and after them, such as a method's body.
It may not have anything with a field name before them, such as a call's receiver.
So Ruby's `require "{{file}}"` matches `require "set"`, and it doesn't match `Kernel.require "set"` or `require name`.

Some code doesn't parse on its own, such as Ruby's `{ |{{x}}| }`, or `def {{method}}({{x}})` without its `end`.
The engine then tries the code in each of the language's pattern contexts, in order.
A rule can also give its own context with `inside:`.
A context marks the code's place with `...`.
The pattern is the smallest node that holds all of the code, and it matches that node wherever it appears.
So `"*{{x}}", inside: "def f(...) end"` matches a splat parameter in a method, a block or a lambda.

If one of the grammar's keywords comes out as a name, the engine rejects that parse and tries the next context.
So Ruby's `rescue => {{x}}` can't become a pattern match on a variable called `rescue`.
If the code doesn't parse in any context, the engine tries every context again with each placeholder capitalised, as Ruby's `class {{x}}` needs.

## Stages

A language defines each stage it needs as a subclass of the engine's class for that stage, and the engine skips a stage that a language doesn't define.
Each stage is a Mandate command that takes one tree and returns the new tree, and includes `Engine::TreeHelpers`.

- `GenerateAST < Engine::GenerateAST` writes its own `call` with the tree helpers below.
- `Normalise < Engine::Normalise` lists its rules with the verbs below.
- `Reorder < Engine::Reorder` writes its own `call`. It sorts code if its order makes no difference, by a key that ignores names. No language needs one yet.

### Normalise verbs

```ruby
class Normalise < Engine::Normalise
  drop_calls_to :puts
  rewrite "{{list}}.length", as: "{{list}}.size"
end
```

The stage applies its rules in the order they are listed, and each rule visits every node once.
The engine compiles the rules the first time the stage runs.

| Verb | Does |
|---|---|
| `drop "code", ...` | Removes every piece of code that matches one of the patterns. |
| `drop_calls_to :name, ...` | Removes every call to these methods. The engine writes each call as `name({{arguments}})`. |
| `rewrite "code", as: "code"` | Turns each match into the code given in `as:`, from the leaves up. Each placeholder in `as:` becomes a copy of its match. |

Each verb also takes `inside:`.

### Setup for a staged language

A staged language's module takes the setup methods `tracks`, `version`, `grammar` and `extensions` (see "Setup" below), `names_are` and `names_are_defined_by` (see "Names in a staged language"), and these two more:

- `imports "code", ...` lists the code that counts as an import, as code patterns. The engine drops it from every file, after `GenerateAST`.
- `pattern_contexts "context", ...` lists the code to put a code pattern in when the pattern doesn't parse on its own. Each context marks the pattern's place with `...`.

The engine reads a staged language's library names from `lib/representer/languages/library_names/<track>.txt`.

## Tree helpers for GenerateAST

Every stage includes `Engine::TreeHelpers`, and `GenerateAST` calls these methods on its tree.
Each method visits a node once, so a rule can't match its own output and loop.
A method that can replace the root returns the new root.
Their patterns use the syntax in "Patterns" below, and they also accept a code pattern.

| Helper | Does |
|---|---|
| `each_node(root) { \|node, parent\| }` | Visits every node and its parent, parents first, in source order. |
| `find_all(root, pattern)` | Returns every match of the pattern, as `Match`es. |
| `captured(root, pattern, name = :name)` | Returns every node captured as `@name`, with list captures flattened. |
| `transform(root, pattern, template)` | Replaces each match with the template, from the leaves up. |
| `transform(root, pattern) { \|match\| }` | Replaces each match with the block's result, from the leaves up. The block can return the matched node changed in place, or nil to leave it. |
| `drop(root, pattern)` | Removes each match with its children. |
| `drop_tokens(root, everywhere:, only_in:, kept_in:)` | Removes anonymous tokens: `everywhere` from every node apart from the types in `kept_in`, and `only_in` from the types it names. |
| `unwrap(root, pattern)` | Replaces a match that has one named child with that child. |
| `retype(root, from => to)` | Gives nodes of one type another type. |
| `build`, `leaf`, `literal`, `token`, `copy` | These make nodes (see "Helpers for rewrite blocks" below). |
| `text_of(node)` | Returns the text of a node's leaves, joined. |

## The rule DSL

The rest of this file describes the rule DSL, used by the languages that haven't moved to stages yet.
Each class in `lib/representer/languages/` describes its language with the rules below.
A staged language's module also takes the setup methods `tracks`, `version`, `grammar` and `extensions`.

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

### `keep_tokens_in(type, *tokens)`

This keeps some of the dropped tokens in nodes of one type, where they are the only thing that tells two programs apart.
Check every token you drop: if any node can hold it or leave it out, and the rest of the node can be the same either way, keep it in that node.

```ruby
keep_tokens_in :delete_expression, "[", "]"
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

### `numbers(*types) { |text| ... }`

This writes every number leaf of these types in one form.
The block receives the number's text and returns its canonical text, or `nil` to keep the text as it is.
`Engine::Numbers` has readers for integers (with digit separators and base prefixes) and decimals, and writers for their values.
Only give two spellings one form if the language reads them as the same value of the same type.

```ruby
numbers(:integer) { |text| Engine::Numbers.integer(text)&.to_s }
numbers :float do |text|
  value = Engine::Numbers.decimal(text)
  value && Engine::Numbers.write_decimal(value)
end
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
A name gets the same placeholder everywhere, unless a rewrite has given its leaf a scope (`leaf.scope = node`). A local name in a scope gets a placeholder of its own there, so two methods that reuse a parameter's name number their placeholders the same way as two that don't.

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
