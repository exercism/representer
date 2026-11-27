require "test_helper"

# The old gdscript-representer has five golden tests. Four are ported as
# fixtures: normalize-whitespace, remove-comments, remove-type-hints and
# rename-identifiers. multiple-solution-files is test_multiple_solution_files
# below, because a fixture holds one equivalent file. Each test's
# `.meta/config.json` is not copied, because it only said which files were
# the solution. The tests of each stage are in test/languages/gdscript/.
class GDScriptTest < RepresenterTest
  extend UpstreamTests

  track "gdscript"

  DEVIATIONS = {}.freeze

  upstream_tests ".gd", deviations: DEVIATIONS

  def test_multiple_solution_files
    result = Representer::RepresentSolution.("gdscript",
      { "one.gd" => "func foo():\n\treturn 1\n", "two.gd" => "func bar():\n\treturn \"Hello\"\n" })
    assert_equal %w[bar foo], result.mapping.values.sort
    refute_equal Representer::Languages::Basic, result.representer
  end

  def test_functions_variables_and_parameters_are_renamed
    assert_same_representation "func foo(a, b: int, c = 1, d := 2):\n\tvar e = a\n\treturn e + b + c + d",
      "func bar(w, x: int, y = 1, z := 2):\n\tvar q = w\n\treturn q + x + y + z"
    assert_same_representation "func f(xs):\n\tfor i in xs:\n\t\tprint(i)", "func g(ys):\n\tfor j in ys:\n\t\tprint(j)"
    assert_same_representation "func f():\n\tvar g = func(x): return x + 1\n\treturn g.call(1)",
      "func f():\n\tvar h = func(y): return y + 1\n\treturn h.call(1)"
  end

  def test_script_level_names_are_renamed
    assert_same_representation "const LIMIT = 5\nvar score = 0\nsignal done\nfunc f():\n\tscore += LIMIT",
      "const MAX = 5\nvar total = 0\nsignal finished\nfunc g():\n\ttotal += MAX"
    assert_same_representation "enum Color { RED, GREEN }\nfunc f():\n\treturn Color.RED",
      "enum Hue { COLD, WARM }\nfunc g():\n\treturn Hue.COLD"
    assert_same_representation "class Inner:\n\tvar q = 1\nfunc f():\n\treturn Inner.new().q",
      "class Other:\n\tvar r = 1\nfunc f():\n\treturn Other.new().r"
  end

  def test_members_after_a_dot_follow_the_definitions
    assert_same_representation "var size_x = 1\nfunc f():\n\treturn self.size_x", "var width = 1\nfunc f():\n\treturn self.width"
    refute_same_representation "func f(a):\n\treturn a.size", "func f(a):\n\treturn a.back"
  end

  def test_library_names_are_renamed_if_the_solution_defines_them
    assert_same_representation "func size():\n\treturn 1", "func back():\n\treturn 1"
    assert_same_representation "func _ready():\n\tpass", "func _process():\n\tpass"
    refute_same_representation "func f(a):\n\treturn str(a)", "func f(a):\n\treturn len(a)"
  end

  def test_syntax_errors_get_a_basic_representation
    assert_basic_representation "func f(:\n"
  end
end
