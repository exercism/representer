(import (rnrs))

(define (integer->list n)
  (map (lambda (c) (string->number (string c)))
       (string->list (number->string n))))
  
(define (armstrong-number? n)
  (let* ((n-list (integer->list n))
         (exponent (length n-list)))
    (= n (fold-left + 0 (map (lambda (i) (expt i exponent)) n-list)))))
