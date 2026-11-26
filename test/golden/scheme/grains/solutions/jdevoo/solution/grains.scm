(import (rnrs))

(define (square n)
  (assert (< 0 n 65))
  (expt 2 (- n 1)))

(define (total)
  (do (
    [i 1 (+ i 1)]
    [accu 0 (+ accu (square i))])
  ((> i 64) accu)))