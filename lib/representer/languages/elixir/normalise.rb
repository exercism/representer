# REPRESENTER_DSL.md defines the verbs and helpers in this file.
module Representer::Languages::Elixir
  class Normalise < Representer::Engine::Normalise
    # Drop documentation, as the old representer did.
    # @moduledoc "..." @doc "..." @typedoc "..."
    drop "@moduledoc {{text}}", "@doc {{text}}", "@typedoc {{text}}"

    # Attach each `@spec` and `@impl` to the function after it, so that it stays
    # with that function when Reorder sorts the module's body.
    #
    # e.g. We convert:
    # @spec area(integer) :: integer
    # def area(x) do
    #
    # internally into:
    # def area(x) do (@spec area(integer) :: integer)
    attach_to_next "@spec {{spec}}", "@impl {{value}}"

    TYPES = /\A(spec|callback|macrocallback|type|typep|opaque)\z/

    def call
      root = super
      call_after_pipe(root)
      types_without_brackets(root)
      root
    end

    private
    # Add empty brackets to the function after a pipe, because a pipe always
    # calls it, as in the old representer.
    # a |> f == a |> f()
    def call_after_pipe(root)
      transform(root, '(binary_operator operator: "|>" right: (identifier) @function)') do |match|
        match.node.replace_child(match[:function], build(:call, { target: match[:function] }, build(:arguments)))
        match.node
      end
    end

    # Drop empty brackets from types in `@spec`, `@callback`, `@macrocallback`,
    # `@type`, `@typep` and `@opaque`, as in the old representer.
    # integer() == integer
    def types_without_brackets(root)
      captured(root, "(unary_operator operand: (call target: (identifier /#{TYPES.source}/) (arguments) @name))").each do |types|
        transform(types, "(call target: (identifier) @type (arguments) @arguments)") do |match|
          match[:type] if match[:arguments].children.empty?
        end
      end
    end
  end
end
