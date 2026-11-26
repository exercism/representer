(import (rnrs))

(define (abc bcd)
 (case bcd
   ((#\C) #\G)
   ((#\G) #\C)
   ((#\T) #\A)
   ((#\A) #\U)))

(define (dna->rna dna)
  (list->string (filter abc (string->list dna))))
