# Elixir's Normalise stage keeps three rules of the old representer
# (exercism/elixir-representer), and keeps each spec with its function:
#
# - It drops `@moduledoc`, `@doc` and `@typedoc`, because documentation
#   makes no difference to the solution working.
# - Each `@spec` moves into the definition after it, so the two stay
#   together when Reorder sorts the module's body.
# - `a |> f` gets the tree of `a |> f()`. Elixir's parser reads the first
#   `f` as a variable, but a pipe always calls it.
# - In `@spec`, `@callback`, `@macrocallback`, `@type`, `@typep` and
#   `@opaque`, a type with empty brackets gets the tree of the type without
#   them, so `integer()` is `integer`.
#
# Update this list whenever the class changes.
module Representer
  module Languages
    module Elixir
      class Normalise < Engine::Normalise
        drop "@moduledoc {{text}}", "@doc {{text}}", "@typedoc {{text}}"
        attach_to_next "@spec {{spec}}"

        TYPES = /\A(spec|callback|macrocallback|type|typep|opaque)\z/

        def call
          root = super
          transform(root, '(binary_operator operator: "|>" right: (identifier) @function)') do |match|
            match.node.replace_child(match[:function], build(:call, { target: match[:function] }, build(:arguments)))
            match.node
          end
          captured(root, "(unary_operator operand: (call target: (identifier /#{TYPES.source}/) (arguments) @name))").each do |types|
            transform(types, "(call target: (identifier) @type (arguments) @arguments)") do |match|
              match[:type] if match[:arguments].children.empty?
            end
          end
          root
        end
      end
    end
  end
end
