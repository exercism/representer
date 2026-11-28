# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Ballerina solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Inspector::Languages::Ballerina::Snippet
  class Spec < Inspector::Engine::Snippet
    # Work on lines, because the grammar reads the code as a flat list of tokens.
    lines_only

    # Remove every comment, wherever it is.
    remove :comments # int x = 1; «// The answer»

    # Find the comments by the way they start, because Rouge has no Ballerina lexer.
    comment_lines "//", "#" # «// A comment» and «# A comment»

    # Skip the imports at the top of the file, up to the first other statement.
    skip_at_top :import # «import ballerina/io;»
  end
end
