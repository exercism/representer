(import (rnrs)
	(srfi srfi-1))

(define (square n)
  (if (<= 1 n 64)
      (ash 1 (- n 1))
      (error)))  

(define total
  (fold-right + 0 (map square (iota 64 1))))

