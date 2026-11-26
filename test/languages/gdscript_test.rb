require "test_helper"

# The old gdscript-representer has five golden tests. Four are ported as
# fixtures: normalize-whitespace, remove-comments, remove-type-hints and
# rename-identifiers. multiple-solution-files is test_multiple_solution_files
# below, because a fixture holds one equivalent file. Differences from the
# old tests:
#
# - The old representer left script-level variables, constants, classes,
#   enums and signals as they were. This one renames them (see the tests
#   below), but none of the golden tests has one.
# - Each test's `.meta/config.json` is not copied, because it only said which
#   files were the solution.
class GDScriptTest < RepresenterTest
  extend UpstreamTests

  track "gdscript"

  DEVIATIONS = {}.freeze

  upstream_tests ".gd", deviations: DEVIATIONS

  def test_multiple_solution_files
    result = Representer::RepresentSolution.("gdscript",
      { "one.gd" => "func foo():\n\treturn 1\n", "two.gd" => "func bar():\n\treturn \"Hello\"\n" }, {})
    assert_equal %w[bar foo], result.mapping.values.sort
    refute_equal Representer::Languages::Basic, result.representer
  end

  def wrap(body) = "func f(a, b):\n#{body.gsub(/^/, "\t")}\n"

  ### Formatting ###

  def test_comments_and_docstrings_are_dropped
    assert_same_representation "\"\"\"Doc.\"\"\"\n## doc\nfunc f(a):\n\t\"\"\"Doc.\"\"\"\n\t# note\n\t'text'\n\treturn a\n",
      "func f(a):\n\treturn a\n"
    assert_same_representation "#region R\nfunc f():\n\tpass\n#endregion\n", "func f():\n\tpass\n"
  end

  def test_formatting
    assert_same_representation wrap("return (a + b)"), wrap("return a + b")
    assert_same_representation wrap("return [1, 2,]"), wrap("return [1,2]")
    assert_same_representation "func f(a, b):\n\tprint(a); print(b)", "func f(a, b):\n\tprint(a)\n\tprint(b)"
  end

  def test_numbers_with_underscores
    assert_same_representation wrap("return 1_000"), wrap("return 1000")
    refute_same_representation wrap("return 1000"), wrap("return 100")
  end

  def test_strings
    assert_same_representation wrap("return 'a'"), wrap("return \"a\"")
    assert_same_representation wrap("return 'it\\'s'"), wrap("return \"it's\"")
    assert_same_representation wrap("return 'say \"x\"'"), wrap("return \"say \\\"x\\\"\"")
    refute_same_representation wrap("return 'a'"), wrap("return 'b'")
    refute_same_representation wrap("return $A"), wrap("return $B")
  end

  def test_boolean_operators
    assert_same_representation wrap("return a && b || !a"), wrap("return a and b or not a")
    refute_same_representation wrap("return a && b"), wrap("return a || b")
  end

  ### Names ###

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
    refute_same_representation wrap("return a.size"), wrap("return a.back")
  end

  def test_core_names_are_kept
    refute_same_representation "func size():\n\treturn 1", "func back():\n\treturn 1"
    refute_same_representation "func _ready():\n\tpass", "func _process():\n\tpass"
    refute_same_representation wrap("return str(a)"), wrap("return len(a)")
  end

  def test_names_the_tests_use_are_kept
    tests = { "test.gd" => "func test():\n\tassert_eq(solution.two_fer(), 1)" }
    refute_same_representation "func two_fer():\n\treturn 1", "func other():\n\treturn 1", exercise_files: tests
    assert_equal({}, represent("func two_fer():\n\treturn 1", exercise_files: tests).mapping)
  end

  ### Unrepresentable solutions ###

  def test_syntax_errors_are_unrepresentable
    assert_unrepresentable "func f(:\n"
  end

  def test_type_hints_are_dropped_everywhere
    assert_same_representation "var g: int = 1\nconst K := 2\nfunc f(a: int, b := 1, c: int = 2) -> int:\n" \
                               "\tfor i: int in [a]:\n\t\tpass\n\treturn b\n",
      "var g = 1\nconst K = 2\nfunc f(a, b = 1, c = 2):\n\tfor i in [a]:\n\t\tpass\n\treturn b\n"
    assert_same_representation "var f = func(p: int) -> int: return p\n", "var f = func(p): return p\n"
    refute_same_representation "extends Node\n", "extends Node2D\n"
    refute_same_representation "func f(a):\n\treturn a as int\n", "func f(a):\n\treturn a as float\n"
  end

  def test_numbers_are_their_values
    assert_same_representation wrap("return a + 1_000 + 0x1F + 0b1"), wrap("return a + 1000 + 31 + 1")
    assert_same_representation wrap("return a * 1.50"), wrap("return a * 1.5")
    refute_same_representation wrap("return a * 1.0"), wrap("return a * 1")
  end
end
