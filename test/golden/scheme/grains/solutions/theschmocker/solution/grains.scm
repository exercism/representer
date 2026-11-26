(import (rnrs))

(define (square n)
  (if (not (< 0 n 65))
      (error "square" "n must be a number from 1 to 64")
      (expt 2 (- n 1))))

(define total
  (apply + (map (compose square 1+) (iota 64))))

