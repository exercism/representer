require "test_helper"

class CommonLispTest < InspectorTest
  extend UpstreamTests

  track "common-lisp"

  # The old representer wrote its mapping as generated keywords for upper-cased
  # symbols (`:TWO-FER-0` for `:TWO-FER`), so the expected mappings are
  # rewritten below as the lower-case names that Inspector renames.
  DEVIATIONS = {
    "two-fer" => {
      remove: [":TWO-FER-0", ":TWO-FER-1", ":TWO-FER-2", ":TWO-FER-3", ":TWO-FER-4"],
      add: %w[two-fer twofer name],
      why: "The old representer wrote its mapping as generated keywords, and renamed `:cl` in the `:use` option. " \
           "Inspector renames the names the solution defines (the package, the function and its " \
           "parameter), writes them in lower case, and keeps `cl`, which the solution doesn't define."
    },
    "end-of-file" => {
      parse_error: true,
      why: "The old representer reported the reader error as the representation. A missing parenthesis is a " \
           "syntax error to tree-sitter, so Inspector gives the solution Basic's representation."
    },
    "reader-error" => {
      why: "The old representer reported SBCL's reader error for `#<` as the representation. The grammar accepts " \
           "`#<foo>`, so Inspector represents it like any other code."
    },
    "sharpsign-dot" => {
      why: "The old representer refused `#.` because it would run code while reading, and reported an error. " \
           "Inspector never evaluates anything, so it represents the form like any other."
    }
  }.freeze

  upstream_tests ".lisp", deviations: DEVIATIONS

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "(defun add-one (x) (+ x 1))", "(defun inc (n) (+ n 1))"
    assert_same_representation "(defvar *count* 0) (incf *count*)", "(defvar *total* 0) (incf *total*)"
    assert_same_representation "(let ((a 1) (b 2)) (+ a b))", "(let ((x 1) (y 2)) (+ x y))"
    assert_same_representation "(dolist (item items) (print item))", "(dolist (i items) (print i))"
    assert_same_representation "(flet ((helper (n) n)) (helper 1))", "(flet ((go-on (m) m)) (go-on 1))"
    assert_same_representation "(loop for x in xs collect x)", "(loop for y in xs collect y)"
    assert_same_representation "(multiple-value-bind (a b) (values 1 2) a)", "(multiple-value-bind (c d) (values 1 2) c)"
  end

  def test_names_from_outside_are_kept
    refute_same_representation "(defun f (x) (car x))", "(defun f (x) (cdr x))"
    refute_same_representation "(defun f (x) (foo x))", "(defun f (x) (bar x))"
    refute_same_representation "(make-array 3 :initial-element 0)", "(make-array 3 :element-type 0)"
  end

  def test_structures_and_classes
    assert_same_representation "(defstruct point x y) (point-x (make-point :x 1))",
      "(defstruct pt x y) (point-x (make-point :x 1))"
    assert_same_representation "(defclass shape () ((side :accessor side :initarg :side)))",
      "(defclass figure () ((edge :accessor edge :initarg :edge)))"
    refute_same_representation "(defclass shape () ((side :accessor side)))", "(defclass shape () ((side :reader side)))"
  end

  def test_lambda_lists
    assert_same_representation "(defun f (a &optional (b nil) &key c) (list a b c))",
      "(defun f (x &optional y &key z) (list x y z))"
    refute_same_representation "(defun f (a &optional (b 1)) (list a b))", "(defun f (a &optional b) (list a b))"
    assert_same_representation "(defmethod area ((s square)) s)", "(defmethod area ((r square)) r)"
    refute_same_representation "(defmethod area ((s square)) s)", "(defmethod area ((s circle)) s)"
  end

  def test_package_imports_and_exports_are_dropped
    assert_same_representation "(defpackage :a (:use :cl) (:export :f))\n(in-package :a)\n(defun f () 1)",
      "(defpackage :a)\n(in-package :a)\n(defun f () 1)"
    refute_same_representation "(defpackage :a (:shadow :x))\n(defun f () 1)", "(defpackage :a)\n(defun f () 1)"
    refute_same_representation "(defun f (x) (list 1 require x))", "(defun f (x))"
    refute_same_representation "(defun f (x) (list 1 :use x))", "(defun f (x))"
  end

  def test_a_syntax_error_gets_a_basic_representation
    assert_basic_representation "(defun f (x) (+ x 1)"
  end
end
