module Inspector::Languages::Coffeescript::Common
  class Spec < Inspector::Engine::Language
    tracks "coffeescript"
    grammar "coffeescript"
    extensions ".coffee"

    # Treat these as comments, including block comments.
    comments_are :comment # x = 1 «# The answer», «### The answer ###»

    # Keep the text of strings and heregexes, which the grammar leaves
    # between their children.
    text_between_children :string, # "«One for »#{name}"
                          :regex   # «///^a///»
  end
end
