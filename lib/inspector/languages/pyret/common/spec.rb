module Inspector::Languages::Pyret::Common
  class Spec < Inspector::Engine::Language
    tracks "pyret"
    grammar "pyret"
    extensions ".arr"

    # Treat these as comments.
    comments_are :line_comment,  # x = 1 «# The answer»
                 :block_comment  # «#| The answer |#»

    # Keep the whole text of these. The grammar gives each of them as a node
    # that holds a token.
    text_nodes :binop,             # a «==» b
               :check_op,          # f(1) «is» 2
               :check_op_postfix,  # f(1) «does-not-raise»
               :bool_expr          # «true»
  end
end
