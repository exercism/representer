(import (rnrs))

(define (square n)
  (if (<= 1 n 64)
    (if (= n 1)
      1
      (* 2 (square (- n 1))))
    (error))
)

(define (sum n)
  (if (= n 1)
    1
    (+ (square n) (sum (- n 1)))))

(define total
  (sum 64)
)

