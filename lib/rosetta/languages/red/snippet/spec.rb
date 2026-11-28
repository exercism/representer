# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Red solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Rosetta::Languages::Red::Snippet
  class Spec < Rosetta::Engine::Snippet
    # Work on lines, because the grammar reads the `Red [...]` header as two separate parts.
    lines_only

    # Remove every comment, wherever it is.
    remove :comments # x: 1 «; The answer»

    # Find the comments by the way they start, because Rouge has no Red lexer.
    comment_lines ";", "comment {" => "}" # «; A comment» and «comment {A comment}»

    # Skip the header at the top of the file, up to the first other statement.
    skip_at_top "Red [" # «Red [Title: "Leap"]»
  end
end
