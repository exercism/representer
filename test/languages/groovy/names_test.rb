require_relative "stage_helper"

# Checks Groovy's declarations of which nodes are names and which nodes define
# them (see groovy/representation/spec.rb), through the engine's renaming.
class GroovyNamesTest < Minitest::Test
  include GroovyStages

  def test_renames_types_and_methods
    source = "class A<T> extends Exception { static int b(int c) { c } }\ninterface D {}\ntrait E {}\n" \
             "enum F { G, H }\nrecord I(int j) {}"
    assert_equal %w[A D E F G H I T b c j], renamed(source)
  end

  def test_renames_variables_parameters_and_labels
    source = "class A {\ndef b\nprivate int c = 1, d\ndef e(f, int... g) {\ndef h = 1\nint i = 2\n" \
             "def (j, k) = [1, 2]\nfor (l in f) {}\n[1].each { m, n -> m }\n" \
             "try {} catch (Exception o) {}\np: while (true) { break p }\n}\n}"
    assert_equal %w[A b c d e f g h i j k l m n o p], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[a], renamed("def a = [1].collect { it * 2 }.sum()")
    assert_equal %w[a], renamed("def a = [b: 1]")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], Groovy::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Groovy::Representation::Spec.name?(node) }
    leaves
  end
end
