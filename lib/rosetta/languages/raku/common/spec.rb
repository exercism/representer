module Rosetta::Languages::Raku::Common
  class Spec < Rosetta::Engine::Language
    tracks "raku"
    grammar "raku"
    extensions ".rakumod", ".raku", ".rakutest", ".pm6", ".p6"

    # Treat these as comments, including Pod, Raku's blocks of documentation.
    comments_are :comment, # say 1; «# The answer»
                 :pod      # «=begin pod» ... «=end pod»
  end
end
