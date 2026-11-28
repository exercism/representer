require_relative "stage_helper"

# Tests Arturo's GenerateAST stage. Each assert_same pair has the same
# meaning in Arturo, and each refute_same pair has different meanings.
class ArturoGenerateASTTest < Minitest::Test
  include ArturoStages

  def test_layout_and_commas_make_no_difference
    assert_same "x: [1,\n  2]\n", "x: [1 2]\n"
    assert_same "f: function [a, b][a]\n", "f: function [a b][a]\n"
  end

  def test_brackets_around_one_value_are_dropped
    assert_same "if (x) = 1 [y]\n", "if x = 1 [y]\n"
    refute_same "x: (a + b) * c\n", "x: a + b * c\n"
    refute_same "x: [a]\n", "x: a\n"
  end

  def test_numbers_are_written_as_their_values
    assert_same "x: 0x1F\n", "x: 31\n"
    assert_same "x: 0b101 + 0o17\n", "x: 5 + 15\n"
    assert_same "x: 1.50\n", "x: 1.5\n"
    assert_same "x: 1e3\n", "x: 1000.0\n"
    refute_same "x: 1.0\n", "x: 1\n"
  end

  def test_strings_are_written_as_their_values
    assert_same "x: {ab}\n", "x: \"ab\"\n"
    assert_same "x: \"a\\tb\"\n", "x: \"a\tb\"\n"
    assert_same "x: ~\"|a|\\n\"\n", "x: ~\"|a|\n\"\n"
    refute_same "x: \"a\\d\"\n", "x: \"ad\"\n"
    refute_same "x: {:ab:}\n", "x: \"ab\"\n"
    refute_same "x: {\n  ab\n}\n", "x: \"ab\"\n"
    refute_same "x: 'a'\n", "x: \"a\"\n"
    refute_same "x: '\\n'\n", "x: 'n'\n"
  end

  def test_paths_keep_where_they_start
    refute_same "x: \\a\\b\n", "x: a\\b\n"
    refute_same "x: a\\b\n", "x: a b\n"
  end

  def test_tokens_that_change_the_meaning_stay
    refute_same "f: function [x][x]\n", "f: method [x][x]\n"
    refute_same "x: 'a\n", "x: a\n"
    refute_same "x: #[a: 1]\n", "x: [a: 1]\n"
    refute_same "x: [a b]: 1\n", "x: [a b] 1\n"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
