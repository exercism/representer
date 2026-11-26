#lang racket

(provide armstrong-number?)

(define (armstrong-number? n)
  (= n
     (let* ([digits (number->digits n)]
            [digits-num (length digits)])
       (foldl (lambda (d acc) (+ acc (expt d digits-num)))
              0
              digits))))

(define (number->digits n)
  (let loop ([q n]
             [digits (list)])
    (if (zero? q)
        digits
        (loop (quotient q 10) (cons (remainder q 10) digits)))))
