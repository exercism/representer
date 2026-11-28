# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Pyret solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Rosetta::Languages::Pyret::Snippet
  class Spec < Rosetta::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, wherever it is.
    remove :comments # x = 1 «# The answer»

    # Find the comments by the way they start, for a file that doesn't parse,
    # because Rouge has no Pyret lexer.
    comment_lines "#", "#|" => "|#" # «# A comment» and «#| A comment |#»

    # Skip the context, provides and imports at the top of the file, up to the first other statement.
    skip_at_top "use context", # «use context essentials2020»
                :provide,      # «provide: leap end»
                :import,       # «import lists as L»
                :include       # «include string-dict»
  end
end
