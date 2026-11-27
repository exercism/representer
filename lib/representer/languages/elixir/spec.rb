# This file says what Elixir is and how the representer reads its files.
# REPRESENTER_DSL.md explains each declaration. representation.rb and
# snippet.rb hold the settings of each output, and the folders hold
# Elixir's stages.
module Representer::Languages::Elixir
  class Spec < Representer::Engine::Language
    tracks "elixir"
    grammar "elixir"
    extensions ".ex", ".exs"

    # Treat these as comments.
    comments_are :comment # x = 1 «# The answer»

    # Treat `@moduledoc`, `@doc` and `@typedoc` as docstrings.
    docstrings_are "@moduledoc {{...}}",  # «@moduledoc "Counts things."»
                   "@doc {{...}}",        # «@doc "Says hello."»
                   "@typedoc {{...}}"     # «@typedoc "A count."»
  end
end
