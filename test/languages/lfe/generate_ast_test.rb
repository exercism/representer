require_relative "stage_helper"

# Tests LFE's GenerateAST stage. Each assert_same pair is the same program
# to LFE's reader, and each refute_same pair is a different program.
class LfeGenerateASTTest < Minitest::Test
  include LfeStages

  def test_layout_and_square_brackets_make_no_difference
    assert_same "(defun f (x) (+ x 1))", "(defun f [x]\n  (+ x 1))"
    assert_same "(let ((x 1)) x)", "(let [(x 1)] x)"
    assert_same "(case x ((tuple a b) a) (_ 0))", "(case x [(tuple a b) a] [_ 0])"
    refute_same "(f x y)", "(f (x y))"
    refute_same "(f x)", "(f #(x))"
  end

  def test_each_form_is_a_list_of_its_items
    assert_equal "(source\n  (list if\n    (list > x 1) 2 3))", ast("(if (> x 1) 2 3)")
    refute_same "(if a b c)", "(if a (b c))"
    refute_same "(let ((x 1)) x)", "(let* ((x 1)) x)"
    refute_same "(defun f (x) x)", "(defmacro f (x) x)"
  end

  def test_the_quote_marks_are_the_forms_that_the_reader_gives
    assert_same "'ok", "(quote ok)"
    assert_same "'(1 2)", "(quote (1 2))"
    assert_same "`(a ,b ,@c)", "(backquote (a (comma b) (comma-at c)))"
    assert_same "#'f/2", "(function f 2)"
    assert_same "#'lists:map/2", "(function lists map 2)"
    refute_same "'ok", "ok"
    refute_same "'#(a b)", "#(a b)"
    refute_same "#'f/2", "(fun f 2)"
  end

  def test_strings_symbols_and_characters_are_written_as_their_values
    assert_same '"a\\nb"', "\"a\nb\""
    assert_same "|abc|", "abc"
    assert_same "#\\x41;", "#\\A"
    assert_same '#"abc"', '#B("abc")'
    refute_same '"a"', "a"
    refute_same '"#\\\\a"', "#\\a"
    refute_same '"a\\x41;"', '"aA"'
    refute_same "#\\a", "97"
  end

  def test_numbers_are_written_as_their_values
    assert_same "#x1F", "31"
    assert_same "#b101", "5"
    assert_same "#o17", "15"
    assert_same "#16rFF", "255"
    assert_same "1.50", "1.5"
    refute_same "1", "1.0"
  end

  private
  def ast(source) = write(generate_ast(source))

  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
