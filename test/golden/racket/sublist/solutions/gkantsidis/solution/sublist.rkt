#lang racket

(provide sublist?)

(define (list/equal? lst1 lst2)
  (cond [(and (null? lst1) (null? lst2)) #t]
        [(or (null? lst1) (null? lst2)) #f]
        [else
         (let ([h1 (car lst1)]
               [r1 (cdr lst1)]
               [h2 (car lst2)]
               [r2 (cdr lst2)])
           (if (eqv? h1 h2)
               (list/equal? r1 r2)
               #f))]))

(define (starts-with? s l)
  ; (display (format "In starting with s:~A, l:~A ~%" s l))
  (cond [(null? s) #t]
        [(> (length s) (length l)) #f]
        [else (equal? s (take l (length s)))]))
;        [(eq? (car s) (car l)) (starts-with? (cdr s) (cdr l))]
;        [else #f]))

(define (is-sublist? s l)
  (define head (car s))
  (define candidate (member head l))
  ; (display (format "Candidate for ~A~%" head))
  (cond [(not candidate) #f]
        [(starts-with? s candidate) #t]
        [else (is-sublist? s (cdr candidate))]))

(define (sublist? s l)
  ; (display (format "Starting now~%"))
  (cond [(and (null? s) (null? l)) 'equal]
        [(null? s) 'sublist]
        [(null? l) 'superlist]
        [(= (length s) (length l))
         (if (list/equal? s l)
             'equal
             'unequal
             )]
        [else 
         (let* ([s-less-than-l? (< (length s) (length l))]
                [if-covered (if s-less-than-l? 'sublist 'superlist)]
                [smaller (if s-less-than-l? s l)]
                [larger (if s-less-than-l? l s)])
           (if (is-sublist? smaller larger)
               if-covered
               'unequal))]))

; slow:
; (starts-with? (range 100000) (range 1000000))
; (sublist? (range 1000000) (range 1 1000000))
; (sublist? (range 10) (range 1 10))
; (sublist? '(1 2 1 2 3) '(1 2 3 1 2 3 2 3 2 1))