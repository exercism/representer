require_relative "stage_helper"

# Checks Java's declarations of which nodes are names and which nodes define
# them (see java/representation.rb), through the engine's renaming.
class JavaNamesTest < Minitest::Test
  include JavaStages

  def test_renames_types_and_type_parameters
    source = "class A<T> { } interface I { } enum E { F } record R(int x) { }"
    assert_equal %w[A E F I R T x], renamed(source)
  end

  def test_renames_methods_and_fields
    assert_equal %w[A count f n], renamed("class A { private int count = 0; int f(int n) { return count + n; } }")
  end

  def test_renames_parameters_and_local_variables
    source = "class A { void m(int a, int... b) { var c = 1; Function<Integer, Integer> d = e -> e; " \
             "BinaryOperator<Integer> f = (g, h) -> g; Function<Integer, Integer> i = (Integer j) -> j; " \
             "try { } catch (Exception k) { } } }"
    assert_equal %w[A a b c d e f g h i j k m], renamed(source)
  end

  def test_renames_the_variables_of_loops_resources_instanceof_and_labels
    source = "class A { void m() { for (int a : xs) { } try (var b = open()) { } if (o instanceof String c) { } " \
             "outer: for (;;) { break outer; } } }"
    assert_equal %w[A a b c m outer], renamed(source)
  end

  def test_renames_every_use_of_a_defined_name
    marks = marks("class A { static int go() { return 1; } int b() { return A.go() + this.go(); } }")
    assert(marks.select { |text, _| %w[A go].include?(text) }.all?(&:last))
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[A m x], renamed("class A { void m() { int x = Math.max(1, 2); System.out.println(String.valueOf(x)); } }")
  end

  def test_renames_library_names_the_solution_defines
    source = "class A { public static void main(String[] args) { } public String toString() { return \"\"; } " \
             "public boolean equals(Object o) { return true; } }"
    assert_equal %w[A args equals main o toString], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], Java::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Java::Representation::Spec.name?(node) }
    leaves
  end
end
