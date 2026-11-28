module Inspector::Languages::Jq::Common
  class Spec < Inspector::Engine::Language
    tracks "jq"
    grammar "jq"
    extensions ".jq"

    # Treat these as comments.
    comments_are :comment # .x «# The answer»
  end
end
