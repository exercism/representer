# Snippets

The website shows the first lines of each solution on its card.
A snippet is those lines: the first 15 lines of the solution's main file, without its comments or the boilerplate at its top, such as imports, so that the card shows the student's own code.
Every track gets a snippet, even when its solution can't be represented.

This doc covers the `snippet` output and the declarations that say what to leave out.
[common.md](./common.md) covers the language folder and the comments and docstrings declared in `common/spec.rb`, which the snippet reads.

## The `snippet` output

The `snippet` output holds the start of the solution, which the website shows on the solution's card, and the snippet's version:

```json
{ "snippet": { "snippet": "def two_fer(name = 'you')\n ...", "version": 1 } }
```

If one of the snippet's rules raises an error, the snippet gets the error `internal_error`, with the shape described in the README's "Deployment" section.

## Where the snippet comes from

Each track's `Snippet::Spec` class says what to leave out of the snippet.
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
The snippet reads `.meta/config.json` from the request's `exercise_files`.
The engine runs the snippet on the tree from the language's grammar, before `GenerateAST` or any other stage changes it.
If the track has no grammar, or the file doesn't parse, the rules apply to lines instead.

Each removal cuts the bytes out of the original source, so the student's formatting stays.
The engine then drops the lines left empty by a removal and the blank lines at the top, turns each run of blank lines into one, keeps the first 15 lines and cuts each line after 200 characters.
If the main file is over 200 KB, the snippet is its first 15 lines.

## Versions

Bump the snippet's version (`version 2`) whenever its snippets could change.
The snippet has its own version, separate from the representation's, so a change to it never makes the website represent the track's solutions again.

## remove

`remove :comments` removes every comment, wherever it is.
With a tree, a comment is any node with `comment` in its type, or a type listed in the Spec's `comments_are`.
Without one, the engine finds the comments with the track's Rouge lexer, or with the markers given to `comment_lines`.

`remove :docstrings` removes every docstring. A language says which code is a docstring in its Spec, with `docstrings_are`.
If a code pattern can't describe a language's docstrings, its snippet defines `self.docstring?(node, parent)` instead, as Python's does.

```ruby
remove :comments, :docstrings
```

## skip_at_top

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

## Rules for lines

These declarations only work without a tree:

- `skip_at_bottom :end` skips the lines at the bottom that start with one of the words.
- `remove_lines ".data"` removes the lines that start with one of the words, wherever they are.
- `comment_lines "//", "/*" => "*/"` finds comments by the way they start, for a track with no Rouge lexer. A string is a line comment, and a pair is a block comment's start and end. A block comment must start its line. A line comment may also follow code after a space, unless it might be inside a string.

`lines_only` makes a language with a grammar apply its rules to lines, for a grammar with no useful tree for the code at the top of a file.
