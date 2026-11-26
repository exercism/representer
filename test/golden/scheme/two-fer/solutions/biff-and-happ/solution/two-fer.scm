(import (rnrs))

(define* (two-fer #:optional (name "you"))
  (format #f "One for ~a, one for me." name))
