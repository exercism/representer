module Representer::Engine
  # Returns the text of every name defined in the trees. A staged language's
  # representation says which nodes define a name (see
  # Representation.names_defined_by),
  # and this command asks every node in turn.
  class CollectDefinedNames
    include Mandate

    initialize_with :trees, :representation

    def call
      names = Set.new
      trees.each do |tree|
        tree.each_descendant do |node|
          representation.names_defined_by(node).each { |leaf| names << representation.name_text(leaf) }
        end
      end
      names
    end
  end
end
