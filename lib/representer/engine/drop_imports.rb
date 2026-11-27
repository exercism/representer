module Representer::Engine
  # Removes the code that counts as an import in a staged language (see
  # Language.imports). Every solution that the representer sees
  # passes its tests, so it has already loaded everything it needs.
  class DropImports
    include Mandate
    include TreeHelpers

    initialize_with :tree, :language

    def call
      language.imports.each { |pattern| drop(tree, pattern) }
      tree
    end
  end
end
