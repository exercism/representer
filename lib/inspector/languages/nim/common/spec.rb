module Inspector::Languages::Nim::Common
  class Spec < Inspector::Engine::Language
    tracks "nim"
    grammar "nim"
    extensions ".nim", ".nims"

    # Keep the text around the escapes in a string, because the grammar only
    # gives the escapes.
    text_between_children :string_content # "«Hello»\n"

    # Treat these as comments.
    comments_are :comment,                     # let x = 1 «# The answer»
                 :documentation_comment,       # «## Adds two numbers.»
                 :block_comment,               # «#[ The answer ]#»
                 :block_documentation_comment  # «##[ Adds two numbers. ]##»
  end
end
