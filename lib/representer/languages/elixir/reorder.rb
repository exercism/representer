# REPRESENTER_DSL.md defines the verbs in this file.
module Representer::Languages::Elixir
  class Reorder < Representer::Engine::Reorder
    # The order of the code in a module's body makes no difference, and nor
    # does the order of a map's or a struct's entries, including the ones
    # after the `|` in `%{map | a: 1}`. The old representer sorted the `use`
    # lines and the entries, and this also sorts the functions. Normalise
    # has already moved each `@spec` into its function, so a spec moves
    # with its function.
    sort :module_body, :map_content, :map_update
  end
end
