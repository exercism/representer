# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Bash solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Rosetta::Languages::Bash::Snippet
  class Spec < Rosetta::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, wherever it is, including the `#!` line.
    remove :comments # x=1 «# The answer»

    # Skip the files sourced at the top of the file, up to the first other
    # statement.
    skip_at_top :source # «source ./utils.bash»
  end
end
