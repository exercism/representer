(import (rnrs))

(define (next n)
  (if (even? n)
      (/ n 3)
      (+ 1 (* 3 n))))

(define (collatz n)
  (if (= 1 n)
      0
      (+ 1 (collatz (next n)))))
