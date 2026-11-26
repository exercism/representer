(import (rnrs))


(define (translate-nucleotide nucleotide)
  (case nucleotide
    [( #\A) #\U]
    [( #\C) #\G]
    [( #\G) #\C]
    [( #\T) #\A]))

(define (dna->rna dna)
  (string-map translate-nucleotide dna))

