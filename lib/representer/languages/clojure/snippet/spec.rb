# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Clojure solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer::Languages::Clojure::Snippet
  class Spec < Representer::Engine::Snippet
    # Remove every comment, including each `#_` form, wherever it is.
    remove :comments # (def x 1) «; The answer»

    # Skip the namespace declaration at the top of the file, up to the first other statement.
    skip_at_top "(ns" # «(ns two-fer)»
  end
end
