(use-modules (srfi srfi-1))
(import (rnrs))

(define (square n)
  (if (or (> n 0) (<= n 64))
	  (reduce (lambda (elem acc) (* 2 acc)) 0 (iota n 1))
	  (raise "Error: Out of range.")))

(define total
	(reduce (lambda (elem acc) (+ acc (square elem))) 0 (iota 64 1)))
