# The website shows the first lines of each solution on its card. This file
# says what to leave out of a COBOL solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Inspector::Languages::Cobol::Snippet
  class Spec < Inspector::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 1

    # Work on lines, because the grammar leaves the comment lines out of its
    # tree.
    lines_only

    # Remove every comment, wherever it is.
    remove :comments # «      * The answer»
  end
end
