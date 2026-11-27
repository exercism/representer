module Representer::Languages::OCaml
  class Spec < Representer::Engine::Language
    tracks "ocaml"
    grammar "ocaml"
    extensions ".ml"

    # Treat these as comments, including documentation comments.
    comments_are :comment # let x = 1 «(* The answer *)»

    # Keep the whole text of these. The grammar gives some of them as a
    # node that holds a token, and leaves the text of a string out of the
    # tree around its escapes.
    text_nodes :string_content,         # "«a\nb»"
               :quoted_string_content,  # {|«a "b"»|}
               :character_content,      # '«\n»'
               :mult_operator,          # x «mod» 2
               :pow_operator,           # x «lsl» 2
               :and_operator,           # a «&&» b
               :or_operator             # a «||» b
  end
end
