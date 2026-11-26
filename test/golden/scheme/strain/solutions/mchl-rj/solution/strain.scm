(import (rnrs))

(define (keep pred seq)
  (filter pred seq))

(define (discard pred seq)
  (filter (lambda (x) (not (pred x))) seq))
