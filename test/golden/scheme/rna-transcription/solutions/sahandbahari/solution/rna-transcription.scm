(import (rnrs))

(define (nucleotid-complement nucleotid)
  (cond
   ((char=? nucleotid #\C) #\G)
   ((char=? nucleotid #\G) #\C)
   ((char=? nucleotid #\T) #\A)
   ((char=? nucleotid #\A) #\U)))

(define (dna->rna dna)
  (list->string
   (map nucleotid-complement
        (string->list dna))))

