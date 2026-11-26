(import (rnrs))

;
; array is vector type
;
(define (binary-search array target)
  (if (= 0 (vector-length array))
      'not-found
      (binary-search-0 array target 0 (- (vector-length array) 1))))

;
; Search target between i j indexes
;
(define (binary-search-0 array target i j)
  (let ([middle (quotient (+ i j) 2)])
    (let ([element (vector-ref array middle)])
      (cond
        ((eqv? element target) middle)
        ((>= i j) 'not-found)
        ((> target element) (binary-search-0 array target (+ middle 1) j))
        (else  (binary-search-0 array target i (- middle 1)))))))
