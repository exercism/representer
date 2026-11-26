(import (rnrs))

; given a square on a chessboard, how much rice?
(define (square n)
  (cond ((eq? n 1) 1)
        ((< n 1) (raise "too small!"))
        ((> n 64) (raise "too big!"))
        (else (expt 2 (- n 1)))))

; given a square, how much so far?
(define (squaretotal n)
  (cond ((eq? n 1) 1)
        (else (+ (square n) (squaretotal (- n 1))))))

; how much by the end?
(define total
  (squaretotal 64))