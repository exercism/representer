require_relative "stage_helper"

# Tests GDScript's representation Normalise stage, which removes code that
# makes no difference to a passing solution.
class GDScriptNormaliseTest < Minitest::Test
  include GDScriptStages

  def test_writes_symbol_operators_as_words
    assert_same "var x = a && b || !a", "var x = a and b or not a"
    refute_same "var x = a && b", "var x = a || b"
  end

  def test_drops_docstrings
    assert_same "\"\"\"Doc.\"\"\"\nfunc f(a):\n\t\"\"\"Doc.\"\"\"\n\t'text'\n\treturn a\n", "func f(a):\n\treturn a\n"
    refute_same "func f():\n\treturn 'a'", "func f():\n\treturn 'b'"
  end

  def test_drops_type_hints
    assert_same "var g: int = 1\nconst K := 2\nfunc f(a: int, b := 1, c: int = 2) -> int:\n" \
                "\tfor i: int in [a]:\n\t\tpass\n\treturn b\n",
      "var g = 1\nconst K = 2\nfunc f(a, b = 1, c = 2):\n\tfor i in [a]:\n\t\tpass\n\treturn b\n"
    assert_same "var f = func(p: int) -> int: return p\n", "var f = func(p): return p\n"
    assert_same "static var x: Array[int]\n", "static var x\n"
  end

  def test_keeps_other_types
    refute_same "extends Node\n", "extends Node2D\n"
    refute_same "func f(a):\n\treturn a as int\n", "func f(a):\n\treturn a as float\n"
  end

  private
  def tree(source) = write(prepare(source))
  def assert_same(first, second) = assert_equal(tree(first), tree(second))
  def refute_same(first, second) = refute_equal(tree(first), tree(second))
end
