require "test_helper"

# Tests Inspector as a whole on Scheme solutions. The tests of each stage are in
# test/languages/scheme/.
class SchemeTest < InspectorTest
  track "scheme"

  def test_comments_and_formatting
    assert_same_representation "; c\n(define (f x)\n  (+ x 1)) ; x\n", "(define (f x) (+ x 1))"
    refute_same_representation "(define (f x) (- x 1))", "(define (f x) (1- x))"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "(define (area w h) (* w h))", "(define (size x y) (* x y))"
    assert_same_representation "(define (f xs) (let ((total (length xs))) total))",
                               "(define (f ys) (let ((n (length ys))) n))"
    refute_same_representation "(define (f a b) (* a b))", "(define (f a b) (* a a))"
  end

  def test_names_the_solution_does_not_define_are_kept
    refute_same_representation "(define (f s) (string-upcase s))", "(define (f s) (string-downcase s))"
  end

  def test_imports_are_dropped
    assert_same_representation "(import (rnrs))\n(define x 1)", "(define x 1)"
    assert_same_representation "(use-modules (srfi srfi-1))\n(define x 1)", "(define x 1)"
    assert_same_representation "(define-module (leap) #:export (leap-year?))\n(define x 1)", "(define x 1)"
  end

  def test_a_form_is_only_an_import_if_it_starts_with_the_import
    refute_same_representation "(define (f x) (list 1 import x))", "(define (f x))"
    refute_same_representation "(define (f x) (list 1 export x))", "(define (f x))"
  end

  def test_numbers_and_strings_are_their_values
    assert_same_representation "(define x #x10)", "(define x 16)"
    assert_same_representation "(define x 'a)", "(define x (quote a))"
    refute_same_representation "(define x \"you\")", "(define x \"me\")"
  end

  def test_code_that_does_not_parse_gets_basics_representation
    assert_basic_representation "(define (f x)"
  end
end
