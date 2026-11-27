# REPRESENTER_DSL.md defines the verbs in this file.
# Remember that all solutions pass the tests and we don't need to run the code
# so reordering is purely a cosmetic thing to allow for students who choose
# to list methods in a different order to have grouped solutions
module Representer::Languages::Ruby
  class Reorder < Representer::Engine::Reorder
    # Reorder the methods and other code inside classes and modules
    # Modifiers like "private" are already captured and stripped.
    sort :class_body, :module_body

    # Reorder manually written hash keys
    sort :hash # {"a": 1, "b": 2} == {"b": 2, "a": 1}
  end
end
