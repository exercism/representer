#lang racket

(provide two-fer)

;; String or Void -> String
; Given a name, return a string with the message: One for X, one for me.
; if the name is missing, return the string: One for you, one for me.
(define (two-fer [name "you"])
  (string-append "One for " name ", one for me."))