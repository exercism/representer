# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Lean solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Rosetta::Languages::Lean::Snippet
  class Spec < Rosetta::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 1

    # Work on lines, so that the `end` at the bottom of the file can be
    # skipped. The grammar gives `end Leap` as a statement of its own, after
    # the code inside the namespace.
    lines_only

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
