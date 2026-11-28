module Inspector::Languages::Clojure::Common
  class Spec < Inspector::Engine::Language
    tracks "clojure"
    grammar "clojure"
    extensions ".clj", ".cljc", ".cljs"

    # Treat these as comments. A `#_` comments out the form after it.
    comments_are :comment,  # (def x 1) «; The answer»
                 :dis_expr  # «#_(println x)»

    # Keep each keyword and regular expression as one leaf with its whole
    # text, because the grammar gives their parts as children.
    text_nodes :kwd_lit,   # «::total»
               :regex_lit  # «#"[a-z]+"»
  end
end
