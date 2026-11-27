module Representer::Languages::Scala
  class Spec < Representer::Engine::Language
    tracks "scala"
    grammar "scala"
    extensions ".scala", ".sc"

    # Treat these as comments, including Scaladoc.
    comments_are :comment,       # val x = 1 «// The answer»
                 :block_comment  # «/** Says hello. */»

    # Read each string as its whole text, because the grammar leaves out the
    # text around its escapes.
    text_nodes :string # «"a\nb"»

    # Keep the text of an interpolated string, because the grammar leaves out
    # the text between its interpolations.
    text_between_children :interpolated_string # s"«a »$b«!»"
  end
end
