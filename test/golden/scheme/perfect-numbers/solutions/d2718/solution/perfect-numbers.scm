(import (rnrs))

(define (fold op init seq)
    (if (null? seq)
        init
        (fold op (op init (car seq)) (cdr seq))))

(define (sum seq) (fold + 0 seq))

;; Recursive helper function for proper-divisors.
;; Call thus:
;;  (proper-divisors-aux number 2 (list 1))
;; number must be > 1.
(define (proper-divisors-aux number divisor accum)
    (cond
        ((> (* divisor divisor) number) accum)
        ((= (* divisor divisor) number) (cons divisor accum))
        ((= 0 (remainder number divisor))
            (proper-divisors-aux number (+ 1 divisor)
                (cons divisor (cons (quotient number divisor) accum))))
        (#t (proper-divisors-aux number (+ 1 divisor) accum))))

;; Return a list of proper divisors of number (if number > 1).
(define (proper-divisors number)
    (proper-divisors-aux number 2 (list 1)))

;; Classify n as 'deficient, 'abundant, or 'perfect.
(define (classify n)
    (cond
        ((< n 1) (error "must be a positive integer"))
        ((= n 1) 'deficient)
        (#t (let ((asum (sum (proper-divisors n))))
                (cond
                    ((< asum n) 'deficient)
                    ((> asum n) 'abundant)
                    (#t 'perfect))))))
