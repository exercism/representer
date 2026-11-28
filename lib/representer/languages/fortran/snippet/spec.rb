# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Fortran solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer::Languages::Fortran::Snippet
  class Spec < Representer::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, wherever it is.
    remove :comments # x = 1 «! The answer»

    # Skip the uses of modules at the top of the file, up to the first other statement.
    skip_at_top :use # «use iso_fortran_env»
  end
end
