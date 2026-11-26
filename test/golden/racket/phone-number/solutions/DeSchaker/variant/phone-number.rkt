#lang racket

(provide nanp-clean)

(define (nanp-clean s)
  (let* ([s-digits  (filter char-numeric?  (string->list s))]
         [check-area (lambda (x) (not (and (equal? x #\0) (equal? x #\1))))])
  (cond [(and (equal? (length s-digits) 10) (check-area (car s-digits)) (check-area (fourth s-digits)) ) (list->string s-digits)]
        [(and (equal? (length s-digits) 11) (equal? (car s-digits) #\1) (check-area (second s-digits)) (check-area (fifth s-digits))) (list->string (rest s-digits))]
        [else (error "number not right")]
        )))
