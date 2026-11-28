module Rosetta::Languages::Ballerina::Common
  class Spec < Rosetta::Engine::Language
    tracks "ballerina"
    grammar "ballerina"
    extensions ".bal"

    # Treat these as comments.
    comments_are :line_comment, # int x = 1; «// The answer»
                 :doc_comment   # «# Returns the sum.»
  end
end
