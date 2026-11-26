#lang racket

(provide to-rna)

(define complement (hash #\G #\C
                         #\C #\G
                         #\T #\A
                         #\A #\U))

(define (to-rna dna)
  (list->string
   (for/list ([letter dna])
     (hash-ref complement letter))))