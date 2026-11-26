(import (rnrs))

;; Number List-of-Number List-of-Number -> Number
(define (knapsack capacity weights values)
  (let* ((n (length weights))
         (wvec (list->vector weights))
         (vvec (list->vector values))
         (dp   (make-vector (+ capacity 1) 0)))
    ;; process each item i = 0 .. n-1
    (let loop ((i 0))
      (if (>= i n)
          (vector-ref dp capacity)   ; final answer
          (begin
            (let ((wi (vector-ref wvec i))
                  (vi (vector-ref vvec i)))
              ;; update dp[c] for c = capacity down to wi
              (do ((c capacity (- c 1)))
                  ((< c wi) #t) ; stop when c < weight
                (let* ((old (vector-ref dp c))
                       (cand (+ (vector-ref dp (- c wi)) vi)))
                  (if (> cand old)
                      (vector-set! dp c cand)))))
            (loop (+ i 1)))))))
