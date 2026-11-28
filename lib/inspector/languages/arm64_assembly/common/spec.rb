module Inspector::Languages::Arm64Assembly::Common
  class Spec < Inspector::Engine::Language
    tracks "arm64-assembly"
    grammar "arm64_assembly"
    extensions ".s"

    # Keep the whole text of each string as one leaf, so GenerateAST can read
    # its escapes in one place.
    text_nodes :string # «"a\n"»

    # Treat these as comments.
    comments_are :comment,      # mov x0, #1 «// The answer»
                 :line_comment  # «# The answer»
  end
end
