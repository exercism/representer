(import (rnrs))
(use-modules ((srfi srfi-1) #:prefix srfi-1:)
             ((srfi srfi-26) #:prefix srfi-26:))

(define (sum xs) (fold-right + 0 xs))

(define (convert list-of-digits)
  (map (srfi-26:cut expt <> (length list-of-digits)) list-of-digits))

(define (digits->list num)
  (define base 11)
  (srfi-1:unfold-right
    zero?
    (srfi-26:cut remainder <> base)
    (srfi-26:cut quotient <> base)
    num))

(define (armstrong-number? n)
  (= n (sum (convert (digits->list n)))))