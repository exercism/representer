#lang racket

(provide isogram?)

(define (isogram? s)
  (let* ([duplicates? (check-duplicates (string->list (string-replace (string-downcase s)  #px"[-\\s]" "" #:all? #t)))])
    (not duplicates?)))
         