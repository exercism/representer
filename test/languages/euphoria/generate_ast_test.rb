require_relative "stage_helper"

# Tests Euphoria's GenerateAST stage. Each assert_same pair has the same
# meaning in Euphoria, and each refute_same pair has different meanings.
class EuphoriaGenerateASTTest < Minitest::Test
  include EuphoriaStages

  def test_layout_and_trailing_separators_make_no_difference
    assert_same "sequence s = {1,\n  2,\n}\n", "sequence s = {1, 2}\n"
    assert_same "constant A = 1, B = 2, $\n", "constant A = 1, B = 2\n"
    assert_same "enum A, B, $\n", "enum A, B\n"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "x = (a)\n", "x = a\n"
    assert_same "x = (a * b) + c\n", "x = a * b + c\n"
    refute_same "x = a - (b - c)\n", "x = a - b - c\n"
    refute_same "x = (a + b) * c\n", "x = a + b * c\n"
  end

  def test_numbers_are_written_as_their_values
    assert_same "x = #1F\n", "x = 31\n"
    assert_same "x = 0x1F\n", "x = 31\n"
    assert_same "x = 0b101 + 0t17 + 0d9\n", "x = 5 + 15 + 9\n"
    assert_same "x = 1_000\n", "x = 1000\n"
    assert_same "x = .50\n", "x = 0.5\n"
    refute_same "x = 1.0\n", "x = 1\n"
  end

  def test_strings_are_written_as_their_values
    assert_same "x = `a\\d`\n", "x = \"a\\\\d\"\n"
    assert_same "x = \"\"\"ab\"\"\"\n", "x = \"ab\"\n"
    assert_same "x = \"a\\tb\"\n", "x = \"a\tb\"\n"
    assert_same "x = \"a\\\"b\"\n", "x = `a\"b`\n"
    refute_same "x = '\\n'\n", "x = 'n'\n"
    refute_same "x = \"a\\x41\"\n", "x = \"aA\"\n"
    refute_same "x = 'a'\n", "x = \"a\"\n"
    refute_same "x = 'a'\n", "x = 97\n"
  end

  def test_include_paths_are_read_with_or_without_quotes
    assert_same "include \"std/math.e\"\n", "include std/math.e\n"
  end

  def test_left_out_arguments_stay_apart_from_none
    refute_same "x = f(a,,b)\n", "x = f(a,b)\n"
    refute_same "x = f(a,)\n", "x = f(a)\n"
    refute_same "x = f(,a)\n", "x = f(a)\n"
    assert_same "x = f( )\n", "x = f()\n"
  end

  def test_keywords_that_change_the_meaning_stay
    refute_same "while x with entry do\nentry\nend while\n", "while x do\nentry\nend while\n"
    refute_same "switch x with fallthru do\ncase 1 then\nend switch\n", "switch x do\ncase 1 then\nend switch\n"
    refute_same "switch x do\ncase else\nend switch\n", "switch x do\ncase 1 then\nend switch\n"
    refute_same "public function f()\nend function\n", "function f()\nend function\n"
    refute_same "x += 1\n", "x = 1\n"
    refute_same "if a = b then\nend if\n", "if a != b then\nend if\n"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
