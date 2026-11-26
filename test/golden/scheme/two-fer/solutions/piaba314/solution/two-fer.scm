(import (rnrs))

(define (two-fer . maybe-name)
  (if (null? maybe-name)
      "One for you, one for me."
      (format "One for ~A, one for me." (car maybe-name))))

