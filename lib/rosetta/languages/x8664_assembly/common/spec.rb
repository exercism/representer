module Rosetta::Languages::X8664Assembly::Common
  class Spec < Rosetta::Engine::Language
    tracks "x86-64-assembly"
    grammar "x86_64_assembly"
    extensions ".asm"

    # Treat these as comments.
    comments_are :comment # mov rax, 1 «; The answer»
  end
end
