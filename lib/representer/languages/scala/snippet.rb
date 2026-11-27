# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Scala solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer::Languages::Scala
  class Snippet < Representer::Engine::Snippet
    tracks "scala"

    # Remove every comment, wherever it is.
    remove :comments # val x = 1 «// The answer»

    # Skip the package clause and imports at the top of the file, up to the first other statement.
    skip_at_top :package, # «package leap»
                :import   # «import scala.math.abs»
  end
end
