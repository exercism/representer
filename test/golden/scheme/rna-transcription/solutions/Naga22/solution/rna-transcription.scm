(import (rnrs))

(define (dna->rna dna)
  (dna->rna-iter dna ""))

(define (dna->rna-iter dna result) (if (= (string-length dna) 0) result (dna->rna-iter (substring dna 1 (string-length dna)) (string-append result (cond ((equal? (substring dna 0 1) "G") "C")
        ((equal? (substring dna 0 1) "C") "G")
        ((equal? (substring dna 0 1) "T") "A")
        ((equal? (substring dna 0 1) "A") "U")
        (else (substring dna 0 1)))))))