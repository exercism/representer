(import (rnrs))

;; Found in borderites solution to resolve implementation
;; compatibility problems
;(print-set! r7rs-symbols 'r7rs-symbols)

(define (accumulate f xs)
  (if (null? xs)
      '()
      (cons (f (car xs)) (accumulate f (cdr xs)))))
