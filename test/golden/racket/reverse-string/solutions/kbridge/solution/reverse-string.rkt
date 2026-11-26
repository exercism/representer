#lang racket
(provide my-reverse)

(define (my-reverse s)
  (let* ([n (string-length s)]
         [n1 (sub1 n)])
    (build-string n (lambda (i) (string-ref s (- n1 i))))))
