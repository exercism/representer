require_relative "stage_helper"

# Tests Racket's GenerateAST stage. Each assert_same pair is read as the same
# forms by Racket's reader, and each refute_same pair is not.
class RacketGenerateASTTest < Minitest::Test
  include RacketStages

  def test_layout_makes_no_difference
    assert_same "(define (f x)\n  (+ x 1))", "(define (f x) (+ x 1))"
  end

  def test_every_kind_of_bracket_is_the_same_list
    assert_same "(let ([x 1]) x)", "(let ((x 1)) x)"
    assert_same "(let {[x 1]} x)", "(let ((x 1)) x)"
    refute_same "(f (g x))", "(f g x)"
  end

  def test_quote_marks_are_the_forms_they_stand_for
    assert_same "'(a b)", "(quote (a b))"
    assert_same "`(a ,b ,@c)", "(quasiquote (a (unquote b) (unquote-splicing c)))"
    refute_same "'a", "a"
  end

  def test_booleans_are_written_one_way
    assert_same "(list #true #false)", "(list #t #f)"
    assert_same "(list #T #F)", "(list #t #f)"
  end

  def test_characters_are_written_one_way
    assert_same '(list #\\  #\\linefeed #\\null)', '(list #\\space #\\newline #\\nul)'
    assert_same '(list #\\u0041 #\\101)', '(list #\\A #\\A)'
    refute_same '#\\a', '#\\A'
  end

  def test_numbers_are_their_values
    assert_same "(+ #x1F #b11 #o17)", "(+ 31 3 15)"
    assert_same "(list 1.50 1. 1e3)", "(list 1.5 1.0 1000.0)"
    assert_same "(list 2/4 4/2)", "(list 1/2 2)"
    refute_same "1", "1.0"
    refute_same "#e1.5", "1.5"
  end

  def test_strings_are_their_values
    assert_equal ["a\tb\n\"c\""], literals('"a\\tb\\n\\"c\\""')
    refute_same '"a"', '"b"'
    refute_same '"a"', "a"
    refute_same '"abc"', '#"abc"'
    refute_same '#rx"a+"', '#px"a+"'
  end

  def test_a_here_string_is_its_value
    assert_same "(f #<<END\nsay \"hi\"\nEND\n)", '(f "say \\"hi\\"")'
  end

  def test_an_escape_the_stage_does_not_read_stays_apart_from_its_text
    refute_same '"\\u0041"', '"\\\\u0041"'
  end

  def test_hashes_keep_their_kind
    refute_same "#hash((a . 1))", "#hasheq((a . 1))"
  end

  def test_a_dotted_pair_stays_apart_from_a_list
    refute_same "'(a . b)", "'(a b)"
  end

  def test_the_language_line_stays
    refute_same "#lang racket\n(f)", "#lang racket/base\n(f)"
  end

  private
  def literals(source)
    values = []
    generate_ast(source).each_descendant { |node| values << node.text if node.quoted }
    values
  end

  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
