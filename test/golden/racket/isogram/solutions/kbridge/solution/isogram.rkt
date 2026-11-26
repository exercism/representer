#lang racket

(provide isogram?)

(define (isogram? s)
  (let ([seen (mutable-seteq)])
    (for/and ([c s]
              #:when (char-alphabetic? c))
      (set! c (char-downcase c))
      (if (set-member? seen c)
          #f
          (begin (set-add! seen c)
                 #t)))))
