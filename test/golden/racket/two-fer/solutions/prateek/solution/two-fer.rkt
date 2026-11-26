#lang racket

(provide two-fer)

; (define (two-fer name)
;   (error "Not implemented yet"))

(define two-fer
  (case-lambda
    [(name) (string-append "One for " name ", one for me.")]
    [() (two-fer "you")]))

