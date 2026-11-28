# docs/representation.md defines the verbs in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on.
module Inspector::Languages::Elixir::Representation
  class Normalise < Inspector::Engine::Normalise
    # Drop the docstrings declared in common/spec.rb, because they never change
    # whether a passing solution works.
    # @moduledoc "..." @doc "..." @typedoc "..."
    drop :docstrings
  end
end
