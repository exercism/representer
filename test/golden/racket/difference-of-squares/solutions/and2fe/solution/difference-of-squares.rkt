#lang racket

(provide sum-of-squares square-of-sum difference)

(define (sum-of-squares number)
  (for/fold ([sum 0])
            ([num number])
    (+ sum (sqr (add1 num)))))

(define (square-of-sum number)
  (sqr (stream-fold + 0 (in-range 1 (add1 number)))))

(define (difference number)
  (- (square-of-sum number)
     (sum-of-squares number)))
