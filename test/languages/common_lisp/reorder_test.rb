require_relative "stage_helper"

# Tests Common Lisp's Reorder stage, through Rosetta as a whole, because
# it sorts by the code with the renamed names left out.
class CommonLispReorderTest < RosettaTest
  track "common-lisp"

  def test_the_order_of_defpackage_options_makes_no_difference
    assert_same_representation "(defpackage :p (:use :cl) (:export :f))", "(defpackage #:p (:export :f) (:use :common-lisp))"
    assert_same_representation "(defpackage :p (:shadow :x) (:nicknames :q))", "(defpackage :p (:nicknames :q) (:shadow :x))"
  end

  def test_the_order_of_forms_stays
    refute_same_representation "(defvar *a* 1) (defvar *b* 2)", "(defvar *b* 2) (defvar *a* 1)"
  end
end
