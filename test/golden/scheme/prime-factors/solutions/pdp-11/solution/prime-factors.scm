(import (rnrs))

(define (factorize n)
  (let loop ([n n] [i 2] [r '()])
    (if (> i n) (reverse r)
        (if (zero? [modulo n i])
            (loop [/ n i] i [cons i r])
            (loop n (1+ i) r)))))