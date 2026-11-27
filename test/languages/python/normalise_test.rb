require_relative "stage_helper"

# Tests Python's representation Normalise stage, which removes code that
# makes no difference to a passing solution.
class PythonNormaliseTest < Minitest::Test
  include PythonStages

  def test_drops_main_guards
    assert_same "x = 1", "x = 1\nif __name__ == '__main__':\n    f(x)"
    refute_same "x = 1", "x = 1\nif __name__ == 'other':\n    pass"
  end

  def test_drops_print_statements
    assert_same "def f(a):\n    return a", "def f(a):\n    print(a)\n    return a"
    refute_same "x = f(a)", "x = print(a)"
  end

  def test_drops_docstrings
    assert_same "def f(a):\n    return a", "def f(a):\n    '''Docs.'''\n    return a"
    assert_same "class A:\n    x = 1", "class A:\n    \"Docs\"\n    x = 1"
    assert_same "x = 1", "\"\"\"Module docs\"\"\"\nx = 1"
    refute_same "def f():\n    return 'a'", "def f():\n    return 'b'"
    refute_same "def f():\n    x = 1", "def f():\n    x = 1\n    'Not docs'"
  end

  def test_writes_empty_bodies_as_pass
    assert_same "def f():\n    pass", "def f():\n    '''Docs.'''"
    assert_same "def f():\n    pass", "def f():\n    print(1)"
    refute_same "def f():\n    pass", "def f():\n    ..."
  end

  def test_drops_type_hints
    assert_same "def f(a, b=1, *c, **d):\n    x = 1", "def f(a: int, b: int = 1, *c: str, **d: str) -> None:\n    x: int = 1"
    assert_same "class A:\n    x = None", "class A:\n    x: int"
    assert_same "async def f(a):\n    pass", "async def f(a: int) -> int:\n    pass"
  end

  private
  def tree(source) = write(prepare(source))
  def assert_same(first, second) = assert_equal(tree(first), tree(second))
  def refute_same(first, second) = refute_equal(tree(first), tree(second))
end
