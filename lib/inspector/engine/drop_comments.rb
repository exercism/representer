module Inspector::Engine
  # Removes every node of the comment types, with its children, before a
  # language's GenerateAST steps (see Language.comments_are). A comment
  # never changes whether a solution works.
  class DropComments
    include Mandate
    include TreeHelpers

    initialize_with :tree, :types

    def call
      return tree if types.empty?

      drop(tree, "[#{types.map { |type| "(#{type})" }.join(' ')}]")
    end
  end
end
