#lang racket

(provide (contract-out 
  [isogram? (-> string? boolean?)]))

(define (isogram? s)
  (let ([s-list (filter char-alphabetic?
                       (string->list (string-downcase s)))])
    (= (length s-list) 
       (set-count (list->set s-list)))))
