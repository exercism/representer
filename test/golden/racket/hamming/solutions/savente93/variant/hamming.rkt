#lang racket

(provide hamming-distance)

(define (hamming-distance source target)
  (if (not (equal? (string-length source) (string-length target))) 
      (error "strings should bf of equal length")
      (length 
              (filter (lambda(x) (not (char=? (car x) (cadr x)))) 
                      (map list 
                           (string->list source) 
                           (string->list target)
                           )
                      )
       )
      )
  )
