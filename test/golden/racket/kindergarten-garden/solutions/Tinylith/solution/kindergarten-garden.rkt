#lang racket

(provide plants)

(define ord-A (char->integer #\A))

(define (char->plant ch)
  (case ch
    [(#\C) "clover"]
    [(#\G) "grass"]
    [(#\R) "radishes"]
    [(#\V) "violets"]))

(define (name->indexes name class-size)
  (define idx (* 2 (- (char->integer (string-ref name 0)) ord-A)))
  (define shift (add1 (* class-size 2)))
  (list idx (add1 idx) (+ shift idx) (+ 1 shift idx)))

(define (plants diagram student)
  (define class-size (quotient (string-length diagram) 4))
  (map (λ (idx) (char->plant (string-ref diagram idx))) (name->indexes student class-size)))
