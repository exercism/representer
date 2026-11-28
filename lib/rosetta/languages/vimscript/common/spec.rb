module Rosetta::Languages::Vimscript::Common
  class Spec < Rosetta::Engine::Language
    tracks "vimscript"
    grammar "vim"
    extensions ".vim"

    # Treat these as comments.
    comments_are :comment,                  # let x = 1 «" The answer»
                 :line_continuation_comment # «"\ The answer»

    # Write each function argument and environment variable as one leaf.
    # GenerateAST reads the argument's name from its text, so that the
    # numbers in `a:0` and `a:000` keep their text.
    text_nodes :argument,    # «a:name»
               :env_variable # «$HOME»

    # Keep the spaces around the dot of a member access, which the grammar
    # leaves out of its tree, because Vim reads a dot with spaces around it
    # as concatenation.
    text_between_children :field_expression # name« . »suffix
  end
end
