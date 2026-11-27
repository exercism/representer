require "test_helper"

class RacketTest < RepresenterTest
  track "racket"

  def test_comments_and_layout_are_ignored
    assert_same_representation "#lang racket\n;; Says one.\n(define (f)\n  1) ; one\n#| block |#\n#;(f)\n",
      "#lang racket\n(define (f) 1)\n"
  end

  def test_imports_are_dropped
    assert_same_representation "#lang racket\n(require racket/list (only-in racket/string string-join))\n(define (f l) (first l))\n",
      "#lang racket\n(define (f l) (first l))\n"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "#lang racket\n(provide leap-year?)\n(define (leap-year? year) (divides? year 4))\n" \
                               "(define (divides? n d) (zero? (remainder n d)))\n",
      "#lang racket\n(provide leap?)\n(define (leap? y) (by? y 4))\n(define (by? a b) (zero? (remainder a b)))\n"
  end

  def test_names_from_outside_are_kept
    refute_same_representation "#lang racket\n(define (f l) (apply max l))\n", "#lang racket\n(define (f l) (apply min l))\n"
  end

  def test_things_that_must_stay_apart
    refute_same_representation "#lang racket\n(define (f x) (+ x 1))\n", "#lang racket\n(define (f x) (- x 1))\n"
    refute_same_representation "#lang racket\n(define (f a b) (- a b))\n", "#lang racket\n(define (f a b) (- b a))\n"
    refute_same_representation "#lang racket\n(define (f x) (eq? x 1))\n", "#lang racket\n(define (f x) (equal? x 1))\n"
    refute_same_representation "#lang racket\n(define (f x) (list 1 require x))\n", "#lang racket\n(define (f x) (list 1 x))\n"
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "#lang racket\n(define (f x) \"x)\n"
  end
end
