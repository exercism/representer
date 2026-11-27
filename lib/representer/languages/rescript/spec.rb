module Representer::Languages::Rescript
  class Spec < Representer::Engine::Language
    tracks "rescript"
    grammar "rescript"
    extensions ".res"

    # Treat these as comments, including documentation comments.
    comments_are :line_comment,  # let x = 1 «// The answer»
                 :block_comment  # let x = «/* The answer */» 1

    # Keep the whole text of these. The grammar gives each of them as a
    # node that holds only some of its tokens.
    text_nodes :polyvar_identifier,   # «#red»
               :property_identifier,  # {«"key"»: 1}
               :character             # «'\n'»

    # Keep the text of a template string, which the grammar leaves out of
    # the tree around the substitutions.
    text_between_children :template_string_content # `«Hello, »${name}«!»`
  end
end
