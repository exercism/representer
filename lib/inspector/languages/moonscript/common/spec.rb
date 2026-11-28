module Inspector::Languages::Moonscript::Common
  class Spec < Inspector::Engine::Language
    tracks "moonscript"
    grammar "moonscript"
    extensions ".moon"

    # Treat these as comments.
    comments_are :comment # x = 1 «-- The answer»
  end
end
