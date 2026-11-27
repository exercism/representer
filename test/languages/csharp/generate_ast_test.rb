require_relative "stage_helper"

# Tests C#'s GenerateAST stage. Each assert_same pair gets the same tree from
# C#'s parser (Roslyn, comparing each token's value and ignoring trivia such
# as comments and spacing), and each refute_same pair gets different trees.
# The last test lists the pairs where this stage deliberately differs from
# the parser.
class CSharpGenerateASTTest < Minitest::Test
  include CSharpStages

  def test_drops_comments_and_layout
    assert_same "int x = 1; // one\n/* two */\n", "int x = 1;"
    assert_same "/// <summary>Doc</summary>\nclass A { }", "class A{}"
  end

  def test_strings_are_their_values
    assert_same 'var x = "\\x41\\u0041\\U00000041";', 'var x = "AAA";'
    assert_same 'var x = "a\\tb";', "var x = \"a\tb\";"
    assert_same 'var x = @"a""b\\n";', 'var x = "a\\"b\\\\n";'
    refute_same 'var x = "a b";', 'var x = "ab";'
    refute_same 'var x = "\\uD83D";', 'var x = @"\\uD83D";'
  end

  def test_numbers_are_their_values
    assert_same "var x = 1_000 + 0x1F + 0b11;", "var x = 1000 + 31 + 3;"
    assert_same "var x = 1.50 + 1e7 + 1.5F;", "var x = 1.5 + 1E7 + 1.5f;"
    refute_same "var x = 1.50m;", "var x = 1.5m;"
    refute_same "var x = 1L;", "var x = 1;"
  end

  def test_a_lambdas_single_parameter_is_a_parameter
    assert_includes ast("Func<int, int> f = x => x;"), "(parameter x)"
  end

  def test_keeps_the_tokens_that_tell_programs_apart
    refute_same "class A { int[] b; }", "class A { int[,] b; }"
    refute_same "record struct R(int X);", "record class R(int X);"
    refute_same "for (;; i++) {}", "for (i++;;) {}"
    refute_same "using var r = G();", "var r = G();"
  end

  # Roslyn keeps brackets that only group, and the old representer's
  # simplifier dropped them, so this stage drops them too. The tree's shape
  # still shows the grouping.
  def test_where_this_stage_differs_from_the_parser
    assert_same "var x = (a + b);", "var x = a + b;"
    refute_same "var x = (a + b) * c;", "var x = a + b * c;"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
