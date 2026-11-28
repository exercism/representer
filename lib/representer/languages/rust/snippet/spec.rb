# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Rust solution's snippet, so that the card
# shows the student's own code. docs/dsl.md explains each declaration.
module Representer::Languages::Rust::Snippet
  class Spec < Representer::Engine::Snippet
    # Remove every comment, wherever it is.
    remove :comments # let x = 1; «// The answer»

    # Skip the imports and crate attributes at the top of the file, up to the first other statement.
    skip_at_top :use,    # «use std::collections::HashMap;»
                :extern, # «extern crate regex;»
                "#!["    # «#![allow(dead_code)]»
  end
end
