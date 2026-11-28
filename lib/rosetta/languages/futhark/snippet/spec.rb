# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Futhark solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Rosetta::Languages::Futhark::Snippet
  class Spec < Rosetta::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, wherever it is.
    remove :comments # def x = 1 «-- The answer»

    # Find the comments by the way they start in a file that doesn't parse,
    # because Rouge has no Futhark lexer.
    comment_lines "--" # «-- A comment»

    # Skip the imports and opens at the top of the file, up to the first
    # other declaration.
    skip_at_top :import, # «import "lib/github.com/diku-dk/sorts/merge_sort"»
                :open    # «open i32»
  end
end
