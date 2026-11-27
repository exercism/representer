# REPRESENTER_DSL.md defines the verbs in this file.
module Representer::Languages::Ruby
  class Reorder < Representer::Engine::Reorder
    # The order of the methods and other code in a class's or a module's
    # body makes no difference, and nor does the order of a hash's entries.
    # Normalise has already marked each method with its visibility, so a
    # method keeps its visibility wherever it moves.
    sort :class_body, :module_body, :hash
  end
end
