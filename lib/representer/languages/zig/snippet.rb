# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Zig solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer
  module Languages
    class Zig
      class Snippet < Representer::Engine::Snippet
        # Remove every comment, wherever it is.
        remove :comments # const x = 1; «// The answer»

        # Skip the import of the standard library at the top of the file, up to the first other statement.
        skip_at_top "const std = @import" # «const std = @import("std");»
      end
    end
  end
end
