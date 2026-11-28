# The website shows the first lines of each solution on its card. This file
# says what to leave out of an Euphoria solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Inspector::Languages::Euphoria::Snippet
  class Spec < Inspector::Engine::Snippet
    tracks "euphoria"

    # Remove every comment, wherever it is.
    remove :comments # integer x = 1 «-- The answer»

    # Find the comments by the way they start, because Rouge has no Euphoria lexer.
    comment_lines "--", "/*" => "*/" # «-- A comment» and «/* A comment */»

    # Skip the includes at the top of the file, up to the first other statement.
    skip_at_top :include # «include std/math.e»
  end
end
