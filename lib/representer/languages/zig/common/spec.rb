module Representer::Languages::Zig::Common
  class Spec < Representer::Engine::Language
    tracks "zig"
    grammar "zig"
    extensions ".zig"

    # Treat these as comments.
    comments_are :line_comment,           # const x = 1; «// The answer»
                 :doc_comment,            # «/// Adds two numbers.»
                 :container_doc_comment   # «//! Solves leap.»

    # Read builtins, strings and characters as leaves, because the grammar
    # gives them only their quotes or `@` as children.
    text_nodes :BUILTINIDENTIFIER, :STRINGLITERALSINGLE, :LINESTRING, :CHAR_LITERAL
  end
end
