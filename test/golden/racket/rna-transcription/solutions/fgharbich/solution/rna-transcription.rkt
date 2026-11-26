#lang racket

(provide to-rna)

(define ht (hash #\A #\U #\G #\C #\C #\G #\T #\A))

; String -> String
; transcribes DNA nucleotides to RNA nucleotides
(define (to-rna nucl)
  (let ([lst (string->list nucl)])
    (list->string (map (curry hash-ref ht) lst))))