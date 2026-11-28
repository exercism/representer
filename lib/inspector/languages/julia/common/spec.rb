module Inspector::Languages::Julia::Common
  class Spec < Inspector::Engine::Language
    tracks "julia"
    grammar "julia"
    extensions ".jl"

    # Treat these as comments.
    comments_are :line_comment,  # x = 1 «# The answer»
                 :block_comment  # «#= The answer =#»
  end
end
