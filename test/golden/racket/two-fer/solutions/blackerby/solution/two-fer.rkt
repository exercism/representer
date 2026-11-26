#lang racket

(define (two-fer [name "you"])
  (format "One for ~a, one for me." name))

(provide two-fer)
