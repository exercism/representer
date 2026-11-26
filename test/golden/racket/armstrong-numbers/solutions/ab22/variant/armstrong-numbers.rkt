#lang racket

(provide armstrong-number?)

; (define (digits n)
;   (if (= (quotient n 10) 0) (list n)
;       (cons (remainder n 10)
;             (digits (quotient n 10)))))
(define (digits n)
  (define n-string (number->string n))
  (define digits-string (regexp-match* #px"[[:digit:]]" n-string))
  (filter string->number digits-string)
  )

(define (armstrong-number? n)
  (define digits-of-n (digits n))
  (define number-of-digits (length digits-of-n))

  (define digits-raised-to-power
    (for/list [(x digits-of-n)] ; clearer than using map and lambda
      (expt x number-of-digits))
    )

  (define sum-powers (apply + digits-raised-to-power))
  (= sum-powers n)
  )
