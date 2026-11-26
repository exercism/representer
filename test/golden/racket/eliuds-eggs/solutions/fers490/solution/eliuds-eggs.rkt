#lang racket

(provide number->eggs)

(define (number->eggs n)
  (length
    (for/list ([char (in-string (number->string n 2))]
             #:when (member char '(#\1)))
      char)
    ))

