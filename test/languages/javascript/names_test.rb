require_relative "stage_helper"

# Checks JavaScript's declarations of which nodes are names and which nodes
# define them (see javascript/representation.rb), through the engine's
# renaming.
class JavaScriptNamesTest < Minitest::Test
  include JavaScriptStages

  def test_renames_functions_and_classes
    source = "function a() {}\nfunction* b() {}\nconst c = function d() {}\nconst e = function* f() {}\n" \
             "class G {}\nconst h = class I {}"
    assert_equal %w[G I a b c d e f h], renamed(source)
  end

  def test_renames_methods_fields_and_properties_set_on_this
    source = "class A { #b = 1; static c; d() { this.e = this.#b; } }"
    assert_equal ["#b", "A", "c", "d", "e"], renamed(source)
  end

  def test_renames_variables_and_parameters
    source = "function f(a, b = 1, ...c) { const [d, ...e] = c; const { g, h: i, j = 2 } = a; k = 3; " \
             "return [1].map(l => l).map((m) => m); }"
    assert_equal %w[a b c d e f g i j k l m], renamed(source)
  end

  def test_renames_the_variables_of_loops_and_catch_and_labels
    assert_equal %w[a b c d], renamed("a: for (const b of xs) { for (const [c] of b) { try {} catch (d) { break a; } } }")
  end

  def test_renames_every_use_of_a_defined_name
    marks = marks("const count = 1\nconst o = { count }\nconst p = o.count\nconst q = { count: 2 }")
    assert(marks.select { |text, _| text == "count" }.all?(&:last))
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal ["x"], renamed("const x = Math.max(1, 2)\nconsole.log(x.toString())")
  end

  def test_renames_library_names_the_solution_defines
    assert_equal %w[A constructor max toString], renamed("class A { constructor() {} toString() {} }\nfunction max() {}")
  end

  def test_keeps_imported_names
    assert_equal ["x"], renamed("import { order } from './grocer'\nconst x = order()")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], JavaScript::Representation)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if JavaScript::Representation.name?(node) }
    leaves
  end
end
