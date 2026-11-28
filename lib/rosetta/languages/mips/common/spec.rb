module Rosetta::Languages::Mips::Common
  class Spec < Rosetta::Engine::Language
    tracks "mips"
    grammar "mips"
    extensions ".mips"

    # Keep the whole text of these, because the grammar leaves out their
    # text, apart from their escapes.
    text_nodes :string, # «"Hello"»
               :char    # «'a'»

    # Treat these as comments.
    comments_are :comment # li $v0, 1 «# The answer»
  end
end
