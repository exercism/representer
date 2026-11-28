module Inspector::Languages::Uiua::Common
  class Spec < Inspector::Engine::Language
    tracks "uiua"
    grammar "uiua"
    extensions ".ua"

    # Treat these as comments.
    comments_are :comment # X ← 1 «# The answer»

    # Write each primitive, system function and signature as one leaf, because
    # the grammar leaves their text out of its tree when they have more than
    # one part.
    text_nodes :primitive,       # «+₁»
               :system_function, # «&p»
               :signature        # F ← «|2» +
  end
end
