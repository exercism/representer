module Representer::Languages::Roc::Common
  class Spec < Representer::Engine::Language
    tracks "roc"
    grammar "roc"
    extensions ".roc"

    # Treat these as comments, including documentation.
    comments_are :line_comment, # x = 1 «# The answer»
                 :doc_comment   # «## Says hello.»

    # Read each of these as one leaf. The grammar gives the `$` of a
    # mutable variable, the dots of a qualified type and the quotes of a
    # character as tokens.
    text_nodes :identifier,    # «$count»
               :concrete_type, # «Num.U64»
               :char           # «'a'»

    # Keep the text of each string, and the name of each tag in a type,
    # which the grammar leaves out of the tree.
    text_between_children :string,           # "«a »${b}«!»"
                          :multiline_string, # \\«a »${b}
                          :tag_type          # [«Green»(U8)]
  end
end
