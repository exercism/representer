module Rosetta::Engine
  # Builds a new node from a template, written in the same syntax as a
  # pattern (see Pattern):
  #
  #   (type child...)   a new node of this type.
  #   field: child      gives the child this field name.
  #   @name             a copy of the node captured as "name". If nothing
  #                     was captured under that name, it is left out.
  #   "text"            an anonymous token, such as "!".
  #
  # For example, this turns `x unless y` into the same tree as a block
  # `unless`:
  #
  #   "(unless condition: @condition consequence: (then @body))"
  class Template
    def initialize(source)
      @root = Pattern.parse(source, template: true)
    end

    def build(captures) = build_element(@root, captures)

    private
    def build_element(element, captures)
      case element
      when Pattern::CaptureReference
        captures[element.name] && Rosetta::Engine.deep_copy(captures[element.name])
      when Pattern::Text
        Node.token(element.value)
      when Pattern::NodePattern
        children = element.sequence.filter_map do |field, child|
          built = build_element(child, captures)
          built&.field = field
          built
        end
        Node.new(element.type, children)
      else
        raise ArgumentError, "Templates can't use #{element.class.name.split('::').last}"
      end
    end
  end

  def self.deep_copy(node)
    copy = node.dup
    copy.children = node.children.map { |child| deep_copy(child) }
    copy
  end
end
