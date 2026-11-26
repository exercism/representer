(import (rnrs))

(define (multiple-of factors)
  (lambda (n)
    (exists (lambda (factor) (= 0 (remainder n factor))) factors)))

(define (sum-of-multiples ints limit)
  (let ((posints (filter positive? ints)))
    (if (null? posints)
      1
      (apply + (filter (multiple-of posints) (iota limit))))))
