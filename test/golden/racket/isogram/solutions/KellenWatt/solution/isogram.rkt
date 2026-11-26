#lang racket

(provide isogram?)

(define (isogram? s [seen (set)])
  (if (non-empty-string? s)
    (let ([head (char-downcase (string-ref s 0))]
          [tail (substring s 1)])
      (if (char-alphabetic? head)
        (if (set-member? seen head) #f (isogram? tail (set-add seen head)))
        (isogram? tail seen)))
    #t))
