#lang racket

(provide pangram?)

(define (pangram? sentence)
  (= 27 
    (length 
      (remove-duplicates 
        (filter char-lower-case? (string->list (string-downcase sentence)))))))
