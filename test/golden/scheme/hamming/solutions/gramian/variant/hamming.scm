(import (rnrs))

(define (hamming-distance strand-a strand-b)
    (let rho [(a (string->list strand-a))
              (b (string->list strand-b))
              (c 0)]
      (cond [(and (null? a) (null? b)) c]
            [(or (null? a) (null? b)) (error)]
            [else                     (if (and (null? a) (null? b)) c
                                                                   (rho (cdr a)
                                                                        (cdr b)
                                                                        (if (char=? (car a) (car b)) c (+ c 1))))])))
