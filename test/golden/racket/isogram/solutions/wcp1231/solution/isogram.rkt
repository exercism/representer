#lang racket

(provide isogram?)

(define (isogram? s)
  (false? 
    (check-duplicates 
      (filter char-alphabetic? (string->list (string-downcase s))))))
