#lang racket

(provide rotate)


(define ALPHAMOD (- (char->integer #\Z) (char->integer #\A) -1))
(define LCA (char->integer #\a))
(define UCA (char->integer #\A))

(define (rot-char char amount base)
  (define offset (- (char->integer char) base))
  (define rotated (modulo (+ offset amount) ALPHAMOD))
  (integer->char (+ base rotated)))

(define (rotate text key)
  (list->string
   (for/list ([c text])
     (cond
      [(char-upper-case? c) (rot-char c key UCA)]
      [(char-lower-case? c) (rot-char c key LCA)]
      [else c]))))
