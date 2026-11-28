require "test_helper"

class YAMLScriptTest < InspectorTest
  track "yamlscript"

  def test_comments_and_layout_are_ignored
    assert_same_representation "!YS-v0\n# Says hello.\ndefn f(): 1 # one\n", "!YS-v0\ndefn f():\n  1\n"
  end

  def test_imports_are_dropped
    assert_same_representation "!YS-v0\nuse: clojure.string\ndefn f(x): x\n", "!YS-v0\ndefn f(x): x\n"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "!YS-v0\ndefn leap-year(year):\n  (year % 4) == 0\n",
                               "!YS-v0\ndefn leap(y):\n  (y % 4) == 0\n"
  end

  def test_names_from_outside_are_kept
    refute_same_representation "!YS-v0\ndefn f(xs): sum(xs)\n", "!YS-v0\ndefn f(xs): count(xs)\n"
  end

  def test_things_that_must_stay_apart
    refute_same_representation "!YS-v0\ndefn f(x): x + 1\n", "!YS-v0\ndefn f(x): x - 1\n"
    refute_same_representation "!YS-v0\ndefn f(a b): a - b\n", "!YS-v0\ndefn f(a b): b - a\n"
    refute_same_representation "!YS-v0\ndefn- f(x): x\n", "!YS-v0\ndefn f(x): x\n"
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "!YS-v0\ndefn f(x): (x\n"
  end
end
