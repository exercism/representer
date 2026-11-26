#lang racket
(provide my-reverse)

(define (my-reverse s)
  (let ([len (string-length s)])
    (list->string
     (for/list ([i (in-range len)])
       (string-ref s (- len (add1 i)))))))