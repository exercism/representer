#lang racket
(provide to-rna)

(define dna
  #hash((#\G . #\C)
        (#\C . #\G)
        (#\T . #\A)
        (#\A . #\U)))

; (hash-ref dna "G")
; "C"

(define (to-rna s)
  (let ([lst (string->list s)])
    (list->string (map (λ (i) (hash-ref dna i)) lst))))