module Representer::Engine
  # Gives each name marked by RenameUserDefinedNodes its placeholder, and
  # returns the mapping from each placeholder to the name it replaced.
  #
  # It numbers the names in the order they first appear in the tree, which
  # is the order Serialize writes them in. Every leaf with the same name
  # gets the same placeholder. A placeholder loses the leaf's own text,
  # which may have said what kind of name it was (`@x` or `X` in Ruby), so
  # a placeholder for any type of name except the representation's first is
  # written with its type: (instance_variable PLACEHOLDER_1).
  class NumberPlaceholders
    include Mandate

    initialize_with :tree, :representation

    def call
      placeholders = {}
      tree.each_descendant do |node|
        next unless node.renamed

        name = representation.name_text(node)
        placeholders[name] ||= "PLACEHOLDER_#{placeholders.size + 1}"
        node.placeholder = written(node, placeholders[name])
      end
      placeholders.invert
    end

    private
    def written(leaf, placeholder)
      text = "#{representation.names[leaf.type]}#{placeholder}"
      leaf.type == representation.names.keys.first ? text : "(#{leaf.type} #{text})"
    end
  end
end
