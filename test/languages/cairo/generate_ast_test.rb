require_relative "stage_helper"

# Tests Cairo's GenerateAST stage, which gives one tree to code that differs
# only in comments, layout, brackets that only group and the spelling of
# numbers.
class CairoGenerateASTTest < Minitest::Test
  include CairoStages

  def test_drops_comments_and_layout
    assert_same "// c\nfn f() -> u32 {\n    1 // x\n}\n", "fn f() -> u32 { 1 }"
    assert_same "/// Docs.\nfn f() {}", "fn f(){}"
  end

  def test_drops_empty_statements
    assert_same wrap("let c = 1;;\nc"), wrap("let c = 1;\nc")
  end

  def test_a_final_expression_is_not_a_statement
    refute_same wrap("a"), wrap("a;")
  end

  def test_keeps_the_semicolons_in_a_macro
    refute_same wrap("let v = array![0; 5];\na"), wrap("let v = array![0, 5];\na")
  end

  def test_unwraps_brackets_that_only_group
    assert_same wrap("(a + b)"), wrap("a + b")
    refute_same wrap("(a + b) * a"), wrap("a + b * a")
  end

  def test_numbers_are_their_values
    assert_same wrap("a + 1_000 + 0x1F"), wrap("a + 1000 + 31")
    assert_same wrap("a + 1_000_u32 + 0x1F_u8"), wrap("a + 1000_u32 + 31_u8")
    refute_same wrap("a + 10_u8"), wrap("a + 10")
    refute_same wrap("a + 1000"), wrap("a + 100")
  end

  def test_strings_keep_their_text
    refute_same wrap("let s = \"a\"; a"), wrap("let s = \"b\"; a")
    refute_same wrap("let s = 'a'; a"), wrap("let s = \"a\"; a")
  end

  def test_writes_capitalised_names_in_patterns_as_paths
    assert_includes ast(wrap("match x { None => 0, Some(y) => y }")), "(path None)"
    assert_includes ast(wrap("match x { None => 0, Some(y) => y }")), "(path Some) y"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
