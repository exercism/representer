# The website shows the first lines of each solution on its card. This file
# says what to leave out of a V solution's snippet, so that the card shows
# the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer::Languages::Vlang::Snippet
  class Spec < Representer::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, wherever it is.
    remove :comments # x := 1 «// The answer»

    # Skip the module clause and imports at the top of the file, up to the first other statement.
    skip_at_top :module, # «module main»
                :import  # «import strings»
  end
end
