#lang racket

(provide square total)

(define (square a-square)
  (expt 2 (- a-square 2)))

(define (total)
  (for/sum ([i (in-inclusive-range 1 64 1)]) (square i)))
