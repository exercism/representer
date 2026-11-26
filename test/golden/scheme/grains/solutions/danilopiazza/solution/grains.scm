(import (rnrs))

(define (square n)
  (if (or (<= n 0) (> n 64))
      (error 'square "n must be between 1 and 64")
      (expt 2 (- n 1))))

(define total
  (- (expt 2 64) 1))

