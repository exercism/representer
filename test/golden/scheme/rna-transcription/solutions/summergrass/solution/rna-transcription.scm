(import (rnrs))

(define (dna_letter->rna_letter letter)
    (cond 
        ((char=? letter #\G) #\C)
        ((char=? letter #\C) #\G)
        ((char=? letter #\T) #\A)
        ((char=? letter #\A) #\U)))

(define (dna->rna dna)
    (list->string 
        (map dna_letter->rna_letter (string->list dna))))