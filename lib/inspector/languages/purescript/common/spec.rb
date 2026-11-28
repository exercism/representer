module Inspector::Languages::PureScript::Common
  class Spec < Inspector::Engine::Language
    tracks "purescript"
    grammar "purescript"
    extensions ".purs"

    # Treat these as comments, including documentation comments.
    comments_are :comment # x = 1 «-- The answer»

    # Read each qualified name as one leaf, because the compiler's parser
    # gives it as one name in a module.
    text_nodes :qualified_module,       # import «Data.Array»
               :qualified_variable,     # «Array.filter»
               :qualified_constructor,  # «Maybe.Just»
               :qualified_type,         # «Map.Map»
               :qualified_operator      # «Array.:»
  end
end
