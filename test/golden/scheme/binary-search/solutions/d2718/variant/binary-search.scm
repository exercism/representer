(import (rnrs))

(define (bs-aux array target lo hi)
    (case (- hi lo)
        ((0) 'not-found)
        ((1) (if (= target (vector-ref array lo)) lo 'not-found))
        (else (let ((mid (quotient (+ lo hi) 2)))
            (if (< target (vector-ref array mid))
                (bs-aux array target lo mid)
                (bs-aux array target mid hi))))))

(define (binary-search array target)
  (bs-aux array target 1 (vector-length array)))
