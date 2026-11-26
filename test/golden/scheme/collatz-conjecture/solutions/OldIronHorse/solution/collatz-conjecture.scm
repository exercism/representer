(import (rnrs))

(define (collatz n)
  (letrec ([collatz (lambda (n c)
                      (cond
                        ((= n 1) c)
                        ((even? n) (collatz (/ n 2) (1+ c)))
                        (else (collatz (1+ (* n 3)) (1+ c)))))])
    (collatz n 0)))

