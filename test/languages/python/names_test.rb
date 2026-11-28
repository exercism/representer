require_relative "stage_helper"

# Checks Python's declarations of which nodes are names and which nodes define
# them (see python/representation.rb), through the engine's renaming.
class PythonNamesTest < Minitest::Test
  include PythonStages

  def test_renames_functions_classes_and_every_kind_of_parameter
    source = "class A:\n    def f(self, a, b=1, *c, d: int = 2, **e):\n        g = lambda h, i=1: h\n"
    assert_equal %w[A a b c d e f g h i self], renamed(source)
  end

  def test_renames_the_names_that_are_assigned_to
    source = "a = 1\nb += 1\nc, (d, *e) = x\n[f, g] = x\nglobal h\nif (i := 1):\n    pass\nj: int = 1"
    assert_equal %w[a b c d e f g h i j], renamed(source)
  end

  def test_renames_the_variables_of_loops_comprehensions_with_and_except
    source = "for a in x:\n    pass\ny = [b for b in x]\nwith open(f) as c:\n    pass\ntry:\n    pass\nexcept E as d:\n    pass"
    assert_equal %w[a b c d y], renamed(source)
  end

  def test_renames_the_attributes_that_are_assigned_to
    assert_equal %w[a b c d], renamed("self.a = 1\nx.b += 1\nself.c, self.d = 1, 2\nprint(self.e)")
  end

  def test_renames_keyword_arguments
    assert_equal ["key"], renamed("sorted(xs, key=len)")
  end

  def test_renames_every_use_of_a_defined_name
    marks = marks("def count(xs):\n    return xs.count(1)\nf = count")
    assert(marks.select { |text, _| text == "count" }.all?(&:last))
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal ["x"], renamed("x = math.floor(len(ys))\nprint(x.real)")
  end

  def test_keeps_the_names_that_case_patterns_capture
    assert_equal ["y"], renamed("match x:\n    case [a, *rest] as b:\n        y = 1")
  end

  def test_renames_library_names_the_solution_defines
    assert_equal %w[__init__ exit list self sum], renamed("def exit(self): pass\ndef __init__(self): pass\nsum = list = 0")
  end

  def test_keeps_the_name_given_to_an_import
    assert_equal ["x"], renamed("import numpy as np\nx = np.pi")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], Python::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Python::Representation::Spec.name?(node) }
    leaves
  end
end
