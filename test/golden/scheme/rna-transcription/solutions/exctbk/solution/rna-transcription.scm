(import (rnrs))

(define dna-bases '#(#\G #\C #\T #\A))
(define rna-bases '#(#\C #\G #\A #\U))

(define single-dna->rna
  (lambda (base)
    (let f ([i 0])
      (if (char=? (vector-ref dna-bases i) base)
             (vector-ref rna-bases i)
             (f (+ i 1))))))

(define dna->rna
  (lambda (dna-seq)
    (list->string (map single-dna->rna (string->list dna-seq)))))