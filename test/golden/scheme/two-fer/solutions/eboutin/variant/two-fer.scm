(import (rnrs))

(define (two-fer . maybe-name)
  (format "One for ~a, pne for me."
          (cond ((equal? maybe-name '()) "you")
                (else (car maybe-name)))))
