# Elixir's Reorder stage keeps two rules of the old representer
# (exercism/elixir-representer), which sorted code if its order makes no
# difference:
#
# - It sorts the `use` statements at the start of a module or a file.
#   (The old representer also sorted `alias`, `require` and `import`, but
#   the engine drops those.)
# - It sorts the entries of each map and struct, also after the `|` in
#   `%{map | a: 1}`.
#
# Each sorts by the code with every renamed name left out, so two solutions
# that only name things differently get the same order.
module Representer
  module Languages
    module Elixir
      class Reorder < Engine::Reorder
        def call
          each_node(tree) do |node, _|
            case node.type
            when "source", "do_block"
              uses = node.children.take_while { |child| child.type == "call" && child[:target]&.text == "use" }
              node.children[0, uses.size] = sorted(uses)
            when "map_content"
              node.children = sorted(node.children)
              update = node.children.find { |child| child.type == "binary_operator" && child[:right]&.type == "list" }
              update[:right].children = sorted(update[:right].children) if update
            end
          end
          tree
        end

        private
        def sorted(nodes) = nodes.sort_by.with_index { |node, index| [Engine::Serialize.(node, nil, blank: true), index] }
      end
    end
  end
end
