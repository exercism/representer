# Code patterns

A code pattern is code in the language itself, with placeholders.
The engine parses a pattern with the language's grammar and runs the language's `GenerateAST` on it, so a pattern has the same shape as a solution's tree.
Every output uses code patterns: the representation's imports and `Normalise` verbs, the analysis's rules, and the docstrings declared in `common/spec.rb`.

## Matching

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

If a pattern doesn't parse on its own, the engine tries it in each of the language's pattern contexts (see [`pattern_contexts`](#pattern_contexts) below).
If one of the grammar's keywords comes out as a name, the engine rejects that parse and tries the next context, unless the language lists the keyword in [`keywords_used_as_names`](#keywords_used_as_names).
If the code doesn't parse in any context, the engine tries every context again with each placeholder capitalised, as Ruby's `class {{x}}` needs.
If the code is one token inside a larger node, such as the `readonly` of C#'s `ref readonly int`, the pattern is that token.

Some grammars give a file as a flat list of tokens, such as Factor's and Ballerina's.
If the code is several top-level items, such as Factor's `USING: {{...}} ;`, the pattern matches a run of children in a row, inside any node.
In such a run, `{{x}}` and `{{_}}` match one child, and a list placeholder matches as few children as it can.
So `USING: {{...}} ;` matches `USING: kernel math ;` up to the first `;`, and `USE: {{_}}` matches `USE: io`.
A pattern like this can only be dropped, so it works in `imports` and `drop`.

If a pattern doesn't match, check its shape with `./bin/inspect <track> <file>`.
The pattern is parsed and run through `GenerateAST`, so it must match the tree after `GenerateAST`, which can differ from tree-sitter's tree.

## Declarations for code patterns

These declarations go in `representation/spec.rb`, and the engine uses them for every code pattern in the language, in every output.

### pattern_contexts

Some code patterns don't parse on their own, such as a `def` without its `end`.
A language lists code to put such a pattern in, and marks the pattern's place with `{{pattern}}`.
The engine tries the contexts in order, for every code pattern in the language.

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

If one of the grammar's keywords comes out as a name in a code pattern, the engine rejects that parse (see "Matching" above).
A language lists the keywords that it also uses as names, such as Common Lisp's `cl`, so a pattern such as `:cl` can use them.

```ruby
keywords_used_as_names "cl"
```
