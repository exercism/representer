require_relative "stage_helper"

# Checks Kotlin's declarations of which nodes are names and which nodes define
# them (see kotlin/representation.rb), through the engine's renaming.
class KotlinNamesTest < Minitest::Test
  include KotlinStages

  def test_renames_types_and_functions
    source = "class A<T>(val b: T) { companion object C {} }\nobject D\ninterface E\ntypealias F = Int\n" \
             "enum class G { H }\nfun i(j: Int) = j"
    assert_equal %w[A C D E F G H T b i j], renamed(source)
  end

  def test_renames_variables_parameters_and_labels
    source = "fun f() {\nval a = 1\nfor ((b, c) in d) {}\nval e = d.map { g -> g }\n" \
             "try {} catch (h: Exception) {}\nval i = fun(j: Int) = j\nk@ while (true) break@k\n}\n" \
             "var l = 0\n  set(m) { field = m }"
    assert_equal %w[a b c e f g h i j k l m], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[a], renamed("val a = listOf(1).map { it * 2 }.sum()")
    assert_equal %w[b], renamed("val (_, b) = Pair(1, 2)")
  end

  def test_renames_soft_keywords_the_solution_defines
    assert_equal %w[C value x], renamed("class C(val value: Int)\nval x = C(1).value")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], Kotlin::Representation)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Kotlin::Representation.name?(node) }
    leaves
  end
end
