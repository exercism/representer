# The website shows the first lines of each solution on its card. This file
# says what to leave out of an ARM64 assembly solution's snippet, so that the
# card shows the student's own code. docs/snippets.md explains each declaration.
module Inspector::Languages::Arm64Assembly::Snippet
  class Spec < Inspector::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, wherever it is.
    remove :comments # mov x0, #1 «// The answer»

    # Find the comments in a file that doesn't parse, by the way they start,
    # because Rouge has no ARM64 assembly lexer.
    comment_lines "//", "/*" => "*/" # «// A comment»
  end
end
