module Inspector::Languages::Unison::Common
  class Spec < Inspector::Engine::Language
    tracks "unison"
    grammar "unison"
    extensions ".u"

    # Treat these as comments, including documentation and everything after
    # a `---` line, which Unison ignores.
    comments_are :comment,    # x = 1 «-- The answer»
                 :doc_block,  # «{{ Says hello. }}»
                 :fold        # «---»
  end
end
