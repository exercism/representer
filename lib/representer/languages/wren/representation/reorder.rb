# docs/representation.md defines the verbs in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so reordering only exists to group students who list things in a different order.
module Representer::Languages::Wren::Representation
  class Reorder < Representer::Engine::Reorder
    # Reorder the entries of a map.
    # {"a": 1, "b": 2} == {"b": 2, "a": 1}
    sort :map_literal
  end
end
