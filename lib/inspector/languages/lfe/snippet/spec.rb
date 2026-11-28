# The website shows the first lines of each solution on its card. This file
# says what to leave out of an LFE solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Inspector::Languages::Lfe::Snippet
  class Spec < Inspector::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, wherever it is.
    remove :comments # (+ x 1) «; The answer»

    # Skip the module declaration and the included files at the top of the
    # file, up to the first other statement.
    skip_at_top "(defmodule",  # «(defmodule leap (export (leap-year 1)))»
                "(include-lib" # «(include-lib "lfe/include/clj.lfe")»
  end
end
