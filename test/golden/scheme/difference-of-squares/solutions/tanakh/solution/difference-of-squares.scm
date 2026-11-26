(import (rnrs))

(define (square-of-sum n)
  (let ((sum (apply + (iota (+ n 1)))))
    (* sum sum)))

(define (sum-of-squares n)
  (if (= n 0)
      0
      (+ (* n n) (sum-of-squares (- n 1)))))

(define (difference-of-squares n)
  (- (square-of-sum n) (sum-of-squares n)))
