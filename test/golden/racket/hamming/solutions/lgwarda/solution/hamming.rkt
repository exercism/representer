#lang racket
(provide hamming-distance)

(define (hamming-distance str1 str2)
  (count (negate equal?)
         (string->list str1)
         (string->list str2)))