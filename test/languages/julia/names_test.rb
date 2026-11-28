require_relative "stage_helper"

# Checks Julia's declarations of which nodes are names and which nodes define
# them (see julia/representation.rb), through the engine's renaming.
class JuliaNamesTest < Minitest::Test
  include JuliaStages

  def test_renames_functions_macros_and_modules
    source = "module A\nfunction b(c) c end\nd(e) = e\nf(g)::Int = g\nh(i::T) where T = i\nmacro j(k) k end\nend"
    assert_equal %w[A T b c d e f g h i j k], renamed(source)
  end

  def test_renames_parameters
    source = "function f(a, b::Int, c = 1, d::Int = 2, e...; g = 3, h::Int = 4, i...) a end"
    assert_equal %w[a b c d e f g h i], renamed(source)
  end

  def test_renames_types_type_parameters_and_fields
    source = "abstract type A end\nstruct B{T <: Real} <: A\nc::T\nd\nend\nmutable struct E end\n" \
             "primitive type F 8 end\ng(x::S) where {S <: Number} = x"
    assert_equal %w[A B E F S T c d g x], renamed(source)
  end

  def test_renames_variables
    source = "a = 1\nb, c = 1, 2\n(d, e...) = f\ng::Int = 1\na += 1\nfor (h, i) in f end\n[j for j in f]\n" \
             "let k = 1, l\nend\nlocal m\nglobal n\ntry\ncatch o\nend"
    assert_equal %w[a b c d e g h i j k l m n o], renamed(source)
  end

  def test_renames_the_parameters_of_anonymous_functions
    source = "map(a -> a, xs)\nmap((b, c) -> b, xs)\nmap(xs) do d\nd\nend\nf = function (e) e end"
    assert_equal %w[a b c d e f], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[a], renamed("a = sort(xs, by = length, rev = true)")
    assert_equal %w[a], renamed("a = Base.show(io, x)")
    assert_equal %w[a], renamed("a = zeros(Int, 3)")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], Julia::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Julia::Representation::Spec.name?(node) }
    leaves
  end
end
