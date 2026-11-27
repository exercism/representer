require_relative "stage_helper"

# Tests Java's GenerateAST stage. Each assert_same pair gets the same tree from
# Java's parser (javac, comparing each token's value and ignoring comments and
# spacing), and each refute_same pair gets different trees. The last test
# lists the pairs where this stage deliberately differs from the parser.
class JavaGenerateASTTest < Minitest::Test
  include JavaStages

  def test_drops_comments_and_layout
    assert_same "class A { int x = 1; // one\n/* two */\n}", "class A{int x=1;}"
    assert_same "/** Docs. */\nclass A { }", "class A{}"
  end

  def test_strings_are_their_values
    assert_same 'class A { String s = "a\\u0041\\101\\n"; }', 'class A { String s = "aAA\\n"; }'
    assert_same 'class A { String s = "a\\tb"; }', "class A { String s = \"a\tb\"; }"
    refute_same 'class A { String s = "a b"; }', 'class A { String s = "ab"; }'
    refute_same 'class A { String s = "\\uD83D"; }', 'class A { String s = "\\\\uD83D"; }'
  end

  def test_numbers_are_their_values
    assert_same "class A { long x = 1_000 + 0x1F + 0b11 + 017; }", "class A { long x = 1000 + 31 + 3 + 15; }"
    assert_same "class A { long x = 1_000L + 0x10l; }", "class A { long x = 1000L + 16L; }"
    assert_same "class A { double x = 1.50 + 1.5e3F + 2D; }", "class A { double x = 1.5 + 1500.0f + 2.0d; }"
    refute_same "class A { long x = 1L; }", "class A { long x = 1; }"
    refute_same "class A { double x = 1.0; }", "class A { double x = 1; }"
  end

  def test_a_lambdas_single_parameter_needs_no_brackets
    assert_same "class A { void f() { g((x) -> x); } }", "class A { void f() { g(x -> x); } }"
    refute_same "class A { void f() { g((int x) -> x); } }", "class A { void f() { g(x -> x); } }"
  end

  def test_each_variable_is_a_declaration_of_its_own
    assert_same "class A { int a, b; void f() { int c = 1, d = 2; } }",
      "class A { int a; int b; void f() { int c = 1; int d = 2; } }"
  end

  def test_drops_the_empty_semicolon_after_enum_constants
    assert_same "enum E { X, Y; }", "enum E { X, Y }"
    refute_same "enum E { X; int f() { return 1; } }", "enum E { X }"
  end

  # These brackets and semicolons are the only difference between each pair.
  def test_keeps_the_tokens_that_tell_programs_apart
    refute_same "class A { int[] a; }", "class A { int[][] a; }"
    refute_same "class A { void f(int i) { for (;; i++) {} } }", "class A { void f(int i) { for (i++;;) {} } }"
  end

  # javac keeps brackets that only group, and the representation has never
  # kept them, so this stage drops them too. The tree's shape still shows the
  # grouping.
  def test_where_this_stage_differs_from_the_parser
    assert_same "class A { int x = (a * 2) + 1; }", "class A { int x = a * 2 + 1; }"
    refute_same "class A { int x = a * (2 + 1); }", "class A { int x = a * 2 + 1; }"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
