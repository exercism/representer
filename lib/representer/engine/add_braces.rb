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
  class AddBraces
    include Mandate
    include TreeHelpers

    initialize_with :tree, :braced

    def call
      field, block = braced.last_empty_child
      raise ArgumentError, "#{braced.code.inspect} needs {{body}} where the braces go" unless field

      each_node(tree) do |node, _|
        next unless node.type == braced.type

        body = node[field]
        node.replace_child(body, build(block, body)) if body && body.type != block
      end
      tree
    end
  end
end
