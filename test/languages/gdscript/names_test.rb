require_relative "stage_helper"

# Checks GDScript's declarations of which nodes are names and which nodes
# define them (see gdscript/representation.rb), through the engine's renaming.
class GDScriptNamesTest < Minitest::Test
  include GDScriptStages

  def test_renames_functions_and_every_kind_of_parameter
    source = "func f(a, b: int, c = 1, d := 2, e: int = 3):\n\tvar g = func(h): return h\n\tvar i = func j(k): return k\n"
    assert_equal %w[a b c d e f g h i j k], renamed(source)
  end

  def test_renames_script_level_names
    source = "class_name A\nconst B = 5\nvar c = 0\nsignal d(e)\nenum F { G, H = 2 }\nclass I:\n\tvar j = 1\n"
    assert_equal %w[A B F G H I c d e j], renamed(source)
  end

  def test_renames_the_variables_of_loops
    assert_equal %w[a f i], renamed("func f(a):\n\tfor i in a:\n\t\tpass\n")
  end

  def test_renames_every_use_of_a_defined_name
    marks = marks("var size = 1\nfunc f():\n\treturn self.size + size")
    assert(marks.select { |text, _| text == "size" }.all?(&:last))
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[f x], renamed("func f(x):\n\treturn str(x.size) + Node.new().name + self.y")
  end

  def test_keeps_the_default_of_a_parameter
    assert_equal %w[a f], renamed("func f(a = PI):\n\treturn a")
  end

  def test_keeps_the_names_that_match_patterns_bind
    assert_equal %w[f x], renamed("func f(x):\n\tmatch x:\n\t\tvar y:\n\t\t\treturn y\n")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], GDScript::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if GDScript::Representation::Spec.name?(node) }
    leaves
  end
end
