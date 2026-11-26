#lang racket

(provide two-fer)

(define two-fer
  (case-lambda
    [()  "One for you, one for me."]
    [(name) (string-append "One for " name ", one for me.")]))
