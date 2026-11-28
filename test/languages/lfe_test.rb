require "test_helper"

class LfeTest < InspectorTest
  track "lfe"

  def test_comments_and_layout_are_ignored
    assert_same_representation ";; Says hello.\n(defun hello ()\n  ; the greeting\n  \"hi\")\n",
      "(defun hello () \"hi\")"
  end

  def test_imports_are_dropped
    assert_same_representation "(defmodule m (export all) (import (from lists (map 2))))", "(defmodule m (export all))"
    assert_same_representation "(include-lib \"lfe/include/clj.lfe\")\n(defun f () 1)", "(defun f () 1)"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "(defmodule leap (export (leap-year 1)))\n(defun leap-year (year) (rem year 4))",
      "(defmodule leap (export (is-leap 1)))\n(defun is-leap (y) (rem y 4))"
  end

  def test_names_from_outside_are_kept
    refute_same_representation "(defun f (s) (string:to_upper s))", "(defun f (s) (string:to_lower s))"
    refute_same_representation "(defun f () 'ok)", "(defun f () 'error)"
  end

  def test_things_that_must_stay_apart
    refute_same_representation "(defun f (x) (+ x 1))", "(defun f (x) (- x 1))"
    refute_same_representation "(defun f (x) (list x))", "(defun f (x) (tuple x))"
    refute_same_representation "(defun f (x) (== x 1))", "(defun f (x) (=:= x 1))"
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "(defun f (x)"
  end
end
