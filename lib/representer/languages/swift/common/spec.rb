module Representer::Languages::Swift::Common
  class Spec < Representer::Engine::Language
    tracks "swift"
    grammar "swift"
    extensions ".swift"

    # Treat these as comments, including doc comments.
    comments_are :comment,           # let x = 1 «// The answer», «/// Says hello.»
                 :multiline_comment  # «/* The answer */»

    # Read these nodes as their whole text. The grammar gives a name that is
    # also a keyword, such as `lazy`, only as a keyword token, and an escape
    # such as `\u{41}` only as its first two characters.
    text_nodes :simple_identifier, :type_identifier, :str_escaped_char
  end
end
