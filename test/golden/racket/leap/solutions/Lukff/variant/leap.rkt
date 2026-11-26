#lang racket

(provide leap-year?)

(define (leap-year? year)
  (or (div? year 4)
       (or (not (div? year 100))
           (div? year 400))))

(define (div? num quot)
  (zero? (remainder num quot)))
