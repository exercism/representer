# REPRESENTER_DSL.md defines the verbs and helpers in this file.
module Representer::Languages::Elixir
  class Normalise < Representer::Engine::Normalise
    # Documentation makes no difference to the solution working, so
    # `@moduledoc`, `@doc` and `@typedoc` go, as in the old representer.
    drop "@moduledoc {{text}}", "@doc {{text}}", "@typedoc {{text}}"

    # A `@spec` describes the function after it, so it moves into that
    # function and stays with it when Reorder sorts the module's body.
    attach_to_next "@spec {{spec}}"

    TYPES = /\A(spec|callback|macrocallback|type|typep|opaque)\z/

    def call
      root = super
      call_after_pipe(root)
      types_without_brackets(root)
      root
    end

    private
    # Elixir's parser reads the `f` in `a |> f` as a variable, but a pipe
    # always calls it, so `a |> f` gets the tree of `a |> f()`, as in the old
    # representer.
    def call_after_pipe(root)
      transform(root, '(binary_operator operator: "|>" right: (identifier) @function)') do |match|
        match.node.replace_child(match[:function], build(:call, { target: match[:function] }, build(:arguments)))
        match.node
      end
    end

    # In `@spec`, `@callback`, `@macrocallback`, `@type`, `@typep` and
    # `@opaque`, a type with empty brackets is the same as the type without
    # them, so `integer()` is `integer`, as in the old representer.
    def types_without_brackets(root)
      captured(root, "(unary_operator operand: (call target: (identifier /#{TYPES.source}/) (arguments) @name))").each do |types|
        transform(types, "(call target: (identifier) @type (arguments) @arguments)") do |match|
          match[:type] if match[:arguments].children.empty?
        end
      end
    end
  end
end
