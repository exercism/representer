(import (rnrs))

(define (square n)
  (cond
   ((> n 64) (raise "too many"))
   ((<= n 0) (raise "not enough"))
   (else (expt 2 (- n 1)))))

(define (sum n)
  (cond
   ((= 1 n) 1)
   (else (+ (square n)
            (sum (- n 1))))))

(define total (sum 64))
