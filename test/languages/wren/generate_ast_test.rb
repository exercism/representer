require_relative "stage_helper"

# Tests Wren's GenerateAST stage. Each assert_same pair has the same meaning
# in Wren, and each refute_same pair has different meanings.
class WrenGenerateASTTest < Minitest::Test
  include WrenStages

  def test_brackets_that_only_group_are_dropped
    assert_same "var a = (1 + 2)", "var a = 1 + 2"
    refute_same "var a = (1 + 2) * 3", "var a = 1 + 2 * 3"
  end

  def test_strings_are_their_values
    assert_same 'var a = """a"""', 'var a = "a"'
    assert_same 'var a = "\\u0041"', 'var a = "A"'
    refute_same 'var a = "a"', 'var a = "b"'
    refute_same 'var a = "\\x41"', 'var a = "x41"'
  end

  def test_interpolations_stay_in_their_string
    assert_same 'var a = "a\\n%(b)"', "var a = \"a\n%(b)\""
    refute_same 'var a = "%(b)"', 'var a = "%(c)"'
    refute_same 'var a = "a%(b)"', 'var a = "%(b)a"'
  end

  def test_numbers_are_their_values
    assert_same "var x = 1.0 + 0x1F + 1.50 + 1e3", "var x = 1 + 31 + 1.5 + 1000"
    refute_same "var x = 1.5", "var x = 1.25"
  end

  def test_a_getter_and_a_method_stay_apart
    refute_same in_class("foo { 1 }"), in_class("foo() { 1 }")
    refute_same "var a = b.foo", "var a = b.foo()"
  end

  def test_a_setters_parameter_is_in_a_parameter_list
    assert_includes ast(in_class("foo=(v) { v }")), "(parameter_list v)"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
