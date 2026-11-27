require_relative "stage_helper"

# Tests Zig's GenerateAST stage. Each assert_same pair has the same meaning
# in Zig, and each refute_same pair has different meanings.
class ZigGenerateASTTest < Minitest::Test
  include ZigStages

  def test_trailing_commas_and_layout_make_no_difference
    assert_same "const a = [_]u8{ 1, 2, 3, };", "const a = [_]u8{\n    1,\n    2,\n    3\n};"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same in_function("return (x + 1);"), in_function("return x + 1;")
    refute_same in_function("return (x + 1) * 2;"), in_function("return x + 1 * 2;")
  end

  def test_numbers_are_their_values
    assert_same in_function("return 1_000 + 0x1F + 0o17 + x;"), in_function("return 1000 + 31 + 15 + x;")
    assert_same in_function("return @intFromFloat(1.50);"), in_function("return @intFromFloat(1.5);")
    refute_same in_function("return 1000;"), in_function("return 100;")
    refute_same in_function("return 1.0;"), in_function("return 1;")
  end

  def test_strings_are_their_values
    assert_same in_function('_ = "a\\nb";'), in_function('_ = "a\\x0Ab";')
    assert_same in_function('_ = "\\u{41}";'), in_function('_ = "A";')
    refute_same in_function('_ = "a";'), in_function('_ = "b";')
    refute_same in_function("_ = 'a';"), in_function("_ = 'b';")
  end

  def test_a_byte_escape_stays_apart_from_its_text
    refute_same in_function('_ = "\\xff";'), in_function('_ = "\\\\xff";')
  end

  def test_keywords_that_change_a_statement_stay
    refute_same in_function("defer f();"), in_function("f();")
    refute_same "export fn f() void {}", "fn f() void {}"
    refute_same "fn f() void {}", "pub fn f() void {}"
    refute_same in_function("const a = x;"), in_function("var a = x;")
  end

  def test_the_discard_has_its_own_type
    types = []
    generate_ast(in_function("_ = x;")).each_descendant { |node| types << node.type if node.text == "_" }
    assert_equal ["discard"], types
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
