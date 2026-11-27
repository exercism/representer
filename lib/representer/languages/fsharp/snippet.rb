# The website shows the first lines of each solution on its card. This file
# says what to leave out of an F# solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer::Languages::FSharp
  class Snippet < Representer::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 1

    # Remove every comment, wherever it is.
    remove :comments # let x = 1 «// The answer»

    # Skip the module declaration and opens at the top of the file, up to the first other statement.
    skip_at_top :module,    # «module Leap»
                :namespace, # «namespace Exercism»
                :open       # «open System»

    # Skip only the header line of a module or namespace, and show the code inside it.
    containers :named_module, # «module Leap» ...
               :module_defn,  # «module Helpers =» ...
               :namespace     # «namespace Exercism» ...
  end
end
