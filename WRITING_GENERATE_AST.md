# Writing GenerateAST

Run `./bin/inspect <track> <file>` to see the node types and field names to use in your patterns.
It prints tree-sitter's tree for the file, with each node's type, field names and tokens.

`GenerateAST` is the first stage of every language (see [REPRESENTER_DSL.md](./REPRESENTER_DSL.md)), in the language's `common/generate_ast.rb`.
It turns tree-sitter's tree into the tree that the language's own parser would give, such as Ruby's `parser` gem or Elixir's `Code.string_to_quoted`.
Later stages then see the same tree for the same meaning.

## Declarations and steps

The engine drops the comments declared in `common/spec.rb` before `GenerateAST` starts.
The top of the class lists the steps that every language needs, as declarations: `strip_tokens`, `keep_tokens`, `unwrap` and `numbers_are` (see "GenerateAST's declarations" in [REPRESENTER_DSL.md](./REPRESENTER_DSL.md#generateasts-declarations)).
The engine writes the numbers before the language's own steps, and unwraps the brackets and strips the tokens after them.

The language's `call` method lists its own steps, starting from `tree.tap`:

```ruby
def call
  tree.tap do
    turn_heredocs_into_strings!
    write_strings_symbols_and_word_lists_as_values!
  end
end
```

A step can still read the brackets and tokens that the declarations remove, as Ruby's hash keys read their `:`.
If a step needs the brackets gone before it runs, unwrap them in a step of its own at that point, with the `unwrap` helper below, instead of declaring `unwrap`.

## Tree helpers

`GenerateAST` changes the tree with the helpers in `Engine::TreeHelpers`, which every stage includes.
Each helper visits a node once, so a rule can't loop on its own output.
A helper that can replace the root returns the new root.
The helpers take a tree pattern (see "Tree patterns" below), and they also accept a code pattern (see "Code patterns" in [REPRESENTER_DSL.md](./REPRESENTER_DSL.md)).

| Helper | What it does | Example |
|---|---|---|
| `each_node` | Visits every node and its parent, parents first, in source order. | `each_node(tree) { \|node, parent\| ... }` |
| `find_all` | Returns every match of the pattern. | `find_all(tree, "(call)")` |
| `captured` | Returns every node captured as `@name`. | `captured(tree, "(class body: (_) @name)")` |
| `transform` | Replaces each match with a template or the block's result. It starts with the innermost code and works outwards. The block can return nil to leave the node as it is. | `transform(tree, "(do_block) @b") { \|match\| ... }` |
| `drop` | Removes each match with its children. | `drop(tree, "(comment)")` |
| `drop_tokens` | Removes anonymous tokens (keywords and punctuation). `everywhere` removes them from every node except the types in `kept_in`, and `only_in` removes them from the types it names. | `drop_tokens(tree, everywhere: ["(", ")"])` |
| `unwrap` | Replaces a match that has one named child with that child. | `unwrap(tree, "(parenthesized_statements)")` |
| `retype` | Gives nodes of one type another type. | `retype(tree, do_block: :block)` |
| `attach` | Adds children to the end of a node, without field names, so they move with it. | `attach(method, mark)` |
| `build` | Makes a node. Children can be nodes or `field: node` pairs. | `build(:if, { condition: x })` |
| `leaf` | Makes a named leaf. | `leaf(:identifier, "call")` |
| `literal` | Makes a value that the output always writes in quotes. | `literal("a")` |
| `token` | Makes an anonymous token. | `token("!")` |
| `copy` | Makes a deep copy of a node. | `copy(node)` |
| `text_of` | Returns the text of a node's leaves, joined. | `text_of(node)` |

## Tree patterns

A tree pattern describes a shape in the tree.
It uses a subset of tree-sitter's query syntax, which writes a tree as nested brackets.
A tree pattern lets a node have more children than the pattern names, while a code pattern matches the code exactly.

| Syntax | Matches |
|---|---|
| `(type child...)` | A node of this type, if its children match the child patterns in order. Other children may sit between them. |
| `(_)` | Any named node. |
| `_` | Any node, named or anonymous. |
| `field: pattern` | The child with this field name, if the child matches the pattern. |
| `!field` | A node with no child under this field name. |
| `"text"` | An anonymous token with this text. Inside a leaf's pattern, it matches the leaf's text. |
| `/regex/` | Works like `"text"`, with a regular expression. |
| `[a b c]` | Any one of the patterns. |
| `pattern?` | The pattern, or nothing. |
| `pattern*` | Every remaining child that fits. Its captures become lists. |
| `pattern @name` | The pattern, and captures the match as `name`. |

## Templates

A template builds a new node, in the same syntax as a tree pattern.

| Syntax | Builds |
|---|---|
| `(type child...)` | A new node of this type. |
| `field: child` | A child with this field name. |
| `@name` | A copy of the node captured as `name`. If nothing was captured under that name, the template leaves it out. |
| `"text"` | An anonymous token. |
