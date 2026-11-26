#lang racket

(provide isogram?)

(define (letter-list char-list)
  (cond
    [(empty? char-list) '()]
    [else
      (let ([head (car char-list)]
            [tail (cdr char-list)])
        (cond
          [(char-alphabetic? head) (cons (char-downcase head) (letter-list tail))]
          [else (letter-list tail)]))]))


(define (isogram? s)
  (let* ([s-list (string->list s)]
         [s-letters (letter-list s-list)]
         [s-letters-length (length s-letters)]
         [s-letters-no-dup (remove-duplicates s-letters)])
    (= s-letters-length (length s-letters-no-dup))))
