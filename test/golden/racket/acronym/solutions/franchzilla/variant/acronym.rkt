#lang racket

(provide acronym)

(define (acronym string)
  (list->string
   (filter char-upcase
               (map car
                    (map string->list
                         (string-split string #px"[ _-]+"))))))
