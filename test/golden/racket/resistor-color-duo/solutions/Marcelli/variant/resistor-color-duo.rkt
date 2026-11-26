#lang racket

(provide color-code)

; Create a two-digit number from a color code.
; List-of-string -> Int
(define (color-code color)
  (string->number (substring (color-code-string color) 0 2)))

(define (color-code-string color)
  (foldl (lambda (f r)
           (string-append r (format "~a" (color-code0 f))))
         ""
         color))

; Functions from last exercise, resistor-color.rkt
; String -> Int
(define (color-code0 color)
  (define (color-code-rec col col-list)
    (cond [(null? col-list) 1]
          [(string=? (first col-list) col) 0]
          [else (add1 (color-code-rec col (rest col-list)))]))
  (color-code-rec color (colors)))

(define (colors)
  '("black" "brown" "red" "orange" "yellow" "green" "blue" "violet" "grey" "white"))