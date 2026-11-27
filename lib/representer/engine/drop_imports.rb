module Representer::Engine
  # Removes the code that counts as an import, for a language's
  # representation (see Representation.imports). Every solution that the
  # representer sees passes its tests, so it has already loaded everything
  # it needs.
  class DropImports
    include Mandate
    include TreeHelpers

    initialize_with :tree, :representation

    def call
      representation.imports.each { |pattern| drop(tree, pattern) }
      tree
    end
  end
end
