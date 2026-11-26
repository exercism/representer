#lang racket

(provide armstrong-number?)

(define (armstrong-number? n [count 0] [chars (string->list(number->string n))] [xsl (length (string->list(number->string n)))])
  (cond
    [(empty? chars) (= n count)] 
    [else (
      let ([expo (expt (- (char->integer (car chars)) 48) xsl)])
        (armstrong-number? n (+ count expo) (cdr chars))
    )]
  )
)