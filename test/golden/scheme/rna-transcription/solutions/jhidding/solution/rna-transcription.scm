(import (rnrs))

(define (string-map f str)
  (list->string (map f (string->list str))))

(define (nuc-dna->rna n)
  (cdr (assoc n '((#\G . #\C) (#\C . #\G) (#\T . #\A) (#\A . #\U)))))

(define (dna->rna dna)
  (string-map nuc-dna->rna dna))
