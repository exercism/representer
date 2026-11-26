(import (rnrs))

(define (factorize n)
  (let loop ([acc '()] [n n] [divisor 3])
    (cond
     [(> divisor n) (reverse acc)]
     [(= (mod n divisor) 0)
      (loop (cons divisor acc) (div n divisor) divisor)]
     [else
      (loop acc n (+ divisor 1))])))
