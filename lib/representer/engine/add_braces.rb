module Representer::Engine
  # Puts braces around a body that has none, for a Normalise stage's
  # `add_braces_to` verb, so `if (a) return 1;` becomes
  # `if (a) { return 1; }`.
  #
  # The verb writes the pattern's `{{body}}` as empty braces, such as
  # `if ({{...}}) { }`. From that pattern, this command learns the type of
  # the statement, the field of its body and the type of a block. If the
  # pattern has other empty braces, they must come before `{{body}}`, as
  # in `if ({{...}}) { } else {{body}}`. It then
  # wraps the body of every such statement in a block, unless the body
  # already is one.
  #
  # Some grammars read empty braces as something else, such as Wren's
  # empty map. The verb then gives the block's type, and keeps `{{body}}`
  # in the pattern, so this command learns the body's field from it.
  class AddBraces
    include Mandate
    include TreeHelpers

    initialize_with :tree, :braced, block: nil

    def call
      field, type = block ? [braced.field_holding("body"), block.to_s] : braced.last_empty_child
      raise ArgumentError, "#{braced.code.inspect} needs {{body}} where the braces go" unless field

      each_node(tree) do |node, _|
        next unless node.type == braced.type

        body = node[field]
        node.replace_child(body, build(type, copy(body).tap { |statement| statement.field = nil })) if body && body.type != type
      end
      tree
    end
  end
end
