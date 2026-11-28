module Rosetta::Engine
  # Writes a tree as an indented s-expression. Leaves are written as their
  # text, quoted if they hold a literal value or anything that could be
  # mistaken for the s-expression's own syntax. A renamed name is written
  # as its placeholder (see NumberPlaceholders).
  #
  # With blank: true, every renamed name is written as `_`.
  class Serialize
    include Mandate

    PLAIN = /\A[^\s()"\\]+\z/

    initialize_with :tree, blank: false

    def call
      out = +""
      write(tree, 0, out)
      out
    end

    private
    def write(node, depth, out)
      out << "(" << node.type
      node.children.each { |child| write_child(child, depth + 1, out) }
      out << ")"
    end

    def write_child(node, depth, out)
      if node.leaf?
        out << " " << leaf_text(node)
      else
        out << "\n" << ("  " * depth)
        write(node, depth, out)
      end
    end

    def leaf_text(node)
      return "_" if blank && node.renamed
      return node.placeholder if node.placeholder

      text = node.named? ? node.text : node.type
      !node.quoted && text.match?(PLAIN) ? text : text.dump
    end
  end
end
