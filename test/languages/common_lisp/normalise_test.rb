require_relative "stage_helper"

# Tests Common Lisp's representation Normalise stage, and the imports that
# the engine drops, which give one form to spellings that Common Lisp
# treats the same way.
class CommonLispNormaliseTest < Minitest::Test
  include CommonLispStages

  def test_drops_imports_and_exports
    assert_same "(require :asdf)\n(export 'f)\n(defun f () 1)", "(defun f () 1)"
    assert_same "(use-package :a)\n(import 'a:b)\n(defun f () 1)", "(defun f () 1)"
  end

  def test_drops_the_use_export_and_import_options_of_defpackage
    assert_same "(defpackage :a (:use :cl) (:export :f) (:import-from :b :c))", "(defpackage :a)"
    refute_same "(defpackage :a (:shadow :x))", "(defpackage :a)"
  end

  def test_writes_package_names_one_way
    assert_same "(defpackage #:p (:shadow #:x))", "(defpackage :p (:shadow :x))"
    assert_same "(in-package :common-lisp-user) (f :common-lisp)", "(in-package :common-lisp-user) (f :cl)"
  end

  def test_writes_a_quoted_nil_as_nil
    assert_same "(let ((a 'nil) (b '())) 1)", "(let ((a nil) (b nil)) 1)"
  end

  def test_drops_the_function_mark_before_a_lambda
    assert_same "(mapcar #'(lambda (x) x) xs)", "(mapcar (lambda (x) x) xs)"
    assert_same "(mapcar (function (lambda (x) x)) xs)", "(mapcar (lambda (x) x) xs)"
  end

  def test_drops_docstrings_but_not_returned_strings
    assert_same '(defun f (x) "Adds one." (+ x 1))', "(defun f (x) (+ x 1))"
    assert_same '(defvar *x* 1 "A counter.")', "(defvar *x* 1)"
    refute_same '(defun f () "hello")', '(defun f () "bye")'
    refute_same '(defun f () "hello")', "(defun f () nil)"
  end

  def test_keeps_only_the_variable_of_a_for_or_with_clause
    assert_same "(loop for x from 1 to 10 collect x)", "(loop for x from 2 to 20 collect x)"
    assert_same "(loop with total = 0 for x in xs do (incf total x))", "(loop with total = 1 for x in xs do (incf total x))"
    refute_same "(loop for x in xs collect x)", "(loop for x in xs sum x)"
  end

  private
  def tree(source) = write(prepare(source))
  def assert_same(first, second) = assert_equal(tree(first), tree(second))
  def refute_same(first, second) = refute_equal(tree(first), tree(second))
end
