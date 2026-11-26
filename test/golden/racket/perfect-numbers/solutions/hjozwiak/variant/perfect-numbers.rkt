#lang racket

(provide classify)


(define (classify n)
  "Classify n as perfect, deficient, or abundant."
  (let
      ([sum (factorize-and-sum n)])
    (cond
      [(= sum n) 'perfect]
      [(< sum n) 'deficient]
      [(> sum n) 'abundant])))



(define (factorize-and-sum n)
  "Factor n and sum the factors."
  (for/sum
      ([i (in-range 2 n)]
    #:when (zero? (modulo n i)))
    i))

