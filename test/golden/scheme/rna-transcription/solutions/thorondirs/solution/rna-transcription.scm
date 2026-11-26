(import (rnrs))

(define (dna->rna dna)
  (list->string (map complement (string->list dna))))

(define (complement c)
  (cond
    [(eq? c '()) '()]
    [(eq? c #\G) #\C]
    [(eq? c #\C) #\G]
    [(eq? c #\A) #\U]
    [(eq? c #\T) #\A]
    [else 'error]))
