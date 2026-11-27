# The website shows the first lines of each solution on its card. This file
# says what to leave out of a C++ solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer
  module Languages
    class Cpp
      class Snippet < Representer::Engine::Snippet
        # Remove every comment, wherever it is.
        remove :comments # int x = 1; «// The answer»

        # Skip the includes and namespace lines at the top of the file, up to the first other statement.
        skip_at_top "#include",        # «#include <string>»
                    "#pragma",         # «#pragma once»
                    "using namespace", # «using namespace std;»
                    :namespace         # «namespace leap {»

        # Skip only the header line of a namespace, and show the code inside it.
        containers :namespace_definition # «namespace leap {» ... «}»
      end
    end
  end
end
