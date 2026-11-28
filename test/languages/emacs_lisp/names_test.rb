require_relative "stage_helper"

# Checks Emacs Lisp's declarations of which nodes are names and which nodes
# define them (see emacs_lisp/representation.rb), through the engine's
# renaming.
class EmacsLispNamesTest < Minitest::Test
  include EmacsLispStages

  def test_renames_functions_macros_and_their_parameters
    source = "(defun a (b &optional c &rest d) b)\n(defsubst e () 1)\n(defmacro f (g) g)\n" \
             "(cl-defun h (i &key (j 1 j-given) ((:k k) 2)) i)\n(cl-defmethod l :before ((m integer)) m)"
    assert_equal %w[a b c d e f g h i j j-given k l m], renamed(source)
  end

  def test_renames_global_variables_and_aliases
    source = "(defvar a 1)\n(defconst b 2)\n(defcustom c 3 \"C.\")\n(defalias 'd #'car)\n(define-error 'e \"E\")"
    assert_equal %w[a b c d e], renamed(source)
  end

  def test_renames_local_variables
    source = "(let ((a 1) b) a)\n(let* ((c 2)) c)\n(dolist (d xs) d)\n(dotimes (e 3) e)\n(if-let (f (g)) f)\n" \
             "(when-let* ((h 1)) h)\n(seq-let (i &rest j) xs i)\n(condition-case k (car xs) (error k))"
    assert_equal %w[a b c d e f h i j k], renamed(source)
  end

  def test_renames_lambda_and_local_function_parameters
    source = "(mapcar (lambda (a) a) xs)\n(cl-flet ((b (c) c)) (b 1))\n(cl-labels ((d (e) (d e))) (d 1))"
    assert_equal %w[a b c d e], renamed(source)
  end

  def test_renames_loop_variables
    source = "(cl-loop for a in xs for (b . c) in ys with d = 0 collect a into e finally return e)"
    assert_equal %w[a b c d e], renamed(source)
  end

  def test_renames_structures_and_classes
    source = "(cl-defstruct a b (c 0))\n(defclass d () ((e :initform 0 :accessor f)))"
    assert_equal %w[a b c d e f], renamed(source)
  end

  def test_renames_a_quoted_name_the_solution_defines
    names = marks("(defun two-fer () 1)\n(provide 'two-fer)").select { |text, _| text == "two-fer" }
    assert_equal [["two-fer", true], ["two-fer", true]], names
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[a], renamed("(defun a () (make-instance 'foo) (mapcar #'car xs))")
    assert_equal %w[a], renamed("(defun a () (setq b nil))")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], EmacsLisp::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if EmacsLisp::Representation::Spec.name?(node) }
    leaves
  end
end
