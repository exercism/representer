# docs/dsl.md defines the verbs in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so reordering only exists to group students who list things in a different order.
module Representer::Languages::Clojure::Representation
  class Reorder < Representer::Engine::Reorder
    VALUES = [:literal, :char_lit, :num_lit, :kwd_lit].freeze

    def call
      super.tap do |root|
        reorder_sets_of_values!(root)
        reorder_maps_of_values!(root)
      end
    end

    private
    # Reorder the items of a set that holds only strings, characters, numbers
    # and keywords.
    # #{\A \C} == #{\C \A}
    def reorder_sets_of_values!(root)
      root.each_descendant do |node|
        node.children.sort_by! { |item| [item.type, item.text] } if node.type == "set_lit" && values?(node.children)
      end
    end

    # Reorder the entries of a map that holds only strings, characters,
    # numbers and keywords.
    # {:b 1 :a 2} == {:a 2 :b 1}
    def reorder_maps_of_values!(root)
      root.each_descendant do |node|
        next unless node.type == "map_lit" && values?(node.children)

        node.children = node.children.each_slice(2).sort_by { |entry| entry.flat_map { |item| [item.type, item.text] } }.flatten
      end
    end

    def values?(items) = items.all? { |item| item.leaf? && VALUES.include?(item.type.to_sym) }
  end
end
