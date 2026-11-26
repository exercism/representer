#lang racket

(provide isogram?)
(define (counter-hash lst)
  (begin
    (define h (make-hash))
    (map (λ (x) (hash-update! h x add1 0)) lst)
    h))
(define (isogram? s)
  (null? (filter (λ (x) (<= 2 x)) (hash-values (counter-hash (filter char-alphabetic? (string->list (string-downcase s))))))))