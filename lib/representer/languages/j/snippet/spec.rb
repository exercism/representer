# The website shows the first lines of each solution on its card. This file
# says what to leave out of a J solution's snippet, so that the card
# shows the student's own code. docs/dsl.md explains each declaration.
module Representer::Languages::J::Snippet
  class Spec < Representer::Engine::Snippet
    tracks "j"

    # Remove every comment, wherever it is.
    remove :comments # x =: 1 «NB. The answer»

    # Skip the loads and requires at the top of the file, up to the first other statement.
    skip_at_top :load,    # «load 'format/printf'»
                :require  # «require 'strings'»
  end
end
