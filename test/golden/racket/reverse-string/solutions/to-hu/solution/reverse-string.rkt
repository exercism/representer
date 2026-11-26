#lang racket
(provide my-reverse)

(define (my-reverse s)
  (if (= (string-length s) 0)
      ""
      ((compose list->string reverse string->list) s)))
