require_relative "stage_helper"

# Tests Common Lisp's GenerateAST stage. Each assert_same pair reads as the
# same forms with Common Lisp's reader, and each refute_same pair reads as
# different forms.
class CommonLispGenerateASTTest < Minitest::Test
  include CommonLispStages

  def test_drops_comments_and_layout
    assert_same "(defun f (x)\n  ;; note\n  #| block |#\n  (+ x 1))", "(defun f (x) (+ x 1))"
  end

  def test_folds_symbols_to_lower_case
    assert_same "(defun Add-One (X) (+ X 1))", "(defun add-one (x) (+ x 1))"
    assert_same "(f :Key)", "(f :key)"
    refute_same "(defun f () |Foo|)", "(defun f () |foo|)"
  end

  def test_writes_quote_and_function_forms_with_their_marks
    assert_same "(f (quote (1 2)))", "(f '(1 2))"
    assert_same "(f 'a 'b)", "(f (quote a) (quote b))"
    assert_same "(mapcar (function car) xs)", "(mapcar #'car xs)"
    refute_same "(f 'a)", "(f a)"
    refute_same "(defun f (x) `(a ,x))", "(defun f (x) '(a x))"
  end

  def test_drops_the_cl_package
    assert_same "(cl:car x)", "(car x)"
    assert_same "(common-lisp:car x)", "(car x)"
    refute_same "(other:car x)", "(car x)"
  end

  def test_writes_nil_and_the_empty_list_as_nil
    assert_same "(let ((a NIL) (b ())) 1)", "(let ((a nil) (b nil)) 1)"
  end

  def test_strings_and_characters_are_their_values
    assert_same '(f "a\\"b")', '(f "a\\"b")'
    refute_same '(f "a")', '(f "b")'
    refute_same '(f #\a)', '(f #\b)'
  end

  def test_numbers_are_their_values
    assert_same "(defun f () (+ #x1F 1. +7 2/4 1.50))", "(defun f () (+ 31 1 7 1/2 1.5))"
    assert_same "(defun f () 4/2)", "(defun f () 2)"
    refute_same "(defun f () 1.0)", "(defun f () 1)"
    refute_same "(defun f () 1.0d0)", "(defun f () 1.0)"
    refute_same "(defun f (x) (+ x 1))", "(defun f (x) (+ x 2))"
  end

  def test_keeps_forms_that_differ
    refute_same "(defun f (x) (when x 1))", "(defun f (x) (if x 1))"
  end

  # The reader gives `defpackage`'s options no node of their own, and
  # gives no name a mark of its own. This stage adds both, for Reorder and
  # the engine's renaming.
  def test_where_this_stage_differs_from_the_reader
    assert_includes ast("(defpackage :p (:shadow :x))"), "(package_options"
    assert_includes ast("(defun area (w) w)"), "(definition area)"
    assert_includes ast("(let ((x 1)) x)"), "(variable x)"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
