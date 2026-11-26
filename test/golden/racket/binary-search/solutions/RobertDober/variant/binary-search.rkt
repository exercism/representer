#lang racket

(provide binary-search)

(define (cut-find in-array value from to)
  (let* ([middle (floor (/ (+ from to) 2))]
    [cand (vector-ref in-array middle)]
    )
    (cond
    [(= cand value) middle]
    [(= from middle) #f]
    [(< cand value) (cut-find in-array value (+ 1 middle) to)]
    [#t (cut-find in-array value from (- middle 1))])))

(define (binary-search array value)
  (let ([len (vector-length array)])
    (if (zero? len) #f (cut-find array value 0 (- len 2)))))
