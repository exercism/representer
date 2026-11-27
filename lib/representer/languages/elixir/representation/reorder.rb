# REPRESENTER_DSL.md defines the verbs in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so reordering only exists to group students who list things in a different order.
class Representer::Languages::Elixir::Representation
  class Reorder < Representer::Engine::Reorder
    # Reorder the functions and other code inside modules, and the entries of
    # maps and structs, including the ones after the `|` in `%{map | a: 1}`.
    # Normalise has already attached each `@spec` to its function, so a spec
    # moves with its function.
    # %{a: 1, b: 2} == %{b: 2, a: 1}
    sort :module_body, :map_content, :map_update
  end
end
