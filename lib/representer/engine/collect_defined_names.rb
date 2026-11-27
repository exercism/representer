module Representer
  module Engine
    # Returns the text of every name defined in the trees. A staged language
    # says which nodes define a name (see StagedLanguage#names_defined_by),
    # and this command asks every node in turn.
    class CollectDefinedNames
      include Mandate

      initialize_with :trees, :language

      def call
        names = Set.new
        trees.each do |tree|
          tree.each_descendant do |node|
            language.names_defined_by(node).each { |leaf| names << language.name_text(leaf) }
          end
        end
        names
      end
    end
  end
end
