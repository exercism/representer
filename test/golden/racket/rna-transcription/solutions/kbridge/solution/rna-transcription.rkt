#lang racket

(provide to-rna)
(require srfi/13)

(define table
  '#hasheq(
    (#\G . #\C)
    (#\C . #\G)
    (#\T . #\A)
    (#\A . #\U)))

(define (to-rna dna)
  (string-map (curry hash-ref table) dna))

;; (immutable? "...") => #t
;; (immutable? (to-rna "...")) => #f
;; but the latter should be immutable, consider using string->immutable-string
