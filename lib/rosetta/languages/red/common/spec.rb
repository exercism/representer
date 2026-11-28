module Rosetta::Languages::Red::Common
  class Spec < Rosetta::Engine::Language
    tracks "red"
    grammar "red"
    extensions ".red"

    # Treat these as comments.
    comments_are :comment # x: 1 «; The answer»

    # Read each of these as one leaf with its whole text, because the
    # grammar leaves their text out of the tree.
    text_nodes :set_word,          # «total:»
               :path_start,        # «obj/»x
               :refinement,        # «/local»
               :multiline_string,  # «{a "b"}»
               :raw_string,        # «%{a}%»
               :char,              # «#"a"»
               :url,               # «http://example.com»
               :binary,            # «#{FF}»
               :construction       # «#(none)»
  end
end
