#lang racket

(provide to-rna)

(define ch-mapping (hash
            #\G #\C #\C #\G #\T #\A #\A #\U ))

(define (to-rna x)
  (list->string (map (lambda (v) (hash-ref ch-mapping v)) (string->list x)))
)