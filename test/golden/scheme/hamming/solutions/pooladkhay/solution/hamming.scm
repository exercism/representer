(import (rnrs))

(define (count-acc lst acc)
      (if (null? lst)
          acc
          (count-acc (cdr lst)(if (car lst) acc (+ acc 1)))))

(define (hamming-distance strand-a strand-b)
  (define a-list (string->list strand-a))
  (define b-list (string->list strand-b))
  
  (define res (map char=? a-list b-list))
  
  (when (= (length a-list) (length b-list))
    (count-acc res 0)))