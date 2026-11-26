#lang racket

(provide acronym)

(define (acronym input)
  (define chars (string->list input))
  (define (search initials searching? remaining)
    (if (null? remaining)
        initials
        (let ([head (car remaining)]
              [tail (cdr remaining)])
          (if searching?
              (if (char-alphabetic? head)
                  (search (append initials (list head)) #f tail)
                  (search initials #t tail))
              (if (or (eq? head #\space)
                      (eq? head #\-))
                  (search initials #t tail)
                  (search initials #f tail))))))

  (list->string
   (map char-upcase (search '() #t chars))))

(acronym "Portable Network Graphics")
