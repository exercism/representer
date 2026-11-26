#lang racket

(define (etl ht)
  (let ((ans (make-hash)))
    (for ([(k v) ht])
      (if (< k 0)
          (raise-argument-error 'etl "negative keys" ht)
          (for ([i v])
            (if (not (string? i))
                (raise-argument-error 'etl "list of non string values" ht)
                (hash-set! ans (string-downcase i) k)))))
    ans))
      
(provide etl)
