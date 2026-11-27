# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Wren solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer
  module Languages
    class Wren
      class Snippet < Representer::Engine::Snippet
        # Remove every comment, wherever it is.
        remove :comments # var x = 1 «// The answer»

        # Find the comments in a file that doesn't parse, by the way they start, because Rouge has no Wren lexer.
        comment_lines "//" # «// A comment»

        # Skip the imports at the top of the file, up to the first other statement.
        skip_at_top :import # «import "random" for Random»
      end
    end
  end
end
