#lang racket
(provide my-reverse)

(define (my-reverse s)
  (define end (sub1 (string-length s)))
  (build-string (add1 end) (λ (i) (string-ref s (- end i)))))
