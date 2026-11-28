# The website shows the first lines of each solution on its card. This file
# says what to leave out of an Odin solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer::Languages::Odin::Snippet
  class Spec < Representer::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, wherever it is.
    remove :comments # x := 1 «// The answer»

    # Find the comments in a file that doesn't parse, by the way they start, because Rouge has no Odin lexer.
    comment_lines "//", "/*" => "*/" # «// A comment» and «/* A comment */»

    # Skip the package declaration and imports at the top of the file, up to the first other statement.
    skip_at_top :package, # «package leap»
                :import   # «import "core:fmt"»
  end
end
