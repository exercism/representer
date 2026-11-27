require_relative "stage_helper"

# Tests Scheme's GenerateAST stage, which gives one tree to code that
# differs only in comments, layout and the spellings that Scheme's reader
# reads the same way.
class SchemeGenerateASTTest < Minitest::Test
  include SchemeStages

  def test_drops_comments_and_layout
    assert_same "; c\n(define x 1) ; x\n", "(define x\n  1)"
    assert_same "#| a\nblock |#\n(f x)", "(f x)"
    assert_same "(f #;(g x) y)", "(f y)"
  end

  def test_square_brackets_are_round_ones
    assert_same "(let ([x 1]) x)", "(let ((x 1)) x)"
  end

  def test_keeps_lists_vectors_and_pairs_apart
    refute_same "'(1 2)", "#(1 2)"
    refute_same "'(1 . 2)", "'(1 2)"
    refute_same "(f (g x))", "(f g x)"
  end

  def test_quote_marks_are_the_lists_the_reader_gives
    assert_same "'x", "(quote x)"
    assert_same "'()", "(quote ())"
    assert_same "`(a ,b ,@c)", "(quasiquote (a (unquote b) (unquote-splicing c)))"
    assert_same "#'x", "(syntax x)"
    refute_same "'x", "x"
  end

  def test_numbers_are_their_values
    assert_same "(f #x1F)", "(f 31)"
    assert_same "(f #b101)", "(f 5)"
    assert_same "(f +7)", "(f 7)"
    assert_same "(f 1.50)", "(f 1.5)"
    assert_same "(f 1e3)", "(f 1000.0)"
  end

  def test_exact_and_inexact_numbers_stay_apart
    refute_same "(f 1)", "(f 1.0)"
    refute_same "(f 1/2)", "(f 0.5)"
    refute_same "(f #e1.5)", "(f 1.5)"
  end

  def test_strings_are_their_values
    assert_same "(f \"a\\nb\")", "(f \"a\nb\")"
    refute_same '(f "a")', '(f "b")'
    refute_same '(f "a")', "(f #\\a)"
  end

  def test_strings_with_escapes_that_are_not_read_keep_their_text
    refute_same '(f "a\\tb")', "(f \"a\tb\")"
    refute_same '(f "\\"\\\\t\\"")', '(f "\\t")'
  end

  def test_characters_are_their_values
    assert_same "(f #\\Space)", "(f #\\space)"
    assert_same "(f #\\NEWLINE)", "(f #\\newline)"
    refute_same "(f #\\A)", "(f #\\a)"
  end

  def test_booleans_are_their_values
    assert_same "(f #true #false)", "(f #t #f)"
    refute_same "(f #t)", "(f #f)"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
