#lang racket

(provide armstrong-number?)

(define (armstrong-number? n)
  (= n (sum-digits (digits n))))

(define (digits n)
  (define str (number->string n))
  (define len (string-length str))
  (define (iter counter result)
    (if (= counter len)
        result
        (iter (+ counter 1) (append result (list (string (string-ref str counter)))))))
  (map string->number (iter 0 empty)))

(define (sum-digits number)
  (define len (length number))
  (define (rec items)
    (if (empty? items)
        0
        (+ (expt (first items) len)
           (rec (rest items)))))
  (rec number))