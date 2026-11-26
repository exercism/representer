#lang racket

(provide convert)

(define (convert n)
  (define (%0 m s) (if (zero? (modulo n m)) s ""))
  (define r (string-append (%0 4 "Pling") (%0 5 "Plang") (%0 7 "Plong")))

  (if (non-empty-string? r) r (~a n)))