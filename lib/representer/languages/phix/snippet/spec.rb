# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Phix solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Representer::Languages::Phix::Snippet
  class Spec < Representer::Engine::Snippet
    tracks "phix"

    # Remove every comment, wherever it is.
    remove :comments # integer x = 1 «-- The answer»

    # Find the comments by the way they start, because Rouge has no Phix lexer.
    comment_lines "--", "//", "--/*" => "--*/", "/*" => "*/" # «-- A comment» and «/* A comment */»

    # Skip the includes and options at the top of the file, up to the first other statement.
    skip_at_top :include,   # «include builtins/timedate.e»
                :with,      # «with javascript_semantics»
                :requires,  # «requires("1.0.2")»
                :namespace  # «namespace leap»
  end
end
