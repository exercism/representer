#lang racket
;(non-empty-string? x)
(provide two-fer)


; [name ""] creates default value if no arg given
(define (two-fer [name ""])
        ; check if string is empty & 
        (if (non-empty-string?  name) 
            ; use ~a to build a string 
            (~a "One for " name ", one for me." )  "One for you, one for me."))


; Second not so good version
;(define (two-fer [name 0])
;        (if (string? name) (~a "One for " name ", one for me." ) "One for you, one for me."))