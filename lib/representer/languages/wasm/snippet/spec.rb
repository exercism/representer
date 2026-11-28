# The website shows the first lines of each solution on its card. This file
# says what to leave out of a WebAssembly solution's snippet, so that the card
# shows the student's own code. docs/dsl.md explains each declaration.
module Representer::Languages::Wasm::Snippet
  class Spec < Representer::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 1

    # Remove every comment, wherever it is.
    remove :comments # (i32.const 1) «;; The answer»

    # Find the comments in a file that doesn't parse, by the way they start, because Rouge has no WebAssembly lexer.
    comment_lines ";;" # «;; A comment»
  end
end
