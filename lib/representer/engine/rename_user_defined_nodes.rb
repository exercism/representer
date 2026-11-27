module Representer
  module Engine
    # Marks every name the solution defines, wherever it appears, so that it
    # gets a placeholder (see NumberPlaceholders).
    #
    # It walks the trees twice. The first walk collects the text of every
    # name the solution defines (see CollectDefinedNames). The second walk
    # marks every name with one of those texts: its definition, and every
    # use, call and symbol with the same text.
    class RenameUserDefinedNodes
      include Mandate

      initialize_with :trees, :language

      def call
        renamed = CollectDefinedNames.(trees, language)
        trees.each do |tree|
          tree.each_descendant do |node|
            node.renamed = true if language.name?(node) && renamed.include?(language.name_text(node))
          end
        end
      end
    end
  end
end
