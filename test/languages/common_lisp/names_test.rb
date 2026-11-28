require_relative "stage_helper"

# Checks Common Lisp's declarations of which nodes are names and which
# nodes define them (see common_lisp/representation.rb), through the
# engine's renaming.
class CommonLispNamesTest < Minitest::Test
  include CommonLispStages

  def test_renames_functions_and_their_lambda_lists
    source = "(defun f (a &optional (b nil) (c 1 c-given) &key ((:dee d) 2) &rest r &aux (z 1)) (list a b c d r z))"
    assert_equal %w[a b c c-given d f r z], renamed(source)
    assert_equal %w[g x], renamed("(defmacro g (x) x)")
    assert_equal %w[area s], renamed("(defmethod area ((s square)) s)")
    assert_equal %w[n v], renamed("(defun (setf n) (v) v)")
  end

  def test_renames_global_variables_structures_and_classes
    assert_equal %w[*count*], renamed("(defvar *count* 0) (incf *count*)")
    assert_equal %w[point x y], renamed("(defstruct point x (y 0)) (point-x p)")
    assert_equal %w[shape side], renamed("(defclass shape () ((side :accessor side :initarg :side)))")
  end

  def test_renames_local_bindings
    assert_equal %w[a b], renamed("(let ((a 1) (b 2)) (+ a b))")
    assert_equal %w[item], renamed("(dolist (item items) (print item))")
    assert_equal %w[helper n], renamed("(flet ((helper (n) n)) (helper 1))")
    assert_equal %w[x], renamed("(loop for x in xs collect x)")
    assert_equal %w[a b], renamed("(multiple-value-bind (a b) (values 1 2) a)")
    assert_equal %w[e], renamed("(handler-case (f) (error (e) e))")
  end

  def test_renames_the_package_and_every_keyword_with_a_defined_name
    assert_equal %w[f two-fer], renamed("(defpackage :two-fer (:shadow :f)) (in-package :two-fer) (defun f () 1)")
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[f x], renamed("(defun f (x) (car x) (make-array 3 :initial-element 0))")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], CommonLisp::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if CommonLisp::Representation::Spec.name?(node) }
    leaves
  end
end
