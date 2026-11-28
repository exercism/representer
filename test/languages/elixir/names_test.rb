require_relative "stage_helper"

# Checks Elixir's declarations of which nodes are names and which nodes
# define them (see elixir/spec.rb), through the engine's renaming.
class ElixirNamesTest < Minitest::Test
  include ElixirStages

  def test_renames_modules_functions_and_types
    source = "defmodule A.B do\n  defprotocol P do\n  end\n  @type t :: integer\n  def f, do: 1\n  defp g(x), do: x\n  " \
             "defmacro h(x), do: x\n  defguard i(x) when x > 1\nend"
    assert_equal %w[A B P f g h i t x], renamed(source)
  end

  def test_renames_the_variables_that_patterns_bind
    source = "def f(a, {b, [c | d]}) when a > 1 do\n  e = a\n  {:ok, g} = b\n  for h <- c, do: h\n  fn i -> i end\n  " \
             "case d do\n    j -> j\n  end\nend"
    assert_equal %w[a b c d e f g h i j], renamed(source)
  end

  def test_renames_attributes_that_the_solution_reads
    assert_equal %w[a], renamed("@impl true\n@a 1\n@b 2\ndef f, do: @a").grep_v("f")
  end

  def test_renames_every_use_of_a_defined_name
    marks = marks("defmodule M do\n  def go(x), do: x\nend\nM.go(1)\nEnum.map([], &go/1)")
    assert(marks.select { |text, _| %w[M go].include?(text) }.all?(&:last))
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[x], renamed("x = Enum.map(y, &String.upcase/1)")
    assert_empty renamed("defimpl String.Chars, for: Integer do\nend")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], Elixir::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Elixir::Representation::Spec.name?(node) }
    leaves
  end
end
