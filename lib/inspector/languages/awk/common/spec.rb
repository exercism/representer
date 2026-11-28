module Inspector::Languages::Awk::Common
  class Spec < Inspector::Engine::Language
    tracks "awk"
    grammar "awk"
    extensions ".awk", ".sh"

    # Treat these as comments.
    comments_are :comment # x = 1 «# The answer»

    # Read each regular expression as one leaf, because AWK's parser keeps
    # a regular expression as its text.
    text_nodes :regexp # «/^[a-z]+$/»
  end
end
