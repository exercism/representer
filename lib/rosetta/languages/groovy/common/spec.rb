module Rosetta::Languages::Groovy::Common
  class Spec < Rosetta::Engine::Language
    tracks "groovy"
    grammar "groovy"
    extensions ".groovy"

    # Treat these as comments, including Groovydoc and a shebang line.
    comments_are :line_comment,      # def x = 1 «// The answer»
                 :block_comment,     # «/* The answer */»
                 :groovydoc_comment, # «/** Says hello. */»
                 :shebang            # «#!/usr/bin/env groovy»
  end
end
