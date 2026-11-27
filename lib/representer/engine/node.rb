module Representer::Engine
  # One node of a syntax tree.
  #
  # The engine copies each tree-sitter tree into these nodes, because
  # tree-sitter's own trees can't be changed and rewrite rules need to
  # change them.
  #
  # - type: the node's type, as a String ("call", "identifier", or for an
  #   anonymous token its canonical spelling, such as "(" or "def").
  # - text: the source text. Only leaves keep it.
  # - named: false for anonymous tokens (keywords, punctuation, operators).
  # - field: the field name the parent gives this node ("name", "body"...).
  # - children: the child nodes, in source order.
  # - quoted: true for a leaf that holds a literal value (such as a string's
  #   contents), which the output always writes in quotes.
  # - role: set by the naming rules. :member for a name after a dot, which
  #   is only renamed if the solution defines a member with that name.
  # - scope: set by a language's rules for a local name, to the node that
  #   holds the name's declaration (such as a method). Two locals with the
  #   same name in different scopes get different placeholders.
  # - renamed: set by RenameUserDefinedNodes, to true for a leaf that
  #   holds a name the solution defines.
  # - placeholder: set by NumberPlaceholders on each renamed leaf, to the
  #   text that Serialize writes in its place.
  # - span: the node's byte range in the source. Grammar#parse only sets it
  #   when asked to, because only CodePattern needs it.
  class Node
    attr_accessor :type, :text, :named, :field, :children, :quoted, :role, :scope, :renamed, :placeholder, :span

    def initialize(type, children = [], text: nil, named: true, field: nil, quoted: false)
      @type = type.to_s
      @children = children
      @text = text
      @named = named
      @field = field&.to_s
      @quoted = quoted
      @role = nil
      @scope = nil
      @renamed = false
      @placeholder = nil
    end

    def self.leaf(type, text, quoted: false) = new(type, [], text:, quoted:)
    def self.token(text) = new(text, [], text:, named: false)

    def named? = named

    # Leaves are the nodes that hold source text: names, literals and
    # tokens. A node that has lost all its children (such as `{}` once
    # its braces are dropped) is not a leaf.
    def leaf? = !text.nil?
    def named_children = children.select(&:named?)

    # The first child with this field name.
    def [](field)
      field = field.to_s
      children.find { |child| child.field == field }
    end

    # Replaces one child (found by identity) with another node, which takes
    # over the old child's field name.
    def replace_child(old, replacement)
      index = children.index { |child| child.equal?(old) }
      raise ArgumentError, "#{old.type} is not a child of #{type}" unless index

      replacement.field = old.field
      children[index] = replacement
      replacement
    end

    def each_descendant
      stack = [self]
      until stack.empty?
        node = stack.pop
        yield node
        stack.concat(node.children.reverse)
      end
    end

    # A short, readable form for debugging and error messages.
    def inspect
      return "#{type}(#{text.inspect})" if leaf?
      return "(#{type})" if children.empty?

      "(#{type} #{children.map(&:inspect).join(' ')})"
    end
  end
end
