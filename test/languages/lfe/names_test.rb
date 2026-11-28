require_relative "stage_helper"

# Checks which names LFE's GenerateAST marks as defined (see
# lfe/representation/spec.rb), through the engine's renaming.
class LfeNamesTest < Minitest::Test
  include LfeStages

  def test_renames_the_module_functions_and_their_parameters
    source = "(defmodule leap (export (leap-year 1)))\n(defun leap-year (year) (divides? year 4))"
    assert_equal %w[leap leap-year year], renamed(source)
  end

  def test_renames_the_variables_in_the_patterns_of_function_clauses
    source = "(defun go\n  (('() acc) acc)\n  (((cons c rest) acc) (when (> c 0)) (go rest (cons c acc))))"
    assert_equal %w[acc c go rest], renamed(source)
  end

  def test_renames_the_variables_in_the_segments_of_a_binary_pattern
    source = "(defun f (((binary (a (size 8)) (rest binary))) (list a rest)))"
    assert_equal %w[a f rest], renamed(source)
  end

  def test_renames_the_variables_bound_by_lambdas_and_lets
    source = <<~LFE
      (lambda (x) x)
      (match-lambda (((tuple k v) acc) (+ v acc)))
      (let* ((total 0) ((tuple a b) (f))) total)
    LFE
    assert_equal %w[a acc b k total v x], renamed(source)
  end

  def test_renames_the_variables_bound_by_case_receive_and_comprehensions
    source = <<~LFE
      (case x ((tuple 'ok value) value) (_ 0))
      (receive ((tuple from msg) msg) (after 100 'timeout))
      (lc ((<- (tuple c n) pairs) (> n 1)) c)
      (cond ((?= (cons h _) list) h))
      (try (f) (catch ((tuple class reason stack) reason)))
    LFE
    assert_equal %w[c class from h msg n reason stack value], renamed(source)
  end

  def test_renames_local_functions_records_and_macros
    source = <<~LFE
      (fletrec ((loop (n acc) (loop (- n 1) acc))) (loop 3 0))
      (letrec-function ((count (lambda (xs) xs))) (count '()))
      (defrecord robot direction (position 0))
      (defmacro twice (e) `(progn ,e ,e))
    LFE
    assert_equal %w[acc count direction e loop n position robot twice xs], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = "(defun f () (lists:map #'g/1 (list 'a x)))\n(catch (g 1))"
    assert_equal %w[f], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], Lfe::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if Lfe::Representation::Spec.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
