# The website shows the first lines of each solution on its card. This file
# says what to leave out of an AWK solution's snippet, so that the card
# shows the student's own code. docs/dsl.md explains each declaration.
module Representer::Languages::Awk::Snippet
  class Spec < Representer::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, wherever it is.
    remove :comments # x = 1 «# The answer»

    # Skip the files and extensions loaded at the top of the file, up to the
    # first other statement.
    skip_at_top "@include", # «@include "array-utils.awk"»
                "@load"     # «@load "ordchr"»
  end
end
