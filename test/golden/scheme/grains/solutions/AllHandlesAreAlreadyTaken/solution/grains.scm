(import (rnrs))

(define (square n)
  (if (<= 1 n 64)
      (expt 2 (1- n))
      (error)))

(define total
  (let rec ([n 64])
    (if (zero? n)
        0
        (+ (square n) (rec (1- n))))))
