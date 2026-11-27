module Representer::Languages::Java
  class Spec < Representer::Engine::Language
    tracks "java"
    grammar "java"
    extensions ".java"

    # Treat these as comments, including Javadoc.
    comments_are :line_comment,  # int x = 1; «// The answer»
                 :block_comment  # «/** Says hello. */»
  end
end
