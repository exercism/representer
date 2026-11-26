#lang racket

(provide two-fer)

(define (two-fer . name)
  (if (empty? name)
      "One for you, one for me."
      (string-append "One for" " " (first name) "," " " "one for me." )))

