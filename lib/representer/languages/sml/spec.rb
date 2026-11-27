module Representer::Languages::Sml
  class Spec < Representer::Engine::Language
    tracks "sml"
    grammar "sml"
    extensions ".sml"

    # Treat these as comments.
    comments_are :block_comment, # val x = 1 «(* The answer *)»
                 :line_comment   # val x = 1 «(*) The answer»

    # Keep the text between the children of these, because the grammar
    # leaves the precedence of an operator out of the tree.
    text_between_children :infix_dec,  # infix «5» &
                          :infixr_dec  # infixr «5» &
  end
end
