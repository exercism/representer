# The website shows the first lines of each solution on its card. This file
# says what to leave out of a C solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer::Languages::C
  class Snippet < Representer::Engine::Snippet
    tracks "c"

    # Remove every comment, wherever it is.
    remove :comments # int x = 1; «// The answer»

    # Skip the includes and header guards at the top of the file, up to the first other statement.
    skip_at_top "#include", # «#include <stdbool.h>»
                "#ifndef",  # «#ifndef LEAP_H»
                "#pragma"   # «#pragma once»
  end
end
