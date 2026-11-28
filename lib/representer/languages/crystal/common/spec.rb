module Representer::Languages::Crystal::Common
  class Spec < Representer::Engine::Language
    tracks "crystal"
    grammar "crystal"
    extensions ".cr"

    # Keep the whole text of a constant, because the grammar only gives the
    # `::` of a path such as `Foo::Bar`.
    text_nodes :constant # «Foo::Bar»

    # Treat these as comments.
    comments_are :comment # x = 1 «# The answer»
  end
end
