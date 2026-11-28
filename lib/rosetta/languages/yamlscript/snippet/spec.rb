# The website shows the first lines of each solution on its card. This file
# says what to leave out of a YAMLScript solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Rosetta::Languages::YAMLScript::Snippet
  class Spec < Rosetta::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, wherever it is.
    remove :comments # x =: 1 «# The answer»

    # Find the comments by the way they start in a file that doesn't parse,
    # because Rouge has no YAMLScript lexer.
    comment_lines "#" # «# A comment»
  end
end
