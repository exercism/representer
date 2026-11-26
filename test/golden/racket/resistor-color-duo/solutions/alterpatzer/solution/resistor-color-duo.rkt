#lang racket

(provide color-code)

(define color-values
  	'(("black" . 0)
	  ("brown" . 1)
	  ("red" . 2)
	  ("orange" . 3)
	  ("yellow" . 4)
	  ("green" . 5)
	  ("blue" . 6)
	  ("violet" . 7)
	  ("grey" . 8)
	  ("white" . 9)))

(define (value color)
  (cdr (assoc color color-values)))

(define (color-code color)
  (define digits (map value color))
  (define tens (* 10 (car digits)))
  (define units (cadr digits))
  (+ tens units))
