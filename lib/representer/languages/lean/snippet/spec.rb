# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Lean solution's snippet, so that the card
# shows the student's own code. docs/dsl.md explains each declaration.
module Representer::Languages::Lean::Snippet
  class Spec < Representer::Engine::Snippet
    tracks "lean"

    # Remove every comment, wherever it is.
    remove :comments # def x := 1 «-- The answer»

    # Skip the imports, opens and namespace at the top of the file, up to the first other statement.
    skip_at_top :import,    # «import Std»
                :open,      # «open Nat»
                :namespace  # «namespace Leap»

    # Skip the `end` lines at the bottom of the file, which close the namespace skipped at the top.
    skip_at_bottom :end # «end Leap»
  end
end
