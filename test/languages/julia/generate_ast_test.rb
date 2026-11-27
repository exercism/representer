require_relative "stage_helper"

# Tests Julia's GenerateAST stage. Each assert_same pair has the same meaning
# in Julia, and each refute_same pair has different meanings.
class JuliaGenerateASTTest < Minitest::Test
  include JuliaStages

  def test_layout_makes_no_difference
    assert_same "a = f(1, 2,); b = 3", "a = f(1, 2)\nb = 3"
    assert_same "a = [1, 2,]", "a = [1, 2]"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "a = (1 + 2)", "a = 1 + 2"
    refute_same "a = (1 + 2) * 3", "a = 1 + 2 * 3"
  end

  def test_semicolons_that_tell_code_apart_stay
    refute_same "f(a; b = 1)", "f(a, b = 1)"
    refute_same "a = (; b = 1)", "a = (b = 1,)"
    refute_same "a = [1; 2]", "a = [1 2]"
    refute_same "a = [1;; 2]", "a = [1; 2]"
  end

  def test_keywords_that_tell_code_apart_stay
    refute_same "mutable struct A end", "struct A end"
    refute_same "baremodule A end", "module A end"
    refute_same "for outer i in 1:3 end", "for i in 1:3 end"
    refute_same "map(xs) do (a, b)\na\nend", "map(xs) do a, b\na\nend"
  end

  def test_every_spelling_of_a_loop_binding_is_the_same
    assert_same "for i = 1:3 end", "for i in 1:3 end"
    assert_same "for i ∈ 1:3 end", "for i in 1:3 end"
    assert_same "[x for x = xs]", "[x for x in xs]"
  end

  def test_a_number_before_an_expression_is_a_multiplication
    assert_same "a = 2x + 1", "a = 2 * x + 1"
    assert_same "a = 1 / 2x", "a = 1 / (2 * x)"
    refute_same "a = 1 / 2x", "a = 1 / 2 * x"
  end

  def test_strings_are_their_values
    assert_same 'a = """b"""', 'a = "b"'
    assert_same 'a = "\\u00e9\\t"', "a = \"é\t\""
    refute_same 'a = "\\$b"', 'a = "$b"'
    refute_same 'a = raw"b"', 'a = "b"'
    refute_same 'a = "b"', "a = 'b'"
  end

  def test_a_triple_quoted_string_over_several_lines_keeps_its_text
    refute_same "a = \"\"\"\n    b\n    \"\"\"", "a = \"b\""
  end

  def test_both_spellings_of_an_interpolation_are_the_same
    assert_same 'a = "x$b"', 'a = "x$(b)"'
    refute_same 'a = "$b.c"', 'a = "$(b.c)"'
  end

  def test_characters_are_their_values
    assert_same "a = '\\u41'", "a = 'A'"
    refute_same "a = 'a'", "a = 'b'"
  end

  def test_numbers_are_their_values
    assert_same "a = 1_000 + 1e3 + 1.50 + 007", "a = 1000 + 1000.0 + 1.5 + 7"
    refute_same "a = 0x1F", "a = 31"
    refute_same "a = 0x01", "a = 0x1"
    refute_same "a = 1.5f0", "a = 1.5"
    refute_same "a = 1", "a = 1.0"
  end

  def test_a_keyword_argument_has_its_own_type
    assert_includes ast("sort(xs, by = length)"), "(keyword_argument by = length)"
  end

  def test_dropping_the_imports_leaves_nothing_behind
    assert_equal write(prepare("a = 1")),
      write(prepare("using Dates\nimport Base: show\nusing Random: shuffle\ninclude(\"b.jl\")\na = 1"))
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
