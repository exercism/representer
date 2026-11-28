require_relative "stage_helper"

# Checks Wren's declarations of which nodes are names and which nodes define
# them (see wren/representation.rb), through the engine's renaming.
class WrenNamesTest < Minitest::Test
  include WrenStages

  def test_renames_classes_and_methods
    source = "class A {\nconstruct make(a) {}\nfoo { 1 }\nbar(b) { 2 }\nbaz=(c) { 3 }\n}\n"
    assert_equal %w[A a bar baz b c foo make].sort, renamed(source)
  end

  def test_renames_variables_and_parameters
    source = "var a = 1\nfor (b in 1..3) {}\nvar f = Fn.new {|c| c }\nclass C {\n+(d) { d }\n[e] { e }\n}\n"
    assert_equal %w[C a b c d e f].sort, renamed(source)
  end

  def test_renames_fields
    assert_equal %w[C __b _a foo].sort, renamed(in_class("foo {\n_a = 1\n__b = 2\n}"))
  end

  def test_renames_methods_where_they_are_called
    marks = marks("class A {\nfoo { 1 }\n}\nvar a = A.new().foo\n")
    assert(marks.select { |text, _| text == "foo" }.all?(&:last))
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[a x], renamed("var a = b.map {|x| x }.count\nSystem.print(a)")
  end

  def test_renames_library_names_the_solution_defines
    assert_equal %w[C new toString], renamed(in_class("construct new() {}\ntoString { \"a\" }"))
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], Wren::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Wren::Representation::Spec.name?(node) }
    leaves
  end
end
