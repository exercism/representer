module Representer::Languages::Dart::Common
  class Spec < Representer::Engine::Language
    tracks "dart"
    grammar "dart"
    extensions ".dart"

    # Keep the text between the children of these, because the grammar
    # leaves out the text of a string.
    text_between_children :string_literal # '«a»$b«c»'

    # Treat these as comments, including documentation comments.
    comments_are :comment,               # var x = 1; «// The answer»
                 :documentation_comment  # «/// Says hello.»
  end
end
