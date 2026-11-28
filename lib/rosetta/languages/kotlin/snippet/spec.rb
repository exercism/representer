# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Kotlin solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Rosetta::Languages::Kotlin::Snippet
  class Spec < Rosetta::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, wherever it is.
    remove :comments # val x = 1 «// The answer»

    # Skip the package header, imports and file annotations at the top of the file, up to the first other statement.
    skip_at_top :package, # «package leap»
                :import,  # «import kotlin.math.abs»
                "@file:"  # «@file:JvmName("Leap")»
  end
end
