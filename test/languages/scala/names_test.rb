require_relative "stage_helper"

# Checks Scala's declarations of which nodes are names and which nodes define
# them (see scala/representation.rb), through the engine's renaming.
class ScalaNamesTest < Minitest::Test
  include ScalaStages

  def test_renames_types_and_methods
    source = "object A\ncase class B[C](d: Int)\ntrait E[+F, -G]\nenum H { case I, J }\ntype K = Int\n" \
             "abstract class L { def m: Int; def n(o: Int) = o }\ngiven p: Ordering[Int] = Ordering.Int"
    assert_equal %w[A B C E F G H I J K L d m n o p], renamed(source)
  end

  def test_renames_values_variables_and_parameters
    source = "object A {\n  val b = 1\n  var c, d = 0\n  val e: Int\n  def f(g: Int) = xs.foldLeft(0)((h, i) => h + i)\n" \
             "  val j = xs.map(k => k)\n}"
    assert_equal %w[A b c d e f g h i j k], renamed(source)
  end

  def test_renames_the_variables_bound_by_patterns
    source = "object A {\n  val (b, c) = (1, 2)\n  for ((d, e) <- xs; f = d) yield e\n" \
             "  xs match {\n    case Some(g) :: h => g\n    case i: Int => i\n    case j @ List(_) => j\n  }\n}"
    assert_equal %w[A b c d e f g h i j], renamed(source)
  end

  # In a pattern, a name that starts with a capital letter, or is in
  # backticks, refers to a value that already exists.
  def test_keeps_the_names_patterns_refer_to
    source = "object A {\n  def f(x: Option[Int], y: Int) = x match {\n    case None => 0\n    case Some(`y`) => 1\n" \
             "    case Some(Max) => 2\n  }\n}"
    assert_equal %w[A f x y], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[A a], renamed("object A { val a = List(1).map(_ * 2).sum.toString }")
  end

  def test_renames_library_names_the_solution_defines
    sums = marks("object A { def sum(x: Int) = x\n  def g = List(1).sum }").select { |text, _| text == "sum" }
    assert_equal [true, true], sums.map(&:last)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], Scala::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Scala::Representation::Spec.name?(node) }
    leaves
  end
end
