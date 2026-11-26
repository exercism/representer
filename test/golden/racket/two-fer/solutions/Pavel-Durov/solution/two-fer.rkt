#lang racket

(provide two-fer)

(define (two-fer [name null])(
  if (null? name) "One for you, one for me."
  (string-append "One for " (string-append name ", one for me."))
))
