# The website shows the first lines of each solution on its card. This file
# says what to leave out of a jq solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer::Languages::Jq::Snippet
  class Spec < Representer::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, wherever it is.
    remove :comments # .x «# The answer»

    # Find the comments by the way they start in a file that doesn't parse,
    # because Rouge has no jq lexer.
    comment_lines "#" # «# A comment»

    # Skip the module directive and the imports at the top of the file, up
    # to the first other statement.
    skip_at_top :module,  # «module {name: "colors"};»
                :import,  # «import "lib" as lib;»
                :include  # «include "lib";»
  end
end
