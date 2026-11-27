require_relative "stage_helper"

# Tests GDScript's GenerateAST stage. Each assert_same pair gets the same
# tree, and each refute_same pair gets different trees.
class GDScriptGenerateASTTest < Minitest::Test
  include GDScriptStages

  def test_drops_comments_and_region_markers
    assert_same "#region R\nfunc f():\n\tpass # done\n#endregion\n", "func f():\n\tpass\n"
  end

  def test_drops_layout
    assert_same "var x = (a + b)", "var x = a + b"
    assert_same "var x = [1, 2,]", "var x = [1,2]"
    assert_same "func f():\n\tprint(a); print(b)", "func f():\n\tprint(a)\n\tprint(b)"
    assert_same "var x = 1 + \\\n\t2", "var x = 1 + 2"
    refute_same "var x = a * (b + c)", "var x = a * b + c"
  end

  def test_numbers_are_their_values
    assert_same "var x = 1_000 + 0x1F + 0b1", "var x = 1000 + 31 + 1"
    assert_same "var x = 1.50", "var x = 1.5"
    refute_same "var x = 1000", "var x = 100"
    refute_same "var x = 1.0", "var x = 1"
  end

  def test_strings_are_their_values
    assert_same "var x = 'a'", 'var x = "a"'
    assert_same "var x = 'it\\'s'", "var x = \"it's\""
    assert_same "var x = 'say \"x\"'", "var x = \"say \\\"x\\\"\""
    refute_same "var x = 'a'", "var x = 'b'"
    refute_same "var x = 'a\\n'", "var x = 'a\\\\n'"
    refute_same "var x = '''a'''", "var x = 'a'"
  end

  def test_node_paths_keep_their_text
    refute_same "var x = $A", "var x = $B"
    refute_same "var x = &\"a\"", "var x = ^\"a\""
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
