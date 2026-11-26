#lang racket
(provide my-reverse)

(define (my-reverse s)
  (define sum (string->list s))
    (list->string (reverse sum)))
  
  
