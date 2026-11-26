#lang racket

(provide two-fer)

; Using rest arguments
; (define (two-fer . names)
; 	(if (null? names)
; 		"One for you, one for me."
; 		(string-append "One for " (first names) ", one for me.")))

; Using default value (less line but work only because it's exaclty same sentence)
(define (two-fer [name "you"])
	(string-append "One for " name ", one for me."))