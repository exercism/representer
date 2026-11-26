(import (rnrs))

(define (nucleotide-count dna)
  (define freq (list (cons #\A 0) (cons #\C 0) (cons #\G 0) (cons #\T 0)))
  (string-for-each
    (lambda (c)
      (define p (assv c freq))
      (if (pair? p)
        (set-cdr! p (+ (cdr p) 1))
        (error 'nucleotide-count "Invalid nucleotide" c)))
    dna)
  freq)

