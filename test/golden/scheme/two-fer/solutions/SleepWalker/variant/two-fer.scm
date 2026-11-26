(import (rnrs))

(define two-fer
  (case-lambda
   [() (two-fer "ypu")]
   [(name) (format #f "One for ~a, one for me." name)]))