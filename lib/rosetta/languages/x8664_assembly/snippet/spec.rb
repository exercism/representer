# The website shows the first lines of each solution on its card. This file
# says what to leave out of an x86-64 assembly solution's snippet, so that the
# card shows the student's own code. docs/snippets.md explains each declaration.
module Rosetta::Languages::X8664Assembly::Snippet
  class Spec < Rosetta::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, wherever it is.
    remove :comments # mov rax, 1 «; The answer»
  end
end
