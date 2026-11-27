require_relative "stage_helper"

# Tests Roc's GenerateAST stage. Each assert_same pair gets the same tree
# from the Roc compiler's parser, and each refute_same pair gets different
# trees.
class RocGenerateASTTest < Minitest::Test
  include RocStages

  def test_layout_makes_no_difference
    assert_same "x = f(\n  a,\n  b,\n)", "x = f(a, b)"
    assert_same "x = [1,2,3]", "x = [\n  1,\n  2,\n  3,\n]"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "x = f((a))", "x = f(a)"
    assert_same "x = (a * b)", "x = a * b"
    refute_same "x = (a + b) * c", "x = a + b * c"
    refute_same "x = (-a) ^ 2", "x = -a ^ 2"
  end

  def test_numbers_are_their_values
    assert_same "x = 0x1F + 1_000", "x = 31 + 1000"
    assert_same "x = 1.50", "x = 1.5"
    assert_same "x = (-5)", "x = -5"
    refute_same "x = 1", "x = 1.0"
    refute_same "x = 5", "x = 5.U8"
  end

  def test_strings_are_their_values
    assert_same 'x = "say \"hi\""', "x = \"say \\\"hi\\\"\""
    assert_same 'x = "\u(41)"', 'x = "A"'
    assert_same 'x = "a ${b}"', 'x = "a ${b}"'
    refute_same 'x = "a ${b}"', 'x = "a b"'
    refute_same 'x = "a"', "x = 'a'"
    refute_same 'x = "a"', 'x = "A"'
  end

  def test_multiline_strings_join_their_lines
    assert_same "x =\n    \\\\one\n    \\\\two\n", "x =\n  \\\\one\n  \\\\two\n"
    refute_same "x =\n    \\\\one\n    \\\\two\n", "x =\n    \\\\one two\n"
    refute_same "x =\n    \\\\one\n", 'x = "one"'
  end

  def test_tags_keep_their_names
    refute_same "Color : [Red, Green(U8)]", "Color : [Red, Blue(U8)]"
  end

  def test_code_that_changes_the_meaning_stays
    refute_same "f : U64 -> U64", "f : U64 => U64"
    refute_same "x = a and b", "x = a or b"
    refute_same "x = f(a)?", "x = f(a)"
    refute_same "Point :: { x : U64 }", "Point := { x : U64 }"
  end

  private
  def ast(source) = write(generate_ast(source))

  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
