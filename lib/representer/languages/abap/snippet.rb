# The website shows the first lines of each solution on its card. This file
# says what to leave out of an ABAP solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer::Languages::Abap
  class Snippet < Representer::Engine::Snippet
    tracks "abap"

    # Remove every comment, wherever it is.
    remove :comments # DATA x TYPE i. «" The answer»

    # Skip the class's DEFINITION section at the top of the file, because it only lists what its IMPLEMENTATION defines.
    skip_at_top "CLASS" => "IMPLEMENTATION." # «CLASS zcl_leap DEFINITION.» ... «CLASS zcl_leap IMPLEMENTATION.»
  end
end
