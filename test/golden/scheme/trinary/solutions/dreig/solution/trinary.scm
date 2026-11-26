(import (rnrs))

(define (to-decimal s)
  (call/cc
    (lambda (return)
      (fold-left
        (lambda (acc d) (+ (* 3 acc) d))
        0
        (map (lambda (ch)
               (case ch
                 [(#\0) 0]
                 [(#\1) 1]
                 [(#\2) 2]
                 [else (return 0)]))
             (string->list s))))))
