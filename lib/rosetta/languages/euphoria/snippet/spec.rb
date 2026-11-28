# The website shows the first lines of each solution on its card. This file
# says what to leave out of an Euphoria solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Rosetta::Languages::Euphoria::Snippet
  class Spec < Rosetta::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, wherever it is.
    remove :comments # integer x = 1 «-- The answer»

    # Find the comments by the way they start in a file that doesn't parse,
    # because Rouge has no Euphoria lexer.
    comment_lines "--", "/*" => "*/" # «-- A comment» and «/* A comment */»

    # Skip the includes at the top of the file, up to the first other statement.
    skip_at_top :include # «include std/math.e»
  end
end
