#lang racket

(provide armstrong-number?)

(define (armstrong-number? n)
   (let* ([digitos (map (lambda (c) (- (char->integer c) (char->integer #\0)))
                        (string->list (number->string n)))]
          [cantidad (length digitos)]
          [potencias (map (lambda (d) (expt d cantidad)) digitos)])
     (= (apply + potencias) n))
  )
