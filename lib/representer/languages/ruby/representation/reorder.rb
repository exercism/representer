# docs/representation.md defines the verbs in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so reordering only exists to group students who list things in a different order.
module Representer::Languages::Ruby::Representation
  class Reorder < Representer::Engine::Reorder
    # Reorder the methods and other code inside classes and modules. Normalise
    # has already attached each modifier, such as `private`, to its methods.
    # def a; end; def b; end == def b; end; def a; end
    sort :class_body, :module_body

    # Reorder manually written hash keys.
    # {"a": 1, "b": 2} == {"b": 2, "a": 1}
    sort :hash
  end
end
