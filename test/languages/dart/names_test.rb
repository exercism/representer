require_relative "stage_helper"

# Checks Dart's declarations of which nodes are names and which nodes define
# them (see dart/representation.rb), through the engine's renaming.
class DartNamesTest < Minitest::Test
  include DartStages

  def test_renames_types_and_their_parameters
    source = "class Box<T> {} enum Color { red, green } mixin Walker on Object {} " \
             "extension Doubler on int {} typedef Grid = List<int>;"
    assert_equal %w[Box Color Doubler Grid T Walker green red], renamed(source)
  end

  def test_keeps_the_types_beside_a_definition
    assert_equal %w[Walker], renamed("mixin Walker on Object {}")
    assert_equal %w[f x], renamed("void f(List<int> x) {}")
  end

  def test_renames_methods_constructors_getters_and_setters
    source = "class A { final int x; static const max = 1; A(this.x); A.named() : x = 0; " \
             "factory A.make() => A(1); int get twice => x * 2; set value(int v) {} int area() => x; }"
    assert_equal %w[A area make max named twice v value x], renamed(source)
  end

  def test_renames_variables_and_parameters
    source = "int f(int a, {required int c, int b = 0}) { var d = 1; final e = (g) => g; int h = a; return h; }"
    assert_equal %w[a b c d e f g h], renamed(source)
  end

  def test_renames_the_variables_of_loops_catch_patterns_and_labels
    source = "void f(List<(int, int)> xs) { for (final x in xs) {} for (final (p, q) in xs) {} var (m, n) = (1, 2); " \
             "try {} catch (e, s) {} outer: while (true) { break outer; } switch (xs) { case [int z]: break; } }"
    assert_equal %w[e f m n outer p q s x xs z], renamed(source)
  end

  def test_renames_record_fields_and_the_parameters_of_function_types
    assert_equal %w[f moves], renamed("({int moves}) f() => (moves: 1);")
    assert_equal %w[acc g h], renamed("void g(int Function(int acc) h) {}")
  end

  def test_renames_names_in_interpolations
    assert(marks("void f(int total) { print('$total'); }").select { |text, _| text == "total" }.all?(&:last))
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[f x xs], renamed("int f(List<int> xs) => xs.map((x) => 1).fold(0, max);")
  end

  def test_renames_library_names_the_solution_defines
    assert_equal %w[length s], renamed("int length(String s) => s.length;")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], Dart::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Dart::Representation::Spec.name?(node) }
    leaves
  end
end
