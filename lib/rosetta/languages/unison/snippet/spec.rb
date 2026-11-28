# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Unison solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Rosetta::Languages::Unison::Snippet
  class Spec < Rosetta::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, wherever it is.
    remove :comments # x = 1 «-- The answer»

    # Find the comments by the way they start in a file that doesn't parse,
    # because Rouge has no Unison lexer.
    comment_lines "--", "{-" => "-}" # «-- A comment» and «{- A comment -}»

    # Skip the use clauses at the top of the file, up to the first other statement.
    skip_at_top :use # «use List map»
  end
end
