(import (rnrs))


(define (sum-of-squares n)
  (sumsq-iter 0 2 n))

(define (sumsq-iter sum counter max-count)
  (if (> counter max-count)
    sum
    (sumsq-iter (+ (* counter counter) sum)
               (+ counter 1)
               max-count)))

(define (square-of-sum n)
  (* (sum-iter 0 1 n) (sum-iter 0 1 n)))

(define (sum-iter sum counter max-count)
    (if (> counter max-count)
    sum
    (sum-iter (+ counter sum)
               (+ counter 1)
               max-count)))

(define (difference-of-squares n)
  (- (square-of-sum n) (sum-of-squares n)))
