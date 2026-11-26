(import (rnrs))

(define (square n)
  ;; tests require an exceptoin when outside range 1 .. 64
  (assert (< 0 n 65))
  (expt 2 (- n 1)))

(define total
  ;; due to above restrictions, we can't use (square 65)
  (- (* (square 64) 2) 1))
