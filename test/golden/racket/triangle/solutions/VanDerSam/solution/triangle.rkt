#lang racket

(provide triangle?)

(define (triangle? sides kind)
  (define a (first sides))
  (define b (second sides))
  (define c (third sides))
  (define (valid-triangle? a b c)
    (and (> a 0)
         (> b 0)
         (> c 0)
         (>= (+ a b) c)
         (>= (+ b c) a)
         (>= (+ a c) b)))
  (define (get-triangle-type a b c)
    (append
      null
      (if (and (= a b) (= b c)) (list 'equilateral) null)
      (if (or (= a b) (= b c) (= a c)) (list 'isosceles) (list 'scalene))))
  (if (valid-triangle? a b c)
    (if (member kind (get-triangle-type a b c)) #t #f)
    #f))
