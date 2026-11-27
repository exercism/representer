# The website shows the first lines of each solution on its card. This file
# says what to leave out of an Elixir solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer::Languages::Elixir
  class Snippet < Representer::Engine::Snippet
    # Remove every comment and docstring, wherever they are.
    remove :comments,   # x = 1 «# The answer»
           :docstrings  # «@doc "Says hello."»

    # Treat `@moduledoc`, `@doc` and `@typedoc` as docstrings.
    docstrings_are do |node, _parent|
      operand = node["operand"] if node.type == "unary_operator" && node.children.first&.type == "@"
      operand&.type == "call" && %w[moduledoc doc typedoc].include?(operand["target"]&.text)
    end
  end
end
