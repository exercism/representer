(import (rnrs))

(define radix 8)

(define (to-decimal s)
  (let ((valid-number? (string->number s radix)))
    (if (not valid-number?)
        0
        valid-number?)))
