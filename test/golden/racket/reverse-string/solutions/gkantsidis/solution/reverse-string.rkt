#lang racket
(provide my-reverse)

(define (my-reverse s)
  (define chars (string->list s))
  (define (next total remaining)
    (if (null? remaining)
        total
        (let ([head (car remaining)]
              [tail (cdr remaining)])
          (next (cons head total) tail))))

  (list->string (next '() chars)))
