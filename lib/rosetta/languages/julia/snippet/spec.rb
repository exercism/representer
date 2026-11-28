# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Julia solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Rosetta::Languages::Julia::Snippet
  class Spec < Rosetta::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, wherever it is.
    remove :comments # x = 1 «# The answer»

    # Skip the module header, the imports and the exports at the top of the
    # file, up to the first other statement.
    skip_at_top :module, # «module Leap»
                :using,  # «using Test»
                :import, # «import Base: show»
                :export  # «export is_leap_year»

    # Skip only the header line of a module, and show the code inside it.
    containers :module_definition # «module Leap» ...
  end
end
