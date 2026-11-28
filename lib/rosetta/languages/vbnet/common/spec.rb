module Rosetta::Languages::VBNet::Common
  class Spec < Rosetta::Engine::Language
    tracks "vbnet"
    grammar "vbnet"
    extensions ".vb"

    # Treat these as comments.
    comments_are :comment # Dim x = 1 «' The answer»
  end
end
