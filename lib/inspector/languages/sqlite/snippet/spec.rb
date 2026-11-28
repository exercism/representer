# The website shows the first lines of each solution on its card. This file
# says what to leave out of an SQLite solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Inspector::Languages::Sqlite::Snippet
  class Spec < Inspector::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, wherever it is.
    remove :comments # SELECT 1 «-- The answer»
  end
end
