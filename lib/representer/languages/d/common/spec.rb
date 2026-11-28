module Representer::Languages::D::Common
  class Spec < Representer::Engine::Language
    tracks "d"
    grammar "d"
    extensions ".d"

    # Treat these as comments, including documentation comments.
    comments_are :comment # int x = 1; «// The answer»

    # Read each string and character as its whole text, because the grammar
    # leaves out the text around its escapes.
    text_nodes :quoted_string, # «"a\nb"»
               :raw_string,    # «`a\b`», «r"a\b"»
               :token_string,  # «q{a < b}»
               :hex_string,    # «x"0A"»
               :char_literal   # «'\n'»

    # Keep the text of an interpolated string, because the grammar leaves out
    # the text between its interpolations.
    text_between_children :interpolated_quoted_string, # i"«a »$(b)«!»"
                          :interpolated_raw_string,    # i`«a »$(b)«!»`
                          :interpolated_token_string   # iq{«a »$(b)«!»}
  end
end
