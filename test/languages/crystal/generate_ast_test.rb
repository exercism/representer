require_relative "stage_helper"

# Tests Crystal's GenerateAST stage. Each assert_same pair is code that
# Crystal's parser reads as the same tree, and each refute_same pair is code
# that it reads as different trees. The last test lists the pairs where this
# stage deliberately differs from the parser.
class CrystalGenerateASTTest < Minitest::Test
  include CrystalStages

  def test_drops_comments_and_layout
    assert_same "x = 1", "# a\nx = 1 # b\n"
    assert_same "puts(1)", "puts 1"
    assert_same "a.map { |x| x + 1 }", "a.map do |x|\n  x + 1\nend"
  end

  def test_a_call_without_arguments_has_one_spelling
    assert_same "def f(a)\n  g()\nend", "def f(a)\n  g\nend"
    assert_same "def f()\n  1\nend", "def f\n  1\nend"
    assert_same "a.b()", "a.b"
  end

  def test_modifiers_are_the_same_as_block_forms
    assert_same "puts 1 if a", "if a\n  puts 1\nend"
    assert_same "puts 1 unless a", "unless a\n  puts 1\nend"
    refute_same "puts 1 if a", "puts 1 unless a"
  end

  def test_quoted_symbols_are_symbols
    assert_same "x = :\"abc\"", "x = :abc"
    refute_same "x = :abc", "x = :abd"
  end

  def test_implicit_object_calls_drop_their_dot
    assert_includes ast("xs.map(&.size)"), "(implicit_object_call size)"
  end

  def test_operator_methods_are_operators
    assert_same "x = n.**(2)", "x = n ** 2"
    refute_same "x = n ** 2", "x = n * 2"
  end

  def test_paths_are_split_into_constants
    assert_includes ast("x = Math::PI"), "(path Math :: PI)"
    assert_includes ast("x = ::Foo"), "(path :: Foo)"
  end

  def test_numbers_are_their_values
    assert_same "X = 1_000 + 0x1F + 1_i32", "X = 1000 + 31 + 1"
    assert_same "X = 4400000000_i64", "X = 4400000000"
    assert_same "X = 1.50 + 2.0_f64", "X = 1.5 + 2.0"
    refute_same "X = 1_i64", "X = 1"
    refute_same "X = 1.0_f32", "X = 1.0"
    refute_same "X = 1.0", "X = 1"
    refute_same "X = 1", "X = 2"
  end

  def test_strings_are_their_values
    assert_same 'x = "a\\u0041"', 'x = "aA"'
    assert_same 'x = "\\x41"', 'x = "A"'
    assert_same 'x = "a b"', "x = %q(a b)"
    assert_same 'x = ["a", "b"]', "x = %w(a b)"
    refute_same 'x = "a"', 'x = "b"'
    refute_same "x = \"a\#{b}\"", 'x = "a"'
  end

  def test_the_targets_of_a_multiple_assignment_are_in_a_list
    assert_includes ast("a, b = 1, 2"), "(targets a b)"
    refute_includes ast("a = 1"), "targets"
  end

  def test_the_names_that_types_define_have_types_of_their_own
    assert_includes ast("class Box(T)\nend"), "(type_vars T)"
    assert_includes ast("module Shop::Counting\nend"), "(type_name Shop :: Counting)"
    assert_includes ast("enum Color\n  Red\n  Green\nend"), "(enum_body Red Green)"
  end

  # The parser keeps a pair of brackets that only groups, and this stage
  # drops it. The tree's shape still shows the grouping.
  def test_where_this_stage_differs_from_the_parser
    assert_same "x = (1 + 2)", "x = 1 + 2"
    refute_same "x = (1 + 2) * 3", "x = 1 + 2 * 3"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
