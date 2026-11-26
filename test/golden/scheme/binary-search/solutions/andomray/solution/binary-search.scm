(import (rnrs))

(define (find-guess-ref start end)
  (floor (/ (+ start end) 2)))

(define (do-binary-search array target start end)
  (if (> start end)
      'not-found
      (let* [(guess-ref (find-guess-ref start end))
             (elem (vector-ref array guess-ref))]
        (cond
         [(= elem target) guess-ref]
         [(< elem target) (do-binary-search array target (1+ guess-ref) end)]
         [(> elem target) (do-binary-search array target start (1- guess-ref))]))))

(define (binary-search array target)
  (cond
   [(= (vector-length array) 0) 'not-found]
   [else (do-binary-search array target 0 (1- (vector-length array)))]))
