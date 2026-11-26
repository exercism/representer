(import (rnrs))

(define (to-decimal s)
  (let ([zero (char->integer #\0)]
        [cs (string->list s)])
    (if (for-all (lambda (c) (or (char>=? c #\0) (char<? c #\8))) cs)
      (fold-left
        (lambda (acc d) (+ d (* acc 8)))
        0
        (map (lambda (c) (- (char->integer c) zero)) cs))
      0)))
