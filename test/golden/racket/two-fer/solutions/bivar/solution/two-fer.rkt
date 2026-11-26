#lang racket

(provide two-fer)

(define (two-fer (name "you")) ;;if name is empty, it'll be read as you
     (format "One for ~a, one for me." name))
