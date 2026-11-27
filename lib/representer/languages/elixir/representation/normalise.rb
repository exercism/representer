# REPRESENTER_DSL.md defines the verbs in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on.
class Representer::Languages::Elixir::Representation
  class Normalise < Representer::Engine::Normalise
    # Drop the docstrings declared in spec.rb, because they never change
    # whether a passing solution works.
    # @moduledoc "..." @doc "..." @typedoc "..."
    drop :docstrings
  end
end
