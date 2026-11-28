require_relative "stage_helper"

# Checks D's declarations of which nodes are names and which nodes define
# them (see d/representation.rb), through the engine's renaming.
class DNamesTest < Minitest::Test
  include DStages

  def test_renames_modules_types_and_functions
    source = "module a.b;\nclass C : Object { this(int d) {} }\nstruct E { int f; }\nunion G { int h; }\n" \
             "interface I {}\nenum J { k, l = 2 }\nenum M = 1;\nalias N = int[];\nT o(T)(T p) { return p; }\n" \
             "template Q(R) {}"
    assert_equal %w[C E G I J M N Q R T a b d f h k l o p], renamed(source)
  end

  def test_renames_variables_and_parameters
    source = "void f(int a, ref int[] b) {\n  int c, d = a;\n  auto e = b;\n  foreach (i, g; b) {}\n" \
             "  try {} catch (Exception h) {}\n  if (auto j = a in k) {}\n  auto l = (m, int n) => m + n;\n" \
             "  auto o = p => p;\n  q: goto q;\n}"
    assert_equal %w[a b c d e f g h i j l m n o p q], renamed(source)
  end

  def test_keeps_the_value_of_a_definition
    assert_equal %w[a f], renamed("void f() { int a = b; }")
    assert_equal %w[f x], renamed("void f(int x = y) {}")
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[a f], renamed("void f(int[] a) { writeln(a.map!(to!string).join); }")
  end

  def test_renames_library_names_the_solution_defines
    sums = marks("int sum(int x) { return x; }\nvoid g() { [1].sum; }").select { |text, _| text == "sum" }
    assert_equal [true, true], sums.map(&:last)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], D::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if D::Representation::Spec.name?(node) }
    leaves
  end
end
