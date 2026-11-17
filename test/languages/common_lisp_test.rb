require "test_helper"

class CommonLispTest < RepresenterTest
  extend UpstreamTests

  track "common-lisp"

  # The old representer wrote its mapping as generated keywords for upper-cased
  # symbols (`:TWO-FER-0` for `:TWO-FER`), so the expected mappings are
  # rewritten below as the lower-case names that this representer renames.
  DEVIATIONS = {
    "two-fer" => {
      remove: [":TWO-FER-0", ":TWO-FER-1", ":TWO-FER-2", ":TWO-FER-3", ":TWO-FER-4"],
      add: %w[two-fer twofer name],
      why: "The old representer wrote its mapping as generated keywords, and renamed `:cl` in the `:use` option. " \
           "This representer renames the names the solution defines (the package, the function and its " \
           "parameter), writes them in lower case, and keeps `cl`, which the solution doesn't define."
    },
    "end-of-file" => {
      fallback: true,
      why: "The old representer reported the reader error as the representation. A missing parenthesis is a " \
           "syntax error to tree-sitter, so this representer gives the solution Basic."
    },
    "reader-error" => {
      why: "The old representer reported SBCL's reader error for `#<` as the representation. The grammar accepts " \
           "`#<foo>`, so this representer represents it like any other code."
    },
    "sharpsign-dot" => {
      why: "The old representer refused `#.` because it would run code while reading, and reported an error. " \
           "This representer never evaluates anything, so it represents the form like any other."
    }
  }.freeze

  upstream_tests ".lisp", deviations: DEVIATIONS

  def test_comments_and_layout_are_ignored
    assert_same_representation "(defun f (x)\n  ;; note\n  #| block |#\n  (+ x 1))", "(defun f (x) (+ x 1))"
  end

  def test_symbols_are_case_insensitive
    assert_same_representation "(defun Add-One (X) (+ X 1))", "(defun add-one (x) (+ x 1))"
    refute_same_representation "(defun f () |Foo|)", "(defun f () |foo|)"
  end

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

  def test_names_from_the_tests_are_kept
    tests = { "two-fer-test.lisp" => "(in-package :two-fer-test)\n(is (equal (two-fer:twofer) 1))" }
    refute_same_representation "(defpackage :two-fer (:export :twofer))\n(defun twofer () 1)",
      "(defpackage :two-fer (:export :twofer))\n(defun other () 1)", exercise_files: tests
    assert_same_representation "(defun twofer (a) a)", "(defun twofer (b) b)", exercise_files: tests
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

  def test_other_spellings_of_the_same_code
    assert_same_representation "(f (quote (1 2)))", "(f '(1 2))"
    assert_same_representation "(mapcar (function car) xs)", "(mapcar #'car xs)"
    assert_same_representation "(mapcar #'(lambda (x) x) xs)", "(mapcar (lambda (x) x) xs)"
    assert_same_representation "(cl:car x)", "(car x)"
    assert_same_representation "(common-lisp:car x)", "(car x)"
    assert_same_representation "(let ((a NIL) (b ()) (c 'nil)) 1)", "(let ((x nil) (y nil) (z nil)) 1)"
    assert_same_representation "(defpackage :p (:use :cl) (:export :f))", "(defpackage #:p (:export :f) (:use :common-lisp))"
    assert_same_representation "(f 'a 'b)", "(f (quote a) (quote b))"
  end

  def test_strings_are_their_values
    assert_same_representation '(f "a\\"b")', '(f "a\\"b")'
    refute_same_representation '(f "a")', '(f "b")'
    refute_same_representation '(f #\a)', '(f #\b)'
  end

  def test_docstrings_are_comments_but_returned_strings_are_not
    assert_same_representation '(defun f (x) "Adds one." (+ x 1))', "(defun f (x) (+ x 1))"
    assert_same_representation '(defvar *x* 1 "A counter.")', "(defvar *x* 1)"
    refute_same_representation '(defun f () "hello")', "(defun f () \"bye\")"
    refute_same_representation '(defun f () "hello")', "(defun f () nil)"
  end

  def test_things_that_must_stay_apart
    refute_same_representation "(defun f (x) (when x 1))", "(defun f (x) (if x 1))"
    refute_same_representation "(defun f (x) `(a ,x))", "(defun f (x) '(a x))"
    refute_same_representation "(f 'a)", "(f a)"
    refute_same_representation "(defun f (x) (+ x 1))", "(defun f (x) (+ x 2))"
  end

  def test_a_syntax_error_falls_back
    assert_falls_back "(defun f (x) (+ x 1)"
  end
end
