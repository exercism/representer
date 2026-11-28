module Inspector::Engine
  # Replaces each node of the types that holds one named child with that
  # child, for brackets that only group (see GenerateAST.unwrap). The
  # tree's shape already shows the grouping, so `(1 + 2)` becomes `1 + 2`.
  class UnwrapBrackets
    include Mandate
    include TreeHelpers

    initialize_with :tree, :types

    def call
      return tree if types.empty?

      unwrap(tree, "[#{types.map { |type| "(#{type})" }.join(' ')}]")
    end
  end
end
