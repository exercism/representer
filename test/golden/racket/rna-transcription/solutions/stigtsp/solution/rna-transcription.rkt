#lang racket

(define dna-to-rna (hash
                    #\G "C"
                    #\C "G"
                    #\T "A"
                    #\A "U"))
(provide to-rna)

(define (to-rna dna)
  (string-join
   (map (lambda (c)
          (hash-ref dna-to-rna c))
          (string->list dna)) ""))
