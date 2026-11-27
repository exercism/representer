module Representer::Languages::PHP
  class Spec < Representer::Engine::Language
    tracks "php"
    grammar "php"
    extensions ".php"

    # Treat these as comments, including doc comments.
    comments_are :comment # $x = 1; «// The answer»

    # Keep the line breaks in a heredoc, and the indentation of its closing
    # marker, which the grammar leaves out of its children.
    text_between_children :heredoc, :heredoc_body, :nowdoc
  end
end
