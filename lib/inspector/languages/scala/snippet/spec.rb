# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Scala solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Inspector::Languages::Scala::Snippet
  class Spec < Inspector::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, wherever it is.
    remove :comments # val x = 1 «// The answer»

    # Skip the package clause and imports at the top of the file, up to the first other statement.
    skip_at_top :package, # «package leap»
                :import   # «import scala.math.abs»
  end
end
