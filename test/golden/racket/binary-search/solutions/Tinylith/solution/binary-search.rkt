#lang racket

(provide binary-search)

(define (binary-search array value)
  (let loop ([left 0] [right (vector-length array)])
    (if (= right left)
        #f
        (let ([mid (+ left (quotient (- right left) 2))])
          (let ([mv (vector-ref array mid)])
            (cond
              [(< mv value) (loop (add1 left) right)]
              [(> mv value) (loop left (sub1 right))]
              [else mid]))))))
