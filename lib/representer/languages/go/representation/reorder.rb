# docs/representation.md defines the verbs in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so reordering only exists to group students who list things in a different order.
module Representer::Languages::Go::Representation
  class Reorder < Representer::Engine::Reorder
    # Reorder the declarations at the top of the file.
    # func A() {}; type T int == type T int; func A() {}
    sort :source_file
  end
end
