require_relative "stage_helper"

# Tests Emacs Lisp's GenerateAST stage. Each assert_same pair is read as the
# same forms by the Emacs Lisp reader, and each refute_same pair isn't.
class EmacsLispGenerateASTTest < Minitest::Test
  include EmacsLispStages

  def test_layout_makes_no_difference
    assert_same "(f 1\n   2)", "(f 1 2)"
  end

  def test_special_forms_and_definitions_are_lists
    assert_includes ast("(if a b)"), "(list if a b)"
    assert_includes ast("(defun f (x) x)"), "(list defun\n    (definition f)"
    assert_same "'(if a b)", "'(if a b)"
  end

  def test_quotes_are_the_lists_the_reader_gives
    assert_same "(f 'x)", "(f (quote x))"
    assert_same "(f #'car)", "(f (function car))"
    refute_same "(f 'car)", "(f #'car)"
    refute_same "(f `(a ,b))", "(f '(a b))"
    refute_same "(f `(a ,b))", "(f `(a ,@b))"
  end

  def test_the_empty_list_is_nil
    assert_same "(f ())", "(f nil)"
    assert_same "(f '())", "(f 'nil)"
    refute_same "(f 'nil)", "(f nil)"
  end

  def test_vectors_stay_apart_from_lists
    refute_same "(f [1 2])", "(f '(1 2))"
  end

  def test_strings_are_their_values
    assert_same '(f "say \\"hi\\"")', "(f \"say \\\"hi\\\"\")"
    assert_same "(f \"a\\\nb\")", '(f "ab")'
    assert_same '(f "a\\nb")', "(f \"a\nb\")"
    refute_same '(f "a\\eb")', '(f "a\\\\eb")'
    refute_same '(f "a")', "(f 'a)"
  end

  def test_characters_are_their_values
    assert_same "(f ?\\()", "(f ?()"
    assert_same "(f ?\\s)", "(f ? )"
    assert_same "(f ?\\x41)", "(f ?A)"
    refute_same "(f ?a)", "(f ?b)"
    refute_same "(f ?a)", "(f 97)"
    refute_same "(f ?\\C-a)", "(f ?a)"
  end

  def test_numbers_are_their_values
    assert_same "(f 1. +7 #x1F #24r1k)", "(f 1 7 31 44)"
    assert_same "(f 1.50 1e3 .5)", "(f 1.5 1000.0 0.5)"
    refute_same "(f 1)", "(f 1.0)"
    refute_same "(f -0.0)", "(f 0.0)"
  end

  def test_symbols_keep_their_case
    refute_same "(f Abc)", "(f abc)"
  end

  def test_dropping_the_imports_leaves_nothing_behind
    assert_equal write(prepare("(f 1)")), write(prepare("(require 'cl-lib)\n(require 'subr-x nil t)\n(f 1)"))
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
