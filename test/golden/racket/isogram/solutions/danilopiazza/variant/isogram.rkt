#lang racket

(provide isogram?)

(define (isogram? s)
  (let ([letters (filter char-alphabetic? (string->list (string-upcase s)))])
    (equal? letters (remove-duplicates letters))))
